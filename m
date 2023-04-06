Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F59C77B6E
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbjDFWSj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbjDFWSg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:18:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033D27EFE
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61D6060FB9
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD545C433D2;
        Thu,  6 Apr 2023 22:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819513;
        bh=A0dD+WI6dQjsgpms3HgPOtbd+ITIMf9UJyuEeNoAonI=;
        h=Date:To:From:Subject:From;
        b=zgYjU9Zi80THgHUDpRuE9fiq150ooxQ9TUPFlOeaE2t2M6/hfOoM+Un2W6ZUHzBNC
         D5xBAUDFAbAuDbNg+sz+p0eB+qj5Nz7xLEA5eJm0Ti5nkr3ZxLI6dTmxULr2v1rdGv
         Ly6QPcDT+4SakahLsyZkTaDSiM5ZLiH11KZJ4ZDc=
Date:   Thu, 06 Apr 2023 15:18:33 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-move-discard-handling-to-zram_submit_bio.patch added to mm-unstable branch
Message-Id: <20230406221833.BD545C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: move discard handling to zram_submit_bio
has been added to the -mm mm-unstable branch.  Its filename is
     zram-move-discard-handling-to-zram_submit_bio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-discard-handling-to-zram_submit_bio.patch

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
Subject: zram: move discard handling to zram_submit_bio
Date: Thu, 6 Apr 2023 16:40:50 +0200

Switch on the bio operation in zram_submit_bio and only call into
__zram_make_request for read and write operations.

Link: https://lkml.kernel.org/r/20230406144102.149231-5-hch@lst.de
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
@@ -1964,15 +1964,6 @@ static void __zram_make_request(struct z
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
@@ -1996,7 +1987,19 @@ static void zram_submit_bio(struct bio *
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

