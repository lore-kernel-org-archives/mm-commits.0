Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFE02066F9
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741216370; cv=none; b=irUjyBKZUBKPedsTGwYJOtu6gylI8YPa8ckjH4sYaqGrahaufSx98M40tWzfN4S9tSs2EL5fz+qqTbETh4jmrnrdJ96XOhEEeQWF9uwzCi2gug6Ff4PM1xQqq2tUqZ88PQVxB/mNWlQy/WDDnLcDhM7AZVJVNNKlRQfM23ht7MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741216370; c=relaxed/simple;
	bh=PQ19eSCbUJXz1GxIc/kOR4RLDD+2dOwkky7NX/vZR+I=;
	h=Date:To:From:Subject:Message-Id; b=Oaa3TxbTviMvuOIQux88VlEd5BpnI6DtW2I5ziNdnfPctaOUKx//JPXqtWA1amV/fiELS+Ge1xMyAVQAry3jkr7egAJ6Ya0pM9p49IukGpItMn3CYHpAy5dvKHjbBeEAbHxuzQc0ZpyXSPa4mBDTNbmOSNViRNQK5mQmJc4QoTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hV8Sq26N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hV8Sq26N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D8BC4CED1;
	Wed,  5 Mar 2025 23:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741216370;
	bh=PQ19eSCbUJXz1GxIc/kOR4RLDD+2dOwkky7NX/vZR+I=;
	h=Date:To:From:Subject:From;
	b=hV8Sq26Nbl2zLQO7PafALemGevmpMAQXYBY86BbCAm2cOGxPpn8JUCjfqYCK6n4ti
	 lf3AOx6u5WaW4CP7Ef0yjwHeP0WJSS4QGg+3xrbESSAv6bskxHZGHe0lx6H3y3XYw8
	 J/huWLAUz7WgtfIQHQWNeeVthgxbappNV3IFB8uM=
Date: Wed, 05 Mar 2025 15:12:49 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,senozhatsky@chromium.org,peterz@infradead.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zpool-remove-zpool_malloc_support_movable.patch added to mm-unstable branch
Message-Id: <20250305231250.04D8BC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zpool: remove zpool_malloc_support_movable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zpool-remove-zpool_malloc_support_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zpool-remove-zpool_malloc_support_movable.patch

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
Subject: mm: zpool: remove zpool_malloc_support_movable()
Date: Wed, 5 Mar 2025 06:11:33 +0000

zpool_malloc_support_movable() always returns true for zsmalloc, the only
remaining zpool driver.  Remove it and set the gfp flags in
zswap_compress() accordingly.  Opportunistically use GFP_NOWAIT instead of
__GFP_NOWARN | __GFP_KSWAPD_RECLAIM for conciseness as they are
equivalent.

Link: https://lkml.kernel.org/r/20250305061134.4105762-6-yosry.ahmed@linux.dev
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    3 ---
 mm/zpool.c            |   16 ----------------
 mm/zsmalloc.c         |    1 -
 mm/zswap.c            |    4 +---
 4 files changed, 1 insertion(+), 23 deletions(-)

--- a/include/linux/zpool.h~mm-zpool-remove-zpool_malloc_support_movable
+++ a/include/linux/zpool.h
@@ -21,8 +21,6 @@ const char *zpool_get_type(struct zpool
 
 void zpool_destroy_pool(struct zpool *pool);
 
-bool zpool_malloc_support_movable(struct zpool *pool);
-
 int zpool_malloc(struct zpool *pool, size_t size, gfp_t gfp,
 			unsigned long *handle);
 
@@ -65,7 +63,6 @@ struct zpool_driver {
 	void *(*create)(const char *name, gfp_t gfp);
 	void (*destroy)(void *pool);
 
-	bool malloc_support_movable;
 	int (*malloc)(void *pool, size_t size, gfp_t gfp,
 				unsigned long *handle);
 	void (*free)(void *pool, unsigned long handle);
--- a/mm/zpool.c~mm-zpool-remove-zpool_malloc_support_movable
+++ a/mm/zpool.c
@@ -221,22 +221,6 @@ const char *zpool_get_type(struct zpool
 }
 
 /**
- * zpool_malloc_support_movable() - Check if the zpool supports
- *	allocating movable memory
- * @zpool:	The zpool to check
- *
- * This returns if the zpool supports allocating movable memory.
- *
- * Implementations must guarantee this to be thread-safe.
- *
- * Returns: true if the zpool supports allocating movable memory, false if not
- */
-bool zpool_malloc_support_movable(struct zpool *zpool)
-{
-	return zpool->driver->malloc_support_movable;
-}
-
-/**
  * zpool_malloc() - Allocate memory
  * @zpool:	The zpool to allocate from.
  * @size:	The amount of memory to allocate.
--- a/mm/zsmalloc.c~mm-zpool-remove-zpool_malloc_support_movable
+++ a/mm/zsmalloc.c
@@ -503,7 +503,6 @@ static struct zpool_driver zs_zpool_driv
 	.owner =		  THIS_MODULE,
 	.create =		  zs_zpool_create,
 	.destroy =		  zs_zpool_destroy,
-	.malloc_support_movable = true,
 	.malloc =		  zs_zpool_malloc,
 	.free =			  zs_zpool_free,
 	.obj_read_begin =	  zs_zpool_obj_read_begin,
--- a/mm/zswap.c~mm-zpool-remove-zpool_malloc_support_movable
+++ a/mm/zswap.c
@@ -964,9 +964,7 @@ static bool zswap_compress(struct page *
 		goto unlock;
 
 	zpool = pool->zpool;
-	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
-	if (zpool_malloc_support_movable(zpool))
-		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
+	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
 	alloc_ret = zpool_malloc(zpool, dlen, gfp, &handle);
 	if (alloc_ret)
 		goto unlock;
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

