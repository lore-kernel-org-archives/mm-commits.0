Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C848E286405
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 04:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767674451; cv=none; b=JRIs5pv0ouZme1gIwGm+m+3R/N4Wa7qWsQkxYuLeWeJq7EeNnI22AfgUPOQLoQnfGxsZYNJaZN1jum//n9kZg9eUJ3qTv6JbecngrlkM+HjSzHz2uVSHHvUYsiRm3XQHNKLtS531bk4tdVhBb+BSkJsJVw9Tn7Xdt9SMLbGxHiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767674451; c=relaxed/simple;
	bh=RLDbJZYj8m53KXEjNuV6Y3mV9oXCQQBpgH5/DXJem9Q=;
	h=Date:To:From:Subject:Message-Id; b=BMmJhCPSzZQxQPweyEiKehA4M+3Sa3fAVL5q/ENpcj7I84OsMC9Qaye6p6of4UY5+jjJmzM3TLgx1DdH2kFW5kX4SaqdkGJfL+DZjZKEZOM7NEu6Iq98kRPvV8Qi/b3vMf5BUbFZ1+vy5/zZGxtu8P/cDEsh6NB07aocCQHYDtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QBxcJyFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QBxcJyFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADE3C116C6;
	Tue,  6 Jan 2026 04:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767674451;
	bh=RLDbJZYj8m53KXEjNuV6Y3mV9oXCQQBpgH5/DXJem9Q=;
	h=Date:To:From:Subject:From;
	b=QBxcJyFjXpsL9FEk1oz5XlYdqk+V6jf8QI86BTbb9ohO4vd9MSYNWC4mOVYjB6fIA
	 YKqTKUvmCJFL5diXlkY4apE6Ev8gnOEWQeSwudLEDJi29lvGtl/IEJxMx6hVZt0wfx
	 attTO8xDVnyGqPcCa/89QJk88s2Tmrh22n57ox7E=
Date: Mon, 05 Jan 2026 20:40:50 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-use-actual-object-size-to-detect-spans.patch added to mm-new branch
Message-Id: <20260106044051.4ADE3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: use actual object size to detect spans
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-use-actual-object-size-to-detect-spans.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-use-actual-object-size-to-detect-spans.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: use actual object size to detect spans
Date: Tue, 6 Jan 2026 13:25:07 +0900

Using class->size to detect spanning objects is not entirely correct,
because some size classes can hold a range of object sizes of up to
class->size bytes in length, due to size-classes merge.  Such classes use
padding for cases when actually written objects are smaller than
class->size.  zs_obj_read_begin() can incorrectly hit the slow path and
perform memcpy of such objects, basically copying padding bytes.  Instead
of class->size zs_obj_read_begin() should use the actual compressed object
length (both zram and zswap know it) so that it can correctly handle
situations when a written object is small enough to fit into the first
physical page.

Link: https://lkml.kernel.org/r/20260106042507.2579150-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   14 ++++++++------
 include/linux/zsmalloc.h      |    4 ++--
 mm/zsmalloc.c                 |   16 ++++++++++++----
 mm/zswap.c                    |    5 +++--
 4 files changed, 25 insertions(+), 14 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zsmalloc-use-actual-object-size-to-detect-spans
+++ a/drivers/block/zram/zram_drv.c
@@ -2065,11 +2065,11 @@ static int read_incompressible_page(stru
 	void *src, *dst;
 
 	handle = get_slot_handle(zram, index);
-	src = zs_obj_read_begin(zram->mem_pool, handle, NULL);
+	src = zs_obj_read_begin(zram->mem_pool, handle, PAGE_SIZE, NULL);
 	dst = kmap_local_page(page);
 	copy_page(dst, src);
 	kunmap_local(dst);
-	zs_obj_read_end(zram->mem_pool, handle, src);
+	zs_obj_read_end(zram->mem_pool, handle, PAGE_SIZE, src);
 
 	return 0;
 }
@@ -2087,11 +2087,12 @@ static int read_compressed_page(struct z
 	prio = get_slot_comp_priority(zram, index);
 
 	zstrm = zcomp_stream_get(zram->comps[prio]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
+	src = zs_obj_read_begin(zram->mem_pool, handle, size,
+				zstrm->local_copy);
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
 	kunmap_local(dst);
-	zs_obj_read_end(zram->mem_pool, handle, src);
+	zs_obj_read_end(zram->mem_pool, handle, size, src);
 	zcomp_stream_put(zstrm);
 
 	return ret;
@@ -2114,9 +2115,10 @@ static int read_from_zspool_raw(struct z
 	 * takes place here, as we read raw compressed data.
 	 */
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
+	src = zs_obj_read_begin(zram->mem_pool, handle, size,
+				zstrm->local_copy);
 	memcpy_to_page(page, 0, src, size);
-	zs_obj_read_end(zram->mem_pool, handle, src);
+	zs_obj_read_end(zram->mem_pool, handle, size, src);
 	zcomp_stream_put(zstrm);
 
 	return 0;
--- a/include/linux/zsmalloc.h~zsmalloc-use-actual-object-size-to-detect-spans
+++ a/include/linux/zsmalloc.h
@@ -40,9 +40,9 @@ unsigned int zs_lookup_class_index(struc
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 
 void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			void *local_copy);
+			size_t mem_len, void *local_copy);
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
-		     void *handle_mem);
+		     size_t mem_len, void *handle_mem);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len);
 
--- a/mm/zsmalloc.c~zsmalloc-use-actual-object-size-to-detect-spans
+++ a/mm/zsmalloc.c
@@ -1065,7 +1065,7 @@ unsigned long zs_get_total_pages(struct
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
 void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			void *local_copy)
+			size_t mem_len, void *local_copy)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1087,7 +1087,11 @@ void *zs_obj_read_begin(struct zs_pool *
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	/* Normal classes have inlined handle */
+	if (!ZsHugePage(zspage))
+		mem_len += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		addr = kmap_local_zpdesc(zpdesc);
 		addr += off;
@@ -1115,7 +1119,7 @@ void *zs_obj_read_begin(struct zs_pool *
 EXPORT_SYMBOL_GPL(zs_obj_read_begin);
 
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
-		     void *handle_mem)
+		     size_t mem_len, void *handle_mem)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1129,7 +1133,11 @@ void zs_obj_read_end(struct zs_pool *poo
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	/* Normal classes have inlined handle */
+	if (!ZsHugePage(zspage))
+		mem_len += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
 		if (!ZsHugePage(zspage))
 			off += ZS_HANDLE_SIZE;
 		handle_mem -= off;
--- a/mm/zswap.c~zsmalloc-use-actual-object-size-to-detect-spans
+++ a/mm/zswap.c
@@ -937,7 +937,8 @@ static bool zswap_decompress(struct zswa
 	u8 *src, *obj;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
-	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
+	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, entry->length,
+				acomp_ctx->buffer);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
@@ -966,7 +967,7 @@ static bool zswap_decompress(struct zswa
 	dlen = acomp_ctx->req->dlen;
 
 read_done:
-	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
+	zs_obj_read_end(pool->zs_pool, entry->handle, entry->length, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
 	if (!decomp_ret && dlen == PAGE_SIZE)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch
zram-use-u32-for-entry-ac_time-tracking.patch
zram-rename-internal-slot-api.patch
zram-trivial-fix-of-recompress_slot-coding-styles.patch
zram-drop-pp_in_progress.patch
zsmalloc-use-actual-object-size-to-detect-spans.patch

