From: akpm@linux-foundation.org
Subject: [withdrawn] zram-reorganize-code-layout.patch removed from -mm
 tree
Date: Wed, 06 May 2015 12:52:20 -0700
Message-ID: <554a70f4.eg1IK8om3ELS3YmO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbEFTwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 15:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: reorganize code layout
has been removed from the -mm tree.  Its filename was
     zram-reorganize-code-layout.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: reorganize code layout

This patch looks big, but basically it just moves code blocks.
No functional changes.

Our current code layout looks like a sandwitch.

For example,
a) between read/write handlers, we have update_used_max() helper function:

static int zram_decompress_page
static int zram_bvec_read
static inline void update_used_max
static int zram_bvec_write
static int zram_bvec_rw

b) RW request handlers __zram_make_request/zram_bio_discard are divided by
sysfs attr reset_store() function and corresponding zram_reset_device()
handler:

static void zram_bio_discard
static void zram_reset_device
static ssize_t disksize_store
static ssize_t reset_store
static void __zram_make_request

c) we first a bunch of sysfs read/store functions. then a number of
one-liners, then helper functions, RW functions, sysfs functions, helper
functions again, and so on.

Reorganize layout to be more logically grouped (a brief description,
`cat zram_drv.c | grep static` gives a bigger picture):

-- one-liners: zram_test_flag/etc.

-- helpers: is_partial_io/update_position/etc

-- sysfs attr show/store functions + ZRAM_ATTR_RO() generated stats
show() functions
exception: reset and disksize store functions are required to be after
meta() functions. because we do device create/destroy actions in these
sysfs handlers.

-- "mm" functions: meta get/put, meta alloc/free, page free
static inline bool zram_meta_get
static inline void zram_meta_put
static void zram_meta_free
static struct zram_meta *zram_meta_alloc
static void zram_free_page

-- a block of I/O functions
static int zram_decompress_page
static int zram_bvec_read
static int zram_bvec_write
static void zram_bio_discard
static int zram_bvec_rw
static void __zram_make_request
static void zram_make_request
static void zram_slot_free_notify
static int zram_rw_page

-- device contol: add/remove/init/reset functions (+zram-control class
will sit here)
static int zram_reset_device
static ssize_t reset_store
static ssize_t disksize_store
static int zram_add
static void zram_remove
static int __init zram_init
static void __exit zram_exit

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  733 +++++++++++++++-----------------
 1 file changed, 366 insertions(+), 367 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-reorganize-code-layout drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-reorganize-code-layout
+++ a/drivers/block/zram/zram_drv.c
@@ -70,33 +70,117 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
-static ssize_t compact_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+/* flag operations needs meta->tb_lock */
+static int zram_test_flag(struct zram_meta *meta, u32 index,
+			enum zram_pageflags flag)
 {
-	unsigned long nr_migrated;
-	struct zram *zram = dev_to_zram(dev);
-	struct zram_meta *meta;
+	return meta->table[index].value & BIT(flag);
+}
 
-	down_read(&zram->init_lock);
-	if (!init_done(zram)) {
-		up_read(&zram->init_lock);
-		return -EINVAL;
-	}
+static void zram_set_flag(struct zram_meta *meta, u32 index,
+			enum zram_pageflags flag)
+{
+	meta->table[index].value |= BIT(flag);
+}
 
-	meta = zram->meta;
-	nr_migrated = zs_compact(meta->mem_pool);
-	atomic64_add(nr_migrated, &zram->stats.num_migrated);
-	up_read(&zram->init_lock);
+static void zram_clear_flag(struct zram_meta *meta, u32 index,
+			enum zram_pageflags flag)
+{
+	meta->table[index].value &= ~BIT(flag);
+}
 
-	return len;
+static size_t zram_get_obj_size(struct zram_meta *meta, u32 index)
+{
+	return meta->table[index].value & (BIT(ZRAM_FLAG_SHIFT) - 1);
 }
 
-static ssize_t disksize_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static void zram_set_obj_size(struct zram_meta *meta,
+					u32 index, size_t size)
 {
-	struct zram *zram = dev_to_zram(dev);
+	unsigned long flags = meta->table[index].value >> ZRAM_FLAG_SHIFT;
 
-	return scnprintf(buf, PAGE_SIZE, "%llu\n", zram->disksize);
+	meta->table[index].value = (flags << ZRAM_FLAG_SHIFT) | size;
+}
+
+static inline int is_partial_io(struct bio_vec *bvec)
+{
+	return bvec->bv_len != PAGE_SIZE;
+}
+
+/*
+ * Check if request is within bounds and aligned on zram logical blocks.
+ */
+static inline int valid_io_request(struct zram *zram,
+		sector_t start, unsigned int size)
+{
+	u64 end, bound;
+
+	/* unaligned request */
+	if (unlikely(start & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
+		return 0;
+	if (unlikely(size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
+		return 0;
+
+	end = start + (size >> SECTOR_SHIFT);
+	bound = zram->disksize >> SECTOR_SHIFT;
+	/* out of range range */
+	if (unlikely(start >= bound || end > bound || start > end))
+		return 0;
+
+	/* I/O request is valid */
+	return 1;
+}
+
+static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
+{
+	if (*offset + bvec->bv_len >= PAGE_SIZE)
+		(*index)++;
+	*offset = (*offset + bvec->bv_len) % PAGE_SIZE;
+}
+
+static inline void update_used_max(struct zram *zram,
+					const unsigned long pages)
+{
+	unsigned long old_max, cur_max;
+
+	old_max = atomic_long_read(&zram->stats.max_used_pages);
+
+	do {
+		cur_max = old_max;
+		if (pages > cur_max)
+			old_max = atomic_long_cmpxchg(
+				&zram->stats.max_used_pages, cur_max, pages);
+	} while (old_max != cur_max);
+}
+
+static int page_zero_filled(void *ptr)
+{
+	unsigned int pos;
+	unsigned long *page;
+
+	page = (unsigned long *)ptr;
+
+	for (pos = 0; pos != PAGE_SIZE / sizeof(*page); pos++) {
+		if (page[pos])
+			return 0;
+	}
+
+	return 1;
+}
+
+static void handle_zero_page(struct bio_vec *bvec)
+{
+	struct page *page = bvec->bv_page;
+	void *user_mem;
+
+	user_mem = kmap_atomic(page);
+	if (is_partial_io(bvec))
+		memset(user_mem + bvec->bv_offset, 0, bvec->bv_len);
+	else
+		clear_page(user_mem);
+	kunmap_atomic(user_mem);
+
+	flush_dcache_page(page);
 }
 
 static ssize_t initstate_show(struct device *dev,
@@ -112,6 +196,14 @@ static ssize_t initstate_show(struct dev
 	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
 }
 
+static ssize_t disksize_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", zram->disksize);
+}
+
 static ssize_t orig_data_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -139,19 +231,6 @@ static ssize_t mem_used_total_show(struc
 	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
 }
 
-static ssize_t max_comp_streams_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	int val;
-	struct zram *zram = dev_to_zram(dev);
-
-	down_read(&zram->init_lock);
-	val = zram->max_comp_streams;
-	up_read(&zram->init_lock);
-
-	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
-}
-
 static ssize_t mem_limit_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -221,6 +300,19 @@ static ssize_t mem_used_max_store(struct
 	return len;
 }
 
+static ssize_t max_comp_streams_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->max_comp_streams;
+	up_read(&zram->init_lock);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
+}
+
 static ssize_t max_comp_streams_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -278,71 +370,101 @@ static ssize_t comp_algorithm_store(stru
 	return len;
 }
 
-/* flag operations needs meta->tb_lock */
-static int zram_test_flag(struct zram_meta *meta, u32 index,
-			enum zram_pageflags flag)
+static ssize_t compact_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
 {
-	return meta->table[index].value & BIT(flag);
-}
+	unsigned long nr_migrated;
+	struct zram *zram = dev_to_zram(dev);
+	struct zram_meta *meta;
 
-static void zram_set_flag(struct zram_meta *meta, u32 index,
-			enum zram_pageflags flag)
-{
-	meta->table[index].value |= BIT(flag);
-}
+	down_read(&zram->init_lock);
+	if (!init_done(zram)) {
+		up_read(&zram->init_lock);
+		return -EINVAL;
+	}
 
-static void zram_clear_flag(struct zram_meta *meta, u32 index,
-			enum zram_pageflags flag)
-{
-	meta->table[index].value &= ~BIT(flag);
-}
+	meta = zram->meta;
+	nr_migrated = zs_compact(meta->mem_pool);
+	atomic64_add(nr_migrated, &zram->stats.num_migrated);
+	up_read(&zram->init_lock);
 
-static size_t zram_get_obj_size(struct zram_meta *meta, u32 index)
-{
-	return meta->table[index].value & (BIT(ZRAM_FLAG_SHIFT) - 1);
+	return len;
 }
 
-static void zram_set_obj_size(struct zram_meta *meta,
-					u32 index, size_t size)
+static ssize_t io_stat_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
 {
-	unsigned long flags = meta->table[index].value >> ZRAM_FLAG_SHIFT;
+	struct zram *zram = dev_to_zram(dev);
+	ssize_t ret;
 
-	meta->table[index].value = (flags << ZRAM_FLAG_SHIFT) | size;
-}
+	down_read(&zram->init_lock);
+	ret = scnprintf(buf, PAGE_SIZE,
+			"%8llu %8llu %8llu %8llu\n",
+			(u64)atomic64_read(&zram->stats.failed_reads),
+			(u64)atomic64_read(&zram->stats.failed_writes),
+			(u64)atomic64_read(&zram->stats.invalid_io),
+			(u64)atomic64_read(&zram->stats.notify_free));
+	up_read(&zram->init_lock);
 
-static inline int is_partial_io(struct bio_vec *bvec)
-{
-	return bvec->bv_len != PAGE_SIZE;
+	return ret;
 }
 
-/*
- * Check if request is within bounds and aligned on zram logical blocks.
- */
-static inline int valid_io_request(struct zram *zram,
-		sector_t start, unsigned int size)
+static ssize_t mm_stat_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
 {
-	u64 end, bound;
+	struct zram *zram = dev_to_zram(dev);
+	u64 orig_size, mem_used = 0;
+	long max_used;
+	ssize_t ret;
 
-	/* unaligned request */
-	if (unlikely(start & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
-		return 0;
-	if (unlikely(size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
-		return 0;
+	down_read(&zram->init_lock);
+	if (init_done(zram))
+		mem_used = zs_get_total_pages(zram->meta->mem_pool);
 
-	end = start + (size >> SECTOR_SHIFT);
-	bound = zram->disksize >> SECTOR_SHIFT;
-	/* out of range range */
-	if (unlikely(start >= bound || end > bound || start > end))
-		return 0;
+	orig_size = atomic64_read(&zram->stats.pages_stored);
+	max_used = atomic_long_read(&zram->stats.max_used_pages);
 
-	/* I/O request is valid */
-	return 1;
-}
+	ret = scnprintf(buf, PAGE_SIZE,
+			"%8llu %8llu %8llu %8lu %8ld %8llu %8llu\n",
+			orig_size << PAGE_SHIFT,
+			(u64)atomic64_read(&zram->stats.compr_data_size),
+			mem_used << PAGE_SHIFT,
+			zram->limit_pages << PAGE_SHIFT,
+			max_used << PAGE_SHIFT,
+			(u64)atomic64_read(&zram->stats.zero_pages),
+			(u64)atomic64_read(&zram->stats.num_migrated));
+	up_read(&zram->init_lock);
 
-static void zram_meta_free(struct zram_meta *meta, u64 disksize)
-{
-	size_t num_pages = disksize >> PAGE_SHIFT;
-	size_t index;
+	return ret;
+}
+
+static DEVICE_ATTR_RO(io_stat);
+static DEVICE_ATTR_RO(mm_stat);
+ZRAM_ATTR_RO(num_reads);
+ZRAM_ATTR_RO(num_writes);
+ZRAM_ATTR_RO(failed_reads);
+ZRAM_ATTR_RO(failed_writes);
+ZRAM_ATTR_RO(invalid_io);
+ZRAM_ATTR_RO(notify_free);
+ZRAM_ATTR_RO(zero_pages);
+ZRAM_ATTR_RO(compr_data_size);
+
+static inline bool zram_meta_get(struct zram *zram)
+{
+	if (atomic_inc_not_zero(&zram->refcount))
+		return true;
+	return false;
+}
+
+static inline void zram_meta_put(struct zram *zram)
+{
+	atomic_dec(&zram->refcount);
+}
+
+static void zram_meta_free(struct zram_meta *meta, u64 disksize)
+{
+	size_t num_pages = disksize >> PAGE_SHIFT;
+	size_t index;
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++) {
@@ -390,56 +512,6 @@ out_error:
 	return NULL;
 }
 
-static inline bool zram_meta_get(struct zram *zram)
-{
-	if (atomic_inc_not_zero(&zram->refcount))
-		return true;
-	return false;
-}
-
-static inline void zram_meta_put(struct zram *zram)
-{
-	atomic_dec(&zram->refcount);
-}
-
-static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
-{
-	if (*offset + bvec->bv_len >= PAGE_SIZE)
-		(*index)++;
-	*offset = (*offset + bvec->bv_len) % PAGE_SIZE;
-}
-
-static int page_zero_filled(void *ptr)
-{
-	unsigned int pos;
-	unsigned long *page;
-
-	page = (unsigned long *)ptr;
-
-	for (pos = 0; pos != PAGE_SIZE / sizeof(*page); pos++) {
-		if (page[pos])
-			return 0;
-	}
-
-	return 1;
-}
-
-static void handle_zero_page(struct bio_vec *bvec)
-{
-	struct page *page = bvec->bv_page;
-	void *user_mem;
-
-	user_mem = kmap_atomic(page);
-	if (is_partial_io(bvec))
-		memset(user_mem + bvec->bv_offset, 0, bvec->bv_len);
-	else
-		clear_page(user_mem);
-	kunmap_atomic(user_mem);
-
-	flush_dcache_page(page);
-}
-
-
 /*
  * To protect concurrent access to the same index entry,
  * caller should hold this table index entry's bit_spinlock to
@@ -557,21 +629,6 @@ out_cleanup:
 	return ret;
 }
 
-static inline void update_used_max(struct zram *zram,
-					const unsigned long pages)
-{
-	unsigned long old_max, cur_max;
-
-	old_max = atomic_long_read(&zram->stats.max_used_pages);
-
-	do {
-		cur_max = old_max;
-		if (pages > cur_max)
-			old_max = atomic_long_cmpxchg(
-				&zram->stats.max_used_pages, cur_max, pages);
-	} while (old_max != cur_max);
-}
-
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			   int offset)
 {
@@ -699,35 +756,6 @@ out:
 	return ret;
 }
 
-static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, int rw)
-{
-	unsigned long start_time = jiffies;
-	int ret;
-
-	generic_start_io_acct(rw, bvec->bv_len >> SECTOR_SHIFT,
-			&zram->disk->part0);
-
-	if (rw == READ) {
-		atomic64_inc(&zram->stats.num_reads);
-		ret = zram_bvec_read(zram, bvec, index, offset);
-	} else {
-		atomic64_inc(&zram->stats.num_writes);
-		ret = zram_bvec_write(zram, bvec, index, offset);
-	}
-
-	generic_end_io_acct(rw, &zram->disk->part0, start_time);
-
-	if (unlikely(ret)) {
-		if (rw == READ)
-			atomic64_inc(&zram->stats.failed_reads);
-		else
-			atomic64_inc(&zram->stats.failed_writes);
-	}
-
-	return ret;
-}
-
 /*
  * zram_bio_discard - handler on discard request
  * @index: physical block index in PAGE_SIZE units
@@ -767,149 +795,32 @@ static void zram_bio_discard(struct zram
 	}
 }
 
-static void zram_reset_device(struct zram *zram)
-{
-	struct zram_meta *meta;
-	struct zcomp *comp;
-	u64 disksize;
-
-	down_write(&zram->init_lock);
-
-	zram->limit_pages = 0;
-
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
-	}
-
-	meta = zram->meta;
-	comp = zram->comp;
-	disksize = zram->disksize;
-	/*
-	 * Refcount will go down to 0 eventually and r/w handler
-	 * cannot handle further I/O so it will bail out by
-	 * check zram_meta_get.
-	 */
-	zram_meta_put(zram);
-	/*
-	 * We want to free zram_meta in process context to avoid
-	 * deadlock between reclaim path and any other locks.
-	 */
-	wait_event(zram->io_done, atomic_read(&zram->refcount) == 0);
-
-	/* Reset stats */
-	memset(&zram->stats, 0, sizeof(zram->stats));
-	zram->disksize = 0;
-	zram->max_comp_streams = 1;
-	set_capacity(zram->disk, 0);
-
-	up_write(&zram->init_lock);
-	/* I/O operation under all of CPU are done so let's free */
-	zram_meta_free(meta, disksize);
-	zcomp_destroy(comp);
-}
-
-static ssize_t disksize_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
-{
-	u64 disksize;
-	struct zcomp *comp;
-	struct zram_meta *meta;
-	struct zram *zram = dev_to_zram(dev);
-	int err;
-
-	disksize = memparse(buf, NULL);
-	if (!disksize)
-		return -EINVAL;
-
-	disksize = PAGE_ALIGN(disksize);
-	meta = zram_meta_alloc(zram->disk->first_minor, disksize);
-	if (!meta)
-		return -ENOMEM;
-
-	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
-	if (IS_ERR(comp)) {
-		pr_info("Cannot initialise %s compressing backend\n",
-				zram->compressor);
-		err = PTR_ERR(comp);
-		goto out_free_meta;
-	}
-
-	down_write(&zram->init_lock);
-	if (init_done(zram)) {
-		pr_info("Cannot change disksize for initialized device\n");
-		err = -EBUSY;
-		goto out_destroy_comp;
-	}
-
-	init_waitqueue_head(&zram->io_done);
-	atomic_set(&zram->refcount, 1);
-	zram->meta = meta;
-	zram->comp = comp;
-	zram->disksize = disksize;
-	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	up_write(&zram->init_lock);
-
-	/*
-	 * Revalidate disk out of the init_lock to avoid lockdep splat.
-	 * It's okay because disk's capacity is protected by init_lock
-	 * so that revalidate_disk always sees up-to-date capacity.
-	 */
-	revalidate_disk(zram->disk);
-
-	return len;
-
-out_destroy_comp:
-	up_write(&zram->init_lock);
-	zcomp_destroy(comp);
-out_free_meta:
-	zram_meta_free(meta, disksize);
-	return err;
-}
-
-static ssize_t reset_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
+			int offset, int rw)
 {
+	unsigned long start_time = jiffies;
 	int ret;
-	unsigned short do_reset;
-	struct zram *zram;
-	struct block_device *bdev;
-
-	zram = dev_to_zram(dev);
-	bdev = bdget_disk(zram->disk, 0);
 
-	if (!bdev)
-		return -ENOMEM;
+	generic_start_io_acct(rw, bvec->bv_len >> SECTOR_SHIFT,
+			&zram->disk->part0);
 
-	mutex_lock(&bdev->bd_mutex);
-	/* Do not reset an active device! */
-	if (bdev->bd_openers) {
-		ret = -EBUSY;
-		goto out;
+	if (rw == READ) {
+		atomic64_inc(&zram->stats.num_reads);
+		ret = zram_bvec_read(zram, bvec, index, offset);
+	} else {
+		atomic64_inc(&zram->stats.num_writes);
+		ret = zram_bvec_write(zram, bvec, index, offset);
 	}
 
-	ret = kstrtou16(buf, 10, &do_reset);
-	if (ret)
-		goto out;
+	generic_end_io_acct(rw, &zram->disk->part0, start_time);
 
-	if (!do_reset) {
-		ret = -EINVAL;
-		goto out;
+	if (unlikely(ret)) {
+		if (rw == READ)
+			atomic64_inc(&zram->stats.failed_reads);
+		else
+			atomic64_inc(&zram->stats.failed_writes);
 	}
 
-	/* Make sure all pending I/O is finished */
-	fsync_bdev(bdev);
-	zram_reset_device(zram);
-
-	mutex_unlock(&bdev->bd_mutex);
-	revalidate_disk(zram->disk);
-	bdput(bdev);
-
-	return len;
-
-out:
-	mutex_unlock(&bdev->bd_mutex);
-	bdput(bdev);
 	return ret;
 }
 
@@ -1049,80 +960,168 @@ out:
 	return err;
 }
 
-static const struct block_device_operations zram_devops = {
-	.swap_slot_free_notify = zram_slot_free_notify,
-	.rw_page = zram_rw_page,
-	.owner = THIS_MODULE
-};
+static void zram_reset_device(struct zram *zram)
+{
+	struct zram_meta *meta;
+	struct zcomp *comp;
+	u64 disksize;
 
-static DEVICE_ATTR_WO(compact);
-static DEVICE_ATTR_RW(disksize);
-static DEVICE_ATTR_RO(initstate);
-static DEVICE_ATTR_WO(reset);
-static DEVICE_ATTR_RO(orig_data_size);
-static DEVICE_ATTR_RO(mem_used_total);
-static DEVICE_ATTR_RW(mem_limit);
-static DEVICE_ATTR_RW(mem_used_max);
-static DEVICE_ATTR_RW(max_comp_streams);
-static DEVICE_ATTR_RW(comp_algorithm);
+	down_write(&zram->init_lock);
 
-static ssize_t io_stat_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+	zram->limit_pages = 0;
+
+	if (!init_done(zram)) {
+		up_write(&zram->init_lock);
+		return;
+	}
+
+	meta = zram->meta;
+	comp = zram->comp;
+	disksize = zram->disksize;
+	/*
+	 * Refcount will go down to 0 eventually and r/w handler
+	 * cannot handle further I/O so it will bail out by
+	 * check zram_meta_get.
+	 */
+	zram_meta_put(zram);
+	/*
+	 * We want to free zram_meta in process context to avoid
+	 * deadlock between reclaim path and any other locks.
+	 */
+	wait_event(zram->io_done, atomic_read(&zram->refcount) == 0);
+
+	/* Reset stats */
+	memset(&zram->stats, 0, sizeof(zram->stats));
+	zram->disksize = 0;
+	zram->max_comp_streams = 1;
+	set_capacity(zram->disk, 0);
+
+	up_write(&zram->init_lock);
+	/* I/O operation under all of CPU are done so let's free */
+	zram_meta_free(meta, disksize);
+	zcomp_destroy(comp);
+}
+
+static ssize_t disksize_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
 {
+	u64 disksize;
+	struct zcomp *comp;
+	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
-	ssize_t ret;
+	int err;
 
-	down_read(&zram->init_lock);
-	ret = scnprintf(buf, PAGE_SIZE,
-			"%8llu %8llu %8llu %8llu\n",
-			(u64)atomic64_read(&zram->stats.failed_reads),
-			(u64)atomic64_read(&zram->stats.failed_writes),
-			(u64)atomic64_read(&zram->stats.invalid_io),
-			(u64)atomic64_read(&zram->stats.notify_free));
-	up_read(&zram->init_lock);
+	disksize = memparse(buf, NULL);
+	if (!disksize)
+		return -EINVAL;
 
-	return ret;
+	disksize = PAGE_ALIGN(disksize);
+	meta = zram_meta_alloc(zram->disk->first_minor, disksize);
+	if (!meta)
+		return -ENOMEM;
+
+	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
+	if (IS_ERR(comp)) {
+		pr_info("Cannot initialise %s compressing backend\n",
+				zram->compressor);
+		err = PTR_ERR(comp);
+		goto out_free_meta;
+	}
+
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		pr_info("Cannot change disksize for initialized device\n");
+		err = -EBUSY;
+		goto out_destroy_comp;
+	}
+
+	init_waitqueue_head(&zram->io_done);
+	atomic_set(&zram->refcount, 1);
+	zram->meta = meta;
+	zram->comp = comp;
+	zram->disksize = disksize;
+	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
+	up_write(&zram->init_lock);
+
+	/*
+	 * Revalidate disk out of the init_lock to avoid lockdep splat.
+	 * It's okay because disk's capacity is protected by init_lock
+	 * so that revalidate_disk always sees up-to-date capacity.
+	 */
+	revalidate_disk(zram->disk);
+
+	return len;
+
+out_destroy_comp:
+	up_write(&zram->init_lock);
+	zcomp_destroy(comp);
+out_free_meta:
+	zram_meta_free(meta, disksize);
+	return err;
 }
 
-static ssize_t mm_stat_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t reset_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
 {
-	struct zram *zram = dev_to_zram(dev);
-	u64 orig_size, mem_used = 0;
-	long max_used;
-	ssize_t ret;
+	int ret;
+	unsigned short do_reset;
+	struct zram *zram;
+	struct block_device *bdev;
 
-	down_read(&zram->init_lock);
-	if (init_done(zram))
-		mem_used = zs_get_total_pages(zram->meta->mem_pool);
+	zram = dev_to_zram(dev);
+	bdev = bdget_disk(zram->disk, 0);
 
-	orig_size = atomic64_read(&zram->stats.pages_stored);
-	max_used = atomic_long_read(&zram->stats.max_used_pages);
+	if (!bdev)
+		return -ENOMEM;
 
-	ret = scnprintf(buf, PAGE_SIZE,
-			"%8llu %8llu %8llu %8lu %8ld %8llu %8llu\n",
-			orig_size << PAGE_SHIFT,
-			(u64)atomic64_read(&zram->stats.compr_data_size),
-			mem_used << PAGE_SHIFT,
-			zram->limit_pages << PAGE_SHIFT,
-			max_used << PAGE_SHIFT,
-			(u64)atomic64_read(&zram->stats.zero_pages),
-			(u64)atomic64_read(&zram->stats.num_migrated));
-	up_read(&zram->init_lock);
+	mutex_lock(&bdev->bd_mutex);
+	/* Do not reset an active device! */
+	if (bdev->bd_openers) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = kstrtou16(buf, 10, &do_reset);
+	if (ret)
+		goto out;
+
+	if (!do_reset) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Make sure all pending I/O is finished */
+	fsync_bdev(bdev);
+	zram_reset_device(zram);
+
+	mutex_unlock(&bdev->bd_mutex);
+	revalidate_disk(zram->disk);
+	bdput(bdev);
+
+	return len;
 
+out:
+	mutex_unlock(&bdev->bd_mutex);
+	bdput(bdev);
 	return ret;
 }
 
-static DEVICE_ATTR_RO(io_stat);
-static DEVICE_ATTR_RO(mm_stat);
-ZRAM_ATTR_RO(num_reads);
-ZRAM_ATTR_RO(num_writes);
-ZRAM_ATTR_RO(failed_reads);
-ZRAM_ATTR_RO(failed_writes);
-ZRAM_ATTR_RO(invalid_io);
-ZRAM_ATTR_RO(notify_free);
-ZRAM_ATTR_RO(zero_pages);
-ZRAM_ATTR_RO(compr_data_size);
+static const struct block_device_operations zram_devops = {
+	.swap_slot_free_notify = zram_slot_free_notify,
+	.rw_page = zram_rw_page,
+	.owner = THIS_MODULE
+};
+
+static DEVICE_ATTR_WO(compact);
+static DEVICE_ATTR_RW(disksize);
+static DEVICE_ATTR_RO(initstate);
+static DEVICE_ATTR_WO(reset);
+static DEVICE_ATTR_RO(orig_data_size);
+static DEVICE_ATTR_RO(mem_used_total);
+static DEVICE_ATTR_RW(mem_limit);
+static DEVICE_ATTR_RW(mem_used_max);
+static DEVICE_ATTR_RW(max_comp_streams);
+static DEVICE_ATTR_RW(comp_algorithm);
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-from-zram_add.patch
zram-close-race-by-open-overriding.patch
zram-add-dynamic-device-add-remove-functionality.patch

