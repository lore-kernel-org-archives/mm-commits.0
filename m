Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6CAC76196
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 20:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjDKU5u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 16:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjDKU5q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 16:57:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425382683
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 13:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23B77625A8
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 20:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A553C433EF;
        Tue, 11 Apr 2023 20:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681246659;
        bh=0jOmcOz9BjZljUh3Fcz2cGQ+arCFlDRSPq9R0uaGNlo=;
        h=Date:To:From:Subject:From;
        b=krvxmQinE+QEpdrEN28lGErQee4lCUgAd86bd+SvaA3FMGDGqat1pZyo3wlbJqwvk
         TVWn2bAyFjquWwH9IS5FEw34pCFaKMiJUsl7i7IIu2155xF3ojfDUAU9cOZ75j471N
         pLb3e1xYVlFd5sX+G1FjyghPLj0vBfJVZe3g8s2A=
Date:   Tue, 11 Apr 2023 13:57:38 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-directly-call-zram_read_page-in-writeback_store.patch added to mm-unstable branch
Message-Id: <20230411205739.7A553C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: directly call zram_read_page in writeback_store
has been added to the -mm mm-unstable branch.  Its filename is
     zram-directly-call-zram_read_page-in-writeback_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-directly-call-zram_read_page-in-writeback_store.patch

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
Subject: zram: directly call zram_read_page in writeback_store
Date: Tue, 11 Apr 2023 19:14:52 +0200

writeback_store always reads a full page, so just call zram_read_page
directly and bypass the boune buffer handling.

Link: https://lkml.kernel.org/r/20230411171459.567614-11-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-directly-call-zram_read_page-in-writeback_store
+++ a/drivers/block/zram/zram_drv.c
@@ -54,9 +54,8 @@ static size_t huge_class_size;
 static const struct block_device_operations zram_devops;
 
 static void zram_free_page(struct zram *zram, size_t index);
-static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-				u32 index, int offset, struct bio *bio);
-
+static int zram_read_page(struct zram *zram, struct page *page, u32 index,
+			  struct bio *bio, bool partial_io);
 
 static int zram_slot_trylock(struct zram *zram, u32 index)
 {
@@ -672,10 +671,6 @@ static ssize_t writeback_store(struct de
 	}
 
 	for (; nr_pages != 0; index++, nr_pages--) {
-		struct bio_vec bvec;
-
-		bvec_set_page(&bvec, page, PAGE_SIZE, 0);
-
 		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
 			spin_unlock(&zram->wb_limit_lock);
@@ -719,7 +714,7 @@ static ssize_t writeback_store(struct de
 		/* Need for hugepage writeback racing */
 		zram_set_flag(zram, index, ZRAM_IDLE);
 		zram_slot_unlock(zram, index);
-		if (zram_bvec_read(zram, &bvec, index, 0, NULL)) {
+		if (zram_read_page(zram, page, index, NULL, false)) {
 			zram_slot_lock(zram, index);
 			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 			zram_clear_flag(zram, index, ZRAM_IDLE);
@@ -730,9 +725,8 @@ static ssize_t writeback_store(struct de
 		bio_init(&bio, zram->bdev, &bio_vec, 1,
 			 REQ_OP_WRITE | REQ_SYNC);
 		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
+		bio_add_page(&bio, page, PAGE_SIZE, 0);
 
-		bio_add_page(&bio, bvec.bv_page, bvec.bv_len,
-				bvec.bv_offset);
 		/*
 		 * XXX: A single page IO would be inefficient for write
 		 * but it would be not bad as starter.
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

