From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op.patch removed from
 -mm tree
Date: Tue, 11 Apr 2017 13:54:15 -0700
Message-ID: <58ed4277.3RS+cGzqHgdhL7/O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753530AbdDKUyQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2017 16:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, axboe@kernel.dk, hare@suse.com, jthumshirn@suse.de, mika.penttila@nextfour.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use zram_slot_lock instead of raw bit_spin_lock op
has been removed from the -mm tree.  Its filename was
     zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: use zram_slot_lock instead of raw bit_spin_lock op

With this cleanup phase, I want to use zram's wrapper function to lock
table access which is more consistent with other zram's functions.

Link: http://lkml.kernel.org/r/1491196653-7388-4-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Mika Penttil <mika.penttila@nextfour.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   42 +++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op
+++ a/drivers/block/zram/zram_drv.c
@@ -415,24 +415,39 @@ static DEVICE_ATTR_RO(io_stat);
 static DEVICE_ATTR_RO(mm_stat);
 static DEVICE_ATTR_RO(debug_stat);
 
+
+static void zram_slot_lock(struct zram *zram, u32 index)
+{
+	struct zram_meta *meta = zram->meta;
+
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+}
+
+static void zram_slot_unlock(struct zram *zram, u32 index)
+{
+	struct zram_meta *meta = zram->meta;
+
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+}
+
 static bool zram_special_page_read(struct zram *zram, u32 index,
 				struct page *page,
 				unsigned int offset, unsigned int len)
 {
 	struct zram_meta *meta = zram->meta;
 
-	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_lock(zram, index);
 	if (unlikely(!meta->table[index].handle) ||
 			zram_test_flag(meta, index, ZRAM_SAME)) {
 		void *mem;
 
-		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+		zram_slot_unlock(zram, index);
 		mem = kmap_atomic(page);
 		zram_fill_page(mem + offset, len, meta->table[index].element);
 		kunmap_atomic(mem);
 		return true;
 	}
-	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_unlock(zram, index);
 
 	return false;
 }
@@ -448,11 +463,11 @@ static bool zram_special_page_write(stru
 
 		kunmap_atomic(mem);
 		/* Free memory associated with this sector now. */
-		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+		zram_slot_lock(zram, index);
 		zram_free_page(zram, index);
 		zram_set_flag(meta, index, ZRAM_SAME);
 		zram_set_element(meta, index, element);
-		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+		zram_slot_unlock(zram, index);
 
 		atomic64_inc(&zram->stats.same_pages);
 		return true;
@@ -559,7 +574,7 @@ static int zram_decompress_page(struct z
 	if (zram_special_page_read(zram, index, page, 0, PAGE_SIZE))
 		return 0;
 
-	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_lock(zram, index);
 	handle = meta->table[index].handle;
 	size = zram_get_obj_size(meta, index);
 
@@ -578,7 +593,7 @@ static int zram_decompress_page(struct z
 		zcomp_stream_put(zram->comp);
 	}
 	zs_unmap_object(meta->mem_pool, handle);
-	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_unlock(zram, index);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret))
@@ -731,11 +746,11 @@ static int __zram_bvec_write(struct zram
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
 	 */
-	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
 	meta->table[index].handle = handle;
 	zram_set_obj_size(meta, index, comp_len);
-	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_unlock(zram, index);
 
 	/* Update stats */
 	atomic64_add(comp_len, &zram->stats.compr_data_size);
@@ -793,7 +808,6 @@ static void zram_bio_discard(struct zram
 			     int offset, struct bio *bio)
 {
 	size_t n = bio->bi_iter.bi_size;
-	struct zram_meta *meta = zram->meta;
 
 	/*
 	 * zram manages data in physical block size units. Because logical block
@@ -814,9 +828,9 @@ static void zram_bio_discard(struct zram
 	}
 
 	while (n >= PAGE_SIZE) {
-		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+		zram_slot_lock(zram, index);
 		zram_free_page(zram, index);
-		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+		zram_slot_unlock(zram, index);
 		atomic64_inc(&zram->stats.notify_free);
 		index++;
 		n -= PAGE_SIZE;
@@ -925,9 +939,9 @@ static void zram_slot_free_notify(struct
 	zram = bdev->bd_disk->private_data;
 	meta = zram->meta;
 
-	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
-	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_unlock(zram, index);
 	atomic64_inc(&zram->stats.notify_free);
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch
mm-remove-swap_-fix.patch
zram-remove-zram_meta-structure.patch
zram-introduce-zram-data-accessor.patch

