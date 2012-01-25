From: akpm@linux-foundation.org
Subject: [merged] xen-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch removed from -mm tree
Date: Wed, 25 Jan 2012 12:42:07 -0800
Message-ID: <20120125204207.C3CD1A02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:46538 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2AYUmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2012 15:42:09 -0500
Received: by ghbg20 with SMTP id g20so548679ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2012 12:42:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@intel.com, cl@gentwo.org, jeremy@goop.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: xen: use this_cpu_xxx replace percpu_xxx funcs
has been removed from the -mm tree.  Its filename was
     xen-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: xen: use this_cpu_xxx replace percpu_xxx funcs

percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
for further code clean up.

I don't know much of xen code.  But, since the code is in x86
architecture, the percpu_xxx is exactly same as this_cpu_xxx serials
functions.  So, the change is safe.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/enlighten.c  |    6 +++---
 arch/x86/xen/irq.c        |    8 ++++----
 arch/x86/xen/mmu.c        |   20 ++++++++++----------
 arch/x86/xen/multicalls.h |    2 +-
 arch/x86/xen/smp.c        |    2 +-
 5 files changed, 19 insertions(+), 19 deletions(-)

diff -puN arch/x86/xen/enlighten.c~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs
+++ a/arch/x86/xen/enlighten.c
@@ -777,11 +777,11 @@ static DEFINE_PER_CPU(unsigned long, xen
 
 static unsigned long xen_read_cr0(void)
 {
-	unsigned long cr0 = percpu_read(xen_cr0_value);
+	unsigned long cr0 = this_cpu_read(xen_cr0_value);
 
 	if (unlikely(cr0 == 0)) {
 		cr0 = native_read_cr0();
-		percpu_write(xen_cr0_value, cr0);
+		this_cpu_write(xen_cr0_value, cr0);
 	}
 
 	return cr0;
@@ -791,7 +791,7 @@ static void xen_write_cr0(unsigned long 
 {
 	struct multicall_space mcs;
 
-	percpu_write(xen_cr0_value, cr0);
+	this_cpu_write(xen_cr0_value, cr0);
 
 	/* Only pay attention to cr0.TS; everything else is
 	   ignored. */
diff -puN arch/x86/xen/irq.c~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs arch/x86/xen/irq.c
--- a/arch/x86/xen/irq.c~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs
+++ a/arch/x86/xen/irq.c
@@ -26,7 +26,7 @@ static unsigned long xen_save_fl(void)
 	struct vcpu_info *vcpu;
 	unsigned long flags;
 
-	vcpu = percpu_read(xen_vcpu);
+	vcpu = this_cpu_read(xen_vcpu);
 
 	/* flag has opposite sense of mask */
 	flags = !vcpu->evtchn_upcall_mask;
@@ -50,7 +50,7 @@ static void xen_restore_fl(unsigned long
 	   make sure we're don't switch CPUs between getting the vcpu
 	   pointer and updating the mask. */
 	preempt_disable();
-	vcpu = percpu_read(xen_vcpu);
+	vcpu = this_cpu_read(xen_vcpu);
 	vcpu->evtchn_upcall_mask = flags;
 	preempt_enable_no_resched();
 
@@ -72,7 +72,7 @@ static void xen_irq_disable(void)
 	   make sure we're don't switch CPUs between getting the vcpu
 	   pointer and updating the mask. */
 	preempt_disable();
-	percpu_read(xen_vcpu)->evtchn_upcall_mask = 1;
+	this_cpu_read(xen_vcpu)->evtchn_upcall_mask = 1;
 	preempt_enable_no_resched();
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_irq_disable);
@@ -86,7 +86,7 @@ static void xen_irq_enable(void)
 	   the caller is confused and is trying to re-enable interrupts
 	   on an indeterminate processor. */
 
-	vcpu = percpu_read(xen_vcpu);
+	vcpu = this_cpu_read(xen_vcpu);
 	vcpu->evtchn_upcall_mask = 0;
 
 	/* Doesn't matter if we get preempted here, because any
diff -puN arch/x86/xen/mmu.c~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs
+++ a/arch/x86/xen/mmu.c
@@ -1071,14 +1071,14 @@ static void drop_other_mm_ref(void *info
 	struct mm_struct *mm = info;
 	struct mm_struct *active_mm;
 
-	active_mm = percpu_read(cpu_tlbstate.active_mm);
+	active_mm = this_cpu_read(cpu_tlbstate.active_mm);
 
-	if (active_mm == mm && percpu_read(cpu_tlbstate.state) != TLBSTATE_OK)
+	if (active_mm == mm && this_cpu_read(cpu_tlbstate.state) != TLBSTATE_OK)
 		leave_mm(smp_processor_id());
 
 	/* If this cpu still has a stale cr3 reference, then make sure
 	   it has been flushed. */
-	if (percpu_read(xen_current_cr3) == __pa(mm->pgd))
+	if (this_cpu_read(xen_current_cr3) == __pa(mm->pgd))
 		load_cr3(swapper_pg_dir);
 }
 
@@ -1185,17 +1185,17 @@ static void __init xen_pagetable_setup_d
 
 static void xen_write_cr2(unsigned long cr2)
 {
-	percpu_read(xen_vcpu)->arch.cr2 = cr2;
+	this_cpu_read(xen_vcpu)->arch.cr2 = cr2;
 }
 
 static unsigned long xen_read_cr2(void)
 {
-	return percpu_read(xen_vcpu)->arch.cr2;
+	return this_cpu_read(xen_vcpu)->arch.cr2;
 }
 
 unsigned long xen_read_cr2_direct(void)
 {
-	return percpu_read(xen_vcpu_info.arch.cr2);
+	return this_cpu_read(xen_vcpu_info.arch.cr2);
 }
 
 static void xen_flush_tlb(void)
@@ -1278,12 +1278,12 @@ static void xen_flush_tlb_others(const s
 
 static unsigned long xen_read_cr3(void)
 {
-	return percpu_read(xen_cr3);
+	return this_cpu_read(xen_cr3);
 }
 
 static void set_current_cr3(void *v)
 {
-	percpu_write(xen_current_cr3, (unsigned long)v);
+	this_cpu_write(xen_current_cr3, (unsigned long)v);
 }
 
 static void __xen_write_cr3(bool kernel, unsigned long cr3)
@@ -1306,7 +1306,7 @@ static void __xen_write_cr3(bool kernel,
 	xen_extend_mmuext_op(&op);
 
 	if (kernel) {
-		percpu_write(xen_cr3, cr3);
+		this_cpu_write(xen_cr3, cr3);
 
 		/* Update xen_current_cr3 once the batch has actually
 		   been submitted. */
@@ -1322,7 +1322,7 @@ static void xen_write_cr3(unsigned long 
 
 	/* Update while interrupts are disabled, so its atomic with
 	   respect to ipis */
-	percpu_write(xen_cr3, cr3);
+	this_cpu_write(xen_cr3, cr3);
 
 	__xen_write_cr3(true, cr3);
 
diff -puN arch/x86/xen/multicalls.h~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs arch/x86/xen/multicalls.h
--- a/arch/x86/xen/multicalls.h~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs
+++ a/arch/x86/xen/multicalls.h
@@ -47,7 +47,7 @@ static inline void xen_mc_issue(unsigned
 		xen_mc_flush();
 
 	/* restore flags saved in xen_mc_batch */
-	local_irq_restore(percpu_read(xen_mc_irq_flags));
+	local_irq_restore(this_cpu_read(xen_mc_irq_flags));
 }
 
 /* Set up a callback to be called when the current batch is flushed */
diff -puN arch/x86/xen/smp.c~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c~xen-use-this_cpu_xxx-replace-percpu_xxx-funcs
+++ a/arch/x86/xen/smp.c
@@ -76,7 +76,7 @@ static void __cpuinit cpu_bringup(void)
 	xen_setup_cpu_clockevents();
 
 	set_cpu_online(cpu, true);
-	percpu_write(cpu_state, CPU_ONLINE);
+	this_cpu_write(cpu_state, CPU_ONLINE);
 	wmb();
 
 	/* We can take interrupts now: we're officially "up". */
_

Patches currently in -mm which might be from alex.shi@intel.com are

linux-next.patch
net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable.patch
percpu-remove-percpu_xxx-functions.patch

