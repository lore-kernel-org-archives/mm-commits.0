Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8685AC77B6E
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjDFWTW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDFWTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:19:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DE8B456
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A39C364234
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06888C433D2;
        Thu,  6 Apr 2023 22:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819532;
        bh=64r1UWZGVoE5O49N/iWAR8F4X7o1aJDwdYfyXKqzIIA=;
        h=Date:To:From:Subject:From;
        b=rAbjCNGA9B1OhMHAo5bPmXweFmTT840flx/zVXQA7q1pFTwkOCuDpJDgYmsk2wbNU
         426fickT+0VexDTs82tPCrzx2OVgyiikqekGVW62FGHjAU2aH7l7MimE4UXSn263T2
         OPbUrDoMc3IFGkZXFxg6iY+o9kRIG98IsrEN4+Q0=
Date:   Thu, 06 Apr 2023 15:18:51 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-dont-return-errors-from-read_from_bdev_async.patch added to mm-unstable branch
Message-Id: <20230406221852.06888C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: don't return errors from read_from_bdev_async
has been added to the -mm mm-unstable branch.  Its filename is
     zram-dont-return-errors-from-read_from_bdev_async.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-dont-return-errors-from-read_from_bdev_async.patch

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
Subject: zram: don't return errors from read_from_bdev_async
Date: Thu, 6 Apr 2023 16:41:00 +0200

bio_alloc will never return a NULL bio when it is allowed to sleep, and
adding a single page to bio with a single vector also can't fail, so
switch to the asserting __bio_add_page variant and drop the error returns.

Link: https://lkml.kernel.org/r/20230406144102.149231-15-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-dont-return-errors-from-read_from_bdev_async
+++ a/drivers/block/zram/zram_drv.c
@@ -584,24 +584,16 @@ static void zram_page_end_io(struct bio
 	bio_put(bio);
 }
 
-/*
- * Returns 1 if the submission is successful.
- */
-static int read_from_bdev_async(struct zram *zram, struct page *page,
+static void read_from_bdev_async(struct zram *zram, struct page *page,
 			unsigned long entry, struct bio *parent)
 {
 	struct bio *bio;
 
 	bio = bio_alloc(zram->bdev, 1, parent ? parent->bi_opf : REQ_OP_READ,
 			GFP_NOIO);
-	if (!bio)
-		return -ENOMEM;
 
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
-	if (!bio_add_page(bio, page, PAGE_SIZE, 0)) {
-		bio_put(bio);
-		return -EIO;
-	}
+	__bio_add_page(bio, page, PAGE_SIZE, 0);
 
 	if (!parent)
 		bio->bi_end_io = zram_page_end_io;
@@ -609,7 +601,6 @@ static int read_from_bdev_async(struct z
 		bio_chain(bio, parent);
 
 	submit_bio(bio);
-	return 1;
 }
 
 #define PAGE_WB_SIG "page_index="
@@ -845,7 +836,8 @@ static int read_from_bdev(struct zram *z
 	atomic64_inc(&zram->stats.bd_reads);
 	if (sync)
 		return read_from_bdev_sync(zram, page, entry, parent);
-	return read_from_bdev_async(zram, page, entry, parent);
+	read_from_bdev_async(zram, page, entry, parent);
+	return 1;
 }
 #else
 static inline void reset_bdev(struct zram *zram) {};
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

