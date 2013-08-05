From: akpm@linux-foundation.org
Subject: + x86-finish-user-fault-error-path-with-fatal-signal.patch added
 to -mm tree
Date: Mon, 05 Aug 2013 15:05:56 -0700
Message-ID: <520021c4.3w3GBjylifNqtuI9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3HEWF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 18:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, azurit@pobox.sk, hannes@cmpxchg.org

Subject: + x86-finish-user-fault-error-path-with-fatal-signal.patch added to -mm tree
To: hannes@cmpxchg.org,azurit@pobox.sk,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 15:05:56 -0700


The patch titled
     Subject: x86: finish user fault error path with fatal signal
has been added to the -mm tree.  Its filename is
     x86-finish-user-fault-error-path-with-fatal-signal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-finish-user-fault-error-path-with-fatal-signal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-finish-user-fault-error-path-with-fatal-signal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: x86: finish user fault error path with fatal signal

The x86 fault handler bails in the middle of error handling when the task
has a fatal signal pending.  For a subsequent patch this is a problem in
OOM situations because it relies on pagefault_out_of_memory() being called
even when the task has been killed, to perform proper per-task OOM state
unwinding.

Shortcutting the fault like this is a rather minor optimization that saves
a few instructions in rare cases.  Just remove it for user-triggered
faults.

Use the opportunity to split the fault retry handling from actual fault
errors and add locking documentation that reads suprisingly similar to
ARM's.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: azurIt <azurit@pobox.sk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff -puN arch/x86/mm/fault.c~x86-finish-user-fault-error-path-with-fatal-signal arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86-finish-user-fault-error-path-with-fatal-signal
+++ a/arch/x86/mm/fault.c
@@ -842,23 +842,15 @@ do_sigbus(struct pt_regs *regs, unsigned
 	force_sig_info_fault(SIGBUS, code, address, tsk, fault);
 }
 
-static noinline int
+static noinline void
 mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 	       unsigned long address, unsigned int fault)
 {
-	/*
-	 * Pagefault was interrupted by SIGKILL. We have no reason to
-	 * continue pagefault.
-	 */
-	if (fatal_signal_pending(current)) {
-		if (!(fault & VM_FAULT_RETRY))
-			up_read(&current->mm->mmap_sem);
-		if (!(error_code & PF_USER))
-			no_context(regs, error_code, address, 0, 0);
-		return 1;
+	if (fatal_signal_pending(current) && !(error_code & PF_USER)) {
+		up_read(&current->mm->mmap_sem);
+		no_context(regs, error_code, address, 0, 0);
+		return;
 	}
-	if (!(fault & VM_FAULT_ERROR))
-		return 0;
 
 	if (fault & VM_FAULT_OOM) {
 		/* Kernel mode? Handle exceptions or die: */
@@ -866,7 +858,7 @@ mm_fault_error(struct pt_regs *regs, uns
 			up_read(&current->mm->mmap_sem);
 			no_context(regs, error_code, address,
 				   SIGSEGV, SEGV_MAPERR);
-			return 1;
+			return;
 		}
 
 		up_read(&current->mm->mmap_sem);
@@ -884,7 +876,6 @@ mm_fault_error(struct pt_regs *regs, uns
 		else
 			BUG();
 	}
-	return 1;
 }
 
 static int spurious_fault_check(unsigned long error_code, pte_t *pte)
@@ -1189,9 +1180,17 @@ good_area:
 	 */
 	fault = handle_mm_fault(mm, vma, address, flags);
 
-	if (unlikely(fault & (VM_FAULT_RETRY|VM_FAULT_ERROR))) {
-		if (mm_fault_error(regs, error_code, address, fault))
-			return;
+	/*
+	 * If we need to retry but a fatal signal is pending, handle the
+	 * signal first. We do not need to release the mmap_sem because it
+	 * would already be released in __lock_page_or_retry in mm/filemap.c.
+	 */
+	if (unlikely((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)))
+		return;
+
+	if (unlikely(fault & VM_FAULT_ERROR)) {
+		mm_fault_error(regs, error_code, address, fault);
+		return;
 	}
 
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
mm-kill-one-if-loop-in-__free_pages_bootmem.patch
mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch
mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
mm-page_alloc-fair-zone-allocator-policy.patch
mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

