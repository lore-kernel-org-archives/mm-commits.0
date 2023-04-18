Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94490C77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjDRXhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjDRXfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A728AA246
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 466F663A09
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C45BC433D2;
        Tue, 18 Apr 2023 23:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860893;
        bh=9yejQGY0+jkHCohum/xCRxkvBd7hpPw5WaI5PfGg9do=;
        h=Date:To:From:Subject:From;
        b=eZAaeVn67QaY1IyA6QD5YukaXeNrePj9IcWV+L6VW8FydpHFbbwTpnRxjDRp7RgYg
         wcsIz2/y/GOtJaa4h0bLnrcqJlPoAmKUpJ5ACnA2QgmLl9K4inunm7qTrN5/plHjrK
         fQXKEag5zfdJ1z2avenLlcSIzrMgTfpcewWTV5fA=
Date:   Tue, 18 Apr 2023 16:34:53 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-pass-a-page-to-read_from_bdev.patch removed from -mm tree
Message-Id: <20230418233453.9C45BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: pass a page to read_from_bdev
has been removed from the -mm tree.  Its filename was
     zram-pass-a-page-to-read_from_bdev.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: zram: pass a page to read_from_bdev
Date: Tue, 11 Apr 2023 19:14:56 +0200

read_from_bdev always reads a whole page, so pass a page to it instead of
the bvec and remove the now pointless zram_bvec_read_from_bdev wrapper.

Link: https://lkml.kernel.org/r/20230411171459.567614-15-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   43 +++++++++++---------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-pass-a-page-to-read_from_bdev
+++ a/drivers/block/zram/zram_drv.c
@@ -588,7 +588,7 @@ static void zram_page_end_io(struct bio
 /*
  * Returns 1 if the submission is successful.
  */
-static int read_from_bdev_async(struct zram *zram, struct bio_vec *bvec,
+static int read_from_bdev_async(struct zram *zram, struct page *page,
 			unsigned long entry, struct bio *parent)
 {
 	struct bio *bio;
@@ -599,7 +599,7 @@ static int read_from_bdev_async(struct z
 		return -ENOMEM;
 
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
-	if (!bio_add_page(bio, bvec->bv_page, bvec->bv_len, bvec->bv_offset)) {
+	if (!bio_add_page(bio, page, PAGE_SIZE, 0)) {
 		bio_put(bio);
 		return -EIO;
 	}
@@ -795,7 +795,7 @@ struct zram_work {
 	struct zram *zram;
 	unsigned long entry;
 	struct bio *bio;
-	struct bio_vec bvec;
+	struct page *page;
 };
 
 static void zram_sync_read(struct work_struct *work)
@@ -805,7 +805,7 @@ static void zram_sync_read(struct work_s
 	unsigned long entry = zw->entry;
 	struct bio *bio = zw->bio;
 
-	read_from_bdev_async(zram, &zw->bvec, entry, bio);
+	read_from_bdev_async(zram, zw->page, entry, bio);
 }
 
 /*
@@ -813,12 +813,12 @@ static void zram_sync_read(struct work_s
  * chained IO with parent IO in same context, it's a deadlock. To avoid that,
  * use a worker thread context.
  */
-static int read_from_bdev_sync(struct zram *zram, struct bio_vec *bvec,
+static int read_from_bdev_sync(struct zram *zram, struct page *page,
 				unsigned long entry, struct bio *bio)
 {
 	struct zram_work work;
 
-	work.bvec = *bvec;
+	work.page = page;
 	work.zram = zram;
 	work.entry = entry;
 	work.bio = bio;
@@ -831,20 +831,20 @@ static int read_from_bdev_sync(struct zr
 	return 1;
 }
 
-static int read_from_bdev(struct zram *zram, struct bio_vec *bvec,
+static int read_from_bdev(struct zram *zram, struct page *page,
 			unsigned long entry, struct bio *parent, bool sync)
 {
 	atomic64_inc(&zram->stats.bd_reads);
 	if (sync) {
 		if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
 			return -EIO;
-		return read_from_bdev_sync(zram, bvec, entry, parent);
+		return read_from_bdev_sync(zram, page, entry, parent);
 	}
-	return read_from_bdev_async(zram, bvec, entry, parent);
+	return read_from_bdev_async(zram, page, entry, parent);
 }
 #else
 static inline void reset_bdev(struct zram *zram) {};
-static int read_from_bdev(struct zram *zram, struct bio_vec *bvec,
+static int read_from_bdev(struct zram *zram, struct page *page,
 			unsigned long entry, struct bio *parent, bool sync)
 {
 	return -EIO;
@@ -1329,20 +1329,6 @@ out:
 }
 
 /*
- * Reads a page from the writeback devices. Corresponding ZRAM slot
- * should be unlocked.
- */
-static int zram_bvec_read_from_bdev(struct zram *zram, struct page *page,
-				    u32 index, struct bio *bio, bool partial_io)
-{
-	struct bio_vec bvec;
-
-	bvec_set_page(&bvec, page, PAGE_SIZE, 0);
-	return read_from_bdev(zram, &bvec, zram_get_element(zram, index), bio,
-			      partial_io);
-}
-
-/*
  * Reads (decompresses if needed) a page from zspool (zsmalloc).
  * Corresponding ZRAM slot should be locked.
  */
@@ -1402,11 +1388,14 @@ static int zram_read_page(struct zram *z
 		ret = zram_read_from_zspool(zram, page, index);
 		zram_slot_unlock(zram, index);
 	} else {
-		/* Slot should be unlocked before the function call */
+		/*
+		 * The slot should be unlocked before reading from the backing
+		 * device.
+		 */
 		zram_slot_unlock(zram, index);
 
-		ret = zram_bvec_read_from_bdev(zram, page, index, bio,
-					       partial_io);
+		ret = read_from_bdev(zram, page, zram_get_element(zram, index),
+				     bio, partial_io);
 	}
 
 	/* Should NEVER happen. Return bio error if it does. */
_

Patches currently in -mm which might be from hch@lst.de are

zram-dont-return-errors-from-read_from_bdev_async.patch
zram-fix-synchronous-reads.patch
zram-return-errors-from-read_from_bdev_sync.patch

