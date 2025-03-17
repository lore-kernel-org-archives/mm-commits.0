Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D5920FAA9
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188556; cv=none; b=gjbtwENyh46tbkEMsWnrXTgW6lpPKEhaVrUxNS2qnbIIAUq5FyNPKTt5DV43Xpr7ugGHiTcd9AZA2PVitq8bZaHWuLn3Imx0JZR50pmnqIeseQux0JgKdoRZSypzkjR3Pny7hC9mnwJfdawCAGz604wu0inOmgHBBXFHesy7Ox8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188556; c=relaxed/simple;
	bh=h3btpyrctjJW1L4vVeVEYggRuPNUSo2l0XsXIObuVYI=;
	h=Date:To:From:Subject:Message-Id; b=sKjuinnrFrLVXPnLMnVYCY5TXxuDqEnFPZhFCj/e9yLEtJMsMK5adizhuSa9o8HjTPsvYzF42B69NpWhMdYp45SNi3wNhtqLXc/eM/T5zRm27Fb1t2doqUruOKHy8E7LXQFMXfXi7uHeSqI69z07BbAdQ5Mv62ejeJ4Jusrf6CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lDqvUZSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lDqvUZSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDEDC4CEEC;
	Mon, 17 Mar 2025 05:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188555;
	bh=h3btpyrctjJW1L4vVeVEYggRuPNUSo2l0XsXIObuVYI=;
	h=Date:To:From:Subject:From;
	b=lDqvUZSbHITKhq8Hv7aZ8zOyjfmvXLIswnY83yZOkzu5QXf0lRMEpMjV7vqWW+EbQ
	 mCJxiwF47MsbAfY84XjWt6oTShfSJLpqogq/NQudS/RpywuxYhDfHrKYVN3cRVFcuR
	 IsI/jIA4FW3TYcWWmoRHZJDFJW9XQ3/CjR87Wbls=
Date: Sun, 16 Mar 2025 22:15:55 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,senozhatsky@chromium.org,peterz@infradead.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zpool-remove-zpool_malloc_support_movable.patch removed from -mm tree
Message-Id: <20250317051555.BDDEDC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zpool: remove zpool_malloc_support_movable()
has been removed from the -mm tree.  Its filename was
     mm-zpool-remove-zpool_malloc_support_movable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


