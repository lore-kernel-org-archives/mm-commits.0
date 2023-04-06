Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0913C77B6C
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjDFWSj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238290AbjDFWSe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDB2B7
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8762C64005
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B3BC433EF;
        Thu,  6 Apr 2023 22:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819512;
        bh=52s/X30njbfC0akgb1cPbjfps4HJviZ7UTu4WTpRQWA=;
        h=Date:To:From:Subject:From;
        b=sgf9p0mwISG0J55jFBImcBwWajPQ8JT4ZCnh8Cx1D7ZT5qtcR5ujAC3urwJgumozP
         EDjPSGQ5g7uphgZD6cISUi3KmVYR+z3bap1y0XzeYw+WnEj3MlC5AuZb6a/uuzOp16
         9xvGA7CAmm8LHMVIPP3C+8QfUZg639KIcs+SKt+0=
Date:   Thu, 06 Apr 2023 15:18:31 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-simplify-bvec-iteration-in-__zram_make_request.patch added to mm-unstable branch
Message-Id: <20230406221831.E3B3BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: simplify bvec iteration in __zram_make_request
has been added to the -mm mm-unstable branch.  Its filename is
     zram-simplify-bvec-iteration-in-__zram_make_request.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-simplify-bvec-iteration-in-__zram_make_request.patch

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
Subject: zram: simplify bvec iteration in __zram_make_request
Date: Thu, 6 Apr 2023 16:40:49 +0200

bio_for_each_segment synthetize bvecs that never cross page boundaries, so
don't duplicate that work in an inner loop.

Link: https://lkml.kernel.org/r/20230406144102.149231-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   42 ++++++++------------------------
 1 file changed, 11 insertions(+), 31 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-simplify-bvec-iteration-in-__zram_make_request
+++ a/drivers/block/zram/zram_drv.c
@@ -174,12 +174,6 @@ static inline u32 zram_get_priority(stru
 	return prio & ZRAM_COMP_PRIORITY_MASK;
 }
 
-static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
-{
-	*index  += (*offset + bvec->bv_len) / PAGE_SIZE;
-	*offset = (*offset + bvec->bv_len) % PAGE_SIZE;
-}
-
 static inline void update_used_max(struct zram *zram,
 					const unsigned long pages)
 {
@@ -1966,16 +1960,10 @@ static int zram_bvec_rw(struct zram *zra
 
 static void __zram_make_request(struct zram *zram, struct bio *bio)
 {
-	int offset;
-	u32 index;
-	struct bio_vec bvec;
 	struct bvec_iter iter;
+	struct bio_vec bv;
 	unsigned long start_time;
 
-	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
-	offset = (bio->bi_iter.bi_sector &
-		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
-
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
@@ -1986,24 +1974,16 @@ static void __zram_make_request(struct z
 	}
 
 	start_time = bio_start_io_acct(bio);
-	bio_for_each_segment(bvec, bio, iter) {
-		struct bio_vec bv = bvec;
-		unsigned int unwritten = bvec.bv_len;
-
-		do {
-			bv.bv_len = min_t(unsigned int, PAGE_SIZE - offset,
-							unwritten);
-			if (zram_bvec_rw(zram, &bv, index, offset,
-					 bio_op(bio), bio) < 0) {
-				bio->bi_status = BLK_STS_IOERR;
-				break;
-			}
-
-			bv.bv_offset += bv.bv_len;
-			unwritten -= bv.bv_len;
-
-			update_position(&index, &offset, &bv);
-		} while (unwritten);
+	bio_for_each_segment(bv, bio, iter) {
+		u32 index = iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
+		u32 offset = (iter.bi_sector & (SECTORS_PER_PAGE - 1)) <<
+				SECTOR_SHIFT;
+
+		if (zram_bvec_rw(zram, &bv, index, offset, bio_op(bio),
+				bio) < 0) {
+			bio->bi_status = BLK_STS_IOERR;
+			break;
+		}
 	}
 	bio_end_io_acct(bio, start_time);
 	bio_endio(bio);
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

