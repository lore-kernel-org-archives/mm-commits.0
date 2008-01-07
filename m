From: akpm@linux-foundation.org
Subject: - kconfig-use-getopt-in-confc-for-handling-command-line.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:36 -0800
Message-ID: <200801072139.m07LdGGj013553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbYAGVnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:43:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig: use getopt() in conf.c for handling command line arguments
has been removed from the -mm tree.  Its filename was
     kconfig-use-getopt-in-confc-for-handling-command-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig: use getopt() in conf.c for handling command line arguments
From: Andres Salomon <dilinger@queued.net>

First, rename ac/av to argc/argv; those are pretty conventional names.

Second, switch from doing our own parsing of command line arguments to
using getopt(3) to do it.  Aside from simplifying things, this allows us to
specify multiple arguments; the old code could only accept two arguments
(input_mode and kconfig name).

Note some subtle changes:
 - The argument '-?' is no longer supported.
 - '-h' is not treated as an error, so output goes to stdout, and we
   exit with '0'.
 - There is no compatibility checking amongst arguments; the last option
   will simply override earlier options.  For example, 'conf -n -y foo'
   is perfectly valid now (input_mode will be set_yes).  Previously, that
   would have been an error ("can't find file -y").

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/conf.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN scripts/kconfig/conf.c~kconfig-use-getopt-in-confc-for-handling-command-line scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c~kconfig-use-getopt-in-confc-for-handling-command-line
+++ a/scripts/kconfig/conf.c
@@ -493,14 +493,14 @@ static void check_conf(struct menu *menu
 		check_conf(child);
 }
 
-int main(int ac, char **av)
+int main(int argc, char **argv)
 {
-	int i = 1;
+	int opt;
 	const char *name;
 	struct stat tmpstat;
 
-	if (ac > i && av[i][0] == '-') {
-		switch (av[i++][1]) {
+	while ((opt = getopt(argc, argv, "osdD:nmyrh")) != -1) {
+		switch (opt) {
 		case 'o':
 			input_mode = ask_new;
 			break;
@@ -513,12 +513,7 @@ int main(int ac, char **av)
 			break;
 		case 'D':
 			input_mode = set_default;
-			defconfig_file = av[i++];
-			if (!defconfig_file) {
-				printf(_("%s: No default config file specified\n"),
-					av[0]);
-				exit(1);
-			}
+			defconfig_file = optarg;
 			break;
 		case 'n':
 			input_mode = set_no;
@@ -534,16 +529,19 @@ int main(int ac, char **av)
 			srandom(time(NULL));
 			break;
 		case 'h':
-		case '?':
-			fprintf(stderr, "See README for usage info\n");
+			printf("See README for usage info\n");
 			exit(0);
+			break;
+		default:
+			fprintf(stderr, "See README for usage info\n");
+			exit(1);
 		}
 	}
-  	name = av[i];
-	if (!name) {
-		printf(_("%s: Kconfig file missing\n"), av[0]);
+	if (argc == optind) {
+		printf(_("%s: Kconfig file missing\n"), argv[0]);
 		exit(1);
 	}
+	name = argv[optind];
 	conf_parse(name);
 	//zconfdump(stdout);
 	switch (input_mode) {
_

Patches currently in -mm which might be from dilinger@queued.net are

git-battery.patch
git-x86.patch
kernel-printkc-concerns-about-the-console-handover.patch
