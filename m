From: akpm@linux-foundation.org
Subject: [withdrawn]
 zram-introduce-zram_entry-to-prepare-dedup-functionality.patch removed from -mm tree
Date: Thu, 15 Jun 2017 16:29:50 -0700
Message-ID: <5943186e./Kjt8ptjlrblKRUG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdFOX3v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 19:29:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: introduce zram_entry to prepare dedup functionality
has been removed from the -mm tree.  Its filename was
     zram-introduce-zram_entry-to-prepare-dedup-functionality.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: zram: introduce zram_entry to prepare dedup functionality

The following patch will implement deduplication functionality in zram and
it requires an indirection layer to manage the life cycle of zsmalloc
handle.  To prepare that, this patch introduces zram_entry which can be
used to manage the life-cycle of zsmalloc handle.  Many lines are changed
due to rename but core change is just simple introduction about newly data
structure.

Link: http://lkml.kernel.org/r/1494556204-25796-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   95 ++++++++++++++++++++------------
 drivers/block/zram/zram_drv.h |    6 +-
 2 files changed, 66 insertions(+), 35 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-introduce-zram_entry-to-prepare-dedup-functionality drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-introduce-zram_entry-to-prepare-dedup-functionality
+++ a/drivers/block/zram/zram_drv.c
@@ -57,14 +57,15 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
-static unsigned long zram_get_handle(struct zram *zram, u32 index)
+static struct zram_entry *zram_get_entry(struct zram *zram, u32 index)
 {
-	return zram->table[index].handle;
+	return zram->table[index].entry;
 }
 
-static void zram_set_handle(struct zram *zram, u32 index, unsigned long handle)
+static void zram_set_entry(struct zram *zram, u32 index,
+			struct zram_entry *entry)
 {
-	zram->table[index].handle = handle;
+	zram->table[index].entry = entry;
 }
 
 /* flag operations require table entry bit_spin_lock() being held */
@@ -437,7 +438,7 @@ static bool zram_same_page_read(struct z
 				unsigned int offset, unsigned int len)
 {
 	zram_slot_lock(zram, index);
-	if (unlikely(!zram_get_handle(zram, index) ||
+	if (unlikely(!zram_get_entry(zram, index) ||
 			zram_test_flag(zram, index, ZRAM_SAME))) {
 		void *mem;
 
@@ -476,6 +477,32 @@ static bool zram_same_page_write(struct
 	return false;
 }
 
+static struct zram_entry *zram_entry_alloc(struct zram *zram,
+					unsigned int len, gfp_t flags)
+{
+	struct zram_entry *entry;
+
+	entry = kzalloc(sizeof(*entry),
+			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
+	if (!entry)
+		return NULL;
+
+	entry->handle = zs_malloc(zram->mem_pool, len, flags);
+	if (!entry->handle) {
+		kfree(entry);
+		return NULL;
+	}
+
+	return entry;
+}
+
+static inline void zram_entry_free(struct zram *zram,
+			struct zram_entry *entry)
+{
+	zs_free(zram->mem_pool, entry->handle);
+	kfree(entry);
+}
+
 static void zram_meta_free(struct zram *zram, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
@@ -514,7 +541,7 @@ static bool zram_meta_alloc(struct zram
  */
 static void zram_free_page(struct zram *zram, size_t index)
 {
-	unsigned long handle = zram_get_handle(zram, index);
+	struct zram_entry *entry = zram_get_entry(zram, index);
 
 	/*
 	 * No memory is allocated for same element filled pages.
@@ -527,23 +554,23 @@ static void zram_free_page(struct zram *
 		return;
 	}
 
-	if (!handle)
+	if (!entry)
 		return;
 
-	zs_free(zram->mem_pool, handle);
+	zram_entry_free(zram, entry);
 
 	atomic64_sub(zram_get_obj_size(zram, index),
 			&zram->stats.compr_data_size);
 	atomic64_dec(&zram->stats.pages_stored);
 
-	zram_set_handle(zram, index, 0);
+	zram_set_entry(zram, index, NULL);
 	zram_set_obj_size(zram, index, 0);
 }
 
 static int zram_decompress_page(struct zram *zram, struct page *page, u32 index)
 {
 	int ret;
-	unsigned long handle;
+	struct zram_entry *entry;
 	unsigned int size;
 	void *src, *dst;
 
@@ -551,10 +578,10 @@ static int zram_decompress_page(struct z
 		return 0;
 
 	zram_slot_lock(zram, index);
-	handle = zram_get_handle(zram, index);
+	entry = zram_get_entry(zram, index);
 	size = zram_get_obj_size(zram, index);
 
-	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
+	src = zs_map_object(zram->mem_pool, entry->handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
 		dst = kmap_atomic(page);
 		memcpy(dst, src, PAGE_SIZE);
@@ -568,7 +595,7 @@ static int zram_decompress_page(struct z
 		kunmap_atomic(dst);
 		zcomp_stream_put(zram->comp);
 	}
-	zs_unmap_object(zram->mem_pool, handle);
+	zs_unmap_object(zram->mem_pool, entry->handle);
 	zram_slot_unlock(zram, index);
 
 	/* Should NEVER happen. Return bio error if it does. */
@@ -612,14 +639,14 @@ out:
 }
 
 static int zram_compress(struct zram *zram, struct zcomp_strm **zstrm,
-			struct page *page,
-			unsigned long *out_handle, unsigned int *out_comp_len)
+			struct page *page, struct zram_entry **out_entry,
+			unsigned int *out_comp_len)
 {
 	int ret;
 	unsigned int comp_len;
 	void *src;
 	unsigned long alloced_pages;
-	unsigned long handle = 0;
+	struct zram_entry *entry = NULL;
 
 compress_again:
 	src = kmap_atomic(page);
@@ -628,8 +655,8 @@ compress_again:
 
 	if (unlikely(ret)) {
 		pr_err("Compression failed! err=%d\n", ret);
-		if (handle)
-			zs_free(zram->mem_pool, handle);
+		if (entry)
+			zram_entry_free(zram, entry);
 		return ret;
 	}
 
@@ -637,32 +664,32 @@ compress_again:
 		comp_len = PAGE_SIZE;
 
 	/*
-	 * handle allocation has 2 paths:
+	 * entry allocation has 2 paths:
 	 * a) fast path is executed with preemption disabled (for
 	 *  per-cpu streams) and has __GFP_DIRECT_RECLAIM bit clear,
 	 *  since we can't sleep;
 	 * b) slow path enables preemption and attempts to allocate
 	 *  the page with __GFP_DIRECT_RECLAIM bit set. we have to
 	 *  put per-cpu compression stream and, thus, to re-do
-	 *  the compression once handle is allocated.
+	 *  the compression once entry is allocated.
 	 *
-	 * if we have a 'non-null' handle here then we are coming
-	 * from the slow path and handle has already been allocated.
+	 * if we have a 'non-null' entry here then we are coming
+	 * from the slow path and entry has already been allocated.
 	 */
-	if (!handle)
-		handle = zs_malloc(zram->mem_pool, comp_len,
+	if (!entry)
+		entry = zram_entry_alloc(zram, comp_len,
 				__GFP_KSWAPD_RECLAIM |
 				__GFP_NOWARN |
 				__GFP_HIGHMEM |
 				__GFP_MOVABLE);
-	if (!handle) {
+	if (!entry) {
 		zcomp_stream_put(zram->comp);
 		atomic64_inc(&zram->stats.writestall);
-		handle = zs_malloc(zram->mem_pool, comp_len,
+		entry = zram_entry_alloc(zram, comp_len,
 				GFP_NOIO | __GFP_HIGHMEM |
 				__GFP_MOVABLE);
 		*zstrm = zcomp_stream_get(zram->comp);
-		if (handle)
+		if (entry)
 			goto compress_again;
 		return -ENOMEM;
 	}
@@ -671,11 +698,11 @@ compress_again:
 	update_used_max(zram, alloced_pages);
 
 	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
-		zs_free(zram->mem_pool, handle);
+		zram_entry_free(zram, entry);
 		return -ENOMEM;
 	}
 
-	*out_handle = handle;
+	*out_entry = entry;
 	*out_comp_len = comp_len;
 	return 0;
 }
@@ -683,7 +710,7 @@ compress_again:
 static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 {
 	int ret;
-	unsigned long handle;
+	struct zram_entry *entry;
 	unsigned int comp_len;
 	void *src, *dst;
 	struct zcomp_strm *zstrm;
@@ -693,13 +720,13 @@ static int __zram_bvec_write(struct zram
 		return 0;
 
 	zstrm = zcomp_stream_get(zram->comp);
-	ret = zram_compress(zram, &zstrm, page, &handle, &comp_len);
+	ret = zram_compress(zram, &zstrm, page, &entry, &comp_len);
 	if (ret) {
 		zcomp_stream_put(zram->comp);
 		return ret;
 	}
 
-	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
+	dst = zs_map_object(zram->mem_pool, entry->handle, ZS_MM_WO);
 
 	src = zstrm->buffer;
 	if (comp_len == PAGE_SIZE)
@@ -709,7 +736,7 @@ static int __zram_bvec_write(struct zram
 		kunmap_atomic(src);
 
 	zcomp_stream_put(zram->comp);
-	zs_unmap_object(zram->mem_pool, handle);
+	zs_unmap_object(zram->mem_pool, entry->handle);
 
 	/*
 	 * Free memory associated with this sector
@@ -717,7 +744,7 @@ static int __zram_bvec_write(struct zram
 	 */
 	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
-	zram_set_handle(zram, index, handle);
+	zram_set_entry(zram, index, entry);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
 
diff -puN drivers/block/zram/zram_drv.h~zram-introduce-zram_entry-to-prepare-dedup-functionality drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-introduce-zram_entry-to-prepare-dedup-functionality
+++ a/drivers/block/zram/zram_drv.h
@@ -69,10 +69,14 @@ enum zram_pageflags {
 
 /*-- Data structures */
 
+struct zram_entry {
+	unsigned long handle;
+};
+
 /* Allocated for each disk page */
 struct zram_table_entry {
 	union {
-		unsigned long handle;
+		struct zram_entry *entry;
 		unsigned long element;
 	};
 	unsigned long value;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

zram-implement-deduplication-in-zram.patch
zram-make-deduplication-feature-optional.patch
zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch
mm-kasan-use-kasan_zero_pud-for-p4d-table.patch
mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch

