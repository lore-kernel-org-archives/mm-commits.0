From: akpm@linux-foundation.org
Subject: + writeback-elevate-queue_io-into-wb_writeback.patch added to -mm tree
Date: Tue, 26 Apr 2011 14:42:22 -0700
Message-ID: <201104262142.p3QLgMvg021322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932957Ab1DZV6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 17:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, Trond.Myklebust@netapp.com, axboe@kernel.dk, david@fromorbit.com, hch@lst.de, jack@suse.cz, kitayama@cl.bb4u.ne.jp, mel@linux.vnet.ibm.com, minchan.kim@gmail.com, npiggin@kernel.dk


The patch titled
     writeback: elevate queue_io() into wb_writeback()
has been added to the -mm tree.  Its filename is
     writeback-elevate-queue_io-into-wb_writeback.patch

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
Subject: writeback: elevate queue_io() into wb_writeback()
From: Wu Fengguang <fengguang.wu@intel.com>

Code refactor for more logical code layout.
No behavior change.

- remove the mis-named __writeback_inodes_sb()

- wb_writeback()/writeback_inodes_wb() will decide when to queue_io()
  before calling __writeback_inodes_wb()

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mel@linux.vnet.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN fs/fs-writeback.c~writeback-elevate-queue_io-into-wb_writeback fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-elevate-queue_io-into-wb_writeback
+++ a/fs/fs-writeback.c
@@ -570,17 +570,13 @@ static int writeback_sb_inodes(struct su
 	return 1;
 }
 
-void writeback_inodes_wb(struct bdi_writeback *wb,
-		struct writeback_control *wbc)
+static void __writeback_inodes_wb(struct bdi_writeback *wb,
+				  struct writeback_control *wbc)
 {
 	int ret = 0;
 
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
-	spin_lock(&wb->list_lock);
-
-	if (list_empty(&wb->b_io))
-		queue_io(wb, wbc);
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -596,19 +592,16 @@ void writeback_inodes_wb(struct bdi_writ
 		if (ret)
 			break;
 	}
-	spin_unlock(&wb->list_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
-static void __writeback_inodes_sb(struct super_block *sb,
-		struct bdi_writeback *wb, struct writeback_control *wbc)
+void writeback_inodes_wb(struct bdi_writeback *wb,
+		struct writeback_control *wbc)
 {
-	WARN_ON(!rwsem_is_locked(&sb->s_umount));
-
 	spin_lock(&wb->list_lock);
 	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc);
-	writeback_sb_inodes(sb, wb, wbc, true);
+	__writeback_inodes_wb(wb, wbc);
 	spin_unlock(&wb->list_lock);
 }
 
@@ -674,7 +667,7 @@ static long wb_writeback(struct bdi_writ
 	 * The intended call sequence for WB_SYNC_ALL writeback is:
 	 *
 	 *      wb_writeback()
-	 *          __writeback_inodes_sb()     <== called only once
+	 *          writeback_sb_inodes()       <== called only once
 	 *              write_cache_pages()     <== called once for each inode
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
@@ -722,10 +715,14 @@ static long wb_writeback(struct bdi_writ
 
 retry:
 		trace_wbc_writeback_start(&wbc, wb->bdi);
+		spin_lock(&wb->list_lock);
+		if (list_empty(&wb->b_io))
+			queue_io(wb, &wbc);
 		if (work->sb)
-			__writeback_inodes_sb(work->sb, wb, &wbc);
+			writeback_sb_inodes(work->sb, wb, &wbc, true);
 		else
-			writeback_inodes_wb(wb, &wbc);
+			__writeback_inodes_wb(wb, &wbc);
+		spin_unlock(&wb->list_lock);
 		trace_wbc_writeback_written(&wbc, wb->bdi);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
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
readahead-readahead-page-allocations-are-ok-to-fail.patch
readahead-return-early-when-readahead-is-disabled.patch
readahead-reduce-unnecessary-mmap_miss-increases.patch
readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
writeback-elevate-queue_io-into-wb_writeback.patch

