From: akpm@linux-foundation.org
Subject: - git-block-more-xfs-fixes.patch removed from -mm tree
Date: Mon, 05 Feb 2007 12:41:32 -0800
Message-ID: <200702052041.l15KfWk2030589@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933437AbXBEUli (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 15:41:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jens.axboe@oracle.com, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     git-block: more XFS fixes
has been removed from the -mm tree.  Its filename was
     git-block-more-xfs-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-block: more XFS fixes
From: Jens Axboe <jens.axboe@oracle.com>

That down() probably wants a replug to precede it. Probably something
like:

        if (atomic_read(&bp->b_io_remaining))
                blk_replug_current_nested();

for xfs_buf_wait_unpin() and xfs_buf_lock(). Does this fix it?

Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/xfs/linux-2.6/xfs_buf.c |   12 ++++++++++++
 1 files changed, 12 insertions(+)

diff -puN fs/xfs/linux-2.6/xfs_buf.c~git-block-more-xfs-fixes fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~git-block-more-xfs-fixes
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -909,6 +909,8 @@ xfs_buf_lock(
 	xfs_buf_t		*bp)
 {
 	XB_TRACE(bp, "lock", 0);
+	if (atomic_read(&bp->b_io_remaining))
+		blk_replug_current_nested();
 	down(&bp->b_sema);
 	XB_SET_OWNER(bp);
 	XB_TRACE(bp, "locked", 0);
@@ -1291,6 +1293,8 @@ xfs_buf_iowait(
 	xfs_buf_t		*bp)
 {
 	XB_TRACE(bp, "iowait", 0);
+	if (atomic_read(&bp->b_io_remaining))
+		blk_replug_current_nested();
 	down(&bp->b_iodonesema);
 	XB_TRACE(bp, "iowaited", (long)bp->b_error);
 	return bp->b_error;
@@ -1682,6 +1686,7 @@ xfsbufd(
 	xfs_buf_t		*bp, *n;
 	struct list_head	*dwq = &target->bt_delwrite_queue;
 	spinlock_t		*dwlk = &target->bt_delwrite_lock;
+	int			count;
 
 	current->flags |= PF_MEMALLOC;
 
@@ -1697,6 +1702,7 @@ xfsbufd(
 		schedule_timeout_interruptible(
 			xfs_buf_timer_centisecs * msecs_to_jiffies(10));
 
+		count = 0;
 		age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
 		spin_lock(dwlk);
 		list_for_each_entry_safe(bp, n, dwq, b_list) {
@@ -1716,6 +1722,7 @@ xfsbufd(
 						 _XBF_RUN_QUEUES);
 				bp->b_flags |= XBF_WRITE;
 				list_move_tail(&bp->b_list, &tmp);
+				count++;
 			}
 		}
 		spin_unlock(dwlk);
@@ -1730,6 +1737,8 @@ xfsbufd(
 
 		if (as_list_len > 0)
 			purge_addresses();
+		if (count)
+			blk_replug_current_nested();
 
 		clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);
 	} while (!kthread_should_stop());
@@ -1786,6 +1795,9 @@ xfs_flush_buftarg(
 		xfs_buf_iostrategy(bp);
 	}
 
+	if (wait)
+		blk_replug_current_nested();
+
 	/*
 	 * Remaining list items must be flushed before returning
 	 */
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

git-block.patch
git-block-atomicity-fix.patch
git-block-dupe-definitions.patch
git-block-xfs-barriers-broke.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
reiser4-vs-git-block3.patch
sysctl-cdrom-dont-set-de-owner.patch
