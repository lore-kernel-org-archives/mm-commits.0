Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DAAC7619A
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 20:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjDKU5w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 16:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjDKU5r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 16:57:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E544C31
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 13:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B51A2625C3
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 20:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1932CC433EF;
        Tue, 11 Apr 2023 20:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681246661;
        bh=XRtTxN+f2XKROpAvUJolcJbe+t46egD8hjldXjVG2P4=;
        h=Date:To:From:Subject:From;
        b=k6HN5cvyLzorr9367pjbhHSC13nwOYczKlvMS7Uumij5Ovc0VgJ4CYfgF1mk40Lqv
         JfKbiw6JWT8ZmNJFH9XWlCDZaSCPD1i/E+TyN4k9YXxLhkIE7soyI1b7Z8wFk5SyYU
         1zgi5X2XPlFhMQ0sBt+PF1TjIB6y0MQTgYZ/rlu8=
Date:   Tue, 11 Apr 2023 13:57:40 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-refactor-zram_bdev_read.patch added to mm-unstable branch
Message-Id: <20230411205741.1932CC433EF@smtp.kernel.org>
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
Date: Tue, 11 Apr 2023 19:14:53 +0200

Split the partial read into a separate helper.

Link: https://lkml.kernel.org/r/20230411171459.567614-12-hch@lst.de
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
@@ -1416,33 +1416,33 @@ static int zram_read_page(struct zram *z
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

