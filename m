From: akpm@linux-foundation.org
Subject: + mm-swap-introduce-swp_synchronous_io.patch added to -mm tree
Date: Wed, 27 Sep 2017 14:05:58 -0700
Message-ID: <59cc12b6.m/eShDUyd8qm21II%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751580AbdI0VF7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 17:05:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, hch@lst.de, hughd@google.com, idryomov@gmail.com, ross.zwisler@linux.intel.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: introduce SWP_SYNCHRONOUS_IO
has been added to the -mm tree.  Its filename is
     mm-swap-introduce-swp_synchronous_io.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-introduce-swp_synchronous_io.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-introduce-swp_synchronous_io.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 ++-
 mm/swapfile.c        |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-swap-introduce-swp_synchronous_io include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-introduce-swp_synchronous_io
+++ a/include/linux/swap.h
@@ -170,8 +170,9 @@ enum {
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
@@ -3168,6 +3168,9 @@ SYSCALL_DEFINE2(swapon, const char __use
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

zram-fix-null-dereference-of-handle.patch
zram-fix-null-dereference-of-handle-v2.patch
zram-set-bdi_cap_stable_writes-once.patch
bdi-introduce-bdi_cap_synchronous_io.patch
mm-swap-introduce-swp_synchronous_io.patch
mm-swap-skip-swapcache-for-swapin-of-synchronous-device.patch

