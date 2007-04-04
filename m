From: akpm@linux-foundation.org
Subject: + fix-race-between-rmmod-and-cat-proc-kallsyms.patch added to -mm tree
Date: Tue, 03 Apr 2007 17:10:24 -0700
Message-ID: <200704040010.l340AOcr007287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49706 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992504AbXDDALH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 20:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, rusty@rustcorp.com.au


The patch titled
     Fix race between rmmod and cat /proc/kallsyms
has been added to the -mm tree.  Its filename is
     fix-race-between-rmmod-and-cat-proc-kallsyms.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix race between rmmod and cat /proc/kallsyms
From: Alexey Dobriyan <adobriyan@sw.ru>

module_get_kallsym() leaks "struct module *" outside of module_mutex which is
no-no, because module can dissapear right after mutex unlock.

Copy all needed information from inside module_mutex into caller-supplied
space.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |   14 +++++++-------
 kernel/kallsyms.c      |   30 +++++++++++++++---------------
 kernel/module.c        |   10 ++++++----
 3 files changed, 28 insertions(+), 26 deletions(-)

diff -puN include/linux/module.h~fix-race-between-rmmod-and-cat-proc-kallsyms include/linux/module.h
--- a/include/linux/module.h~fix-race-between-rmmod-and-cat-proc-kallsyms
+++ a/include/linux/module.h
@@ -371,10 +371,10 @@ struct module *module_text_address(unsig
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
@@ -530,11 +530,11 @@ static inline const char *module_address
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
@@ -2200,8 +2200,8 @@ const char *module_address_lookup(unsign
 	return NULL;
 }
 
-struct module *module_get_kallsym(unsigned int symnum, unsigned long *value,
-				char *type, char *name)
+int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
+			char *name, char *module_name, int *exported)
 {
 	struct module *mod;
 
@@ -2212,13 +2212,15 @@ struct module *module_get_kallsym(unsign
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
git-cpufreq.patch
2621-rc5-mm3-fix-e1000-compilation.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
add-file-position-info-to-proc.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-oom_score-oops-re-badness.patch
protect-tty-drivers-list-with-tty_mutex.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
