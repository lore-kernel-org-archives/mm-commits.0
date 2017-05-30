From: akpm@linux-foundation.org
Subject: + zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch added to -mm tree
Date: Tue, 30 May 2017 14:27:24 -0700
Message-ID: <592de3bc.1/xtXq2A/MH8sSuL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34506 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750897AbdE3V1Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 17:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: clean up duplicated codes in __zram_bvec_write
has been added to the -mm tree.  Its filename is
     zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch

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
Subject: zram: clean up duplicated codes in __zram_bvec_write

__zram_bvec_write has some of duplicated logic for zram meta data handling
of same_page|dedup_page|compressed_page.  This patch aims to clean it up
without behavior change.

Link: http://lkml.kernel.org/r/1496019048-27016-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   70 ++++++++++++--------------------
 1 file changed, 27 insertions(+), 43 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-clean-up-duplicated-codes-in-__zram_bvec_write drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-clean-up-duplicated-codes-in-__zram_bvec_write
+++ a/drivers/block/zram/zram_drv.c
@@ -500,30 +500,6 @@ static bool zram_same_page_read(struct z
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
 static struct zram_entry *zram_entry_alloc(struct zram *zram,
 					unsigned int len, gfp_t flags)
 {
@@ -788,28 +764,31 @@ compress_again:
 static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 {
 	int ret;
-	struct zram_entry *entry;
-	unsigned int comp_len;
-	void *src, *dst;
+	struct zram_entry *uninitialized_var(entry);
+	unsigned int uninitialized_var(comp_len);
+	void *src, *dst, *mem;
 	struct zcomp_strm *zstrm;
 	struct page *page = bvec->bv_page;
 	u32 checksum;
+	enum zram_pageflags flags = 0;
+	unsigned long uninitialized_var(element);
 
-	if (zram_same_page_write(zram, index, page))
-		return 0;
+	mem = kmap_atomic(page);
+	if (page_same_filled(mem, &element)) {
+		kunmap_atomic(mem);
+		/* Free memory associated with this sector now. */
+		flags = ZRAM_SAME;
+		atomic64_inc(&zram->stats.same_pages);
+		goto out;
+	}
+	kunmap_atomic(mem);
 
 	entry = zram_dedup_find(zram, page, &checksum);
 	if (entry) {
 		comp_len = entry->len;
-		zram_slot_lock(zram, index);
-		zram_free_page(zram, index);
-		zram_set_flag(zram, index, ZRAM_DUP);
-		zram_set_entry(zram, index, entry);
-		zram_set_obj_size(zram, index, comp_len);
-		zram_slot_unlock(zram, index);
+		flags = ZRAM_DUP;
 		atomic64_add(comp_len, &zram->stats.dup_data_size);
-		atomic64_inc(&zram->stats.pages_stored);
-		return 0;
+		goto out;
 	}
 
 	zstrm = zcomp_stream_get(zram->comp);
@@ -833,19 +812,24 @@ static int __zram_bvec_write(struct zram
 	zs_unmap_object(zram->mem_pool, zram_entry_handle(zram, entry));
 	zram_dedup_insert(zram, entry, checksum);
 
+out:
+	zram_slot_lock(zram, index);
 	/*
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
 	 */
-	zram_slot_lock(zram, index);
 	zram_free_page(zram, index);
-	zram_set_entry(zram, index, entry);
-	zram_set_obj_size(zram, index, comp_len);
+	if (flags)
+		zram_set_flag(zram, index, flags);
+	if (flags != ZRAM_SAME) {
+		zram_set_obj_size(zram, index, comp_len);
+		zram_set_entry(zram, index, entry);
+	} else {
+		zram_set_element(zram, index, element);
+	}
 	zram_slot_unlock(zram, index);
