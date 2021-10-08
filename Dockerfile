FROM node:16-alpine AS BUILDER

WORKDIR /tmp

COPY ./src          ./src
COPY ./package.json ./package.json
COPY tsconfig.json  ./
COPY yarn.lock      ./

RUN apk add --no-cache \
        sudo \
        curl \
        build-base \
        g++ \
        libpng \
        libpng-dev \
        jpeg-dev \
        pango-dev \
        cairo-dev \
        giflib-dev \
        py-pip

RUN yarn install
RUN yarn tsc

FROM node:16-alpine

ENV LOG_LEVEL=INFO

WORKDIR /app

COPY --from=BUILDER /tmp/dist ./dist
COPY --from=BUILDER /tmp/node_modules ./node_modules

CMD ["node", "dist/App.js"]
