From: akpm@linux-foundation.org
Subject: [merged] writeback-avoid-livelocking-wb_sync_all-writeback.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:31 -0800
Message-ID: <201101142247.p0EMlLBO004985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab1ANWrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hch@lst.de, jengelh@medozas.de, mm-commits@vger.kernel.org


The patch titled
     writeback: avoid livelocking WB_SYNC_ALL writeback
has been removed from the -mm tree.  Its filename was
     writeback-avoid-livelocking-wb_sync_all-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: avoid livelocking WB_SYNC_ALL writeback
From: Jan Kara <jack@suse.cz>

When wb_writeback() is called in WB_SYNC_ALL mode, work->nr_to_write is
usually set to LONG_MAX.  The logic in wb_writeback() then calls
__writeback_inodes_sb() with nr_to_write == MAX_WRITEBACK_PAGES and we
easily end up with non-positive nr_to_write after the function returns, if
the inode has more than MAX_WRITEBACK_PAGES dirty pages at the moment.

When nr_to_write is <= 0 wb_writeback() decides we need another round of
writeback but this is wrong in some cases!  For example when a single
large file is continuously dirtied, we would never finish syncing it
because each pass would be able to write MAX_WRITEBACK_PAGES and inode
dirty timestamp never gets updated (as inode is never completely clean). 
Thus __writeback_inodes_sb() would write the redirtied inode again and
again.

Fix the issue by setting nr_to_write to LONG_MAX in WB_SYNC_ALL mode.  We
do not need nr_to_write in WB_SYNC_ALL mode anyway since
write_cache_pages() does livelock avoidance using page tagging in
WB_SYNC_ALL mode.

This makes wb_writeback() call __writeback_inodes_sb() only once on
WB_SYNC_ALL.  The latter function won't livelock because it works on

- a finite set of files by doing queue_io() once at the beginning
- a finite set of pages by PAGECACHE_TAG_TOWRITE page tagging

After this patch, program from http://lkml.org/lkml/2010/10/24/154 is no
longer able to stall sync forever.

[fengguang.wu@intel.com: fix locking comment]
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de> 
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff -puN fs/fs-writeback.c~writeback-avoid-livelocking-wb_sync_all-writeback fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-avoid-livelocking-wb_sync_all-writeback
+++ a/fs/fs-writeback.c
@@ -630,6 +630,7 @@ static long wb_writeback(struct bdi_writ
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
+	long write_chunk;
 	struct inode *inode;
 
 	if (wbc.for_kupdate) {
@@ -642,6 +643,24 @@ static long wb_writeback(struct bdi_writ
 		wbc.range_end = LLONG_MAX;
 	}
 
+	/*
+	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
+	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
+	 * here avoids calling into writeback_inodes_wb() more than once.
+	 *
+	 * The intended call sequence for WB_SYNC_ALL writeback is:
+	 *
+	 *      wb_writeback()
+	 *          __writeback_inodes_sb()     <== called only once
+	 *              write_cache_pages()     <== called once for each inode
+	 *                   (quickly) tag currently dirty pages
+	 *                   (maybe slowly) sync all tagged pages
+	 */
+	if (wbc.sync_mode == WB_SYNC_NONE)
+		write_chunk = MAX_WRITEBACK_PAGES;
+	else
+		write_chunk = LONG_MAX;
+
 	wbc.wb_start = jiffies; /* livelock avoidance */
 	for (;;) {
 		/*
@@ -668,7 +687,7 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		wbc.more_io = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
 
 		trace_wbc_writeback_start(&wbc, wb->bdi);
@@ -678,8 +697,8 @@ static long wb_writeback(struct bdi_writ
 			writeback_inodes_wb(wb, &wbc);
 		trace_wbc_writeback_written(&wbc, wb->bdi);
 
-		work->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		work->nr_pages -= write_chunk - wbc.nr_to_write;
+		wrote += write_chunk - wbc.nr_to_write;
 
 		/*
 		 * If we consumed everything, see if we have more
@@ -694,7 +713,7 @@ static long wb_writeback(struct bdi_writ
 		/*
 		 * Did we write something? Try for more
 		 */
-		if (wbc.nr_to_write < MAX_WRITEBACK_PAGES)
+		if (wbc.nr_to_write < write_chunk)
 			continue;
 		/*
 		 * Nothing written. Wait for some inode to
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch

