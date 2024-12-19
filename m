Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D09D171D2
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734569875; cv=none; b=IjnXzp95u+dQvDjdGg+DopFwJ7WHYL5qIvYGmBrDUWUmWgzjm1v/iVTmBS42rfMTcr4YyWZKrQHmRCVBPyHVU4u5bZK8sEljLAvQ1hbQcN5A6ganAQxCMiajcSVT55MSN+Ko9P+EQEQ2ciXJLAGzlw/E5ymKfVX1fO8BB+sGXkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734569875; c=relaxed/simple;
	bh=yt1BYUCnhGwoNBPdv0y7vOvKNYBNDusqq/xrVoZUULo=;
	h=Date:To:From:Subject:Message-Id; b=tr2+sP61seKOdjJ1Z0rv3LfwAVv7W0cF6aIgc05ub9iNHr5yd2tGO0xV09S1Ev/XIA3OHxli5Cz4G3rkvNbLsTxTbYmSvTZ4mMt+eQ+xGlaw14x7Rn6KYXzk02sKKWF5Cn8flLh6zOW/c/WxUJ9CC+s7G0430Znt1ZryRGFrQkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=de6qKwcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="de6qKwcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9FDC4CECD;
	Thu, 19 Dec 2024 00:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734569874;
	bh=yt1BYUCnhGwoNBPdv0y7vOvKNYBNDusqq/xrVoZUULo=;
	h=Date:To:From:Subject:From;
	b=de6qKwcKw1qGLkNnyIDpCFG+Jckq6euG9aGC85tJR4YNZaFB425XTGpp1VWL5Cn5X
	 ptsX4qTdxoGKoNly+FcFM0D0Ullq7rlL6+SZJO6fMJ4G11RdD18RC9w9SFt4DlsCT9
	 jhlwY0zWTfIrEpucB4+ruqDpWz5ld01eG3A6kcO0=
Date: Wed, 18 Dec 2024 16:57:54 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-factor-out-zram_huge-write.patch added to mm-unstable branch
Message-Id: <20241219005754.8D9FDC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: factor out ZRAM_HUGE write
has been added to the -mm mm-unstable branch.  Its filename is
     zram-factor-out-zram_huge-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-factor-out-zram_huge-write.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: factor out ZRAM_HUGE write
Date: Wed, 18 Dec 2024 15:34:21 +0900

zram_write_page() handles: ZRAM_SAME pages (which was already factored
out) stores, regular page stores and ZRAM_HUGE pages stores.

ZRAM_HUGE handling adds a significant amount of complexity.  Instead, we
can handle ZRAM_HUGE in a separate function.  This allows us to simplify
zs_handle allocations slow-path, as it now does not handle ZRAM_HUGE case.
ZRAM_HUGE zs_handle allocation, on the other hand, can now drop
__GFP_KSWAPD_RECLAIM because we handle ZRAM_HUGE in preemptible context
(outside of local-lock scope).

Link: https://lkml.kernel.org/r/20241218063513.297475-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  136 +++++++++++++++++++-------------
 1 file changed, 83 insertions(+), 53 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-factor-out-zram_huge-write
+++ a/drivers/block/zram/zram_drv.c
@@ -132,6 +132,27 @@ static inline bool zram_allocated(struct
 			zram_test_flag(zram, index, ZRAM_WB);
 }
 
+static inline void update_used_max(struct zram *zram, const unsigned long pages)
+{
+	unsigned long cur_max = atomic_long_read(&zram->stats.max_used_pages);
+
+	do {
+		if (cur_max >= pages)
+			return;
+	} while (!atomic_long_try_cmpxchg(&zram->stats.max_used_pages,
+					  &cur_max, pages));
+}
+
+static bool zram_can_store_page(struct zram *zram)
+{
+	unsigned long alloced_pages;
+
+	alloced_pages = zs_get_total_pages(zram->mem_pool);
+	update_used_max(zram, alloced_pages);
+
+	return !zram->limit_pages || alloced_pages <= zram->limit_pages;
+}
+
 #if PAGE_SIZE != 4096
 static inline bool is_partial_io(struct bio_vec *bvec)
 {
@@ -266,18 +287,6 @@ static struct zram_pp_slot *select_pp_sl
 }
 #endif
 
-static inline void update_used_max(struct zram *zram,
-					const unsigned long pages)
-{
-	unsigned long cur_max = atomic_long_read(&zram->stats.max_used_pages);
-
-	do {
-		if (cur_max >= pages)
-			return;
-	} while (!atomic_long_try_cmpxchg(&zram->stats.max_used_pages,
-					  &cur_max, pages));
-}
-
 static inline void zram_fill_page(void *ptr, unsigned long len,
 					unsigned long value)
 {
@@ -1638,13 +1647,54 @@ static int write_same_filled_page(struct
 	return 0;
 }
 
+static int write_incompressible_page(struct zram *zram, struct page *page,
+				     u32 index)
+{
+	unsigned long handle;
+	void *src, *dst;
+
+	/*
+	 * This function is called from preemptible context so we don't need
+	 * to do optimistic and fallback to pessimistic handle allocation,
+	 * like we do for compressible pages.
+	 */
+	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
+			   GFP_NOIO | __GFP_HIGHMEM | __GFP_MOVABLE);
+	if (IS_ERR_VALUE(handle))
+		return PTR_ERR((void *)handle);
+
+	if (!zram_can_store_page(zram)) {
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		zs_free(zram->mem_pool, handle);
+		return -ENOMEM;
+	}
+
+	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
+	src = kmap_local_page(page);
+	memcpy(dst, src, PAGE_SIZE);
+	kunmap_local(src);
+	zs_unmap_object(zram->mem_pool, handle);
+
+	zram_slot_lock(zram, index);
+	zram_set_flag(zram, index, ZRAM_HUGE);
+	zram_set_handle(zram, index, handle);
+	zram_set_obj_size(zram, index, PAGE_SIZE);
+	zram_slot_unlock(zram, index);
+
+	atomic64_add(PAGE_SIZE, &zram->stats.compr_data_size);
+	atomic64_inc(&zram->stats.huge_pages);
+	atomic64_inc(&zram->stats.huge_pages_since);
+	atomic64_inc(&zram->stats.pages_stored);
+
+	return 0;
+}
+
 static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 {
 	int ret = 0;
-	unsigned long alloced_pages;
 	unsigned long handle = -ENOMEM;
 	unsigned int comp_len = 0;
-	void *src, *dst, *mem;
+	void *dst, *mem;
 	struct zcomp_strm *zstrm;
 	unsigned long element = 0;
 	bool same_filled;
@@ -1662,10 +1712,10 @@ static int zram_write_page(struct zram *
 
 compress_again:
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
-	src = kmap_local_page(page);
+	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
-			     src, &comp_len);
-	kunmap_local(src);
+			     mem, &comp_len);
+	kunmap_local(mem);
 
 	if (unlikely(ret)) {
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
@@ -1674,8 +1724,11 @@ compress_again:
 		return ret;
 	}
 
-	if (comp_len >= huge_class_size)
-		comp_len = PAGE_SIZE;
+	if (comp_len >= huge_class_size) {
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		return write_incompressible_page(zram, page, index);
+	}
+
 	/*
 	 * handle allocation has 2 paths:
 	 * a) fast path is executed with preemption disabled (for
@@ -1691,35 +1744,23 @@ compress_again:
 	 */
 	if (IS_ERR_VALUE(handle))
 		handle = zs_malloc(zram->mem_pool, comp_len,
-				__GFP_KSWAPD_RECLAIM |
-				__GFP_NOWARN |
-				__GFP_HIGHMEM |
-				__GFP_MOVABLE);
+				   __GFP_KSWAPD_RECLAIM |
+				   __GFP_NOWARN |
+				   __GFP_HIGHMEM |
+				   __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle)) {
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 		atomic64_inc(&zram->stats.writestall);
 		handle = zs_malloc(zram->mem_pool, comp_len,
-				GFP_NOIO | __GFP_HIGHMEM |
-				__GFP_MOVABLE);
+				   GFP_NOIO | __GFP_HIGHMEM |
+				   __GFP_MOVABLE);
 		if (IS_ERR_VALUE(handle))
 			return PTR_ERR((void *)handle);
 
-		if (comp_len != PAGE_SIZE)
-			goto compress_again;
-		/*
-		 * If the page is not compressible, you need to acquire the
-		 * lock and execute the code below. The zcomp_stream_get()
-		 * call is needed to disable the cpu hotplug and grab the
-		 * zstrm buffer back. It is necessary that the dereferencing
-		 * of the zstrm variable below occurs correctly.
-		 */
-		zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
+		goto compress_again;
 	}
 
-	alloced_pages = zs_get_total_pages(zram->mem_pool);
-	update_used_max(zram, alloced_pages);
-
-	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
+	if (!zram_can_store_page(zram)) {
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
@@ -1727,30 +1768,19 @@ compress_again:
 
 	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
 
-	src = zstrm->buffer;
-	if (comp_len == PAGE_SIZE)
-		src = kmap_local_page(page);
-	memcpy(dst, src, comp_len);
-	if (comp_len == PAGE_SIZE)
-		kunmap_local(src);
-
+	memcpy(dst, zstrm->buffer, comp_len);
 	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 	zs_unmap_object(zram->mem_pool, handle);
-	atomic64_add(comp_len, &zram->stats.compr_data_size);
 
 	zram_slot_lock(zram, index);
-	if (comp_len == PAGE_SIZE) {
-		zram_set_flag(zram, index, ZRAM_HUGE);
-		atomic64_inc(&zram->stats.huge_pages);
-		atomic64_inc(&zram->stats.huge_pages_since);
-	}
-
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
 
 	/* Update stats */
 	atomic64_inc(&zram->stats.pages_stored);
+	atomic64_add(comp_len, &zram->stats.compr_data_size);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch
zram-use-zram_read_from_zspool-in-writeback.patch
zram-cond_resched-in-writeback-loop.patch

