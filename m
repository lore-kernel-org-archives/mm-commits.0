From: akpm@linux-foundation.org
Subject: [merged] zram-partial-io-refactoring.patch removed from
 -mm tree
Date: Thu, 04 May 2017 12:13:09 -0700
Message-ID: <20170504191309.oClwFrABS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51878 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753018AbdEDTNL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:13:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hare@suse.com, jthumshirn@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com


The patch titled
     Subject: zram: partial IO refactoring
has been removed from the -mm tree.  Its filename was
     zram-partial-io-refactoring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: partial IO refactoring

For architecture(PAGE_SIZE > 4K), zram have supported partial IO. 
However, the mixed code for handling normal/partial IO is too mess,
error-prone to modify IO handler functions with upcoming feature so this
patch aims for cleaning up zram's IO handling functions.

Link: http://lkml.kernel.org/r/1492052365-16169-3-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  337 +++++++++++++++++---------------
 1 file changed, 184 insertions(+), 153 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-partial-io-refactoring drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-partial-io-refactoring
+++ a/drivers/block/zram/zram_drv.c
@@ -45,6 +45,8 @@ static const char *default_compressor =
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+static void zram_free_page(struct zram *zram, size_t index);
+
 static inline bool init_done(struct zram *zram)
 {
 	return zram->disksize;
@@ -98,10 +100,17 @@ static void zram_set_obj_size(struct zra
 	meta->table[index].value = (flags << ZRAM_FLAG_SHIFT) | size;
 }
 
+#if PAGE_SIZE != 4096
 static inline bool is_partial_io(struct bio_vec *bvec)
 {
 	return bvec->bv_len != PAGE_SIZE;
 }
+#else
+static inline bool is_partial_io(struct bio_vec *bvec)
+{
+	return false;
+}
+#endif
 
 static void zram_revalidate_disk(struct zram *zram)
 {
@@ -189,18 +198,6 @@ static bool page_same_filled(void *ptr,
 	return true;
 }
 
-static void handle_same_page(struct bio_vec *bvec, unsigned long element)
-{
-	struct page *page = bvec->bv_page;
-	void *user_mem;
-
-	user_mem = kmap_atomic(page);
-	zram_fill_page(user_mem + bvec->bv_offset, bvec->bv_len, element);
-	kunmap_atomic(user_mem);
-
-	flush_dcache_page(page);
-}
-
 static ssize_t initstate_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -416,6 +413,53 @@ static DEVICE_ATTR_RO(io_stat);
 static DEVICE_ATTR_RO(mm_stat);
 static DEVICE_ATTR_RO(debug_stat);
 
+static bool zram_same_page_read(struct zram *zram, u32 index,
+				struct page *page,
+				unsigned int offset, unsigned int len)
+{
+	struct zram_meta *meta = zram->meta;
+
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+	if (unlikely(!meta->table[index].handle) ||
+			zram_test_flag(meta, index, ZRAM_SAME)) {
+		void *mem;
+
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+		mem = kmap_atomic(page);
+		zram_fill_page(mem + offset, len, meta->table[index].element);
+		kunmap_atomic(mem);
+		return true;
+	}
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+
+	return false;
+}
+
+static bool zram_same_page_write(struct zram *zram, u32 index,
+					struct page *page)
+{
+	unsigned long element;
+	void *mem = kmap_atomic(page);
+
+	if (page_same_filled(mem, &element)) {
+		struct zram_meta *meta = zram->meta;
+
+		kunmap_atomic(mem);
+		/* Free memory associated with this sector now. */
+		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+		zram_free_page(zram, index);
+		zram_set_flag(meta, index, ZRAM_SAME);
+		zram_set_element(meta, index, element);
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+
+		atomic64_inc(&zram->stats.same_pages);
+		return true;
+	}
+	kunmap_atomic(mem);
+
+	return false;
+}
+
 static void zram_meta_free(struct zram_meta *meta, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
@@ -502,169 +546,103 @@ static void zram_free_page(struct zram *
 	zram_set_obj_size(meta, index, 0);
 }
 
-static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
+static int zram_decompress_page(struct zram *zram, struct page *page, u32 index)
 {
-	int ret = 0;
-	unsigned char *cmem;
-	struct zram_meta *meta = zram->meta;
+	int ret;
 	unsigned long handle;
 	unsigned int size;
+	void *src, *dst;
+	struct zram_meta *meta = zram->meta;
+
+	if (zram_same_page_read(zram, index, page, 0, PAGE_SIZE))
+		return 0;
 
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	handle = meta->table[index].handle;
 	size = zram_get_obj_size(meta, index);
 
-	if (!handle || zram_test_flag(meta, index, ZRAM_SAME)) {
-		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
-		zram_fill_page(mem, PAGE_SIZE, meta->table[index].element);
-		return 0;
-	}
-
-	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
+	src = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
-		memcpy(mem, cmem, PAGE_SIZE);
+		dst = kmap_atomic(page);
+		memcpy(dst, src, PAGE_SIZE);
+		kunmap_atomic(dst);
+		ret = 0;
 	} else {
 		struct zcomp_strm *zstrm = zcomp_stream_get(zram->comp);
 
-		ret = zcomp_decompress(zstrm, cmem, size, mem);
+		dst = kmap_atomic(page);
+		ret = zcomp_decompress(zstrm, src, size, dst);
+		kunmap_atomic(dst);
 		zcomp_stream_put(zram->comp);
 	}
 	zs_unmap_object(meta->mem_pool, handle);
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret)) {
+	if (unlikely(ret))
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
-		return ret;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-			  u32 index, int offset)
+				u32 index, int offset)
 {
 	int ret;
 	struct page *page;
-	unsigned char *user_mem, *uncmem = NULL;
-	struct zram_meta *meta = zram->meta;
-	page = bvec->bv_page;
 
-	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
-	if (unlikely(!meta->table[index].handle) ||
-			zram_test_flag(meta, index, ZRAM_SAME)) {
-		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
-		handle_same_page(bvec, meta->table[index].element);
-		return 0;
+	page = bvec->bv_page;
+	if (is_partial_io(bvec)) {
+		/* Use a temporary buffer to decompress the page */
+		page = alloc_page(GFP_NOIO|__GFP_HIGHMEM);
+		if (!page)
+			return -ENOMEM;
 	}
-	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
-	if (is_partial_io(bvec))
-		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
+	ret = zram_decompress_page(zram, page, index);
+	if (unlikely(ret))
+		goto out;
 
-	user_mem = kmap_atomic(page);
-	if (!is_partial_io(bvec))
-		uncmem = user_mem;
+	if (is_partial_io(bvec)) {
+		void *dst = kmap_atomic(bvec->bv_page);
+		void *src = kmap_atomic(page);
 
-	if (!uncmem) {
-		pr_err("Unable to allocate temp memory\n");
-		ret = -ENOMEM;
-		goto out_cleanup;
+		memcpy(dst + bvec->bv_offset, src + offset, bvec->bv_len);
+		kunmap_atomic(src);
+		kunmap_atomic(dst);
 	}
-
-	ret = zram_decompress_page(zram, uncmem, index);
-	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret))
-		goto out_cleanup;
-
+out:
 	if (is_partial_io(bvec))
-		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
-				bvec->bv_len);
+		__free_page(page);
 
-	flush_dcache_page(page);
-	ret = 0;
-out_cleanup:
-	kunmap_atomic(user_mem);
-	if (is_partial_io(bvec))
-		kfree(uncmem);
 	return ret;
 }
 
-static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
-			   int offset)
+static int zram_compress(struct zram *zram, struct zcomp_strm **zstrm,
+			struct page *page,
+			unsigned long *out_handle, unsigned int *out_comp_len)
 {
-	int ret = 0;
-	unsigned int clen;
+	int ret;
+	unsigned int comp_len;
+	void *src;
+	unsigned long alloced_pages;
 	unsigned long handle = 0;
-	struct page *page;
-	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
-	struct zcomp_strm *zstrm = NULL;
-	unsigned long alloced_pages;
-	unsigned long element;
-
-	page = bvec->bv_page;
-	if (is_partial_io(bvec)) {
-		/*
-		 * This is a partial IO. We need to read the full page
-		 * before to write the changes.
-		 */
-		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
-		if (!uncmem) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		ret = zram_decompress_page(zram, uncmem, index);
-		if (ret)
-			goto out;
-	}
 
 compress_again:
-	user_mem = kmap_atomic(page);
-	if (is_partial_io(bvec)) {
-		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
-		       bvec->bv_len);
-		kunmap_atomic(user_mem);
-		user_mem = NULL;
-	} else {
-		uncmem = user_mem;
-	}
-
-	if (page_same_filled(uncmem, &element)) {
-		if (user_mem)
-			kunmap_atomic(user_mem);
-		/* Free memory associated with this sector now. */
-		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
-		zram_free_page(zram, index);
-		zram_set_flag(meta, index, ZRAM_SAME);
-		zram_set_element(meta, index, element);
-		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
-
-		atomic64_inc(&zram->stats.same_pages);
-		ret = 0;
-		goto out;
-	}
-
-	zstrm = zcomp_stream_get(zram->comp);
-	ret = zcomp_compress(zstrm, uncmem, &clen);
-	if (!is_partial_io(bvec)) {
-		kunmap_atomic(user_mem);
-		user_mem = NULL;
-		uncmem = NULL;
-	}
+	src = kmap_atomic(page);
+	ret = zcomp_compress(*zstrm, src, &comp_len);
+	kunmap_atomic(src);
 
 	if (unlikely(ret)) {
 		pr_err("Compression failed! err=%d\n", ret);
-		goto out;
+		if (handle)
+			zs_free(meta->mem_pool, handle);
+		return ret;
 	}
 
-	src = zstrm->buffer;
-	if (unlikely(clen > max_zpage_size)) {
-		clen = PAGE_SIZE;
-		if (is_partial_io(bvec))
-			src = uncmem;
-	}
+	if (unlikely(comp_len > max_zpage_size))
+		comp_len = PAGE_SIZE;
 
 	/*
 	 * handle allocation has 2 paths:
@@ -680,27 +658,21 @@ compress_again:
 	 * from the slow path and handle has already been allocated.
 	 */
 	if (!handle)
-		handle = zs_malloc(meta->mem_pool, clen,
+		handle = zs_malloc(meta->mem_pool, comp_len,
 				__GFP_KSWAPD_RECLAIM |
 				__GFP_NOWARN |
 				__GFP_HIGHMEM |
 				__GFP_MOVABLE);
 	if (!handle) {
 		zcomp_stream_put(zram->comp);
-		zstrm = NULL;
-
 		atomic64_inc(&zram->stats.writestall);
-
-		handle = zs_malloc(meta->mem_pool, clen,
+		handle = zs_malloc(meta->mem_pool, comp_len,
 				GFP_NOIO | __GFP_HIGHMEM |
 				__GFP_MOVABLE);
+		*zstrm = zcomp_stream_get(zram->comp);
 		if (handle)
 			goto compress_again;
-
-		pr_err("Error allocating memory for compressed page: %u, size=%u\n",
-			index, clen);
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	alloced_pages = zs_get_total_pages(meta->mem_pool);
@@ -708,22 +680,45 @@ compress_again:
 
 	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
 		zs_free(meta->mem_pool, handle);
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
+	}
+
+	*out_handle = handle;
+	*out_comp_len = comp_len;
+	return 0;
+}
+
+static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
+{
+	int ret;
+	unsigned long handle;
+	unsigned int comp_len;
+	void *src, *dst;
+	struct zcomp_strm *zstrm;
+	struct zram_meta *meta = zram->meta;
+	struct page *page = bvec->bv_page;
+
+	if (zram_same_page_write(zram, index, page))
+		return 0;
+
+	zstrm = zcomp_stream_get(zram->comp);
+	ret = zram_compress(zram, &zstrm, page, &handle, &comp_len);
+	if (ret) {
+		zcomp_stream_put(zram->comp);
+		return ret;
 	}
 
-	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
 
-	if ((clen == PAGE_SIZE) && !is_partial_io(bvec)) {
+	dst = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
+
+	src = zstrm->buffer;
+	if (comp_len == PAGE_SIZE)
 		src = kmap_atomic(page);
-		memcpy(cmem, src, PAGE_SIZE);
+	memcpy(dst, src, comp_len);
+	if (comp_len == PAGE_SIZE)
 		kunmap_atomic(src);
-	} else {
-		memcpy(cmem, src, clen);
-	}
 
 	zcomp_stream_put(zram->comp);
-	zstrm = NULL;
 	zs_unmap_object(meta->mem_pool, handle);
 
 	/*
@@ -732,19 +727,54 @@ compress_again:
 	 */
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	zram_free_page(zram, index);
-
 	meta->table[index].handle = handle;
-	zram_set_obj_size(meta, index, clen);
+	zram_set_obj_size(meta, index, comp_len);
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 	/* Update stats */
-	atomic64_add(clen, &zram->stats.compr_data_size);
+	atomic64_add(comp_len, &zram->stats.compr_data_size);
 	atomic64_inc(&zram->stats.pages_stored);
+	return 0;
+}
+
+static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
+				u32 index, int offset)
+{
+	int ret;
+	struct page *page = NULL;
+	void *src;
+	struct bio_vec vec;
+
+	vec = *bvec;
+	if (is_partial_io(bvec)) {
+		void *dst;
+		/*
+		 * This is a partial IO. We need to read the full page
+		 * before to write the changes.
+		 */
+		page = alloc_page(GFP_NOIO|__GFP_HIGHMEM);
+		if (!page)
+			return -ENOMEM;
+
+		ret = zram_decompress_page(zram, page, index);
+		if (ret)
+			goto out;
+
+		src = kmap_atomic(bvec->bv_page);
+		dst = kmap_atomic(page);
+		memcpy(dst + offset, src + bvec->bv_offset, bvec->bv_len);
+		kunmap_atomic(dst);
+		kunmap_atomic(src);
+
+		vec.bv_page = page;
+		vec.bv_len = PAGE_SIZE;
+		vec.bv_offset = 0;
+	}
+
+	ret = __zram_bvec_write(zram, &vec, index);
 out:
-	if (zstrm)
-		zcomp_stream_put(zram->comp);
 	if (is_partial_io(bvec))
-		kfree(uncmem);
+		__free_page(page);
 	return ret;
 }
 
@@ -800,6 +830,7 @@ static int zram_bvec_rw(struct zram *zra
 	if (!is_write) {
 		atomic64_inc(&zram->stats.num_reads);
 		ret = zram_bvec_read(zram, bvec, index, offset);
+		flush_dcache_page(bvec->bv_page);
 	} else {
 		atomic64_inc(&zram->stats.num_writes);
 		ret = zram_bvec_write(zram, bvec, index, offset);
_

Patches currently in -mm which might be from minchan@kernel.org are


