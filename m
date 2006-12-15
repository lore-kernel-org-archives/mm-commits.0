From: akpm@osdl.org
Subject: + paravirt-paravirt-cpu-hypercall-batching-mode.patch added to -mm tree
Date: Fri, 15 Dec 2006 14:27:15 -0800
Message-ID: <200612152227.kBFMRFwc002964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50224 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030225AbWLOW1t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 17:27:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au


The patch titled
     paravirt: paravirt CPU hypercall batching mode
has been added to the -mm tree.  Its filename is
     paravirt-paravirt-cpu-hypercall-batching-mode.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: paravirt: paravirt CPU hypercall batching mode
From: Zachary Amsden <zach@vmware.com>

The VMI ROM has a mode where hypercalls can be queued and batched.  This turns
out to be a significant win during context switch, but must be done at a
specific point before side effects to CPU state are visible to subsequent
instructions.  This is similar to the MMU batching hooks already provided. 
The same hooks could be used by the Xen backend to implement a context switch
multicall.

To explain a bit more about lazy modes in the paravirt patches, basically, the
idea is that only one of lazy CPU or MMU mode can be active at any given time.
 Lazy MMU mode is similar to this lazy CPU mode, and allows for batching of
multiple PTE updates (say, inside a remap loop), but to avoid keeping some
kind of state machine about when to flush cpu or mmu updates, we just allow
one or the other to be active.  Although there is no real reason a more
comprehensive scheme could not be implemented, there is also no demonstrated
need for this extra complexity.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/paravirt.c   |    1 +
 arch/i386/kernel/process.c    |   25 +++++++++++++++++--------
 include/asm-generic/pgtable.h |   13 +++++++++++++
 include/asm-i386/paravirt.h   |   15 +++++++++++++++
 kernel/sched.c                |    7 +++++++
 5 files changed, 53 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt-paravirt-cpu-hypercall-batching-mode arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt-paravirt-cpu-hypercall-batching-mode
+++ a/arch/i386/kernel/paravirt.c
@@ -545,6 +545,7 @@ struct paravirt_ops paravirt_ops = {
 	.apic_write_atomic = native_apic_write_atomic,
 	.apic_read = native_apic_read,
 #endif
+	.set_lazy_mode = (void *)native_nop,
 
 	.flush_tlb_user = native_flush_tlb,
 	.flush_tlb_kernel = native_flush_tlb_global,
diff -puN arch/i386/kernel/process.c~paravirt-paravirt-cpu-hypercall-batching-mode arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~paravirt-paravirt-cpu-hypercall-batching-mode
+++ a/arch/i386/kernel/process.c
@@ -665,14 +665,6 @@ struct task_struct fastcall * __switch_t
 	load_TLS(next, cpu);
 
 	/*
-	 * Restore %gs if needed (which is common)
-	 */
-	if (prev->gs | next->gs)
-		loadsegment(gs, next->gs);
-
-	write_pda(pcurrent, next_p);
-
-	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
 	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW)
@@ -681,6 +673,15 @@ struct task_struct fastcall * __switch_t
 
 	disable_tsc(prev_p, next_p);
 
+	/*
+	 * Leave lazy mode, flushing any hypercalls made here.
+	 * This must be done before restoring TLS segments so
+	 * the GDT and LDT are properly updated, and must be
+	 * done before math_state_restore, so the TS bit is up
+	 * to date.
+	 */
+	arch_leave_lazy_cpu_mode();
+
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
@@ -688,6 +689,14 @@ struct task_struct fastcall * __switch_t
 	if (next_p->fpu_counter > 5)
 		math_state_restore();
 
+	/*
+	 * Restore %gs if needed (which is common)
+	 */
+	if (prev->gs | next->gs)
+		loadsegment(gs, next->gs);
+
+	write_pda(pcurrent, next_p);
+
 	return prev_p;
 }
 
diff -puN include/asm-generic/pgtable.h~paravirt-paravirt-cpu-hypercall-batching-mode include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~paravirt-paravirt-cpu-hypercall-batching-mode
+++ a/include/asm-generic/pgtable.h
@@ -183,6 +183,19 @@ static inline void ptep_set_wrprotect(st
 #endif
 
 /*
+ * A facility to provide batching of the reload of page tables with the
+ * actual context switch code for paravirtualized guests.  By convention,
+ * only one of the lazy modes (CPU, MMU) should be active at any given
+ * time, entry should never be nested, and entry and exits should always
+ * be paired.  This is for sanity of maintaining and reasoning about the
+ * kernel code.
+ */
+#ifndef __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+#define arch_leave_lazy_cpu_mode()	do {} while (0)
+#endif
+
+/*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
  * vma end wraps to 0, rounded up __boundary may wrap to 0 throughout.
diff -puN include/asm-i386/paravirt.h~paravirt-paravirt-cpu-hypercall-batching-mode include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt-paravirt-cpu-hypercall-batching-mode
+++ a/include/asm-i386/paravirt.h
@@ -146,6 +146,8 @@ struct paravirt_ops
 	void (fastcall *pmd_clear)(pmd_t *pmdp);
 #endif
 
+	void (fastcall *set_lazy_mode)(int mode);
+
 	/* These two are jmp to, not actually called. */
 	void (fastcall *irq_enable_sysexit)(void);
 	void (fastcall *iret)(void);
@@ -386,6 +388,19 @@ static inline void pmd_clear(pmd_t *pmdp
 }
 #endif
 
+/* Lazy mode for batching updates / context switch */
+#define PARAVIRT_LAZY_NONE 0
+#define PARAVIRT_LAZY_MMU  1
+#define PARAVIRT_LAZY_CPU  2
+
+#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+#define arch_enter_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_CPU)
+#define arch_leave_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+
+#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
+#define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch {
 	u8 *instr; 		/* original instructions */
diff -puN kernel/sched.c~paravirt-paravirt-cpu-hypercall-batching-mode kernel/sched.c
--- a/kernel/sched.c~paravirt-paravirt-cpu-hypercall-batching-mode
+++ a/kernel/sched.c
@@ -1842,6 +1842,13 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm = next->mm;
 	struct mm_struct *oldmm = prev->active_mm;
 
+	/*
+	 * For paravirt, this is coupled with an exit in switch_to to
+	 * combine the page table reload and the switch backend into
+	 * one hypercall.
+	 */
+	arch_enter_lazy_cpu_mode();
+
 	if (!mm) {
 		next->active_mm = oldmm;
 		atomic_inc(&oldmm->mm_count);
_

Patches currently in -mm which might be from zach@vmware.com are

convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
paravirt-page-allocation-hooks-for-vmi-backend.patch
paravirt-paravirt-cpu-hypercall-batching-mode.patch
paravirt-iopl-handling-for-paravirt-guests.patch
paravirt-smp-boot-hook-for-paravirt.patch
paravirt-vmi-backend-for-paravirt-ops.patch
paravirt-vmi-timer-patches.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch

