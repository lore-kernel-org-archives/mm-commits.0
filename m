Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C038C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbiKJAa5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiKJAaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:30:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDD12623
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE9FB61D2D
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF3AC433B5;
        Thu, 10 Nov 2022 00:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668040252;
        bh=cN+ht1Zqfki6S2HZhXP20KbH/yTInkBR7AWHYz0gEEo=;
        h=Date:To:From:Subject:From;
        b=pfCC1MF0K6nW9GlAY968t2qFgPekMFjqCp7hPzh5BcRDs8gI4UN21jZ6DpX5f7y2x
         eDavAdx9k8wZS45ShW450kmi2+zfrTdMqYeUgg6FqrYeTk7UTk7qUyi+FZQdjLemyg
         7N8ABWcvVbpWULXlKWVtZrEzrAEIK3Otd+3ztY4g=
Date:   Wed, 09 Nov 2022 16:30:51 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-factor-out-wb-and-non-wb-zram-read-functions.patch added to mm-unstable branch
Message-Id: <20221110003052.4BF3AC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: factor out WB and non-WB zram read functions
has been added to the -mm mm-unstable branch.  Its filename is
     zram-factor-out-wb-and-non-wb-zram-read-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-factor-out-wb-and-non-wb-zram-read-functions.patch

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

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch

