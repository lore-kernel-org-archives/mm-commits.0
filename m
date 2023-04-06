Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DD6C76196
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbjDFWTH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238890AbjDFWS5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:18:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA7FA5E7
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:18:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AAEA60FD1
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73D0C433D2;
        Thu,  6 Apr 2023 22:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819524;
        bh=Cz4YqhIK4Sr0E7n7nsYhFtLhZbe3DFw5CkV7zzrx/Qo=;
        h=Date:To:From:Subject:From;
        b=f1niTUT7/OmRwJpV0qsCqaNJNR679vBeZ8XnZJLMxTiQoGJ88agqAu38cupzPHNg6
         2+3AbtqwmF6AxAwIn627jsWcyAbwDRgKeww7jqs2Xw81CwqiqVVbW4JjCbBCMXmvpR
         qxAnTQBHbs0qSUPmYOJHcDYgyy4W/2Zbck1B/FYU=
Date:   Thu, 06 Apr 2023 15:18:44 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-refactor-zram_bdev_read.patch added to mm-unstable branch
Message-Id: <20230406221844.A73D0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: refactor zram_bdev_read
has been added to the -mm mm-unstable branch.  Its filename is
     zram-refactor-zram_bdev_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-refactor-zram_bdev_read.patch

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
Subject: zram: refactor zram_bdev_read
Date: Thu, 6 Apr 2023 16:40:56 +0200

Split the partial read into a separate helper.

Link: https://lkml.kernel.org/r/20230406144102.149231-11-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   40 ++++++++++++++++----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-refactor-zram_bdev_read
+++ a/drivers/block/zram/zram_drv.c
@@ -1422,33 +1422,33 @@ static int zram_read_page(struct zram *z
 	return ret;
 }
 
-static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-			  u32 index, int offset, struct bio *bio)
+/*
+ * Use a temporary buffer to decompress the page, as the decompressor
+ * always expects a full page for the output.
+ */
+static int zram_bvec_read_partial(struct zram *zram, struct bio_vec *bvec,
+				  u32 index, int offset, struct bio *bio)
 {
+	struct page *page = alloc_page(GFP_NOIO);
 	int ret;
-	struct page *page;
-
-	page = bvec->bv_page;
-	if (is_partial_io(bvec)) {
-		/* Use a temporary buffer to decompress the page */
-		page = alloc_page(GFP_NOIO);
-		if (!page)
-			return -ENOMEM;
-	}
-
-	ret = zram_read_page(zram, page, index, bio, is_partial_io(bvec));
-	if (unlikely(ret))
-		goto out;
 
-	if (is_partial_io(bvec))
+	if (!page)
+		return -ENOMEM;
+	ret = zram_read_page(zram, page, index, bio, true);
+	if (likely(!ret))
 		memcpy_to_bvec(bvec, page_address(page) + offset);
-out:
-	if (is_partial_io(bvec))
-		__free_page(page);
-
+	__free_page(page);
 	return ret;
 }
 
+static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
+			  u32 index, int offset, struct bio *bio)
+{
+	if (is_partial_io(bvec))
+		return zram_bvec_read_partial(zram, bvec, index, offset, bio);
+	return zram_read_page(zram, bvec->bv_page, index, bio, false);
+}
+
 static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 				u32 index, struct bio *bio)
 {
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

