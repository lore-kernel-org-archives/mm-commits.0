Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54E81CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824835; cv=none; b=JzXI0DfoLd5fsKRylNnO2tMep6TaxPDXHsGCtw2S2WvE96M8ctEdx4qza/Ld/gc1jxuc/VGGsT57KVwJIvu8heRpEZ/ds5oNnIQesxWyLUOyzzT2bPYOL0B29jSE9AmIzxcXsmYEddq4pxZYq+1bX9GVsmO53P9utUNZdYKm9U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824835; c=relaxed/simple;
	bh=4/Tufn2DNf2QYPU+ZfyDQPgxItaPSHrpnY/Im+pSkjg=;
	h=Date:To:From:Subject:Message-Id; b=RLD1gDoa0fJXur6n8QL6pY8/ek7VxlApccg3EKH5L+wkyOE5Lgf3uyNJwE4Vcr5fLGmZdf4vqViCtVaMrqScKiTL6/5Y8F1CbD/TZXdwe+Sjj0qNDMnHyfWXysRHzb6r+g6gUDNJcDoHnvgPgTDUlI1uiYej7aKwcTCTZombFBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XaJvwTXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XaJvwTXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AB1C32782;
	Fri, 12 Jul 2024 22:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824835;
	bh=4/Tufn2DNf2QYPU+ZfyDQPgxItaPSHrpnY/Im+pSkjg=;
	h=Date:To:From:Subject:From;
	b=XaJvwTXUjAMe8P3pDUqV5D0DVMVtNI4psC7hkNaYlTQAC08FZ7XxFHueAKLtzMoZ7
	 QZB/5dT+TNW7Npm/5ah3+qVIp4GxNscmiAKiln6NORtuk82VnffHL9B3DLUU8e9/H6
	 nv+g+SdlAWpmtte4BhrFEn52Gptv1OoTr7e2XyNg=
Date: Fri, 12 Jul 2024 15:53:54 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-use-only-one-pool-in-zswap.patch removed from -mm tree
Message-Id: <20240712225355.00AB1C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: use only one pool in zswap
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-only-one-pool-in-zswap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/zswap: use only one pool in zswap
Date: Mon, 17 Jun 2024 20:57:41 +0800

Zswap uses 32 pools to workaround the locking scalability problem in zswap
backends (mainly zsmalloc nowadays), which brings its own problems like
memory waste and more memory fragmentation.

Testing results show that we can have near performance with only one pool
in zswap after changing zsmalloc to use per-size_class lock instead of
pool spinlock.

Testing kernel build (make bzImage -j32) on tmpfs with memory.max=1GB, and
zswap shrinker enabled with 10GB swapfile on ext4.

                                real    user    sys
6.10.0-rc3                      138.18  1241.38 1452.73
6.10.0-rc3-onepool              149.45  1240.45 1844.69
6.10.0-rc3-onepool-perclass     138.23  1242.37 1469.71

And do the same testing using zbud, which shows a little worse performance
as expected since we don't do any locking optimization for zbud.  I think
it's acceptable since zsmalloc became a lot more popular than other
backends, and we may want to support only zsmalloc in the future.

                                real    user    sys
6.10.0-rc3-zbud			138.23  1239.58 1430.09
6.10.0-rc3-onepool-zbud		139.64  1241.37 1516.59

[chengming.zhou@linux.dev: fix error handling in zswap_pool_create(), per Dan Carpenter]
  Link: https://lkml.kernel.org/r/20240621-zsmalloc-lock-mm-everything-v2-2-d30e9cd2b793@linux.dev
[chengming.zhou@linux.dev: fix error handling again in zswap_pool_create(), per Yosry]
  Link: https://lkml.kernel.org/r/20240625-zsmalloc-lock-mm-everything-v3-2-ad941699cb61@linux.dev
Link: https://lkml.kernel.org/r/20240617-zsmalloc-lock-mm-everything-v1-2-5e5081ea11b3@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   61 ++++++++++++++++-----------------------------------
 1 file changed, 20 insertions(+), 41 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-only-one-pool-in-zswap
+++ a/mm/zswap.c
@@ -124,9 +124,6 @@ static unsigned int zswap_accept_thr_per
 module_param_named(accept_threshold_percent, zswap_accept_thr_percent,
 		   uint, 0644);
 
-/* Number of zpools in zswap_pool (empirically determined for scalability) */
-#define ZSWAP_NR_ZPOOLS 32
-
 /* Enable/disable memory pressure-based shrinker. */
 static bool zswap_shrinker_enabled = IS_ENABLED(
 		CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
@@ -162,7 +159,7 @@ struct crypto_acomp_ctx {
  * needs to be verified that it's still valid in the tree.
  */
 struct zswap_pool {
-	struct zpool *zpools[ZSWAP_NR_ZPOOLS];
+	struct zpool *zpool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct list_head list;
@@ -244,7 +241,7 @@ static inline struct xarray *swap_zswap_
 
 #define zswap_pool_debug(msg, p)				\
 	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
-		 zpool_get_type((p)->zpools[0]))
+		 zpool_get_type((p)->zpool))
 
 /*********************************
 * pool functions
@@ -253,7 +250,6 @@ static void __zswap_pool_empty(struct pe
 
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
-	int i;
 	struct zswap_pool *pool;
 	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
 	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
@@ -274,18 +270,14 @@ static struct zswap_pool *zswap_pool_cre
 	if (!pool)
 		return NULL;
 
-	for (i = 0; i < ZSWAP_NR_ZPOOLS; i++) {
-		/* unique name for each pool specifically required by zsmalloc */
-		snprintf(name, 38, "zswap%x",
-			 atomic_inc_return(&zswap_pools_count));
-
-		pool->zpools[i] = zpool_create_pool(type, name, gfp);
-		if (!pool->zpools[i]) {
-			pr_err("%s zpool not available\n", type);
-			goto error;
-		}
+	/* unique name for each pool specifically required by zsmalloc */
+	snprintf(name, 38, "zswap%x", atomic_inc_return(&zswap_pools_count));
+	pool->zpool = zpool_create_pool(type, name, gfp);
+	if (!pool->zpool) {
+		pr_err("%s zpool not available\n", type);
+		goto error;
 	}
-	pr_debug("using %s zpool\n", zpool_get_type(pool->zpools[0]));
+	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
 	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 
@@ -318,8 +310,8 @@ ref_fail:
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
-	while (i--)
-		zpool_destroy_pool(pool->zpools[i]);
+	if (pool->zpool)
+		zpool_destroy_pool(pool->zpool);
 	kfree(pool);
 	return NULL;
 }
@@ -368,15 +360,12 @@ static struct zswap_pool *__zswap_pool_c
 
 static void zswap_pool_destroy(struct zswap_pool *pool)
 {
-	int i;
-
 	zswap_pool_debug("destroying", pool);
 
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 	free_percpu(pool->acomp_ctx);
 
-	for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
-		zpool_destroy_pool(pool->zpools[i]);
+	zpool_destroy_pool(pool->zpool);
 	kfree(pool);
 }
 
@@ -471,8 +460,7 @@ static struct zswap_pool *zswap_pool_fin
 	list_for_each_entry_rcu(pool, &zswap_pools, list) {
 		if (strcmp(pool->tfm_name, compressor))
 			continue;
-		/* all zpools share the same type */
-		if (strcmp(zpool_get_type(pool->zpools[0]), type))
+		if (strcmp(zpool_get_type(pool->zpool), type))
 			continue;
 		/* if we can't get it, it's about to be destroyed */
 		if (!zswap_pool_get(pool))
@@ -499,12 +487,8 @@ unsigned long zswap_total_pages(void)
 	unsigned long total = 0;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(pool, &zswap_pools, list) {
-		int i;
-
-		for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
-			total += zpool_get_total_pages(pool->zpools[i]);
-	}
+	list_for_each_entry_rcu(pool, &zswap_pools, list)
+		total += zpool_get_total_pages(pool->zpool);
 	rcu_read_unlock();
 
 	return total;
@@ -809,11 +793,6 @@ static void zswap_entry_cache_free(struc
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
-static struct zpool *zswap_find_zpool(struct zswap_entry *entry)
-{
-	return entry->pool->zpools[hash_ptr(entry, ilog2(ZSWAP_NR_ZPOOLS))];
-}
-
 /*
  * Carries out the common pattern of freeing and entry's zpool allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
@@ -824,7 +803,7 @@ static void zswap_entry_free(struct zswa
 		atomic_dec(&zswap_same_filled_pages);
 	else {
 		zswap_lru_del(&zswap_list_lru, entry);
-		zpool_free(zswap_find_zpool(entry), entry->handle);
+	zpool_free(entry->pool->zpool, entry->handle);
 		zswap_pool_put(entry->pool);
 	}
 	if (entry->objcg) {
@@ -950,7 +929,7 @@ static bool zswap_compress(struct folio
 	if (comp_ret)
 		goto unlock;
 
-	zpool = zswap_find_zpool(entry);
+	zpool = entry->pool->zpool;
 	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
 	if (zpool_malloc_support_movable(zpool))
 		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
@@ -979,7 +958,7 @@ unlock:
 
 static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
-	struct zpool *zpool = zswap_find_zpool(entry);
+	struct zpool *zpool = entry->pool->zpool;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
 	u8 *src;
@@ -1531,7 +1510,7 @@ store_failed:
 	if (!entry->length)
 		atomic_dec(&zswap_same_filled_pages);
 	else {
-		zpool_free(zswap_find_zpool(entry), entry->handle);
+		zpool_free(entry->pool->zpool, entry->handle);
 put_pool:
 		zswap_pool_put(entry->pool);
 	}
@@ -1753,7 +1732,7 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s/%s\n", pool->tfm_name,
-			zpool_get_type(pool->zpools[0]));
+			zpool_get_type(pool->zpool));
 		list_add(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are


