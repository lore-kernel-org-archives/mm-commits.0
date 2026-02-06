Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5243B30AABC
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421695; cv=none; b=ZG4ab8FTuoZ1lyEC5kEaJkIj8OsC4Kc792kJODsTIvfcDZJ2Ph6lonjqiY6j2DjvXgXhKE6qwY3No768SDQ5cGe/bLdIUzIDNiCswnZM01dLv/0a+7x9PBEImfqVllrRgDbNtjJ4CFAL1GMX50tDFRWXxSNVzUW7+kfeaq/jTqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421695; c=relaxed/simple;
	bh=5tI7a4U5yLsyy/2jviHG5caQBjqw9aigiZGzaZBzEkY=;
	h=Date:To:From:Subject:Message-Id; b=BikfyeWUzYS1Ibt5umuO4vNt4L26V4wqOPYFnACZutL78w6qpIHToZNCv4oT6R4HOU2coWne9OWhGzAA7dk/UcdLJMh0EA/i8zi/Ce7vuSLY9059KjwSVX8WDhDDuINBum+Q5PTE8F/Ns/UzGsqAPvXgVpyYqVmZLMgn8eYjeJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J4fLoyQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J4fLoyQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ACDC116C6;
	Fri,  6 Feb 2026 23:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421695;
	bh=5tI7a4U5yLsyy/2jviHG5caQBjqw9aigiZGzaZBzEkY=;
	h=Date:To:From:Subject:From;
	b=J4fLoyQ28IODm+bsmpb7e37FMtqGy3QWcSZa88rxuEGnCBpKhDW9y1k4MMB8T6daa
	 njXPJLhzF26qSDYs2B+JeHCS8aBvVXIsr2QfXV0LHyS3BtYkRCJzVhKRUy82J193RG
	 /f1q8g9HGedg1i+GaTUjmOH07L8qmGdVxoGuVYVw=
Date: Fri, 06 Feb 2026 15:48:14 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-make-common-caches-global.patch removed from -mm tree
Message-Id: <20260206234815.28ACDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: make common caches global
has been removed from the -mm tree.  Its filename was
     zsmalloc-make-common-caches-global.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: make common caches global
Date: Sat, 17 Jan 2026 11:54:05 +0900

Currently, zsmalloc creates kmem_cache of handles and zspages for each
pool, which may be suboptimal from the memory usage point of view (extra
internal fragmentation per pool).  Systems that create multiple zsmalloc
pools may benefit from shared common zsmalloc caches.

Make handles and zspages kmem caches global.  The memory savings depend on
particular setup and data patterns and can be found via slabinfo.

Link: https://lkml.kernel.org/r/20260117025406.799428-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  106 ++++++++++++++++++++++--------------------------
 1 file changed, 50 insertions(+), 56 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-make-common-caches-global
+++ a/mm/zsmalloc.c
@@ -193,12 +193,13 @@ struct link_free {
 	};
 };
 
+static struct kmem_cache *handle_cachep;
+static struct kmem_cache *zspage_cachep;
+
 struct zs_pool {
 	const char *name;
 
 	struct size_class *size_class[ZS_SIZE_CLASSES];
-	struct kmem_cache *handle_cachep;
-	struct kmem_cache *zspage_cachep;
 
 	atomic_long_t pages_allocated;
 
@@ -371,60 +372,28 @@ static void init_deferred_free(struct zs
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
 #endif
 
-static int create_cache(struct zs_pool *pool)
+static unsigned long cache_alloc_handle(gfp_t gfp)
 {
-	char *name;
-
-	name = kasprintf(GFP_KERNEL, "zs_handle-%s", pool->name);
-	if (!name)
-		return -ENOMEM;
-	pool->handle_cachep = kmem_cache_create(name, ZS_HANDLE_SIZE,
-						0, 0, NULL);
-	kfree(name);
-	if (!pool->handle_cachep)
-		return -EINVAL;
-
-	name = kasprintf(GFP_KERNEL, "zspage-%s", pool->name);
-	if (!name)
-		return -ENOMEM;
-	pool->zspage_cachep = kmem_cache_create(name, sizeof(struct zspage),
-						0, 0, NULL);
-	kfree(name);
-	if (!pool->zspage_cachep) {
-		kmem_cache_destroy(pool->handle_cachep);
-		pool->handle_cachep = NULL;
-		return -EINVAL;
-	}
+	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-	return 0;
-}
-
-static void destroy_cache(struct zs_pool *pool)
-{
-	kmem_cache_destroy(pool->handle_cachep);
-	kmem_cache_destroy(pool->zspage_cachep);
+	return (unsigned long)kmem_cache_alloc(handle_cachep, gfp);
 }
 
-static unsigned long cache_alloc_handle(struct zs_pool *pool, gfp_t gfp)
+static void cache_free_handle(unsigned long handle)
 {
-	return (unsigned long)kmem_cache_alloc(pool->handle_cachep,
-			gfp & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
+	kmem_cache_free(handle_cachep, (void *)handle);
 }
 
-static void cache_free_handle(struct zs_pool *pool, unsigned long handle)
+static struct zspage *cache_alloc_zspage(gfp_t gfp)
 {
-	kmem_cache_free(pool->handle_cachep, (void *)handle);
-}
+	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-static struct zspage *cache_alloc_zspage(struct zs_pool *pool, gfp_t flags)
-{
-	return kmem_cache_zalloc(pool->zspage_cachep,
-			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
+	return kmem_cache_zalloc(zspage_cachep, gfp);
 }
 
-static void cache_free_zspage(struct zs_pool *pool, struct zspage *zspage)
+static void cache_free_zspage(struct zspage *zspage)
 {
-	kmem_cache_free(pool->zspage_cachep, zspage);
+	kmem_cache_free(zspage_cachep, zspage);
 }
 
 /* class->lock(which owns the handle) synchronizes races */
@@ -853,7 +822,7 @@ static void __free_zspage(struct zs_pool
 		zpdesc = next;
 	} while (zpdesc != NULL);
 
-	cache_free_zspage(pool, zspage);
+	cache_free_zspage(zspage);
 
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
@@ -966,7 +935,7 @@ static struct zspage *alloc_zspage(struc
 {
 	int i;
 	struct zpdesc *zpdescs[ZS_MAX_PAGES_PER_ZSPAGE];
-	struct zspage *zspage = cache_alloc_zspage(pool, gfp);
+	struct zspage *zspage = cache_alloc_zspage(gfp);
 
 	if (!zspage)
 		return NULL;
@@ -988,7 +957,7 @@ static struct zspage *alloc_zspage(struc
 				zpdesc_dec_zone_page_state(zpdescs[i]);
 				free_zpdesc(zpdescs[i]);
 			}
-			cache_free_zspage(pool, zspage);
+			cache_free_zspage(zspage);
 			return NULL;
 		}
 		__zpdesc_set_zsmalloc(zpdesc);
@@ -1339,7 +1308,7 @@ unsigned long zs_malloc(struct zs_pool *
 	if (unlikely(size > ZS_MAX_ALLOC_SIZE))
 		return (unsigned long)ERR_PTR(-ENOSPC);
 
-	handle = cache_alloc_handle(pool, gfp);
+	handle = cache_alloc_handle(gfp);
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
@@ -1363,7 +1332,7 @@ unsigned long zs_malloc(struct zs_pool *
 
 	zspage = alloc_zspage(pool, class, gfp, nid);
 	if (!zspage) {
-		cache_free_handle(pool, handle);
+		cache_free_handle(handle);
 		return (unsigned long)ERR_PTR(-ENOMEM);
 	}
 
@@ -1443,7 +1412,7 @@ void zs_free(struct zs_pool *pool, unsig
 		free_zspage(pool, class, zspage);
 
 	spin_unlock(&class->lock);
-	cache_free_handle(pool, handle);
+	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
@@ -2105,9 +2074,6 @@ struct zs_pool *zs_create_pool(const cha
 	if (!pool->name)
 		goto err;
 
-	if (create_cache(pool))
-		goto err;
-
 	/*
 	 * Iterate reversely, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
@@ -2229,20 +2195,47 @@ void zs_destroy_pool(struct zs_pool *poo
 		kfree(class);
 	}
 
-	destroy_cache(pool);
 	kfree(pool->name);
 	kfree(pool);
 }
 EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
+static void zs_destroy_caches(void)
+{
+	kmem_cache_destroy(handle_cachep);
+	handle_cachep = NULL;
+	kmem_cache_destroy(zspage_cachep);
+	zspage_cachep = NULL;
+}
+
+static int __init zs_init_caches(void)
+{
+	handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
+					  0, 0, NULL);
+	zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
+					  0, 0, NULL);
+
+	if (!handle_cachep || !zspage_cachep) {
+		zs_destroy_caches();
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 static int __init zs_init(void)
 {
-	int rc __maybe_unused;
+	int rc;
+
+	rc = zs_init_caches();
+	if (rc)
+		return rc;
 
 #ifdef CONFIG_COMPACTION
 	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
-	if (rc)
+	if (rc) {
+		zs_destroy_caches();
 		return rc;
+	}
 #endif
 	zs_stat_init();
 	return 0;
@@ -2254,6 +2247,7 @@ static void __exit zs_exit(void)
 	set_movable_ops(NULL, PGTY_zsmalloc);
 #endif
 	zs_stat_exit();
+	zs_destroy_caches();
 }
 
 module_init(zs_init);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


