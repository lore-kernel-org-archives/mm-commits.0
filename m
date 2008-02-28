From: akpm@linux-foundation.org
Subject: + device-mapper-not-reporting-no-barrier-support.patch added to -mm tree
Date: Wed, 27 Feb 2008 23:31:36 -0800
Message-ID: <200802280731.m1S7Vanb021747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbYB1HcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 02:32:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jens.axboe@oracle.com


The patch titled
     device mapper not reporting no-barrier-support?
has been added to the -mm tree.  Its filename is
     device-mapper-not-reporting-no-barrier-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-block-viodasdc-use-field_sizeof.patch
git-block.patch
git-block-git-rejects.patch
remove-ps2esdi.patch
kconfig-cleanup-block-kconfig-help-descriptions.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
use-page_cache_xxx-in-fs-splicec.patch
cciss-remove-read_ahead-define-and-use-block-layer-defaults.patch
kconfig-cleanup-block-kconfigiosched-help-descriptions.patch
device-mapper-not-reporting-no-barrier-support.patch
cciss-procfs-updates-to-display-info-about-many-volumes.patch
block-genhdc-check-class_register-return-value.patch
xen-make-blkif_getgeo-static.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
reiser4-specify-splice-file-operations.patch
