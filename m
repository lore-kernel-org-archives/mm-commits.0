From: akpm@linux-foundation.org
Subject: [patch 083/102] zram: introduce zram data accessor
Date: Wed, 03 May 2017 14:55:50 -0700
Message-ID: <20170503215550.sEWKvtspM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECV5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hare@suse.com, jthumshirn@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: introduce zram data accessor

With element, sometime I got confused handle and element access.  It might
be my bad but I think it's time to introduce accessor to prevent future
idiot like me.  This patch is just clean-up patch so it shouldn't change
any behavior.

Link: http://lkml.kernel.org/r/1492052365-16169-6-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   33 +++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-introduce-zram-data-accessor drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-introduce-zram-data-accessor
+++ a/drivers/block/zram/zram_drv.c
@@ -57,6 +57,16 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
+static unsigned long zram_get_handle(struct zram *zram, u32 index)
+{
+	return zram->table[index].handle;
+}
+
+static void zram_set_handle(struct zram *zram, u32 index, unsigned long handle)
+{
+	zram->table[index].handle = handle;
+}
+
 /* flag operations require table entry bit_spin_lock() being held */
 static int zram_test_flag(struct zram *zram, u32 index,
 			enum zram_pageflags flag)
@@ -82,9 +92,9 @@ static inline void zram_set_element(stru
 	zram->table[index].element = element;
 }
 
-static inline void zram_clear_element(struct zram *zram, u32 index)
+static unsigned long zram_get_element(struct zram *zram, u32 index)
 {
-	zram->table[index].element = 0;
+	return zram->table[index].element;
 }
 
 static size_t zram_get_obj_size(struct zram *zram, u32 index)
@@ -425,13 +435,14 @@ static bool zram_same_page_read(struct z
 				unsigned int offset, unsigned int len)
 {
 	zram_slot_lock(zram, index);
-	if (unlikely(!zram->table[index].handle) ||
-			zram_test_flag(zram, index, ZRAM_SAME)) {
+	if (unlikely(!zram_get_handle(zram, index) ||
+			zram_test_flag(zram, index, ZRAM_SAME))) {
 		void *mem;
 
 		zram_slot_unlock(zram, index);
 		mem = kmap_atomic(page);
-		zram_fill_page(mem + offset, len, zram->table[index].element);
+		zram_fill_page(mem + offset, len,
+					zram_get_element(zram, index));
 		kunmap_atomic(mem);
 		return true;
 	}
@@ -470,7 +481,7 @@ static void zram_meta_free(struct zram *
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++) {
-		unsigned long handle = zram->table[index].handle;
+		unsigned long handle = zram_get_handle(zram, index);
 		/*
 		 * No memory is allocated for same element filled pages.
 		 * Simply clear same page flag.
@@ -510,7 +521,7 @@ static bool zram_meta_alloc(struct zram
  */
 static void zram_free_page(struct zram *zram, size_t index)
 {
-	unsigned long handle = zram->table[index].handle;
+	unsigned long handle = zram_get_handle(zram, index);
 
 	/*
 	 * No memory is allocated for same element filled pages.
@@ -518,7 +529,7 @@ static void zram_free_page(struct zram *
 	 */
 	if (zram_test_flag(zram, index, ZRAM_SAME)) {
 		zram_clear_flag(zram, index, ZRAM_SAME);
-		zram_clear_element(zram, index);
+		zram_set_element(zram, index, 0);
 		atomic64_dec(&zram->stats.same_pages);
 		return;
 	}
@@ -532,7 +543,7 @@ static void zram_free_page(struct zram *
 			&zram->stats.compr_data_size);
 	atomic64_dec(&zram->stats.pages_stored);
 
-	zram->table[index].handle = 0;
+	zram_set_handle(zram, index, 0);
 	zram_set_obj_size(zram, index, 0);
 }
 
@@ -547,7 +558,7 @@ static int zram_decompress_page(struct z
 		return 0;
 
 	zram_slot_lock(zram, index);
-	handle = zram->table[index].handle;
+	handle = zram_get_handle(zram, index);
 	size = zram_get_obj_size(zram, index);
 
 	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
@@ -713,7 +724,7 @@ static int __zram_bvec_write(struct zram
 	 */
 	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
-	zram->table[index].handle = handle;
+	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
 
_
