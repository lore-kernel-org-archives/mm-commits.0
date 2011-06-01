From: akpm@linux-foundation.org
Subject: [merged] x86-optimize-fatal-signal-checking.patch removed from -mm tree
Date: Wed, 01 Jun 2011 13:34:03 -0700
Message-ID: <201106012033.p51KXan0008101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759483Ab1FAUd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 16:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: optimize fatal signal checking
has been removed from the -mm tree.  Its filename was
     x86-optimize-fatal-signal-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: optimize fatal signal checking
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Ingo suggested SIGKILL check should be moved into slowpath function.  It
may reduce page fault fastpath impact.  This patch do that.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff -puN arch/x86/mm/fault.c~x86-optimize-fatal-signal-checking arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86-optimize-fatal-signal-checking
+++ a/arch/x86/mm/fault.c
@@ -823,16 +823,30 @@ do_sigbus(struct pt_regs *regs, unsigned
 	force_sig_info_fault(SIGBUS, code, address, tsk, fault);
 }
 
-static noinline void
+static noinline int
 mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 	       unsigned long address, unsigned int fault)
 {
+	/*
+	 * Pagefault was interrupted by SIGKILL. We have no reason to
+	 * continue pagefault.
+	 */
+	if (fatal_signal_pending(current)) {
+		if (!(fault & VM_FAULT_RETRY))
+			up_read(&current->mm->mmap_sem);
+		if (!(error_code & PF_USER))
+			no_context(regs, error_code, address);
+		return 1;
+	}
+	if (!(fault & VM_FAULT_ERROR))
+		return 0;
+
 	if (fault & VM_FAULT_OOM) {
 		/* Kernel mode? Handle exceptions or die: */
 		if (!(error_code & PF_USER)) {
 			up_read(&current->mm->mmap_sem);
 			no_context(regs, error_code, address);
-			return;
+			return 1;
 		}
 
 		out_of_memory(regs, error_code, address);
@@ -843,6 +857,7 @@ mm_fault_error(struct pt_regs *regs, uns
 		else
 			BUG();
 	}
+	return 1;
 }
 
 static int spurious_fault_check(unsigned long error_code, pte_t *pte)
@@ -1133,19 +1148,9 @@ good_area:
 	 */
 	fault = handle_mm_fault(mm, vma, address, flags);
 
-	if (unlikely(fault & VM_FAULT_ERROR)) {
-		mm_fault_error(regs, error_code, address, fault);
-		return;
-	}
-
-	/*
-	 * Pagefault was interrupted by SIGKILL. We have no reason to
-	 * continue pagefault.
-	 */
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)) {
-		if (!(error_code & PF_USER))
-			no_context(regs, error_code, address);
-		return;
+	if (unlikely(fault & (VM_FAULT_RETRY|VM_FAULT_ERROR))) {
+		if (mm_fault_error(regs, error_code, address, fault))
+			return;
 	}
 
 	/*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

