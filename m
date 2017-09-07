From: akpm@linux-foundation.org
Subject: [merged]
 zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:37:25 -0700
Message-ID: <20170907183725.XdK6DobAL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755809AbdIGSh0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juno.choi@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, xieyisheng1@huawei.com


The patch titled
     Subject: zram: clean up duplicated codes in __zram_bvec_write
has been removed from the -mm tree.  Its filename was
     zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: clean up duplicated codes in __zram_bvec_write

Patch series "writeback incompressible pages to storage", v1.

zRam is useful for memory saving with compressible pages but sometime,
workload can be changed and system has lots of incompressible pages which
is very harmful for zram.

This patch supports writeback feature of zram so admin can set up a block
device and with it, zram can save the memory via writing out the
incompressile pages once it found it's incompressible pages (1/4 comp
ratio) instead of keeping the page in memory.

[1-3] is just clean up and [4-8] is step by step feature enablement.
[4-8] is logically not bisectable(ie, logical unit separation)
although I tried to compiled out without breaking but I think it would
be better to review.


This patch (of 9):

__zram_bvec_write has some of duplicated logic for zram meta data handling
of same_page|compressed_page.  This patch aims to clean it up without
behavior change.

[xieyisheng1@huawei.com: fix compr_data_size stat]
  Link: http://lkml.kernel.org/r/1502707447-6944-1-git-send-email-xieyisheng1@huawei.com
Link: http://lkml.kernel.org/r/1496019048-27016-1-git-send-email-minchan@kernel.org
Link: http://lkml.kernel.org/r/1498459987-24562-2-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Juneho Choi <juno.choi@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   56 +++++++++++++-------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-clean-up-duplicated-codes-in-__zram_bvec_write drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-clean-up-duplicated-codes-in-__zram_bvec_write
+++ a/drivers/block/zram/zram_drv.c
@@ -453,30 +453,6 @@ static bool zram_same_page_read(struct z
 	return false;
 }
 
-static bool zram_same_page_write(struct zram *zram, u32 index,
-					struct page *page)
-{
-	unsigned long element;
-	void *mem = kmap_atomic(page);
-
-	if (page_same_filled(mem, &element)) {
-		kunmap_atomic(mem);
-		/* Free memory associated with this sector now. */
-		zram_slot_lock(zram, index);
-		zram_free_page(zram, index);
-		zram_set_flag(zram, index, ZRAM_SAME);
-		zram_set_element(zram, index, element);
-		zram_slot_unlock(zram, index);
-
-		atomic64_inc(&zram->stats.same_pages);
-		atomic64_inc(&zram->stats.pages_stored);
-		return true;
-	}
-	kunmap_atomic(mem);
-
-	return false;
-}
-
 static void zram_meta_free(struct zram *zram, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
@@ -685,14 +661,23 @@ compress_again:
 static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 {
 	int ret;
-	unsigned long handle;
-	unsigned int comp_len;
-	void *src, *dst;
+	unsigned long handle = 0;
+	unsigned int comp_len = 0;
+	void *src, *dst, *mem;
 	struct zcomp_strm *zstrm;
 	struct page *page = bvec->bv_page;
+	unsigned long element = 0;
+	enum zram_pageflags flags = 0;
 
-	if (zram_same_page_write(zram, index, page))
-		return 0;
+	mem = kmap_atomic(page);
+	if (page_same_filled(mem, &element)) {
+		kunmap_atomic(mem);
+		/* Free memory associated with this sector now */
+		atomic64_inc(&zram->stats.same_pages);
+		flags = ZRAM_SAME;
+		goto out;
+	}
+	kunmap_atomic(mem);
 
 	zstrm = zcomp_stream_get(zram->comp);
 	ret = zram_compress(zram, &zstrm, page, &handle, &comp_len);
@@ -712,19 +697,24 @@ static int __zram_bvec_write(struct zram
 
 	zcomp_stream_put(zram->comp);
 	zs_unmap_object(zram->mem_pool, handle);
-
+	atomic64_add(comp_len, &zram->stats.compr_data_size);
+out:
 	/*
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
 	 */
 	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
-	zram_set_handle(zram, index, handle);
-	zram_set_obj_size(zram, index, comp_len);
+	if (flags == ZRAM_SAME) {
+		zram_set_flag(zram, index, ZRAM_SAME);
+		zram_set_element(zram, index, element);
+	} else {
+		zram_set_handle(zram, index, handle);
+		zram_set_obj_size(zram, index, comp_len);
+	}
 	zram_slot_unlock(zram, index);
 
 	/* Update stats */
-	atomic64_add(comp_len, &zram->stats.compr_data_size);
 	atomic64_inc(&zram->stats.pages_stored);
 	return 0;
 }
_

Patches currently in -mm which might be from minchan@kernel.org are


