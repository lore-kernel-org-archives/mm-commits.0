From: akpm@linux-foundation.org
Subject: [merged] mempool-fix-first-round-failure-behavior.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:35 -0800
Message-ID: <20120111212835.A3F8610004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41779 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab2AKV2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:36 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so7466yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mempool: fix first round failure behavior
has been removed from the -mm tree.  Its filename was
     mempool-fix-first-round-failure-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mempool: fix first round failure behavior

mempool modifies gfp_mask so that the backing allocator doesn't try too
hard or trigger warning message when there's pool to fall back on.  In
addition, for the first try, it removes __GFP_WAIT and IO, so that it
doesn't trigger reclaim or wait when allocation can be fulfilled from
pool; however, when that allocation fails and pool is empty too, it waits
for the pool to be replenished before retrying.

Allocation which could have succeeded after a bit of reclaim has to wait
on the reserved items and it's not like mempool doesn't retry with
__GFP_WAIT and IO.  It just does that *after* someone returns an element,
pointlessly delaying things.

Fix it by retrying immediately if the first round of allocation attempts
w/o __GFP_WAIT and IO fails.

[akpm@linux-foundation.org: shorten the lock hold time]
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/mempool.c~mempool-fix-first-round-failure-behavior mm/mempool.c
--- a/mm/mempool.c~mempool-fix-first-round-failure-behavior
+++ a/mm/mempool.c
@@ -221,14 +221,23 @@ repeat_alloc:
 		return element;
 	}
 
-	/* We must not sleep in the GFP_ATOMIC case */
+	/*
+	 * We use gfp mask w/o __GFP_WAIT or IO for the first round.  If
+	 * alloc failed with that and @pool was empty, retry immediately.
+	 */
+	if (gfp_temp != gfp_mask) {
+		spin_unlock_irqrestore(&pool->lock, flags);
+		gfp_temp = gfp_mask;
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

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
sysctl-add-the-kernelns_last_pid-control.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

