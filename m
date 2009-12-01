From: akpm@linux-foundation.org
Subject: + writeback-remove-unused-nonblocking-and-congestion-checks-xfs.patch added to -mm tree
Date: Tue, 01 Dec 2009 15:08:54 -0800
Message-ID: <200912012308.nB1N8sxG018599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbZLAXJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 18:09:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@gmail.com, Trond.Myklebust@netapp.com, aelder@sgi.com, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jens.axboe@oracle.com, zbr@ioremap.net


The patch titled
     writeback: remove unused nonblocking and congestion checks
has been added to the -mm tree.  Its filename is
     writeback-remove-unused-nonblocking-and-congestion-checks-xfs.patch

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
Subject: writeback: remove unused nonblocking and congestion checks
From: Wu Fengguang <fengguang.wu@gmail.com>

- no one is calling wb_writeback and write_cache_pages with
  wbc.nonblocking=1 any more
- lumpy pageout will want to do nonblocking writeback without the
  congestion wait

So remove the congestion checks as suggested by Chris.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alex Elder <aelder@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/pohmelfs/inode.c |   10 ----------
 fs/fs-writeback.c                |    9 ---------
 fs/xfs/linux-2.6/xfs_aops.c      |    9 +--------
 mm/page-writeback.c              |   12 ------------
 4 files changed, 1 insertion(+), 39 deletions(-)

diff -puN drivers/staging/pohmelfs/inode.c~writeback-remove-unused-nonblocking-and-congestion-checks-xfs drivers/staging/pohmelfs/inode.c
--- a/drivers/staging/pohmelfs/inode.c~writeback-remove-unused-nonblocking-and-congestion-checks-xfs
+++ a/drivers/staging/pohmelfs/inode.c
@@ -143,7 +143,6 @@ static int pohmelfs_writepages(struct ad
 	struct inode *inode = mapping->host;
 	struct pohmelfs_inode *pi = POHMELFS_I(inode);
 	struct pohmelfs_sb *psb = POHMELFS_SB(inode->i_sb);
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int err = 0;
 	int done = 0;
 	int nr_pages;
@@ -152,11 +151,6 @@ static int pohmelfs_writepages(struct ad
 	int scanned = 0;
 	int range_whole = 0;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
@@ -248,10 +242,6 @@ retry:
 
 			if (wbc->nr_to_write <= 0)
 				done = 1;
-			if (wbc->nonblocking && bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-			}
 
 			continue;
 out_continue:
diff -puN fs/fs-writeback.c~writeback-remove-unused-nonblocking-and-congestion-checks-xfs fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-remove-unused-nonblocking-and-congestion-checks-xfs
+++ a/fs/fs-writeback.c
@@ -658,14 +658,6 @@ static void writeback_inodes_wb(struct b
 			continue;
 		}
 
-		if (wbc->nonblocking && bdi_write_congested(wb->bdi)) {
-			wbc->encountered_congestion = 1;
-			if (!is_blkdev_sb)
-				break;		/* Skip a congested fs */
-			requeue_io(inode);
-			continue;		/* Skip a congested blockdev */
-		}
-
 		/*
 		 * Was this inode dirtied after sync_sb_inodes was called?
 		 * This keeps sync from extra jobs and livelock.
@@ -788,7 +780,6 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
 		writeback_inodes_wb(wb, &wbc);
diff -puN fs/xfs/linux-2.6/xfs_aops.c~writeback-remove-unused-nonblocking-and-congestion-checks-xfs fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~writeback-remove-unused-nonblocking-and-congestion-checks-xfs
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -864,16 +864,9 @@ xfs_convert_page(
 
 	if (startio) {
 		if (count) {
-			struct backing_dev_info *bdi;
-
-			bdi = inode->i_mapping->backing_dev_info;
 			wbc->nr_to_write--;
-			if (bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-			} else if (wbc->nr_to_write <= 0) {
+			if (wbc->nr_to_write <= 0)
 				done = 1;
-			}
 		}
 		xfs_start_page_writeback(page, !page_dirty, count);
 	}
diff -puN mm/page-writeback.c~writeback-remove-unused-nonblocking-and-congestion-checks-xfs mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-remove-unused-nonblocking-and-congestion-checks-xfs
+++ a/mm/page-writeback.c
@@ -821,7 +821,6 @@ int write_cache_pages(struct address_spa
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
 	int done = 0;
 	struct pagevec pvec;
@@ -834,11 +833,6 @@ int write_cache_pages(struct address_spa
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
-
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		writeback_index = mapping->writeback_index; /* prev offset */
@@ -957,12 +951,6 @@ continue_unlock:
 					break;
 				}
 			}
