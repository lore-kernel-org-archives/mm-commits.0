From: akpm@linux-foundation.org
Subject: + zram-introduce-zram-data-accessor.patch added to -mm tree
Date: Mon, 03 Apr 2017 15:48:00 -0700
Message-ID: <58e2d120.SXptub+9wSOqAeAl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdDCWsB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 18:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, axboe@kernel.dk, hare@suse.com, jthumshirn@suse.de, mika.penttila@nextfour.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: introduce zram data accessor
has been added to the -mm tree.  Its filename is
     zram-introduce-zram-data-accessor.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-zram-data-accessor.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-zram-data-accessor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: introduce zram data accessor

With element, sometime I got confused handle and element access.  It might
be my bad but I think it's time to introduce accessor to prevent future
idiot like me.  This patch is just clean-up patch so it shouldn't change
any behavior.

Link: http://lkml.kernel.org/r/1491196653-7388-6-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Mika Penttil <mika.penttila@nextfour.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
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
@@ -428,13 +438,14 @@ static bool zram_special_page_read(struc
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
@@ -473,7 +484,7 @@ static void zram_meta_free(struct zram *
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++) {
-		unsigned long handle = zram->table[index].handle;
+		unsigned long handle = zram_get_handle(zram, index);
 		/*
 		 * No memory is allocated for same element filled pages.
 		 * Simply clear same page flag.
@@ -513,7 +524,7 @@ static bool zram_meta_alloc(struct zram
  */
 static void zram_free_page(struct zram *zram, size_t index)
 {
-	unsigned long handle = zram->table[index].handle;
+	unsigned long handle = zram_get_handle(zram, index);
 
 	/*
 	 * No memory is allocated for same element filled pages.
@@ -521,7 +532,7 @@ static void zram_free_page(struct zram *
 	 */
 	if (zram_test_flag(zram, index, ZRAM_SAME)) {
 		zram_clear_flag(zram, index, ZRAM_SAME);
-		zram_clear_element(zram, index);
+		zram_set_element(zram, index, 0);
 		atomic64_dec(&zram->stats.same_pages);
 		return;
 	}
@@ -535,7 +546,7 @@ static void zram_free_page(struct zram *
 			&zram->stats.compr_data_size);
 	atomic64_dec(&zram->stats.pages_stored);
 
-	zram->table[index].handle = 0;
+	zram_set_handle(zram, index, 0);
 	zram_set_obj_size(zram, index, 0);
 }
 
@@ -550,7 +561,7 @@ static int zram_decompress_page(struct z
 		return 0;
 
 	zram_slot_lock(zram, index);
-	handle = zram->table[index].handle;
+	handle = zram_get_handle(zram, index);
 	size = zram_get_obj_size(zram, index);
 
 	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
@@ -721,7 +732,7 @@ static int __zram_bvec_write(struct zram
 	 */
 	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
-	zram->table[index].handle = handle;
+	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
 
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
zram-handle-multiple-pages-attached-bios-bvec.patch
zram-partial-io-refactoring.patch
zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op.patch
zram-remove-zram_meta-structure.patch
zram-introduce-zram-data-accessor.patch

