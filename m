Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A492C77B6C
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjDFWTQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238970AbjDFWS7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:18:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A4AAF2B
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:18:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F30F5642D2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0DFC433EF;
        Thu,  6 Apr 2023 22:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819528;
        bh=J4KLpi+dXgM+xSGf5RWkivgCA1RKbnk7icl5lPnQVzk=;
        h=Date:To:From:Subject:From;
        b=aGZO9+RFxFc6iDWPkIN9UO8zBHhj3mt6Q+hpWnGy0oWMQFCsWbJvku/ltyeaIR9N1
         EzrzZQODnQSRRBhDm/7Gpxa2eCUgzwiowg0WcoEmfkb/aMD2PHgZ4DPXbpLBegnlRK
         SnoZzWWnAzuDzzEaNv3iIMs59KglhDHv8RFHaKRY=
Date:   Thu, 06 Apr 2023 15:18:47 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-refactor-zram_bdev_write.patch added to mm-unstable branch
Message-Id: <20230406221848.5B0DFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: refactor zram_bdev_write
has been added to the -mm mm-unstable branch.  Its filename is
     zram-refactor-zram_bdev_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-refactor-zram_bdev_write.patch

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
Subject: zram: refactor zram_bdev_write
Date: Thu, 6 Apr 2023 16:40:58 +0200

Split the read/modify/write case into a separate helper.

Link: https://lkml.kernel.org/r/20230406144102.149231-13-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   38 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-refactor-zram_bdev_write
+++ a/drivers/block/zram/zram_drv.c
@@ -1574,33 +1574,33 @@ out:
 	return ret;
 }
 
-static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
-				u32 index, int offset, struct bio *bio)
+/*
+ * This is a partial IO. Read the full page before writing the changes.
+ */
+static int zram_bvec_write_partial(struct zram *zram, struct bio_vec *bvec,
+				   u32 index, int offset, struct bio *bio)
 {
-	struct page *page = bvec->bv_page;
+	struct page *page = alloc_page(GFP_NOIO);
 	int ret;
 
-	if (is_partial_io(bvec)) {
-		/*
-		 * This is a partial IO. We need to read the full page
-		 * before to write the changes.
-		 */
-		page = alloc_page(GFP_NOIO);
-		if (!page)
-			return -ENOMEM;
-
-		ret = zram_read_page(zram, page, index, bio, true);
-		if (ret)
-			goto out;
+	if (!page)
+		return -ENOMEM;
 
+	ret = zram_read_page(zram, page, index, bio, true);
+	if (!ret) {
 		memcpy_from_bvec(page_address(page) + offset, bvec);
+		ret = zram_write_page(zram, page, index);
 	}
+	__free_page(page);
+	return ret;
+}
 
-	ret = zram_write_page(zram, page, index);
-out:
+static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
+			   u32 index, int offset, struct bio *bio)
+{
 	if (is_partial_io(bvec))
-		__free_page(page);
-	return ret;
+		return zram_bvec_write_partial(zram, bvec, index, offset, bio);
+	return zram_write_page(zram, bvec->bv_page, index);
 }
 
 #ifdef CONFIG_ZRAM_MULTI_COMP
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

