{
    description = "LLaMA inference flake";

    inputs.nixpkgs.url = "github:NixOS/nixpkgs";
    inputs.flake-utils.url = "github:numtide/flake-utils";

    outputs = { self, nixpkgs, flake-utils }:
        flake-utils.lib.eachDefaultSystem
            (system:
                let

                    pkgs = nixpkgs.legacyPackages.${system};
                    python_pkgs = ps: with ps; [
                        fairscale
                        fire
                        sentencepiece
                        torch
                    ];

                in {

                    devShells.fhs = (pkgs.buildFHSUserEnv {
                        name = "LLaMA Inference Python Dev Shell";
                        targetPkgs = pkgs: (with pkgs; [
                            (python311.withPackages python_pkgs)
                            wget
                        ]);
                        runScript = "$SHELL";
                    }).env;


                    devShells.std = pkgs.mkShell {
                        name = "LLaMA Inference Python Dev Shell";
                        buildInputs = with pkgs; [
                            (python311.withPackages python_pkgs)
                            wget
                        ];
                    };

                    devShells.default = pkgs.mkShell {
                        shellHook = ''
                            echo "This default shell doesn't do anything. Try running 'nix develop .#fhs' or 'nix develop .#std'"
                        '';
                    };
                }

            );
}
