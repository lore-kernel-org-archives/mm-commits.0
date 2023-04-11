Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28BEC77B6F
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 20:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjDKU6D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 16:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjDKU5t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 16:57:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887B744A9
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 13:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CE21626D4
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 20:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7371BC433D2;
        Tue, 11 Apr 2023 20:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681246666;
        bh=oj5O9WwaLUswO8bw0V5RG15ZtztoOPB/WRjw5FY8iaY=;
        h=Date:To:From:Subject:From;
        b=k/r2iOCIWpVLcnUvOKHWCITTo2sjEz6fun8UXloaVL5ZwaWmZi61sXh+10nNPKtzf
         DqihrAzEHJ5n26FAPNSMxh79kN9WtcmmGYclAcVoBohjzzbQd/d8ts1hHTIaRx/exz
         y+G9/FG5EYv9AkhQCSNauUglpD/nnk9iSi0N8xys=
Date:   Tue, 11 Apr 2023 13:57:45 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-pass-a-page-to-read_from_bdev.patch added to mm-unstable branch
Message-Id: <20230411205746.7371BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: pass a page to read_from_bdev
has been added to the -mm mm-unstable branch.  Its filename is
     zram-pass-a-page-to-read_from_bdev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-pass-a-page-to-read_from_bdev.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

zram-always-compile-read_from_bdev_sync.patch
zram-remove-valid_io_request.patch
zram-make-zram_bio_discard-more-self-contained.patch
zram-simplify-bvec-iteration-in-__zram_make_request.patch
zram-move-discard-handling-to-zram_submit_bio.patch
zram-return-early-on-error-in-zram_bvec_rw.patch
zram-refactor-highlevel-read-and-write-handling.patch
zram-dont-use-highmem-for-the-bounce-buffer-in-zram_bvec_readwrite.patch
zram-rename-__zram_bvec_read-to-zram_read_page.patch
zram-directly-call-zram_read_page-in-writeback_store.patch
zram-refactor-zram_bdev_read.patch
zram-dont-pass-a-bvec-to-__zram_bvec_write.patch
zram-refactor-zram_bdev_write.patch
zram-pass-a-page-to-read_from_bdev.patch
zram-dont-return-errors-from-read_from_bdev_async.patch
zram-fix-synchronous-reads.patch
zram-return-errors-from-read_from_bdev_sync.patch

