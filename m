From: akpm@linux-foundation.org
Subject: + x86-optimize-fatal-signal-checking.patch added to -mm tree
Date: Fri, 27 May 2011 16:09:50 -0700
Message-ID: <201105272309.p4RN9oSE026923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756953Ab1E0XKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 19:10:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: optimize fatal signal checking
has been added to the -mm tree.  Its filename is
     x86-optimize-fatal-signal-checking.patch

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

origin.patch
mm-increase-reclaim_distance-to-30.patch
x86-optimize-fatal-signal-checking.patch
slab-use-numa_no_node.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

