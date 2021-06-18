FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app
# copy csproj and restore as distinct layers
COPY *.sln .
COPY ./*.csproj ./SampleAppFr4.5/
COPY ./*.config ./SampleAppFr4.5/
RUN nuget restore
# copy everything else and build app
COPY ./. ./SampleAppFr4.5/
WORKDIR /app/SampleAppFr4.5
RUN msbuild /p:Configuration=Release
# copy build artifacts into runtime image
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8
WORKDIR /inetpub/wwwroot
COPY --chown=1000 --from=build ./app/SampleAppFr4.5/. ./
