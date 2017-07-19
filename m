From: akpm@linux-foundation.org
Subject: + zram-identify-asynchronous-ios-return-value.patch added to -mm
 tree
Date: Wed, 19 Jul 2017 16:08:19 -0700
Message-ID: <596fe663.ZteP6umPlk7bwVLV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39000 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933482AbdGSXIU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 19:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, juno.choi@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: identify asynchronous IO's return value
has been added to the -mm tree.  Its filename is
     zram-identify-asynchronous-ios-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-identify-asynchronous-ios-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-identify-asynchronous-ios-return-value.patch

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
Subject: zram: identify asynchronous IO's return value

For upcoming asynchronous IO like writeback, zram_rw_page should be aware
of that whether requested IO was completed or submitted successfully,
otherwise error.

For the goal, zram_bvec_rw has three return values.

-errno: returns error number
     0: IO request is done synchronously
     1: IO request is issued successfully.

Link: http://lkml.kernel.org/r/1498459987-24562-7-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-identify-asynchronous-ios-return-value drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-identify-asynchronous-ios-return-value
+++ a/drivers/block/zram/zram_drv.c
@@ -772,7 +772,7 @@ out:
 
 static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 {
-	int ret;
+	int ret = 0;
 	unsigned long alloced_pages;
 	unsigned long handle = 0;
 	unsigned int comp_len = 0;
@@ -876,7 +876,7 @@ out:
 
 	/* Update stats */
 	atomic64_inc(&zram->stats.pages_stored);
-	return 0;
+	return ret;
 }
 
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
@@ -958,6 +958,11 @@ static void zram_bio_discard(struct zram
 	}
 }
 
+/*
+ * Returns errno if it has some problem. Otherwise return 0 or 1.
+ * Returns 0 if IO request was done synchronously
+ * Returns 1 if IO request was successfully submitted.
+ */
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 			int offset, bool is_write)
 {
@@ -979,7 +984,7 @@ static int zram_bvec_rw(struct zram *zra
 
 	generic_end_io_acct(rw_acct, &zram->disk->part0, start_time);
 
-	if (unlikely(ret)) {
+	if (unlikely(ret < 0)) {
 		if (!is_write)
 			atomic64_inc(&zram->stats.failed_reads);
 		else
@@ -1072,7 +1077,7 @@ static void zram_slot_free_notify(struct
 static int zram_rw_page(struct block_device *bdev, sector_t sector,
 		       struct page *page, bool is_write)
 {
-	int offset, err = -EIO;
+	int offset, ret;
 	u32 index;
 	struct zram *zram;
 	struct bio_vec bv;
@@ -1081,7 +1086,7 @@ static int zram_rw_page(struct block_dev
 
 	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
 		atomic64_inc(&zram->stats.invalid_io);
-		err = -EINVAL;
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -1092,7 +1097,7 @@ static int zram_rw_page(struct block_dev
 	bv.bv_len = PAGE_SIZE;
 	bv.bv_offset = 0;
 
-	err = zram_bvec_rw(zram, &bv, index, offset, is_write);
+	ret = zram_bvec_rw(zram, &bv, index, offset, is_write);
 out:
 	/*
 	 * If I/O fails, just return error(ie, non-zero) without
@@ -1102,9 +1107,20 @@ out:
 	 * bio->bi_end_io does things to handle the error
 	 * (e.g., SetPageError, set_page_dirty and extra works).
 	 */
-	if (err == 0)
+	if (unlikely(ret < 0))
+		return ret;
+
+	switch (ret) {
+	case 0:
 		page_endio(page, is_write, 0);
-	return err;
+		break;
+	case 1:
+		ret = 0;
+		break;
+	default:
+		WARN_ON(1);
+	}
+	return ret;
 }
 
 static void zram_reset_device(struct zram *zram)
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch
zram-inlining-zram_compress.patch
zram-rename-zram_decompress_page-with-__zram_bvec_read.patch
zram-add-interface-to-specify-backing-device.patch
zram-add-free-space-management-in-backing-device.patch
zram-identify-asynchronous-ios-return-value.patch
zram-write-incompressible-pages-to-backing-device.patch
zram-read-page-from-backing-device.patch
zram-add-config-and-doc-file-for-writeback-feature.patch

