{
  description = "Tim's postgres image";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
  };

  outputs = { self, nixpkgs }: 
    with import nixpkgs { system = "x86_64-linux"; };
    rec {

      extension = stdenv.mkDerivation rec {
        pname = "pgsql-http";
        version = "v1.5.0";
        src = pkgs.fetchurl {
          url = "https://github.com/pramsey/${pname}/archive/refs/tags/${version}.tar.gz";
        };
        buildInputs = [ curl postgresql_14 clang ];
      };

      image = dockerTools.buildImage {
        name = "timdw-postgres";
        fromImage = dockerTools.pullImage {
          imageName = "flyio/postgres:14";
          imageDigest = "sha256-fa1816c5a6a012ff243a2bc1664fc05cdf0acebe1759d14c7d02f364f43a4f0c";
          sha256      = "";
        };
        created = self.lastModifiedDate;
        contents = [
          extension
        ];
      };

    };
}

# FROM flyio/postgres:14

# RUN apt-get install -y make gcc g++ clang llvm libcurl4-openssl-dev postgresql-server-dev-14

# ARG pgsql_http_version=v1.5.0
# WORKDIR /tmp/pgsql-http/${pgsql_http_version}
# RUN curl -sL https://github.com/pramsey/pgsql-http/archive/refs/tags/${pgsql_http_version}.tar.gz | tar xvz --strip-components=1
# RUN make
# RUN make install

