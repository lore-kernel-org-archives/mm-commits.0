Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03787C77B6F
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 20:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjDKU5j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 16:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjDKU5g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 16:57:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67514198A
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 13:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03D7162C0A
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 20:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A87C433EF;
        Tue, 11 Apr 2023 20:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681246654;
        bh=oVp0Wev8fZeTy98Y7KAg4uqkGcQYwmIxKo2BS0HnV0E=;
        h=Date:To:From:Subject:From;
        b=cKKLSU997QdhmheGn1COnwSE8/J1XYXJrK7/vTkgdgHH/h0Pou0Mux2TUNE0amVyR
         YwUQrhY6wmJdjiVXFQg+WdIjGC3GtIPggorSA4IHHZk5q7eLmkVPJ/PC3TRlo8Uw9V
         7zuG3/2Znow5LrocB4dgiKHh/vc0xlPIXlN1xdkA=
Date:   Tue, 11 Apr 2023 13:57:33 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-refactor-highlevel-read-and-write-handling.patch added to mm-unstable branch
Message-Id: <20230411205734.59A87C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: refactor highlevel read and write handling
has been added to the -mm mm-unstable branch.  Its filename is
     zram-refactor-highlevel-read-and-write-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-refactor-highlevel-read-and-write-handling.patch

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
Subject: zram: refactor highlevel read and write handling
Date: Tue, 11 Apr 2023 19:14:49 +0200

Instead of having an outer loop in __zram_make_request and then branch out
for reads vs writes for each loop iteration in zram_bvec_rw, split the
main handler into separat zram_bio_read and zram_bio_write handlers that
also include the functionality formerly in zram_bvec_rw.

Link: https://lkml.kernel.org/r/20230411171459.567614-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   58 ++++++++++++++++----------------
 1 file changed, 30 insertions(+), 28 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-refactor-highlevel-read-and-write-handling
+++ a/drivers/block/zram/zram_drv.c
@@ -1921,38 +1921,34 @@ static void zram_bio_discard(struct zram
 	bio_endio(bio);
 }
 
-/*
- * Returns errno if it has some problem. Otherwise return 0 or 1.
- * Returns 0 if IO request was done synchronously
- * Returns 1 if IO request was successfully submitted.
- */
-static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, enum req_op op, struct bio *bio)
+static void zram_bio_read(struct zram *zram, struct bio *bio)
 {
-	int ret;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	unsigned long start_time;
+
+	start_time = bio_start_io_acct(bio);
+	bio_for_each_segment(bv, bio, iter) {
+		u32 index = iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
+		u32 offset = (iter.bi_sector & (SECTORS_PER_PAGE - 1)) <<
+				SECTOR_SHIFT;
 
-	if (!op_is_write(op)) {
-		ret = zram_bvec_read(zram, bvec, index, offset, bio);
-		if (unlikely(ret < 0)) {
+		if (zram_bvec_read(zram, &bv, index, offset, bio) < 0) {
 			atomic64_inc(&zram->stats.failed_reads);
-			return ret;
-		}
-		flush_dcache_page(bvec->bv_page);
-	} else {
-		ret = zram_bvec_write(zram, bvec, index, offset, bio);
-		if (unlikely(ret < 0)) {
-			atomic64_inc(&zram->stats.failed_writes);
-			return ret;
+			bio->bi_status = BLK_STS_IOERR;
+			break;
 		}
-	}
+		flush_dcache_page(bv.bv_page);
 
-	zram_slot_lock(zram, index);
-	zram_accessed(zram, index);
-	zram_slot_unlock(zram, index);
-	return 0;
+		zram_slot_lock(zram, index);
+		zram_accessed(zram, index);
+		zram_slot_unlock(zram, index);
+	}
+	bio_end_io_acct(bio, start_time);
+	bio_endio(bio);
 }
 
-static void __zram_make_request(struct zram *zram, struct bio *bio)
+static void zram_bio_write(struct zram *zram, struct bio *bio)
 {
 	struct bvec_iter iter;
 	struct bio_vec bv;
@@ -1964,11 +1960,15 @@ static void __zram_make_request(struct z
 		u32 offset = (iter.bi_sector & (SECTORS_PER_PAGE - 1)) <<
 				SECTOR_SHIFT;
 
-		if (zram_bvec_rw(zram, &bv, index, offset, bio_op(bio),
-				bio) < 0) {
+		if (zram_bvec_write(zram, &bv, index, offset, bio) < 0) {
+			atomic64_inc(&zram->stats.failed_writes);
 			bio->bi_status = BLK_STS_IOERR;
 			break;
 		}
+
+		zram_slot_lock(zram, index);
+		zram_accessed(zram, index);
+		zram_slot_unlock(zram, index);
 	}
 	bio_end_io_acct(bio, start_time);
 	bio_endio(bio);
@@ -1983,8 +1983,10 @@ static void zram_submit_bio(struct bio *
 
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
+		zram_bio_read(zram, bio);
+		break;
 	case REQ_OP_WRITE:
-		__zram_make_request(zram, bio);
+		zram_bio_write(zram, bio);
 		break;
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
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

