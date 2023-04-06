Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 090E0C77B6F
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbjDFWS6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238485AbjDFWSl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:18:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BBB977B
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE15464111
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F491C433EF;
        Thu,  6 Apr 2023 22:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819519;
        bh=YY8PRfI/dJPWWUqyMBWiyt+UKCfUuM7ucetHHS3y9iQ=;
        h=Date:To:From:Subject:From;
        b=LeaucKdYc0mXII/jIqsbYh1XBXsU0OTcnOa3hrpPjM6bBQgSdXHqLcDzfm8Gw9IJa
         em4ZUTUeaTjKlIeVF/Dsbz7b1GZHW2tXRkIBKWjXbrXu2nZYaG2gfvxnRxPZEOHSEl
         VBS4TAzkHdXQYRrOCUUVJWYVV2LlyvJw8kPwhrFs=
Date:   Thu, 06 Apr 2023 15:18:38 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-dont-use-highmem-for-the-bounce-buffer-in-zram_bvec_readwrite.patch added to mm-unstable branch
Message-Id: <20230406221839.3F491C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: don't use highmem for the bounce buffer in zram_bvec_{read,write}
has been added to the -mm mm-unstable branch.  Its filename is
     zram-dont-use-highmem-for-the-bounce-buffer-in-zram_bvec_readwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-dont-use-highmem-for-the-bounce-buffer-in-zram_bvec_readwrite.patch

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
Subject: zram: don't use highmem for the bounce buffer in zram_bvec_{read,write}
Date: Thu, 6 Apr 2023 16:40:53 +0200

There is no point in allocation a highmem page when we instantly need to
copy from it.

Link: https://lkml.kernel.org/r/20230406144102.149231-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-dont-use-highmem-for-the-bounce-buffer-in-zram_bvec_readwrite
+++ a/drivers/block/zram/zram_drv.c
@@ -1437,7 +1437,7 @@ static int zram_bvec_read(struct zram *z
 	page = bvec->bv_page;
 	if (is_partial_io(bvec)) {
 		/* Use a temporary buffer to decompress the page */
-		page = alloc_page(GFP_NOIO|__GFP_HIGHMEM);
+		page = alloc_page(GFP_NOIO);
 		if (!page)
 			return -ENOMEM;
 	}
@@ -1446,12 +1446,8 @@ static int zram_bvec_read(struct zram *z
 	if (unlikely(ret))
 		goto out;
 
-	if (is_partial_io(bvec)) {
-		void *src = kmap_atomic(page);
-
-		memcpy_to_bvec(bvec, src + offset);
-		kunmap_atomic(src);
-	}
+	if (is_partial_io(bvec))
+		memcpy_to_bvec(bvec, page_address(page) + offset);
 out:
 	if (is_partial_io(bvec))
 		__free_page(page);
@@ -1595,12 +1591,11 @@ static int zram_bvec_write(struct zram *
 
 	vec = *bvec;
 	if (is_partial_io(bvec)) {
-		void *dst;
 		/*
 		 * This is a partial IO. We need to read the full page
 		 * before to write the changes.
 		 */
-		page = alloc_page(GFP_NOIO|__GFP_HIGHMEM);
+		page = alloc_page(GFP_NOIO);
 		if (!page)
 			return -ENOMEM;
 
@@ -1608,9 +1603,7 @@ static int zram_bvec_write(struct zram *
 		if (ret)
 			goto out;
 
-		dst = kmap_atomic(page);
-		memcpy_from_bvec(dst + offset, bvec);
-		kunmap_atomic(dst);
+		memcpy_from_bvec(page_address(page) + offset, bvec);
 
 		bvec_set_page(&vec, page, PAGE_SIZE, 0);
 	}
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

