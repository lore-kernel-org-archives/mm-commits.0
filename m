From: akpm@linux-foundation.org
Subject: [merged] writeback-introduce-writeback_controlinodes_cleaned.patch removed from -mm tree
Date: Thu, 09 Jun 2011 12:05:24 -0700
Message-ID: <201106091904.p59J4BCT025376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab1FITFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 15:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, david@fromorbit.com, jack@suse.cz, kitayama@cl.bb4u.ne.jp, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     writeback: introduce writeback_control.inodes_cleaned
has been removed from the -mm tree.  Its filename was
     writeback-introduce-writeback_controlinodes_cleaned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: introduce writeback_control.inodes_cleaned
From: Wu Fengguang <fengguang.wu@intel.com>

The flusher works on dirty inodes in batches, and may quit prematurely if
the batch of inodes happen to be metadata-only dirtied: in this case
wbc->nr_to_write won't be decreased at all, which stands for "no pages
written" but also mis-interpreted as "no progress".

So introduce writeback_control.inodes_cleaned to count the number of
inodes which get cleaned.  A non-zero value means there was some progress
on writeback, in which case more writeback can be tried.

about v1: The initial version was to count successful ->write_inode()
calls.  However it leads to busy loops for sync() over NFS, because NFS
ridiculously returns 0 (success) while at the same time redirties the
inode.  The NFS case can be trivially fixed, however there may be more
hidden bugs in other filesystems..

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |    4 ++++
 include/linux/writeback.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN fs/fs-writeback.c~writeback-introduce-writeback_controlinodes_cleaned fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-introduce-writeback_controlinodes_cleaned
+++ a/fs/fs-writeback.c
@@ -454,6 +454,7 @@ writeback_single_inode(struct inode *ino
 			 * No need to add it back to the LRU.
 			 */
 			list_del_init(&inode->i_wb_list);
+			wbc->inodes_cleaned++;
 		}
 	}
 	inode_sync_complete(inode);
@@ -716,6 +717,7 @@ static long wb_writeback(struct bdi_writ
 		wbc.more_io = 0;
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
+		wbc.inodes_cleaned = 0;
 
 		trace_wbc_writeback_start(&wbc, wb->bdi);
 		if (work->sb)
@@ -732,6 +734,8 @@ static long wb_writeback(struct bdi_writ
 		 */
 		if (wbc.nr_to_write <= 0)
 			continue;
+		if (wbc.inodes_cleaned)
+			continue;
 		/*
 		 * Didn't write everything and we don't have more IO, bail
 		 */
diff -puN include/linux/writeback.h~writeback-introduce-writeback_controlinodes_cleaned include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-introduce-writeback_controlinodes_cleaned
+++ a/include/linux/writeback.h
@@ -34,6 +34,7 @@ struct writeback_control {
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
+	long inodes_cleaned;		/* # of inodes cleaned */
 
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

