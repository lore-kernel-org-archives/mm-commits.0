From: akpm@linux-foundation.org
Subject: + zsmalloc-require-gfp-in-zs_malloc.patch added to -mm tree
Date: Thu, 28 Apr 2016 14:35:07 -0700
Message-ID: <5722820b.gdQHbH08cjmQUrDR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbcD1VfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2016 17:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: require GFP in zs_malloc()
has been added to the -mm tree.  Its filename is
     zsmalloc-require-gfp-in-zs_malloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-require-gfp-in-zs_malloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-require-gfp-in-zs_malloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: require GFP in zs_malloc()

Pass GFP flags to zs_malloc() instead of using a fixed set (supplied
during pool creation), so we can be more flexible, but, more importantly,
this will be need to switch zram to per-cpu compression streams.

Apart from that, this also align zs_malloc() interface with zspool/zbud.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 include/linux/zsmalloc.h      |    2 +-
 mm/zsmalloc.c                 |   15 ++++++---------
 3 files changed, 8 insertions(+), 11 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zsmalloc-require-gfp-in-zs_malloc drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zsmalloc-require-gfp-in-zs_malloc
+++ a/drivers/block/zram/zram_drv.c
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
@@ -44,7 +44,7 @@ struct zs_pool;
 struct zs_pool *zs_create_pool(const char *name, gfp_t flags);
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
@@ -335,7 +334,7 @@ static void zs_zpool_destroy(void *pool)
 static int zs_zpool_malloc(void *pool, size_t size, gfp_t gfp,
 			unsigned long *handle)
 {
-	*handle = zs_malloc(pool, size);
+	*handle = zs_malloc(pool, size, gfp);
 	return *handle ? 0 : -1;
 }
 static void zs_zpool_free(void *pool, unsigned long handle)
@@ -1391,7 +1390,7 @@ static unsigned long obj_malloc(struct s
  * otherwise 0.
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
  */
-unsigned long zs_malloc(struct zs_pool *pool, size_t size)
+unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp)
 {
 	unsigned long handle, obj;
 	struct size_class *class;
@@ -1400,7 +1399,7 @@ unsigned long zs_malloc(struct zs_pool *
 	if (unlikely(!size || size > ZS_MAX_ALLOC_SIZE))
 		return 0;
 
-	handle = alloc_handle(pool);
+	handle = alloc_handle(pool, gfp);
 	if (!handle)
 		return 0;
 
@@ -1413,7 +1412,7 @@ unsigned long zs_malloc(struct zs_pool *
 
 	if (!first_page) {
 		spin_unlock(&class->lock);
-		first_page = alloc_zspage(class, pool->flags);
+		first_page = alloc_zspage(class, gfp);
 		if (unlikely(!first_page)) {
 			free_handle(pool, handle);
 			return 0;
@@ -1945,8 +1944,6 @@ struct zs_pool *zs_create_pool(const cha
 		prev_class = class;
 	}
 
-	pool->flags = flags;
