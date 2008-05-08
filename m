From: akpm@linux-foundation.org
Subject: + revert-git-kbuild.patch added to -mm tree
Date: Thu, 08 May 2008 14:14:13 -0700
Message-ID: <200805082125.m48LP9oA006562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756755AbYEHVZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 17:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, sam@ravnborg.org


The patch titled
     revert git-kbuild
has been added to the -mm tree.  Its filename is
     revert-git-kbuild.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert git-kbuild
From: Andrew Morton <akpm@linux-foundation.org>

allnoconfig gets a segfauklt

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                            |    2 
 README                              |    8 
 scripts/kconfig/.gitignore          |    1 
 scripts/kconfig/Makefile            |   76 ++----
 scripts/kconfig/aconf.c             |  325 --------------------------
 scripts/kconfig/conf.c              |  168 ++++++++++++-
 scripts/kconfig/lex.zconf.c_shipped |   16 -
 scripts/kconfig/zconf.l             |   16 -
 8 files changed, 206 insertions(+), 406 deletions(-)

diff -puN Makefile~revert-git-kbuild Makefile
--- a/Makefile~revert-git-kbuild
+++ a/Makefile
@@ -473,7 +473,7 @@ $(KCONFIG_CONFIG) include/config/auto.co
 # if auto.conf.cmd is missing then we are probably in a cleaned tree so
 # we execute the config step to be sure to catch updated Kconfig files
 include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
-	$(Q)$(MAKE) -f $(srctree)/Makefile oldconfig
+	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
 else
 # external modules needs include/linux/autoconf.h and include/config/auto.conf
 # but do not care if they are up-to-date. Use auto.conf to trigger the test
diff -puN README~revert-git-kbuild README
--- a/README~revert-git-kbuild
+++ a/README
@@ -171,9 +171,11 @@ CONFIGURING the kernel:
 	"make oldconfig"   Default all questions based on the contents of
 			   your existing ./.config file and asking about
 			   new config symbols.
-	"make defconfig"   Create a ./.config file by using the base
-			   configuration found in the file specified by
-			   the environment variable KBUILD_DEFCONFIG.
+	"make silentoldconfig"
+			   Like above, but avoids cluttering the screen
+			   with questions already answered.
+	"make defconfig"   Create a ./.config file by using the default
+			   symbol values from arch/$ARCH/defconfig.
 	"make allyesconfig"
 			   Create a ./.config file by setting symbol
 			   values to 'y' as much as possible.
diff -puN scripts/kconfig/.gitignore~revert-git-kbuild scripts/kconfig/.gitignore
--- a/scripts/kconfig/.gitignore~revert-git-kbuild
+++ a/scripts/kconfig/.gitignore
@@ -13,7 +13,6 @@ lkc_defs.h
 # configuration programs
 #
 conf
-aconf
 mconf
 qconf
 gconf
diff -puN scripts/kconfig/Makefile~revert-git-kbuild scripts/kconfig/Makefile
--- a/scripts/kconfig/Makefile~revert-git-kbuild
+++ a/scripts/kconfig/Makefile
@@ -18,9 +18,12 @@ menuconfig: $(obj)/mconf
 config: $(obj)/conf
 	$< $(Kconfig)
 
-oldconfig silentoldconfig: $(obj)/conf
+oldconfig: $(obj)/conf
 	$< -o $(Kconfig)
 
+silentoldconfig: $(obj)/conf
+	$< -s $(Kconfig)
+
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
@@ -44,38 +47,30 @@ update-po-config: $(obj)/kxgettext $(obj
 	$(Q)rm -f arch/um/Kconfig.arch
 	$(Q)rm -f $(obj)/config.pot
 
-#####
-#
-# aconf support
-#
-aconf-targets := allnoconfig allyesconfig allmodconfig alldefconfig randconfig
-PHONY += $(aconf-targets) defconfig
-
-# Optional base file for aconf
-# K= have precedence over KCONFIG_ALLCONFIG
-aconf-file := $(if $(KCONFIG_ALLCONFIG),-b $(KCONFIG_ALLCONFIG))
-aconf-file := $(if $(K),-b $(K), $(aconf-file))
-$(aconf-targets): $(obj)/aconf
-	$< $@ $(aconf-file) $(Kconfig)
-
-# Targets named *_defconfig may be located in arch/.../configs/
-# but try current dir first and always fallback to current dir
-archdef = $(srctree)/arch/$(SRCARCH)/configs/$@
-aconf-archdef = \
-$(if $(wildcard $(archdef)), $(if $(wildcard $@),$@,$(archdef)),$@)
-%_defconfig: $(obj)/aconf
-	$< alldefconfig -b $(aconf-archdef) $(Kconfig)
-
-# An arch may use KBUILD_DEFCONFIG to specify defconfig file
-# fallback to arch/$ARCH/defconfig
-defconfig-file := $(if $(KBUILD_DEFCONFIG),                       \
-        $(srctree)/arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG),   \
-        $(srctree)/arch/$(SRCARCH)/defconfig)
-defconfig-file := $(strip $(defconfig-file))
+PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig
+
+randconfig: $(obj)/conf
+	$< -r $(Kconfig)
 
-defconfig: $(obj)/aconf
-	$< alldefconfig -b $(defconfig-file) $(Kconfig)
+allyesconfig: $(obj)/conf
+	$< -y $(Kconfig)
+
+allnoconfig: $(obj)/conf
+	$< -n $(Kconfig)
+
+allmodconfig: $(obj)/conf
+	$< -m $(Kconfig)
+
+defconfig: $(obj)/conf
+ifeq ($(KBUILD_DEFCONFIG),)
+	$< -d $(Kconfig)
+else
+	@echo "*** Default configuration is based on '$(KBUILD_DEFCONFIG)'"
+	$(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
+endif
 
+%_defconfig: $(obj)/conf
+	$(Q)$< -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
 
 # Help text used by make help
 help:
@@ -83,14 +78,13 @@ help:
 	@echo  '  menuconfig	  - Update current config utilising a menu based program'
 	@echo  '  xconfig	  - Update current config utilising a QT based front-end'
 	@echo  '  gconfig	  - Update current config utilising a GTK based front-end'
-	@echo  '  oldconfig	  - Update current config utilising .config as base'
-	@echo  '  defconfig	  - New config based on arch specific base configuration'
-	@echo  '  randconfig	  - New config with random values for all symbols'
-	@echo  '  allnoconfig	  - New config where all values are set to no'
-	@echo  '  allyesconfig	  - New config where all values are set to yes'
-	@echo  '  allmodconfig	  - New config where all values are set to module'
-	@echo  '  alldefconfig	  - New config where all values has their default value'
-	@echo  '  For randconfig and all*config targets use K=file to specify a base configuration'
+	@echo  '  oldconfig	  - Update current config utilising a provided .config as base'
+	@echo  '  silentoldconfig - Same as oldconfig, but quietly'
+	@echo  '  randconfig	  - New config with random answer to all options'
+	@echo  '  defconfig	  - New config with default answer to all options'
+	@echo  '  allmodconfig	  - New config selecting modules when possible'
+	@echo  '  allyesconfig	  - New config where all options are accepted with yes'
+	@echo  '  allnoconfig	  - New config where all options are answered with no'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
@@ -106,7 +100,6 @@ HOST_EXTRACFLAGS += -DLOCALE
 # ===========================================================================
 # Shared Makefile for the various kconfig executables:
 # conf:	  Used for defconfig, oldconfig and related targets
-# aconf:  Generate simple configurations (all*config, etc)
 # mconf:  Used for the mconfig target.
 #         Utilizes the lxdialog package
 # qconf:  Used for the xconfig target
@@ -119,11 +112,10 @@ lxdialog := lxdialog/checklist.o lxdialo
 lxdialog += lxdialog/textbox.o lxdialog/yesno.o lxdialog/menubox.o
 
 conf-objs	:= conf.o  zconf.tab.o
-aconf-objs	:= aconf.o zconf.tab.o
 mconf-objs	:= mconf.o zconf.tab.o $(lxdialog)
 kxgettext-objs	:= kxgettext.o zconf.tab.o
 
-hostprogs-y := conf aconf qconf gconf kxgettext
+hostprogs-y := conf qconf gconf kxgettext
 
 ifeq ($(MAKECMDGOALS),menuconfig)
 	hostprogs-y += mconf
diff -puN scripts/kconfig/aconf.c~revert-git-kbuild /dev/null
--- a/scripts/kconfig/aconf.c
+++ /dev/null
@@ -1,325 +0,0 @@
-/*
- * Copyright (C) 2002 Roman Zippel <zippel@linux-m68k.org>
- * Copyright (C) 2008 Sam Ravnborg <sam@ravnborg.org>
- * Released under the terms of the GNU GPL v2.0.
- */
-
-/*
- * Generate the automated configs
- */
-
-#include <locale.h>
-#include <ctype.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <time.h>
-#include <unistd.h>
-#include <sys/stat.h>
-
-#define LKC_DIRECT_LINK
-#include "lkc.h"
-
-static void check_conf(struct menu *menu);
-static void conf(struct menu *menu);
-
-enum {
-	set_default,
-	set_yes,
-	set_mod,
-	set_no,
-	set_random
-} default_value;
-
-
-static int conf_cnt;
-static struct menu *rootEntry;
-
-/* Set strig value - it this a nop as it looks like? */
-static void conf_string(struct menu *menu)
-{
-	struct symbol *sym = menu->sym;
-	const char *def;
-
-
-	if (!sym_is_changable(sym))
-		return;
-
-	if (sym_has_value(sym) && (default_value != set_default))
-		return;
-
-	def = sym_get_string_value(sym);
-	if (def)
-		sym_set_string_value(sym, def);
-}
-
-static void conf_sym(struct menu *menu)
-{
-	struct symbol *sym = menu->sym;
-	int type;
-	tristate val;
-
-	if (!sym_is_changable(sym))
-		return;
-
-	if (sym_has_value(sym) && (default_value != set_default))
-		return;
-
-	type = sym_get_type(sym);
-	switch (default_value) {
-	case set_yes:
-		if (sym_tristate_within_range(sym, yes)) {
-			sym_set_tristate_value(sym, yes);
-			break;
-		}
-	/* fallthrough */
-	case set_mod:
-		if (type == S_TRISTATE) {
-			if (sym_tristate_within_range(sym, mod)) {
-				sym_set_tristate_value(sym, mod);
-				break;
-			}
-		} else if (sym_tristate_within_range(sym, yes)) {
-			sym_set_tristate_value(sym, yes);
-			break;
-		}
-	/* fallthrough */
-	case set_no:
-		if (sym_tristate_within_range(sym, no)) {
-			sym_set_tristate_value(sym, no);
-			break;
-		}
-	/* fallthrough */
-	case set_random:
-		 do {
-			val = (tristate)(rand() % 3);
-		} while (!sym_tristate_within_range(sym, val));
-		switch (val) {
-		case no:  sym_set_tristate_value(sym, no); break;
-		case mod: sym_set_tristate_value(sym, mod); break;
-		case yes: sym_set_tristate_value(sym, yes); break;
-		}
-		break;
-	case set_default:
-		sym_set_tristate_value(sym, sym_get_tristate_value(sym));
-		break;
-	}
-}
-
-static void conf_choice(struct menu *menu)
-{
-	struct symbol *sym, *def_sym;
-	struct menu *child;
-	int type;
-	bool is_new;
-	int cnt, def;
-
-	sym = menu->sym;
-	type = sym_get_type(sym);
-	is_new = !sym_has_value(sym);
-	if (sym_is_changable(sym)) {
-		conf_sym(menu);
-		sym_calc_value(sym);
-	}
-	if (sym_get_tristate_value(sym) != yes)
-		return;
-	def_sym = sym_get_choice_value(sym);
-	cnt = def = 0;
-	for (child = menu->list; child; child = child->next) {
-		if (!child->sym || !menu_is_visible(child))
-			continue;
-		cnt++;
-		if (child->sym == def_sym)
-			def = cnt;
-	}
-	if (cnt == 1)
-		goto conf_childs;
-
-	switch (default_value) {
-	case set_random:
-		if (is_new)
-			def = (rand() % cnt) + 1;
-	/* fallthrough */
-	case set_default:
-	case set_yes:
-	case set_mod:
-	case set_no:
-		cnt = def;
-		break;
-	}
-
-conf_childs:
-	for (child = menu->list; child; child = child->next) {
-		if (!child->sym || !menu_is_visible(child))
-			continue;
-		if (!--cnt)
-			break;
-	}
-	sym_set_choice_value(sym, child->sym);
-	for (child = child->list; child; child = child->next)
-		conf(child);
-}
-
-
-static void conf(struct menu *menu)
-{
-	struct symbol *sym;
-	struct property *prop;
-	struct menu *child;
-
-	if (!menu_is_visible(menu))
-		return;
-
-	sym = menu->sym;
-	prop = menu->prompt;
-	if (prop && prop->type == P_MENU) {
-		if (menu != rootEntry) {
-			check_conf(menu);
-			return;
-		}
-	}
-
-	if (!sym)
-		goto conf_childs;
-
-	if (sym_is_choice(sym)) {
-		conf_choice(menu);
-		if (sym->curr.tri != mod)
-			return;
-		goto conf_childs;
-	}
-
-	switch (sym->type) {
-	case S_INT:
-	case S_HEX:
-	case S_STRING:
-		conf_string(menu);
-		break;
-	default:
-		conf_sym(menu);
-		break;
-	}
-
-conf_childs:
-	for (child = menu->list; child; child = child->next)
-		conf(child);
-}
-
-static void check_conf(struct menu *menu)
-{
-	struct symbol *sym;
-	struct menu *child;
-
-	if (!menu_is_visible(menu))
-		return;
-
-	sym = menu->sym;
-	if (sym && !sym_has_value(sym)) {
-		if (sym_is_changable(sym) ||
-		    (sym_is_choice(sym) &&
-		     sym_get_tristate_value(sym) == yes)) {
-			conf_cnt++;
-			rootEntry = menu_get_parent_menu(menu);
-			conf(rootEntry);
-		}
-	}
-
-	for (child = menu->list; child; child = child->next)
-		check_conf(child);
-}
-
-static void usage(void)
-{
-	printf(_("usage: aconf COMMAND [-b config_file] Kconfig\n"));
-	printf("\n");
-	printf(_("The supported commands are:\n"));
-	printf(_("   allnoconfig  set as many values as possible to 'n'\n"));
-	printf(_("   allyesconfig set as many values as possible to 'y'\n"));
-	printf(_("   allmodconfig set as many values as possible to 'm'\n"));
-	printf(_("   alldefconfig set all vaues to their default value\n"));
-	printf(_("   randconfig   select a random value for all value\n"));
-	printf("\n");
-	printf(_("   -b file      optional base configuration\n"));
-	printf(_("   Kconfig      the kconfig configuration\n"));
-	printf("\n");
-	printf(_("   Output is stored in .config (if not overridden by KCONFIG_CONFIG)\n"));
-	printf("\n");
-}
-
-int main(int ac, char **av)
-{
-	char *config_filename;
-	char *config_file = NULL;
-	char *kconfig_file = NULL;
-	struct stat tmpstat;
-
-	setlocale(LC_ALL, "");
-	bindtextdomain(PACKAGE, LOCALEDIR);
-	textdomain(PACKAGE);
-
-	if (ac < 2) {
-		usage();
-		exit(1);
-	}
-	if (strcmp(av[1], "allnoconfig") == 0)
-		default_value = set_no;
-	else if (strcmp(av[1], "allyesconfig") == 0)
-		default_value = set_yes;
-	else if (strcmp(av[1], "allmodconfig") == 0)
-		default_value = set_mod;
-	else if (strcmp(av[1], "alldefconfig") == 0)
-		default_value = set_default;
-	else if (strcmp(av[1], "randconfig") == 0) {
-		default_value = set_random;
-		srand(time(NULL));
-	} else {
-		usage();
-		exit(1);
-	}
-	if (strcmp(av[2], "-b") == 0) {
-		config_file = av[3];
-		kconfig_file = av[4];
-	} else {
-		kconfig_file = av[2];
-	}
-	if (!kconfig_file) {
-		fprintf(stderr, _("%s: Kconfig file missing\n"), av[0]);
-		exit(1);
-	}
-	conf_parse(kconfig_file);
-	/* debug: zconfdump(stdout); */
-	if (strcmp(config_file, "-")) {
-		if (config_file && stat(config_file, &tmpstat)) {
-			fprintf(stderr, _("%s: failed to open %s\n"),
-			        av[0], config_file);
-			exit(1);
-		}
-		config_filename = config_file;
-	} else {
-		config_filename = "stdin";
-	}
-
-	if (config_file && conf_read_simple(config_file, S_DEF_USER)) {
-		fprintf(stderr, _("%s: failed to read %s\n"),
-		        av[0], config_filename);
-		exit(1);
-	}
-	if (config_file) {
-		printf("#\n");
-		printf(_("# configuration is based on '%s'\n"),
-		       config_filename);
-	}
-	/* generate the config */
-	do {
-		conf_cnt = 0;
-		check_conf(&rootmenu);
-	} while (conf_cnt);
-	/* write out the config */
-	if (conf_write(NULL) || conf_write_autoconf()) {
-		fprintf(stderr,
-		        _("%s: error during write of the configuration.\n"),
-		        av[0]);
-		exit(1);
-	}
-	return 0;
-}
diff -puN scripts/kconfig/conf.c~revert-git-kbuild scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c~revert-git-kbuild
+++ a/scripts/kconfig/conf.c
@@ -21,7 +21,14 @@ static void check_conf(struct menu *menu
 enum {
 	ask_all,
 	ask_new,
+	ask_silent,
+	set_default,
+	set_yes,
+	set_mod,
+	set_no,
+	set_random
 } input_mode = ask_all;
+char *defconfig_file;
 
 static int indent = 1;
 static int valid_stdin = 1;
@@ -58,17 +65,18 @@ static void strip(char *str)
 
 static void check_stdin(void)
 {
-	if (valid_stdin)
-		return;
-	fprintf(stderr, _("aborted!\n\n"));
-	fprintf(stderr, _("Console input/output is redirected. "));
-	fprintf(stderr, _("Run 'make oldconfig' to update configuration.\n\n"));
-	exit(1);
+	if (!valid_stdin && input_mode == ask_silent) {
+		printf(_("aborted!\n\n"));
+		printf(_("Console input/output is redirected. "));
+		printf(_("Run 'make oldconfig' to update configuration.\n\n"));
+		exit(1);
+	}
 }
 
 static int conf_askvalue(struct symbol *sym, const char *def)
 {
 	enum symbol_type type = sym_get_type(sym);
+	tristate val;
 
 	if (!sym_has_value(sym))
 		printf(_("(NEW) "));
@@ -83,17 +91,32 @@ static int conf_askvalue(struct symbol *
 		return 0;
 	}
 
-	check_stdin();
 	switch (input_mode) {
+	case set_no:
+	case set_mod:
+	case set_yes:
+	case set_random:
+		if (sym_has_value(sym)) {
+			printf("%s\n", def);
+			return 0;
+		}
+		break;
 	case ask_new:
+	case ask_silent:
 		if (sym_has_value(sym)) {
 			printf("%s\n", def);
 			return 0;
 		}
+		check_stdin();
 	case ask_all:
 		fflush(stdout);
 		fgets(line, 128, stdin);
 		return 1;
+	case set_default:
+		printf("%s\n", def);
+		return 1;
+	default:
+		break;
 	}
 
 	switch (type) {
@@ -105,6 +128,52 @@ static int conf_askvalue(struct symbol *
 	default:
 		;
 	}
+	switch (input_mode) {
+	case set_yes:
+		if (sym_tristate_within_range(sym, yes)) {
+			line[0] = 'y';
+			line[1] = '\n';
+			line[2] = 0;
+			break;
+		}
+	case set_mod:
+		if (type == S_TRISTATE) {
+			if (sym_tristate_within_range(sym, mod)) {
+				line[0] = 'm';
+				line[1] = '\n';
+				line[2] = 0;
+				break;
+			}
+		} else {
+			if (sym_tristate_within_range(sym, yes)) {
+				line[0] = 'y';
+				line[1] = '\n';
+				line[2] = 0;
+				break;
+			}
+		}
+	case set_no:
+		if (sym_tristate_within_range(sym, no)) {
+			line[0] = 'n';
+			line[1] = '\n';
+			line[2] = 0;
+			break;
+		}
+	case set_random:
+		do {
+			val = (tristate)(rand() % 3);
+		} while (!sym_tristate_within_range(sym, val));
+		switch (val) {
+		case no: line[0] = 'n'; break;
+		case mod: line[0] = 'm'; break;
+		case yes: line[0] = 'y'; break;
+		}
+		line[1] = '\n';
+		line[2] = 0;
+		break;
+	default:
+		break;
+	}
 	printf("%s", line);
 	return 1;
 }
@@ -283,6 +352,7 @@ static int conf_choice(struct menu *menu
 		printf("]: ");
 		switch (input_mode) {
 		case ask_new:
+		case ask_silent:
 			if (!is_new) {
 				cnt = def;
 				printf("%d\n", cnt);
@@ -304,6 +374,16 @@ static int conf_choice(struct menu *menu
 			else
 				continue;
 			break;
+		case set_random:
+			if (is_new)
+				def = (rand() % cnt) + 1;
+		case set_default:
+		case set_yes:
+		case set_mod:
+		case set_no:
+			cnt = def;
+			printf("%d\n", cnt);
+			break;
 		}
 
 	conf_childs:
@@ -345,7 +425,7 @@ static void conf(struct menu *menu)
 
 		switch (prop->type) {
 		case P_MENU:
-			if (input_mode != ask_all && rootEntry != menu) {
+			if (input_mode == ask_silent && rootEntry != menu) {
 				check_conf(menu);
 				return;
 			}
@@ -424,13 +504,35 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	valid_stdin = isatty(0) && isatty(1) && isatty(2);
-
-	while ((opt = getopt(ac, av, "oh")) != -1) {
+	while ((opt = getopt(ac, av, "osdD:nmyrh")) != -1) {
 		switch (opt) {
 		case 'o':
 			input_mode = ask_new;
 			break;
+		case 's':
+			input_mode = ask_silent;
+			valid_stdin = isatty(0) && isatty(1) && isatty(2);
+			break;
+		case 'd':
+			input_mode = set_default;
+			break;
+		case 'D':
+			input_mode = set_default;
+			defconfig_file = optarg;
+			break;
+		case 'n':
+			input_mode = set_no;
+			break;
+		case 'm':
+			input_mode = set_mod;
+			break;
+		case 'y':
+			input_mode = set_yes;
+			break;
+		case 'r':
+			input_mode = set_random;
+			srand(time(NULL));
+			break;
 		case 'h':
 			printf(_("See README for usage info\n"));
 			exit(0);
@@ -448,7 +550,17 @@ int main(int ac, char **av)
 	conf_parse(name);
 	//zconfdump(stdout);
 	switch (input_mode) {
-	case ask_new:
+	case set_default:
+		if (!defconfig_file)
+			defconfig_file = conf_get_default_confname();
+		if (conf_read(defconfig_file)) {
+			printf(_("***\n"
+				"*** Can't find default configuration \"%s\"!\n"
+				"***\n"), defconfig_file);
+			exit(1);
+		}
+		break;
+	case ask_silent:
 		if (stat(".config", &tmpstat)) {
 			printf(_("***\n"
 				"*** You have not yet configured your kernel!\n"
@@ -460,13 +572,41 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	case ask_all:
+	case ask_new:
 		conf_read(NULL);
 		break;
+	case set_no:
+	case set_mod:
+	case set_yes:
+	case set_random:
+		name = getenv("KCONFIG_ALLCONFIG");
+		if (name && !stat(name, &tmpstat)) {
+			conf_read_simple(name, S_DEF_USER);
+			break;
+		}
+		switch (input_mode) {
+		case set_no:	 name = "allno.config"; break;
+		case set_mod:	 name = "allmod.config"; break;
+		case set_yes:	 name = "allyes.config"; break;
+		case set_random: name = "allrandom.config"; break;
+		default: break;
+		}
+		if (!stat(name, &tmpstat))
+			conf_read_simple(name, S_DEF_USER);
+		else if (!stat("all.config", &tmpstat))
+			conf_read_simple("all.config", S_DEF_USER);
+		break;
+	default:
+		break;
 	}
 
-	if (input_mode == ask_all) {
+	if (input_mode != ask_silent) {
 		rootEntry = &rootmenu;
 		conf(&rootmenu);
+		if (input_mode == ask_all) {
+			input_mode = ask_silent;
+			valid_stdin = 1;
+		}
 	} else if (conf_get_changed()) {
 		name = getenv("KCONFIG_NOSILENTUPDATE");
 		if (name && *name) {
@@ -485,7 +625,7 @@ int main(int ac, char **av)
 		return 1;
 	}
 skip_check:
-	if (conf_write_autoconf()) {
+	if (input_mode == ask_silent && conf_write_autoconf()) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 		return 1;
 	}
diff -puN scripts/kconfig/lex.zconf.c_shipped~revert-git-kbuild scripts/kconfig/lex.zconf.c_shipped
--- a/scripts/kconfig/lex.zconf.c_shipped~revert-git-kbuild
+++ a/scripts/kconfig/lex.zconf.c_shipped
@@ -2268,17 +2268,13 @@ FILE *zconf_fopen(const char *name)
 	char *env, fullname[PATH_MAX+1];
 	FILE *f;
 
-	if (strcmp(name, "-")) {
-		f = fopen(name, "r");
-		if (!f && name != NULL && name[0] != '/') {
-			env = getenv(SRCTREE);
-			if (env) {
-				sprintf(fullname, "%s/%s", env, name);
-				f = fopen(fullname, "r");
-			}
+	f = fopen(name, "r");
+	if (!f && name != NULL && name[0] != '/') {
+		env = getenv(SRCTREE);
+		if (env) {
+			sprintf(fullname, "%s/%s", env, name);
+			f = fopen(fullname, "r");
 		}
-	} else {
-		f = stdin;
 	}
 	return f;
 }
diff -puN scripts/kconfig/zconf.l~revert-git-kbuild scripts/kconfig/zconf.l
--- a/scripts/kconfig/zconf.l~revert-git-kbuild
+++ a/scripts/kconfig/zconf.l
@@ -269,17 +269,13 @@ FILE *zconf_fopen(const char *name)
 	char *env, fullname[PATH_MAX+1];
 	FILE *f;
 
-	if (strcmp(name, "-")) {
-		f = fopen(name, "r");
-		if (!f && name != NULL && name[0] != '/') {
-			env = getenv(SRCTREE);
-			if (env) {
-				sprintf(fullname, "%s/%s", env, name);
-				f = fopen(fullname, "r");
-			}
+	f = fopen(name, "r");
+	if (!f && name != NULL && name[0] != '/') {
+		env = getenv(SRCTREE);
+		if (env) {
+			sprintf(fullname, "%s/%s", env, name);
+			f = fopen(fullname, "r");
 		}
-	} else {
-		f = stdin;
 	}
 	return f;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-vt-fix-background-color-on-line-feed.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86.patch
git-x86-fixup.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
git-jg-misc-git-rejects.patch
revert-git-kbuild.patch
revert-libata-improve-post-reset-device-ready-test.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
hysdn-no-longer-broken-on-smp.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

