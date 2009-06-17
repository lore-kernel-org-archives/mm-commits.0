From: akpm@linux-foundation.org
Subject: [folded] gru-dynamic-allocation-of-kernel-contexts-update.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:56:57 -0700
Message-ID: <200906172256.n5HMuwVk016468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153AbZFQW51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru-dynamic-allocation-of-kernel-contexts-update
has been removed from the -mm tree.  Its filename was
     gru-dynamic-allocation-of-kernel-contexts-update.patch

This patch was dropped because it was folded into gru-dynamic-allocation-of-kernel-contexts.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru-dynamic-allocation-of-kernel-contexts-update
From: Jack Steiner <steiner@sgi.com>

Added fixes from Andrew.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grumain.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sgi-gru/grumain.c~gru-dynamic-allocation-of-kernel-contexts-update drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-dynamic-allocation-of-kernel-contexts-update
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -804,8 +804,9 @@ again:
 
 	if (!gts->ts_gru) {
 		if (!gru_assign_gru_context(gts, blade_id)) {
-			mutex_unlock(&gts->ts_ctxlock);
 			preempt_enable();
+			mutex_unlock(&gts->ts_ctxlock);
+			set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(GRU_ASSIGN_DELAY);  /* true hack ZZZ */
 			blade_id = uv_numa_blade_id();
 			if (gts->ts_steal_jiffies + GRU_STEAL_DELAY < jiffies)
@@ -819,8 +820,8 @@ again:
 				vma->vm_page_prot);
 	}
 
-	mutex_unlock(&gts->ts_ctxlock);
 	preempt_enable();
+	mutex_unlock(&gts->ts_ctxlock);
 
 	return VM_FAULT_NOPAGE;
 }
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch
gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-dynamic-allocation-of-kernel-contexts-update.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
gru-update-gru-kernel-self-tests.patch
gru-update-gru-kernel-self-tests-fix.patch
gru-update-to-rev-09-of-gru-spec.patch
gru-fix-cache-coherency-issues-with-instruction-retry.patch
gru-add-user-request-to-explicitly-unload-a-gru-context.patch
gru-fix-automatic-retry-of-gru-instruction-failures.patch
gru-collect-per-context-user-statistics.patch
gru-delete-user-request-for-fetching-chiplet-status.patch
gru-cleanup-gru-inline-functions.patch
gru-generic-infrastructure-for-context-options.patch
gru-add-user-request-to-specify-gru-slice.patch
gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch
gru-fixes-to-grudump-utility.patch
gru-remove-references-to-the-obsolete-global-status-handle.patch
gru-copyright-fixes.patch

