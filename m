From: akpm@linux-foundation.org
Subject: - remove-smp_alt_instructions.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:41 -0700
Message-ID: <200704132330.l3DNUfwD012760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60716 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161235AbXDMXaq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     Remove smp_alt_instructions
has been removed from the -mm tree.  Its filename was
     remove-smp_alt_instructions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove smp_alt_instructions
From: Jeremy Fitzhardinge <jeremy@goop.org>

The .smp_altinstructions section and its corresponding symbols are completely
unused, so remove them.

Also, remove stray #ifdef __KENREL__ in asm-i386/alternative.h

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |   38 +------------------------------
 arch/i386/kernel/vmlinux.lds.S |   11 --------
 include/asm-i386/alternative.h |    6 ----
 3 files changed, 3 insertions(+), 52 deletions(-)

diff -puN arch/i386/kernel/alternative.c~remove-smp_alt_instructions arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~remove-smp_alt_instructions
+++ a/arch/i386/kernel/alternative.c
@@ -132,11 +132,8 @@ static void nop_out(void *insns, unsigne
 }
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
-extern struct alt_instr __smp_alt_instructions[], __smp_alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
 
-extern u8 __smp_alt_begin[], __smp_alt_end[];
-
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
    self modifying code. This implies that assymetric systems where
@@ -171,29 +168,6 @@ void apply_alternatives(struct alt_instr
 
 #ifdef CONFIG_SMP
 
-static void alternatives_smp_save(struct alt_instr *start, struct alt_instr *end)
-{
-	struct alt_instr *a;
-
-	DPRINTK("%s: alt table %p-%p\n", __FUNCTION__, start, end);
-	for (a = start; a < end; a++) {
-		memcpy(a->replacement + a->replacementlen,
-		       a->instr,
-		       a->instrlen);
-	}
-}
-
-static void alternatives_smp_apply(struct alt_instr *start, struct alt_instr *end)
-{
-	struct alt_instr *a;
-
-	for (a = start; a < end; a++) {
-		memcpy(a->instr,
-		       a->replacement + a->replacementlen,
-		       a->instrlen);
-	}
-}
-
 static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 {
 	u8 **ptr;
@@ -319,8 +293,6 @@ void alternatives_smp_switch(int smp)
 		printk(KERN_INFO "SMP alternatives: switching to SMP code\n");
 		clear_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
 		clear_bit(X86_FEATURE_UP, cpu_data[0].x86_capability);
-		alternatives_smp_apply(__smp_alt_instructions,
-				       __smp_alt_instructions_end);
 		list_for_each_entry(mod, &smp_alt_modules, next)
 			alternatives_smp_lock(mod->locks, mod->locks_end,
 					      mod->text, mod->text_end);
@@ -328,8 +300,6 @@ void alternatives_smp_switch(int smp)
 		printk(KERN_INFO "SMP alternatives: switching to UP code\n");
 		set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
 		set_bit(X86_FEATURE_UP, cpu_data[0].x86_capability);
-		apply_alternatives(__smp_alt_instructions,
-				   __smp_alt_instructions_end);
 		list_for_each_entry(mod, &smp_alt_modules, next)
 			alternatives_smp_unlock(mod->locks, mod->locks_end,
 						mod->text, mod->text_end);
@@ -388,17 +358,13 @@ void __init alternative_instructions(voi
 			printk(KERN_INFO "SMP alternatives: switching to UP code\n");
 			set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
 			set_bit(X86_FEATURE_UP, cpu_data[0].x86_capability);
-			apply_alternatives(__smp_alt_instructions,
-					   __smp_alt_instructions_end);
 			alternatives_smp_unlock(__smp_locks, __smp_locks_end,
 						_text, _etext);
 		}
 		free_init_pages("SMP alternatives",
-				__pa_symbol(&__smp_alt_begin),
-				__pa_symbol(&__smp_alt_end));
+				__pa_symbol(&__smp_locks),
+				__pa_symbol(&__smp_locks_end));
 	} else {
-		alternatives_smp_save(__smp_alt_instructions,
-				      __smp_alt_instructions_end);
 		alternatives_smp_module_add(NULL, "core kernel",
 					    __smp_locks, __smp_locks_end,
 					    _text, _etext);
diff -puN arch/i386/kernel/vmlinux.lds.S~remove-smp_alt_instructions arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~remove-smp_alt_instructions
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -119,22 +119,11 @@ SECTIONS
 
   /* might get freed after init */
   . = ALIGN(4096);
-  .smp_altinstructions : AT(ADDR(.smp_altinstructions) - LOAD_OFFSET) {
-	__smp_alt_begin = .;
-	__smp_alt_instructions = .;
-	*(.smp_altinstructions)
-	__smp_alt_instructions_end = .;
-  }
-  . = ALIGN(4);
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
   	__smp_locks = .;
 	*(.smp_locks)
 	__smp_locks_end = .;
   }
-  .smp_altinstr_replacement : AT(ADDR(.smp_altinstr_replacement) - LOAD_OFFSET) {
-	*(.smp_altinstr_replacement)
-  	__smp_alt_end = .;
-  }
   /* will be freed after init
    * Following ALIGN() is required to make sure no other data falls on the
    * same page where __smp_alt_end is pointing as that page might be freed
diff -puN include/asm-i386/alternative.h~remove-smp_alt_instructions include/asm-i386/alternative.h
--- a/include/asm-i386/alternative.h~remove-smp_alt_instructions
+++ a/include/asm-i386/alternative.h
@@ -1,8 +1,6 @@
 #ifndef _I386_ALTERNATIVE_H
 #define _I386_ALTERNATIVE_H
 
-#ifdef __KERNEL__
-
 #include <asm/types.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
@@ -31,9 +29,7 @@ static inline void alternatives_smp_modu
 					void *text, void *text_end) {}
 static inline void alternatives_smp_module_del(struct module *mod) {}
 static inline void alternatives_smp_switch(int smp) {}
-#endif
-
-#endif
+#endif	/* CONFIG_SMP */
 
 /*
  * Alternative instructions for different CPU types or capabilities.
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
