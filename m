From: akpm@linux-foundation.org
Subject: + zram-factor-out-partial-io-routine.patch added to -mm tree
Date: Wed, 29 Mar 2017 15:25:32 -0700
Message-ID: <58dc345c.2sIFgn31CiZhgKKP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbdC2WZe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 18:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: factor out partial IO routine
has been added to the -mm tree.  Its filename is
     zram-factor-out-partial-io-routine.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-factor-out-partial-io-routine.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-factor-out-partial-io-routine.patch

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
Subject: zram: factor out partial IO routine

For architecture(PAGE_SIZE > 4K), zram have supported partial IO. 
However, the mixed code for handling normal/partial IO is too messy,
error-prone to modify IO handler functions with upcoming feature so this
patch aims for cleaning up via factoring out partial IO routines to
zram_bvec_partial_[read|write] which will be disabled for most 4K page
architecures.

x86(4K architecure)
add/remove: 0/1 grow/shrink: 0/1 up/down: 0/-664 (-664)
function                                     old     new   delta
zram_bvec_rw                                2301    2039    -262
zram_decompress_page.isra                    402       -    -402

So, we will save 662 bytes.

However, as side effect, it will increase binary size in non-4K
architecure but it's not major for zram so I believe benefit(maintainance,
binary size for most architecture) is bigger.

Link: http://lkml.kernel.org/r/1490773683-10701-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  259 ++++++++++++++++++++++----------
 1 file changed, 186 insertions(+), 73 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-factor-out-partial-io-routine drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-factor-out-partial-io-routine
+++ a/drivers/block/zram/zram_drv.c
@@ -98,10 +98,17 @@ static void zram_set_obj_size(struct zra
 	meta->table[index].value = (flags << ZRAM_FLAG_SHIFT) | size;
 }
 
+#if PAGE_SIZE != 4096
 static inline bool is_partial_io(struct bio_vec *bvec)
 {
 	return bvec->bv_len != PAGE_SIZE;
 }
+#else
+static inline bool is_partial_io(struct bio_vec *bvec)
+{
+	return false;
+}
+#endif
 
 static void zram_revalidate_disk(struct zram *zram)
 {
@@ -544,8 +551,8 @@ static int zram_decompress_page(struct z
 	return 0;
 }
 
-static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-			  u32 index, int offset)
+static int zram_bvec_partial_read(struct zram *zram, struct bio_vec *bvec,
+				u32 index, int offset)
 {
 	int ret;
 	struct page *page;
@@ -562,81 +569,87 @@ static int zram_bvec_read(struct zram *z
 	}
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
-	if (is_partial_io(bvec))
-		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
-
-	user_mem = kmap_atomic(page);
-	if (!is_partial_io(bvec))
-		uncmem = user_mem;
-
+	/* Use  a temporary buffer to decompress the page */
+	uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 	if (!uncmem) {
 		pr_err("Unable to allocate temp memory\n");
-		ret = -ENOMEM;
-		goto out_cleanup;
+		return -ENOMEM;
 	}
 
+	user_mem = kmap_atomic(page);
 	ret = zram_decompress_page(zram, uncmem, index);
-	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret))
 		goto out_cleanup;
 
-	if (is_partial_io(bvec))
-		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
+	memcpy(user_mem + bvec->bv_offset, uncmem + offset,
 				bvec->bv_len);
-
 	flush_dcache_page(page);
 	ret = 0;
 out_cleanup:
 	kunmap_atomic(user_mem);
-	if (is_partial_io(bvec))
-		kfree(uncmem);
+	kfree(uncmem);
 	return ret;
 }
 
-static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
-			   int offset)
+static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
+			  u32 index, int offset)
 {
-	int ret = 0;
+	int ret;
+	struct page *page;
+	unsigned char *user_mem;
+	struct zram_meta *meta = zram->meta;
+	page = bvec->bv_page;
+
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+	if (unlikely(!meta->table[index].handle) ||
+			zram_test_flag(meta, index, ZRAM_SAME)) {
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+		handle_same_page(bvec, meta->table[index].element);
+		return 0;
+	}
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+
+	user_mem = kmap_atomic(page);
+	ret = zram_decompress_page(zram, user_mem, index);
+	kunmap_atomic(user_mem);
+
+	flush_dcache_page(page);
+	return ret;
+}
+
+static int zram_bvec_partial_write(struct zram *zram, struct bio_vec *bvec,
+				u32 index, int offset)
+{
+	int ret = -ENOMEM;
 	unsigned int clen;
 	unsigned long handle = 0;
 	struct page *page;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
-	struct zcomp_strm *zstrm = NULL;
+	struct zcomp_strm *zstrm;
 	unsigned long alloced_pages;
 	unsigned long element;
 
 	page = bvec->bv_page;
-	if (is_partial_io(bvec)) {
-		/*
-		 * This is a partial IO. We need to read the full page
-		 * before to write the changes.
-		 */
-		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
-		if (!uncmem) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		ret = zram_decompress_page(zram, uncmem, index);
-		if (ret)
-			goto out;
-	}
+	/*
+	 * This is a partial IO. We need to read the full page
+	 * before to write the changes.
+	 */
+	uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
+	if (!uncmem)
+		return ret;
+
+	ret = zram_decompress_page(zram, uncmem, index);
+	if (ret)
+		goto out;
 
 compress_again:
 	user_mem = kmap_atomic(page);
-	if (is_partial_io(bvec)) {
-		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
-		       bvec->bv_len);
-		kunmap_atomic(user_mem);
-		user_mem = NULL;
-	} else {
-		uncmem = user_mem;
-	}
+	memcpy(uncmem + offset, user_mem + bvec->bv_offset,
+	       bvec->bv_len);
+	kunmap_atomic(user_mem);
 
 	if (page_same_filled(uncmem, &element)) {
-		if (user_mem)
-			kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
 		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 		zram_free_page(zram, index);
@@ -651,13 +664,8 @@ compress_again:
 
 	zstrm = zcomp_stream_get(zram->comp);
 	ret = zcomp_compress(zstrm, uncmem, &clen);
-	if (!is_partial_io(bvec)) {
-		kunmap_atomic(user_mem);
-		user_mem = NULL;
-		uncmem = NULL;
-	}
-
 	if (unlikely(ret)) {
+		zcomp_stream_put(zram->comp);
 		pr_err("Compression failed! err=%d\n", ret);
 		goto out;
 	}
@@ -665,8 +673,7 @@ compress_again:
 	src = zstrm->buffer;
 	if (unlikely(clen > max_zpage_size)) {
 		clen = PAGE_SIZE;
-		if (is_partial_io(bvec))
-			src = uncmem;
+		src = uncmem;
 	}
 
 	/*
@@ -690,8 +697,6 @@ compress_again:
 				__GFP_MOVABLE);
 	if (!handle) {
 		zcomp_stream_put(zram->comp);
-		zstrm = NULL;
-
 		atomic64_inc(&zram->stats.writestall);
 
 		handle = zs_malloc(meta->mem_pool, clen,
@@ -702,7 +707,6 @@ compress_again:
 
 		pr_err("Error allocating memory for compressed page: %u, size=%u\n",
 			index, clen);
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -711,22 +715,131 @@ compress_again:
 
 	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
 		zs_free(meta->mem_pool, handle);
-		ret = -ENOMEM;
+		zcomp_stream_put(zram->comp);
 		goto out;
 	}
 
 	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
 
-	if ((clen == PAGE_SIZE) && !is_partial_io(bvec)) {
-		src = kmap_atomic(page);
-		copy_page(cmem, src);
-		kunmap_atomic(src);
+	memcpy(cmem, src, clen);
+	zcomp_stream_put(zram->comp);
+	zs_unmap_object(meta->mem_pool, handle);
+
+	/*
+	 * Free memory associated with this sector
+	 * before overwriting unused sectors.
+	 */
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+	zram_free_page(zram, index);
+	meta->table[index].handle = handle;
+	zram_set_obj_size(meta, index, clen);
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+
+	/* Update stats */
+	atomic64_add(clen, &zram->stats.compr_data_size);
+	atomic64_inc(&zram->stats.pages_stored);
+	ret = 0;
+out:
+	kfree(uncmem);
+	return ret;
+}
+
+static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
+			   int offset)
+{
+	int ret;
+	unsigned int clen;
+	unsigned long handle = 0;
+	struct page *page;
+	void *user_mem, *cmem;
+	struct zram_meta *meta = zram->meta;
+	struct zcomp_strm *zstrm;
+	unsigned long alloced_pages;
+	unsigned long element;
+
+	page = bvec->bv_page;
+compress_again:
+	user_mem = kmap_atomic(page);
+	if (page_same_filled(user_mem, &element)) {
+		kunmap_atomic(user_mem);
+
+		/* Free memory associated with this sector now. */
+		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
+		zram_free_page(zram, index);
+		zram_set_flag(meta, index, ZRAM_SAME);
+		zram_set_element(meta, index, element);
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
+
+		atomic64_inc(&zram->stats.same_pages);
+		return 0;
+	}
+
+	zstrm = zcomp_stream_get(zram->comp);
+	ret = zcomp_compress(zstrm, user_mem, &clen);
+	kunmap_atomic(user_mem);
+
+	if (unlikely(ret)) {
+		pr_err("Compression failed! err=%d\n", ret);
+		zcomp_stream_put(zram->comp);
+		return ret;
+	}
+
+	if (unlikely(clen > max_zpage_size))
+		clen = PAGE_SIZE;
+
+	/*
+	 * handle allocation has 2 paths:
+	 * a) fast path is executed with preemption disabled (for
+	 *  per-cpu streams) and has __GFP_DIRECT_RECLAIM bit clear,
+	 *  since we can't sleep;
+	 * b) slow path enables preemption and attempts to allocate
+	 *  the page with __GFP_DIRECT_RECLAIM bit set. we have to
+	 *  put per-cpu compression stream and, thus, to re-do
+	 *  the compression once handle is allocated.
+	 *
+	 * if we have a 'non-null' handle here then we are coming
+	 * from the slow path and handle has already been allocated.
+	 */
+	if (!handle)
+		handle = zs_malloc(meta->mem_pool, clen,
+				__GFP_KSWAPD_RECLAIM |
+				__GFP_NOWARN |
+				__GFP_HIGHMEM |
+				__GFP_MOVABLE);
+	if (!handle) {
+		zcomp_stream_put(zram->comp);
+		atomic64_inc(&zram->stats.writestall);
+		handle = zs_malloc(meta->mem_pool, clen,
+				GFP_NOIO | __GFP_HIGHMEM |
+				__GFP_MOVABLE);
+		if (handle)
+			goto compress_again;
+
+		pr_err("Error allocating memory for compressed page: %u, size=%u\n",
+			index, clen);
+		return -ENOMEM;
+	}
+
+	alloced_pages = zs_get_total_pages(meta->mem_pool);
+	update_used_max(zram, alloced_pages);
+
+	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
+		zs_free(meta->mem_pool, handle);
+		zcomp_stream_put(zram->comp);
+		return -ENOMEM;
+	}
+
+	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
+
+	if (clen == PAGE_SIZE) {
+		user_mem = kmap_atomic(page);
+		copy_page(cmem, user_mem);
+		kunmap_atomic(user_mem);
 	} else {
-		memcpy(cmem, src, clen);
+		memcpy(cmem, zstrm->buffer, clen);
 	}
 
 	zcomp_stream_put(zram->comp);
-	zstrm = NULL;
 	zs_unmap_object(meta->mem_pool, handle);
 
 	/*
@@ -735,7 +848,6 @@ compress_again:
 	 */
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	zram_free_page(zram, index);
-
 	meta->table[index].handle = handle;
 	zram_set_obj_size(meta, index, clen);
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
@@ -743,12 +855,7 @@ compress_again:
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_data_size);
 	atomic64_inc(&zram->stats.pages_stored);
-out:
-	if (zstrm)
-		zcomp_stream_put(zram->comp);
-	if (is_partial_io(bvec))
-		kfree(uncmem);
-	return ret;
+	return 0;
 }
 
 /*
@@ -802,10 +909,16 @@ static int zram_bvec_rw(struct zram *zra
 
 	if (!is_write) {
 		atomic64_inc(&zram->stats.num_reads);
-		ret = zram_bvec_read(zram, bvec, index, offset);
+		if (!is_partial_io(bvec))
+			ret = zram_bvec_read(zram, bvec, index, offset);
+		else
+			ret = zram_bvec_partial_read(zram, bvec, index, offset);
 	} else {
 		atomic64_inc(&zram->stats.num_writes);
-		ret = zram_bvec_write(zram, bvec, index, offset);
+		if (!is_partial_io(bvec))
+			ret = zram_bvec_write(zram, bvec, index, offset);
+		else
+			ret = zram_bvec_partial_write(zram, bvec, index, offset);
 	}
 
 	generic_end_io_acct(rw_acct, &zram->disk->part0, start_time);
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
zram-factor-out-partial-io-routine.patch

