From: akpm@linux-foundation.org
Subject: + mempool-fix-first-round-failure-behavior.patch added to -mm tree
Date: Wed, 21 Dec 2011 16:33:10 -0800
Message-ID: <20111222003311.752815C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:42720 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1LVAdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 19:33:13 -0500
Received: by faar15 with SMTP id r15so259260faa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2011 16:33:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: mempool: fix first round failure behavior
has been added to the -mm tree.  Its filename is
     mempool-fix-first-round-failure-behavior.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mempool: fix first round failure behavior

For the initial allocation, mempool passes modified gfp mask to the
backing allocator so that it doesn't try too hard when there are reserved
elements waiting in the pool; however, when that allocation fails and pool
is empty too, it either waits for the pool to be replenished before
retrying or fails if !__GFP_WAIT.

* If the caller was calling in with GFP_ATOMIC, it never gets to try
  emergency reserve.  Allocations which would have succeeded without
  mempool may fail, which is just wrong.

* Allocation which could have succeeded after a bit of reclaim now has
  to wait on the reserved items and it's not like mempool doesn't retry
  with the original gfp mask.  It just does that *after* someone returns
  an element, pointlessly delaying things.

Fix it by retrying immediately with the gfp mask requested by the caller
if the first round of allocation attempts fails with modified mask.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/mempool.c~mempool-fix-first-round-failure-behavior mm/mempool.c
--- a/mm/mempool.c~mempool-fix-first-round-failure-behavior
+++ a/mm/mempool.c
@@ -221,14 +221,24 @@ repeat_alloc:
 		return element;
 	}
 
-	/* We must not sleep in the GFP_ATOMIC case */
+	/*
+	 * We use modified gfp mask for the first round.  If alloc failed
+	 * with that and @pool was empty too, immediately retry with the
+	 * original gfp mask.
+	 */
+	if (gfp_temp != gfp_mask) {
+		gfp_temp = gfp_mask;
+		spin_unlock_irqrestore(&pool->lock, flags);
+		goto repeat_alloc;
+	}
+
+	/* We must not sleep if !__GFP_WAIT */
 	if (!(gfp_mask & __GFP_WAIT)) {
 		spin_unlock_irqrestore(&pool->lock, flags);
 		return NULL;
 	}
 
 	/* Let's wait for someone else to return an element to @pool */
-	gfp_temp = gfp_mask;
 	init_wait(&wait);
 	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
 
_
Subject: Subject: mempool: fix first round failure behavior

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch
mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patch
mm-bootmem-try-harder-to-free-pages-in-bulk.patch
mempool-fix-and-document-synchronization-and-memory-barrier-usage.patch
mempool-drop-unnecessary-and-incorrect-bug_on-from-mempool_destroy.patch
mempool-fix-first-round-failure-behavior.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
sysctl-add-the-kernelns_last_pid-control.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

