From: akpm@osdl.org
Subject: - bdev-fix-bd_part_count-leak.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:40 -0800
Message-ID: <200612082000.kB8K0ebZ001775@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56635 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426209AbWLHUAr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     bdev: fix ->bd_part_count leak
has been removed from the -mm tree.  Its filename was
     bdev-fix-bd_part_count-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bdev: fix ->bd_part_count leak
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Don't leak a ->bd_part_count when the partition open fails with -ENXIO.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/block_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~bdev-fix-bd_part_count-leak fs/block_dev.c
--- a/fs/block_dev.c~bdev-fix-bd_part_count-leak
+++ a/fs/block_dev.c
@@ -902,6 +902,7 @@ EXPORT_SYMBOL(bd_set_size);
 
 static int __blkdev_get(struct block_device *bdev, mode_t mode, unsigned flags,
 			int for_part);
+static int __blkdev_put(struct block_device *bdev, int for_part);
 
 static int do_open(struct block_device *bdev, struct file *file, int for_part)
 {
@@ -987,7 +988,7 @@ out_first:
 	bdev->bd_disk = NULL;
 	bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
 	if (bdev != bdev->bd_contains)
-		blkdev_put(bdev->bd_contains);
+		__blkdev_put(bdev->bd_contains, 1);
 	bdev->bd_contains = NULL;
 	put_disk(disk);
 	module_put(owner);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

