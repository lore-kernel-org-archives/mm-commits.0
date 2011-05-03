From: akpm@linux-foundation.org
Subject: + writeback-avoid-extra-sync-work-at-enqueue-time.patch added to -mm tree
Date: Tue, 03 May 2011 15:20:35 -0700
Message-ID: <201105032220.p43MKax2013893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138Ab1ECWVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 18:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, david@fromorbit.com, hch@lst.de, jack@suse.cz


The patch titled
     writeback: avoid extra sync work at enqueue time
has been added to the -mm tree.  Its filename is
     writeback-avoid-extra-sync-work-at-enqueue-time.patch

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

mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
writeback-pass-writeback_control-down-to-move_expired_inodes.patch
writeback-introduce-writeback_controlinodes_cleaned.patch
writeback-try-more-writeback-as-long-as-something-was-written.patch
writeback-the-kupdate-expire-timestamp-should-be-a-moving-target.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-refill-b_io-iff-empty.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
writeback-elevate-queue_io-into-wb_writeback.patch
writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage.patch
writeback-update-dirtied_when-for-synced-inode-to-prevent-livelock.patch
writeback-avoid-extra-sync-work-at-enqueue-time.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
readahead-return-early-when-readahead-is-disabled.patch
readahead-reduce-unnecessary-mmap_miss-increases.patch
readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch

