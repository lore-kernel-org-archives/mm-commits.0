From: akpm@linux-foundation.org
Subject: - kconfig-add-module_name-shortcut.patch removed from -mm tree
Date: Wed, 31 Dec 2008 00:45:21 -0800
Message-ID: <200812310845.mBV8jLS9011717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbYLaIqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Dec 2008 03:46:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig: add module_name shortcut
has been removed from the -mm tree.  Its filename was
     kconfig-add-module_name-shortcut.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig: add module_name shortcut
From: Alexey Dobriyan <adobriyan@gmail.com>

As correctly noticed in bug 11446
(http://bugzilla.kernel.org/show_bug.cgi?id=11446) "To compile this driver
as a module, blah-blah" boilerplate is being copy-pasted to death with
slight variations.

Add Kconfig token "module_name" to supply module's name. Example:

	config FOO
		tristate "foo"
		module_name foo
		---help---
		  foo

Print module's name as following on menuconfigs help screen (press 'h'):

	Module name: foo

8139too driver converted to show real-life example.

P.S.: menuconfig only, no checking wrt modular/standalone code et al.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig                  |    4 
 scripts/kconfig/expr.h               |    2 
 scripts/kconfig/lkc.h                |    1 
 scripts/kconfig/mconf.c              |    2 
 scripts/kconfig/menu.c               |    8 
 scripts/kconfig/symbol.c             |    2 
 scripts/kconfig/zconf.gperf          |    1 
 scripts/kconfig/zconf.hash.c_shipped |  184 ++++----
 scripts/kconfig/zconf.tab.c_shipped  |  539 ++++++++++++-------------
 scripts/kconfig/zconf.y              |   12 
 10 files changed, 403 insertions(+), 352 deletions(-)

diff -puN drivers/net/Kconfig~kconfig-add-module_name-shortcut drivers/net/Kconfig
--- a/drivers/net/Kconfig~kconfig-add-module_name-shortcut
+++ a/drivers/net/Kconfig
@@ -1551,14 +1551,12 @@ config 8139TOO
 	depends on NET_PCI && PCI
 	select CRC32
 	select MII
+	module_name 8139too
 	---help---
 	  This is a driver for the Fast Ethernet PCI network cards based on
 	  the RTL 8129/8130/8139 chips. If you have one of those, say Y and
 	  read the Ethernet-HOWTO <http://www.tldp.org/docs.html#howto>.
 
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8139too.  This is recommended.
-
 config 8139TOO_PIO
 	bool "Use PIO instead of MMIO"
 	default y
diff -puN scripts/kconfig/expr.h~kconfig-add-module_name-shortcut scripts/kconfig/expr.h
--- a/scripts/kconfig/expr.h~kconfig-add-module_name-shortcut
+++ a/scripts/kconfig/expr.h
@@ -133,6 +133,7 @@ enum prop_type {
 	P_RANGE,    /* range 7..100 (for a symbol) */
 	P_ENV,      /* value from environment variable */
 	P_SYMBOL,   /* where a symbol is defined */
+	P_MODULE_NAME, /* printing the name of the generated module */
 };
 
 struct property {
@@ -140,6 +141,7 @@ struct property {
 	struct symbol *sym;        /* the symbol for which the property is associated */
 	enum prop_type type;       /* type of property */
 	const char *text;          /* the prompt value - P_PROMPT, P_MENU, P_COMMENT */
+	char *module_name;
 	struct expr_value visible;
 	struct expr *expr;         /* the optional conditional part of the property */
 	struct menu *menu;         /* the menu the property are associated with
diff -puN scripts/kconfig/lkc.h~kconfig-add-module_name-shortcut scripts/kconfig/lkc.h
--- a/scripts/kconfig/lkc.h~kconfig-add-module_name-shortcut
+++ a/scripts/kconfig/lkc.h
@@ -95,6 +95,7 @@ struct property *menu_add_prompt(enum pr
 void menu_add_expr(enum prop_type type, struct expr *expr, struct expr *dep);
 void menu_add_symbol(enum prop_type type, struct symbol *sym, struct expr *dep);
 void menu_add_option(int token, char *arg);
+void menu_add_module_name(char *module_name);
 void menu_finalize(struct menu *parent);
 void menu_set_type(int type);
 
diff -puN scripts/kconfig/mconf.c~kconfig-add-module_name-shortcut scripts/kconfig/mconf.c
--- a/scripts/kconfig/mconf.c~kconfig-add-module_name-shortcut
+++ a/scripts/kconfig/mconf.c
@@ -320,6 +320,8 @@ static void get_symbol_str(struct gstr *
 	bool hit;
 	struct property *prop;
 
+	for_all_properties(sym, prop, P_MODULE_NAME)
+		str_printf(r, _("Module name: %s\n\n"), prop->module_name);
 	if (sym && sym->name)
 		str_printf(r, "Symbol: %s [=%s]\n", sym->name,
 		                                    sym_get_string_value(sym));
diff -puN scripts/kconfig/menu.c~kconfig-add-module_name-shortcut scripts/kconfig/menu.c
--- a/scripts/kconfig/menu.c~kconfig-add-module_name-shortcut
+++ a/scripts/kconfig/menu.c
@@ -180,6 +180,14 @@ void menu_add_option(int token, char *ar
 	}
 }
 
+void menu_add_module_name(char *module_name)
+{
+	struct property *prop;
+
+	prop = prop_alloc(P_MODULE_NAME, current_entry->sym);
+	prop->module_name = strdup(module_name);
+}
+
 static int menu_range_valid_sym(struct symbol *sym, struct symbol *sym2)
 {
 	return sym2->type == S_INT || sym2->type == S_HEX ||
diff -puN scripts/kconfig/symbol.c~kconfig-add-module_name-shortcut scripts/kconfig/symbol.c
--- a/scripts/kconfig/symbol.c~kconfig-add-module_name-shortcut
+++ a/scripts/kconfig/symbol.c
@@ -954,6 +954,8 @@ const char *prop_get_type_name(enum prop
 		return "range";
 	case P_SYMBOL:
 		return "symbol";
+	case P_MODULE_NAME:
+		return "module_name";
 	case P_UNKNOWN:
 		break;
 	}
diff -puN scripts/kconfig/zconf.gperf~kconfig-add-module_name-shortcut scripts/kconfig/zconf.gperf
--- a/scripts/kconfig/zconf.gperf~kconfig-add-module_name-shortcut
+++ a/scripts/kconfig/zconf.gperf
@@ -41,4 +41,5 @@ on,		T_ON,		TF_PARAM
 modules,	T_OPT_MODULES,	TF_OPTION
 defconfig_list,	T_OPT_DEFCONFIG_LIST,TF_OPTION
 env,		T_OPT_ENV,	TF_OPTION
+module_name,	T_MODULE_NAME,	TF_COMMAND
 %%
diff -puN scripts/kconfig/zconf.hash.c_shipped~kconfig-add-module_name-shortcut scripts/kconfig/zconf.hash.c_shipped
--- a/scripts/kconfig/zconf.hash.c_shipped~kconfig-add-module_name-shortcut
+++ a/scripts/kconfig/zconf.hash.c_shipped
@@ -30,7 +30,7 @@
 #endif
 
 struct kconf_id;
-/* maximum key range = 47, duplicates = 0 */
+/* maximum key range = 45, duplicates = 0 */
 
 #ifdef __GNUC__
 __inline
@@ -44,32 +44,32 @@ kconf_id_hash (register const char *str,
 {
   static unsigned char asso_values[] =
     {
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 11,  5,
-       0,  0,  5, 49,  5, 20, 49, 49,  5, 20,
-       5,  0, 30, 49,  0, 15,  0, 10,  0, 49,
-      25, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49, 49, 49, 49, 49,
-      49, 49, 49, 49, 49, 49
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 15,  5,
+       0,  0,  5, 47,  0,  0, 47, 47, 10, 25,
+       0, 20, 20, 47,  5,  5,  0, 30, 20, 47,
+      15, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47, 47, 47, 47, 47,
+      47, 47, 47, 47, 47, 47
     };
   register int hval = len;
 
@@ -88,71 +88,73 @@ kconf_id_hash (register const char *str,
 
 struct kconf_id_strings_t
   {
-    char kconf_id_strings_str2[sizeof("on")];
-    char kconf_id_strings_str3[sizeof("env")];
+    char kconf_id_strings_str2[sizeof("if")];
+    char kconf_id_strings_str3[sizeof("int")];
     char kconf_id_strings_str5[sizeof("endif")];
-    char kconf_id_strings_str6[sizeof("option")];
     char kconf_id_strings_str7[sizeof("endmenu")];
-    char kconf_id_strings_str8[sizeof("optional")];
+    char kconf_id_strings_str8[sizeof("tristate")];
     char kconf_id_strings_str9[sizeof("endchoice")];
     char kconf_id_strings_str10[sizeof("range")];
-    char kconf_id_strings_str11[sizeof("choice")];
+    char kconf_id_strings_str11[sizeof("config")];
     char kconf_id_strings_str12[sizeof("default")];
     char kconf_id_strings_str13[sizeof("def_bool")];
     char kconf_id_strings_str14[sizeof("help")];
-    char kconf_id_strings_str15[sizeof("bool")];
-    char kconf_id_strings_str16[sizeof("config")];
+    char kconf_id_strings_str16[sizeof("string")];
     char kconf_id_strings_str17[sizeof("def_tristate")];
-    char kconf_id_strings_str18[sizeof("boolean")];
+    char kconf_id_strings_str18[sizeof("hex")];
     char kconf_id_strings_str19[sizeof("defconfig_list")];
-    char kconf_id_strings_str21[sizeof("string")];
-    char kconf_id_strings_str22[sizeof("if")];
-    char kconf_id_strings_str23[sizeof("int")];
-    char kconf_id_strings_str26[sizeof("select")];
-    char kconf_id_strings_str27[sizeof("modules")];
-    char kconf_id_strings_str28[sizeof("tristate")];
+    char kconf_id_strings_str21[sizeof("select")];
+    char kconf_id_strings_str22[sizeof("on")];
+    char kconf_id_strings_str23[sizeof("env")];
+    char kconf_id_strings_str26[sizeof("option")];
+    char kconf_id_strings_str27[sizeof("depends")];
+    char kconf_id_strings_str28[sizeof("optional")];
     char kconf_id_strings_str29[sizeof("menu")];
-    char kconf_id_strings_str31[sizeof("source")];
-    char kconf_id_strings_str32[sizeof("comment")];
-    char kconf_id_strings_str33[sizeof("hex")];
+    char kconf_id_strings_str31[sizeof("choice")];
+    char kconf_id_strings_str32[sizeof("modules")];
+    char kconf_id_strings_str33[sizeof("mainmenu")];
     char kconf_id_strings_str35[sizeof("menuconfig")];
-    char kconf_id_strings_str36[sizeof("prompt")];
-    char kconf_id_strings_str37[sizeof("depends")];
-    char kconf_id_strings_str48[sizeof("mainmenu")];
+    char kconf_id_strings_str36[sizeof("module_name")];
+    char kconf_id_strings_str37[sizeof("comment")];
+    char kconf_id_strings_str39[sizeof("bool")];
+    char kconf_id_strings_str41[sizeof("source")];
+    char kconf_id_strings_str42[sizeof("boolean")];
+    char kconf_id_strings_str46[sizeof("prompt")];
   };
 static struct kconf_id_strings_t kconf_id_strings_contents =
   {
-    "on",
-    "env",
+    "if",
+    "int",
     "endif",
-    "option",
     "endmenu",
-    "optional",
+    "tristate",
     "endchoice",
     "range",
-    "choice",
+    "config",
     "default",
     "def_bool",
     "help",
-    "bool",
-    "config",
+    "string",
     "def_tristate",
-    "boolean",
+    "hex",
     "defconfig_list",
-    "string",
-    "if",
-    "int",
     "select",
-    "modules",
-    "tristate",
+    "on",
+    "env",
+    "option",
+    "depends",
+    "optional",
     "menu",
-    "source",
-    "comment",
-    "hex",
+    "choice",
+    "modules",
+    "mainmenu",
     "menuconfig",
-    "prompt",
-    "depends",
-    "mainmenu"
+    "module_name",
+    "comment",
+    "bool",
+    "source",
+    "boolean",
+    "prompt"
   };
 #define kconf_id_strings ((const char *) &kconf_id_strings_contents)
 #ifdef __GNUC__
@@ -166,54 +168,58 @@ kconf_id_lookup (register const char *st
 {
   enum
     {
-      TOTAL_KEYWORDS = 31,
+      TOTAL_KEYWORDS = 32,
       MIN_WORD_LENGTH = 2,
       MAX_WORD_LENGTH = 14,
       MIN_HASH_VALUE = 2,
-      MAX_HASH_VALUE = 48
+      MAX_HASH_VALUE = 46
     };
 
   static struct kconf_id wordlist[] =
     {
       {-1}, {-1},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str2,		T_ON,		TF_PARAM},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str3,		T_OPT_ENV,	TF_OPTION},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str2,		T_IF,		TF_COMMAND|TF_PARAM},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str3,		T_TYPE,		TF_COMMAND, S_INT},
       {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str5,		T_ENDIF,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str6,		T_OPTION,	TF_COMMAND},
+      {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str7,	T_ENDMENU,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str8,	T_OPTIONAL,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str8,	T_TYPE,		TF_COMMAND, S_TRISTATE},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str9,	T_ENDCHOICE,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str10,		T_RANGE,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str11,		T_CHOICE,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str11,		T_CONFIG,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str12,	T_DEFAULT,	TF_COMMAND, S_UNKNOWN},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str13,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str14,		T_HELP,		TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str15,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str16,		T_CONFIG,	TF_COMMAND},
+      {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str16,		T_TYPE,		TF_COMMAND, S_STRING},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str17,	T_DEFAULT,	TF_COMMAND, S_TRISTATE},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,		T_TYPE,		TF_COMMAND, S_HEX},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str19,	T_OPT_DEFCONFIG_LIST,TF_OPTION},
       {-1},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_TYPE,		TF_COMMAND, S_STRING},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,		T_IF,		TF_COMMAND|TF_PARAM},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str23,		T_TYPE,		TF_COMMAND, S_INT},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_SELECT,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,		T_ON,		TF_PARAM},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str23,		T_OPT_ENV,	TF_OPTION},
       {-1}, {-1},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str26,		T_SELECT,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,	T_TYPE,		TF_COMMAND, S_TRISTATE},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str26,		T_OPTION,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_DEPENDS,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,	T_OPTIONAL,	TF_COMMAND},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str29,		T_MENU,		TF_COMMAND},
       {-1},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str31,		T_SOURCE,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str32,	T_COMMENT,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str33,		T_TYPE,		TF_COMMAND, S_HEX},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str31,		T_CHOICE,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str32,	T_OPT_MODULES,	TF_OPTION},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str33,	T_MAINMENU,	TF_COMMAND},
       {-1},
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str35,	T_MENUCONFIG,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,		T_PROMPT,	TF_COMMAND},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str37,	T_DEPENDS,	TF_COMMAND},
-      {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,	T_MODULE_NAME,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str37,	T_COMMENT,	TF_COMMAND},
+      {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str39,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
       {-1},
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str48,	T_MAINMENU,	TF_COMMAND}
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str41,		T_SOURCE,	TF_COMMAND},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str42,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1}, {-1}, {-1},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str46,		T_PROMPT,	TF_COMMAND}
     };
 
   if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
diff -puN scripts/kconfig/zconf.tab.c_shipped~kconfig-add-module_name-shortcut scripts/kconfig/zconf.tab.c_shipped
--- a/scripts/kconfig/zconf.tab.c_shipped~kconfig-add-module_name-shortcut
+++ a/scripts/kconfig/zconf.tab.c_shipped
@@ -96,16 +96,17 @@
      T_RANGE = 277,
      T_OPTION = 278,
      T_ON = 279,
-     T_WORD = 280,
-     T_WORD_QUOTE = 281,
-     T_UNEQUAL = 282,
-     T_CLOSE_PAREN = 283,
-     T_OPEN_PAREN = 284,
-     T_EOL = 285,
-     T_OR = 286,
-     T_AND = 287,
-     T_EQUAL = 288,
-     T_NOT = 289
+     T_MODULE_NAME = 280,
+     T_WORD = 281,
+     T_WORD_QUOTE = 282,
+     T_UNEQUAL = 283,
+     T_CLOSE_PAREN = 284,
+     T_OPEN_PAREN = 285,
+     T_EOL = 286,
+     T_OR = 287,
+     T_AND = 288,
+     T_EQUAL = 289,
+     T_NOT = 290
    };
 #endif
 /* Tokens.  */
@@ -131,16 +132,17 @@
 #define T_RANGE 277
 #define T_OPTION 278
 #define T_ON 279
-#define T_WORD 280
-#define T_WORD_QUOTE 281
-#define T_UNEQUAL 282
-#define T_CLOSE_PAREN 283
-#define T_OPEN_PAREN 284
-#define T_EOL 285
-#define T_OR 286
-#define T_AND 287
-#define T_EQUAL 288
-#define T_NOT 289
+#define T_MODULE_NAME 280
+#define T_WORD 281
+#define T_WORD_QUOTE 282
+#define T_UNEQUAL 283
+#define T_CLOSE_PAREN 284
+#define T_OPEN_PAREN 285
+#define T_EOL 286
+#define T_OR 287
+#define T_AND 288
+#define T_EQUAL 289
+#define T_NOT 290
 
 
 
@@ -446,20 +448,20 @@ union yyalloc
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  3
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   259
+#define YYLAST   257
 
 /* YYNTOKENS -- Number of terminals.  */
-#define YYNTOKENS  35
+#define YYNTOKENS  36
 /* YYNNTS -- Number of nonterminals.  */
-#define YYNNTS  46
+#define YYNNTS  47
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  110
+#define YYNRULES  112
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  180
+#define YYNSTATES  184
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
-#define YYMAXUTOK   289
+#define YYMAXUTOK   290
 
 #define YYTRANSLATE(YYX)						\
   ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
@@ -495,7 +497,8 @@ static const yytype_uint8 yytranslate[] 
        2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
        5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
       15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
-      25,    26,    27,    28,    29,    30,    31,    32,    33,    34
+      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
+      35
 };
 
 #if YYDEBUG
@@ -507,69 +510,69 @@ static const yytype_uint16 yyprhs[] =
       28,    33,    37,    39,    41,    43,    45,    47,    49,    51,
       53,    55,    57,    59,    61,    63,    67,    70,    74,    77,
       81,    84,    85,    88,    91,    94,    97,   100,   103,   107,
-     112,   117,   122,   128,   132,   133,   137,   138,   141,   145,
-     148,   150,   154,   155,   158,   161,   164,   167,   170,   175,
-     179,   182,   187,   188,   191,   195,   197,   201,   202,   205,
-     208,   211,   215,   218,   220,   224,   225,   228,   231,   234,
-     238,   242,   245,   248,   251,   252,   255,   258,   261,   266,
-     267,   270,   272,   274,   277,   280,   283,   285,   288,   289,
-     292,   294,   298,   302,   306,   309,   313,   317,   319,   321,
-     322
+     112,   117,   122,   128,   132,   136,   137,   141,   142,   145,
+     149,   152,   154,   158,   159,   162,   165,   168,   171,   174,
+     179,   183,   186,   191,   192,   195,   199,   201,   205,   206,
+     209,   212,   215,   219,   222,   224,   228,   229,   232,   235,
+     238,   242,   246,   249,   252,   255,   256,   259,   262,   265,
+     270,   271,   274,   276,   278,   281,   284,   287,   289,   292,
+     293,   296,   298,   302,   306,   310,   313,   317,   321,   323,
+     325,   326,   328
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
 static const yytype_int8 yyrhs[] =
 {
-      36,     0,    -1,    37,    -1,    -1,    37,    39,    -1,    37,
-      53,    -1,    37,    64,    -1,    37,     3,    74,    76,    -1,
-      37,    75,    -1,    37,    25,     1,    30,    -1,    37,    38,
-       1,    30,    -1,    37,     1,    30,    -1,    16,    -1,    18,
+      37,     0,    -1,    38,    -1,    -1,    38,    40,    -1,    38,
+      54,    -1,    38,    65,    -1,    38,     3,    75,    77,    -1,
+      38,    76,    -1,    38,    26,     1,    31,    -1,    38,    39,
+       1,    31,    -1,    38,     1,    31,    -1,    16,    -1,    18,
       -1,    19,    -1,    21,    -1,    17,    -1,    22,    -1,    20,
-      -1,    30,    -1,    59,    -1,    68,    -1,    42,    -1,    44,
-      -1,    66,    -1,    25,     1,    30,    -1,     1,    30,    -1,
-      10,    25,    30,    -1,    41,    45,    -1,    11,    25,    30,
-      -1,    43,    45,    -1,    -1,    45,    46,    -1,    45,    47,
-      -1,    45,    72,    -1,    45,    70,    -1,    45,    40,    -1,
-      45,    30,    -1,    19,    73,    30,    -1,    18,    74,    77,
-      30,    -1,    20,    78,    77,    30,    -1,    21,    25,    77,
-      30,    -1,    22,    79,    79,    77,    30,    -1,    23,    48,
-      30,    -1,    -1,    48,    25,    49,    -1,    -1,    33,    74,
-      -1,     7,    80,    30,    -1,    50,    54,    -1,    75,    -1,
-      51,    56,    52,    -1,    -1,    54,    55,    -1,    54,    72,
-      -1,    54,    70,    -1,    54,    30,    -1,    54,    40,    -1,
-      18,    74,    77,    30,    -1,    19,    73,    30,    -1,    17,
-      30,    -1,    20,    25,    77,    30,    -1,    -1,    56,    39,
-      -1,    14,    78,    76,    -1,    75,    -1,    57,    60,    58,
-      -1,    -1,    60,    39,    -1,    60,    64,    -1,    60,    53,
-      -1,     4,    74,    30,    -1,    61,    71,    -1,    75,    -1,
-      62,    65,    63,    -1,    -1,    65,    39,    -1,    65,    64,
-      -1,    65,    53,    -1,     6,    74,    30,    -1,     9,    74,
-      30,    -1,    67,    71,    -1,    12,    30,    -1,    69,    13,
-      -1,    -1,    71,    72,    -1,    71,    30,    -1,    71,    40,
-      -1,    16,    24,    78,    30,    -1,    -1,    74,    77,    -1,
-      25,    -1,    26,    -1,     5,    30,    -1,     8,    30,    -1,
-      15,    30,    -1,    30,    -1,    76,    30,    -1,    -1,    14,
-      78,    -1,    79,    -1,    79,    33,    79,    -1,    79,    27,
-      79,    -1,    29,    78,    28,    -1,    34,    78,    -1,    78,
-      31,    78,    -1,    78,    32,    78,    -1,    25,    -1,    26,
-      -1,    -1,    25,    -1
+      -1,    31,    -1,    60,    -1,    69,    -1,    43,    -1,    45,
+      -1,    67,    -1,    26,     1,    31,    -1,     1,    31,    -1,
+      10,    26,    31,    -1,    42,    46,    -1,    11,    26,    31,
+      -1,    44,    46,    -1,    -1,    46,    47,    -1,    46,    48,
+      -1,    46,    73,    -1,    46,    71,    -1,    46,    41,    -1,
+      46,    31,    -1,    19,    74,    31,    -1,    18,    75,    78,
+      31,    -1,    20,    79,    78,    31,    -1,    21,    26,    78,
+      31,    -1,    22,    80,    80,    78,    31,    -1,    25,    82,
+      31,    -1,    23,    49,    31,    -1,    -1,    49,    26,    50,
+      -1,    -1,    34,    75,    -1,     7,    81,    31,    -1,    51,
+      55,    -1,    76,    -1,    52,    57,    53,    -1,    -1,    55,
+      56,    -1,    55,    73,    -1,    55,    71,    -1,    55,    31,
+      -1,    55,    41,    -1,    18,    75,    78,    31,    -1,    19,
+      74,    31,    -1,    17,    31,    -1,    20,    26,    78,    31,
+      -1,    -1,    57,    40,    -1,    14,    79,    77,    -1,    76,
+      -1,    58,    61,    59,    -1,    -1,    61,    40,    -1,    61,
+      65,    -1,    61,    54,    -1,     4,    75,    31,    -1,    62,
+      72,    -1,    76,    -1,    63,    66,    64,    -1,    -1,    66,
+      40,    -1,    66,    65,    -1,    66,    54,    -1,     6,    75,
+      31,    -1,     9,    75,    31,    -1,    68,    72,    -1,    12,
+      31,    -1,    70,    13,    -1,    -1,    72,    73,    -1,    72,
+      31,    -1,    72,    41,    -1,    16,    24,    79,    31,    -1,
+      -1,    75,    78,    -1,    26,    -1,    27,    -1,     5,    31,
+      -1,     8,    31,    -1,    15,    31,    -1,    31,    -1,    77,
+      31,    -1,    -1,    14,    79,    -1,    80,    -1,    80,    34,
+      80,    -1,    80,    28,    80,    -1,    30,    79,    29,    -1,
+      35,    79,    -1,    79,    32,    79,    -1,    79,    33,    79,
+      -1,    26,    -1,    27,    -1,    -1,    26,    -1,    26,    -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
 static const yytype_uint16 yyrline[] =
 {
-       0,   104,   104,   106,   108,   109,   110,   111,   112,   113,
-     114,   118,   122,   122,   122,   122,   122,   122,   122,   126,
-     127,   128,   129,   130,   131,   135,   136,   142,   150,   156,
-     164,   174,   176,   177,   178,   179,   180,   181,   184,   192,
-     198,   208,   214,   220,   223,   225,   236,   237,   242,   251,
-     256,   264,   267,   269,   270,   271,   272,   273,   276,   282,
-     293,   299,   309,   311,   316,   324,   332,   335,   337,   338,
-     339,   344,   351,   356,   364,   367,   369,   370,   371,   374,
-     382,   389,   396,   402,   409,   411,   412,   413,   416,   424,
-     426,   431,   432,   435,   436,   437,   441,   442,   445,   446,
-     449,   450,   451,   452,   453,   454,   455,   458,   459,   462,
-     463
+       0,   106,   106,   108,   110,   111,   112,   113,   114,   115,
+     116,   120,   124,   124,   124,   124,   124,   124,   124,   128,
+     129,   130,   131,   132,   133,   137,   138,   144,   152,   158,
+     166,   176,   178,   179,   180,   181,   182,   183,   186,   194,
+     200,   210,   216,   222,   228,   231,   233,   244,   245,   250,
+     259,   264,   272,   275,   277,   278,   279,   280,   281,   284,
+     290,   301,   307,   317,   319,   324,   332,   340,   343,   345,
+     346,   347,   352,   359,   364,   372,   375,   377,   378,   379,
+     382,   390,   397,   404,   410,   417,   419,   420,   421,   424,
+     432,   434,   439,   440,   443,   444,   445,   449,   450,   453,
+     454,   457,   458,   459,   460,   461,   462,   463,   466,   467,
+     470,   471,   474
 };
 #endif
 
@@ -582,10 +585,10 @@ static const char *const yytname[] =
   "T_SOURCE", "T_CHOICE", "T_ENDCHOICE", "T_COMMENT", "T_CONFIG",
   "T_MENUCONFIG", "T_HELP", "T_HELPTEXT", "T_IF", "T_ENDIF", "T_DEPENDS",
   "T_OPTIONAL", "T_PROMPT", "T_TYPE", "T_DEFAULT", "T_SELECT", "T_RANGE",
-  "T_OPTION", "T_ON", "T_WORD", "T_WORD_QUOTE", "T_UNEQUAL",
-  "T_CLOSE_PAREN", "T_OPEN_PAREN", "T_EOL", "T_OR", "T_AND", "T_EQUAL",
-  "T_NOT", "$accept", "input", "stmt_list", "option_name", "common_stmt",
-  "option_error", "config_entry_start", "config_stmt",
+  "T_OPTION", "T_ON", "T_MODULE_NAME", "T_WORD", "T_WORD_QUOTE",
+  "T_UNEQUAL", "T_CLOSE_PAREN", "T_OPEN_PAREN", "T_EOL", "T_OR", "T_AND",
+  "T_EQUAL", "T_NOT", "$accept", "input", "stmt_list", "option_name",
+  "common_stmt", "option_error", "config_entry_start", "config_stmt",
   "menuconfig_entry_start", "menuconfig_stmt", "config_option_list",
   "config_option", "symbol_option", "symbol_option_list",
   "symbol_option_arg", "choice", "choice_entry", "choice_end",
@@ -594,7 +597,7 @@ static const char *const yytname[] =
   "menu_end", "menu_stmt", "menu_block", "source_stmt", "comment",
   "comment_stmt", "help_start", "help", "depends_list", "depends",
   "prompt_stmt_opt", "prompt", "end", "nl", "if_expr", "expr", "symbol",
-  "word_opt", 0
+  "word_opt", "module_name", 0
 };
 #endif
 
@@ -606,25 +609,25 @@ static const yytype_uint16 yytoknum[] =
        0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
      265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
      275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
-     285,   286,   287,   288,   289
+     285,   286,   287,   288,   289,   290
 };
 # endif
 
 /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
 static const yytype_uint8 yyr1[] =
 {
-       0,    35,    36,    37,    37,    37,    37,    37,    37,    37,
-      37,    37,    38,    38,    38,    38,    38,    38,    38,    39,
-      39,    39,    39,    39,    39,    40,    40,    41,    42,    43,
-      44,    45,    45,    45,    45,    45,    45,    45,    46,    46,
-      46,    46,    46,    47,    48,    48,    49,    49,    50,    51,
-      52,    53,    54,    54,    54,    54,    54,    54,    55,    55,
-      55,    55,    56,    56,    57,    58,    59,    60,    60,    60,
-      60,    61,    62,    63,    64,    65,    65,    65,    65,    66,
-      67,    68,    69,    70,    71,    71,    71,    71,    72,    73,
-      73,    74,    74,    75,    75,    75,    76,    76,    77,    77,
-      78,    78,    78,    78,    78,    78,    78,    79,    79,    80,
-      80
+       0,    36,    37,    38,    38,    38,    38,    38,    38,    38,
+      38,    38,    39,    39,    39,    39,    39,    39,    39,    40,
+      40,    40,    40,    40,    40,    41,    41,    42,    43,    44,
+      45,    46,    46,    46,    46,    46,    46,    46,    47,    47,
+      47,    47,    47,    47,    48,    49,    49,    50,    50,    51,
+      52,    53,    54,    55,    55,    55,    55,    55,    55,    56,
+      56,    56,    56,    57,    57,    58,    59,    60,    61,    61,
+      61,    61,    62,    63,    64,    65,    66,    66,    66,    66,
+      67,    68,    69,    70,    71,    72,    72,    72,    72,    73,
+      74,    74,    75,    75,    76,    76,    76,    77,    77,    78,
+      78,    79,    79,    79,    79,    79,    79,    79,    80,    80,
+      81,    81,    82
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
@@ -634,14 +637,14 @@ static const yytype_uint8 yyr2[] =
        4,     3,     1,     1,     1,     1,     1,     1,     1,     1,
        1,     1,     1,     1,     1,     3,     2,     3,     2,     3,
        2,     0,     2,     2,     2,     2,     2,     2,     3,     4,
-       4,     4,     5,     3,     0,     3,     0,     2,     3,     2,
-       1,     3,     0,     2,     2,     2,     2,     2,     4,     3,
-       2,     4,     0,     2,     3,     1,     3,     0,     2,     2,
-       2,     3,     2,     1,     3,     0,     2,     2,     2,     3,
-       3,     2,     2,     2,     0,     2,     2,     2,     4,     0,
-       2,     1,     1,     2,     2,     2,     1,     2,     0,     2,
-       1,     3,     3,     3,     2,     3,     3,     1,     1,     0,
-       1
+       4,     4,     5,     3,     3,     0,     3,     0,     2,     3,
+       2,     1,     3,     0,     2,     2,     2,     2,     2,     4,
+       3,     2,     4,     0,     2,     3,     1,     3,     0,     2,
+       2,     2,     3,     2,     1,     3,     0,     2,     2,     2,
+       3,     3,     2,     2,     2,     0,     2,     2,     2,     4,
+       0,     2,     1,     1,     2,     2,     2,     1,     2,     0,
+       2,     1,     3,     3,     3,     2,     3,     3,     1,     1,
+       0,     1,     1
 };
 
 /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
@@ -649,158 +652,161 @@ static const yytype_uint8 yyr2[] =
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       3,     0,     0,     1,     0,     0,     0,     0,     0,   109,
+       3,     0,     0,     1,     0,     0,     0,     0,     0,   110,
        0,     0,     0,     0,     0,     0,    12,    16,    13,    14,
       18,    15,    17,     0,    19,     0,     4,    31,    22,    31,
-      23,    52,    62,     5,    67,    20,    84,    75,     6,    24,
-      84,    21,     8,    11,    91,    92,     0,     0,    93,     0,
-     110,     0,    94,     0,     0,     0,   107,   108,     0,     0,
-       0,   100,    95,     0,     0,     0,     0,     0,     0,     0,
-       0,     0,     0,    96,     7,    71,    79,    48,    80,    27,
-      29,     0,   104,     0,     0,    64,     0,     0,     9,    10,
-       0,     0,     0,     0,    89,     0,     0,     0,    44,     0,
-      37,    36,    32,    33,     0,    35,    34,     0,     0,    89,
-       0,    56,    57,    53,    55,    54,    63,    51,    50,    68,
-      70,    66,    69,    65,    86,    87,    85,    76,    78,    74,
-      77,    73,    97,   103,   105,   106,   102,   101,    26,    82,
-       0,    98,     0,    98,    98,    98,     0,     0,     0,    83,
-      60,    98,     0,    98,     0,     0,     0,    38,    90,     0,
-       0,    98,    46,    43,    25,     0,    59,     0,    88,    99,
-      39,    40,    41,     0,     0,    45,    58,    61,    42,    47
+      23,    53,    63,     5,    68,    20,    85,    76,     6,    24,
+      85,    21,     8,    11,    92,    93,     0,     0,    94,     0,
+     111,     0,    95,     0,     0,     0,   108,   109,     0,     0,
+       0,   101,    96,     0,     0,     0,     0,     0,     0,     0,
+       0,     0,     0,    97,     7,    72,    80,    49,    81,    27,
+      29,     0,   105,     0,     0,    65,     0,     0,     9,    10,
+       0,     0,     0,     0,    90,     0,     0,     0,    45,     0,
+       0,    37,    36,    32,    33,     0,    35,    34,     0,     0,
+      90,     0,    57,    58,    54,    56,    55,    64,    52,    51,
+      69,    71,    67,    70,    66,    87,    88,    86,    77,    79,
+      75,    78,    74,    98,   104,   106,   107,   103,   102,    26,
+      83,     0,    99,     0,    99,    99,    99,     0,     0,   112,
+       0,     0,    84,    61,    99,     0,    99,     0,     0,     0,
+      38,    91,     0,     0,    99,    47,    44,    43,    25,     0,
+      60,     0,    89,   100,    39,    40,    41,     0,     0,    46,
+      59,    62,    42,    48
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int16 yydefgoto[] =
 {
-      -1,     1,     2,    25,    26,   101,    27,    28,    29,    30,
-      65,   102,   103,   147,   175,    31,    32,   117,    33,    67,
-     113,    68,    34,   121,    35,    69,    36,    37,   129,    38,
-      71,    39,    40,    41,   104,   105,    70,   106,   142,   143,
-      42,    74,   156,    60,    61,    51
+      -1,     1,     2,    25,    26,   102,    27,    28,    29,    30,
+      65,   103,   104,   148,   179,    31,    32,   118,    33,    67,
+     114,    68,    34,   122,    35,    69,    36,    37,   130,    38,
+      71,    39,    40,    41,   105,   106,    70,   107,   143,   144,
+      42,    74,   159,    60,    61,    51,   150
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -80
+#define YYPACT_NINF -83
 static const yytype_int16 yypact[] =
 {
-     -80,     2,   132,   -80,   -13,    -1,    -1,    -2,    -1,     9,
-      33,    -1,    27,    40,    -3,    38,   -80,   -80,   -80,   -80,
-     -80,   -80,   -80,    71,   -80,    77,   -80,   -80,   -80,   -80,
-     -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,
-     -80,   -80,   -80,   -80,   -80,   -80,    57,    61,   -80,    63,
-     -80,    76,   -80,    87,   101,   133,   -80,   -80,    -3,    -3,
-     195,    -6,   -80,   136,   149,    39,   104,    65,   150,     5,
-     194,     5,   167,   -80,   176,   -80,   -80,   -80,   -80,   -80,
-     -80,    68,   -80,    -3,    -3,   176,    72,    72,   -80,   -80,
-     177,   187,    78,    -1,    -1,    -3,   196,    72,   -80,   222,
-     -80,   -80,   -80,   -80,   221,   -80,   -80,   205,    -1,    -1,
-     211,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,
-     -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,
-     -80,   -80,   -80,   -80,   206,   -80,   -80,   -80,   -80,   -80,
-      -3,   223,   209,   223,   197,   223,    72,     7,   210,   -80,
-     -80,   223,   212,   223,   201,    -3,   213,   -80,   -80,   214,
-     215,   223,   208,   -80,   -80,   216,   -80,   217,   -80,   113,
-     -80,   -80,   -80,   218,    -1,   -80,   -80,   -80,   -80,   -80
+     -83,     2,    20,   -83,    12,   -15,   -15,    51,   -15,    21,
+      55,   -15,    63,    77,   -17,    98,   -83,   -83,   -83,   -83,
+     -83,   -83,   -83,   156,   -83,   165,   -83,   -83,   -83,   -83,
+     -83,   -83,   -83,   -83,   -83,   -83,   -83,   -83,   -83,   -83,
+     -83,   -83,   -83,   -83,   -83,   -83,   148,   160,   -83,   162,
+     -83,   163,   -83,   175,   176,   180,   -83,   -83,   -17,   -17,
+     131,   -12,   -83,   183,   188,    52,   105,   166,   207,    87,
+     194,    87,   134,   -83,   192,   -83,   -83,   -83,   -83,   -83,
+     -83,    47,   -83,   -17,   -17,   192,   106,   106,   -83,   -83,
+     193,   195,   172,   -15,   -15,   -17,   204,   106,   -83,   205,
+     231,   -83,   -83,   -83,   -83,   220,   -83,   -83,   203,   -15,
+     -15,   209,   -83,   -83,   -83,   -83,   -83,   -83,   -83,   -83,
+     -83,   -83,   -83,   -83,   -83,   -83,   -83,   -83,   -83,   -83,
+     -83,   -83,   -83,   -83,   -83,   208,   -83,   -83,   -83,   -83,
+     -83,   -17,   222,   211,   222,    67,   222,   106,    23,   -83,
+     212,   213,   -83,   -83,   222,   214,   222,   137,   -17,   215,
+     -83,   -83,   217,   218,   222,   206,   -83,   -83,   -83,   219,
+     -83,   221,   -83,   114,   -83,   -83,   -83,   223,   -15,   -83,
+     -83,   -83,   -83,   -83
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int16 yypgoto[] =
 {
-     -80,   -80,   -80,   -80,   122,   -34,   -80,   -80,   -80,   -80,
-     220,   -80,   -80,   -80,   -80,   -80,   -80,   -80,    59,   -80,
-     -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   -80,   125,
-     -80,   -80,   -80,   -80,   -80,   183,   219,    22,   142,    -5,
-     147,   192,    69,   -54,   -79,   -80
+     -83,   -83,   -83,   -83,    16,   -53,   -83,   -83,   -83,   -83,
+     224,   -83,   -83,   -83,   -83,   -83,   -83,   -83,   118,   -83,
+     -83,   -83,   -83,   -83,   -83,   -83,   -83,   -83,   -83,   119,
+     -83,   -83,   -83,   -83,   -83,   184,   216,   -22,   145,    -5,
+      90,   197,    83,   -51,   -82,   -83,   -83
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
    positive, shift that token.  If negative, reduce the rule which
    number is the opposite.  If zero, do what YYDEFACT says.
    If YYTABLE_NINF, syntax error.  */
-#define YYTABLE_NINF -82
+#define YYTABLE_NINF -83
 static const yytype_int16 yytable[] =
 {
-      46,    47,     3,    49,    81,    82,    53,   136,   137,     6,
-       7,     8,     9,    10,    11,    12,    13,    43,   146,    14,
-      15,    86,    56,    57,    44,    45,    58,    87,    48,   134,
-     135,    59,   162,   112,    50,    24,   125,   163,   125,   -28,
-      90,   144,   -28,   -28,   -28,   -28,   -28,   -28,   -28,   -28,
-     -28,    91,    54,   -28,   -28,    92,   -28,    93,    94,    95,
-      96,    97,    98,    52,    99,    55,    90,   161,    62,   100,
-     -49,   -49,    63,   -49,   -49,   -49,   -49,    91,    64,   -49,
-     -49,    92,   107,   108,   109,   110,   154,    73,   141,   115,
-      99,    75,   126,    76,   126,   111,   133,    56,    57,    83,
-      84,   169,   140,   151,   -30,    90,    77,   -30,   -30,   -30,
-     -30,   -30,   -30,   -30,   -30,   -30,    91,    78,   -30,   -30,
-      92,   -30,    93,    94,    95,    96,    97,    98,   120,    99,
-     128,    79,    -2,     4,   100,     5,     6,     7,     8,     9,
-      10,    11,    12,    13,    83,    84,    14,    15,    16,    17,
-      18,    19,    20,    21,    22,     7,     8,    23,    10,    11,
-      12,    13,    24,    80,    14,    15,    88,   -81,    90,   179,
-     -81,   -81,   -81,   -81,   -81,   -81,   -81,   -81,   -81,    89,
-      24,   -81,   -81,    92,   -81,   -81,   -81,   -81,   -81,   -81,
-     116,   119,    99,   127,   122,    90,   130,   124,   -72,   -72,
-     -72,   -72,   -72,   -72,   -72,   -72,   132,   138,   -72,   -72,
-      92,   155,   158,   159,   160,   118,   123,   139,   131,    99,
-     165,   145,   167,   148,   124,    73,    83,    84,    83,    84,
-     173,   168,    83,    84,   149,   150,   153,   155,    84,   157,
-     164,   174,   166,   170,   171,   172,   176,   177,   178,    66,
-     114,   152,    85,     0,     0,     0,     0,     0,     0,    72
+      46,    47,     3,    49,   137,   138,    53,    81,    82,    56,
+      57,    44,    45,    58,   113,   147,    86,   126,    59,   126,
+      -2,     4,    87,     5,     6,     7,     8,     9,    10,    11,
+      12,    13,   135,   136,    14,    15,    16,    17,    18,    19,
+      20,    21,    22,    43,   145,   116,    23,    50,   127,   165,
+     127,    24,   -28,    90,   166,   -28,   -28,   -28,   -28,   -28,
+     -28,   -28,   -28,   -28,    91,   164,   -28,   -28,    92,   -28,
+      93,    94,    95,    96,    97,    98,   134,    99,   100,    83,
+      84,   158,    48,   101,   117,   120,    52,   128,   142,    54,
+     157,     6,     7,     8,     9,    10,    11,    12,    13,    83,
+      84,    14,    15,    55,   154,   -30,    90,   173,   -30,   -30,
+     -30,   -30,   -30,   -30,   -30,   -30,   -30,    91,    24,   -30,
+     -30,    92,   -30,    93,    94,    95,    96,    97,    98,    62,
+      99,   100,    56,    57,   -82,    90,   101,   -82,   -82,   -82,
+     -82,   -82,   -82,   -82,   -82,   -82,    83,    84,   -82,   -82,
+      92,   -82,   -82,   -82,   -82,   -82,   -82,    63,   119,   124,
+     100,   132,    73,    83,    84,   125,    64,    90,   172,    83,
+      84,   -50,   -50,   183,   -50,   -50,   -50,   -50,    91,    73,
+     -50,   -50,    92,   108,   109,   110,   111,   121,   123,   129,
+     131,    75,   100,    76,    77,    90,   141,   112,   -73,   -73,
+     -73,   -73,   -73,   -73,   -73,   -73,    78,    79,   -73,   -73,
+      92,    80,     7,     8,    88,    10,    11,    12,    13,    89,
+     100,    14,    15,   133,   139,   125,   140,   161,   162,   163,
+     146,   149,   151,   152,   153,   156,   158,   169,    24,   171,
+     178,    84,   160,   167,   168,   170,   174,   177,   175,   176,
+     180,   115,   181,    66,   182,   155,    72,    85
 };
 
-static const yytype_int16 yycheck[] =
+static const yytype_uint8 yycheck[] =
 {
-       5,     6,     0,     8,    58,    59,    11,    86,    87,     4,
-       5,     6,     7,     8,     9,    10,    11,    30,    97,    14,
-      15,    27,    25,    26,    25,    26,    29,    33,    30,    83,
-      84,    34,    25,    67,    25,    30,    70,    30,    72,     0,
-       1,    95,     3,     4,     5,     6,     7,     8,     9,    10,
-      11,    12,    25,    14,    15,    16,    17,    18,    19,    20,
-      21,    22,    23,    30,    25,    25,     1,   146,    30,    30,
-       5,     6,     1,     8,     9,    10,    11,    12,     1,    14,
-      15,    16,    17,    18,    19,    20,   140,    30,    93,    67,
-      25,    30,    70,    30,    72,    30,    28,    25,    26,    31,
-      32,   155,    24,   108,     0,     1,    30,     3,     4,     5,
-       6,     7,     8,     9,    10,    11,    12,    30,    14,    15,
-      16,    17,    18,    19,    20,    21,    22,    23,    69,    25,
-      71,    30,     0,     1,    30,     3,     4,     5,     6,     7,
-       8,     9,    10,    11,    31,    32,    14,    15,    16,    17,
-      18,    19,    20,    21,    22,     5,     6,    25,     8,     9,
-      10,    11,    30,    30,    14,    15,    30,     0,     1,   174,
-       3,     4,     5,     6,     7,     8,     9,    10,    11,    30,
-      30,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      68,    69,    25,    71,    69,     1,    71,    30,     4,     5,
-       6,     7,     8,     9,    10,    11,    30,    30,    14,    15,
-      16,    14,   143,   144,   145,    68,    69,    30,    71,    25,
-     151,    25,   153,     1,    30,    30,    31,    32,    31,    32,
-     161,    30,    31,    32,    13,    30,    25,    14,    32,    30,
-      30,    33,    30,    30,    30,    30,    30,    30,    30,    29,
-      67,   109,    60,    -1,    -1,    -1,    -1,    -1,    -1,    40
+       5,     6,     0,     8,    86,    87,    11,    58,    59,    26,
+      27,    26,    27,    30,    67,    97,    28,    70,    35,    72,
+       0,     1,    34,     3,     4,     5,     6,     7,     8,     9,
+      10,    11,    83,    84,    14,    15,    16,    17,    18,    19,
+      20,    21,    22,    31,    95,    67,    26,    26,    70,    26,
+      72,    31,     0,     1,    31,     3,     4,     5,     6,     7,
+       8,     9,    10,    11,    12,   147,    14,    15,    16,    17,
+      18,    19,    20,    21,    22,    23,    29,    25,    26,    32,
+      33,    14,    31,    31,    68,    69,    31,    71,    93,    26,
+     141,     4,     5,     6,     7,     8,     9,    10,    11,    32,
+      33,    14,    15,    26,   109,     0,     1,   158,     3,     4,
+       5,     6,     7,     8,     9,    10,    11,    12,    31,    14,
+      15,    16,    17,    18,    19,    20,    21,    22,    23,    31,
+      25,    26,    26,    27,     0,     1,    31,     3,     4,     5,
+       6,     7,     8,     9,    10,    11,    32,    33,    14,    15,
+      16,    17,    18,    19,    20,    21,    22,     1,    68,    69,
+      26,    71,    31,    32,    33,    31,     1,     1,    31,    32,
+      33,     5,     6,   178,     8,     9,    10,    11,    12,    31,
+      14,    15,    16,    17,    18,    19,    20,    69,    69,    71,
+      71,    31,    26,    31,    31,     1,    24,    31,     4,     5,
+       6,     7,     8,     9,    10,    11,    31,    31,    14,    15,
+      16,    31,     5,     6,    31,     8,     9,    10,    11,    31,
+      26,    14,    15,    31,    31,    31,    31,   144,   145,   146,
+      26,    26,     1,    13,    31,    26,    14,   154,    31,   156,
+      34,    33,    31,    31,    31,    31,    31,   164,    31,    31,
+      31,    67,    31,    29,    31,   110,    40,    60
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
    symbol of state STATE-NUM.  */
 static const yytype_uint8 yystos[] =
 {
-       0,    36,    37,     0,     1,     3,     4,     5,     6,     7,
+       0,    37,    38,     0,     1,     3,     4,     5,     6,     7,
        8,     9,    10,    11,    14,    15,    16,    17,    18,    19,
-      20,    21,    22,    25,    30,    38,    39,    41,    42,    43,
-      44,    50,    51,    53,    57,    59,    61,    62,    64,    66,
-      67,    68,    75,    30,    25,    26,    74,    74,    30,    74,
-      25,    80,    30,    74,    25,    25,    25,    26,    29,    34,
-      78,    79,    30,     1,     1,    45,    45,    54,    56,    60,
-      71,    65,    71,    30,    76,    30,    30,    30,    30,    30,
-      30,    78,    78,    31,    32,    76,    27,    33,    30,    30,
+      20,    21,    22,    26,    31,    39,    40,    42,    43,    44,
+      45,    51,    52,    54,    58,    60,    62,    63,    65,    67,
+      68,    69,    76,    31,    26,    27,    75,    75,    31,    75,
+      26,    81,    31,    75,    26,    26,    26,    27,    30,    35,
+      79,    80,    31,     1,     1,    46,    46,    55,    57,    61,
+      72,    66,    72,    31,    77,    31,    31,    31,    31,    31,
+      31,    79,    79,    32,    33,    77,    28,    34,    31,    31,
        1,    12,    16,    18,    19,    20,    21,    22,    23,    25,
-      30,    40,    46,    47,    69,    70,    72,    17,    18,    19,
-      20,    30,    40,    55,    70,    72,    39,    52,    75,    39,
-      53,    58,    64,    75,    30,    40,    72,    39,    53,    63,
-      64,    75,    30,    28,    78,    78,    79,    79,    30,    30,
-      24,    74,    73,    74,    78,    25,    79,    48,     1,    13,
-      30,    74,    73,    25,    78,    14,    77,    30,    77,    77,
-      77,    79,    25,    30,    30,    77,    30,    77,    30,    78,
-      30,    30,    30,    77,    33,    49,    30,    30,    30,    74
+      26,    31,    41,    47,    48,    70,    71,    73,    17,    18,
+      19,    20,    31,    41,    56,    71,    73,    40,    53,    76,
+      40,    54,    59,    65,    76,    31,    41,    73,    40,    54,
+      64,    65,    76,    31,    29,    79,    79,    80,    80,    31,
+      31,    24,    75,    74,    75,    79,    26,    80,    49,    26,
+      82,     1,    13,    31,    75,    74,    26,    79,    14,    78,
+      31,    78,    78,    78,    80,    26,    31,    31,    31,    78,
+      31,    78,    31,    79,    31,    31,    31,    78,    34,    50,
+      31,    31,    31,    75
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -1308,7 +1314,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 
   switch (yytype)
     {
-      case 51: /* "choice_entry" */
+      case 52: /* "choice_entry" */
 
 	{
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
@@ -1318,7 +1324,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 };
 
 	break;
-      case 57: /* "if_entry" */
+      case 58: /* "if_entry" */
 
 	{
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
@@ -1328,7 +1334,7 @@ yydestruct (yymsg, yytype, yyvaluep)
 };
 
 	break;
-      case 62: /* "menu_entry" */
+      case 63: /* "menu_entry" */
 
 	{
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
@@ -1762,7 +1768,15 @@ yyreduce:
 ;}
     break;
 
-  case 45:
+  case 43:
+
+    {
+	menu_add_module_name((yyvsp[(2) - (3)].string));
+	printd(DEBUG_PARSE, "%s:%d:module_name\n", zconf_curname(), zconf_lineno());
+;}
+    break;
+
+  case 46:
 
     {
 	struct kconf_id *id = kconf_id_lookup((yyvsp[(2) - (3)].string), strlen((yyvsp[(2) - (3)].string)));
@@ -1774,17 +1788,17 @@ yyreduce:
 ;}
     break;
 
-  case 46:
+  case 47:
 
     { (yyval.string) = NULL; ;}
     break;
 
-  case 47:
+  case 48:
 
     { (yyval.string) = (yyvsp[(2) - (2)].string); ;}
     break;
 
-  case 48:
+  case 49:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), SYMBOL_CHOICE);
@@ -1795,14 +1809,14 @@ yyreduce:
 ;}
     break;
 
-  case 49:
+  case 50:
 
     {
 	(yyval.menu) = menu_add_menu();
 ;}
     break;
 
-  case 50:
+  case 51:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_CHOICE, T_ENDCHOICE)) {
@@ -1812,7 +1826,7 @@ yyreduce:
 ;}
     break;
 
-  case 58:
+  case 59:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
@@ -1820,7 +1834,7 @@ yyreduce:
 ;}
     break;
 
-  case 59:
+  case 60:
 
     {
 	if ((yyvsp[(1) - (3)].id)->stype == S_BOOLEAN || (yyvsp[(1) - (3)].id)->stype == S_TRISTATE) {
@@ -1833,7 +1847,7 @@ yyreduce:
 ;}
     break;
 
-  case 60:
+  case 61:
 
     {
 	current_entry->sym->flags |= SYMBOL_OPTIONAL;
@@ -1841,7 +1855,7 @@ yyreduce:
 ;}
     break;
 
-  case 61:
+  case 62:
 
     {
 	if ((yyvsp[(1) - (4)].id)->stype == S_UNKNOWN) {
@@ -1853,7 +1867,7 @@ yyreduce:
 ;}
     break;
 
-  case 64:
+  case 65:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:if\n", zconf_curname(), zconf_lineno());
@@ -1863,7 +1877,7 @@ yyreduce:
 ;}
     break;
 
-  case 65:
+  case 66:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_IF, T_ENDIF)) {
@@ -1873,7 +1887,7 @@ yyreduce:
 ;}
     break;
 
-  case 71:
+  case 72:
 
     {
 	menu_add_entry(NULL);
@@ -1882,14 +1896,14 @@ yyreduce:
 ;}
     break;
 
-  case 72:
+  case 73:
 
     {
 	(yyval.menu) = menu_add_menu();
 ;}
     break;
 
-  case 73:
+  case 74:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_MENU, T_ENDMENU)) {
@@ -1899,7 +1913,7 @@ yyreduce:
 ;}
     break;
 
-  case 79:
+  case 80:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:source %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
@@ -1907,7 +1921,7 @@ yyreduce:
 ;}
     break;
 
-  case 80:
+  case 81:
 
     {
 	menu_add_entry(NULL);
@@ -1916,14 +1930,14 @@ yyreduce:
 ;}
     break;
 
-  case 81:
+  case 82:
 
     {
 	menu_end_entry();
 ;}
     break;
 
-  case 82:
+  case 83:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:help\n", zconf_curname(), zconf_lineno());
@@ -1931,14 +1945,14 @@ yyreduce:
 ;}
     break;
 
-  case 83:
+  case 84:
 
     {
 	current_entry->help = (yyvsp[(2) - (2)].string);
 ;}
     break;
 
-  case 88:
+  case 89:
 
     {
 	menu_add_dep((yyvsp[(3) - (4)].expr));
@@ -1946,88 +1960,93 @@ yyreduce:
 ;}
     break;
 
-  case 90:
+  case 91:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].expr));
 ;}
     break;
 
-  case 93:
+  case 94:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 94:
+  case 95:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 95:
+  case 96:
 
     { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
     break;
 
-  case 98:
+  case 99:
 
     { (yyval.expr) = NULL; ;}
     break;
 
-  case 99:
+  case 100:
 
     { (yyval.expr) = (yyvsp[(2) - (2)].expr); ;}
     break;
 
-  case 100:
+  case 101:
 
     { (yyval.expr) = expr_alloc_symbol((yyvsp[(1) - (1)].symbol)); ;}
     break;
 
-  case 101:
+  case 102:
 
     { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
     break;
 
-  case 102:
+  case 103:
 
     { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
     break;
 
-  case 103:
+  case 104:
 
     { (yyval.expr) = (yyvsp[(2) - (3)].expr); ;}
     break;
 
-  case 104:
+  case 105:
 
     { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[(2) - (2)].expr)); ;}
     break;
 
-  case 105:
+  case 106:
 
     { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
     break;
 
-  case 106:
+  case 107:
 
     { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
     break;
 
-  case 107:
+  case 108:
 
     { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), 0); free((yyvsp[(1) - (1)].string)); ;}
     break;
 
-  case 108:
+  case 109:
 
     { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), SYMBOL_CONST); free((yyvsp[(1) - (1)].string)); ;}
     break;
 
-  case 109:
+  case 110:
 
     { (yyval.string) = NULL; ;}
     break;
 
+  case 112:
+
+    { (yyval.string) = (yyvsp[(1) - (1)].string) ;}
+    break;
+
 
 /* Line 1267 of yacc.c.  */
 
diff -puN scripts/kconfig/zconf.y~kconfig-add-module_name-shortcut scripts/kconfig/zconf.y
--- a/scripts/kconfig/zconf.y~kconfig-add-module_name-shortcut
+++ a/scripts/kconfig/zconf.y
@@ -72,6 +72,7 @@ static struct menu *current_menu, *curre
 %token <id>T_RANGE
 %token <id>T_OPTION
 %token <id>T_ON
+%token <id>T_MODULE_NAME
 %token <string> T_WORD
 %token <string> T_WORD_QUOTE
 %token T_UNEQUAL
@@ -90,6 +91,7 @@ static struct menu *current_menu, *curre
 %type <expr> if_expr
 %type <id> end
 %type <id> option_name
+%type <string> module_name
 %type <menu> if_entry menu_entry choice_entry
 %type <string> symbol_option_arg word_opt
 
@@ -217,6 +219,12 @@ config_option: T_RANGE symbol symbol if_
 	printd(DEBUG_PARSE, "%s:%d:range\n", zconf_curname(), zconf_lineno());
 };
 
+config_option: T_MODULE_NAME module_name T_EOL
+{
+	menu_add_module_name($2);
+	printd(DEBUG_PARSE, "%s:%d:module_name\n", zconf_curname(), zconf_lineno());
+};
+
 symbol_option: T_OPTION symbol_option_list T_EOL
 ;
 
@@ -461,6 +469,10 @@ symbol:	  T_WORD	{ $$ = sym_lookup($1, 0
 
 word_opt: /* empty */			{ $$ = NULL; }
 	| T_WORD
+;
+
+module_name:	T_WORD	{ $$ = $1 }
+;
 
 %%
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
kconfig-add-module_name-shortcut.patch
proc-move-inode-comment-text-file-to-source-file.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
remove-remaining-unwinder-code.patch
remove-linux-hardirqh-from-asm-generic-localh-fix.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
sm501-fix-section-mismatches.patch
ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch

