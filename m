From: akpm@linux-foundation.org
Subject: [patch 081/102] zram: use zram_slot_lock instead of raw
 bit_spin_lock op
Date: Wed, 03 May 2017 14:55:44 -0700
Message-ID: <20170503215544.yEyRcgK5M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52398 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbdECV5M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hare@suse.com, jthumshirn@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: use zram_slot_lock instead of raw bit_spin_lock op

With this clean-up phase, I want to use zram's wrapper function to lock
table access which is more consistent with other zram's functions.

Link: http://lkml.kernel.org/r/1492052365-16169-4-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   41 +++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op
+++ a/drivers/block/zram/zram_drv.c
@@ -413,24 +413,38 @@ static DEVICE_ATTR_RO(io_stat);
 static DEVICE_ATTR_RO(mm_stat);
 static DEVICE_ATTR_RO(debug_stat);
 
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
 static bool zram_same_page_read(struct zram *zram, u32 index,
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
@@ -446,11 +460,11 @@ static bool zram_same_page_write(struct
 
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
@@ -557,7 +571,7 @@ static int zram_decompress_page(struct z
 	if (zram_same_page_read(zram, index, page, 0, PAGE_SIZE))
 		return 0;
 
-	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_lock(zram, index);
 	handle = meta->table[index].handle;
 	size = zram_get_obj_size(meta, index);
 
@@ -576,7 +590,7 @@ static int zram_decompress_page(struct z
 		zcomp_stream_put(zram->comp);
 	}
 	zs_unmap_object(meta->mem_pool, handle);
-	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_slot_unlock(zram, index);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret))
@@ -725,11 +739,11 @@ static int __zram_bvec_write(struct zram
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
@@ -787,7 +801,6 @@ static void zram_bio_discard(struct zram
 			     int offset, struct bio *bio)
 {
 	size_t n = bio->bi_iter.bi_size;
-	struct zram_meta *meta = zram->meta;
 
 	/*
 	 * zram manages data in physical block size units. Because logical block
@@ -808,9 +821,9 @@ static void zram_bio_discard(struct zram
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
@@ -924,9 +937,9 @@ static void zram_slot_free_notify(struct
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
