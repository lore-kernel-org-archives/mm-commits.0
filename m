From: akpm@linux-foundation.org
Subject: [patch 082/102] zram: remove zram_meta structure
Date: Wed, 03 May 2017 14:55:47 -0700
Message-ID: <20170503215547.fyuTtT0VE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbdECV5Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hare@suse.com, jthumshirn@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: remove zram_meta structure

It's redundant now.  Instead, remove it and use zram structure directly.

Link: http://lkml.kernel.org/r/1492052365-16169-5-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  189 +++++++++++++-------------------
 drivers/block/zram/zram_drv.h |    6 -
 2 files changed, 78 insertions(+), 117 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-zram_meta-structure drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-zram_meta-structure
+++ a/drivers/block/zram/zram_drv.c
@@ -58,46 +58,46 @@ static inline struct zram *dev_to_zram(s
 }
 
 /* flag operations require table entry bit_spin_lock() being held */
-static int zram_test_flag(struct zram_meta *meta, u32 index,
+static int zram_test_flag(struct zram *zram, u32 index,
 			enum zram_pageflags flag)
 {
-	return meta->table[index].value & BIT(flag);
+	return zram->table[index].value & BIT(flag);
 }
 
-static void zram_set_flag(struct zram_meta *meta, u32 index,
+static void zram_set_flag(struct zram *zram, u32 index,
 			enum zram_pageflags flag)
 {
-	meta->table[index].value |= BIT(flag);
+	zram->table[index].value |= BIT(flag);
 }
 
-static void zram_clear_flag(struct zram_meta *meta, u32 index,
+static void zram_clear_flag(struct zram *zram, u32 index,
 			enum zram_pageflags flag)
 {
-	meta->table[index].value &= ~BIT(flag);
+	zram->table[index].value &= ~BIT(flag);
 }
 
-static inline void zram_set_element(struct zram_meta *meta, u32 index,
+static inline void zram_set_element(struct zram *zram, u32 index,
 			unsigned long element)
 {
-	meta->table[index].element = element;
+	zram->table[index].element = element;
 }
 
-static inline void zram_clear_element(struct zram_meta *meta, u32 index)
+static inline void zram_clear_element(struct zram *zram, u32 index)
 {
-	meta->table[index].element = 0;
+	zram->table[index].element = 0;
 }
 
-static size_t zram_get_obj_size(struct zram_meta *meta, u32 index)
+static size_t zram_get_obj_size(struct zram *zram, u32 index)
 {
-	return meta->table[index].value & (BIT(ZRAM_FLAG_SHIFT) - 1);
+	return zram->table[index].value & (BIT(ZRAM_FLAG_SHIFT) - 1);
 }
 
-static void zram_set_obj_size(struct zram_meta *meta,
+static void zram_set_obj_size(struct zram *zram,
 					u32 index, size_t size)
 {
-	unsigned long flags = meta->table[index].value >> ZRAM_FLAG_SHIFT;
+	unsigned long flags = zram->table[index].value >> ZRAM_FLAG_SHIFT;
 
-	meta->table[index].value = (flags << ZRAM_FLAG_SHIFT) | size;
+	zram->table[index].value = (flags << ZRAM_FLAG_SHIFT) | size;
 }
 
 #if PAGE_SIZE != 4096
@@ -250,9 +250,8 @@ static ssize_t mem_used_max_store(struct
 
 	down_read(&zram->init_lock);
 	if (init_done(zram)) {
-		struct zram_meta *meta = zram->meta;
 		atomic_long_set(&zram->stats.max_used_pages,
-				zs_get_total_pages(meta->mem_pool));
+				zs_get_total_pages(zram->mem_pool));
 	}
 	up_read(&zram->init_lock);
 
@@ -325,7 +324,6 @@ static ssize_t compact_store(struct devi
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	struct zram_meta *meta;
 
 	down_read(&zram->init_lock);
 	if (!init_done(zram)) {
@@ -333,8 +331,7 @@ static ssize_t compact_store(struct devi
 		return -EINVAL;
 	}
 
-	meta = zram->meta;
-	zs_compact(meta->mem_pool);
+	zs_compact(zram->mem_pool);
 	up_read(&zram->init_lock);
 
 	return len;
@@ -371,8 +368,8 @@ static ssize_t mm_stat_show(struct devic
 
 	down_read(&zram->init_lock);
 	if (init_done(zram)) {
-		mem_used = zs_get_total_pages(zram->meta->mem_pool);
-		zs_pool_stats(zram->meta->mem_pool, &pool_stats);
+		mem_used = zs_get_total_pages(zram->mem_pool);
+		zs_pool_stats(zram->mem_pool, &pool_stats);
 	}
 
 	orig_size = atomic64_read(&zram->stats.pages_stored);
@@ -415,32 +412,26 @@ static DEVICE_ATTR_RO(debug_stat);
 
 static void zram_slot_lock(struct zram *zram, u32 index)
 {
-	struct zram_meta *meta = zram->meta;
-
-	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+	bit_spin_lock(ZRAM_ACCESS, &zram->table[index].value);
 }
 
 static void zram_slot_unlock(struct zram *zram, u32 index)
 {
-	struct zram_meta *meta = zram->meta;
-
-	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+	bit_spin_unlock(ZRAM_ACCESS, &zram->table[index].value);
 }
 
 static bool zram_same_page_read(struct zram *zram, u32 index,
 				struct page *page,
 				unsigned int offset, unsigned int len)
 {
-	struct zram_meta *meta = zram->meta;
-
 	zram_slot_lock(zram, index);
-	if (unlikely(!meta->table[index].handle) ||
-			zram_test_flag(meta, index, ZRAM_SAME)) {
+	if (unlikely(!zram->table[index].handle) ||
+			zram_test_flag(zram, index, ZRAM_SAME)) {
 		void *mem;
 
 		zram_slot_unlock(zram, index);
 		mem = kmap_atomic(page);
-		zram_fill_page(mem + offset, len, meta->table[index].element);
+		zram_fill_page(mem + offset, len, zram->table[index].element);
 		kunmap_atomic(mem);
 		return true;
 	}
@@ -456,14 +447,12 @@ static bool zram_same_page_write(struct
 	void *mem = kmap_atomic(page);
 
 	if (page_same_filled(mem, &element)) {
-		struct zram_meta *meta = zram->meta;
-
 		kunmap_atomic(mem);
 		/* Free memory associated with this sector now. */
 		zram_slot_lock(zram, index);
 		zram_free_page(zram, index);
-		zram_set_flag(meta, index, ZRAM_SAME);
-		zram_set_element(meta, index, element);
+		zram_set_flag(zram, index, ZRAM_SAME);
+		zram_set_element(zram, index, element);
 		zram_slot_unlock(zram, index);
 
 		atomic64_inc(&zram->stats.same_pages);
@@ -474,56 +463,44 @@ static bool zram_same_page_write(struct
 	return false;
 }
 
-static void zram_meta_free(struct zram_meta *meta, u64 disksize)
+static void zram_meta_free(struct zram *zram, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
 	size_t index;
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++) {
-		unsigned long handle = meta->table[index].handle;
+		unsigned long handle = zram->table[index].handle;
 		/*
 		 * No memory is allocated for same element filled pages.
 		 * Simply clear same page flag.
 		 */
-		if (!handle || zram_test_flag(meta, index, ZRAM_SAME))
+		if (!handle || zram_test_flag(zram, index, ZRAM_SAME))
 			continue;
 
-		zs_free(meta->mem_pool, handle);
+		zs_free(zram->mem_pool, handle);
 	}
 
-	zs_destroy_pool(meta->mem_pool);
-	vfree(meta->table);
-	kfree(meta);
+	zs_destroy_pool(zram->mem_pool);
+	vfree(zram->table);
 }
 
-static struct zram_meta *zram_meta_alloc(char *pool_name, u64 disksize)
+static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 {
 	size_t num_pages;
-	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
-
-	if (!meta)
-		return NULL;
 
 	num_pages = disksize >> PAGE_SHIFT;
-	meta->table = vzalloc(num_pages * sizeof(*meta->table));
-	if (!meta->table) {
-		pr_err("Error allocating zram address table\n");
-		goto out_error;
-	}
+	zram->table = vzalloc(num_pages * sizeof(*zram->table));
+	if (!zram->table)
+		return false;
 
-	meta->mem_pool = zs_create_pool(pool_name);
-	if (!meta->mem_pool) {
-		pr_err("Error creating memory pool\n");
-		goto out_error;
+	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
+	if (!zram->mem_pool) {
+		vfree(zram->table);
+		return false;
 	}
 
-	return meta;
-
-out_error:
-	vfree(meta->table);
-	kfree(meta);
-	return NULL;
+	return true;
 }
 
 /*
@@ -533,16 +510,15 @@ out_error:
  */
 static void zram_free_page(struct zram *zram, size_t index)
 {
-	struct zram_meta *meta = zram->meta;
-	unsigned long handle = meta->table[index].handle;
+	unsigned long handle = zram->table[index].handle;
 
 	/*
 	 * No memory is allocated for same element filled pages.
 	 * Simply clear same page flag.
 	 */
-	if (zram_test_flag(meta, index, ZRAM_SAME)) {
-		zram_clear_flag(meta, index, ZRAM_SAME);
-		zram_clear_element(meta, index);
+	if (zram_test_flag(zram, index, ZRAM_SAME)) {
+		zram_clear_flag(zram, index, ZRAM_SAME);
+		zram_clear_element(zram, index);
 		atomic64_dec(&zram->stats.same_pages);
 		return;
 	}
@@ -550,14 +526,14 @@ static void zram_free_page(struct zram *
 	if (!handle)
 		return;
 
-	zs_free(meta->mem_pool, handle);
+	zs_free(zram->mem_pool, handle);
 
-	atomic64_sub(zram_get_obj_size(meta, index),
+	atomic64_sub(zram_get_obj_size(zram, index),
 			&zram->stats.compr_data_size);
 	atomic64_dec(&zram->stats.pages_stored);
 
-	meta->table[index].handle = 0;
-	zram_set_obj_size(meta, index, 0);
+	zram->table[index].handle = 0;
+	zram_set_obj_size(zram, index, 0);
 }
 
 static int zram_decompress_page(struct zram *zram, struct page *page, u32 index)
@@ -566,16 +542,15 @@ static int zram_decompress_page(struct z
 	unsigned long handle;
 	unsigned int size;
 	void *src, *dst;
-	struct zram_meta *meta = zram->meta;
 
 	if (zram_same_page_read(zram, index, page, 0, PAGE_SIZE))
 		return 0;
 
 	zram_slot_lock(zram, index);
-	handle = meta->table[index].handle;
-	size = zram_get_obj_size(meta, index);
+	handle = zram->table[index].handle;
+	size = zram_get_obj_size(zram, index);
 
-	src = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
+	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
 		dst = kmap_atomic(page);
 		memcpy(dst, src, PAGE_SIZE);
@@ -589,7 +564,7 @@ static int zram_decompress_page(struct z
 		kunmap_atomic(dst);
 		zcomp_stream_put(zram->comp);
 	}
-	zs_unmap_object(meta->mem_pool, handle);
+	zs_unmap_object(zram->mem_pool, handle);
 	zram_slot_unlock(zram, index);
 
 	/* Should NEVER happen. Return bio error if it does. */
@@ -641,7 +616,6 @@ static int zram_compress(struct zram *zr
 	void *src;
 	unsigned long alloced_pages;
 	unsigned long handle = 0;
-	struct zram_meta *meta = zram->meta;
 
 compress_again:
 	src = kmap_atomic(page);
@@ -651,7 +625,7 @@ compress_again:
 	if (unlikely(ret)) {
 		pr_err("Compression failed! err=%d\n", ret);
 		if (handle)
-			zs_free(meta->mem_pool, handle);
+			zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
@@ -672,7 +646,7 @@ compress_again:
 	 * from the slow path and handle has already been allocated.
 	 */
 	if (!handle)
-		handle = zs_malloc(meta->mem_pool, comp_len,
+		handle = zs_malloc(zram->mem_pool, comp_len,
 				__GFP_KSWAPD_RECLAIM |
 				__GFP_NOWARN |
 				__GFP_HIGHMEM |
@@ -680,7 +654,7 @@ compress_again:
 	if (!handle) {
 		zcomp_stream_put(zram->comp);
 		atomic64_inc(&zram->stats.writestall);
-		handle = zs_malloc(meta->mem_pool, comp_len,
+		handle = zs_malloc(zram->mem_pool, comp_len,
 				GFP_NOIO | __GFP_HIGHMEM |
 				__GFP_MOVABLE);
 		*zstrm = zcomp_stream_get(zram->comp);
@@ -689,11 +663,11 @@ compress_again:
 		return -ENOMEM;
 	}
 
-	alloced_pages = zs_get_total_pages(meta->mem_pool);
+	alloced_pages = zs_get_total_pages(zram->mem_pool);
 	update_used_max(zram, alloced_pages);
 
 	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
-		zs_free(meta->mem_pool, handle);
+		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
 
@@ -709,7 +683,6 @@ static int __zram_bvec_write(struct zram
 	unsigned int comp_len;
 	void *src, *dst;
 	struct zcomp_strm *zstrm;
-	struct zram_meta *meta = zram->meta;
 	struct page *page = bvec->bv_page;
 
 	if (zram_same_page_write(zram, index, page))
@@ -722,8 +695,7 @@ static int __zram_bvec_write(struct zram
 		return ret;
 	}
 
-
-	dst = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
+	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
 
 	src = zstrm->buffer;
 	if (comp_len == PAGE_SIZE)
@@ -733,7 +705,7 @@ static int __zram_bvec_write(struct zram
 		kunmap_atomic(src);
 
 	zcomp_stream_put(zram->comp);
-	zs_unmap_object(meta->mem_pool, handle);
+	zs_unmap_object(zram->mem_pool, handle);
 
 	/*
 	 * Free memory associated with this sector
@@ -741,8 +713,8 @@ static int __zram_bvec_write(struct zram
 	 */
 	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
-	meta->table[index].handle = handle;
-	zram_set_obj_size(meta, index, comp_len);
+	zram->table[index].handle = handle;
+	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
 
 	/* Update stats */
@@ -932,10 +904,8 @@ static void zram_slot_free_notify(struct
 				unsigned long index)
 {
 	struct zram *zram;
-	struct zram_meta *meta;
 
 	zram = bdev->bd_disk->private_data;
-	meta = zram->meta;
 
 	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
@@ -983,7 +953,6 @@ out:
 
 static void zram_reset_device(struct zram *zram)
 {
-	struct zram_meta *meta;
 	struct zcomp *comp;
 	u64 disksize;
 
@@ -996,7 +965,6 @@ static void zram_reset_device(struct zra
 		return;
 	}
 
-	meta = zram->meta;
 	comp = zram->comp;
 	disksize = zram->disksize;
 
@@ -1009,7 +977,7 @@ static void zram_reset_device(struct zra
 
 	up_write(&zram->init_lock);
 	/* I/O operation under all of CPU are done so let's free */
-	zram_meta_free(meta, disksize);
+	zram_meta_free(zram, disksize);
 	zcomp_destroy(comp);
 }
 
@@ -1018,7 +986,6 @@ static ssize_t disksize_store(struct dev
 {
 	u64 disksize;
 	struct zcomp *comp;
-	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
 	int err;
 
@@ -1026,10 +993,18 @@ static ssize_t disksize_store(struct dev
 	if (!disksize)
 		return -EINVAL;
 
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		pr_info("Cannot change disksize for initialized device\n");
+		err = -EBUSY;
+		goto out_unlock;
+	}
+
 	disksize = PAGE_ALIGN(disksize);
-	meta = zram_meta_alloc(zram->disk->disk_name, disksize);
-	if (!meta)
-		return -ENOMEM;
+	if (!zram_meta_alloc(zram, disksize)) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
 
 	comp = zcomp_create(zram->compressor);
 	if (IS_ERR(comp)) {
@@ -1039,14 +1014,6 @@ static ssize_t disksize_store(struct dev
 		goto out_free_meta;
 	}
 
-	down_write(&zram->init_lock);
-	if (init_done(zram)) {
-		pr_info("Cannot change disksize for initialized device\n");
-		err = -EBUSY;
-		goto out_destroy_comp;
-	}
-
-	zram->meta = meta;
 	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
@@ -1055,11 +1022,10 @@ static ssize_t disksize_store(struct dev
 
 	return len;
 
-out_destroy_comp:
-	up_write(&zram->init_lock);
-	zcomp_destroy(comp);
 out_free_meta:
-	zram_meta_free(meta, disksize);
+	zram_meta_free(zram, disksize);
+out_unlock:
+	up_write(&zram->init_lock);
 	return err;
 }
 
@@ -1245,7 +1211,6 @@ static int zram_add(void)
 		goto out_free_disk;
 	}
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
-	zram->meta = NULL;
 
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
diff -puN drivers/block/zram/zram_drv.h~zram-remove-zram_meta-structure drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-zram_meta-structure
+++ a/drivers/block/zram/zram_drv.h
@@ -92,13 +92,9 @@ struct zram_stats {
 	atomic64_t writestall;		/* no. of write slow paths */
 };
 
-struct zram_meta {
+struct zram {
 	struct zram_table_entry *table;
 	struct zs_pool *mem_pool;
-};
