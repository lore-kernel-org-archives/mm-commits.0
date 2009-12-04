From: akpm@linux-foundation.org
Subject: [merged] writeback-remove-the-always-false-bdi_cap_writeback_dirty-test.patch removed from -mm tree
Date: Fri, 04 Dec 2009 12:33:34 -0800
Message-ID: <200912042033.nB4KXY6V011027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757127AbZLDUdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 15:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@gmail.com, Trond.Myklebust@netapp.com, fengguang.wu@intel.com, hch@infradead.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     writeback: remove the always false bdi_cap_writeback_dirty() test
has been removed from the -mm tree.  Its filename was
     writeback-remove-the-always-false-bdi_cap_writeback_dirty-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: remove the always false bdi_cap_writeback_dirty() test
From: Wu Fengguang <fengguang.wu@gmail.com>

This is dead code because no bdi flush thread will be started for
!bdi_cap_writeback_dirty bdi.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff -puN fs/fs-writeback.c~writeback-remove-the-always-false-bdi_cap_writeback_dirty-test fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-remove-the-always-false-bdi_cap_writeback_dirty-test
+++ a/fs/fs-writeback.c
@@ -615,7 +615,6 @@ static void writeback_inodes_wb(struct b
 				struct writeback_control *wbc)
 {
 	struct super_block *sb = wbc->sb, *pin_sb = NULL;
-	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
 	spin_lock(&inode_lock);
@@ -636,23 +635,6 @@ static void writeback_inodes_wb(struct b
 			continue;
 		}
 
-		if (!bdi_cap_writeback_dirty(wb->bdi)) {
-			redirty_tail(inode);
-			if (is_blkdev_sb) {
-				/*
-				 * Dirty memory-backed blockdev: the ramdisk
-				 * driver does this.  Skip just this inode
-				 */
-				continue;
-			}
-			/*
-			 * Dirty memory-backed inode against a filesystem other
-			 * than the kernel-internal bdev filesystem.  Skip the
-			 * entire superblock.
-			 */
-			break;
-		}
