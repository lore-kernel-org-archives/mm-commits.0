From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-require-gfp-in-zs_malloc.patch removed from -mm tree
Date: Mon, 23 May 2016 12:47:46 -0700
Message-ID: <57435e62.NFNUpqypP//ZC6Mu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbcEWTrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: require GFP in zs_malloc()
has been removed from the -mm tree.  Its filename was
     zsmalloc-require-gfp-in-zs_malloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: require GFP in zs_malloc()

Pass GFP flags to zs_malloc() instead of using a fixed mask supplied to
zs_create_pool(), so we can be more flexible, but, more importantly, we
need this to switch zram to per-cpu compression streams -- zram will try
to allocate handle with preemption disabled in a fast path and switch to
a slow path (using different gfp mask) if the fast one has failed.

Apart from that, this also align zs_malloc() interface with zspool/zbud.

[sergey.senozhatsky@gmail.com: pass GFP flags to zs_malloc() instead of using a fixed mask]
  Link: http://lkml.kernel.org/r/20160429150942.GA637@swordfish
Link: http://lkml.kernel.org/r/20160429150942.GA637@swordfish
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 include/linux/zsmalloc.h      |    4 ++--
 mm/zsmalloc.c                 |   24 +++++++++++++-----------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zsmalloc-require-gfp-in-zs_malloc drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zsmalloc-require-gfp-in-zs_malloc
+++ a/drivers/block/zram/zram_drv.c
@@ -514,7 +514,7 @@ static struct zram_meta *zram_meta_alloc
 		goto out_error;
 	}
 
-	meta->mem_pool = zs_create_pool(pool_name, GFP_NOIO | __GFP_HIGHMEM);
+	meta->mem_pool = zs_create_pool(pool_name);
 	if (!meta->mem_pool) {
 		pr_err("Error creating memory pool\n");
 		goto out_error;
@@ -717,7 +717,7 @@ static int zram_bvec_write(struct zram *
 			src = uncmem;
 	}
 
-	handle = zs_malloc(meta->mem_pool, clen);
+	handle = zs_malloc(meta->mem_pool, clen, GFP_NOIO | __GFP_HIGHMEM);
 	if (!handle) {
 		pr_err("Error allocating memory for compressed page: %u, size=%zu\n",
 			index, clen);
diff -puN include/linux/zsmalloc.h~zsmalloc-require-gfp-in-zs_malloc include/linux/zsmalloc.h
--- a/include/linux/zsmalloc.h~zsmalloc-require-gfp-in-zs_malloc
+++ a/include/linux/zsmalloc.h
@@ -41,10 +41,10 @@ struct zs_pool_stats {
 
 struct zs_pool;
 
-struct zs_pool *zs_create_pool(const char *name, gfp_t flags);
+struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
 
-unsigned long zs_malloc(struct zs_pool *pool, size_t size);
+unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags);
 void zs_free(struct zs_pool *pool, unsigned long obj);
 
 void *zs_map_object(struct zs_pool *pool, unsigned long handle,
diff -puN mm/zsmalloc.c~zsmalloc-require-gfp-in-zs_malloc mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-require-gfp-in-zs_malloc
+++ a/mm/zsmalloc.c
@@ -247,7 +247,6 @@ struct zs_pool {
 	struct size_class **size_class;
 	struct kmem_cache *handle_cachep;
 
-	gfp_t flags;	/* allocation flags used when growing pool */
 	atomic_long_t pages_allocated;
 
 	struct zs_pool_stats stats;
@@ -295,10 +294,10 @@ static void destroy_handle_cache(struct
 	kmem_cache_destroy(pool->handle_cachep);
 }
 
-static unsigned long alloc_handle(struct zs_pool *pool)
+static unsigned long alloc_handle(struct zs_pool *pool, gfp_t gfp)
 {
 	return (unsigned long)kmem_cache_alloc(pool->handle_cachep,
-		pool->flags & ~__GFP_HIGHMEM);
+			gfp & ~__GFP_HIGHMEM);
 }
 
 static void free_handle(struct zs_pool *pool, unsigned long handle)
@@ -324,7 +323,12 @@ static void *zs_zpool_create(const char
 			     const struct zpool_ops *zpool_ops,
 			     struct zpool *zpool)
 {
-	return zs_create_pool(name, gfp);
+	/*
+	 * Ignore global gfp flags: zs_malloc() may be invoked from
+	 * different contexts and its caller must provide a valid
+	 * gfp mask.
+	 */
+	return zs_create_pool(name);
 }
 
 static void zs_zpool_destroy(void *pool)
@@ -335,7 +339,7 @@ static void zs_zpool_destroy(void *pool)
 static int zs_zpool_malloc(void *pool, size_t size, gfp_t gfp,
 			unsigned long *handle)
 {
-	*handle = zs_malloc(pool, size);
+	*handle = zs_malloc(pool, size, gfp);
 	return *handle ? 0 : -1;
 }
 static void zs_zpool_free(void *pool, unsigned long handle)
@@ -1391,7 +1395,7 @@ static unsigned long obj_malloc(struct s
  * otherwise 0.
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
  */
-unsigned long zs_malloc(struct zs_pool *pool, size_t size)
+unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp)
 {
 	unsigned long handle, obj;
 	struct size_class *class;
@@ -1400,7 +1404,7 @@ unsigned long zs_malloc(struct zs_pool *
 	if (unlikely(!size || size > ZS_MAX_ALLOC_SIZE))
 		return 0;
 
-	handle = alloc_handle(pool);
+	handle = alloc_handle(pool, gfp);
 	if (!handle)
 		return 0;
 
@@ -1413,7 +1417,7 @@ unsigned long zs_malloc(struct zs_pool *
 
 	if (!first_page) {
 		spin_unlock(&class->lock);
-		first_page = alloc_zspage(class, pool->flags);
+		first_page = alloc_zspage(class, gfp);
 		if (unlikely(!first_page)) {
 			free_handle(pool, handle);
 			return 0;
@@ -1878,7 +1882,7 @@ static int zs_register_shrinker(struct z
  * On success, a pointer to the newly created pool is returned,
  * otherwise NULL.
  */
-struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
+struct zs_pool *zs_create_pool(const char *name)
 {
 	int i;
 	struct zs_pool *pool;
@@ -1948,8 +1952,6 @@ struct zs_pool *zs_create_pool(const cha
 		prev_class = class;
 	}
 
-	pool->flags = flags;
