From: akpm@osdl.org
Subject: - kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:03:31 -0800
Message-ID: <200612140603.kBE63VhH001787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbWLNGHd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:07:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: annabellesgarden@yahoo.de, fzu@wemgehoertderstaat.de, randy.dunlap@oracle.com, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig: make sym_change_count static, let it be altered by 2 functions only
has been removed from the -mm tree.  Its filename was
     kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kconfig: make sym_change_count static, let it be altered by 2 functions only
From: Karsten Wiese <annabellesgarden@yahoo.de>

Those two functions are
	void sym_set_change_count(int count)
and
	void sym_add_change_count(int count)


All write accesses to sym_change_count are replaced by calls to above
functions.

Variable and changer-functions are moved to confdata.c.  IMO thats ok, as
sym_change_count is an attribute of the .config's change state.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/confdata.c          |   20 ++++++++++++++++----
 scripts/kconfig/lkc.h               |    2 ++
 scripts/kconfig/lkc_proto.h         |    1 -
 scripts/kconfig/symbol.c            |    3 +--
 scripts/kconfig/zconf.tab.c_shipped |    2 +-
 scripts/kconfig/zconf.y             |    2 +-
 6 files changed, 21 insertions(+), 9 deletions(-)

diff -puN scripts/kconfig/confdata.c~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only
+++ a/scripts/kconfig/confdata.c
@@ -100,7 +100,7 @@ int conf_read_simple(const char *name, i
 		in = zconf_fopen(name);
 		if (in)
 			goto load;
-		sym_change_count++;
+		sym_add_change_count(1);
 		if (!sym_defconfig_list)
 			return 1;
 
@@ -312,7 +312,7 @@ int conf_read(const char *name)
 	struct expr *e;
 	int i, flags;
 
-	sym_change_count = 0;
+	sym_set_change_count(0);
 
 	if (conf_read_simple(name, S_DEF_USER))
 		return 1;
@@ -364,7 +364,7 @@ int conf_read(const char *name)
 		sym->flags &= flags | ~SYMBOL_DEF_USER;
 	}
 
-	sym_change_count += conf_warnings || conf_unsaved;
+	sym_add_change_count(conf_warnings || conf_unsaved);
 
 	return 0;
 }
@@ -528,7 +528,7 @@ int conf_write(const char *name)
 		 "# configuration written to %s\n"
 		 "#\n"), newname);
 
-	sym_change_count = 0;
+	sym_set_change_count(0);
 
 	return 0;
 }
@@ -766,6 +766,18 @@ int conf_write_autoconf(void)
 	return 0;
 }
 
+static int sym_change_count;
+
+void sym_set_change_count(int count)
+{
+	sym_change_count = count;
+}
+
+void sym_add_change_count(int count)
+{
+	sym_change_count += count;
+}
+
 bool conf_get_changed(void)
 {
 	return sym_change_count;
diff -puN scripts/kconfig/lkc.h~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only scripts/kconfig/lkc.h
--- a/scripts/kconfig/lkc.h~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only
+++ a/scripts/kconfig/lkc.h
@@ -65,6 +65,8 @@ char *zconf_curname(void);
 
 /* confdata.c */
 char *conf_get_default_confname(void);
+void sym_set_change_count(int count);
+void sym_add_change_count(int count);
 
 /* kconfig_load.c */
 void kconfig_load(void);
diff -puN scripts/kconfig/lkc_proto.h~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only scripts/kconfig/lkc_proto.h
--- a/scripts/kconfig/lkc_proto.h~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only
+++ a/scripts/kconfig/lkc_proto.h
@@ -17,7 +17,6 @@ P(menu_get_parent_menu,struct menu *,(st
 
 /* symbol.c */
 P(symbol_hash,struct symbol *,[SYMBOL_HASHSIZE]);
-P(sym_change_count,int,);
 
 P(sym_lookup,struct symbol *,(const char *name, int isconst));
 P(sym_find,struct symbol *,(const char *name));
diff -puN scripts/kconfig/symbol.c~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only scripts/kconfig/symbol.c
--- a/scripts/kconfig/symbol.c~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only
+++ a/scripts/kconfig/symbol.c
@@ -30,7 +30,6 @@ struct symbol symbol_yes = {
 	.flags = SYMBOL_VALID,
 };
 
-int sym_change_count;
 struct symbol *sym_defconfig_list;
 struct symbol *modules_sym;
 tristate modules_val;
@@ -379,7 +378,7 @@ void sym_clear_all_valid(void)
 
 	for_all_symbols(i, sym)
 		sym->flags &= ~SYMBOL_VALID;
-	sym_change_count++;
+	sym_add_change_count(1);
 	if (modules_sym)
 		sym_calc_value(modules_sym);
 }
diff -puN scripts/kconfig/zconf.tab.c_shipped~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only scripts/kconfig/zconf.tab.c_shipped
--- a/scripts/kconfig/zconf.tab.c_shipped~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only
+++ a/scripts/kconfig/zconf.tab.c_shipped
@@ -2135,7 +2135,7 @@ void conf_parse(const char *name)
 		sym_check_deps(sym);
         }
 
-	sym_change_count = 1;
+	sym_set_change_count(1);
 }
 
 const char *zconf_tokenname(int token)
diff -puN scripts/kconfig/zconf.y~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only scripts/kconfig/zconf.y
--- a/scripts/kconfig/zconf.y~kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only
+++ a/scripts/kconfig/zconf.y
@@ -504,7 +504,7 @@ void conf_parse(const char *name)
 		sym_check_deps(sym);
         }
 
-	sym_change_count = 1;
+	sym_set_change_count(1);
 }
 
 const char *zconf_tokenname(int token)
_

Patches currently in -mm which might be from annabellesgarden@yahoo.de are


