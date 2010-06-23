From: akpm@linux-foundation.org
Subject: + revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch added to -mm tree
Date: Wed, 23 Jun 2010 15:26:21 -0700
Message-ID: <201006232255.o5NMt6Tq004243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FWWzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 18:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au


The patch titled
     revert 3ab7269a6058c136795ce9417f7051a0edde60db
has been added to the -mm tree.  Its filename is
     revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch

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
Subject: revert 3ab7269a6058c136795ce9417f7051a0edde60db
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |  224 ++++++++++++++++++++--------------------------
 1 file changed, 99 insertions(+), 125 deletions(-)

diff -puN kernel/module.c~revert-3ab7269a6058c136795ce9417f7051a0edde60db kernel/module.c
--- a/kernel/module.c~revert-3ab7269a6058c136795ce9417f7051a0edde60db
+++ a/kernel/module.c
@@ -115,8 +115,6 @@ struct load_info {
 	unsigned long len;
 	Elf_Shdr *sechdrs;
 	char *secstrings, *args, *strtab;
-	unsigned long *strmap;
-	unsigned long symoffs, stroffs;
 	struct {
 		unsigned int sym, str, mod, vers, info, pcpu;
 	} index;
@@ -404,8 +402,7 @@ static int percpu_modalloc(struct module
 	mod->percpu = __alloc_reserved_percpu(size, align);
 	if (!mod->percpu) {
 		printk(KERN_WARNING
-		       "%s: Could not allocate %lu bytes percpu data\n",
-		       mod->name, size);
+		       "Could not allocate %lu bytes percpu data\n", size);
 		return -ENOMEM;
 	}
 	mod->percpu_size = size;
@@ -2033,7 +2030,10 @@ static unsigned long layout_symtab(struc
 	return symoffs;
 }
 
-static void add_kallsyms(struct module *mod, struct load_info *info)
+static void add_kallsyms(struct module *mod, struct load_info *info,
+			 unsigned long symoffs,
+			 unsigned long stroffs,
+			 unsigned long *strmap)
 {
 	unsigned int i, ndst;
 	const Elf_Sym *src;
@@ -2049,22 +2049,21 @@ static void add_kallsyms(struct module *
 	for (i = 0; i < mod->num_symtab; i++)
 		mod->symtab[i].st_info = elf_type(&mod->symtab[i], info);
 
-	mod->core_symtab = dst = mod->module_core + info->symoffs;
+	mod->core_symtab = dst = mod->module_core + symoffs;
 	src = mod->symtab;
 	*dst = *src;
 	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
 		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
 			continue;
 		dst[ndst] = *src;
-		dst[ndst].st_name = bitmap_weight(info->strmap,
-						  dst[ndst].st_name);
+		dst[ndst].st_name = bitmap_weight(strmap, dst[ndst].st_name);
 		++ndst;
 	}
 	mod->core_num_syms = ndst;
 
-	mod->core_strtab = s = mod->module_core + info->stroffs;
+	mod->core_strtab = s = mod->module_core + stroffs;
 	for (*s = 0, i = 1; i < info->sechdrs[info->index.str].sh_size; ++i)
-		if (test_bit(i, info->strmap))
+		if (test_bit(i, strmap))
 			*++s = mod->strtab[i];
 }
 #else
@@ -2080,7 +2079,10 @@ static inline unsigned long layout_symta
 	return 0;
 }
 
-static void add_kallsyms(struct module *mod, struct load_info *info)
+static void add_kallsyms(struct module *mod, struct load_info *info,
+			 unsigned long symoffs,
+			 unsigned long stroffs,
+			 unsigned long *strmap)
 {
 }
 #endif /* CONFIG_KALLSYMS */
@@ -2145,10 +2147,8 @@ static inline void kmemleak_load_module(
 }
 #endif
 
-/* Sets info->hdr, info->len and info->args. */
-static int copy_and_check(struct load_info *info,
-			  const void __user *umod, unsigned long len,
-			  const char __user *uargs)
+/* Sets info->hdr and info->len. */
+static int copy_and_check(struct load_info *info, const void __user *umod, unsigned long len)
 {
 	int err;
 	Elf_Ehdr *hdr;
@@ -2180,14 +2180,6 @@ static int copy_and_check(struct load_in
 		err = -ENOEXEC;
 		goto free_hdr;
 	}
-
-	/* Now copy in args */
-	info->args = strndup_user(uargs, ~0UL >> 1);
-	if (IS_ERR(info->args)) {
-		err = PTR_ERR(info->args);
-		goto free_hdr;
-	}
-
 	info->hdr = hdr;
 	info->len = len;
 	return 0;
@@ -2197,12 +2189,6 @@ free_hdr:
 	return err;
 }
 
-static void free_copy(struct load_info *info)
-{
-	kfree(info->args);
-	vfree(info->hdr);
-}
-
 static int rewrite_section_headers(struct load_info *info)
 {
 	unsigned int i;
@@ -2396,9 +2382,9 @@ static void find_module_sections(struct 
 		       mod->name);
 }
 
-static int move_module(struct module *mod,
-		       Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
-		       const char *secstrings, unsigned modindex)
+static struct module *move_module(struct module *mod,
+				  Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
+				  const char *secstrings, unsigned modindex)
 {
 	int i;
 	void *ptr;
@@ -2412,7 +2398,7 @@ static int move_module(struct module *mo
 	 */
 	kmemleak_not_leak(ptr);
 	if (!ptr)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	memset(ptr, 0, mod->core_size);
 	mod->module_core = ptr;
@@ -2427,7 +2413,7 @@ static int move_module(struct module *mo
 	kmemleak_ignore(ptr);
 	if (!ptr && mod->init_size) {
 		module_free(mod, mod->module_core);
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 	memset(ptr, 0, mod->init_size);
 	mod->module_init = ptr;
@@ -2454,8 +2440,10 @@ static int move_module(struct module *mo
 		DEBUGP("\t0x%lx %s\n",
 		       sechdrs[i].sh_addr, secstrings + sechdrs[i].sh_name);
 	}
-
-	return 0;
+	/* Module has been moved. */
+	mod = (void *)sechdrs[modindex].sh_addr;
+	kmemleak_load_module(mod, hdr, sechdrs, secstrings);
+	return mod;
 }
 
 static int check_module_license_and_versions(struct module *mod,
@@ -2512,107 +2500,87 @@ static void flush_module_icache(const st
 	set_fs(old_fs);
 }
 
-static struct module *layout_and_allocate(struct load_info *info)
+/* Allocate and load the module: note that size of section 0 is always
+   zero, and we rely on this for optional sections. */
+static noinline struct module *load_module(void __user *umod,
+				  unsigned long len,
+				  const char __user *uargs)
 {
-	/* Module within temporary copy. */
+	struct load_info info = { NULL, };
 	struct module *mod;
-	int err;
+	long err;
+	unsigned long symoffs, stroffs, *strmap;
+	void __percpu *percpu;
+	struct _ddebug *debug = NULL;
+	unsigned int num_debug = 0;
 
-	mod = setup_load_info(info);
-	if (IS_ERR(mod))
-		return mod;
+	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
+	       umod, len, uargs);
 
-	err = check_modinfo(mod, info->sechdrs, info->index.info, info->index.vers);
+	err = copy_and_check(&info, umod, len);
 	if (err)
 		return ERR_PTR(err);
 
+	mod = setup_load_info(&info);
+	if (IS_ERR(mod)) {
+		err = PTR_ERR(mod);
+		goto free_hdr;
+	}
+
+	err = check_modinfo(mod, info.sechdrs, info.index.info, info.index.vers);
+	if (err)
+		goto free_hdr;
+
+	/* Now copy in args */
+	info.args = strndup_user(uargs, ~0UL >> 1);
+	if (IS_ERR(info.args)) {
+		err = PTR_ERR(info.args);
+		goto free_hdr;
+	}
+
+	strmap = kzalloc(BITS_TO_LONGS(info.sechdrs[info.index.str].sh_size)
+			 * sizeof(long), GFP_KERNEL);
+	if (!strmap) {
+		err = -ENOMEM;
+		goto free_mod;
+	}
+
+	mod->state = MODULE_STATE_COMING;
+
 	/* Allow arches to frob section contents and sizes.  */
-	err = module_frob_arch_sections(info->hdr, info->sechdrs, info->secstrings, mod);
+	err = module_frob_arch_sections(info.hdr, info.sechdrs, info.secstrings, mod);
 	if (err < 0)
-		goto free_args;
+		goto free_mod;
 
-	if (info->index.pcpu) {
+	if (info.index.pcpu) {
 		/* We have a special allocation for this section. */
-		err = percpu_modalloc(mod, info->sechdrs[info->index.pcpu].sh_size,
-				      info->sechdrs[info->index.pcpu].sh_addralign);
+		err = percpu_modalloc(mod, info.sechdrs[info.index.pcpu].sh_size,
+				      info.sechdrs[info.index.pcpu].sh_addralign);
 		if (err)
-			goto free_args;
-		info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
+			goto free_mod;
+		info.sechdrs[info.index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
+	/* Keep this around for failure path. */
+	percpu = mod_percpu(mod);
 
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
-	layout_sections(mod, info->hdr, info->sechdrs, info->secstrings);
-
-	info->strmap = kzalloc(BITS_TO_LONGS(info->sechdrs[info->index.str].sh_size)
-			 * sizeof(long), GFP_KERNEL);
-	if (!info->strmap) {
-		err = -ENOMEM;
-		goto free_percpu;
-	}
-	info->symoffs = layout_symtab(mod, info->sechdrs, info->index.sym, info->index.str, info->hdr,
-				info->secstrings, &info->stroffs, info->strmap);
+	layout_sections(mod, info.hdr, info.sechdrs, info.secstrings);
+	symoffs = layout_symtab(mod, info.sechdrs, info.index.sym, info.index.str, info.hdr,
+				info.secstrings, &stroffs, strmap);
 
 	/* Allocate and move to the final place */
-	err = move_module(mod, info->hdr, info->sechdrs, info->secstrings, info->index.mod);
-	if (err)
-		goto free_strmap;
-
-	/* Module has been copied to its final place now: return it. */
-	mod = (void *)info->sechdrs[info->index.mod].sh_addr;
-	kmemleak_load_module(mod, info->hdr, info->sechdrs, info->secstrings);
-	return mod;
-
-free_strmap:
-	kfree(info->strmap);
-free_percpu:
-	percpu_modfree(mod);
-free_args:
-	kfree(info->args);
-	return ERR_PTR(err);
-}
-
-/* mod is no longer valid after this! */
-static void module_deallocate(struct module *mod, struct load_info *info)
-{
-	kfree(info->strmap);
-	percpu_modfree(mod);
-	module_free(mod, mod->module_init);
-	module_free(mod, mod->module_core);
-}
-
-/* Allocate and load the module: note that size of section 0 is always
-   zero, and we rely on this for optional sections. */
-static noinline struct module *load_module(void __user *umod,
-				  unsigned long len,
-				  const char __user *uargs)
-{
-	struct load_info info = { NULL, };
-	struct module *mod;
-	long err;
-	struct _ddebug *debug = NULL;
-	unsigned int num_debug = 0;
-
-	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
-	       umod, len, uargs);
-
-	/* Copy in the blobs from userspace, check they are vaguely sane. */
-	err = copy_and_check(&info, umod, len, uargs);
-	if (err)
-		return ERR_PTR(err);
-
-	/* Figure out module layout, and allocate all the memory. */
-	mod = layout_and_allocate(&info);
+	mod = move_module(mod, info.hdr, info.sechdrs, info.secstrings, info.index.mod);
 	if (IS_ERR(mod)) {
 		err = PTR_ERR(mod);
-		goto free_copy;
+		goto free_percpu;
 	}
 
 	/* Now we've moved module, initialize linked lists, etc. */
 	err = module_unload_init(mod);
 	if (err)
-		goto free_module;
+		goto free_init;
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
@@ -2629,11 +2597,11 @@ static noinline struct module *load_modu
 	err = simplify_symbols(info.sechdrs, info.index.sym, info.strtab, info.index.vers, info.index.pcpu,
 			       mod);
 	if (err < 0)
-		goto free_modinfo;
+		goto cleanup;
 
 	err = apply_relocations(mod, info.hdr, info.sechdrs, info.index.sym, info.index.str);
 	if (err < 0)
-		goto free_modinfo;
+		goto cleanup;
 
   	/* Set up and sort exception table */
 	mod->extable = section_objs(info.hdr, info.sechdrs, info.secstrings, "__ex_table",
@@ -2644,7 +2612,9 @@ static noinline struct module *load_modu
 	percpu_modcopy(mod, (void *)info.sechdrs[info.index.pcpu].sh_addr,
 		       info.sechdrs[info.index.pcpu].sh_size);
 
-	add_kallsyms(mod, &info);
+	add_kallsyms(mod, &info, symoffs, stroffs, strmap);
+	kfree(strmap);
+	strmap = NULL;
 
 	if (!mod->taints)
 		debug = section_objs(info.hdr, info.sechdrs, info.secstrings, "__verbose",
@@ -2652,14 +2622,12 @@ static noinline struct module *load_modu
 
 	err = module_finalize(info.hdr, info.sechdrs, mod);
 	if (err < 0)
-		goto free_modinfo;
+		goto cleanup;
 
 	flush_module_icache(mod);
 
 	mod->args = info.args;
 
-	mod->state = MODULE_STATE_COMING;
-
 	/* Now sew it into the lists so we can get lockdep and oops
 	 * info during argument parsing.  Noone should access us, since
 	 * strong_try_module_get() will fail.
@@ -2695,9 +2663,8 @@ static noinline struct module *load_modu
 	add_sect_attrs(mod, info.hdr->e_shnum, info.secstrings, info.sechdrs);
 	add_notes_attrs(mod, info.hdr->e_shnum, info.secstrings, info.sechdrs);
 
-	/* Get rid of temporary copy and strmap. */
-	kfree(info.strmap);
-	free_copy(&info);
+	/* Get rid of temporary copy */
+	vfree(info.hdr);
 
 	trace_module_load(mod);
 
@@ -2714,14 +2681,21 @@ static noinline struct module *load_modu
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
 	module_arch_cleanup(mod);
- free_modinfo:
+ cleanup:
 	free_modinfo(mod);
  free_unload:
 	module_unload_free(mod);
- free_module:
-	module_deallocate(mod, &info);
- free_copy:
-	free_copy(&info);
+ free_init:
+	module_free(mod, mod->module_init);
+	module_free(mod, mod->module_core);
+	/* mod will be freed with core. Don't access it beyond this line! */
+ free_percpu:
+	free_percpu(percpu);
+ free_mod:
+	kfree(info.args);
+	kfree(strmap);
+ free_hdr:
+	vfree(info.hdr);
 	return ERR_PTR(err);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix-fix.patch
drivers-gpio-is-platform-neutral-fix.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation-fix.patch
fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch
acpi-fix-bogus-preemption-logic-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

