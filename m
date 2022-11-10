Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CE4C4321E
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiKJAa7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiKJAa5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:30:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1E013D2A
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:30:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2501561D2D
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D939C4347C;
        Thu, 10 Nov 2022 00:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668040254;
        bh=IeQs2gENq7bgp7Hkv6XzEwSgZKyFlmrKNkpSHbT2h30=;
        h=Date:To:From:Subject:From;
        b=TOd5BAAI0PvBZ/SyqdJynxP09ERRoqzlU++K5gxN9nvi4qgKwzMBXD0OXwssb1qS6
         VHKryKxtRD9DDMaMqMUHEYJ3bds9hQEsU5QcWDmwlY5bCeyk1OZZ0M5BJ6Ln4mte3C
         DqqmS7b/5KcJu+GvwyzOK1fp8VWDcvl/8oAXufLY=
Date:   Wed, 09 Nov 2022 16:30:53 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-recompress-sysfs-knob.patch added to mm-unstable branch
Message-Id: <20221110003054.7D939C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: introduce recompress sysfs knob
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-recompress-sysfs-knob.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-recompress-sysfs-knob.patch

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
Subject: zram: introduce recompress sysfs knob
Date: Wed, 9 Nov 2022 20:50:38 +0900

Allow zram to recompress (using secondary compression streams)
pages.

Re-compression algorithms (we support up to 3 at this stage)
are selected via recomp_algorithm:

  echo "algo=zstd priority=1" > /sys/block/zramX/recomp_algorithm

Please read documentation for more details.

We support several recompression modes:

1) IDLE pages recompression is activated by `idle` mode

  echo "type=idle" > /sys/block/zram0/recompress

2) Since there may be many idle pages user-space may pass a size
threshold value (in bytes) and we will recompress pages only
of equal or greater size:

  echo "threshold=888" > /sys/block/zram0/recompress

3) HUGE pages recompression is activated by `huge` mode

  echo "type=huge" > /sys/block/zram0/recompress

4) HUGE_IDLE pages recompression is activated by `huge_idle` mode

  echo "type=huge_idle" > /sys/block/zram0/recompress

Link: https://lkml.kernel.org/r/20221109115047.2921851-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |    9 +
 drivers/block/zram/zram_drv.c |  264 +++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h |    7 
 3 files changed, 277 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-introduce-recompress-sysfs-knob
+++ a/drivers/block/zram/Kconfig
@@ -78,3 +78,12 @@ config ZRAM_MEMORY_TRACKING
 	  /sys/kernel/debug/zram/zramX/block_state.
 
 	  See Documentation/admin-guide/blockdev/zram.rst for more information.
+
+config ZRAM_MULTI_COMP
+	bool "Enable multiple compression streams"
+	depends on ZRAM
+	help
+	  This will enable multi-compression streams, so that ZRAM can
+	  re-compress pages using a potentially slower but more effective
+	  compression algorithm. Note, that IDLE page recompression
+	  requires ZRAM_MEMORY_TRACKING.
--- a/drivers/block/zram/zram_drv.c~zram-introduce-recompress-sysfs-knob
+++ a/drivers/block/zram/zram_drv.c
@@ -155,6 +155,25 @@ static inline bool is_partial_io(struct
 }
 #endif
 
+static inline void zram_set_priority(struct zram *zram, u32 index, u32 prio)
+{
+	prio &= ZRAM_COMP_PRIORITY_MASK;
+	/*
+	 * Clear previous priority value first, in case if we recompress
+	 * further an already recompressed page
+	 */
+	zram->table[index].flags &= ~(ZRAM_COMP_PRIORITY_MASK <<
+				      ZRAM_COMP_PRIORITY_BIT1);
+	zram->table[index].flags |= (prio << ZRAM_COMP_PRIORITY_BIT1);
+}
+
+static inline u32 zram_get_priority(struct zram *zram, u32 index)
+{
+	u32 prio = zram->table[index].flags >> ZRAM_COMP_PRIORITY_BIT1;
+
+	return prio & ZRAM_COMP_PRIORITY_MASK;
+}
+
 /*
  * Check if request is within bounds and aligned on zram logical blocks.
  */
@@ -1304,6 +1323,11 @@ static void zram_free_page(struct zram *
 		atomic64_dec(&zram->stats.huge_pages);
 	}
 
+	if (zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
+		zram_clear_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+
+	zram_set_priority(zram, index, 0);
+
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
 		free_block_bdev(zram, zram_get_element(zram, index));
@@ -1364,6 +1388,7 @@ static int zram_read_from_zspool(struct
 	unsigned long handle;
 	unsigned int size;
 	void *src, *dst;
+	u32 prio;
 	int ret;
 
 	handle = zram_get_handle(zram, index);
@@ -1380,8 +1405,10 @@ static int zram_read_from_zspool(struct
 
 	size = zram_get_obj_size(zram, index);
 
-	if (size != PAGE_SIZE)
-		zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
+	if (size != PAGE_SIZE) {
+		prio = zram_get_priority(zram, index);
+		zstrm = zcomp_stream_get(zram->comps[prio]);
+	}
 
 	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
@@ -1393,7 +1420,7 @@ static int zram_read_from_zspool(struct
 		dst = kmap_atomic(page);
 		ret = zcomp_decompress(zstrm, src, size, dst);
 		kunmap_atomic(dst);
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zcomp_stream_put(zram->comps[prio]);
 	}
 	zs_unmap_object(zram->mem_pool, handle);
 	return ret;
@@ -1624,6 +1651,235 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_ZRAM_MULTI_COMP
+/*
+ * This function will decompress (unless it's ZRAM_HUGE) the page and then
+ * attempt to compress it using provided compression algorithm priority
+ * (which is potentially more effective).
+ *
+ * Corresponding ZRAM slot should be locked.
+ */
+static int zram_recompress(struct zram *zram, u32 index, struct page *page,
+			   u32 threshold, u32 prio, u32 prio_max)
+{
+	struct zcomp_strm *zstrm = NULL;
+	unsigned long handle_old;
+	unsigned long handle_new;
+	unsigned int comp_len_old;
+	unsigned int comp_len_new;
+	void *src, *dst;
+	int ret;
+
+	handle_old = zram_get_handle(zram, index);
+	if (!handle_old)
+		return -EINVAL;
+
+	comp_len_old = zram_get_obj_size(zram, index);
+	/*
+	 * Do not recompress objects that are already "small enough".
+	 */
+	if (comp_len_old < threshold)
+		return 0;
+
+	ret = zram_read_from_zspool(zram, page, index);
+	if (ret)
+		return ret;
+
+	/*
+	 * Iterate the secondary comp algorithms list (in order of priority)
+	 * and try to recompress the page.
+	 */
+	for (; prio < prio_max; prio++) {
+		if (!zram->comps[prio])
+			continue;
+
+		/*
+		 * Skip if the object is already re-compressed with a higher
+		 * priority algorithm (or same algorithm).
+		 */
+		if (prio <= zram_get_priority(zram, index))
+			continue;
+
+		zstrm = zcomp_stream_get(zram->comps[prio]);
+		src = kmap_atomic(page);
+		ret = zcomp_compress(zstrm, src, &comp_len_new);
+		kunmap_atomic(src);
+
+		if (ret) {
+			zcomp_stream_put(zram->comps[prio]);
+			return ret;
+		}
+
+		/* Continue until we make progress */
+		if (comp_len_new >= huge_class_size ||
+		    comp_len_new >= comp_len_old ||
+		    (threshold && comp_len_new >= threshold)) {
+			zcomp_stream_put(zram->comps[prio]);
+			continue;
+		}
+
+		/* Recompression was successful so break out */
+		break;
+	}
+
+	/*
+	 * We did not try to recompress, e.g. when we have only one
+	 * secondary algorithm and the page is already recompressed
+	 * using that algorithm
+	 */
+	if (!zstrm)
+		return 0;
+
+	/*
+	 * All secondary algorithms failed to re-compress the page in a way
+	 * that would save memory, mark the object as incompressible so that
+	 * we will not try to compress it again.
+	 */
+	if (comp_len_new >= huge_class_size || comp_len_new >= comp_len_old) {
+		zram_set_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+		return 0;
+	}
+
+	/* Successful recompression but above threshold */
+	if (threshold && comp_len_new >= threshold)
+		return 0;
+
+	/*
+	 * No direct reclaim (slow path) for handle allocation and no
+	 * re-compression attempt (unlike in __zram_bvec_write()) since
+	 * we already have stored that object in zsmalloc. If we cannot
+	 * alloc memory for recompressed object then we bail out and
+	 * simply keep the old (existing) object in zsmalloc.
+	 */
+	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
+			       __GFP_KSWAPD_RECLAIM |
+			       __GFP_NOWARN |
+			       __GFP_HIGHMEM |
+			       __GFP_MOVABLE);
+	if (IS_ERR_VALUE(handle_new)) {
+		zcomp_stream_put(zram->comps[prio]);
+		return PTR_ERR((void *)handle_new);
+	}
+
+	dst = zs_map_object(zram->mem_pool, handle_new, ZS_MM_WO);
+	memcpy(dst, zstrm->buffer, comp_len_new);
+	zcomp_stream_put(zram->comps[prio]);
+
+	zs_unmap_object(zram->mem_pool, handle_new);
+
+	zram_free_page(zram, index);
+	zram_set_handle(zram, index, handle_new);
+	zram_set_obj_size(zram, index, comp_len_new);
+	zram_set_priority(zram, index, prio);
+
+	atomic64_add(comp_len_new, &zram->stats.compr_data_size);
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
+	u32 mode = 0, threshold = 0, prio = ZRAM_SECONDARY_COMP;
+	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	char *args, *param, *val;
+	unsigned long index;
+	struct page *page;
+	ssize_t ret;
+
+	args = skip_spaces(buf);
+	while (*args) {
+		args = next_arg(args, &param, &val);
+
+		if (!*val)
+			return -EINVAL;
+
+		if (!strcmp(param, "type")) {
+			if (!strcmp(val, "idle"))
+				mode = RECOMPRESS_IDLE;
+			if (!strcmp(val, "huge"))
+				mode = RECOMPRESS_HUGE;
+			if (!strcmp(val, "huge_idle"))
+				mode = RECOMPRESS_IDLE | RECOMPRESS_HUGE;
+			continue;
+		}
+
+		if (!strcmp(param, "threshold")) {
+			/*
+			 * We will re-compress only idle objects equal or
+			 * greater in size than watermark.
+			 */
+			ret = kstrtouint(val, 10, &threshold);
+			if (ret)
+				return ret;
+			continue;
+		}
+	}
+
+	if (threshold >= PAGE_SIZE)
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
+		int err;
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
+		    zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
+			goto next;
+
+		err = zram_recompress(zram, index, page, threshold,
+				      prio, ZRAM_MAX_COMPS);
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
@@ -2003,6 +2259,7 @@ static DEVICE_ATTR_RW(writeback_limit_en
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
+static DEVICE_ATTR_WO(recompress);
 #endif
 
 static struct attribute *zram_disk_attrs[] = {
@@ -2029,6 +2286,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_debug_stat.attr,
 #ifdef CONFIG_ZRAM_MULTI_COMP
 	&dev_attr_recomp_algorithm.attr,
+	&dev_attr_recompress.attr,
 #endif
 	NULL,
 };
--- a/drivers/block/zram/zram_drv.h~zram-introduce-recompress-sysfs-knob
+++ a/drivers/block/zram/zram_drv.h
@@ -40,6 +40,9 @@
  */
 #define ZRAM_FLAG_SHIFT (PAGE_SHIFT + 1)
 
+/* Only 2 bits are allowed for comp priority index */
+#define ZRAM_COMP_PRIORITY_MASK	0x3
+
 /* Flags for zram pages (table[page_no].flags) */
 enum zram_pageflags {
 	/* zram slot is locked */
@@ -49,6 +52,10 @@ enum zram_pageflags {
 	ZRAM_UNDER_WB,	/* page is under writeback */
 	ZRAM_HUGE,	/* Incompressible page */
 	ZRAM_IDLE,	/* not accessed page since last idle marking */
+	ZRAM_INCOMPRESSIBLE, /* none of the algorithms could compress it */
+
+	ZRAM_COMP_PRIORITY_BIT1, /* First bit of comp priority index */
+	ZRAM_COMP_PRIORITY_BIT2, /* Second bit of comp priority index */
 
 	__NR_ZRAM_PAGEFLAGS,
 };
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

