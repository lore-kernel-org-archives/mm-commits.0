Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1771EC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjDRXgo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjDRXfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE9B93CD
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D3D462F29
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F59C433D2;
        Tue, 18 Apr 2023 23:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860891;
        bh=JzvuYtaTWHpwn9KFzgFH+F5S7xRZWwKxcWnsqjaQLAo=;
        h=Date:To:From:Subject:From;
        b=lKSAKYlGfmtJZ7YN1CyTdjIWcJmVfR89Lv1iGJgO8FAQQZAjr7I3MDHbZBfxdJif3
         tsnfYU6Cd+bYdBSdl3ZhqOcG5fmPEKZdZ/i/MbvNRhS2KzMFDQnFC9dNab6rdKPZiJ
         J8kGUJ43BtSmOqfsMMwjaXMHPjFv1vbccykPGmEg=
Date:   Tue, 18 Apr 2023 16:34:50 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-dont-pass-a-bvec-to-__zram_bvec_write.patch removed from -mm tree
Message-Id: <20230418233451.77F59C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: don't pass a bvec to __zram_bvec_write
has been removed from the -mm tree.  Its filename was
     zram-dont-pass-a-bvec-to-__zram_bvec_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: zram: don't pass a bvec to __zram_bvec_write
Date: Tue, 11 Apr 2023 19:14:54 +0200

__zram_bvec_write only extracts the page from __zram_bvec_write and always
expects a full page of input.  Pass the page directly instead of the bvec
and rename the function to zram_write_page.

Link: https://lkml.kernel.org/r/20230411171459.567614-13-hch@lst.de
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
@@ -1443,8 +1443,7 @@ static int zram_bvec_read(struct zram *z
 	return zram_read_page(zram, bvec->bv_page, index, bio, false);
 }
 
-static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
-				u32 index, struct bio *bio)
+static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 {
 	int ret = 0;
 	unsigned long alloced_pages;
@@ -1452,7 +1451,6 @@ static int __zram_bvec_write(struct zram
 	unsigned int comp_len = 0;
 	void *src, *dst, *mem;
 	struct zcomp_strm *zstrm;
-	struct page *page = bvec->bv_page;
 	unsigned long element = 0;
 	enum zram_pageflags flags = 0;
 
@@ -1573,11 +1571,9 @@ out:
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
@@ -1592,11 +1588,9 @@ static int zram_bvec_write(struct zram *
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
@@ -1711,7 +1705,7 @@ static int zram_recompress(struct zram *
 
 	/*
 	 * No direct reclaim (slow path) for handle allocation and no
-	 * re-compression attempt (unlike in __zram_bvec_write()) since
+	 * re-compression attempt (unlike in zram_write_bvec()) since
 	 * we already have stored that object in zsmalloc. If we cannot
 	 * alloc memory for recompressed object then we bail out and
 	 * simply keep the old (existing) object in zsmalloc.
_

Patches currently in -mm which might be from hch@lst.de are

zram-refactor-zram_bdev_write.patch
zram-pass-a-page-to-read_from_bdev.patch
zram-dont-return-errors-from-read_from_bdev_async.patch
zram-fix-synchronous-reads.patch
zram-return-errors-from-read_from_bdev_sync.patch

