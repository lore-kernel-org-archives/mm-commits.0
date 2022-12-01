Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B96CC4708E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiLAAEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiLAADS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391C68D649
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B01D1B81D80
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54857C433B5;
        Thu,  1 Dec 2022 00:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852886;
        bh=/30k6g0Sp2h1ktMYdL+zFakXh7BDYV0pSEaGR0NPa4A=;
        h=Date:To:From:Subject:From;
        b=VrvM5iffWRTgabS44920fbXoSyniMY0d6E+CRJKkwphBzf7wy/krfsrwXKyvMmWBX
         hted0plY9dfD8rw3HmNhJt2KlSzvl8rymRhmeNecXDHEGbYa+duAHbUBaKDsF6NDcg
         fIYrXblg7+RvR+X7UTTOMJF/7ypPa2a4gaQg8OEM=
Date:   Wed, 30 Nov 2022 16:01:25 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-factor-out-wb-and-non-wb-zram-read-functions.patch removed from -mm tree
Message-Id: <20221201000126.54857C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: factor out WB and non-WB zram read functions
has been removed from the -mm tree.  Its filename was
     zram-factor-out-wb-and-non-wb-zram-read-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: factor out WB and non-WB zram read functions
Date: Wed, 9 Nov 2022 20:50:37 +0900

We will use non-WB variant in ZRAM page recompression path.

Link: https://lkml.kernel.org/r/20221109115047.2921851-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   72 +++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 23 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-factor-out-wb-and-non-wb-zram-read-functions
+++ a/drivers/block/zram/zram_drv.c
@@ -1336,8 +1336,29 @@ out:
 		~(1UL << ZRAM_LOCK | 1UL << ZRAM_UNDER_WB));
 }
 
-static int __zram_bvec_read(struct zram *zram, struct page *page, u32 index,
-				struct bio *bio, bool partial_io)
+/*
+ * Reads a page from the writeback devices. Corresponding ZRAM slot
+ * should be unlocked.
+ */
+static int zram_bvec_read_from_bdev(struct zram *zram, struct page *page,
+				    u32 index, struct bio *bio, bool partial_io)
+{
+	struct bio_vec bvec = {
+		.bv_page = page,
+		.bv_len = PAGE_SIZE,
+		.bv_offset = 0,
+	};
+
+	return read_from_bdev(zram, &bvec, zram_get_element(zram, index), bio,
+			      partial_io);
+}
+
+/*
+ * Reads (decompresses if needed) a page from zspool (zsmalloc).
+ * Corresponding ZRAM slot should be locked.
+ */
+static int zram_read_from_zspool(struct zram *zram, struct page *page,
+				 u32 index)
 {
 	struct zcomp_strm *zstrm;
 	unsigned long handle;
@@ -1345,23 +1366,6 @@ static int __zram_bvec_read(struct zram
 	void *src, *dst;
 	int ret;
 
-	zram_slot_lock(zram, index);
-	if (zram_test_flag(zram, index, ZRAM_WB)) {
-		struct bio_vec bvec;
-
-		zram_slot_unlock(zram, index);
-		/* A null bio means rw_page was used, we must fallback to bio */
-		if (!bio)
-			return -EOPNOTSUPP;
-
-		bvec.bv_page = page;
-		bvec.bv_len = PAGE_SIZE;
-		bvec.bv_offset = 0;
-		return read_from_bdev(zram, &bvec,
-				zram_get_element(zram, index),
-				bio, partial_io);
-	}
-
 	handle = zram_get_handle(zram, index);
 	if (!handle || zram_test_flag(zram, index, ZRAM_SAME)) {
 		unsigned long value;
@@ -1371,7 +1375,6 @@ static int __zram_bvec_read(struct zram
 		mem = kmap_atomic(page);
 		zram_fill_page(mem, PAGE_SIZE, value);
 		kunmap_atomic(mem);
-		zram_slot_unlock(zram, index);
 		return 0;
 	}
 
@@ -1393,17 +1396,40 @@ static int __zram_bvec_read(struct zram
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 	}
 	zs_unmap_object(zram->mem_pool, handle);
-	zram_slot_unlock(zram, index);
+	return ret;
+}
+
+static int __zram_bvec_read(struct zram *zram, struct page *page, u32 index,
+			    struct bio *bio, bool partial_io)
+{
+	int ret;
+
+	zram_slot_lock(zram, index);
+	if (!zram_test_flag(zram, index, ZRAM_WB)) {
+		/* Slot should be locked through out the function call */
+		ret = zram_read_from_zspool(zram, page, index);
+		zram_slot_unlock(zram, index);
+	} else {
+		/* Slot should be unlocked before the function call */
+		zram_slot_unlock(zram, index);
+
+		/* A null bio means rw_page was used, we must fallback to bio */
+		if (!bio)
+			return -EOPNOTSUPP;
+
+		ret = zram_bvec_read_from_bdev(zram, page, index, bio,
+					       partial_io);
+	}
 
 	/* Should NEVER happen. Return bio error if it does. */
-	if (WARN_ON(ret))
+	if (WARN_ON(ret < 0))
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 
 	return ret;
 }
 
 static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-				u32 index, int offset, struct bio *bio)
+			  u32 index, int offset, struct bio *bio)
 {
 	int ret;
 	struct page *page;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


