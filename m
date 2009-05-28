From: akpm@linux-foundation.org
Subject: + kconfig-do-not-hardcode-include-config-autoconf-filename.patch added to -mm tree
Date: Wed, 27 May 2009 23:44:03 -0700
Message-ID: <200905280644.n4S6i3jA015223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbZE1Goi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:44:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     kconfig: do not hardcode "include/config/auto.conf" filename
has been added to the -mm tree.  Its filename is
     kconfig-do-not-hardcode-include-config-autoconf-filename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig: do not hardcode "include/config/auto.conf" filename
From: Markus Heidelberg <markus.heidelberg@web.de>

Regardless of KCONFIG_AUTOCONFIG, the filename written as a Make target
into "include/config/auto.conf.cmd" was always the default one.

Of course this doesn't make it work for the Kernel kbuild system, since
there the filename is hardcoded at several places in the Makefiles.

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/confdata.c |   20 ++++++++++++--------
 scripts/kconfig/lkc.h      |    1 +
 scripts/kconfig/util.c     |    6 +++---
 3 files changed, 16 insertions(+), 11 deletions(-)

diff -puN scripts/kconfig/confdata.c~kconfig-do-not-hardcode-include-config-autoconf-filename scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kconfig-do-not-hardcode-include-config-autoconf-filename
+++ a/scripts/kconfig/confdata.c
@@ -41,6 +41,13 @@ const char *conf_get_configname(void)
 	return name ? name : ".config";
 }
 
+const char *conf_get_autoconfig_name(void)
+{
+	char *name = getenv("KCONFIG_AUTOCONFIG");
+
+	return name ? name : "include/config/auto.conf";
+}
+
 static char *conf_expand_value(const char *in)
 {
 	struct symbol *sym;
@@ -555,15 +562,14 @@ int conf_write(const char *name)
 
 int conf_split_config(void)
 {
-	char *name, path[128];
+	const char *name;
+	char path[128];
 	char *s, *d, c;
 	struct symbol *sym;
 	struct stat sb;
 	int res, i, fd;
 
-	name = getenv("KCONFIG_AUTOCONFIG");
-	if (!name)
-		name = "include/config/auto.conf";
+	name = conf_get_autoconfig_name();
 	conf_read_simple(name, S_DEF_AUTO);
 
 	if (chdir("include/config"))
@@ -670,7 +676,7 @@ int conf_write_autoconf(void)
 {
 	struct symbol *sym;
 	const char *str;
-	char *name;
+	const char *name;
 	FILE *out, *out_h;
 	time_t now;
 	int i, l;
@@ -773,9 +779,7 @@ int conf_write_autoconf(void)
 		name = "include/linux/autoconf.h";
 	if (rename(".tmpconfig.h", name))
 		return 1;
-	name = getenv("KCONFIG_AUTOCONFIG");
-	if (!name)
-		name = "include/config/auto.conf";
+	name = conf_get_autoconfig_name();
 	/*
 	 * This must be the last step, kbuild has a dependency on auto.conf
 	 * and this marks the successful completion of the previous steps.
diff -puN scripts/kconfig/lkc.h~kconfig-do-not-hardcode-include-config-autoconf-filename scripts/kconfig/lkc.h
--- a/scripts/kconfig/lkc.h~kconfig-do-not-hardcode-include-config-autoconf-filename
+++ a/scripts/kconfig/lkc.h
@@ -74,6 +74,7 @@ char *zconf_curname(void);
 
 /* confdata.c */
 const char *conf_get_configname(void);
+const char *conf_get_autoconfig_name(void);
 char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
diff -puN scripts/kconfig/util.c~kconfig-do-not-hardcode-include-config-autoconf-filename scripts/kconfig/util.c
--- a/scripts/kconfig/util.c~kconfig-do-not-hardcode-include-config-autoconf-filename
+++ a/scripts/kconfig/util.c
@@ -46,8 +46,8 @@ int file_write_dep(const char *name)
 		else
 			fprintf(out, "\t%s\n", file->name);
 	}
-	fprintf(out, "\ninclude/config/auto.conf: \\\n"
-		     "\t$(deps_config)\n\n");
+	fprintf(out, "\n%s: \\\n"
+		     "\t$(deps_config)\n\n", conf_get_autoconfig_name());
 
 	expr_list_for_each_sym(sym_env_list, e, sym) {
 		struct property *prop;
@@ -61,7 +61,7 @@ int file_write_dep(const char *name)
 		if (!value)
 			value = "";
 		fprintf(out, "ifneq \"$(%s)\" \"%s\"\n", env_sym->name, value);
-		fprintf(out, "include/config/auto.conf: FORCE\n");
+		fprintf(out, "%s: FORCE\n", conf_get_autoconfig_name());
 		fprintf(out, "endif\n");
 	}
 
_

Patches currently in -mm which might be from markus.heidelberg@web.de are

kconfig-fix-typo-mconfig-to-menuconfig-in-a-comment.patch
kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help.patch
kconfig-resort-the-documentation-of-the-environment-variables.patch
gitignore-ignore-kconfig-i18n-files.patch
kconfig-qconf-fix-wall-compiler-warnings.patch
kconfig-qconf-fix-namespace-for-horizontal-and-vertical-enum-values.patch
kconfig-qconf-add-namespace-for-use-of-key_-enum-values.patch
kconfig-qconf-fix-the-type-of-the-desktop-widget.patch
kconfig-do-not-hardcode-config-filename.patch
kconfig-do-not-hardcode-include-config-autoconf-filename.patch

