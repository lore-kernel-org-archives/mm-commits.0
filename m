Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450655;
	b=IBXPSWmlxbq2urVE/1pllAARnJZmo9nGDh9EeIo1fbnxTW8fgsd5uuQbib2m8g3cpYKF
	 9sX2y5a8mR6YDzLIBQK1KeKdypFRU36nH1rXp5zjdJOYmDfmVvVQNHY/ymIlj6lIInRp6
	 45W6FCcVazJMBCTQ1xe6aHpe8iArhi4pJk3gr3GIzVzmMzs5eDnFnWQA554XWw3svcKGe
	 8mNDDHT7haqZiDC4XzKJhIIgnuTAS+RNI4fYn2WBgP5SPIKLbLNr4yR9dbrgvH75Y39pI
	 Lmu2EqcSsYqdFZaH1IrzCFyHDVirMatAPXeCnWzC4C7VQ+q3UGB1r77PeH7yb9I9bmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450655;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QCWKeL8+1zzEPiXWfhMLf0eCXrVl3B/AciDi0C9km5s=;
	b=2onCpxJOTmYd4LG3CMyn3SXeMHR+21Rz2NJKxcq8dY+8FwxAScbQunWRzbJdRbPxTwfK
	 O2MDbXOMPo/QBQ0yq1E0kqhj0qw+zUIi4YmZDodxK/gM/nYwa02FOA5B5svzAhig1Kqy+
	 4k7Z+ep0RpIBblIii0dRTpuBlWh/Gdnmz1b3TOIWaHjmPf8cM0cbEzfPWazhfYXG376Sn
	 +LLUWMX/BkMTqDOuTbrXnSHx1SxLYuAXZBpwWOx+o1P3qE4E5p/aJr194c2AfH+AgT5/o
	 Yx9wFJnhLqGbLbSncmCHiigP9AwJEDnwPSa8Kjy4S4IQ4uGx1wKL1Ss4UFe69uAynfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IpLW7MZy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255DB606A33F
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 02:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IpLW7MZy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39AA1F00A07;
	Thu, 12 Nov 2026 02:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450654;
	bh=QCWKeL8+1zzEPiXWfhMLf0eCXrVl3B/AciDi0C9km5s=;
	h=Date:To:From:Subject;
	b=IpLW7MZydNU6JfmzhWxiRMHyM0Nnb2r8rtO/C2yNXSOPfMEsm8R8HjtElWhp5sM7U
	 xtZ7DqT27YAQQUvnvuW4nqyzIt34QrYVZBpsYXCs7OtoraNJbts6XSjVtaL0/ZcUfk
	 n5RmAUja41JwSgeTY3D4QfAUWZYCfB2RC6iHbhjc=
Date: Wed, 11 Nov 2026 18:30:54 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,richardycc@google.com,
	nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,
	senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-fold-zs_obj_write-into-zs_store.patch added to mm-unstable branch
Message-Id: <20261112023054.A39AA1F00A07@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zsmalloc: fold zs_obj_write() into zs_store()
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-fold-zs_obj_write-into-zs_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-fold-zs_obj_write-into-zs_store.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: zsmalloc: fold zs_obj_write() into zs_store()
Date: Wed, 11 Nov 2026 15:46:33 +0900

zram and zswap always call zs_obj_write() right after zs_malloc(), and
zs_obj_write() has to take pool->lock and look up object location again,
which zs_malloc() just did.

Replace zs_malloc() and zs_obj_write() with one single zs_store()
call.

zs_store() takes zspage read lock under class->lock, before it drops
class->lock to copy the data, while zs_obj_write() used to take it under
pool->lock.  Compaction and page migration already take zspage lock under
class->lock, so this follows the existing pool->lock -> class->lock ->
zspage->lock order.  We don't need pool->lock there, zs_store() doesn't
look up the object via the handle, it already has the zspage from the
allocation.

Link: https://lore.kernel.org/20261111064707.2568433-11-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
---

 Documentation/core-api/memory-allocation.rst |    2 
 Documentation/mm/zsmalloc.rst                |    4 -
 drivers/block/zram/zram_drv.c                |   42 ++++--------
 include/linux/zsmalloc.h                     |    6 -
 mm/zsmalloc.c                                |   58 +++++++----------
 mm/zswap.c                                   |    5 -
 6 files changed, 47 insertions(+), 70 deletions(-)

--- a/Documentation/core-api/memory-allocation.rst~zsmalloc-fold-zs_obj_write-into-zs_store
+++ a/Documentation/core-api/memory-allocation.rst
@@ -9,7 +9,7 @@ allocate small chunks using `kmalloc` or
 large virtually contiguous areas using `vmalloc` and its derivatives,
 or you can directly request pages from the page allocator with
 `alloc_pages`. It is also possible to use more specialized allocators,
-for instance `cma_alloc` or `zs_malloc`.
+for instance `cma_alloc` or `zs_store`.
 
 Most of the memory allocation APIs use GFP flags to express how that
 memory should be allocated. The GFP acronym stands for "get free
--- a/Documentation/mm/zsmalloc.rst~zsmalloc-fold-zs_obj_write-into-zs_store
+++ a/Documentation/mm/zsmalloc.rst
@@ -20,9 +20,9 @@ For simplicity, zsmalloc can only alloca
 since this satisfies the requirements of all its current users (in the
 worst case, page is incompressible and is thus stored "as-is" i.e. in
 uncompressed form). For allocation requests larger than this size, failure
-is returned (see zs_malloc).
+is returned (see zs_store).
 
-Additionally, zs_malloc() does not return a pointer; instead, it returns 0
+Additionally, zs_store() does not return a pointer; instead, it returns 0
 (or a negative error code) and stores the encoded location of the allocated
 object in the caller-provided ``struct zs_handle``. The reason for this
 indirection is that zsmalloc does not keep zspages permanently mapped since
--- a/drivers/block/zram/zram_drv.c~zsmalloc-fold-zs_obj_write-into-zs_store
+++ a/drivers/block/zram/zram_drv.c
@@ -2252,9 +2252,11 @@ static int write_incompressible_page(str
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-	ret = zs_malloc(zram->mem_pool, &zram->table[index].handle, PAGE_SIZE,
-			GFP_NOIO | __GFP_NOWARN |
-			__GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	src = kmap_local_page(page);
+	ret = zs_store(zram->mem_pool, &zram->table[index].handle, src,
+		       PAGE_SIZE, GFP_NOIO | __GFP_NOWARN |
+		       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	kunmap_local(src);
 	if (ret) {
 		slot_unlock(zram, index);
 		return ret;
@@ -2262,11 +2264,6 @@ static int write_incompressible_page(str
 
 	update_used_max(zram);
 
-	src = kmap_local_page(page);
-	zs_obj_write(zram->mem_pool, &zram->table[index].handle, src,
-		     PAGE_SIZE);
-	kunmap_local(src);
-
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	set_slot_size(zram, index, PAGE_SIZE);
 	mark_slot_accessed(zram, index);
@@ -2318,21 +2315,18 @@ static int zram_write_page(struct zram *
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-	ret = zs_malloc(zram->mem_pool, &zram->table[index].handle, comp_len,
-			GFP_NOIO | __GFP_NOWARN |
-			__GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	ret = zs_store(zram->mem_pool, &zram->table[index].handle,
+		       zstrm->buffer, comp_len,
+		       GFP_NOIO | __GFP_NOWARN |
+		       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	zcomp_cstrm_put(zstrm);
 	if (ret) {
-		zcomp_cstrm_put(zstrm);
 		slot_unlock(zram, index);
 		return ret;
 	}
 
 	update_used_max(zram);
 
-	zs_obj_write(zram->mem_pool, &zram->table[index].handle, zstrm->buffer,
-		     comp_len);
-	zcomp_cstrm_put(zstrm);
-
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2517,18 +2511,12 @@ static int recompress_slot(struct zram *
 	 * modify zsmalloc API to return this information. For now, we will
 	 * make do with the node of the page allocated for recompression.
 	 */
-	ret = zs_malloc(zram->mem_pool, &zram->recomp_handle, comp_len_new,
-			GFP_NOIO | __GFP_NOWARN |
-			__GFP_HIGHMEM | __GFP_MOVABLE,
-			page_to_nid(page));
-	if (ret) {
-		zcomp_cstrm_put(zstrm);
-		return ret;
-	}
-
-	zs_obj_write(zram->mem_pool, &zram->recomp_handle, zstrm->buffer,
-		     comp_len_new);
+	ret = zs_store(zram->mem_pool, &zram->recomp_handle, zstrm->buffer,
+		       comp_len_new, GFP_NOIO | __GFP_NOWARN |
+		       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
 	zcomp_cstrm_put(zstrm);
+	if (ret)
+		return ret;
 
 	slot_free(zram, index);
 	zs_rebind_handle(zram->mem_pool, &zram->table[index].handle,
--- a/include/linux/zsmalloc.h~zsmalloc-fold-zs_obj_write-into-zs_store
+++ a/include/linux/zsmalloc.h
@@ -49,8 +49,8 @@ struct scatterlist;
 struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
 
-int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
-	      gfp_t flags, const int nid);
+int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
+	     size_t size, gfp_t flags, const int nid);
 void zs_free(struct zs_pool *pool, struct zs_handle *handle);
 void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
 		      struct zs_handle *src);
@@ -67,8 +67,6 @@ void zs_pool_stats(struct zs_pool *pool,
 void zs_obj_read_sg_begin(struct zs_pool *pool, const struct zs_handle *handle,
 			  struct scatterlist *sg, size_t mem_len);
 void zs_obj_read_sg_end(struct zs_pool *pool, const struct zs_handle *handle);
-void zs_obj_write(struct zs_pool *pool, const struct zs_handle *handle,
-		  void *handle_mem, size_t mem_len);
 
 extern const struct movable_operations zsmalloc_mops;
 
--- a/mm/zsmalloc.c~zsmalloc-fold-zs_obj_write-into-zs_store
+++ a/mm/zsmalloc.c
@@ -1185,54 +1185,37 @@ void zs_obj_read_sg_end(struct zs_pool *
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
 
-void zs_obj_write(struct zs_pool *pool, const struct zs_handle *handle,
-		  void *handle_mem, size_t mem_len)
+static void obj_write(struct size_class *class, struct zspage *zspage,
+		      unsigned long obj, const void *src, size_t size)
 {
-	struct zspage *zspage;
 	struct zpdesc *zpdesc;
-	unsigned long obj, off;
+	unsigned long off;
 	unsigned int obj_idx;
-	struct size_class *class;
 
-	/* Guarantee we can get zspage from handle safely */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
 	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-
-	/* Make sure migration doesn't move any pages in this zspage */
-	zspage_read_lock(zspage);
-	read_unlock(&pool->lock);
-
-	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
 	if (!ZsHugePage(zspage))
 		off += ZS_HANDLE_SIZE;
 
-	if (off + mem_len <= PAGE_SIZE) {
+	if (off + size <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		void *dst = kmap_local_zpdesc(zpdesc);
 
-		memcpy(dst + off, handle_mem, mem_len);
+		memcpy(dst + off, src, size);
 		kunmap_local(dst);
 	} else {
 		/* this object spans two pages */
 		size_t sizes[2];
 
 		sizes[0] = PAGE_SIZE - off;
-		sizes[1] = mem_len - sizes[0];
+		sizes[1] = size - sizes[0];
 
-		memcpy_to_page(zpdesc_page(zpdesc), off,
-			       handle_mem, sizes[0]);
+		memcpy_to_page(zpdesc_page(zpdesc), off, src, sizes[0]);
 		zpdesc = get_next_zpdesc(zpdesc);
-		memcpy_to_page(zpdesc_page(zpdesc), 0,
-			       handle_mem + sizes[0], sizes[1]);
+		memcpy_to_page(zpdesc_page(zpdesc), 0, src + sizes[0], sizes[1]);
 	}
-
-	zspage_read_unlock(zspage);
 }
-EXPORT_SYMBOL_GPL(zs_obj_write);
 
 /**
  * zs_huge_class_size() - Returns the size (in bytes) of the first huge
@@ -1297,9 +1280,10 @@ static unsigned long obj_malloc(struct z
 
 
 /**
- * zs_malloc - Allocate block of given size from pool.
+ * zs_store() - Allocate block of given size from pool and copy data into it.
  * @pool: pool to allocate from
  * @handle: handle to store allocated object in
+ * @src: data to copy into the allocated object
  * @size: size of block to allocate
  * @gfp: gfp flags when allocating object
  * @nid: The preferred node id to allocate new zspage (if needed)
@@ -1312,10 +1296,11 @@ static unsigned long obj_malloc(struct z
  *
  * Return: 0 on success, negative error code otherwise.
  */
-int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
-	      gfp_t gfp, const int nid)
+int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
+	     size_t size, gfp_t gfp, const int nid)
 {
 	struct size_class *class;
+	unsigned long obj;
 	int newfg;
 	struct zspage *zspage;
 
@@ -1334,7 +1319,7 @@ int zs_malloc(struct zs_pool *pool, stru
 	spin_lock(&class->lock);
 	zspage = find_get_zspage(class);
 	if (likely(zspage)) {
-		obj_malloc(pool, zspage, handle);
+		obj = obj_malloc(pool, zspage, handle);
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
 		class_stat_add(class, ZS_OBJS_INUSE, 1);
@@ -1349,7 +1334,7 @@ int zs_malloc(struct zs_pool *pool, stru
 		return -ENOMEM;
 
 	spin_lock(&class->lock);
-	obj_malloc(pool, zspage, handle);
+	obj = obj_malloc(pool, zspage, handle);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
@@ -1359,11 +1344,15 @@ int zs_malloc(struct zs_pool *pool, stru
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
 out:
+	zspage_read_lock(zspage);
 	spin_unlock(&class->lock);
 
+	obj_write(class, zspage, obj, src, size);
+	zspage_read_unlock(zspage);
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(zs_malloc);
+EXPORT_SYMBOL_GPL(zs_store);
 
 static void obj_free(int class_size, unsigned long obj)
 {
@@ -1845,7 +1834,10 @@ static int zs_page_migrate(struct page *
 	 * the class lock protects zpage alloc/free in the zspage.
 	 */
 	spin_lock(&class->lock);
-	/* the zspage write_lock protects zpage access via zs_obj_read/write() */
+	/*
+	 * The zspage write_lock protects zpage access via zs_obj_read_sg_*()
+	 * and zs_store().
+	 */
 	if (!zspage_write_trylock(zspage)) {
 		spin_unlock(&class->lock);
 		write_unlock(&pool->lock);
@@ -2239,7 +2231,7 @@ struct zs_pool *zs_create_pool(const cha
 			huge_class_size = size;
 			/*
 			 * The object uses ZS_HANDLE_SIZE bytes to store the
-			 * handle. We need to subtract it, because zs_malloc()
+			 * handle. We need to subtract it, because zs_store()
 			 * unconditionally adds handle size before it performs
 			 * size class search - so object may be smaller than
 			 * huge class size, yet it still can end up in the huge
--- a/mm/zswap.c~zsmalloc-fold-zs_obj_write-into-zs_store
+++ a/mm/zswap.c
@@ -950,12 +950,11 @@ static bool zswap_compress(struct folio
 	}
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	alloc_ret = zs_malloc(pool->zs_pool, &entry->handle, dlen, gfp,
-			      folio_nid(folio));
+	alloc_ret = zs_store(pool->zs_pool, &entry->handle, dst, dlen, gfp,
+			     folio_nid(folio));
 	if (alloc_ret)
 		goto unlock;
 
-	zs_obj_write(pool->zs_pool, &entry->handle, dst, dlen);
 	entry->length = dlen;
 
 unlock:
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch
zram-drop-stale-comment-in-write_incompressible_page.patch
zram-drop-get_slot_handle-and-set_slot_handle.patch
zsmalloc-return-handle-from-obj_allocated.patch
zsmalloc-switch-handle-type-to-struct-zs_handle.patch
zram-check-mem_limit-before-allocating-zsmalloc-object.patch
zram-allocate-zsmalloc-object-under-slot-lock.patch
zswap-do-not-free-the-entry-if-its-pool-is-null.patch
zsmalloc-encode-1-based-obj_idx-so-valid-obj-is-never-0.patch
zsmalloc-embed-struct-zs_handle-into-zram-and-zswap-entries.patch
zsmalloc-fold-zs_obj_write-into-zs_store.patch
zsmalloc-populate-new-zspage-outside-class-lock-in-zs_store.patch
zram-fix-quadratic-writeback-bitmap-search.patch

