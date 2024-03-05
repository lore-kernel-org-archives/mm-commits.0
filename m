Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57AF9DB
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600517; cv=none; b=iKWl6CIYcMGpv63eZyNdR/JlTQ7vbXB0sOdPvuv19qQlZWLwXM40jtCk2kLtgJO1MRHaE7IVRYzN68w3/yqphsoYlptJ2/12zyGkJhs5LmsMis7Tlcw13fxcnsaBr+kKPnQ0N0sQS9yIAQktJN2sk4zKbHhYCHRxyKcgORzUeWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600517; c=relaxed/simple;
	bh=4miVDtwJRn/wub+Y9FgjzhhmUV/LPLdSnrVid0If+dg=;
	h=Date:To:From:Subject:Message-Id; b=ffGkfvX/pNZP5gBA58mZ99jnEaMDs8HCVaC+F9aHDfZxRJIrMTF2mP7wI0JqiyhfaF2oRN0m1UxwRIldfPL3d/e16crsSQpGXvycfJxMxbLaC/R02d8sB/v2xhXHEsowpQF5gxIaubWzFjbJwIbN4kZ3D12P3rdm3szgKypjHkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C0/UqP+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C0/UqP+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F31BC433C7;
	Tue,  5 Mar 2024 01:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600516;
	bh=4miVDtwJRn/wub+Y9FgjzhhmUV/LPLdSnrVid0If+dg=;
	h=Date:To:From:Subject:From;
	b=C0/UqP+IiLrzq+U2PbCIDsQdcfPea1FYFcZrGlkbhwGVq/2Y9nUepSF9sXnZJDmRa
	 HwzLkdnrEmXt4JJ6hQXOm+85QQvd47lA6n2Arci3DCgydv01Ce56qbMNBH1IlDU9lO
	 KrrxCayvrUyWAsAWPdeoBTYZfzudWDds5m6S6S7A=
Date: Mon, 04 Mar 2024 17:01:55 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch removed from -mm tree
Message-Id: <20240305010156.8F31BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: global lru and shrinker shared by all zswap_pools
has been removed from the -mm tree.  Its filename was
     mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: global lru and shrinker shared by all zswap_pools
Date: Fri, 16 Feb 2024 08:55:04 +0000

Patch series "mm/zswap: optimize for dynamic zswap_pools", v3.

Dynamic pool creation has been supported for a long time, which maybe not
used so much in practice.  But with the per-memcg lru merged, the current
structure of zswap_pool's lru and shrinker become less optimal.

In the current structure, each zswap_pool has its own lru, shrinker and
shrink_work, but only the latest zswap_pool will be the current used.

1. When memory has pressure, all shrinkers of zswap_pools will try to
   shrink its lru list, there is no order between them.

2. When zswap limit hit, only the last zswap_pool's shrink_work will
   try to shrink its own lru, which is inefficient.

A more natural way is to have a global zswap lru shared between all
zswap_pools, and so is the shrinker. The code becomes much simpler too.

Another optimization is changing zswap_pool kref to percpu_ref, which will
be taken reference by every zswap entry.  So the scalability is better.

Testing kernel build (32 threads) in tmpfs with memory.max=2GB.  (zswap
shrinker and writeback enabled with one 50GB swapfile, on a 128 CPUs
x86-64 machine, below is the average of 5 runs)

        mm-unstable  zswap-global-lru
real    63.20        63.12
user    1061.75      1062.95
sys     268.74       264.44


This patch (of 3):

Dynamic zswap_pool creation may create/reuse to have multiple zswap_pools
in a list, only the first will be current used.

Each zswap_pool has its own lru and shrinker, which is not necessary and
has its problem:

1. When memory has pressure, all shrinker of zswap_pools will
   try to shrink its own lru, there is no order between them.

2. When zswap limit hit, only the last zswap_pool's shrink_work
   will try to shrink its lru list. The rationale here was to
   try and empty the old pool first so that we can completely
   drop it. However, since we only support exclusive loads now,
   the LRU ordering should be entirely decided by the order of
   stores, so the oldest entries on the LRU will naturally be
   from the oldest pool.

Anyway, having a global lru and shrinker shared by all zswap_pools is
better and efficient.

Link: https://lkml.kernel.org/r/20240210-zswap-global-lru-v3-0-200495333595@bytedance.com
Link: https://lkml.kernel.org/r/20240210-zswap-global-lru-v3-1-200495333595@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  171 +++++++++++++++++++--------------------------------
 1 file changed, 66 insertions(+), 105 deletions(-)

--- a/mm/zswap.c~mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools
+++ a/mm/zswap.c
@@ -176,14 +176,19 @@ struct zswap_pool {
 	struct kref kref;
 	struct list_head list;
 	struct work_struct release_work;
-	struct work_struct shrink_work;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
+};
+
+static struct {
 	struct list_lru list_lru;
-	struct mem_cgroup *next_shrink;
-	struct shrinker *shrinker;
 	atomic_t nr_stored;
-};
+	struct shrinker *shrinker;
+	struct work_struct shrink_work;
+	struct mem_cgroup *next_shrink;
+	/* The lock protects next_shrink. */
+	spinlock_t shrink_lock;
+} zswap;
 
 /*
  * struct zswap_entry
@@ -301,9 +306,6 @@ static void zswap_update_total_size(void
 * pool functions
 **********************************/
 
-static void zswap_alloc_shrinker(struct zswap_pool *pool);
-static void shrink_worker(struct work_struct *w);
-
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
 	int i;
@@ -353,30 +355,16 @@ static struct zswap_pool *zswap_pool_cre
 	if (ret)
 		goto error;
 
-	zswap_alloc_shrinker(pool);
-	if (!pool->shrinker)
-		goto error;
-
-	pr_debug("using %s compressor\n", pool->tfm_name);
-
 	/* being the current pool takes 1 ref; this func expects the
 	 * caller to always add the new pool as the current pool
 	 */
 	kref_init(&pool->kref);
 	INIT_LIST_HEAD(&pool->list);
-	if (list_lru_init_memcg(&pool->list_lru, pool->shrinker))
-		goto lru_fail;
-	shrinker_register(pool->shrinker);
-	INIT_WORK(&pool->shrink_work, shrink_worker);
-	atomic_set(&pool->nr_stored, 0);
 
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
-lru_fail:
-	list_lru_destroy(&pool->list_lru);
-	shrinker_free(pool->shrinker);
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -434,15 +422,8 @@ static void zswap_pool_destroy(struct zs
 
 	zswap_pool_debug("destroying", pool);
 
-	shrinker_free(pool->shrinker);
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 	free_percpu(pool->acomp_ctx);
-	list_lru_destroy(&pool->list_lru);
-
-	spin_lock(&zswap_pools_lock);
-	mem_cgroup_iter_break(NULL, pool->next_shrink);
-	pool->next_shrink = NULL;
-	spin_unlock(&zswap_pools_lock);
 
 	for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
 		zpool_destroy_pool(pool->zpools[i]);
@@ -529,24 +510,6 @@ static struct zswap_pool *zswap_pool_cur
 	return pool;
 }
 
-static struct zswap_pool *zswap_pool_last_get(void)
-{
-	struct zswap_pool *pool, *last = NULL;
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(pool, &zswap_pools, list)
-		last = pool;
-	WARN_ONCE(!last && zswap_has_pool,
-		  "%s: no page storage pool!\n", __func__);
-	if (!zswap_pool_get(last))
-		last = NULL;
-
-	rcu_read_unlock();
-
-	return last;
-}
-
 /* type and compressor must be null-terminated */
 static struct zswap_pool *zswap_pool_find_get(char *type, char *compressor)
 {
@@ -816,15 +779,11 @@ void zswap_folio_swapin(struct folio *fo
 
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
 {
-	struct zswap_pool *pool;
-
-	/* lock out zswap pools list modification */
-	spin_lock(&zswap_pools_lock);
-	list_for_each_entry(pool, &zswap_pools, list) {
-		if (pool->next_shrink == memcg)
-			pool->next_shrink = mem_cgroup_iter(NULL, pool->next_shrink, NULL);
-	}
-	spin_unlock(&zswap_pools_lock);
+	/* lock out zswap shrinker walking memcg tree */
+	spin_lock(&zswap.shrink_lock);
+	if (zswap.next_shrink == memcg)
+		zswap.next_shrink = mem_cgroup_iter(NULL, zswap.next_shrink, NULL);
+	spin_unlock(&zswap.shrink_lock);
 }
 
 /*********************************
@@ -923,9 +882,9 @@ static void zswap_entry_free(struct zswa
 	if (!entry->length)
 		atomic_dec(&zswap_same_filled_pages);
 	else {
-		zswap_lru_del(&entry->pool->list_lru, entry);
+		zswap_lru_del(&zswap.list_lru, entry);
 		zpool_free(zswap_find_zpool(entry), entry->handle);
-		atomic_dec(&entry->pool->nr_stored);
+		atomic_dec(&zswap.nr_stored);
 		zswap_pool_put(entry->pool);
 	}
 	if (entry->objcg) {
@@ -1287,7 +1246,6 @@ static unsigned long zswap_shrinker_scan
 {
 	struct lruvec *lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
 	unsigned long shrink_ret, nr_protected, lru_size;
-	struct zswap_pool *pool = shrinker->private_data;
 	bool encountered_page_in_swapcache = false;
 
 	if (!zswap_shrinker_enabled ||
@@ -1298,7 +1256,7 @@ static unsigned long zswap_shrinker_scan
 
 	nr_protected =
 		atomic_long_read(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	lru_size = list_lru_shrink_count(&pool->list_lru, sc);
+	lru_size = list_lru_shrink_count(&zswap.list_lru, sc);
 
 	/*
 	 * Abort if we are shrinking into the protected region.
@@ -1315,7 +1273,7 @@ static unsigned long zswap_shrinker_scan
 		return SHRINK_STOP;
 	}
 
-	shrink_ret = list_lru_shrink_walk(&pool->list_lru, sc, &shrink_memcg_cb,
+	shrink_ret = list_lru_shrink_walk(&zswap.list_lru, sc, &shrink_memcg_cb,
 		&encountered_page_in_swapcache);
 
 	if (encountered_page_in_swapcache)
@@ -1327,7 +1285,6 @@ static unsigned long zswap_shrinker_scan
 static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
-	struct zswap_pool *pool = shrinker->private_data;
 	struct mem_cgroup *memcg = sc->memcg;
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(sc->nid));
 	unsigned long nr_backing, nr_stored, nr_freeable, nr_protected;
@@ -1341,8 +1298,8 @@ static unsigned long zswap_shrinker_coun
 	nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 #else
 	/* use pool stats instead of memcg stats */
-	nr_backing = get_zswap_pool_size(pool) >> PAGE_SHIFT;
-	nr_stored = atomic_read(&pool->nr_stored);
+	nr_backing = zswap_pool_total_size >> PAGE_SHIFT;
+	nr_stored = atomic_read(&zswap.nr_stored);
 #endif
 
 	if (!nr_stored)
@@ -1350,7 +1307,7 @@ static unsigned long zswap_shrinker_coun
 
 	nr_protected =
 		atomic_long_read(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	nr_freeable = list_lru_shrink_count(&pool->list_lru, sc);
+	nr_freeable = list_lru_shrink_count(&zswap.list_lru, sc);
 	/*
 	 * Subtract the lru size by an estimate of the number of pages
 	 * that should be protected.
@@ -1366,23 +1323,24 @@ static unsigned long zswap_shrinker_coun
 	return mult_frac(nr_freeable, nr_backing, nr_stored);
 }
 
-static void zswap_alloc_shrinker(struct zswap_pool *pool)
+static struct shrinker *zswap_alloc_shrinker(void)
 {
-	pool->shrinker =
+	struct shrinker *shrinker;
+
+	shrinker =
 		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
-	if (!pool->shrinker)
-		return;
+	if (!shrinker)
+		return NULL;
 
-	pool->shrinker->private_data = pool;
-	pool->shrinker->scan_objects = zswap_shrinker_scan;
-	pool->shrinker->count_objects = zswap_shrinker_count;
-	pool->shrinker->batch = 0;
-	pool->shrinker->seeks = DEFAULT_SEEKS;
+	shrinker->scan_objects = zswap_shrinker_scan;
+	shrinker->count_objects = zswap_shrinker_count;
+	shrinker->batch = 0;
+	shrinker->seeks = DEFAULT_SEEKS;
+	return shrinker;
 }
 
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
-	struct zswap_pool *pool;
 	int nid, shrunk = 0;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
@@ -1395,32 +1353,25 @@ static int shrink_memcg(struct mem_cgrou
 	if (memcg && !mem_cgroup_online(memcg))
 		return -ENOENT;
 
-	pool = zswap_pool_current_get();
-	if (!pool)
-		return -EINVAL;
-
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
 		unsigned long nr_to_walk = 1;
 
-		shrunk += list_lru_walk_one(&pool->list_lru, nid, memcg,
+		shrunk += list_lru_walk_one(&zswap.list_lru, nid, memcg,
 					    &shrink_memcg_cb, NULL, &nr_to_walk);
 	}
-	zswap_pool_put(pool);
 	return shrunk ? 0 : -EAGAIN;
 }
 
 static void shrink_worker(struct work_struct *w)
 {
-	struct zswap_pool *pool = container_of(w, typeof(*pool),
-						shrink_work);
 	struct mem_cgroup *memcg;
 	int ret, failures = 0;
 
 	/* global reclaim will select cgroup in a round-robin fashion. */
 	do {
-		spin_lock(&zswap_pools_lock);
-		pool->next_shrink = mem_cgroup_iter(NULL, pool->next_shrink, NULL);
-		memcg = pool->next_shrink;
+		spin_lock(&zswap.shrink_lock);
+		zswap.next_shrink = mem_cgroup_iter(NULL, zswap.next_shrink, NULL);
+		memcg = zswap.next_shrink;
 
 		/*
 		 * We need to retry if we have gone through a full round trip, or if we
@@ -1434,7 +1385,7 @@ static void shrink_worker(struct work_st
 		 * memcg is not killed when we are reclaiming.
 		 */
 		if (!memcg) {
-			spin_unlock(&zswap_pools_lock);
+			spin_unlock(&zswap.shrink_lock);
 			if (++failures == MAX_RECLAIM_RETRIES)
 				break;
 
@@ -1444,15 +1395,15 @@ static void shrink_worker(struct work_st
 		if (!mem_cgroup_tryget_online(memcg)) {
 			/* drop the reference from mem_cgroup_iter() */
 			mem_cgroup_iter_break(NULL, memcg);
-			pool->next_shrink = NULL;
-			spin_unlock(&zswap_pools_lock);
+			zswap.next_shrink = NULL;
+			spin_unlock(&zswap.shrink_lock);
 
 			if (++failures == MAX_RECLAIM_RETRIES)
 				break;
 
 			goto resched;
 		}
-		spin_unlock(&zswap_pools_lock);
+		spin_unlock(&zswap.shrink_lock);
 
 		ret = shrink_memcg(memcg);
 		/* drop the extra reference */
@@ -1466,7 +1417,6 @@ static void shrink_worker(struct work_st
 resched:
 		cond_resched();
 	} while (!zswap_can_accept());
-	zswap_pool_put(pool);
 }
 
 static int zswap_is_page_same_filled(void *ptr, unsigned long *value)
@@ -1507,7 +1457,6 @@ bool zswap_store(struct folio *folio)
 	struct zswap_entry *entry, *dupentry;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
-	struct zswap_pool *shrink_pool;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1575,7 +1524,7 @@ bool zswap_store(struct folio *folio)
 
 	if (objcg) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		if (memcg_list_lru_alloc(memcg, &entry->pool->list_lru, GFP_KERNEL)) {
+		if (memcg_list_lru_alloc(memcg, &zswap.list_lru, GFP_KERNEL)) {
 			mem_cgroup_put(memcg);
 			goto put_pool;
 		}
@@ -1606,8 +1555,8 @@ insert_entry:
 	}
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(&entry->pool->list_lru, entry);
-		atomic_inc(&entry->pool->nr_stored);
+		zswap_lru_add(&zswap.list_lru, entry);
+		atomic_inc(&zswap.nr_stored);
 	}
 	spin_unlock(&tree->lock);
 
@@ -1639,9 +1588,7 @@ check_old:
 	return false;
 
 shrink:
-	shrink_pool = zswap_pool_last_get();
-	if (shrink_pool && !queue_work(shrink_wq, &shrink_pool->shrink_work))
-		zswap_pool_put(shrink_pool);
+	queue_work(shrink_wq, &zswap.shrink_work);
 	goto reject;
 }
 
@@ -1803,6 +1750,22 @@ static int zswap_setup(void)
 	if (ret)
 		goto hp_fail;
 
+	shrink_wq = alloc_workqueue("zswap-shrink",
+			WQ_UNBOUND|WQ_MEM_RECLAIM, 1);
+	if (!shrink_wq)
+		goto shrink_wq_fail;
+
+	zswap.shrinker = zswap_alloc_shrinker();
+	if (!zswap.shrinker)
+		goto shrinker_fail;
+	if (list_lru_init_memcg(&zswap.list_lru, zswap.shrinker))
+		goto lru_fail;
+	shrinker_register(zswap.shrinker);
+
+	INIT_WORK(&zswap.shrink_work, shrink_worker);
+	atomic_set(&zswap.nr_stored, 0);
+	spin_lock_init(&zswap.shrink_lock);
+
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s/%s\n", pool->tfm_name,
@@ -1814,19 +1777,17 @@ static int zswap_setup(void)
 		zswap_enabled = false;
 	}
 
-	shrink_wq = alloc_workqueue("zswap-shrink",
-			WQ_UNBOUND|WQ_MEM_RECLAIM, 1);
-	if (!shrink_wq)
-		goto fallback_fail;
-
 	if (zswap_debugfs_init())
 		pr_warn("debugfs initialization failed\n");
 	zswap_init_state = ZSWAP_INIT_SUCCEED;
 	return 0;
 
-fallback_fail:
-	if (pool)
-		zswap_pool_destroy(pool);
+lru_fail:
+	shrinker_free(zswap.shrinker);
+shrinker_fail:
+	destroy_workqueue(shrink_wq);
+shrink_wq_fail:
+	cpuhp_remove_multi_state(CPUHP_MM_ZSWP_POOL_PREPARE);
 hp_fail:
 	kmem_cache_destroy(zswap_entry_cache);
 cache_fail:
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are


