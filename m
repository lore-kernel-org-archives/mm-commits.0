Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAB7C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbiJRANq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJRAM5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:12:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ECB8982B
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:09:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CF18612FA
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD244C43151;
        Tue, 18 Oct 2022 00:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666051753;
        bh=gfDV6uJkMK23x6SWb+3tSlzpAO9KhDBIvk444oa/+9w=;
        h=Date:To:From:Subject:From;
        b=BEN9nsh+RLm4LICk2DLeOZywamlHwciA/oaex5QpSNCTptUE9lhn2pi1uFNC0gdl0
         7pwD3szyNLU7VWDn9NVdNsyTMctdgIDiPMaH2aorHifTE2AgrbIHph6F3lJly13M7v
         NA56wUf2mzqZUcECVT1SxoGL5rQH7raUpyPxrYRU=
Date:   Mon, 17 Oct 2022 17:09:13 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-preparation-for-multi-zcomp-support.patch added to mm-unstable branch
Message-Id: <20221018000913.BD244C43151@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: preparation for multi-zcomp support
has been added to the -mm mm-unstable branch.  Its filename is
     zram-preparation-for-multi-zcomp-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-preparation-for-multi-zcomp-support.patch

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
Subject: zram: preparation for multi-zcomp support
Date: Sun, 9 Oct 2022 18:07:13 +0900

Patch series "zram: Support multiple compression streams", v3.

This series adds support for multiple (per-CPU) compression streams (at
point only 2).  The main idea is that different compression algorithms
have different characteristics and zram may benefit when it uses a
combination of algorithms: a default algorithm that is faster but have
lower compression rate and a secondary algorithm that can use higher
compression rate at a price of slower compression/decompression.

There are several use cases for this functionality:

- huge pages re-compression: zstd or deflate can successfully compress
  huge pages (~50% of huge pages on my synthetic ChromeOS tests), IOW
  pages that lzo was not able to compress.

- idle pages re-compression: idle/cold pages sit in the memory and we
  may reduce zsmalloc memory usage if we recompress those idle pages.

Userspace has a number of ways to control the behavior and impact of zram
recompression: what type of pages should be recompressed, size watermarks,
etc.  Please refer to documentation patch.


This patch (of 8):

Turn compression streams and compressor algorithm name struct zram members
into arrays, so that we can have multiple compression streams support (in
the next patches).

The patch uses a rather explicit API for compressor selection:

- Get primary (default) compression stream
	zcomp_stream_get(zram->comps[ZRAM_PRIMARY_ZCOMP])
- Get secondary compression stream
	zcomp_stream_get(zram->comps[ZRAM_SECONDARY_ZCOMP])

We use similar API for compression streams put().

At this point we always have just one compression stream, since
CONFIG_ZRAM_MULTI_COMP is not yet defined.

Link: https://lkml.kernel.org/r/20221009090720.1040633-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20221009090720.1040633-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    6 +-
 drivers/block/zram/zcomp.h    |    2 
 drivers/block/zram/zram_drv.c |   87 ++++++++++++++++++++++----------
 drivers/block/zram/zram_drv.h |   14 ++++-
 4 files changed, 77 insertions(+), 32 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-preparation-for-multi-zcomp-support
+++ a/drivers/block/zram/zcomp.c
@@ -206,7 +206,7 @@ void zcomp_destroy(struct zcomp *comp)
  * case of allocation error, or any other error potentially
  * returned by zcomp_init().
  */
-struct zcomp *zcomp_create(const char *compress)
+struct zcomp *zcomp_create(const char *alg)
 {
 	struct zcomp *comp;
 	int error;
@@ -216,14 +216,14 @@ struct zcomp *zcomp_create(const char *c
 	 * is not loaded yet. We must do it here, otherwise we are about to
 	 * call /sbin/modprobe under CPU hot-plug lock.
 	 */
-	if (!zcomp_available_algorithm(compress))
+	if (!zcomp_available_algorithm(alg))
 		return ERR_PTR(-EINVAL);
 
 	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
 	if (!comp)
 		return ERR_PTR(-ENOMEM);
 
-	comp->name = compress;
+	comp->name = alg;
 	error = zcomp_init(comp);
 	if (error) {
 		kfree(comp);
--- a/drivers/block/zram/zcomp.h~zram-preparation-for-multi-zcomp-support
+++ a/drivers/block/zram/zcomp.h
@@ -27,7 +27,7 @@ int zcomp_cpu_dead(unsigned int cpu, str
 ssize_t zcomp_available_show(const char *comp, char *buf);
 bool zcomp_available_algorithm(const char *comp);
 
-struct zcomp *zcomp_create(const char *comp);
+struct zcomp *zcomp_create(const char *alg);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
--- a/drivers/block/zram/zram_drv.c~zram-preparation-for-multi-zcomp-support
+++ a/drivers/block/zram/zram_drv.c
@@ -1007,36 +1007,53 @@ static ssize_t comp_algorithm_show(struc
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	sz = zcomp_available_show(zram->compressor, buf);
+	sz = zcomp_available_show(zram->comp_algs[ZRAM_PRIMARY_ZCOMP], buf);
 	up_read(&zram->init_lock);
 
 	return sz;
 }
 
+static void comp_algorithm_set(struct zram *zram, u32 idx, const char *alg)
+{
+	/* Do not kfree() algs that we didn't allocate, IOW the default ones */
+	if (zram->comp_algs[idx] != default_compressor)
+		kfree(zram->comp_algs[idx]);
+	zram->comp_algs[idx] = alg;
+}
+
 static ssize_t comp_algorithm_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	char compressor[ARRAY_SIZE(zram->compressor)];
+	char *compressor;
 	size_t sz;
 
-	strscpy(compressor, buf, sizeof(compressor));
+	sz = strlen(buf);
+	if (sz >= CRYPTO_MAX_ALG_NAME)
+		return -E2BIG;
+
+	compressor = kstrdup(buf, GFP_KERNEL);
+	if (!compressor)
+		return -ENOMEM;
+
 	/* ignore trailing newline */
-	sz = strlen(compressor);
 	if (sz > 0 && compressor[sz - 1] == '\n')
 		compressor[sz - 1] = 0x00;
 
-	if (!zcomp_available_algorithm(compressor))
+	if (!zcomp_available_algorithm(compressor)) {
+		kfree(compressor);
 		return -EINVAL;
+	}
 
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
+		kfree(compressor);
 		pr_info("Can't change algorithm for initialized device\n");
 		return -EBUSY;
 	}
 
-	strcpy(zram->compressor, compressor);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_ZCOMP, compressor);
 	up_write(&zram->init_lock);
 	return len;
 }
@@ -1284,7 +1301,7 @@ static int __zram_bvec_read(struct zram
 	size = zram_get_obj_size(zram, index);
 
 	if (size != PAGE_SIZE)
-		zstrm = zcomp_stream_get(zram->comp);
+		zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_ZCOMP]);
 
 	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
@@ -1296,7 +1313,7 @@ static int __zram_bvec_read(struct zram
 		dst = kmap_atomic(page);
 		ret = zcomp_decompress(zstrm, src, size, dst);
 		kunmap_atomic(dst);
-		zcomp_stream_put(zram->comp);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_ZCOMP]);
 	}
 	zs_unmap_object(zram->mem_pool, handle);
 	zram_slot_unlock(zram, index);
@@ -1363,13 +1380,13 @@ static int __zram_bvec_write(struct zram
 	kunmap_atomic(mem);
 
 compress_again:
-	zstrm = zcomp_stream_get(zram->comp);
+	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_ZCOMP]);
 	src = kmap_atomic(page);
 	ret = zcomp_compress(zstrm, src, &comp_len);
 	kunmap_atomic(src);
 
 	if (unlikely(ret)) {
-		zcomp_stream_put(zram->comp);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_ZCOMP]);
 		pr_err("Compression failed! err=%d\n", ret);
 		zs_free(zram->mem_pool, handle);
 		return ret;
@@ -1397,7 +1414,7 @@ compress_again:
 				__GFP_HIGHMEM |
 				__GFP_MOVABLE);
 	if (IS_ERR((void *)handle)) {
-		zcomp_stream_put(zram->comp);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_ZCOMP]);
 		atomic64_inc(&zram->stats.writestall);
 		handle = zs_malloc(zram->mem_pool, comp_len,
 				GFP_NOIO | __GFP_HIGHMEM |
@@ -1414,14 +1431,14 @@ compress_again:
 		 * zstrm buffer back. It is necessary that the dereferencing
 		 * of the zstrm variable below occurs correctly.
 		 */
-		zstrm = zcomp_stream_get(zram->comp);
+		zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_ZCOMP]);
 	}
 
 	alloced_pages = zs_get_total_pages(zram->mem_pool);
 	update_used_max(zram, alloced_pages);
 
 	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
-		zcomp_stream_put(zram->comp);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_ZCOMP]);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
@@ -1435,7 +1452,7 @@ compress_again:
 	if (comp_len == PAGE_SIZE)
 		kunmap_atomic(src);
 
-	zcomp_stream_put(zram->comp);
+	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_ZCOMP]);
 	zs_unmap_object(zram->mem_pool, handle);
 	atomic64_add(comp_len, &zram->stats.compr_data_size);
 out:
@@ -1710,6 +1727,20 @@ out:
 	return ret;
 }
 
+static void zram_destroy_comps(struct zram *zram)
+{
+	u32 idx;
+
+	for (idx = 0; idx < ZRAM_MAX_ZCOMPS; idx++) {
+		struct zcomp *comp = zram->comps[idx];
+
+		zram->comps[idx] = NULL;
+		if (IS_ERR_OR_NULL(comp))
+			continue;
+		zcomp_destroy(comp);
+	}
+}
+
 static void zram_reset_device(struct zram *zram)
 {
 	down_write(&zram->init_lock);
@@ -1727,11 +1758,11 @@ static void zram_reset_device(struct zra
 	/* I/O operation under all of CPU are done so let's free */
 	zram_meta_free(zram, zram->disksize);
 	zram->disksize = 0;
+	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(zram->comp);
-	zram->comp = NULL;
 	reset_bdev(zram);
 
+	comp_algorithm_set(zram, ZRAM_PRIMARY_ZCOMP, default_compressor);
 	up_write(&zram->init_lock);
 }
 
@@ -1742,6 +1773,7 @@ static ssize_t disksize_store(struct dev
 	struct zcomp *comp;
 	struct zram *zram = dev_to_zram(dev);
 	int err;
+	u32 idx;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -1760,22 +1792,25 @@ static ssize_t disksize_store(struct dev
 		goto out_unlock;
 	}
 
-	comp = zcomp_create(zram->compressor);
-	if (IS_ERR(comp)) {
-		pr_err("Cannot initialise %s compressing backend\n",
-				zram->compressor);
-		err = PTR_ERR(comp);
-		goto out_free_meta;
-	}
+	for (idx = 0; idx < ZRAM_MAX_ZCOMPS; idx++) {
+		comp = zcomp_create(zram->comp_algs[idx]);
+		if (IS_ERR(comp)) {
+			pr_err("Cannot initialise %s compressing backend\n",
+			       zram->comp_algs[idx]);
+			err = PTR_ERR(comp);
+			goto out_free_comps;
+		}
 
-	zram->comp = comp;
+		zram->comps[idx] = comp;
+	}
 	zram->disksize = disksize;
 	set_capacity_and_notify(zram->disk, zram->disksize >> SECTOR_SHIFT);
 	up_write(&zram->init_lock);
 
 	return len;
 
-out_free_meta:
+out_free_comps:
+	zram_destroy_comps(zram);
 	zram_meta_free(zram, disksize);
 out_unlock:
 	up_write(&zram->init_lock);
@@ -1962,7 +1997,7 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
-	strscpy(zram->compressor, default_compressor, sizeof(zram->compressor));
+	zram->comp_algs[ZRAM_PRIMARY_ZCOMP] = default_compressor;
 
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
--- a/drivers/block/zram/zram_drv.h~zram-preparation-for-multi-zcomp-support
+++ a/drivers/block/zram/zram_drv.h
@@ -89,10 +89,20 @@ struct zram_stats {
 #endif
 };
 
+#ifdef CONFIG_ZRAM_MULTI_COMP
+#define ZRAM_PRIMARY_ZCOMP	0
+#define ZRAM_SECONDARY_ZCOMP	1
+#define ZRAM_MAX_ZCOMPS	2
+#else
+#define ZRAM_PRIMARY_ZCOMP	0
+#define ZRAM_SECONDARY_ZCOMP	0
+#define ZRAM_MAX_ZCOMPS	1
+#endif
+
 struct zram {
 	struct zram_table_entry *table;
 	struct zs_pool *mem_pool;
-	struct zcomp *comp;
+	struct zcomp *comps[ZRAM_MAX_ZCOMPS];
 	struct gendisk *disk;
 	/* Prevent concurrent execution of device init */
 	struct rw_semaphore init_lock;
@@ -107,7 +117,7 @@ struct zram {
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
-	char compressor[CRYPTO_MAX_ALG_NAME];
+	const char *comp_algs[ZRAM_MAX_ZCOMPS];
 	/*
 	 * zram is claimed so open request will be failed
 	 */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-correct-typos.patch

