Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271A0C77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjDFWTX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjDFWTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:19:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E37B45C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:18:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DF6860FD1
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA854C433D2;
        Thu,  6 Apr 2023 22:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819533;
        bh=kNTxrO9r19LyJjWi1PgiVwuD615krf1MtngQQuPEWDI=;
        h=Date:To:From:Subject:From;
        b=sp64XjlLKIVz0GCRHrL8A9hxnHL9mCssL+aowX3uT6FnBWTZypYflDDDHsf8Ncp82
         55W0n4jJzPRvK8aaOh9CXO4qSDyu36svjeryLqtW1VQKPfoCVM7EGk2rlzXYn1xCAE
         SBgC1+wcwEhtuba53JcAHWt7L/3L++M+Ce5jF28s=
Date:   Thu, 06 Apr 2023 15:18:53 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-synchronous-reads.patch added to mm-unstable branch
Message-Id: <20230406221853.CA854C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix synchronous reads
has been added to the -mm mm-unstable branch.  Its filename is
     zram-fix-synchronous-reads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-synchronous-reads.patch

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
Subject: zram: fix synchronous reads
Date: Thu, 6 Apr 2023 16:41:01 +0200

Currently nothing waits for the synchronous reads before accessing the
data.  Switch them to an on-stack bio and submit_bio_wait to make sure the
I/O has actually completed when the work item has been flushed.  This also
removes the call to page_endio that would unlock a page that has never
been locked.

Drop the partial_io/sync flag, as chaining only makes sense for the
asynchronous reads of the entire page.

Link: https://lkml.kernel.org/r/20230406144102.149231-16-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   64 ++++++++++++--------------------
 1 file changed, 24 insertions(+), 40 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-synchronous-reads
+++ a/drivers/block/zram/zram_drv.c
@@ -55,7 +55,7 @@ static const struct block_device_operati
 
 static void zram_free_page(struct zram *zram, size_t index);
 static int zram_read_page(struct zram *zram, struct page *page, u32 index,
-			  struct bio *bio, bool partial_io);
+			  struct bio *parent);
 
 static int zram_slot_trylock(struct zram *zram, u32 index)
 {
@@ -575,31 +575,15 @@ static void free_block_bdev(struct zram
 	atomic64_dec(&zram->stats.bd_count);
 }
 
-static void zram_page_end_io(struct bio *bio)
-{
-	struct page *page = bio_first_page_all(bio);
-
-	page_endio(page, op_is_write(bio_op(bio)),
-			blk_status_to_errno(bio->bi_status));
-	bio_put(bio);
-}
-
 static void read_from_bdev_async(struct zram *zram, struct page *page,
 			unsigned long entry, struct bio *parent)
 {
 	struct bio *bio;
 
-	bio = bio_alloc(zram->bdev, 1, parent ? parent->bi_opf : REQ_OP_READ,
-			GFP_NOIO);
-
+	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
 	__bio_add_page(bio, page, PAGE_SIZE, 0);
-
-	if (!parent)
-		bio->bi_end_io = zram_page_end_io;
-	else
-		bio_chain(bio, parent);
-
+	bio_chain(bio, parent);
 	submit_bio(bio);
 }
 
@@ -704,7 +688,7 @@ static ssize_t writeback_store(struct de
 		/* Need for hugepage writeback racing */
 		zram_set_flag(zram, index, ZRAM_IDLE);
 		zram_slot_unlock(zram, index);
-		if (zram_read_page(zram, page, index, NULL, false)) {
+		if (zram_read_page(zram, page, index, NULL)) {
 			zram_slot_lock(zram, index);
 			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 			zram_clear_flag(zram, index, ZRAM_IDLE);
@@ -780,23 +764,24 @@ release_init_lock:
 	return ret;
 }
 
+#if PAGE_SIZE != 4096
 struct zram_work {
 	struct work_struct work;
 	struct zram *zram;
 	unsigned long entry;
-	struct bio *bio;
 	struct page *page;
 };
 
-#if PAGE_SIZE != 4096
 static void zram_sync_read(struct work_struct *work)
 {
 	struct zram_work *zw = container_of(work, struct zram_work, work);
-	struct zram *zram = zw->zram;
-	unsigned long entry = zw->entry;
-	struct bio *bio = zw->bio;
+	struct bio_bvec bv;
+	struct bio bio;
 
-	read_from_bdev_async(zram, zw->page, entry, bio);
+	bio_init(&bio, zw->zram->bdev, &bv, 1, REQ_OP_READ);
+	bio.bi_iter.bi_sector = zw->entry * (PAGE_SIZE >> 9);
+	__bio_add_page(&bio, zw->page, PAGE_SIZE, 0);
+	submit_bio_wait(&bio);
 }
 
 /*
@@ -805,14 +790,13 @@ static void zram_sync_read(struct work_s
  * use a worker thread context.
  */
 static int read_from_bdev_sync(struct zram *zram, struct page *page,
-				unsigned long entry, struct bio *bio)
+				unsigned long entry)
 {
 	struct zram_work work;
 
 	work.page = page;
 	work.zram = zram;
 	work.entry = entry;
-	work.bio = bio;
 
 	INIT_WORK_ONSTACK(&work.work, zram_sync_read);
 	queue_work(system_unbound_wq, &work.work);
@@ -823,7 +807,7 @@ static int read_from_bdev_sync(struct zr
 }
 #else
 static int read_from_bdev_sync(struct zram *zram, struct page *page,
-				unsigned long entry, struct bio *bio)
+				unsigned long entry)
 {
 	WARN_ON(1);
 	return -EIO;
@@ -831,18 +815,18 @@ static int read_from_bdev_sync(struct zr
 #endif
 
 static int read_from_bdev(struct zram *zram, struct page *page,
-			unsigned long entry, struct bio *parent, bool sync)
+			unsigned long entry, struct bio *parent)
 {
 	atomic64_inc(&zram->stats.bd_reads);
-	if (sync)
-		return read_from_bdev_sync(zram, page, entry, parent);
+	if (!parent)
+		return read_from_bdev_sync(zram, page, entry);
 	read_from_bdev_async(zram, page, entry, parent);
 	return 1;
 }
 #else
 static inline void reset_bdev(struct zram *zram) {};
 static int read_from_bdev(struct zram *zram, struct page *page,
-			unsigned long entry, struct bio *parent, bool sync)
+			unsigned long entry, struct bio *parent)
 {
 	return -EIO;
 }
@@ -1375,7 +1359,7 @@ static int zram_read_from_zspool(struct
 }
 
 static int zram_read_page(struct zram *zram, struct page *page, u32 index,
-			  struct bio *bio, bool partial_io)
+			  struct bio *parent)
 {
 	int ret;
 
@@ -1392,7 +1376,7 @@ static int zram_read_page(struct zram *z
 		zram_slot_unlock(zram, index);
 
 		ret = read_from_bdev(zram, page, zram_get_element(zram, index),
-				     bio, partial_io);
+				     parent);
 	}
 
 	/* Should NEVER happen. Return bio error if it does. */
@@ -1407,14 +1391,14 @@ static int zram_read_page(struct zram *z
  * always expects a full page for the output.
  */
 static int zram_bvec_read_partial(struct zram *zram, struct bio_vec *bvec,
-				  u32 index, int offset, struct bio *bio)
+				  u32 index, int offset)
 {
 	struct page *page = alloc_page(GFP_NOIO);
 	int ret;
 
 	if (!page)
 		return -ENOMEM;
-	ret = zram_read_page(zram, page, index, bio, true);
+	ret = zram_read_page(zram, page, index, NULL);
 	if (likely(!ret))
 		memcpy_to_bvec(bvec, page_address(page) + offset);
 	__free_page(page);
@@ -1425,8 +1409,8 @@ static int zram_bvec_read(struct zram *z
 			  u32 index, int offset, struct bio *bio)
 {
 	if (is_partial_io(bvec))
-		return zram_bvec_read_partial(zram, bvec, index, offset, bio);
-	return zram_read_page(zram, bvec->bv_page, index, bio, false);
+		return zram_bvec_read_partial(zram, bvec, index, offset);
+	return zram_read_page(zram, bvec->bv_page, index, bio);
 }
 
 static int zram_write_page(struct zram *zram, struct page *page, u32 index)
@@ -1566,7 +1550,7 @@ static int zram_bvec_write_partial(struc
 	if (!page)
 		return -ENOMEM;
 
-	ret = zram_read_page(zram, page, index, bio, true);
+	ret = zram_read_page(zram, page, index, bio);
 	if (!ret) {
 		memcpy_from_bvec(page_address(page) + offset, bvec);
 		ret = zram_write_page(zram, page, index);
_

Patches currently in -mm which might be from hch@lst.de are

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

