From: akpm@linux-foundation.org
Subject: [merged] zram-mm-vs-block.patch removed from -mm tree
Date: Mon, 11 Sep 2017 12:38:02 -0700
Message-ID: <20170911193802.ZSzfcJpfL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdIKTiD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de, minchan@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: zram-mm-vs-block
has been removed from the -mm tree.  Its filename was
     zram-mm-vs-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-mm-vs-block

resolve interface changes from block tree

Cc: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-mm-vs-block drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-mm-vs-block
+++ a/drivers/block/zram/zram_drv.c
@@ -458,7 +458,7 @@ static int read_from_bdev_async(struct z
 		return -ENOMEM;
 
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
-	bio->bi_bdev = zram->bdev;
+	bio_set_dev(bio, zram->bdev);
 	if (!bio_add_page(bio, bvec->bv_page, bvec->bv_len, bvec->bv_offset)) {
 		bio_put(bio);
 		return -EIO;
@@ -552,7 +552,7 @@ static int write_to_bdev(struct zram *zr
 	}
 
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
-	bio->bi_bdev = zram->bdev;
+	bio_set_dev(bio, zram->bdev);
 	if (!bio_add_page(bio, bvec->bv_page, bvec->bv_len,
 					bvec->bv_offset)) {
 		bio_put(bio);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-git-rejects.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

