From: akpm@linux-foundation.org
Subject: [merged] mm-swap-introduce-swp_synchronous_io.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:00:11 -0800
Message-ID: <20171116200011.egvjeglk-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46142 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934367AbdKPUAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, dan.j.williams@intel.com, hch@lst.de, hughd@google.com, idryomov@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, sergey.senozhatsky@gmail.com, ying.huang@intel.com


The patch titled
     Subject: mm, swap: introduce SWP_SYNCHRONOUS_IO
has been removed from the -mm tree.  Its filename was
     mm-swap-introduce-swp_synchronous_io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm, swap: introduce SWP_SYNCHRONOUS_IO

If rw-page based fast storage is used for swap devices, we need to detect
it to enhance swap IO operations.  This patch is preparation for
optimizing of swap-in operation with next patch.

Link: http://lkml.kernel.org/r/1505886205-9671-4-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 ++-
 mm/swapfile.c        |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-swap-introduce-swp_synchronous_io include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-introduce-swp_synchronous_io
+++ a/include/linux/swap.h
@@ -171,8 +171,9 @@ enum {
 	SWP_AREA_DISCARD = (1 << 8),	/* single-time swap area discards */
 	SWP_PAGE_DISCARD = (1 << 9),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 10),	/* no overwrite PG_writeback pages */
+	SWP_SYNCHRONOUS_IO = (1 << 11),	/* synchronous IO is efficient */
 					/* add others here before... */
-	SWP_SCANNING	= (1 << 11),	/* refcount in scan_swap_map */
+	SWP_SCANNING	= (1 << 12),	/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff -puN mm/swapfile.c~mm-swap-introduce-swp_synchronous_io mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-introduce-swp_synchronous_io
+++ a/mm/swapfile.c
@@ -3169,6 +3169,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (bdi_cap_stable_pages_required(inode_to_bdi(inode)))
 		p->flags |= SWP_STABLE_WRITES;
 
+	if (bdi_cap_synchronous_io(inode_to_bdi(inode)))
+		p->flags |= SWP_SYNCHRONOUS_IO;
+
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 		int cpu;
 		unsigned long ci, nr_cluster;
_

Patches currently in -mm which might be from minchan@kernel.org are


