Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E125BC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjDRXg1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjDRXfI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929F1B746
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D7962ED3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A802C433EF;
        Tue, 18 Apr 2023 23:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860881;
        bh=+75RQIK1cffODJ3se/Xw3eCyqiFYrpt2mNMLWWQRTpw=;
        h=Date:To:From:Subject:From;
        b=Y0u7LV//9N3Hc97x4sV42H0FRhE6OWRBLZUX6bFpRiLq75UshMYT8yS93O6P3wfJB
         Erl/Vgav9+EeBMcx/HFh+NN/4pmi3q/Yxs12OtOQ6om8a/OuOtpFBN4h2ho0jCu1fK
         NP73/nPeS8hFhfq0SXMnLyDVSHZJSDKAGHasI+1U=
Date:   Tue, 18 Apr 2023 16:34:40 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-make-zram_bio_discard-more-self-contained.patch removed from -mm tree
Message-Id: <20230418233441.7A802C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: make zram_bio_discard more self-contained
has been removed from the -mm tree.  Its filename was
     zram-make-zram_bio_discard-more-self-contained.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: zram: make zram_bio_discard more self-contained
Date: Tue, 11 Apr 2023 19:14:45 +0200

Derive the index and offset variables inside the function, and complete
the bio directly in preparation for cleaning up the I/O path.

Link: https://lkml.kernel.org/r/20230411171459.567614-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-make-zram_bio_discard-more-self-contained
+++ a/drivers/block/zram/zram_drv.c
@@ -1890,15 +1890,12 @@ release_init_lock:
 }
 #endif
 
-/*
- * zram_bio_discard - handler on discard request
- * @index: physical block index in PAGE_SIZE units
- * @offset: byte offset within physical block
- */
-static void zram_bio_discard(struct zram *zram, u32 index,
-			     int offset, struct bio *bio)
+static void zram_bio_discard(struct zram *zram, struct bio *bio)
 {
 	size_t n = bio->bi_iter.bi_size;
+	u32 index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
+	u32 offset = (bio->bi_iter.bi_sector & (SECTORS_PER_PAGE - 1)) <<
+			SECTOR_SHIFT;
 
 	/*
 	 * zram manages data in physical block size units. Because logical block
@@ -1926,6 +1923,8 @@ static void zram_bio_discard(struct zram
 		index++;
 		n -= PAGE_SIZE;
 	}
+
+	bio_endio(bio);
 }
 
 /*
@@ -1974,8 +1973,7 @@ static void __zram_make_request(struct z
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
-		zram_bio_discard(zram, index, offset, bio);
-		bio_endio(bio);
+		zram_bio_discard(zram, bio);
 		return;
 	default:
 		break;
_

Patches currently in -mm which might be from hch@lst.de are

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

