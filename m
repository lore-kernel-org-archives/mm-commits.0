Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7885B8634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188552; cv=none; b=IZsdDun3pVhAAiDvjZJAEV0XCzjzNCDvJ9eTc1BpIH0KowatCf9P5fe0zsAYwn0VL9EKMllhvkN3qADjBtytMnId6z202WR/apwwADTaqTKmiAgZpu4Fm6hGkpX6O6yI7nupwDOPANbECkWHEaDnKKjasx8RF/tTUJh1lNRaeL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188552; c=relaxed/simple;
	bh=grSrX2iYUUcGSRSkb9JCz/QUdASrRduKl3fB1wg2rCw=;
	h=Date:To:From:Subject:Message-Id; b=mRUPX4nKIHVNIQIXaD3m2QWz+3PYxxr9mGZSgFAcuhvu5LNmjyEIaLboEJ82raCUS0D9d7T+TT98TSl3AwgJ6IceaLFnPrfQj+I5UJzylqn+sNDezyYiA5sUxgxifb4m637nKiBmvgJDSSYt+nE6gl5wzlTO3MaXBpFuj4JcCvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zlVmIU9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zlVmIU9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5E7C4CEEC;
	Mon, 17 Mar 2025 05:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188552;
	bh=grSrX2iYUUcGSRSkb9JCz/QUdASrRduKl3fB1wg2rCw=;
	h=Date:To:From:Subject:From;
	b=zlVmIU9yjvy3LHSdDF020hAF+FkH3PmYv4x31NlPbT42up87gwphmnqvzIWly7Jeg
	 8umXr1DZWbAg7SlO/AiOn0Zk8+ZAe3ksxmU7xBGhoArg/a8bpFTTFBbEd+m9gg97LJ
	 IGAqvN4X240LXlKP7dIDHZ1LnIe2gnz/jdGf+oR8=
Date: Sun, 16 Mar 2025 22:15:51 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,senozhatsky@chromium.org,peterz@infradead.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas.patch removed from -mm tree
Message-Id: <20250317051552.4C5E7C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zsmalloc: remove object mapping APIs and per-CPU map areas
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm: zsmalloc: remove object mapping APIs and per-CPU map areas
Date: Wed, 5 Mar 2025 06:11:32 +0000

zs_map_object() and zs_unmap_object() are no longer used, remove them. 
Since these are the only users of per-CPU mapping_areas, remove them and
the associated CPU hotplug callbacks too.

[yosry.ahmed@linux.dev: update the docs]
  Link: https://lkml.kernel.org/r/Z8ier-ZZp8T6MOTH@google.com
Link: https://lkml.kernel.org/r/20250305061134.4105762-5-yosry.ahmed@linux.dev
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/zsmalloc.rst |    5 
 include/linux/cpuhotplug.h    |    1 
 include/linux/zsmalloc.h      |   21 --
 mm/zsmalloc.c                 |  226 --------------------------------
 4 files changed, 3 insertions(+), 250 deletions(-)

--- a/Documentation/mm/zsmalloc.rst~mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas
+++ a/Documentation/mm/zsmalloc.rst
@@ -27,9 +27,8 @@ Instead, it returns an opaque handle (un
 location of the allocated object. The reason for this indirection is that
 zsmalloc does not keep zspages permanently mapped since that would cause
 issues on 32-bit systems where the VA region for kernel space mappings
-is very small. So, before using the allocating memory, the object has to
-be mapped using zs_map_object() to get a usable pointer and subsequently
-unmapped using zs_unmap_object().
+is very small. So, using the allocated memory should be done through the
+proper handle-based APIs.
 
 stat
 ====
--- a/include/linux/cpuhotplug.h~mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas
+++ a/include/linux/cpuhotplug.h
@@ -116,7 +116,6 @@ enum cpuhp_state {
 	CPUHP_NET_IUCV_PREPARE,
 	CPUHP_ARM_BL_PREPARE,
 	CPUHP_TRACE_RB_PREPARE,
-	CPUHP_MM_ZS_PREPARE,
 	CPUHP_MM_ZSWP_POOL_PREPARE,
 	CPUHP_KVM_PPC_BOOK3S_PREPARE,
 	CPUHP_ZCOMP_PREPARE,
--- a/include/linux/zsmalloc.h~mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas
+++ a/include/linux/zsmalloc.h
@@ -16,23 +16,6 @@
 
 #include <linux/types.h>
 
-/*
- * zsmalloc mapping modes
- *
- * NOTE: These only make a difference when a mapped object spans pages.
- */
-enum zs_mapmode {
-	ZS_MM_RW, /* normal read-write mapping */
-	ZS_MM_RO, /* read-only (no copy-out at unmap time) */
-	ZS_MM_WO /* write-only (no copy-in at map time) */
-	/*
-	 * NOTE: ZS_MM_WO should only be used for initializing new
-	 * (uninitialized) allocations.  Partial writes to already
-	 * initialized allocations should use ZS_MM_RW to preserve the
-	 * existing data.
-	 */
-};
-
 struct zs_pool_stats {
 	/* How many pages were migrated (freed) */
 	atomic_long_t pages_compacted;
@@ -48,10 +31,6 @@ void zs_free(struct zs_pool *pool, unsig
 
 size_t zs_huge_class_size(struct zs_pool *pool);
 
-void *zs_map_object(struct zs_pool *pool, unsigned long handle,
-			enum zs_mapmode mm);
-void zs_unmap_object(struct zs_pool *pool, unsigned long handle);
-
 unsigned long zs_get_total_pages(struct zs_pool *pool);
 unsigned long zs_compact(struct zs_pool *pool);
 
--- a/mm/zsmalloc.c~mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas
+++ a/mm/zsmalloc.c
@@ -281,13 +281,6 @@ struct zspage {
 	struct zspage_lock zsl;
 };
 
-struct mapping_area {
-	local_lock_t lock;
-	char *vm_buf; /* copy buffer for objects that span pages */
-	char *vm_addr; /* address of kmap_local_page()'ed pages */
-	enum zs_mapmode vm_mm; /* mapping mode */
-};
-
 static void zspage_lock_init(struct zspage *zspage)
 {
 	static struct lock_class_key __key;
@@ -522,11 +515,6 @@ static struct zpool_driver zs_zpool_driv
 MODULE_ALIAS("zpool-zsmalloc");
 #endif /* CONFIG_ZPOOL */
 
-/* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
-static DEFINE_PER_CPU(struct mapping_area, zs_map_area) = {
-	.lock	= INIT_LOCAL_LOCK(lock),
-};
-
 static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
 {
 	return PagePrivate(zpdesc_page(zpdesc));
@@ -1111,93 +1099,6 @@ static struct zspage *find_get_zspage(st
 	return zspage;
 }
 
-static inline int __zs_cpu_up(struct mapping_area *area)
-{
-	/*
-	 * Make sure we don't leak memory if a cpu UP notification
-	 * and zs_init() race and both call zs_cpu_up() on the same cpu
-	 */
-	if (area->vm_buf)
-		return 0;
-	area->vm_buf = kmalloc(ZS_MAX_ALLOC_SIZE, GFP_KERNEL);
-	if (!area->vm_buf)
-		return -ENOMEM;
-	return 0;
-}
-
-static inline void __zs_cpu_down(struct mapping_area *area)
-{
-	kfree(area->vm_buf);
-	area->vm_buf = NULL;
-}
-
-static void *__zs_map_object(struct mapping_area *area,
-			struct zpdesc *zpdescs[2], int off, int size)
-{
-	size_t sizes[2];
-	char *buf = area->vm_buf;
-
-	/* disable page faults to match kmap_local_page() return conditions */
-	pagefault_disable();
-
-	/* no read fastpath */
-	if (area->vm_mm == ZS_MM_WO)
-		goto out;
-
-	sizes[0] = PAGE_SIZE - off;
-	sizes[1] = size - sizes[0];
-
-	/* copy object to per-cpu buffer */
-	memcpy_from_page(buf, zpdesc_page(zpdescs[0]), off, sizes[0]);
-	memcpy_from_page(buf + sizes[0], zpdesc_page(zpdescs[1]), 0, sizes[1]);
-out:
-	return area->vm_buf;
-}
-
-static void __zs_unmap_object(struct mapping_area *area,
-			struct zpdesc *zpdescs[2], int off, int size)
-{
-	size_t sizes[2];
-	char *buf;
-
-	/* no write fastpath */
-	if (area->vm_mm == ZS_MM_RO)
-		goto out;
-
-	buf = area->vm_buf;
-	buf = buf + ZS_HANDLE_SIZE;
-	size -= ZS_HANDLE_SIZE;
-	off += ZS_HANDLE_SIZE;
-
-	sizes[0] = PAGE_SIZE - off;
-	sizes[1] = size - sizes[0];
-
-	/* copy per-cpu buffer to object */
-	memcpy_to_page(zpdesc_page(zpdescs[0]), off, buf, sizes[0]);
-	memcpy_to_page(zpdesc_page(zpdescs[1]), 0, buf + sizes[0], sizes[1]);
-
-out:
-	/* enable page faults to match kunmap_local() return conditions */
-	pagefault_enable();
-}
-
-static int zs_cpu_prepare(unsigned int cpu)
-{
-	struct mapping_area *area;
-
-	area = &per_cpu(zs_map_area, cpu);
-	return __zs_cpu_up(area);
-}
-
-static int zs_cpu_dead(unsigned int cpu)
-{
-	struct mapping_area *area;
-
-	area = &per_cpu(zs_map_area, cpu);
-	__zs_cpu_down(area);
-	return 0;
-}
-
 static bool can_merge(struct size_class *prev, int pages_per_zspage,
 					int objs_per_zspage)
 {
@@ -1245,117 +1146,6 @@ unsigned long zs_get_total_pages(struct
 }
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
-/**
- * zs_map_object - get address of allocated object from handle.
- * @pool: pool from which the object was allocated
- * @handle: handle returned from zs_malloc
- * @mm: mapping mode to use
- *
- * Before using an object allocated from zs_malloc, it must be mapped using
- * this function. When done with the object, it must be unmapped using
- * zs_unmap_object.
- *
- * Only one object can be mapped per cpu at a time. There is no protection
- * against nested mappings.
- *
- * This function returns with preemption and page faults disabled.
- */
-void *zs_map_object(struct zs_pool *pool, unsigned long handle,
-			enum zs_mapmode mm)
-{
-	struct zspage *zspage;
-	struct zpdesc *zpdesc;
-	unsigned long obj, off;
-	unsigned int obj_idx;
-
-	struct size_class *class;
-	struct mapping_area *area;
-	struct zpdesc *zpdescs[2];
-	void *ret;
-
-	/*
-	 * Because we use per-cpu mapping areas shared among the
-	 * pools/users, we can't allow mapping in interrupt context
-	 * because it can corrupt another users mappings.
-	 */
-	BUG_ON(in_interrupt());
-
-	/* It guarantees it can get zspage from handle safely */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
-	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-
-	/*
-	 * migration cannot move any zpages in this zspage. Here, class->lock
-	 * is too heavy since callers would take some time until they calls
-	 * zs_unmap_object API so delegate the locking from class to zspage
-	 * which is smaller granularity.
-	 */
-	zspage_read_lock(zspage);
-	read_unlock(&pool->lock);
-
-	class = zspage_class(pool, zspage);
-	off = offset_in_page(class->size * obj_idx);
-
-	local_lock(&zs_map_area.lock);
-	area = this_cpu_ptr(&zs_map_area);
-	area->vm_mm = mm;
-	if (off + class->size <= PAGE_SIZE) {
-		/* this object is contained entirely within a page */
-		area->vm_addr = kmap_local_zpdesc(zpdesc);
-		ret = area->vm_addr + off;
-		goto out;
-	}
-
-	/* this object spans two pages */
-	zpdescs[0] = zpdesc;
-	zpdescs[1] = get_next_zpdesc(zpdesc);
-	BUG_ON(!zpdescs[1]);
-
-	ret = __zs_map_object(area, zpdescs, off, class->size);
-out:
-	if (likely(!ZsHugePage(zspage)))
-		ret += ZS_HANDLE_SIZE;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(zs_map_object);
-
-void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
-{
-	struct zspage *zspage;
-	struct zpdesc *zpdesc;
-	unsigned long obj, off;
-	unsigned int obj_idx;
-
-	struct size_class *class;
-	struct mapping_area *area;
-
-	obj = handle_to_obj(handle);
-	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-	class = zspage_class(pool, zspage);
-	off = offset_in_page(class->size * obj_idx);
-
-	area = this_cpu_ptr(&zs_map_area);
-	if (off + class->size <= PAGE_SIZE)
-		kunmap_local(area->vm_addr);
-	else {
-		struct zpdesc *zpdescs[2];
-
-		zpdescs[0] = zpdesc;
-		zpdescs[1] = get_next_zpdesc(zpdesc);
-		BUG_ON(!zpdescs[1]);
-
-		__zs_unmap_object(area, zpdescs, off, class->size);
-	}
-	local_unlock(&zs_map_area.lock);
-
-	zspage_read_unlock(zspage);
-}
-EXPORT_SYMBOL_GPL(zs_unmap_object);
-
 void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 			void *local_copy)
 {
@@ -1975,7 +1765,7 @@ static int zs_page_migrate(struct page *
 	 * the class lock protects zpage alloc/free in the zspage.
 	 */
 	spin_lock(&class->lock);
-	/* the zspage write_lock protects zpage access via zs_map_object */
+	/* the zspage write_lock protects zpage access via zs_obj_read/write() */
 	if (!zspage_write_trylock(zspage)) {
 		spin_unlock(&class->lock);
 		write_unlock(&pool->lock);
@@ -2459,23 +2249,11 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
 static int __init zs_init(void)
 {
-	int ret;
-
-	ret = cpuhp_setup_state(CPUHP_MM_ZS_PREPARE, "mm/zsmalloc:prepare",
-				zs_cpu_prepare, zs_cpu_dead);
-	if (ret)
-		goto out;
-
 #ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zs_zpool_driver);
 #endif
-
 	zs_stat_init();
-
 	return 0;
-
-out:
-	return ret;
 }
 
 static void __exit zs_exit(void)
@@ -2483,8 +2261,6 @@ static void __exit zs_exit(void)
 #ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zs_zpool_driver);
 #endif
-	cpuhp_remove_state(CPUHP_MM_ZS_PREPARE);
-
 	zs_stat_exit();
 }
 
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are


