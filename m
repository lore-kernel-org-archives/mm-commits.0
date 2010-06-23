From: akpm@linux-foundation.org
Subject: + revert-4624469822455b4accc886557f6c997ccdd59066.patch added to -mm tree
Date: Wed, 23 Jun 2010 15:26:21 -0700
Message-ID: <201006232255.o5NMt7Tv004246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FWWzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 18:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au


The patch titled
     revert 4624469822455b4accc886557f6c997ccdd59066
has been added to the -mm tree.  Its filename is
     revert-4624469822455b4accc886557f6c997ccdd59066.patch

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
Subject: revert 4624469822455b4accc886557f6c997ccdd59066
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   68 ++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff -puN kernel/module.c~revert-4624469822455b4accc886557f6c997ccdd59066 kernel/module.c
--- a/kernel/module.c~revert-4624469822455b4accc886557f6c997ccdd59066
+++ a/kernel/module.c
@@ -110,16 +110,6 @@ int unregister_module_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_module_notifier);
 
-struct load_info {
-	Elf_Ehdr *hdr;
-	unsigned long len;
-	Elf_Shdr *sechdrs;
-	char *secstrings, *args, *strtab;
-	struct {
-		unsigned int sym, str, mod, vers, info, pcpu;
-	} index;
-};
-
 /* We require a truly strong try_module_get(): 0 means failure due to
    ongoing or failed initialization etc. */
 static inline int strong_try_module_get(struct module *mod)
@@ -1917,10 +1907,11 @@ static int is_exported(const char *name,
 }
 
 /* As per nm */
-static char elf_type(const Elf_Sym *sym, const struct load_info *info)
+static char elf_type(const Elf_Sym *sym,
+		     Elf_Shdr *sechdrs,
+		     const char *secstrings,
+		     struct module *mod)
 {
-	const Elf_Shdr *sechdrs = info->sechdrs;
-
 	if (ELF_ST_BIND(sym->st_info) == STB_WEAK) {
 		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT)
 			return 'v';
@@ -1950,10 +1941,8 @@ static char elf_type(const Elf_Sym *sym,
 		else
 			return 'b';
 	}
-	if (strstarts(info->secstrings + sechdrs[sym->st_shndx].sh_name,
-		      ".debug")) {
+	if (strstarts(secstrings + sechdrs[sym->st_shndx].sh_name, ".debug"))
 		return 'n';
-	}
 	return '?';
 }
 
@@ -2030,30 +2019,35 @@ static unsigned long layout_symtab(struc
 	return symoffs;
 }
 
-static void add_kallsyms(struct module *mod, struct load_info *info,
+static void add_kallsyms(struct module *mod,
+			 Elf_Shdr *sechdrs,
+			 unsigned int shnum,
+			 unsigned int symindex,
+			 unsigned int strindex,
 			 unsigned long symoffs,
 			 unsigned long stroffs,
+			 const char *secstrings,
 			 unsigned long *strmap)
 {
 	unsigned int i, ndst;
 	const Elf_Sym *src;
 	Elf_Sym *dst;
 	char *s;
-	Elf_Shdr *symsec = &info->sechdrs[info->index.sym];
 
-	mod->symtab = (void *)symsec->sh_addr;
-	mod->num_symtab = symsec->sh_size / sizeof(Elf_Sym);
-	mod->strtab = info->strtab;
+	mod->symtab = (void *)sechdrs[symindex].sh_addr;
+	mod->num_symtab = sechdrs[symindex].sh_size / sizeof(Elf_Sym);
+	mod->strtab = (void *)sechdrs[strindex].sh_addr;
 
 	/* Set types up while we still have access to sections. */
 	for (i = 0; i < mod->num_symtab; i++)
-		mod->symtab[i].st_info = elf_type(&mod->symtab[i], info);
+		mod->symtab[i].st_info
+			= elf_type(&mod->symtab[i], sechdrs, secstrings, mod);
 
 	mod->core_symtab = dst = mod->module_core + symoffs;
 	src = mod->symtab;
 	*dst = *src;
 	for (ndst = i = 1; i < mod->num_symtab; ++i, ++src) {
-		if (!is_core_symbol(src, info->sechdrs, info->hdr->e_shnum))
+		if (!is_core_symbol(src, sechdrs, shnum))
 			continue;
 		dst[ndst] = *src;
 		dst[ndst].st_name = bitmap_weight(strmap, dst[ndst].st_name);
@@ -2062,7 +2056,7 @@ static void add_kallsyms(struct module *
 	mod->core_num_syms = ndst;
 
 	mod->core_strtab = s = mod->module_core + stroffs;
-	for (*s = 0, i = 1; i < info->sechdrs[info->index.str].sh_size; ++i)
+	for (*s = 0, i = 1; i < sechdrs[strindex].sh_size; ++i)
 		if (test_bit(i, strmap))
 			*++s = mod->strtab[i];
 }
@@ -2079,10 +2073,15 @@ static inline unsigned long layout_symta
 	return 0;
 }
 
-static void add_kallsyms(struct module *mod, struct load_info *info,
-			 unsigned long symoffs,
-			 unsigned long stroffs,
-			 unsigned long *strmap)
+static inline void add_kallsyms(struct module *mod,
+				Elf_Shdr *sechdrs,
+				unsigned int shnum,
+				unsigned int symindex,
+				unsigned int strindex,
+				unsigned long symoffs,
+				unsigned long stroffs,
+				const char *secstrings,
+				const unsigned long *strmap)
 {
 }
 #endif /* CONFIG_KALLSYMS */
@@ -2147,6 +2146,16 @@ static inline void kmemleak_load_module(
 }
 #endif
 
+struct load_info {
+	Elf_Ehdr *hdr;
+	unsigned long len;
+	Elf_Shdr *sechdrs;
+	char *secstrings, *args, *strtab;
+	struct {
+		unsigned int sym, str, mod, vers, info, pcpu;
+	} index;
+};
+
 /* Sets info->hdr and info->len. */
 static int copy_and_check(struct load_info *info, const void __user *umod, unsigned long len)
 {
@@ -2612,7 +2621,8 @@ static noinline struct module *load_modu
 	percpu_modcopy(mod, (void *)info.sechdrs[info.index.pcpu].sh_addr,
 		       info.sechdrs[info.index.pcpu].sh_size);
 
-	add_kallsyms(mod, &info, symoffs, stroffs, strmap);
+	add_kallsyms(mod, info.sechdrs, info.hdr->e_shnum, info.index.sym, info.index.str,
+		     symoffs, stroffs, info.secstrings, strmap);
 	kfree(strmap);
 	strmap = NULL;
 
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

