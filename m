From: akpm@linux-foundation.org
Subject: [merged] block-fix-use-after-free-bug-in-__blkdev_get.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:53:34 -0700
Message-ID: <200910302053.n9UKrYAw018065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932857AbZJ3Uyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, jens.axboe@oracle.com, stable@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     block: fix use after free bug in __blkdev_get
has been removed from the -mm tree.  Its filename was
     block-fix-use-after-free-bug-in-__blkdev_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: fix use after free bug in __blkdev_get
From: Neil Brown <neilb@suse.de>

commit 0762b8bde9729f10f8e6249809660ff2ec3ad735 ("block: always set
bdev->bd_part") (from 14 months ago) introduced a use-after-free bug which
has just recently started manifesting in my md testing.  I tried git
bisect to find out what caused the bug to start manifesting, and it could
have been the recent change to blk_unregister_queue (48c0d4d4c04) but the
results were inconclusive.

This patch certainly fixes my symptoms and looks correct as the two calls
are now in the same order as elsewhere in that function.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/block_dev.c~block-fix-use-after-free-bug-in-__blkdev_get fs/block_dev.c
--- a/fs/block_dev.c~block-fix-use-after-free-bug-in-__blkdev_get
+++ a/fs/block_dev.c
@@ -1258,8 +1258,8 @@ static int __blkdev_get(struct block_dev
 			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
 		}
 	} else {
-		put_disk(disk);
 		module_put(disk->fops->owner);
+		put_disk(disk);
 		disk = NULL;
 		if (bdev->bd_contains == bdev) {
 			if (bdev->bd_disk->fops->open) {
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch

