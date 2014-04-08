From: akpm@linux-foundation.org
Subject: [merged]
 kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:33:53 -0700
Message-ID: <53446b41.bLDqqbXFuyEqKevG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580AbaDHVdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, mmarek@suse.cz, josh@joshtriplett.org

Subject: [merged] kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch removed from -mm tree
To: josh@joshtriplett.org,mmarek@suse.cz,paulmck@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:33:53 -0700


The patch titled
     Subject: kconfig: make allnoconfig disable options behind EMBEDDED and EXPERT
has been removed from the -mm tree.  Its filename was
     kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: kconfig: make allnoconfig disable options behind EMBEDDED and EXPERT

"make allnoconfig" exists to ease testing of minimal configurations. 
Documentation/SubmitChecklist includes a note to test with allnoconfig. 
This helps catch missing dependencies on common-but-not-required
functionality, which might otherwise go unnoticed.

However, allnoconfig still leaves many symbols enabled, because they're
hidden behind CONFIG_EMBEDDED or CONFIG_EXPERT.  For instance, allnoconfig
still has CONFIG_PRINTK and CONFIG_BLOCK enabled, so drivers don't
typically get build-tested with those disabled.

To address this, introduce a new Kconfig option "allnoconfig_y", used on
symbols which only exist to hide other symbols.  Set it on CONFIG_EMBEDDED
(which then selects CONFIG_EXPERT).  allnoconfig will then disable all the
symbols hidden behind those.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/kconfig-language.txt |    4 ++++
 init/Kconfig                              |    1 +
 scripts/kconfig/confdata.c                |    5 ++++-
 scripts/kconfig/expr.h                    |    3 +++
 scripts/kconfig/lkc.h                     |    1 +
 scripts/kconfig/menu.c                    |    3 +++
 scripts/kconfig/zconf.gperf               |    1 +
 scripts/kconfig/zconf.hash.c_shipped      |   13 ++++++++-----
 8 files changed, 25 insertions(+), 6 deletions(-)

diff -puN Documentation/kbuild/kconfig-language.txt~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert Documentation/kbuild/kconfig-language.txt
--- a/Documentation/kbuild/kconfig-language.txt~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert
+++ a/Documentation/kbuild/kconfig-language.txt
@@ -157,6 +157,10 @@ applicable everywhere (see syntax).
     to the build environment (if this is desired, it can be done via
     another symbol).
 
+  - "allnoconfig_y"
+    This declares the symbol as one that should have the value y when
+    using "allnoconfig". Used for symbols that hide other symbols.
+
 Menu dependencies
 -----------------
 
diff -puN init/Kconfig~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert init/Kconfig
--- a/init/Kconfig~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert
+++ a/init/Kconfig
@@ -1483,6 +1483,7 @@ config PCI_QUIRKS
 
 config EMBEDDED
 	bool "Embedded system"
+	option allnoconfig_y
 	select EXPERT
 	help
 	  This option should be enabled if compiling the kernel for
diff -puN scripts/kconfig/confdata.c~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert
+++ a/scripts/kconfig/confdata.c
@@ -1178,7 +1178,10 @@ bool conf_set_all_new_symbols(enum conf_
 				sym->def[S_DEF_USER].tri = mod;
 				break;
 			case def_no:
-				sym->def[S_DEF_USER].tri = no;
+				if (sym->flags & SYMBOL_ALLNOCONFIG_Y)
+					sym->def[S_DEF_USER].tri = yes;
+				else
+					sym->def[S_DEF_USER].tri = no;
 				break;
 			case def_random:
 				sym->def[S_DEF_USER].tri = no;
diff -puN scripts/kconfig/expr.h~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert scripts/kconfig/expr.h
--- a/scripts/kconfig/expr.h~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert
+++ a/scripts/kconfig/expr.h
@@ -109,6 +109,9 @@ struct symbol {
 /* choice values need to be set before calculating this symbol value */
 #define SYMBOL_NEED_SET_CHOICE_VALUES  0x100000
 
+/* Set symbol to y if allnoconfig; used for symbols that hide others */
+#define SYMBOL_ALLNOCONFIG_Y 0x200000
+
 #define SYMBOL_MAXLENGTH	256
 #define SYMBOL_HASHSIZE		9973
 
diff -puN scripts/kconfig/lkc.h~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert scripts/kconfig/lkc.h
--- a/scripts/kconfig/lkc.h~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert
+++ a/scripts/kconfig/lkc.h
@@ -61,6 +61,7 @@ enum conf_def_mode {
 #define T_OPT_MODULES		1
 #define T_OPT_DEFCONFIG_LIST	2
 #define T_OPT_ENV		3
+#define T_OPT_ALLNOCONFIG_Y	4
 
 struct kconf_id {
 	int name;
diff -puN scripts/kconfig/menu.c~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert scripts/kconfig/menu.c
--- a/scripts/kconfig/menu.c~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert
+++ a/scripts/kconfig/menu.c
@@ -217,6 +217,9 @@ void menu_add_option(int token, char *ar
 	case T_OPT_ENV:
 		prop_add_env(arg);
 		break;
+	case T_OPT_ALLNOCONFIG_Y:
+		current_entry->sym->flags |= SYMBOL_ALLNOCONFIG_Y;
+		break;
 	}
 }
 
diff -puN scripts/kconfig/zconf.gperf~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert scripts/kconfig/zconf.gperf
--- a/scripts/kconfig/zconf.gperf~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert
+++ a/scripts/kconfig/zconf.gperf
@@ -44,4 +44,5 @@ on,		T_ON,		TF_PARAM
 modules,	T_OPT_MODULES,	TF_OPTION
 defconfig_list,	T_OPT_DEFCONFIG_LIST,TF_OPTION
 env,		T_OPT_ENV,	TF_OPTION
+allnoconfig_y,	T_OPT_ALLNOCONFIG_Y,TF_OPTION
 %%
diff -puN scripts/kconfig/zconf.hash.c_shipped~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert scripts/kconfig/zconf.hash.c_shipped
--- a/scripts/kconfig/zconf.hash.c_shipped~kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert
+++ a/scripts/kconfig/zconf.hash.c_shipped
@@ -55,10 +55,10 @@ kconf_id_hash (register const char *str,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 25, 25,
+      73, 73, 73, 73, 73, 73, 73,  5, 25, 25,
        0,  0,  0,  5,  0,  0, 73, 73,  5,  0,
       10,  5, 45, 73, 20, 20,  0, 15, 15, 73,
-      20, 73, 73, 73, 73, 73, 73, 73, 73, 73,
+      20,  5, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
@@ -106,6 +106,7 @@ struct kconf_id_strings_t
     char kconf_id_strings_str23[sizeof("mainmenu")];
     char kconf_id_strings_str25[sizeof("menuconfig")];
     char kconf_id_strings_str27[sizeof("modules")];
+    char kconf_id_strings_str28[sizeof("allnoconfig_y")];
     char kconf_id_strings_str29[sizeof("menu")];
     char kconf_id_strings_str31[sizeof("select")];
     char kconf_id_strings_str32[sizeof("comment")];
@@ -141,6 +142,7 @@ static const struct kconf_id_strings_t k
     "mainmenu",
     "menuconfig",
     "modules",
+    "allnoconfig_y",
     "menu",
     "select",
     "comment",
@@ -170,7 +172,7 @@ kconf_id_lookup (register const char *st
 {
   enum
     {
-      TOTAL_KEYWORDS = 32,
+      TOTAL_KEYWORDS = 33,
       MIN_WORD_LENGTH = 2,
       MAX_WORD_LENGTH = 14,
       MIN_HASH_VALUE = 2,
@@ -219,7 +221,8 @@ kconf_id_lookup (register const char *st
       {-1},
 #line 44 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
-      {-1},
+#line 47 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,	T_OPT_ALLNOCONFIG_Y,TF_OPTION},
 #line 16 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str29,		T_MENU,		TF_COMMAND},
       {-1},
@@ -282,5 +285,5 @@ kconf_id_lookup (register const char *st
     }
   return 0;
 }
-#line 47 "scripts/kconfig/zconf.gperf"
+#line 48 "scripts/kconfig/zconf.gperf"
 
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch

