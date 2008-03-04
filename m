From: akpm@linux-foundation.org
Subject: - device-mapper-not-reporting-no-barrier-support.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:40 -0800
Message-ID: <200803042009.m24K9exf026778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763440AbYCDUJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:09:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     device mapper not reporting no-barrier-support?
has been removed from the -mm tree.  Its filename was
     device-mapper-not-reporting-no-barrier-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: device mapper not reporting no-barrier-support?
From: Jens Axboe <jens.axboe@oracle.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-barrier.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN block/blk-barrier.c~device-mapper-not-reporting-no-barrier-support block/blk-barrier.c
--- a/block/blk-barrier.c~device-mapper-not-reporting-no-barrier-support
+++ a/block/blk-barrier.c
@@ -259,8 +259,11 @@ int blk_do_ordered(struct request_queue 
 
 static void bio_end_empty_barrier(struct bio *bio, int err)
 {
-	if (err)
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	}
 
 	complete(bio->bi_private);
 }
@@ -309,7 +312,9 @@ int blkdev_issue_flush(struct block_devi
 		*error_sector = bio->bi_sector;
 
 	ret = 0;
-	if (!bio_flagged(bio, BIO_UPTODATE))
+	if (bio_flagged(bio, BIO_EOPNOTSUPP))
+		ret = -EOPNOTSUPP;
+	else if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
 
 	bio_put(bio);
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

origin.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-block.patch
git-block-git-rejects.patch
remove-ps2esdi.patch
kconfig-cleanup-block-kconfig-help-descriptions.patch
kconfig-cleanup-block-kconfigiosched-help-descriptions.patch
block-genhdc-check-class_register-return-value.patch
xen-make-blkif_getgeo-static.patch
block-remove-remaining-__function__-occurances.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
reiser4-specify-splice-file-operations.patch

