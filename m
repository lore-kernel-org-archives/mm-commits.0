From: akpm@linux-foundation.org
Subject: + whitespace-fixes-module-loading.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:50 -0700
Message-ID: <200707210018.l6L0Io72023870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56338 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758982AbXGUAUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com


The patch titled
     whitespace fixes: module loading
has been added to the -mm tree.  Its filename is
     whitespace-fixes-module-loading.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: module loading
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff -puN kernel/module.c~whitespace-fixes-module-loading kernel/module.c
--- a/kernel/module.c~whitespace-fixes-module-loading
+++ a/kernel/module.c
@@ -105,7 +105,7 @@ void __module_put_and_exit(struct module
 	do_exit(code);
 }
 EXPORT_SYMBOL(__module_put_and_exit);
-	
+
 /* Find a module section: 0 means not found. */
 static unsigned int find_sec(Elf_Ehdr *hdr,
 			     Elf_Shdr *sechdrs,
@@ -179,7 +179,7 @@ static unsigned long __find_symbol(const
 	struct module *mod;
 	const struct kernel_symbol *ks;
 
-	/* Core kernel first. */ 
+	/* Core kernel first. */
 	*owner = NULL;
 	ks = lookup_symbol(name, __start___ksymtab, __stop___ksymtab);
 	if (ks) {
@@ -231,7 +231,7 @@ static unsigned long __find_symbol(const
 		return ks->value;
 	}
 
-	/* Now try modules. */ 
+	/* Now try modules. */
 	list_for_each_entry(mod, &modules, list) {
 		*owner = mod;
 		ks = lookup_symbol(name, mod->syms, mod->syms + mod->num_syms);
@@ -285,7 +285,7 @@ static unsigned long __find_symbol(const
 		}
 	}
 	DEBUGP("Failed to find symbol %s\n", name);
- 	return 0;
+	return 0;
 }
 
 /* Search for module by name: must hold module_mutex. */
@@ -441,7 +441,7 @@ static int percpu_modinit(void)
 	}
 
 	return 0;
-}	
+}
 __initcall(percpu_modinit);
 #else /* ... !CONFIG_SMP */
 static inline void *percpu_modalloc(unsigned long size, unsigned long align,
@@ -483,8 +483,8 @@ static int modinfo_##field##_exists(stru
 }                                                                     \
 static void free_modinfo_##field(struct module *mod)                  \
 {                                                                     \
-        kfree(mod->field);                                            \
-        mod->field = NULL;                                            \
+	kfree(mod->field);                                            \
+	mod->field = NULL;                                            \
 }                                                                     \
 static struct module_attribute modinfo_##field = {                    \
 	.attr = { .name = __stringify(field), .mode = 0444 },         \
@@ -1011,7 +1011,7 @@ static void add_sect_attrs(struct module
 	struct module_sect_attrs *sect_attrs;
 	struct module_sect_attr *sattr;
 	struct attribute **gattr;
-	
+
 	/* Count loaded sections and allocate structures */
 	for (i = 0; i < nsect; i++)
 		if (sechdrs[i].sh_flags & SHF_ALLOC)
@@ -1270,14 +1270,14 @@ static int verify_export_symbols(struct 
 	const unsigned long *crc;
 
 	for (i = 0; i < mod->num_syms; i++)
-	        if (__find_symbol(mod->syms[i].name, &owner, &crc, 1)) {
+		if (__find_symbol(mod->syms[i].name, &owner, &crc, 1)) {
 			name = mod->syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
 		}
 
 	for (i = 0; i < mod->num_gpl_syms; i++)
-	        if (__find_symbol(mod->gpl_syms[i].name, &owner, &crc, 1)) {
+		if (__find_symbol(mod->gpl_syms[i].name, &owner, &crc, 1)) {
 			name = mod->gpl_syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
@@ -1875,7 +1875,7 @@ static struct module *load_module(void _
 		mod->unused_crcs = (void *)sechdrs[unusedgplcrcindex].sh_addr;
 
 #ifdef CONFIG_MODVERSIONS
-	if ((mod->num_syms && !crcindex) || 
+	if ((mod->num_syms && !crcindex) ||
 	    (mod->num_gpl_syms && !gplcrcindex) ||
 	    (mod->num_gpl_future_syms && !gplfuturecrcindex) ||
 	    (mod->num_unused_syms && !unusedcrcindex) ||
@@ -1969,7 +1969,7 @@ static struct module *load_module(void _
 	if (err < 0)
 		goto arch_cleanup;
 
-	err = mod_sysfs_setup(mod, 
+	err = mod_sysfs_setup(mod,
 			      (struct kernel_param *)
 			      sechdrs[setupindex].sh_addr,
 			      sechdrs[setupindex].sh_size
@@ -1980,8 +1980,8 @@ static struct module *load_module(void _
 
 	/* Size of section 0 is 0, so this works well if no unwind info. */
 	mod->unwind_info = unwind_add_table(mod,
-	                                    (void *)sechdrs[unwindex].sh_addr,
-	                                    sechdrs[unwindex].sh_size);
+					    (void *)sechdrs[unwindex].sh_addr,
+					    sechdrs[unwindex].sh_size);
 
 	/* Get rid of temporary copy */
 	vfree(hdr);
@@ -2113,7 +2113,7 @@ static inline int within(unsigned long a
  */
 static inline int is_arm_mapping_symbol(const char *str)
 {
-	return str[0] == '$' && strchr("atd", str[1]) 
+	return str[0] == '$' && strchr("atd", str[1])
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
@@ -2128,11 +2128,11 @@ static const char *get_ksymbol(struct mo
 	/* At worse, next value is at end of module */
 	if (within(addr, mod->module_init, mod->init_size))
 		nextval = (unsigned long)mod->module_init+mod->init_text_size;
-	else 
+	else
 		nextval = (unsigned long)mod->module_core+mod->core_text_size;
 
 	/* Scan for closest preceeding symbol, and next symbol. (ELF
-           starts real symbols at 1). */
+	   starts real symbols at 1). */
 	for (i = 1; i < mod->num_symtab; i++) {
 		if (mod->symtab[i].st_shndx == SHN_UNDEF)
 			continue;
@@ -2374,7 +2374,7 @@ const struct exception_table_entry *sear
 	list_for_each_entry(mod, &modules, list) {
 		if (mod->num_exentries == 0)
 			continue;
-				
+
 		e = search_extable(mod->extable,
 				   mod->extable + mod->num_exentries - 1,
 				   addr);
@@ -2384,7 +2384,7 @@ const struct exception_table_entry *sear
 	preempt_enable();
 
 	/* Now, if we found one, we are running inside it now, hence
-           we cannot unload the module, hence no refcnt needed. */
+	   we cannot unload the module, hence no refcnt needed. */
 	return e;
 }
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
