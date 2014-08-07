From: akpm@linux-foundation.org
Subject: [merged] zram-remove-global-tb_lock-with-fine-grain-lock.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:53 -0700
Message-ID: <53e3dc5d.e3N7y6HHEu7KEcfc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:56961 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHGUGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:54 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so880078igi.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, davidlohr@hp.com, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: replace global tb_lock with fine grain lock
has been removed from the -mm tree.  Its filename was
     zram-remove-global-tb_lock-with-fine-grain-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: zram: replace global tb_lock with fine grain lock

Currently, we use a rwlock tb_lock to protect concurrent access to the
whole zram meta table.  However, according to the actual access model,
there is only a small chance for upper user to access the same
table[index], so the current lock granularity is too big.

The idea of optimization is to change the lock granularity from whole meta
table to per table entry (table -> table[index]), so that we can protect
concurrent access to the same table[index], meanwhile allow the maximum
concurrency.

With this in mind, several kinds of locks which could be used as a
per-entry lock were tested and compared:

Test environment:
x86-64 Intel Core2 Q8400, system memory 4GB, Ubuntu 12.04,
kernel v3.15.0-rc3 as base, zram with 4 max_comp_streams LZO.

iozone test:
iozone -t 4 -R -r 16K -s 200M -I +Z
(1GB zram with ext4 filesystem, take the average of 10 tests, KB/s)

      Test       base      CAS    spinlock    rwlock   bit_spinlock
-------------------------------------------------------------------
 Initial write  1381094   1425435   1422860   1423075   1421521
       Rewrite  1529479   1641199   1668762   1672855   1654910
          Read  8468009  11324979  11305569  11117273  10997202
       Re-read  8467476  11260914  11248059  11145336  10906486
  Reverse Read  6821393   8106334   8282174   8279195   8109186
   Stride read  7191093   8994306   9153982   8961224   9004434
   Random read  7156353   8957932   9167098   8980465   8940476
Mixed workload  4172747   5680814   5927825   5489578   5972253
  Random write  1483044   1605588   1594329   1600453   1596010
        Pwrite  1276644   1303108   1311612   1314228   1300960
         Pread  4324337   4632869   4618386   4457870   4500166

To enhance the possibility of access the same table[index] concurrently,
set zram a small disksize(10MB) and let threads run with large loop count.

fio test:
fio --bs=32k --randrepeat=1 --randseed=100 --refill_buffers
--scramble_buffers=1 --direct=1 --loops=3000 --numjobs=4
--filename=/dev/zram0 --name=seq-write --rw=write --stonewall
--name=seq-read --rw=read --stonewall --name=seq-readwrite
--rw=rw --stonewall --name=rand-readwrite --rw=randrw --stonewall
(10MB zram raw block device, take the average of 10 tests, KB/s)

    Test     base     CAS    spinlock    rwlock  bit_spinlock
-------------------------------------------------------------
seq-write   933789   999357   1003298    995961   1001958
 seq-read  5634130  6577930   6380861   6243912   6230006
   seq-rw  1405687  1638117   1640256   1633903   1634459
  rand-rw  1386119  1614664   1617211   1609267   1612471

All the optimization methods show a higher performance than the base,
however, it is hard to say which method is the most appropriate.

On the other hand, zram is mostly used on small embedded system, so we
don't want to increase any memory footprint.

This patch pick the bit_spinlock method, pack object size and page_flag
into an unsigned long table.value, so as to not increase any memory
overhead on both 32-bit and 64-bit system.

On the third hand, even though different kinds of locks have different
performances, we can ignore this difference, because: if zram is used as
zram swapfile, the swap subsystem can prevent concurrent access to the
same swapslot; if zram is used as zram-blk for set up filesystem on it,
the upper filesystem and the page cache also prevent concurrent access of
the same block mostly.  So we can ignore the different performances among
locks.

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   69 +++++++++++++++++++-------------
 drivers/block/zram/zram_drv.h |   24 ++++++++---
 2 files changed, 60 insertions(+), 33 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-global-tb_lock-with-fine-grain-lock drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-global-tb_lock-with-fine-grain-lock
+++ a/drivers/block/zram/zram_drv.c
@@ -183,19 +183,32 @@ static ssize_t comp_algorithm_store(stru
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
-	return meta->table[index].flags & BIT(flag);
+	return meta->table[index].value & BIT(flag);
 }
 
 static void zram_set_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
-	meta->table[index].flags |= BIT(flag);
+	meta->table[index].value |= BIT(flag);
 }
 
 static void zram_clear_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
-	meta->table[index].flags &= ~BIT(flag);
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
 }
 
 static inline int is_partial_io(struct bio_vec *bvec)
@@ -255,7 +268,6 @@ static struct zram_meta *zram_meta_alloc
 		goto free_table;
 	}
 
-	rwlock_init(&meta->tb_lock);
 	return meta;
 
 free_table:
@@ -304,7 +316,12 @@ static void handle_zero_page(struct bio_
 	flush_dcache_page(page);
 }
 
-/* NOTE: caller should hold meta->tb_lock with write-side */
+
+/*
+ * To protect concurrent access to the same index entry,
+ * caller should hold this table index entry's bit_spinlock to
+ * indicate this index entry is accessing.
+ */
 static void zram_free_page(struct zram *zram, size_t index)
 {
 	struct zram_meta *meta = zram->meta;
@@ -324,11 +341,12 @@ static void zram_free_page(struct zram *
 
 	zs_free(meta->mem_pool, handle);
 
-	atomic64_sub(meta->table[index].size, &zram->stats.compr_data_size);
+	atomic64_sub(zram_get_obj_size(meta, index),
+			&zram->stats.compr_data_size);
 	atomic64_dec(&zram->stats.pages_stored);
 
 	meta->table[index].handle = 0;
-	meta->table[index].size = 0;
+	zram_set_obj_size(meta, index, 0);
 }
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
@@ -339,12 +357,12 @@ static int zram_decompress_page(struct z
 	unsigned long handle;
 	size_t size;
 
-	read_lock(&meta->tb_lock);
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	handle = meta->table[index].handle;
-	size = meta->table[index].size;
+	size = zram_get_obj_size(meta, index);
 
 	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
-		read_unlock(&meta->tb_lock);
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 		clear_page(mem);
 		return 0;
 	}
@@ -355,7 +373,7 @@ static int zram_decompress_page(struct z
 	else
 		ret = zcomp_decompress(zram->comp, cmem, size, mem);
 	zs_unmap_object(meta->mem_pool, handle);
-	read_unlock(&meta->tb_lock);
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret)) {
@@ -376,14 +394,14 @@ static int zram_bvec_read(struct zram *z
 	struct zram_meta *meta = zram->meta;
 	page = bvec->bv_page;
 
-	read_lock(&meta->tb_lock);
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	if (unlikely(!meta->table[index].handle) ||
 			zram_test_flag(meta, index, ZRAM_ZERO)) {
-		read_unlock(&meta->tb_lock);
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 		handle_zero_page(bvec);
 		return 0;
 	}
-	read_unlock(&meta->tb_lock);
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 	if (is_partial_io(bvec))
 		/* Use  a temporary buffer to decompress the page */
@@ -461,10 +479,10 @@ static int zram_bvec_write(struct zram *
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
-		write_lock(&zram->meta->tb_lock);
+		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 		zram_free_page(zram, index);
 		zram_set_flag(meta, index, ZRAM_ZERO);
-		write_unlock(&zram->meta->tb_lock);
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 		atomic64_inc(&zram->stats.zero_pages);
 		ret = 0;
@@ -514,12 +532,12 @@ static int zram_bvec_write(struct zram *
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
 	 */
-	write_lock(&zram->meta->tb_lock);
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	zram_free_page(zram, index);
 
 	meta->table[index].handle = handle;
-	meta->table[index].size = clen;
-	write_unlock(&zram->meta->tb_lock);
+	zram_set_obj_size(meta, index, clen);
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_data_size);
@@ -560,6 +578,7 @@ static void zram_bio_discard(struct zram
 			     int offset, struct bio *bio)
 {
 	size_t n = bio->bi_iter.bi_size;
+	struct zram_meta *meta = zram->meta;
 
 	/*
 	 * zram manages data in physical block size units. Because logical block
@@ -580,13 +599,9 @@ static void zram_bio_discard(struct zram
 	}
 
 	while (n >= PAGE_SIZE) {
-		/*
-		 * Discard request can be large so the lock hold times could be
-		 * lengthy.  So take the lock once per page.
-		 */
-		write_lock(&zram->meta->tb_lock);
+		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 		zram_free_page(zram, index);
-		write_unlock(&zram->meta->tb_lock);
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 		index++;
 		n -= PAGE_SIZE;
 	}
@@ -821,9 +836,9 @@ static void zram_slot_free_notify(struct
 	zram = bdev->bd_disk->private_data;
 	meta = zram->meta;
 
-	write_lock(&meta->tb_lock);
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	zram_free_page(zram, index);
-	write_unlock(&meta->tb_lock);
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 	atomic64_inc(&zram->stats.notify_free);
 }
 
diff -puN drivers/block/zram/zram_drv.h~zram-remove-global-tb_lock-with-fine-grain-lock drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-global-tb_lock-with-fine-grain-lock
+++ a/drivers/block/zram/zram_drv.h
@@ -50,10 +50,24 @@ static const size_t max_zpage_size = PAG
 #define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
 	(1 << (ZRAM_LOGICAL_BLOCK_SHIFT - SECTOR_SHIFT))
 
-/* Flags for zram pages (table[page_no].flags) */
+
+/*
+ * The lower ZRAM_FLAG_SHIFT bits of table.value is for
+ * object size (excluding header), the higher bits is for
+ * zram_pageflags.
+ *
+ * zram is mainly used for memory efficiency so we want to keep memory
+ * footprint small so we can squeeze size and flags into a field.
+ * The lower ZRAM_FLAG_SHIFT bits is for object size (excluding header),
+ * the higher bits is for zram_pageflags.
+ */
+#define ZRAM_FLAG_SHIFT 24
+
+/* Flags for zram pages (table[page_no].value) */
 enum zram_pageflags {
 	/* Page consists entirely of zeros */
-	ZRAM_ZERO,
+	ZRAM_ZERO = ZRAM_FLAG_SHIFT + 1,
+	ZRAM_ACCESS,	/* page in now accessed */
 
 	__NR_ZRAM_PAGEFLAGS,
 };
@@ -63,9 +77,8 @@ enum zram_pageflags {
 /* Allocated for each disk page */
 struct zram_table_entry {
 	unsigned long handle;
-	u16 size;	/* object size (excluding header) */
-	u8 flags;
-} __aligned(4);
+	unsigned long value;
+};
 
 struct zram_stats {
 	atomic64_t compr_data_size;	/* compressed size of pages stored */
@@ -80,7 +93,6 @@ struct zram_stats {
 };
 
 struct zram_meta {
-	rwlock_t tb_lock;	/* protect table */
 	struct zram_table_entry *table;
 	struct zs_pool *mem_pool;
 };
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch

