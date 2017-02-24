From: akpm@linux-foundation.org
Subject: [patch 078/124] zram: extend zero pages to same element pages
Date: Fri, 24 Feb 2017 14:59:27 -0800
Message-ID: <58b0bacf.jyhZAbHEfk451x9T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdBXW73 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhouxianrong@huawei.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com

From: zhouxianrong <zhouxianrong@huawei.com>
Subject: zram: extend zero pages to same element pages

The idea is that without doing more calculations we extend zero pages to
same element pages for zram.  zero page is special case of same element
page with zero element.

1. the test is done under android 7.0
2. startup too many applications circularly
3. sample the zero pages, same pages (none-zero element)
   and total pages in function page_zero_filled

the result is listed as below:

ZERO	SAME	TOTAL
36214	17842	598196

		ZERO/TOTAL	 SAME/TOTAL	  (ZERO+SAME)/TOTAL ZERO/SAME
AVERAGE	0.060631909	 0.024990816  0.085622726		2.663825038
STDEV	0.00674612	 0.005887625  0.009707034		2.115881328
MAX		0.069698422	 0.030046087  0.094975336		7.56043956
MIN		0.03959586	 0.007332205  0.056055193		1.928985507

from the above data, the benefit is about 2.5% and up to 3% of total
swapout pages.

The defect of the patch is that when we recovery a page from non-zero
element the operations are low efficient for partial read.

This patch extends zero_page to same_page so if there is any user to have
monitored zero_pages, he will be surprised if the number is increased but
it's not harmful, I believe.

[minchan@kernel.org: do not free same element pages in zram_meta_free]
  Link: http://lkml.kernel.org/r/20170207065741.GA2567@bbox
Link: http://lkml.kernel.org/r/1483692145-75357-1-git-send-email-zhouxianrong@huawei.com
Link: http://lkml.kernel.org/r/1486307804-27903-1-git-send-email-minchan@kernel.org
Signed-off-by: zhouxianrong <zhouxianrong@huawei.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |    6 +-
 drivers/block/zram/zram_drv.c   |   87 ++++++++++++++++++++----------
 drivers/block/zram/zram_drv.h   |    9 ++-
 3 files changed, 69 insertions(+), 33 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-extend-zero-pages-to-same-element-pages Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-extend-zero-pages-to-same-element-pages
+++ a/Documentation/blockdev/zram.txt
@@ -201,8 +201,8 @@ File /sys/block/zram<id>/mm_stat
 The stat file represents device's mm statistics. It consists of a single
 line of text and contains the following stats separated by whitespace:
  orig_data_size   uncompressed size of data stored in this disk.
-                  This excludes zero-filled pages (zero_pages) since no
-                  memory is allocated for them.
+		  This excludes same-element-filled pages (same_pages) since
+		  no memory is allocated for them.
                   Unit: bytes
  compr_data_size  compressed size of data stored in this disk
  mem_used_total   the amount of memory allocated for this disk. This
@@ -214,7 +214,7 @@ line of text and contains the following
                   the compressed data
  mem_used_max     the maximum amount of memory zram have consumed to
                   store the data
- zero_pages       the number of zero filled pages written to this disk.
+ same_pages       the number of same element filled pages written to this disk.
                   No memory is allocated for such pages.
  pages_compacted  the number of pages freed during compaction
 
diff -puN drivers/block/zram/zram_drv.c~zram-extend-zero-pages-to-same-element-pages drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-extend-zero-pages-to-same-element-pages
+++ a/drivers/block/zram/zram_drv.c
@@ -74,6 +74,17 @@ static void zram_clear_flag(struct zram_
 	meta->table[index].value &= ~BIT(flag);
 }
 
+static inline void zram_set_element(struct zram_meta *meta, u32 index,
+			unsigned long element)
+{
+	meta->table[index].element = element;
+}
+
+static inline void zram_clear_element(struct zram_meta *meta, u32 index)
+{
+	meta->table[index].element = 0;
+}
+
 static size_t zram_get_obj_size(struct zram_meta *meta, u32 index)
 {
 	return meta->table[index].value & (BIT(ZRAM_FLAG_SHIFT) - 1);
@@ -146,31 +157,46 @@ static inline void update_used_max(struc
 	} while (old_max != cur_max);
 }
 
-static bool page_zero_filled(void *ptr)
+static inline void zram_fill_page(char *ptr, unsigned long len,
+					unsigned long value)
+{
+	int i;
+	unsigned long *page = (unsigned long *)ptr;
+
+	WARN_ON_ONCE(!IS_ALIGNED(len, sizeof(unsigned long)));
+
+	if (likely(value == 0)) {
+		memset(ptr, 0, len);
+	} else {
+		for (i = 0; i < len / sizeof(*page); i++)
+			page[i] = value;
+	}
+}
+
+static bool page_same_filled(void *ptr, unsigned long *element)
 {
 	unsigned int pos;
 	unsigned long *page;
 
 	page = (unsigned long *)ptr;
 
-	for (pos = 0; pos != PAGE_SIZE / sizeof(*page); pos++) {
-		if (page[pos])
+	for (pos = 0; pos < PAGE_SIZE / sizeof(*page) - 1; pos++) {
+		if (page[pos] != page[pos + 1])
 			return false;
 	}
 
+	*element = page[pos];
+
 	return true;
 }
 
-static void handle_zero_page(struct bio_vec *bvec)
+static void handle_same_page(struct bio_vec *bvec, unsigned long element)
 {
 	struct page *page = bvec->bv_page;
 	void *user_mem;
 
 	user_mem = kmap_atomic(page);
-	if (is_partial_io(bvec))
-		memset(user_mem + bvec->bv_offset, 0, bvec->bv_len);
-	else
-		clear_page(user_mem);
+	zram_fill_page(user_mem + bvec->bv_offset, bvec->bv_len, element);
 	kunmap_atomic(user_mem);
 
 	flush_dcache_page(page);
@@ -363,7 +389,7 @@ static ssize_t mm_stat_show(struct devic
 			mem_used << PAGE_SHIFT,
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
-			(u64)atomic64_read(&zram->stats.zero_pages),
+			(u64)atomic64_read(&zram->stats.same_pages),
 			pool_stats.pages_compacted);
 	up_read(&zram->init_lock);
 
@@ -399,8 +425,11 @@ static void zram_meta_free(struct zram_m
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++) {
 		unsigned long handle = meta->table[index].handle;
-
-		if (!handle)
+		/*
+		 * No memory is allocated for same element filled pages.
+		 * Simply clear same page flag.
+		 */
+		if (!handle || zram_test_flag(meta, index, ZRAM_SAME))
 			continue;
 
 		zs_free(meta->mem_pool, handle);
@@ -450,18 +479,20 @@ static void zram_free_page(struct zram *
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle = meta->table[index].handle;
 
-	if (unlikely(!handle)) {
-		/*
-		 * No memory is allocated for zero filled pages.
-		 * Simply clear zero page flag.
-		 */
-		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
-			zram_clear_flag(meta, index, ZRAM_ZERO);
-			atomic64_dec(&zram->stats.zero_pages);
-		}
+	/*
+	 * No memory is allocated for same element filled pages.
+	 * Simply clear same page flag.
+	 */
+	if (zram_test_flag(meta, index, ZRAM_SAME)) {
+		zram_clear_flag(meta, index, ZRAM_SAME);
+		zram_clear_element(meta, index);
+		atomic64_dec(&zram->stats.same_pages);
 		return;
 	}
 
+	if (!handle)
+		return;
+
 	zs_free(meta->mem_pool, handle);
 
 	atomic64_sub(zram_get_obj_size(meta, index),
@@ -484,9 +515,9 @@ static int zram_decompress_page(struct z
 	handle = meta->table[index].handle;
 	size = zram_get_obj_size(meta, index);
 
-	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
+	if (!handle || zram_test_flag(meta, index, ZRAM_SAME)) {
 		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
-		clear_page(mem);
+		zram_fill_page(mem, PAGE_SIZE, meta->table[index].element);
 		return 0;
 	}
 
@@ -522,9 +553,9 @@ static int zram_bvec_read(struct zram *z
 
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	if (unlikely(!meta->table[index].handle) ||
-			zram_test_flag(meta, index, ZRAM_ZERO)) {
+			zram_test_flag(meta, index, ZRAM_SAME)) {
 		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
-		handle_zero_page(bvec);
+		handle_same_page(bvec, meta->table[index].element);
 		return 0;
 	}
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
@@ -572,6 +603,7 @@ static int zram_bvec_write(struct zram *
 	struct zram_meta *meta = zram->meta;
 	struct zcomp_strm *zstrm = NULL;
 	unsigned long alloced_pages;
+	unsigned long element;
 
 	page = bvec->bv_page;
 	if (is_partial_io(bvec)) {
@@ -600,16 +632,17 @@ compress_again:
 		uncmem = user_mem;
 	}
 
-	if (page_zero_filled(uncmem)) {
+	if (page_same_filled(uncmem, &element)) {
 		if (user_mem)
 			kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
 		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 		zram_free_page(zram, index);
-		zram_set_flag(meta, index, ZRAM_ZERO);
+		zram_set_flag(meta, index, ZRAM_SAME);
+		zram_set_element(meta, index, element);
 		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
-		atomic64_inc(&zram->stats.zero_pages);
+		atomic64_inc(&zram->stats.same_pages);
 		ret = 0;
 		goto out;
 	}
diff -puN drivers/block/zram/zram_drv.h~zram-extend-zero-pages-to-same-element-pages drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-extend-zero-pages-to-same-element-pages
+++ a/drivers/block/zram/zram_drv.h
@@ -61,7 +61,7 @@ static const size_t max_zpage_size = PAG
 /* Flags for zram pages (table[page_no].value) */
 enum zram_pageflags {
 	/* Page consists entirely of zeros */
-	ZRAM_ZERO = ZRAM_FLAG_SHIFT,
+	ZRAM_SAME = ZRAM_FLAG_SHIFT,
 	ZRAM_ACCESS,	/* page is now accessed */
 
 	__NR_ZRAM_PAGEFLAGS,
@@ -71,7 +71,10 @@ enum zram_pageflags {
 
 /* Allocated for each disk page */
 struct zram_table_entry {
-	unsigned long handle;
+	union {
+		unsigned long handle;
+		unsigned long element;
+	};
 	unsigned long value;
 };
 
@@ -83,7 +86,7 @@ struct zram_stats {
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
-	atomic64_t zero_pages;		/* no. of zero filled pages */
+	atomic64_t same_pages;		/* no. of same element filled pages */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
 	atomic64_t writestall;		/* no. of write slow paths */
_
