From: akpm@linux-foundation.org
Subject: [merged] writeback-avoid-extra-sync-work-at-enqueue-time.patch removed from -mm tree
Date: Thu, 09 Jun 2011 12:05:43 -0700
Message-ID: <201106091904.p59J4UWG025478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab1FITFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 15:05:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     writeback: avoid extra sync work at enqueue time
has been removed from the -mm tree.  Its filename was
     writeback-avoid-extra-sync-work-at-enqueue-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: avoid extra sync work at enqueue time
From: Wu Fengguang <fengguang.wu@intel.com>

This removes writeback_control.wb_start and does more straightforward sync
livelock prevention by setting .older_than_this to prevent extra inodes
from being enqueued in the first place.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |   17 ++++-------------
 include/linux/writeback.h |    3 ---
 2 files changed, 4 insertions(+), 16 deletions(-)

diff -puN fs/fs-writeback.c~writeback-avoid-extra-sync-work-at-enqueue-time fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-avoid-extra-sync-work-at-enqueue-time
+++ a/fs/fs-writeback.c
@@ -544,15 +544,6 @@ static int writeback_sb_inodes(struct su
 			continue;
 		}
 
-		/*
-		 * Was this inode dirtied after sync_sb_inodes was called?
-		 * This keeps sync from extra jobs and livelock.
-		 */
-		if (inode_dirtied_after(inode, wbc->wb_start)) {
-			spin_unlock(&inode->i_lock);
-			return 1;
-		}
-
 		__iget(inode);
 
 		pages_skipped = wbc->pages_skipped;
@@ -585,8 +576,6 @@ static void __writeback_inodes_wb(struct
 {
 	int ret = 0;
 
-	if (!wbc->wb_start)
-		wbc->wb_start = jiffies; /* livelock avoidance */
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -683,10 +672,12 @@ static long wb_writeback(struct bdi_writ
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
 	 */
-	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
+	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync) {
 		write_chunk = LONG_MAX;
+		oldest_jif = jiffies;
+		wbc.older_than_this = &oldest_jif;
+	}
 
-	wbc.wb_start = jiffies; /* livelock avoidance */
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
diff -puN include/linux/writeback.h~writeback-avoid-extra-sync-work-at-enqueue-time include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-avoid-extra-sync-work-at-enqueue-time
+++ a/include/linux/writeback.h
@@ -26,9 +26,6 @@ struct writeback_control {
 	enum writeback_sync_modes sync_mode;
 	unsigned long *older_than_this;	/* If !NULL, only write back inodes
 					   older than this */
-	unsigned long wb_start;         /* Time writeback_inodes_wb was
-					   called. This is needed to avoid
-					   extra jobs and livelock */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

