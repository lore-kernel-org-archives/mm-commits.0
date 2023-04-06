Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F27C76196
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjDFWTQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238972AbjDFWS7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:18:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9701CAF08
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:18:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31E7464234
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DBAC433EF;
        Thu,  6 Apr 2023 22:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680819526;
        bh=Ry4CrspxtMqQkdINZ8/dBJrAmkoNlUchxrtYJhvzwnk=;
        h=Date:To:From:Subject:From;
        b=C5hYMpSGk1LRtVSd3RtJKs+O3eA9BvpbCvQNe5NEleEZmKaXbKesLYFQODRhEMBpV
         nwMc1M2xdBuZtF7iazFC4PEXoRjPXwl4HuhKpvPp5Rp/afIVoAT3qecKXVgS7RC02z
         2WWS+jFxBD/IG91hVwwpfYSN0B/syTaQ37pbp+hw=
Date:   Thu, 06 Apr 2023 15:18:46 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-dont-pass-a-bvec-to-__zram_bvec_write.patch added to mm-unstable branch
Message-Id: <20230406221846.89DBAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: don't pass a bvec to __zram_bvec_write
has been added to the -mm mm-unstable branch.  Its filename is
     zram-dont-pass-a-bvec-to-__zram_bvec_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-dont-pass-a-bvec-to-__zram_bvec_write.patch

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
Subject: zram: don't pass a bvec to __zram_bvec_write
Date: Thu, 6 Apr 2023 16:40:57 +0200

__zram_bvec_write only extracts the page from __zram_bvec_write and always
expects a full page of input.  Pass the page directly instead of the bvec
and rename the function to zram_write_page.

Link: https://lkml.kernel.org/r/20230406144102.149231-12-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-dont-pass-a-bvec-to-__zram_bvec_write
+++ a/drivers/block/zram/zram_drv.c
@@ -1449,8 +1449,7 @@ static int zram_bvec_read(struct zram *z
 	return zram_read_page(zram, bvec->bv_page, index, bio, false);
 }
 
-static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
-				u32 index, struct bio *bio)
+static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 {
 	int ret = 0;
 	unsigned long alloced_pages;
@@ -1458,7 +1457,6 @@ static int __zram_bvec_write(struct zram
 	unsigned int comp_len = 0;
 	void *src, *dst, *mem;
 	struct zcomp_strm *zstrm;
-	struct page *page = bvec->bv_page;
 	unsigned long element = 0;
 	enum zram_pageflags flags = 0;
 
@@ -1579,11 +1577,9 @@ out:
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 				u32 index, int offset, struct bio *bio)
 {
+	struct page *page = bvec->bv_page;
 	int ret;
-	struct page *page = NULL;
-	struct bio_vec vec;
 
-	vec = *bvec;
 	if (is_partial_io(bvec)) {
 		/*
 		 * This is a partial IO. We need to read the full page
@@ -1598,11 +1594,9 @@ static int zram_bvec_write(struct zram *
 			goto out;
 
 		memcpy_from_bvec(page_address(page) + offset, bvec);
-
-		bvec_set_page(&vec, page, PAGE_SIZE, 0);
 	}
 
-	ret = __zram_bvec_write(zram, &vec, index, bio);
+	ret = zram_write_page(zram, page, index);
 out:
 	if (is_partial_io(bvec))
 		__free_page(page);
@@ -1717,7 +1711,7 @@ static int zram_recompress(struct zram *
 
 	/*
 	 * No direct reclaim (slow path) for handle allocation and no
-	 * re-compression attempt (unlike in __zram_bvec_write()) since
+	 * re-compression attempt (unlike in zram_write_bvec()) since
 	 * we already have stored that object in zsmalloc. If we cannot
 	 * alloc memory for recompressed object then we bail out and
 	 * simply keep the old (existing) object in zsmalloc.
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

