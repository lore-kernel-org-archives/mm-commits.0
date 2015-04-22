From: akpm@linux-foundation.org
Subject: [to-be-updated] zram-reorganize-code-layout.patch removed from
 -mm tree
Date: Wed, 22 Apr 2015 13:30:04 -0700
Message-ID: <553804cc.tIgG9e+jesWH6oCL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbbDVUaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: reorganize code layout
has been removed from the -mm tree.  Its filename was
     zram-reorganize-code-layout.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: reorganize code layout

This patch looks big, but basically it just moves code blocks forward and
backward.  No functional changes.

Our current code layout looks a bit like a sandwitch.

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
exception: reset and disksize store functions are required to be after meta()
functions. because we do device create/destroy actions in these sysfs
handlers.

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
static void zram_reset_device_internal
static int zram_reset_device
static ssize_t reset_store
static ssize_t disksize_store
static int zram_add
static void zram_remove
static int __init zram_init
static void __exit zram_exit

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  587 +++++++++++++++-----------------
 1 file changed, 290 insertions(+), 297 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-reorganize-code-layout drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-reorganize-code-layout
+++ a/drivers/block/zram/zram_drv.c
@@ -70,6 +70,119 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
+/* flag operations needs meta->tb_lock */
+static int zram_test_flag(struct zram_meta *meta, u32 index,
+			enum zram_pageflags flag)
+{
+	return meta->table[index].value & BIT(flag);
+}
+
+static void zram_set_flag(struct zram_meta *meta, u32 index,
+			enum zram_pageflags flag)
+{
+	meta->table[index].value |= BIT(flag);
+}
+
+static void zram_clear_flag(struct zram_meta *meta, u32 index,
+			enum zram_pageflags flag)
+{
+	meta->table[index].value &= ~BIT(flag);
+}
+
+static size_t zram_get_obj_size(struct zram_meta *meta, u32 index)
+{
+	return meta->table[index].value & (BIT(ZRAM_FLAG_SHIFT) - 1);
+}
+
+static void zram_set_obj_size(struct zram_meta *meta,
+					u32 index, size_t size)
+{
+	unsigned long flags = meta->table[index].value >> ZRAM_FLAG_SHIFT;
+
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
+}
+
 static ssize_t disksize_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -257,65 +370,16 @@ static ssize_t comp_algorithm_store(stru
 	return len;
 }
 
-/* flag operations needs meta->tb_lock */
-static int zram_test_flag(struct zram_meta *meta, u32 index,
-			enum zram_pageflags flag)
-{
-	return meta->table[index].value & BIT(flag);
-}
-
-static void zram_set_flag(struct zram_meta *meta, u32 index,
-			enum zram_pageflags flag)
-{
-	meta->table[index].value |= BIT(flag);
-}
-
-static void zram_clear_flag(struct zram_meta *meta, u32 index,
-			enum zram_pageflags flag)
-{
-	meta->table[index].value &= ~BIT(flag);
-}
-
-static size_t zram_get_obj_size(struct zram_meta *meta, u32 index)
-{
-	return meta->table[index].value & (BIT(ZRAM_FLAG_SHIFT) - 1);
-}
-
-static void zram_set_obj_size(struct zram_meta *meta,
-					u32 index, size_t size)
-{
-	unsigned long flags = meta->table[index].value >> ZRAM_FLAG_SHIFT;
-
-	meta->table[index].value = (flags << ZRAM_FLAG_SHIFT) | size;
-}
-
-static inline int is_partial_io(struct bio_vec *bvec)
+static inline bool zram_meta_get(struct zram *zram)
 {
-	return bvec->bv_len != PAGE_SIZE;
+	if (atomic_inc_not_zero(&zram->refcount))
+		return true;
+	return false;
 }
 
-/*
- * Check if request is within bounds and aligned on zram logical blocks.
- */
-static inline int valid_io_request(struct zram *zram,
-		sector_t start, unsigned int size)
+static inline void zram_meta_put(struct zram *zram)
 {
-	u64 end, bound;
-
-	/* unaligned request */
-	if (unlikely(start & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
-		return 0;
-	if (unlikely(size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
-		return 0;
-
-	end = start + (size >> SECTOR_SHIFT);
-	bound = zram->disksize >> SECTOR_SHIFT;
-	/* out of range range */
-	if (unlikely(start >= bound || end > bound || start > end))
-		return 0;
-
-	/* I/O request is valid */
-	return 1;
+	atomic_dec(&zram->refcount);
 }
 
 static void zram_meta_free(struct zram_meta *meta, u64 disksize)
@@ -369,56 +433,6 @@ out_error:
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
@@ -451,6 +465,7 @@ static void zram_free_page(struct zram *
 	zram_set_obj_size(meta, index, 0);
 }
 
+
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
 	int ret = 0;
@@ -536,21 +551,6 @@ out_cleanup:
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
@@ -678,45 +678,16 @@ out:
 	return ret;
 }
 
-static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, int rw)
+/*
+ * zram_bio_discard - handler on discard request
+ * @index: physical block index in PAGE_SIZE units
+ * @offset: byte offset within physical block
+ */
+static void zram_bio_discard(struct zram *zram, u32 index,
+			     int offset, struct bio *bio)
 {
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
-/*
- * zram_bio_discard - handler on discard request
- * @index: physical block index in PAGE_SIZE units
- * @offset: byte offset within physical block
- */
-static void zram_bio_discard(struct zram *zram, u32 index,
-			     int offset, struct bio *bio)
-{
-	size_t n = bio->bi_iter.bi_size;
-	struct zram_meta *meta = zram->meta;
+	size_t n = bio->bi_iter.bi_size;
+	struct zram_meta *meta = zram->meta;
 
 	/*
 	 * zram manages data in physical block size units. Because logical block
@@ -746,151 +717,29 @@ static void zram_bio_discard(struct zram
 	}
 }
 
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
-/* internal device reset part -- cleanup allocated memory and
- * return back to initial state */
-static void zram_reset_device_internal(struct zram *zram)
+static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
+			int offset, int rw)
 {
-	struct zram_meta *meta;
-	struct zcomp *comp;
-	u64 disksize;
-
-	down_write(&zram->init_lock);
-
-	zram->limit_pages = 0;
+	int ret;
 
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
+	if (rw == READ) {
+		atomic64_inc(&zram->stats.num_reads);
+		ret = zram_bvec_read(zram, bvec, index, offset);
+	} else {
+		atomic64_inc(&zram->stats.num_writes);
+		ret = zram_bvec_write(zram, bvec, index, offset);
 	}
 
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
-static int zram_reset_device(struct zram *zram)
-{
-	int ret = 0;
-	struct block_device *bdev = bdget_disk(zram->disk, 0);
-
-	if (!bdev)
-		return -ENOMEM;
-
-	mutex_lock(&bdev->bd_mutex);
-	/* Do not reset an active device! */
-	if (bdev->bd_openers) {
-		ret = -EBUSY;
-		goto out;
+	if (unlikely(ret)) {
+		if (rw == READ)
+			atomic64_inc(&zram->stats.failed_reads);
+		else
+			atomic64_inc(&zram->stats.failed_writes);
 	}
 
-	/* Make sure all pending I/O is finished */
-	fsync_bdev(bdev);
-	zram_reset_device_internal(zram);
-out:
-	mutex_unlock(&bdev->bd_mutex);
-	bdput(bdev);
 	return ret;
 }
 
-static ssize_t reset_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
-{
-	int ret;
-	unsigned short do_reset;
-	struct zram *zram;
-
-	zram = dev_to_zram(dev);
-	ret = kstrtou16(buf, 10, &do_reset);
-	if (ret)
-		return ret;
-
-	if (!do_reset)
-		return -EINVAL;
-
-	ret = zram_reset_device(zram);
-	return ret ? ret : len;
-}
-
 static void __zram_make_request(struct zram *zram, struct bio *bio)
 {
 	int offset, rw;
@@ -945,9 +794,7 @@ out:
 	bio_io_error(bio);
 }
 
-/*
- * Handler function for all zram I/O requests.
- */
+/* Handler function for all zram I/O requests */
 static void zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct zram *zram = queue->queuedata;
@@ -1027,6 +874,152 @@ out:
 	return err;
 }
 
+/* internal device reset part -- cleanup allocated memory and
+ * return back to initial state */
+static void zram_reset_device_internal(struct zram *zram)
+{
+	struct zram_meta *meta;
+	struct zcomp *comp;
+	u64 disksize;
+
+	down_write(&zram->init_lock);
+
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
+static int zram_reset_device(struct zram *zram)
+{
+	int ret = 0;
+	struct block_device *bdev = bdget_disk(zram->disk, 0);
+
+	if (!bdev)
+		return -ENOMEM;
+
+	mutex_lock(&bdev->bd_mutex);
+	/* Do not reset an active device! */
+	if (bdev->bd_openers) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* Make sure all pending I/O is finished */
+	fsync_bdev(bdev);
+	zram_reset_device_internal(zram);
+out:
+	mutex_unlock(&bdev->bd_mutex);
+	bdput(bdev);
+	return ret;
+}
+
+static ssize_t reset_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	int ret;
+	unsigned short do_reset;
+	struct zram *zram;
+
+	zram = dev_to_zram(dev);
+	ret = kstrtou16(buf, 10, &do_reset);
+	if (ret)
+		return ret;
+
+	if (!do_reset)
+		return -EINVAL;
+
+	ret = zram_reset_device(zram);
+	return ret ? ret : len;
+}
+
+static ssize_t disksize_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	u64 disksize;
+	struct zcomp *comp;
+	struct zram_meta *meta;
+	struct zram *zram = dev_to_zram(dev);
+	int err;
+
+	disksize = memparse(buf, NULL);
+	if (!disksize)
+		return -EINVAL;
+
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
+}
+
+/* per-device block device operations and sysfs attrs */
 static const struct block_device_operations zram_devops = {
 	.swap_slot_free_notify = zram_slot_free_notify,
 	.rw_page = zram_rw_page,
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

