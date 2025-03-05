Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D5E1FFC56
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741216367; cv=none; b=RAioDVGFrmxRAhd//mF+N9NhEK00wKVFF08qgmE+k7bZm82LcCIKZyYbYADsN6ts1GvVoymZgsjMxsM9mmMcUgIcifagbGeZt1Q1CCqX/ip3G9BZYLh+AAE0EXW2ey267uWhlVi4LlAMwe2wAGyTro58r2wh1A496i68wLoU0AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741216367; c=relaxed/simple;
	bh=gYb87kXarhZtQJGRgsUBRfvVOX2/yrHpSJLINBHI84A=;
	h=Date:To:From:Subject:Message-Id; b=KN9AaYaZ7GW3l7HQqUsEYekYuTNmNKjSETWLkNUNA6qBN4Z+e2W+JlPz9YhRft7GAAG0tCu2uodq7bQ2CO4zRhS0u/Uo98v+MBCiuxO9ZMH3ajf5AhyFhk09Ze5wfUHeHLSyYFACZhrhCa29dFadQ0YTl9PjH1kw/gOGqSSvST4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wc/hQDzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wc/hQDzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22F0C4CEE0;
	Wed,  5 Mar 2025 23:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741216365;
	bh=gYb87kXarhZtQJGRgsUBRfvVOX2/yrHpSJLINBHI84A=;
	h=Date:To:From:Subject:From;
	b=Wc/hQDzSekWE+lh/AX8EzEJCX1bQ+9bs1hx0DBFx6J0wFeV9wLmZIitLu85BIoUmi
	 Xx59YPN9QjgXW4aaWlagWDc6XVCe7VFMrL0bjay9MbEkweEmO1foufLpsglPQHbNnx
	 4OMTAomx/fuSgamwfFybB3XThBfD+InRNHvHSnVM=
Date: Wed, 05 Mar 2025 15:12:45 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,senozhatsky@chromium.org,peterz@infradead.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zpool-remove-object-mapping-apis.patch added to mm-unstable branch
Message-Id: <20250305231245.D22F0C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zpool: remove object mapping APIs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zpool-remove-object-mapping-apis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zpool-remove-object-mapping-apis.patch

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
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm: zpool: remove object mapping APIs
Date: Wed, 5 Mar 2025 06:11:31 +0000

zpool_map_handle(), zpool_unmap_handle(), and zpool_can_sleep_mapped() are
no longer used.  Remove them with the underlying driver callbacks.

Link: https://lkml.kernel.org/r/20250305061134.4105762-4-yosry.ahmed@linux.dev
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |   30 -------------------
 mm/zpool.c            |   61 ----------------------------------------
 mm/zsmalloc.c         |   27 -----------------
 3 files changed, 118 deletions(-)

--- a/include/linux/zpool.h~mm-zpool-remove-object-mapping-apis
+++ a/include/linux/zpool.h
@@ -13,25 +13,6 @@
 
 struct zpool;
 
-/*
- * Control how a handle is mapped.  It will be ignored if the
- * implementation does not support it.  Its use is optional.
- * Note that this does not refer to memory protection, it
- * refers to how the memory will be copied in/out if copying
- * is necessary during mapping; read-write is the safest as
- * it copies the existing memory in on map, and copies the
- * changed memory back out on unmap.  Write-only does not copy
- * in the memory and should only be used for initialization.
- * If in doubt, use ZPOOL_MM_DEFAULT which is read-write.
- */
-enum zpool_mapmode {
-	ZPOOL_MM_RW, /* normal read-write mapping */
-	ZPOOL_MM_RO, /* read-only (no copy-out at unmap time) */
-	ZPOOL_MM_WO, /* write-only (no copy-in at map time) */
-
-	ZPOOL_MM_DEFAULT = ZPOOL_MM_RW
-};
-
 bool zpool_has_pool(char *type);
 
 struct zpool *zpool_create_pool(const char *type, const char *name, gfp_t gfp);
@@ -47,12 +28,6 @@ int zpool_malloc(struct zpool *pool, siz
 
 void zpool_free(struct zpool *pool, unsigned long handle);
 
-void *zpool_map_handle(struct zpool *pool, unsigned long handle,
-			enum zpool_mapmode mm);
-
-void zpool_unmap_handle(struct zpool *pool, unsigned long handle);
-
-
 void *zpool_obj_read_begin(struct zpool *zpool, unsigned long handle,
 			   void *local_copy);
 
@@ -95,11 +70,6 @@ struct zpool_driver {
 				unsigned long *handle);
 	void (*free)(void *pool, unsigned long handle);
 
-	bool sleep_mapped;
-	void *(*map)(void *pool, unsigned long handle,
-				enum zpool_mapmode mm);
-	void (*unmap)(void *pool, unsigned long handle);
-
 	void *(*obj_read_begin)(void *pool, unsigned long handle,
 				void *local_copy);
 	void (*obj_read_end)(void *pool, unsigned long handle,
--- a/mm/zpool.c~mm-zpool-remove-object-mapping-apis
+++ a/mm/zpool.c
@@ -278,49 +278,6 @@ void zpool_free(struct zpool *zpool, uns
 }
 
 /**
- * zpool_map_handle() - Map a previously allocated handle into memory
- * @zpool:	The zpool that the handle was allocated from
- * @handle:	The handle to map
- * @mapmode:	How the memory should be mapped
- *
- * This maps a previously allocated handle into memory.  The @mapmode
- * param indicates to the implementation how the memory will be
- * used, i.e. read-only, write-only, read-write.  If the
- * implementation does not support it, the memory will be treated
- * as read-write.
- *
- * This may hold locks, disable interrupts, and/or preemption,
- * and the zpool_unmap_handle() must be called to undo those
- * actions.  The code that uses the mapped handle should complete
- * its operations on the mapped handle memory quickly and unmap
- * as soon as possible.  As the implementation may use per-cpu
- * data, multiple handles should not be mapped concurrently on
- * any cpu.
- *
- * Returns: A pointer to the handle's mapped memory area.
- */
-void *zpool_map_handle(struct zpool *zpool, unsigned long handle,
-			enum zpool_mapmode mapmode)
-{
-	return zpool->driver->map(zpool->pool, handle, mapmode);
-}
-
-/**
- * zpool_unmap_handle() - Unmap a previously mapped handle
- * @zpool:	The zpool that the handle was allocated from
- * @handle:	The handle to unmap
- *
- * This unmaps a previously mapped handle.  Any locks or other
- * actions that the implementation took in zpool_map_handle()
- * will be undone here.  The memory area returned from
- * zpool_map_handle() should no longer be used after this.
- */
-void zpool_unmap_handle(struct zpool *zpool, unsigned long handle)
-{
-	zpool->driver->unmap(zpool->pool, handle);
-}
-
-/**
  * zpool_obj_read_begin() - Start reading from a previously allocated handle.
  * @zpool:	The zpool that the handle was allocated from
  * @handle:	The handle to read from
@@ -381,23 +338,5 @@ u64 zpool_get_total_pages(struct zpool *
 	return zpool->driver->total_pages(zpool->pool);
 }
 
-/**
- * zpool_can_sleep_mapped - Test if zpool can sleep when do mapped.
- * @zpool:	The zpool to test
- *
- * Some allocators enter non-preemptible context in ->map() callback (e.g.
- * disable pagefaults) and exit that context in ->unmap(), which limits what
- * we can do with the mapped object. For instance, we cannot wait for
- * asynchronous crypto API to decompress such an object or take mutexes
- * since those will call into the scheduler. This function tells us whether
- * we use such an allocator.
- *
- * Returns: true if zpool can sleep; false otherwise.
- */
-bool zpool_can_sleep_mapped(struct zpool *zpool)
-{
-	return zpool->driver->sleep_mapped;
-}
-
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
 MODULE_DESCRIPTION("Common API for compressed memory storage");
--- a/mm/zsmalloc.c~mm-zpool-remove-object-mapping-apis
+++ a/mm/zsmalloc.c
@@ -482,31 +482,6 @@ static void zs_zpool_free(void *pool, un
 	zs_free(pool, handle);
 }
 
-static void *zs_zpool_map(void *pool, unsigned long handle,
-			enum zpool_mapmode mm)
-{
-	enum zs_mapmode zs_mm;
-
-	switch (mm) {
-	case ZPOOL_MM_RO:
-		zs_mm = ZS_MM_RO;
-		break;
-	case ZPOOL_MM_WO:
-		zs_mm = ZS_MM_WO;
-		break;
-	case ZPOOL_MM_RW:
-	default:
-		zs_mm = ZS_MM_RW;
-		break;
-	}
-
-	return zs_map_object(pool, handle, zs_mm);
-}
-static void zs_zpool_unmap(void *pool, unsigned long handle)
-{
-	zs_unmap_object(pool, handle);
-}
-
 static void *zs_zpool_obj_read_begin(void *pool, unsigned long handle,
 				     void *local_copy)
 {
@@ -538,8 +513,6 @@ static struct zpool_driver zs_zpool_driv
 	.malloc_support_movable = true,
 	.malloc =		  zs_zpool_malloc,
 	.free =			  zs_zpool_free,
-	.map =			  zs_zpool_map,
-	.unmap =		  zs_zpool_unmap,
 	.obj_read_begin =	  zs_zpool_obj_read_begin,
 	.obj_read_end  =	  zs_zpool_obj_read_end,
 	.obj_write =		  zs_zpool_obj_write,
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

mm-z3fold-remove-z3fold.patch
mm-zbud-remove-zbud.patch
mm-zpool-add-interfaces-for-object-read-write-apis.patch
mm-zswap-use-object-read-write-apis-instead-of-object-mapping-apis.patch
mm-zpool-remove-object-mapping-apis.patch
mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas.patch
mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix.patch
mm-zpool-remove-zpool_malloc_support_movable.patch

