Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE06757EA
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878518; cv=none; b=qRpnPY04Ccc60gfyRJK7KbUcEPqrFHtI9qEXPDpUVkUvMUi/8cQXQ+VFF1sxSOscaHsmSiadbXc8cjts1CY7Opg9IN1+Fga7ba6j6QYZVlV9nXNJi/n4lLydBd6t0ewrKMyw/rXNt/sXdvwyecn+mKnrNQ12d+/Wr3mv6+0P0oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878518; c=relaxed/simple;
	bh=Wl5OVLTvNGekxrZkwy792JK+AsOe0FH4AZr0DgVu2Vs=;
	h=Date:To:From:Subject:Message-Id; b=H4TM9dguEUiTj59Yih9H7XLBJ4JpJnHonwN1eO0E6NGsyS4Bf2DGyTl2UJwq2sZHbgtT2uGLnhL1SVHBDnax6aeE5CVDR43s2mawl9gR88tOrX7RYoZg+Kog/yY0FWbse29Rjs5RcE0A8CVezrdoKFwxtaAL4PhifnVQnTErwcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HabylV5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HabylV5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2EDC4CEE0;
	Wed, 11 Dec 2024 00:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733878518;
	bh=Wl5OVLTvNGekxrZkwy792JK+AsOe0FH4AZr0DgVu2Vs=;
	h=Date:To:From:Subject:From;
	b=HabylV5ddR3DjJoda+yOv+vGOVIF7Uv89O0YixB/e9En8fFUtNwrkI/mI8MG48q1m
	 43DzSaXCNuKcjQb+zuIQ2aDb9IxgZOd9hKBqFZd/FOVfZ+MkwgTNHyVbiso/OcgF8f
	 kA6cBuzOjrI+T7LSxz5BXhExg1nACfcK3Oni7qW4=
Date: Tue, 10 Dec 2024 16:55:18 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-factor-out-zram_huge-write.patch added to mm-unstable branch
Message-Id: <20241211005518.9C2EDC4CEE0@smtp.kernel.org>
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
Date: Tue, 10 Dec 2024 19:53:59 +0900

zram_write_page() handles: ZRAM_SAME pages (which was already factored
out) stores, regular page stores and ZRAM_HUGE pages stores.

ZRAM_HUGE handling adds a significant amount of complexity.  Instead, we
can handle ZRAM_HUGE in a separate function.  This allows us to simplify
zs_handle allocations slow-path, as it now does not handle ZRAM_HUGE case.
ZRAM_HUGE zs_handle allocation, on the other hand, can now drop
__GFP_KSWAPD_RECLAIM because we handle ZRAM_HUGE in preemptible context
(outside of local-lock scope).

Link: https://lkml.kernel.org/r/20241210105420.1888790-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  139 +++++++++++++++++++-------------
 1 file changed, 83 insertions(+), 56 deletions(-)

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
@@ -1640,14 +1649,55 @@ static int write_same_filled_page(struct
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
 	unsigned int last_comp_len = 0;
-	void *src, *dst, *mem;
+	void *dst, *mem;
 	struct zcomp_strm *zstrm;
 	unsigned long element = 0;
 	bool same_filled;
@@ -1665,10 +1715,10 @@ static int zram_write_page(struct zram *
 
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
@@ -1677,13 +1727,16 @@ compress_again:
 		return ret;
 	}
 
-	if (comp_len >= huge_class_size)
-		comp_len = PAGE_SIZE;
-
 	if (last_comp_len && (last_comp_len != comp_len)) {
 		zs_free(zram->mem_pool, handle);
 		handle = -ENOMEM;
 	}
+
+	if (comp_len >= huge_class_size) {
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		return write_incompressible_page(zram, page, index);
+	}
+
 	/*
 	 * handle allocation has 2 paths:
 	 * a) fast path is executed with preemption disabled (for
@@ -1699,37 +1752,22 @@ compress_again:
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
+				   GFP_NOIO | __GFP_HIGHMEM | __GFP_MOVABLE);
 		if (IS_ERR_VALUE(handle))
 			return PTR_ERR((void *)handle);
 
-		if (comp_len != PAGE_SIZE) {
-			last_comp_len = comp_len;
-			goto compress_again;
-		}
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
@@ -1737,30 +1775,19 @@ compress_again:
 
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

zram-panic-when-use-ext4-over-zram-fix.patch
zram-cond_resched-in-writeback-loop.patch
zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch

