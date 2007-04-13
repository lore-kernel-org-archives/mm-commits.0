From: akpm@linux-foundation.org
Subject: - paravirt_ops-add-flush_tlb_others-paravirt_op.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:29 -0700
Message-ID: <200704132330.l3DNUTtE012741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60668 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161222AbXDMXad (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: add flush_tlb_others paravirt_op
has been removed from the -mm tree.  Its filename was
     paravirt_ops-add-flush_tlb_others-paravirt_op.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: add flush_tlb_others paravirt_op
From: Jeremy Fitzhardinge <jeremy@goop.org>

This patch adds a pv_op for flush_tlb_others.  Linux running on native
hardware uses cross-CPU IPIs to flush the TLB on any CPU which may have a
particular mm's pagetable entries cached in its TLB.  This is inefficient in a
paravirtualized environment, since the hypervisor knows which real CPUs
actually contain cached mappings, which may be a small subset of a guest's
VCPUs.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    1 +
 arch/i386/kernel/smp.c      |   13 +++++++------
 include/asm-i386/paravirt.h |    9 +++++++++
 include/asm-i386/tlbflush.h |   19 +++++++++++++++++--
 4 files changed, 34 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt_ops-add-flush_tlb_others-paravirt_op arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt_ops-add-flush_tlb_others-paravirt_op
+++ a/arch/i386/kernel/paravirt.c
@@ -300,6 +300,7 @@ struct paravirt_ops paravirt_ops = {
 	.flush_tlb_user = native_flush_tlb,
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
+	.flush_tlb_others = native_flush_tlb_others,
 
 	.map_pt_hook = paravirt_nop,
 
diff -puN arch/i386/kernel/smp.c~paravirt_ops-add-flush_tlb_others-paravirt_op arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~paravirt_ops-add-flush_tlb_others-paravirt_op
+++ a/arch/i386/kernel/smp.c
@@ -256,7 +256,6 @@ static cpumask_t flush_cpumask;
 static struct mm_struct * flush_mm;
 static unsigned long flush_va;
 static DEFINE_SPINLOCK(tlbstate_lock);
-#define FLUSH_ALL	0xffffffff
 
 /*
  * We cannot call mmdrop() because we are in interrupt context, 
@@ -338,7 +337,7 @@ fastcall void smp_invalidate_interrupt(s
 		 
 	if (flush_mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
 		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
-			if (flush_va == FLUSH_ALL)
+			if (flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
 				__flush_tlb_one(flush_va);
@@ -353,9 +352,11 @@ out:
 	put_cpu_no_resched();
 }
 
-static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
-						unsigned long va)
+void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
+			     unsigned long va)
 {
+	cpumask_t cpumask = *cpumaskp;
+
 	/*
 	 * A couple of (to be removed) sanity checks:
 	 *
@@ -417,7 +418,7 @@ void flush_tlb_current_task(void)
 
 	local_flush_tlb();
 	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
@@ -436,7 +437,7 @@ void flush_tlb_mm (struct mm_struct * mm
 			leave_mm(smp_processor_id());
 	}
 	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
 
 	preempt_enable();
 }
diff -puN include/asm-i386/paravirt.h~paravirt_ops-add-flush_tlb_others-paravirt_op include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-add-flush_tlb_others-paravirt_op
+++ a/include/asm-i386/paravirt.h
@@ -15,6 +15,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
+#include <linux/cpumask.h>
 
 struct thread_struct;
 struct Xgt_desc_struct;
@@ -165,6 +166,8 @@ struct paravirt_ops
 	void (*flush_tlb_user)(void);
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_single)(unsigned long addr);
+	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
+				 unsigned long va);
 
 	void (*map_pt_hook)(int type, pte_t *va, u32 pfn);
 
@@ -723,6 +726,12 @@ static inline void __flush_tlb_single(un
 	PVOP_VCALL1(flush_tlb_single, addr);
 }
 
+static inline void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+				    unsigned long va)
+{
+	PVOP_VCALL3(flush_tlb_others, &cpumask, mm, va);
+}
+
 static inline void paravirt_map_pt_hook(int type, pte_t *va, u32 pfn)
 {
 	PVOP_VCALL3(map_pt_hook, type, va, pfn);
diff -puN include/asm-i386/tlbflush.h~paravirt_ops-add-flush_tlb_others-paravirt_op include/asm-i386/tlbflush.h
--- a/include/asm-i386/tlbflush.h~paravirt_ops-add-flush_tlb_others-paravirt_op
+++ a/include/asm-i386/tlbflush.h
@@ -79,11 +79,15 @@
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
  *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
+ *  - flush_tlb_others(cpumask, mm, va) flushes a TLBs on other cpus
  *
  * ..but the i386 has somewhat limited tlb flushing capabilities,
  * and page-granular flushes are available only on i486 and up.
  */
 
+#define TLB_FLUSH_ALL	0xffffffff
+
+
 #ifndef CONFIG_SMP
 
 #define flush_tlb() __flush_tlb()
@@ -110,7 +114,12 @@ static inline void flush_tlb_range(struc
 		__flush_tlb();
 }
 
-#else
+static inline void native_flush_tlb_others(const cpumask_t *cpumask,
+					   struct mm_struct *mm, unsigned long va)
+{
+}
+
+#else  /* SMP */
 
 #include <asm/smp.h>
 
@@ -129,6 +138,9 @@ static inline void flush_tlb_range(struc
 	flush_tlb_mm(vma->vm_mm);
 }
 
+void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
+			     unsigned long va);
+
 #define TLBSTATE_OK	1
 #define TLBSTATE_LAZY	2
 
@@ -139,8 +151,11 @@ struct tlb_state
 	char __cacheline_padding[L1_CACHE_BYTES-8];
 };
 DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
+#endif	/* SMP */
 
-
+#ifndef CONFIG_PARAVIRT
+#define flush_tlb_others(mask, mm, va)		\
+	native_flush_tlb_others(&mask, mm, va)
 #endif
 
 #define flush_tlb_kernel_range(start, end) flush_tlb_all()
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
