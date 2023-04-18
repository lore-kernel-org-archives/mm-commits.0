Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6660FC77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjDRXhE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjDRXfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937317ABA
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FBE5615F4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87968C433D2;
        Tue, 18 Apr 2023 23:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860892;
        bh=F8sCpNui9QIDGkcj1O2cnjLJGoFi139q4Uoff92fMNQ=;
        h=Date:To:From:Subject:From;
        b=nNae6ydw6WLxhy3bPSxFwoScdzht6NBjZ3cd5FfekBA4D46LFNzPhz4orcwQup2Ma
         lluKNtH0W4OrBvHtiJ0VckJlP8EW4d8Rxzq3vn7JsY0sJtrWM590Lp8rWcGh416OKg
         Um/LSXcxyjAEvo/jrZboD0IBVhrN4vjhmRAdBzp4=
Date:   Tue, 18 Apr 2023 16:34:52 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-refactor-zram_bdev_write.patch removed from -mm tree
Message-Id: <20230418233452.87968C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: refactor zram_bdev_write
has been removed from the -mm tree.  Its filename was
     zram-refactor-zram_bdev_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: zram: refactor zram_bdev_write
Date: Tue, 11 Apr 2023 19:14:55 +0200

Split the read/modify/write case into a separate helper.

Link: https://lkml.kernel.org/r/20230411171459.567614-14-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   38 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-refactor-zram_bdev_write
+++ a/drivers/block/zram/zram_drv.c
@@ -1568,33 +1568,33 @@ out:
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

zram-pass-a-page-to-read_from_bdev.patch
zram-dont-return-errors-from-read_from_bdev_async.patch
zram-fix-synchronous-reads.patch
zram-return-errors-from-read_from_bdev_sync.patch

