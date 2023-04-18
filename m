Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E5AC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjDRXgr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjDRXfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:35:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48747BBAA
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E04862BAD
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68863C433D2;
        Tue, 18 Apr 2023 23:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860890;
        bh=hqbx2QdsmoAr1tk+004CaadE+b9/2Kzc9z4la34/ulk=;
        h=Date:To:From:Subject:From;
        b=QBIE6bblGajl0Gej9h6N3gES/GLcy3UhXdKyr3etAvPbIH5ckviJifRzh1h/bNWMR
         EtLQy7HvQ6JtmWnsSYz96/pngAaa62wMxK/gXLhS6xz08hCFzpdogWbHO9LnkxZIL+
         jYcb0Z7goig7qo3MC9q5HFz8Ga3jxHZ66yHcs5lc=
Date:   Tue, 18 Apr 2023 16:34:49 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-refactor-zram_bdev_read.patch removed from -mm tree
Message-Id: <20230418233450.68863C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: refactor zram_bdev_read
has been removed from the -mm tree.  Its filename was
     zram-refactor-zram_bdev_read.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

zram-dont-pass-a-bvec-to-__zram_bvec_write.patch
zram-refactor-zram_bdev_write.patch
zram-pass-a-page-to-read_from_bdev.patch
zram-dont-return-errors-from-read_from_bdev_async.patch
zram-fix-synchronous-reads.patch
zram-return-errors-from-read_from_bdev_sync.patch

