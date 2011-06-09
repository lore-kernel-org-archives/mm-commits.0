From: akpm@linux-foundation.org
Subject: [merged] writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage.patch removed from -mm tree
Date: Thu, 09 Jun 2011 12:05:39 -0700
Message-ID: <201106091904.p59J4QNj025472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142Ab1FITFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 15:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     writeback: introduce wbc.tagged_sync for the WB_SYNC_NONE sync stage
has been removed from the -mm tree.  Its filename was
     writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: introduce wbc.tagged_sync for the WB_SYNC_NONE sync stage
From: Wu Fengguang <fengguang.wu@intel.com>

sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
WB_SYNC_ALL sync.  Tag the first stage with wbc.tagged_sync and do
livelock prevention for it, too.

Note that writeback_inodes_sb() is called by not only sync(), they are
treated the same because the other callers need also need livelock
prevention.

Impacts:

- it changes the order in which pages/inodes are synced to disk. Now in
  the WB_SYNC_NONE stage, it won't proceed to write the next inode until
  finished with the current inode.

- this adds a new field to the writeback trace events and may possibly
  break some scripts.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c           |    4 ++--
 fs/fs-writeback.c         |    9 +++++----
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |    4 ++--
 4 files changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/ext4/inode.c~writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage fs/ext4/inode.c
--- a/fs/ext4/inode.c~writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage
+++ a/fs/ext4/inode.c
@@ -2741,7 +2741,7 @@ static int write_cache_pages_da(struct a
 	index = wbc->range_start >> PAGE_CACHE_SHIFT;
 	end = wbc->range_end >> PAGE_CACHE_SHIFT;
 
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
@@ -2975,7 +2975,7 @@ static int ext4_da_writepages(struct add
 	}
 
 retry:
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
 		tag_pages_for_writeback(mapping, index, end);
 
 	while (!ret && wbc->nr_to_write > 0) {
diff -puN fs/fs-writeback.c~writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage
+++ a/fs/fs-writeback.c
@@ -36,6 +36,7 @@ struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
+	unsigned int tagged_sync:1;
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
@@ -644,6 +645,7 @@ static long wb_writeback(struct bdi_writ
 {
 	struct writeback_control wbc = {
 		.sync_mode		= work->sync_mode,
+		.tagged_sync		= work->tagged_sync,
 		.older_than_this	= NULL,
 		.for_kupdate		= work->for_kupdate,
 		.for_background		= work->for_background,
@@ -651,7 +653,7 @@ static long wb_writeback(struct bdi_writ
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
-	long write_chunk;
+	long write_chunk = MAX_WRITEBACK_PAGES;
 	struct inode *inode;
 
 	if (!wbc.range_cyclic) {
@@ -672,9 +674,7 @@ static long wb_writeback(struct bdi_writ
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
 	 */
-	if (wbc.sync_mode == WB_SYNC_NONE)
-		write_chunk = MAX_WRITEBACK_PAGES;
-	else
+	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
 		write_chunk = LONG_MAX;
 
 	wbc.wb_start = jiffies; /* livelock avoidance */
@@ -1209,6 +1209,7 @@ void writeback_inodes_sb_nr(struct super
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_NONE,
+		.tagged_sync	= 1,
 		.done		= &done,
 		.nr_pages	= nr,
 	};
diff -puN include/linux/writeback.h~writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage
+++ a/include/linux/writeback.h
@@ -46,6 +46,7 @@ struct writeback_control {
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
+	unsigned tagged_sync:1;		/* do livelock prevention for sync */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
diff -puN mm/page-writeback.c~writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-introduce-wbctagged_sync-for-the-wb_sync_none-sync-stage
+++ a/mm/page-writeback.c
@@ -892,12 +892,12 @@ int write_cache_pages(struct address_spa
 			range_whole = 1;
 		cycled = 1; /* ignore range_cyclic tests */
 	}
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
 retry:
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && (index <= end)) {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

