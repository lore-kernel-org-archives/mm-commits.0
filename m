From: akpm@linux-foundation.org
Subject: [merged]
 zram-write-incompressible-pages-to-backing-device.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:37:43 -0700
Message-ID: <20170907183743.acDtOBS7c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55332 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755713AbdIGSho (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juno.choi@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, xieyisheng1@huawei.com


The patch titled
     Subject: zram: write incompressible pages to backing device
has been removed from the -mm tree.  Its filename was
     zram-write-incompressible-pages-to-backing-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: write incompressible pages to backing device

This patch enables write IO to transfer data to backing device.  For that,
it implements write_to_bdev function which creates new bio and chaining
with parent bio to make the parent bio asynchrnous.

For rw_page which don't have parent bio, it submit owned bio and handle IO
completion by zram_page_end_io.

Also, this patch defines new flag ZRAM_WB to mark written page for later
read IO.

[xieyisheng1@huawei.com: fix typo in comment]
  Link: http://lkml.kernel.org/r/1502707447-6944-2-git-send-email-xieyisheng1@huawei.com
Link: http://lkml.kernel.org/r/1498459987-24562-8-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  113 ++++++++++++++++++++++++++++----
 drivers/block/zram/zram_drv.h |    3 
 2 files changed, 103 insertions(+), 13 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-write-incompressible-pages-to-backing-device drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-write-incompressible-pages-to-backing-device
+++ a/drivers/block/zram/zram_drv.c
@@ -445,9 +445,76 @@ static void put_entry_bdev(struct zram *
 	WARN_ON_ONCE(!was_set);
 }
 
+void zram_page_end_io(struct bio *bio)
+{
+	struct page *page = bio->bi_io_vec[0].bv_page;
+
+	page_endio(page, op_is_write(bio_op(bio)),
+			blk_status_to_errno(bio->bi_status));
+	bio_put(bio);
+}
+
+static int write_to_bdev(struct zram *zram, struct bio_vec *bvec,
+					u32 index, struct bio *parent,
+					unsigned long *pentry)
+{
+	struct bio *bio;
+	unsigned long entry;
+
+	bio = bio_alloc(GFP_ATOMIC, 1);
+	if (!bio)
+		return -ENOMEM;
+
+	entry = get_entry_bdev(zram);
+	if (!entry) {
+		bio_put(bio);
+		return -ENOSPC;
+	}
+
+	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
+	bio->bi_bdev = zram->bdev;
+	if (!bio_add_page(bio, bvec->bv_page, bvec->bv_len,
+					bvec->bv_offset)) {
+		bio_put(bio);
+		put_entry_bdev(zram, entry);
+		return -EIO;
+	}
+
+	if (!parent) {
+		bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
+		bio->bi_end_io = zram_page_end_io;
+	} else {
+		bio->bi_opf = parent->bi_opf;
+		bio_chain(bio, parent);
+	}
+
+	submit_bio(bio);
+	*pentry = entry;
+
+	return 0;
+}
+
+static void zram_wb_clear(struct zram *zram, u32 index)
+{
+	unsigned long entry;
+
+	zram_clear_flag(zram, index, ZRAM_WB);
+	entry = zram_get_element(zram, index);
+	zram_set_element(zram, index, 0);
+	put_entry_bdev(zram, entry);
+}
+
 #else
 static bool zram_wb_enabled(struct zram *zram) { return false; }
 static inline void reset_bdev(struct zram *zram) {};
+static int write_to_bdev(struct zram *zram, struct bio_vec *bvec,
+					u32 index, struct bio *parent,
+					unsigned long *pentry)
+
+{
+	return -EIO;
+}
+static void zram_wb_clear(struct zram *zram, u32 index) {}
 #endif
 
 
@@ -672,7 +739,13 @@ static bool zram_meta_alloc(struct zram
  */
 static void zram_free_page(struct zram *zram, size_t index)
 {
-	unsigned long handle = zram_get_handle(zram, index);
+	unsigned long handle;
+
+	if (zram_wb_enabled(zram) && zram_test_flag(zram, index, ZRAM_WB)) {
+		zram_wb_clear(zram, index);
+		atomic64_dec(&zram->stats.pages_stored);
+		return;
+	}
 
 	/*
 	 * No memory is allocated for same element filled pages.
@@ -686,6 +759,7 @@ static void zram_free_page(struct zram *
 		return;
 	}
 
+	handle = zram_get_handle(zram, index);
 	if (!handle)
 		return;
 
@@ -770,7 +844,8 @@ out:
 	return ret;
 }
 
-static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
+static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
+				u32 index, struct bio *bio)
 {
 	int ret = 0;
 	unsigned long alloced_pages;
@@ -781,6 +856,7 @@ static int __zram_bvec_write(struct zram
 	struct page *page = bvec->bv_page;
 	unsigned long element = 0;
 	enum zram_pageflags flags = 0;
+	bool allow_wb = true;
 
 	mem = kmap_atomic(page);
 	if (page_same_filled(mem, &element)) {
@@ -805,8 +881,20 @@ compress_again:
 		return ret;
 	}
 
-	if (unlikely(comp_len > max_zpage_size))
+	if (unlikely(comp_len > max_zpage_size)) {
+		if (zram_wb_enabled(zram) && allow_wb) {
+			zcomp_stream_put(zram->comp);
+			ret = write_to_bdev(zram, bvec, index, bio, &element);
+			if (!ret) {
+				flags = ZRAM_WB;
+				ret = 1;
+				goto out;
+			}
+			allow_wb = false;
+			goto compress_again;
+		}
 		comp_len = PAGE_SIZE;
+	}
 
 	/*
 	 * handle allocation has 2 paths:
@@ -866,10 +954,11 @@ out:
 	 */
 	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
-	if (flags == ZRAM_SAME) {
-		zram_set_flag(zram, index, ZRAM_SAME);
+
+	if (flags) {
+		zram_set_flag(zram, index, flags);
 		zram_set_element(zram, index, element);
-	} else {
+	}  else {
 		zram_set_handle(zram, index, handle);
 		zram_set_obj_size(zram, index, comp_len);
 	}
@@ -881,7 +970,7 @@ out:
 }
 
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
-				u32 index, int offset)
+				u32 index, int offset, struct bio *bio)
 {
 	int ret;
 	struct page *page = NULL;
@@ -914,7 +1003,7 @@ static int zram_bvec_write(struct zram *
 		vec.bv_offset = 0;
 	}
 
-	ret = __zram_bvec_write(zram, &vec, index);
+	ret = __zram_bvec_write(zram, &vec, index, bio);
 out:
 	if (is_partial_io(bvec))
 		__free_page(page);
@@ -965,7 +1054,7 @@ static void zram_bio_discard(struct zram
  * Returns 1 if IO request was successfully submitted.
  */
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, bool is_write)
+			int offset, bool is_write, struct bio *bio)
 {
 	unsigned long start_time = jiffies;
 	int rw_acct = is_write ? REQ_OP_WRITE : REQ_OP_READ;
@@ -980,7 +1069,7 @@ static int zram_bvec_rw(struct zram *zra
 		flush_dcache_page(bvec->bv_page);
 	} else {
 		atomic64_inc(&zram->stats.num_writes);
-		ret = zram_bvec_write(zram, bvec, index, offset);
+		ret = zram_bvec_write(zram, bvec, index, offset, bio);
 	}
 
 	generic_end_io_acct(rw_acct, &zram->disk->part0, start_time);
@@ -1024,7 +1113,7 @@ static void __zram_make_request(struct z
 			bv.bv_len = min_t(unsigned int, PAGE_SIZE - offset,
 							unwritten);
 			if (zram_bvec_rw(zram, &bv, index, offset,
-					op_is_write(bio_op(bio))) < 0)
+					op_is_write(bio_op(bio)), bio) < 0)
 				goto out;
 
 			bv.bv_offset += bv.bv_len;
@@ -1098,7 +1187,7 @@ static int zram_rw_page(struct block_dev
 	bv.bv_len = PAGE_SIZE;
 	bv.bv_offset = 0;
 
-	ret = zram_bvec_rw(zram, &bv, index, offset, is_write);
+	ret = zram_bvec_rw(zram, &bv, index, offset, is_write, NULL);
 out:
 	/*
 	 * If I/O fails, just return error(ie, non-zero) without
diff -puN drivers/block/zram/zram_drv.h~zram-write-incompressible-pages-to-backing-device drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-write-incompressible-pages-to-backing-device
+++ a/drivers/block/zram/zram_drv.h
@@ -60,9 +60,10 @@ static const size_t max_zpage_size = PAG
 
 /* Flags for zram pages (table[page_no].value) */
 enum zram_pageflags {
-	/* Page consists entirely of zeros */
+	/* Page consists the same element */
 	ZRAM_SAME = ZRAM_FLAG_SHIFT,
 	ZRAM_ACCESS,	/* page is now accessed */
+	ZRAM_WB,	/* page is stored on backing_device */
 
 	__NR_ZRAM_PAGEFLAGS,
 };
_

Patches currently in -mm which might be from minchan@kernel.org are


