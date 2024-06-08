Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C883C3D68
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 04:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717821146; cv=none; b=uQyIQ7YH+kLErKXKkB5ATMH5vWDTbghSaRymVoQ/DHaC1KCv1u17bHBrt1evFtPN3XHuJkj99zxJNsh9/vVV3fODhoWuWeoAdf8umMUKwDGtmcfd9SBPz6IQqd0eKRTX3PsagjUpQDJXzxXwOgr+TR01bq3KaXX8IUt9iyDYdOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717821146; c=relaxed/simple;
	bh=B8jrvctOlDNArpXXTeYhdvgvxOvnsPfu2oPO6nv+ZQs=;
	h=Date:To:From:Subject:Message-Id; b=d+3tt3tyQ9iGPLqdgMk8VcSCSiCcNG23mkVL3XcLc1uq9rIcjhPfuoyFTQuqOja0yUZxCm9KV4xzdHIkc8pEBzO08NhazP7Oq6PiRh4X6a5Bb9iVmwfUM1XxnyWpA+LE+G4PLrrZurhU6fRGAUiIwB+mXZKMzkvIMSz1IPaOhfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rEguTuGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rEguTuGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F889C2BD11;
	Sat,  8 Jun 2024 04:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717821146;
	bh=B8jrvctOlDNArpXXTeYhdvgvxOvnsPfu2oPO6nv+ZQs=;
	h=Date:To:From:Subject:From;
	b=rEguTuGVZxjdVvohsauiOsl2/+pfdtryJu4x+meBgTUIUAgeStlwP3Wy85FffkwP4
	 1Hv/iSqOLEMPAdYs3Ph7uMQwmmifIIohWiUZ/8s5xjIa6f4BAi8trM0MOAFgTuc5j9
	 PrvmLr5gqYhhRcTYu/+wcfD9I5SFaFWC2R+Ym428=
Date: Fri, 07 Jun 2024 21:32:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,senozhatsky@chromium.org,rientjes@google.com,minchan@kernel.org,erhard_f@mailbox.org,cl@linux.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-zsmalloc-share-slab-caches-for-all-zsmalloc-zpools.patch removed from -mm tree
Message-Id: <20240608043226.3F889C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zsmalloc: share slab caches for all zsmalloc zpools
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-share-slab-caches-for-all-zsmalloc-zpools.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zsmalloc: share slab caches for all zsmalloc zpools
Date: Tue, 4 Jun 2024 17:53:40 +0000

Zswap creates multiple zpools to improve concurrency.  Each zsmalloc zpool
creates its own 'zs_handle' and 'zspage' slab caches.  Currently we end up
with 32 slab caches of each type.

Since each slab cache holds some free objects, we end up with a lot of
free objects distributed among the separate zpool caches.  Slab caches are
designed to handle concurrent allocations by using percpu structures, so
having a single instance of each cache should be enough, and avoids
wasting more memory than needed due to fragmentation.

Additionally, having more slab caches than needed unnecessarily slows down
code paths that iterate slab_caches.

In the results reported by Eric in [1], the amount of unused slab memory
in these caches goes down from 242808 bytes to 29216 bytes (-88%).  This
is calculated by (num_objs - active_objs) * objsize for each 'zs_handle'
and 'zspage' cache.  Although this patch did not help with the allocation
failure reported by Eric with zswap + zsmalloc, I think it is still worth
merging on its own.

[1]https://lore.kernel.org/lkml/20240604134458.3ae4396a@yea/

Link: https://lkml.kernel.org/r/20240604175340.218175-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Erhard Furtner <erhard_f@mailbox.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   87 ++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 43 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-share-slab-caches-for-all-zsmalloc-zpools
+++ a/mm/zsmalloc.c
@@ -221,8 +221,6 @@ struct zs_pool {
 	const char *name;
 
 	struct size_class *size_class[ZS_SIZE_CLASSES];
-	struct kmem_cache *handle_cachep;
-	struct kmem_cache *zspage_cachep;
 
 	atomic_long_t pages_allocated;
 
@@ -290,50 +288,29 @@ static void init_deferred_free(struct zs
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
 #endif
 
-static int create_cache(struct zs_pool *pool)
-{
-	pool->handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
-					0, 0, NULL);
-	if (!pool->handle_cachep)
-		return 1;
-
-	pool->zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
-					0, 0, NULL);
-	if (!pool->zspage_cachep) {
-		kmem_cache_destroy(pool->handle_cachep);
-		pool->handle_cachep = NULL;
-		return 1;
-	}
-
-	return 0;
-}
+static struct kmem_cache *zs_handle_cache;
+static struct kmem_cache *zspage_cache;
 
-static void destroy_cache(struct zs_pool *pool)
+static unsigned long cache_alloc_handle(gfp_t gfp)
 {
-	kmem_cache_destroy(pool->handle_cachep);
-	kmem_cache_destroy(pool->zspage_cachep);
-}
-
-static unsigned long cache_alloc_handle(struct zs_pool *pool, gfp_t gfp)
-{
-	return (unsigned long)kmem_cache_alloc(pool->handle_cachep,
+	return (unsigned long)kmem_cache_alloc(zs_handle_cache,
 			gfp & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
 }
 
-static void cache_free_handle(struct zs_pool *pool, unsigned long handle)
+static void cache_free_handle(unsigned long handle)
 {
-	kmem_cache_free(pool->handle_cachep, (void *)handle);
+	kmem_cache_free(zs_handle_cache, (void *)handle);
 }
 
-static struct zspage *cache_alloc_zspage(struct zs_pool *pool, gfp_t flags)
+static struct zspage *cache_alloc_zspage(gfp_t flags)
 {
-	return kmem_cache_zalloc(pool->zspage_cachep,
+	return kmem_cache_zalloc(zspage_cache,
 			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
 }
 
-static void cache_free_zspage(struct zs_pool *pool, struct zspage *zspage)
+static void cache_free_zspage(struct zspage *zspage)
 {
-	kmem_cache_free(pool->zspage_cachep, zspage);
+	kmem_cache_free(zspage_cache, zspage);
 }
 
 /* pool->lock(which owns the handle) synchronizes races */
@@ -853,7 +830,7 @@ static void __free_zspage(struct zs_pool
 		page = next;
 	} while (page != NULL);
 
-	cache_free_zspage(pool, zspage);
+	cache_free_zspage(zspage);
 
 	class_stat_dec(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
@@ -966,7 +943,7 @@ static struct zspage *alloc_zspage(struc
 {
 	int i;
 	struct page *pages[ZS_MAX_PAGES_PER_ZSPAGE];
-	struct zspage *zspage = cache_alloc_zspage(pool, gfp);
+	struct zspage *zspage = cache_alloc_zspage(gfp);
 
 	if (!zspage)
 		return NULL;
@@ -984,7 +961,7 @@ static struct zspage *alloc_zspage(struc
 				__ClearPageZsmalloc(pages[i]);
 				__free_page(pages[i]);
 			}
-			cache_free_zspage(pool, zspage);
+			cache_free_zspage(zspage);
 			return NULL;
 		}
 		__SetPageZsmalloc(page);
@@ -1356,7 +1333,7 @@ unsigned long zs_malloc(struct zs_pool *
 	if (unlikely(size > ZS_MAX_ALLOC_SIZE))
 		return (unsigned long)ERR_PTR(-ENOSPC);
 
-	handle = cache_alloc_handle(pool, gfp);
+	handle = cache_alloc_handle(gfp);
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
@@ -1381,7 +1358,7 @@ unsigned long zs_malloc(struct zs_pool *
 
 	zspage = alloc_zspage(pool, class, gfp);
 	if (!zspage) {
-		cache_free_handle(pool, handle);
+		cache_free_handle(handle);
 		return (unsigned long)ERR_PTR(-ENOMEM);
 	}
 
@@ -1459,7 +1436,7 @@ void zs_free(struct zs_pool *pool, unsig
 		free_zspage(pool, class, zspage);
 
 	spin_unlock(&pool->lock);
-	cache_free_handle(pool, handle);
+	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
@@ -2124,9 +2101,6 @@ struct zs_pool *zs_create_pool(const cha
 	if (!pool->name)
 		goto err;
 
-	if (create_cache(pool))
-		goto err;
-
 	/*
 	 * Iterate reversely, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
@@ -2247,16 +2221,41 @@ void zs_destroy_pool(struct zs_pool *poo
 		kfree(class);
 	}
 
-	destroy_cache(pool);
 	kfree(pool->name);
 	kfree(pool);
 }
 EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
+static void zs_destroy_caches(void)
+{
+	kmem_cache_destroy(zs_handle_cache);
+	kmem_cache_destroy(zspage_cache);
+	zs_handle_cache = NULL;
+	zspage_cache = NULL;
+}
+
+static int zs_create_caches(void)
+{
+	zs_handle_cache = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
+					    0, 0, NULL);
+	zspage_cache = kmem_cache_create("zspage", sizeof(struct zspage),
+					 0, 0, NULL);
+
+	if (!zs_handle_cache || !zspage_cache) {
+		zs_destroy_caches();
+		return -1;
+	}
+	return 0;
+}
+
 static int __init zs_init(void)
 {
 	int ret;
 
+	ret = zs_create_caches();
+	if (ret)
+		goto out;
+
 	ret = cpuhp_setup_state(CPUHP_MM_ZS_PREPARE, "mm/zsmalloc:prepare",
 				zs_cpu_prepare, zs_cpu_dead);
 	if (ret)
@@ -2271,6 +2270,7 @@ static int __init zs_init(void)
 	return 0;
 
 out:
+	zs_destroy_caches();
 	return ret;
 }
 
@@ -2282,6 +2282,7 @@ static void __exit zs_exit(void)
 	cpuhp_remove_state(CPUHP_MM_ZS_PREPARE);
 
 	zs_stat_exit();
+	zs_destroy_caches();
 }
 
 module_init(zs_init);
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch
mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch
mm-swap-remove-synchronous-argument-to-swap_read_folio.patch

