Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF97C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjDRXg1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjDRXfK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E143B75A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 604F963A03
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1DEC433D2;
        Tue, 18 Apr 2023 23:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860883;
        bh=Dv8luZBEGdv77FnXz8VDiwlpK1RISqip4vJesdrE/IA=;
        h=Date:To:From:Subject:From;
        b=aHvmt6qh0mNGaS7aFEHSENZz10INSc8K79sbl2Wn/sU9g3Nsg7KSF5wGIfPs1qB1z
         WAnn8oA0u0S9EoNRma+wPbLLpQVbRwxb3onTxTDjBu54WC4vVjtx1dVLCEbY5Hfp8A
         Cu9vzjfuWykCxiqZQKSvAVKTeb2nXyRb7dzJM+Ks=
Date:   Tue, 18 Apr 2023 16:34:43 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-move-discard-handling-to-zram_submit_bio.patch removed from -mm tree
Message-Id: <20230418233443.BA1DEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: move discard handling to zram_submit_bio
has been removed from the -mm tree.  Its filename was
     zram-move-discard-handling-to-zram_submit_bio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: zram: move discard handling to zram_submit_bio
Date: Tue, 11 Apr 2023 19:14:47 +0200

Switch on the bio operation in zram_submit_bio and only call into
__zram_make_request for read and write operations.

Link: https://lkml.kernel.org/r/20230411171459.567614-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-move-discard-handling-to-zram_submit_bio
+++ a/drivers/block/zram/zram_drv.c
@@ -1958,15 +1958,6 @@ static void __zram_make_request(struct z
 	struct bio_vec bv;
 	unsigned long start_time;
 
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_WRITE_ZEROES:
-		zram_bio_discard(zram, bio);
-		return;
-	default:
-		break;
-	}
-
 	start_time = bio_start_io_acct(bio);
 	bio_for_each_segment(bv, bio, iter) {
 		u32 index = iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
@@ -1990,7 +1981,19 @@ static void zram_submit_bio(struct bio *
 {
 	struct zram *zram = bio->bi_bdev->bd_disk->private_data;
 
-	__zram_make_request(zram, bio);
+	switch (bio_op(bio)) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+		__zram_make_request(zram, bio);
+		break;
+	case REQ_OP_DISCARD:
+	case REQ_OP_WRITE_ZEROES:
+		zram_bio_discard(zram, bio);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		bio_endio(bio);
+	}
 }
 
 static void zram_slot_free_notify(struct block_device *bdev,
_

Patches currently in -mm which might be from hch@lst.de are

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

