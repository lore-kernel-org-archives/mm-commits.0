From: akpm@linux-foundation.org
Subject: [folded] writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch removed from -mm tree
Date: Wed, 01 Jun 2011 15:27:22 -0700
Message-ID: <201106012227.p51MRMua013372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233Ab1FAW2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 18:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, Trond.Myklebust@netapp.com, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, hch@lst.de, jack@suse.cz, kitayama@cl.bb4u.ne.jp, mel@linux.vnet.ibm.comm


The patch titled
     mmotm: fix hang at startup
has been removed from the -mm tree.  Its filename was
     writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch

This patch was dropped because it was folded into writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmotm: fix hang at startup
From: Hugh Dickins <hughd@google.com>

Yesterday's mmotm hangs at startup, and with lockdep it reports:
BUG: spinlock recursion on CPU#1, blkid/284 - with bdi_lock_two()
called from bdev_inode_switch_bdi() in the backtrace.  It appears
that this function is sometimes called with new the same as old.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
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

 fs/block_dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/block_dev.c~writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix fs/block_dev.c
--- a/fs/block_dev.c~writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix
+++ a/fs/block_dev.c
@@ -57,6 +57,8 @@ static void bdev_inode_switch_bdi(struct
 {
 	struct backing_dev_info *old = inode->i_data.backing_dev_info;
 
+	if (dst == old)
+		return;
 	bdi_lock_two(&old->wb, &dst->wb);
 	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
_

Patches currently in -mm which might be from hughd@google.com are

writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
prio_tree-debugging-patch.patch

