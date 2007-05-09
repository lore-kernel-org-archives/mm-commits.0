From: akpm@linux-foundation.org
Subject: - fix-race-between-cat-proc-slab_allocators-and-rmmod.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:52 -0700
Message-ID: <200705090248.l492mqjh009159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969590AbXEICtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Fix race between cat /proc/slab_allocators and rmmod
has been removed from the -mm tree.  Its filename was
     fix-race-between-cat-proc-slab_allocators-and-rmmod.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -455,6 +455,7 @@ const char *module_address_lookup(unsign
 				  unsigned long *offset,
 				  char **modname);
 int lookup_module_symbol_name(unsigned long addr, char *symname);
+int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size, unsigned long *offset, char *modname, char *name);
 
 /* For extable.c to search modules' exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr);
@@ -531,6 +532,11 @@ static inline int lookup_module_symbol_n
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
@@ -2149,6 +2149,33 @@ out:
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
@@ -4432,16 +4432,12 @@ static void handle_slab(unsigned long *n
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
2621-rc5-mm3-fix-e1000-compilation.patch
fix-rmmod-read-write-races-in-proc-entries.patch
