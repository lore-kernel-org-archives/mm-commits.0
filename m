From: akpm@linux-foundation.org
Subject: - fix-race-between-rmmod-and-cat-proc-kallsyms.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:45 -0700
Message-ID: <200705090248.l492mj0C009145@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967361AbXEICtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, bunk@stusta.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Fix race between rmmod and cat /proc/kallsyms
has been removed from the -mm tree.  Its filename was
     fix-race-between-rmmod-and-cat-proc-kallsyms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix race between rmmod and cat /proc/kallsyms
From: Alexey Dobriyan <adobriyan@sw.ru>

module_get_kallsym() leaks "struct module *" outside of module_mutex which is
no-no, because module can dissapear right after mutex unlock.

Copy all needed information from inside module_mutex into caller-supplied
space.

[bunk@stusta.de: is_exported() can now become static]
Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |   21 +++++++--------------
 kernel/kallsyms.c      |   30 +++++++++++++++---------------
 kernel/module.c        |   12 +++++++-----
 3 files changed, 29 insertions(+), 34 deletions(-)

diff -puN include/linux/module.h~fix-race-between-rmmod-and-cat-proc-kallsyms include/linux/module.h
--- a/include/linux/module.h~fix-race-between-rmmod-and-cat-proc-kallsyms
+++ a/include/linux/module.h
@@ -370,16 +370,14 @@ struct module *module_text_address(unsig
 struct module *__module_text_address(unsigned long addr);
 int is_module_address(unsigned long addr);
 
-/* Returns module and fills in value, defined and namebuf, or NULL if
+/* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
-struct module *module_get_kallsym(unsigned int symnum, unsigned long *value,
-				char *type, char *name);
+int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
+			char *name, char *module_name, int *exported);
 
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
 
-int is_exported(const char *name, const struct module *mod);
-
 extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
@@ -527,11 +525,11 @@ static inline const char *module_address
 	return NULL;
 }
 
-static inline struct module *module_get_kallsym(unsigned int symnum,
-						unsigned long *value,
-						char *type, char *name)
+static inline int module_get_kallsym(unsigned int symnum, unsigned long *value,
+					char *type, char *name,
+					char *module_name, int *exported)
 {
-	return NULL;
+	return -ERANGE;
 }
 
 static inline unsigned long module_kallsyms_lookup_name(const char *name)
@@ -539,11 +537,6 @@ static inline unsigned long module_kalls
 	return 0;
 }
 
-static inline int is_exported(const char *name, const struct module *mod)
-{
-	return 0;
-}
-
 static inline int register_module_notifier(struct notifier_block * nb)
 {
 	/* no events will happen anyway, so this can always succeed */
diff -puN kernel/kallsyms.c~fix-race-between-rmmod-and-cat-proc-kallsyms kernel/kallsyms.c
--- a/kernel/kallsyms.c~fix-race-between-rmmod-and-cat-proc-kallsyms
+++ a/kernel/kallsyms.c
@@ -301,25 +301,20 @@ void __print_symbol(const char *fmt, uns
 struct kallsym_iter
 {
 	loff_t pos;
-	struct module *owner;
 	unsigned long value;
 	unsigned int nameoff; /* If iterating in core kernel symbols */
 	char type;
 	char name[KSYM_NAME_LEN+1];
+	char module_name[MODULE_NAME_LEN + 1];
+	int exported;
 };
 
 static int get_ksymbol_mod(struct kallsym_iter *iter)
 {
-	iter->owner = module_get_kallsym(iter->pos - kallsyms_num_syms,
-					 &iter->value, &iter->type,
-					 iter->name);
-	if (iter->owner == NULL)
+	if (module_get_kallsym(iter->pos - kallsyms_num_syms, &iter->value,
+				&iter->type, iter->name, iter->module_name,
+				&iter->exported) < 0)
 		return 0;
-
-	/* Label it "global" if it is exported, "local" if not exported. */
-	iter->type = is_exported(iter->name, iter->owner)
-		? toupper(iter->type) : tolower(iter->type);
-
 	return 1;
 }
 
@@ -328,7 +323,7 @@ static unsigned long get_ksymbol_core(st
 {
 	unsigned off = iter->nameoff;
 
-	iter->owner = NULL;
+	iter->module_name[0] = '\0';
 	iter->value = kallsyms_addresses[iter->pos];
 
 	iter->type = kallsyms_get_symbol_type(off);
@@ -392,12 +387,17 @@ static int s_show(struct seq_file *m, vo
 	if (!iter->name[0])
 		return 0;
 
-	if (iter->owner)
+	if (iter->module_name[0]) {
+		char type;
+
+		/* Label it "global" if it is exported,
+		 * "local" if not exported. */
+		type = iter->exported ? toupper(iter->type) :
+					tolower(iter->type);
 		seq_printf(m, "%0*lx %c %s\t[%s]\n",
 			   (int)(2*sizeof(void*)),
-			   iter->value, iter->type, iter->name,
-			   module_name(iter->owner));
-	else
+			   iter->value, type, iter->name, iter->module_name);
+	} else
 		seq_printf(m, "%0*lx %c %s\n",
 			   (int)(2*sizeof(void*)),
 			   iter->value, iter->type, iter->name);
diff -puN kernel/module.c~fix-race-between-rmmod-and-cat-proc-kallsyms kernel/module.c
--- a/kernel/module.c~fix-race-between-rmmod-and-cat-proc-kallsyms
+++ a/kernel/module.c
@@ -1472,7 +1472,7 @@ static void setup_modinfo(struct module 
 }
 
 #ifdef CONFIG_KALLSYMS
-int is_exported(const char *name, const struct module *mod)
+static int is_exported(const char *name, const struct module *mod)
 {
 	if (!mod && lookup_symbol(name, __start___ksymtab, __stop___ksymtab))
 		return 1;
@@ -2124,8 +2124,8 @@ const char *module_address_lookup(unsign
 	return NULL;
 }
 
-struct module *module_get_kallsym(unsigned int symnum, unsigned long *value,
-				char *type, char *name)
+int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
+			char *name, char *module_name, int *exported)
 {
 	struct module *mod;
 
@@ -2136,13 +2136,15 @@ struct module *module_get_kallsym(unsign
 			*type = mod->symtab[symnum].st_info;
 			strlcpy(name, mod->strtab + mod->symtab[symnum].st_name,
 				KSYM_NAME_LEN + 1);
+			strlcpy(module_name, mod->name, MODULE_NAME_LEN + 1);
+			*exported = is_exported(name, mod);
 			mutex_unlock(&module_mutex);
-			return mod;
+			return 0;
 		}
 		symnum -= mod->num_symtab;
 	}
 	mutex_unlock(&module_mutex);
-	return NULL;
+	return -ERANGE;
 }
 
 static unsigned long mod_find_symname(struct module *mod, const char *name)
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
2621-rc5-mm3-fix-e1000-compilation.patch
fix-rmmod-read-write-races-in-proc-entries.patch
