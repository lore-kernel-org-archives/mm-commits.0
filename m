Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE572C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 04:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiKIEEl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 23:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiKIEE1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 23:04:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91941E3D8
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 20:04:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A858E617D0
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 04:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B88C433B5;
        Wed,  9 Nov 2022 04:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667966665;
        bh=8GE3E4Fp3bmaoe9dBwmc+8fki48WxNuOdczgcK+eMzE=;
        h=Date:To:From:Subject:From;
        b=kZziDAurlzZfnY4pFFWhWfzhbizLZdKflzBHIo3miWd62551iUaVmsQ9zIbF0b/ex
         HnTP4VMfqCy9j9xa25TslKCZPjfVojwyowE2sTsHY6OEB3gQTHW8ApNAFKbF4shHu9
         gIa24ctewBjSmeW0nnvqZuOH1E3Ju31vjglxUDP0=
Date:   Tue, 08 Nov 2022 20:04:24 -0800
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-introduce-recompress-sysfs-knob.patch removed from -mm tree
Message-Id: <20221109040424.F1B88C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: introduce recompress sysfs knob
has been removed from the -mm tree.  Its filename was
     zram-introduce-recompress-sysfs-knob.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: introduce recompress sysfs knob
Date: Tue, 18 Oct 2022 13:55:28 +0900

Allow zram to recompress (using secondary compression streams) pages.  We
support three modes:

1) IDLE pages recompression is activated by `idle` mode

	echo idle > /sys/block/zram0/recompress

2) Since there may be many idle pages user-space may pass a size
   watermark value (in bytes) and we will recompress IDLE pages only of
   equal or greater size:

	echo 888 > /sys/block/zram0/recompress

3) HUGE pages recompression is activated by `huge` mode

	echo huge > /sys/block/zram0/recompress

4) HUGE_IDLE pages recompression is activated by `huge_idle` mode

	echo huge_idle > /sys/block/zram0/recompress

Link: https://lkml.kernel.org/r/20221018045533.2396670-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |   15 ++
 drivers/block/zram/zram_drv.c |  196 +++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h |    2 
 3 files changed, 210 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-introduce-recompress-sysfs-knob
+++ a/drivers/block/zram/Kconfig
@@ -78,3 +78,18 @@ config ZRAM_MEMORY_TRACKING
 	  /sys/kernel/debug/zram/zramX/block_state.
 
 	  See Documentation/admin-guide/blockdev/zram.rst for more information.
+
+config ZRAM_MULTI_COMP
+	bool "Enable multiple per-CPU compression streams"
+	depends on ZRAM
+	help
+	This will enable per-CPU multi-compression streams, so that ZRAM
+	can re-compress IDLE/huge pages, using a potentially slower but
+	more effective compression algorithm. Note, that IDLE page support
+	requires ZRAM_MEMORY_TRACKING.
+
+          echo TIMEOUT > /sys/block/zramX/idle
+          echo SIZE > /sys/block/zramX/recompress
+
+	SIZE (in bytes) parameter sets the object size watermark: idle
+	objects that are of a smaller size will not get recompressed.
--- a/drivers/block/zram/zram_drv.c~zram-introduce-recompress-sysfs-knob
+++ a/drivers/block/zram/zram_drv.c
@@ -1279,6 +1279,12 @@ static void zram_free_page(struct zram *
 		atomic64_dec(&zram->stats.huge_pages);
 	}
 
+	if (zram_test_flag(zram, index, ZRAM_RECOMP))
+		zram_clear_flag(zram, index, ZRAM_RECOMP);
+
+	if (zram_test_flag(zram, index, ZRAM_RECOMP_SKIP))
+		zram_clear_flag(zram, index, ZRAM_RECOMP_SKIP);
+
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
 		free_block_bdev(zram, zram_get_element(zram, index));
@@ -1340,6 +1346,7 @@ static int zram_read_from_zspool(struct
 	unsigned long handle;
 	unsigned int size;
 	void *src, *dst;
+	u32 idx;
 	int ret;
 
 	handle = zram_get_handle(zram, index);
@@ -1356,8 +1363,13 @@ static int zram_read_from_zspool(struct
 
 	size = zram_get_obj_size(zram, index);
 
-	if (size != PAGE_SIZE)
-		zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_ZCOMP]);
+	if (size != PAGE_SIZE) {
+		idx = ZRAM_PRIMARY_ZCOMP;
+		if (zram_test_flag(zram, index, ZRAM_RECOMP))
+			idx = ZRAM_SECONDARY_ZCOMP;
+
+		zstrm = zcomp_stream_get(zram->comps[idx]);
+	}
 
 	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
@@ -1369,7 +1381,7 @@ static int zram_read_from_zspool(struct
 		dst = kmap_atomic(page);
 		ret = zcomp_decompress(zstrm, src, size, dst);
 		kunmap_atomic(dst);
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_ZCOMP]);
+		zcomp_stream_put(zram->comps[idx]);
 	}
 	zs_unmap_object(zram->mem_pool, handle);
 	return ret;
@@ -1600,6 +1612,182 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_ZRAM_MULTI_COMP
+/*
+ * This function will decompress (unless it's ZRAM_HUGE) the page and then
+ * attempt to compress it using secondary compression algorithm (which is
+ * potentially more effective).
+ *
+ * Corresponding ZRAM slot should be locked.
+ */
+static int zram_recompress(struct zram *zram, u32 index, struct page *page,
+			   int size_watermark)
+{
+	unsigned long handle_prev;
+	unsigned long handle_next;
+	unsigned int comp_len_next;
+	unsigned int comp_len_prev;
+	struct zcomp_strm *zstrm;
+	void *src, *dst;
+	int ret;
+
+	handle_prev = zram_get_handle(zram, index);
+	if (!handle_prev)
+		return -EINVAL;
+
+	comp_len_prev = zram_get_obj_size(zram, index);
+	/*
+	 * Do not recompress objects that are already "small enough".
+	 */
+	if (comp_len_prev < size_watermark)
+		return 0;
+
+	ret = zram_read_from_zspool(zram, page, index);
+	if (ret)
+		return ret;
+
+	zstrm = zcomp_stream_get(zram->comps[ZRAM_SECONDARY_ZCOMP]);
+	src = kmap_atomic(page);
+	ret = zcomp_compress(zstrm, src, &comp_len_next);
+	kunmap_atomic(src);
+
+	/*
+	 * Either a compression error or we failed to compressed the object
+	 * in a way that will save us memory. Mark the object so that we
+	 * don't attempt to re-compress it again (RECOMP_SKIP).
+	 */
+	if (comp_len_next >= huge_class_size ||
+	    comp_len_next >= comp_len_prev ||
+	    ret) {
+		zram_set_flag(zram, index, ZRAM_RECOMP_SKIP);
+		zram_clear_flag(zram, index, ZRAM_IDLE);
+		zcomp_stream_put(zram->comps[ZRAM_SECONDARY_ZCOMP]);
+		return ret;
+	}
+
+	/*
+	 * No direct reclaim (slow path) for handle allocation and no
+	 * re-compression attempt (unlike in __zram_bvec_write()) since
+	 * we already have stored that object in zsmalloc. If we cannot
+	 * alloc memory for recompressed object then we bail out and
+	 * simply keep the old (existing) object in zsmalloc.
+	 */
+	handle_next = zs_malloc(zram->mem_pool, comp_len_next,
+				__GFP_KSWAPD_RECLAIM |
+				__GFP_NOWARN |
+				__GFP_HIGHMEM |
+				__GFP_MOVABLE);
+	if (IS_ERR((void *)handle_next)) {
+		zcomp_stream_put(zram->comps[ZRAM_SECONDARY_ZCOMP]);
+		return PTR_ERR((void *)handle_next);
+	}
+
+	dst = zs_map_object(zram->mem_pool, handle_next, ZS_MM_WO);
+	memcpy(dst, zstrm->buffer, comp_len_next);
+	zcomp_stream_put(zram->comps[ZRAM_SECONDARY_ZCOMP]);
+
+	zs_unmap_object(zram->mem_pool, handle_next);
+
+	zram_free_page(zram, index);
+	zram_set_handle(zram, index, handle_next);
+	zram_set_obj_size(zram, index, comp_len_next);
+
+	zram_set_flag(zram, index, ZRAM_RECOMP);
+	atomic64_add(comp_len_next, &zram->stats.compr_data_size);
+	atomic64_inc(&zram->stats.pages_stored);
+
+	return 0;
+}
+
+#define RECOMPRESS_IDLE		(1 << 0)
+#define RECOMPRESS_HUGE		(1 << 1)
+
+static ssize_t recompress_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long index;
+	struct page *page;
+	ssize_t ret;
+	int mode, size_watermark = 0;
+
+	if (sysfs_streq(buf, "idle")) {
+		mode = RECOMPRESS_IDLE;
+	} else if (sysfs_streq(buf, "huge")) {
+		mode = RECOMPRESS_HUGE;
+	} else if (sysfs_streq(buf, "huge_idle")) {
+		mode = RECOMPRESS_IDLE | RECOMPRESS_HUGE;
+	} else {
+		/*
+		 * We will re-compress only idle objects equal or greater
+		 * in size than watermark.
+		 */
+		ret = kstrtoint(buf, 10, &size_watermark);
+		if (ret)
+			return ret;
+		mode = RECOMPRESS_IDLE;
+	}
+
+	if (size_watermark > PAGE_SIZE)
+		return -EINVAL;
+
+	down_read(&zram->init_lock);
+	if (!init_done(zram)) {
+		ret = -EINVAL;
+		goto release_init_lock;
+	}
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page) {
+		ret = -ENOMEM;
+		goto release_init_lock;
+	}
+
+	ret = len;
+	for (index = 0; index < nr_pages; index++) {
+		int err = 0;
+
+		zram_slot_lock(zram, index);
+
+		if (!zram_allocated(zram, index))
+			goto next;
+
+		if (mode & RECOMPRESS_IDLE &&
+		    !zram_test_flag(zram, index, ZRAM_IDLE))
+			goto next;
+
+		if (mode & RECOMPRESS_HUGE &&
+		    !zram_test_flag(zram, index, ZRAM_HUGE))
+			goto next;
+
+		if (zram_test_flag(zram, index, ZRAM_WB) ||
+		    zram_test_flag(zram, index, ZRAM_UNDER_WB) ||
+		    zram_test_flag(zram, index, ZRAM_SAME) ||
+		    zram_test_flag(zram, index, ZRAM_RECOMP) ||
+		    zram_test_flag(zram, index, ZRAM_RECOMP_SKIP))
+			goto next;
+
+		err = zram_recompress(zram, index, page, size_watermark);
+next:
+		zram_slot_unlock(zram, index);
+		if (err) {
+			ret = err;
+			break;
+		}
+
+		cond_resched();
+	}
+
+	__free_page(page);
+
+release_init_lock:
+	up_read(&zram->init_lock);
+	return ret;
+}
+#endif
+
 /*
  * zram_bio_discard - handler on discard request
  * @index: physical block index in PAGE_SIZE units
@@ -1980,6 +2168,7 @@ static DEVICE_ATTR_RW(writeback_limit_en
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
+static DEVICE_ATTR_WO(recompress);
 #endif
 
 static struct attribute *zram_disk_attrs[] = {
@@ -2006,6 +2195,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_debug_stat.attr,
 #ifdef CONFIG_ZRAM_MULTI_COMP
 	&dev_attr_recomp_algorithm.attr,
+	&dev_attr_recompress.attr,
 #endif
 	NULL,
 };
--- a/drivers/block/zram/zram_drv.h~zram-introduce-recompress-sysfs-knob
+++ a/drivers/block/zram/zram_drv.h
@@ -49,6 +49,8 @@ enum zram_pageflags {
 	ZRAM_UNDER_WB,	/* page is under writeback */
 	ZRAM_HUGE,	/* Incompressible page */
 	ZRAM_IDLE,	/* not accessed page since last idle marking */
+	ZRAM_RECOMP,	/* page was recompressed */
+	ZRAM_RECOMP_SKIP, /* secondary algorithm cannot compress this page */
 
 	__NR_ZRAM_PAGEFLAGS,
 };
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zsmalloc-turn-zspage-order-into-runtime-variable.patch
zsmalloc-move-away-from-page-order-defines.patch
zsmalloc-make-huge-class-watermark-zs_pool-member.patch
zram-huge-size-watermark-cannot-be-global.patch
zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch
zram-add-pages_per_pool_page-device-attribute.patch
documentation-document-zram-pages_per_pool_page-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch

