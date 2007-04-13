From: akpm@linux-foundation.org
Subject: - paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:58 -0700
Message-ID: <200704132329.l3DNTwxV012667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60581 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030893AbXDMXaH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: use paravirt_nop to consistently mark no-op operations
has been removed from the -mm tree.  Its filename was
     paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: use paravirt_nop to consistently mark no-op operations
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add a _paravirt_nop function for use as a stub for no-op operations, and
paravirt_nop #defined void * version to make using it easier (since all its
uses are as a void *).

This is useful to allow the patcher to automatically identify noop operations
so it can simply nop out the callsite.

[mingo] but only as a cleanup of the current open-coded (void *) casts.  My
problem with this is that it loses the types.  Not that there is much to check
for, but still, this adds some assumptions about how function calls look like

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |   24 ++++++++++++------------
 include/asm-i386/paravirt.h |    3 +++
 2 files changed, 15 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations
+++ a/arch/i386/kernel/paravirt.c
@@ -35,7 +35,7 @@
 #include <asm/timer.h>
 
 /* nop stub */
-static void native_nop(void)
+void _paravirt_nop(void)
 {
 }
 
@@ -207,7 +207,7 @@ struct paravirt_ops paravirt_ops = {
 
  	.patch = native_patch,
 	.banner = default_banner,
-	.arch_setup = native_nop,
+	.arch_setup = paravirt_nop,
 	.memory_setup = machine_specific_memory_setup,
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
@@ -263,25 +263,25 @@ struct paravirt_ops paravirt_ops = {
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
 #endif
-	.set_lazy_mode = (void *)native_nop,
+	.set_lazy_mode = paravirt_nop,
 
 	.flush_tlb_user = native_flush_tlb,
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
 
-	.map_pt_hook = (void *)native_nop,
+	.map_pt_hook = paravirt_nop,
 
-	.alloc_pt = (void *)native_nop,
-	.alloc_pd = (void *)native_nop,
-	.alloc_pd_clone = (void *)native_nop,
-	.release_pt = (void *)native_nop,
-	.release_pd = (void *)native_nop,
+	.alloc_pt = paravirt_nop,
+	.alloc_pd = paravirt_nop,
+	.alloc_pd_clone = paravirt_nop,
+	.release_pt = paravirt_nop,
+	.release_pd = paravirt_nop,
 
 	.set_pte = native_set_pte,
 	.set_pte_at = native_set_pte_at,
 	.set_pmd = native_set_pmd,
-	.pte_update = (void *)native_nop,
-	.pte_update_defer = (void *)native_nop,
+	.pte_update = paravirt_nop,
+	.pte_update_defer = paravirt_nop,
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
@@ -293,7 +293,7 @@ struct paravirt_ops paravirt_ops = {
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
-	.startup_ipi_hook = (void *)native_nop,
+	.startup_ipi_hook = paravirt_nop,
 };
 
 /*
diff -puN include/asm-i386/paravirt.h~paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations
+++ a/include/asm-i386/paravirt.h
@@ -431,6 +431,9 @@ static inline void pmd_clear(pmd_t *pmdp
 #define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
 #define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
 
+void _paravirt_nop(void);
+#define paravirt_nop	((void *)_paravirt_nop)
+
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch {
 	u8 *instr; 		/* original instructions */
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
