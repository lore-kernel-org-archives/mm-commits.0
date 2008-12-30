From: akpm@linux-foundation.org
Subject: + kmemleak-add-modules-support.patch added to -mm tree
Date: Mon, 29 Dec 2008 16:23:03 -0800
Message-ID: <200812300023.mBU0N365006064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959AbYL3AXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 19:23:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, rusty@rustcorp.com.au


The patch titled
     kmemleak: add modules support
has been added to the -mm tree.  Its filename is
     kmemleak-add-modules-support.patch

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
@@ -51,6 +51,7 @@
 #include <asm/sections.h>
 #include <linux/tracepoint.h>
 #include <linux/ftrace.h>
+#include <linux/kmemleak.h>
 
 #if 0
 #define DEBUGP printk
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
 	void *ptr = __per_cpu_load + block_size(pcpu_size[0]);
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
@@ -1831,6 +1843,36 @@ static void *module_alloc_update_bounds(
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
@@ -2003,6 +2045,12 @@ static noinline struct module *load_modu
 
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
@@ -2011,6 +2059,13 @@ static noinline struct module *load_modu
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
@@ -2041,6 +2096,7 @@ static noinline struct module *load_modu
 	}
 	/* Module has been moved. */
 	mod = (void *)sechdrs[modindex].sh_addr;
+	kmemleak_load_module(mod, hdr, sechdrs, secstrings);
 
 	/* Now we've moved module, initialize linked lists, etc. */
 	module_unload_init(mod);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
kmemleak-add-the-base-support.patch
kmemleak-add-the-base-support-fix.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch
kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch
kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch
kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

