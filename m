From: akpm@linux-foundation.org
Subject: - kmemleak-add-modules-support.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:08 -0800
Message-ID: <200901082246.n08Mk8mS025666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763530AbZAHWvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     kmemleak: add modules support
has been removed from the -mm tree.  Its filename was
     kmemleak-add-modules-support.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemleak: add modules support
From: Catalin Marinas <catalin.marinas@arm.com>

Handle the kmemleak operations needed for modules loading so that memory
allocations from inside a module are properly tracked.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff -puN kernel/module.c~kmemleak-add-modules-support kernel/module.c
--- a/kernel/module.c~kmemleak-add-modules-support
+++ a/kernel/module.c
@@ -37,6 +37,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/vermagic.h>
+#include <linux/kmemleak.h>
 #include <linux/notifier.h>
 #include <linux/sched.h>
 #include <linux/stop_machine.h>
@@ -409,6 +410,7 @@ static void *percpu_modalloc(unsigned lo
 	unsigned long extra;
 	unsigned int i;
 	void *ptr;
+	int cpu;
 
 	if (align > PAGE_SIZE) {
 		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
@@ -438,6 +440,11 @@ static void *percpu_modalloc(unsigned lo
 			if (!split_block(i, size))
 				return NULL;
 
+		/* add the per-cpu scanning areas */
+		for_each_possible_cpu(cpu)
+			kmemleak_alloc(ptr + per_cpu_offset(cpu), size, 0,
+				       GFP_KERNEL);
+
 		/* Mark allocated */
 		pcpu_size[i] = -pcpu_size[i];
 		return ptr;
@@ -452,6 +459,7 @@ static void percpu_modfree(void *freeme)
 {
 	unsigned int i;
 	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
+	int cpu;
 
 	/* First entry is core kernel percpu data. */
 	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
@@ -463,6 +471,10 @@ static void percpu_modfree(void *freeme)
 	BUG();
 
  free:
+	/* remove the per-cpu scanning areas */
+	for_each_possible_cpu(cpu)
+		kmemleak_free(freeme + per_cpu_offset(cpu));
+
 	/* Merge with previous? */
 	if (pcpu_size[i-1] >= 0) {
 		pcpu_size[i-1] += pcpu_size[i];
@@ -1852,6 +1864,36 @@ static void *module_alloc_update_bounds(
 	return ret;
 }
 
+#ifdef CONFIG_DEBUG_KMEMLEAK
+static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
+				 Elf_Shdr *sechdrs, char *secstrings)
+{
+	unsigned int i;
+
+	/* only scan the sections containing data */
+	kmemleak_scan_area(mod->module_core, (unsigned long)mod -
+			   (unsigned long)mod->module_core,
+			   sizeof(struct module), GFP_KERNEL);
+
+	for (i = 1; i < hdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+		if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
+		    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
+			continue;
+
+		kmemleak_scan_area(mod->module_core, sechdrs[i].sh_addr -
+				   (unsigned long)mod->module_core,
+				   sechdrs[i].sh_size, GFP_KERNEL);
+	}
+}
+#else
+static inline void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
+					Elf_Shdr *sechdrs, char *secstrings)
+{
+}
+#endif
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2031,6 +2073,12 @@ static noinline struct module *load_modu
 
 	/* Do the allocs. */
 	ptr = module_alloc_update_bounds(mod->core_size);
+	/*
+	 * The pointer to this block is stored in the module structure
+	 * which is inside the block. Just mark it as not being a
+	 * leak.
+	 */
+	kmemleak_not_leak(ptr);
 	if (!ptr) {
 		err = -ENOMEM;
 		goto free_percpu;
@@ -2039,6 +2087,13 @@ static noinline struct module *load_modu
 	mod->module_core = ptr;
 
 	ptr = module_alloc_update_bounds(mod->init_size);
+	/*
+	 * The pointer to this block is stored in the module structure
+	 * which is inside the block. This block doesn't need to be
+	 * scanned as it contains data and code that will be freed
+	 * after the module is initialized.
+	 */
+	kmemleak_ignore(ptr);
 	if (!ptr && mod->init_size) {
 		err = -ENOMEM;
 		goto free_core;
@@ -2069,6 +2124,7 @@ static noinline struct module *load_modu
 	}
 	/* Module has been moved. */
 	mod = (void *)sechdrs[modindex].sh_addr;
+	kmemleak_load_module(mod, hdr, sechdrs, secstrings);
 
 	/* Now we've moved module, initialize linked lists, etc. */
 	module_unload_init(mod);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

