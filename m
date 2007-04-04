From: akpm@linux-foundation.org
Subject: + fix-race-between-cat-proc-slab_allocators-and-rmmod.patch added to -mm tree
Date: Tue, 03 Apr 2007 17:10:30 -0700
Message-ID: <200704040010.l340AVZY007304@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49710 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946038AbXDDALM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 20:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, rusty@rustcorp.com.au


The patch titled
     Fix race between cat /proc/slab_allocators and rmmod
has been added to the -mm tree.  Its filename is
     fix-race-between-cat-proc-slab_allocators-and-rmmod.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix race between cat /proc/slab_allocators and rmmod
From: Alexey Dobriyan <adobriyan@sw.ru>

Same story as with cat /proc/*/wchan race vs rmmod race, only
/proc/slab_allocators want more info than just symbol name.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |    6 ++++++
 include/linux/module.h   |    6 ++++++
 kernel/kallsyms.c        |   19 +++++++++++++++++++
 kernel/module.c          |   27 +++++++++++++++++++++++++++
 mm/slab.c                |   10 +++-------
 5 files changed, 61 insertions(+), 7 deletions(-)

diff -puN include/linux/kallsyms.h~fix-race-between-cat-proc-slab_allocators-and-rmmod include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~fix-race-between-cat-proc-slab_allocators-and-rmmod
+++ a/include/linux/kallsyms.h
@@ -31,6 +31,7 @@ extern int sprint_symbol(char *buffer, u
 extern void __print_symbol(const char *fmt, unsigned long address);
 
 int lookup_symbol_name(unsigned long addr, char *symname);
+int lookup_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
 #else /* !CONFIG_KALLSYMS */
 
@@ -65,6 +66,11 @@ static inline int lookup_symbol_name(uns
 	return -ERANGE;
 }
 
+static inline int lookup_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name)
+{
+	return -ERANGE;
+}
+
 /* Stupid that this does nothing, but I didn't create this mess. */
 #define __print_symbol(fmt, addr)
 #endif /*CONFIG_KALLSYMS*/
diff -puN include/linux/module.h~fix-race-between-cat-proc-slab_allocators-and-rmmod include/linux/module.h
--- a/include/linux/module.h~fix-race-between-cat-proc-slab_allocators-and-rmmod
+++ a/include/linux/module.h
@@ -460,6 +460,7 @@ const char *module_address_lookup(unsign
 				  unsigned long *offset,
 				  char **modname);
 int lookup_module_symbol_name(unsigned long addr, char *symname);
+int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
 /* For extable.c to search modules' exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr);
@@ -536,6 +537,11 @@ static inline int lookup_module_symbol_n
 	return -ERANGE;
 }
 
+static inline int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name)
+{
+	return -ERANGE;
+}
+
 static inline int module_get_kallsym(unsigned int symnum, unsigned long *value,
 					char *type, char *name,
 					char *module_name, int *exported)
diff -puN kernel/kallsyms.c~fix-race-between-cat-proc-slab_allocators-and-rmmod kernel/kallsyms.c
--- a/kernel/kallsyms.c~fix-race-between-cat-proc-slab_allocators-and-rmmod
+++ a/kernel/kallsyms.c
@@ -286,6 +286,25 @@ int lookup_symbol_name(unsigned long add
 	return lookup_module_symbol_name(addr, symname);
 }
 
+int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
+			unsigned long *offset, char *modname, char *name)
+{
+	name[0] = '\0';
+	name[KSYM_NAME_LEN] = '\0';
+
+	if (is_ksym_addr(addr)) {
+		unsigned long pos;
+
+		pos = get_symbol_pos(addr, size, offset);
+		/* Grab name */
+		kallsyms_expand_symbol(get_symbol_offset(pos), name);
+		modname[0] = '\0';
+		return 0;
+	}
+	/* see if it's in a module */
+	return lookup_module_symbol_attrs(addr, size, offset, modname, name);
+}
+
 /* Look up a kernel symbol and return it in a text buffer. */
 int sprint_symbol(char *buffer, unsigned long address)
 {
diff -puN kernel/module.c~fix-race-between-cat-proc-slab_allocators-and-rmmod kernel/module.c
--- a/kernel/module.c~fix-race-between-cat-proc-slab_allocators-and-rmmod
+++ a/kernel/module.c
@@ -2225,6 +2225,33 @@ out:
 	return -ERANGE;
 }
 
+int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
+			unsigned long *offset, char *modname, char *name)
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry(mod, &modules, list) {
+		if (within(addr, mod->module_init, mod->init_size) ||
+		    within(addr, mod->module_core, mod->core_size)) {
+			const char *sym;
+
+			sym = get_ksymbol(mod, addr, size, offset);
+			if (!sym)
+				goto out;
+			if (modname)
+				strlcpy(modname, mod->name, MODULE_NAME_LEN + 1);
+			if (name)
+				strlcpy(name, sym, KSYM_NAME_LEN + 1);
+			mutex_unlock(&module_mutex);
+			return 0;
+		}
+	}
+out:
+	mutex_unlock(&module_mutex);
+	return -ERANGE;
+}
+
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 			char *name, char *module_name, int *exported)
 {
diff -puN mm/slab.c~fix-race-between-cat-proc-slab_allocators-and-rmmod mm/slab.c
--- a/mm/slab.c~fix-race-between-cat-proc-slab_allocators-and-rmmod
+++ a/mm/slab.c
@@ -4453,16 +4453,12 @@ static void handle_slab(unsigned long *n
 static void show_symbol(struct seq_file *m, unsigned long address)
 {
 #ifdef CONFIG_KALLSYMS
-	char *modname;
-	const char *name;
 	unsigned long offset, size;
-	char namebuf[KSYM_NAME_LEN+1];
-
-	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
+	char modname[MODULE_NAME_LEN + 1], name[KSYM_NAME_LEN + 1];
 
-	if (name) {
+	if (lookup_symbol_attrs(address, &size, &offset, modname, name) == 0) {
 		seq_printf(m, "%s+%#lx/%#lx", name, offset, size);
-		if (modname)
+		if (modname[0])
 			seq_printf(m, " [%s]", modname);
 		return;
 	}
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
