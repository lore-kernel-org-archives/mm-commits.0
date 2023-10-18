Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743A1CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 20:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjJRUJt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 16:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjJRUJq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 16:09:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D014112
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 13:09:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD560C433C7;
        Wed, 18 Oct 2023 20:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697659783;
        bh=+CvLrdL5Wx9TKS4alxm27LXUTCvbRiZCrppy6lac+tw=;
        h=Date:To:From:Subject:From;
        b=n/AwDuqjcy68ZhdQMuBrWcozzGxP/XIN3hTXMHk8xytFldD1O69QZgGK6ktD7wF+T
         NAjz+sgy+irOaF5gjexz9QwKB+zT5mS0D48G5wxW054X1I365+B/M66bplmFV3EAEA
         7ejYuU2ZQXDYgXNGsE0AnnH28xCdk62g7JCuTRyw=
Date:   Wed, 18 Oct 2023 13:09:43 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-shrinks-zswap-pool-based-on-memory-pressure.patch added to mm-unstable branch
Message-Id: <20231018200943.AD560C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: shrinks zswap pool based on memory pressure
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-shrinks-zswap-pool-based-on-memory-pressure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-shrinks-zswap-pool-based-on-memory-pressure.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: shrinks zswap pool based on memory pressure
Date: Tue, 17 Oct 2023 16:21:52 -0700

Currently, we only shrink the zswap pool when the user-defined limit is
hit.  This means that if we set the limit too high, cold data that are
unlikely to be used again will reside in the pool, wasting precious
memory.  It is hard to predict how much zswap space will be needed ahead
of time, as this depends on the workload (specifically, on factors such as
memory access patterns and compressibility of the memory pages).

This patch implements a memcg- and NUMA-aware shrinker for zswap, that is
initiated when there is memory pressure.  The shrinker does not have any
parameter that must be tuned by the user, and can be opted in or out on a
per-memcg basis.

Furthermore, to make it more robust for many workloads and prevent
overshrinking (i.e evicting warm pages that might be refaulted into
memory), we build in the following heuristics:

* Estimate the number of warm pages residing in zswap, and attempt to
  protect this region of the zswap LRU.
* Scale the number of freeable objects by an estimate of the memory
  saving factor. The better zswap compresses the data, the fewer pages
  we will evict to swap (as we will otherwise incur IO for relatively
  small memory saving).
* During reclaim, if the shrinker encounters a page that is also being
  brought into memory, the shrinker will cautiously terminate its
  shrinking action, as this is a sign that it is touching the warmer
  region of the zswap LRU.

As a proof of concept, we ran the following synthetic benchmark: build the
linux kernel in a memory-limited cgroup, and allocate some cold data in
tmpfs to see if the shrinker could write them out and improved the overall
performance.  Depending on the amount of cold data generated, we observe
from 14% to 35% reduction in kernel CPU time used in the kernel builds.

Link: https://lkml.kernel.org/r/20231017232152.2605440-6-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/zswap.rst |    7 +
 include/linux/mmzone.h                 |   14 ++
 mm/mmzone.c                            |    3 
 mm/swap_state.c                        |   21 ++-
 mm/zswap.c                             |  161 ++++++++++++++++++++++-
 5 files changed, 196 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/mm/zswap.rst~zswap-shrinks-zswap-pool-based-on-memory-pressure
+++ a/Documentation/admin-guide/mm/zswap.rst
@@ -153,6 +153,13 @@ attribute, e. g.::
 
 Setting this parameter to 100 will disable the hysteresis.
 
+When there is a sizable amount of cold memory residing in the zswap pool, it
+can be advantageous to proactively write these cold pages to swap and reclaim
+the memory for other use cases. By default, the zswap shrinker is disabled.
+User can enable it as follows:
+
+  echo Y > /sys/module/zswap/parameters/shrinker_enabled
+
 A debugfs interface is provided for various statistic about pool size, number
 of pages stored, same-value filled pages and various counters for the reasons
 pages are rejected.
--- a/include/linux/mmzone.h~zswap-shrinks-zswap-pool-based-on-memory-pressure
+++ a/include/linux/mmzone.h
@@ -637,6 +637,20 @@ struct lruvec {
 #ifdef CONFIG_MEMCG
 	struct pglist_data *pgdat;
 #endif
+#ifdef CONFIG_ZSWAP
+	/*
+	 * Number of pages in zswap that should be protected from the shrinker.
+	 * This number is an estimate of the following counts:
+	 *
+	 * a) Recent page faults.
+	 * b) Recent insertion to the zswap LRU. This includes new zswap stores,
+	 *    as well as recent zswap LRU rotations.
+	 *
+	 * These pages are likely to be warm, and might incur IO if the are written
+	 * to swap.
+	 */
+	atomic_long_t nr_zswap_protected;
+#endif
 };
 
 /* Isolate for asynchronous migration */
--- a/mm/mmzone.c~zswap-shrinks-zswap-pool-based-on-memory-pressure
+++ a/mm/mmzone.c
@@ -78,6 +78,9 @@ void lruvec_init(struct lruvec *lruvec)
 
 	memset(lruvec, 0, sizeof(struct lruvec));
 	spin_lock_init(&lruvec->lru_lock);
+#ifdef CONFIG_ZSWAP
+	atomic_long_set(&lruvec->nr_zswap_protected, 0);
+#endif
 
 	for_each_lru(lru)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
--- a/mm/swap_state.c~zswap-shrinks-zswap-pool-based-on-memory-pressure
+++ a/mm/swap_state.c
@@ -676,7 +676,15 @@ struct page *swap_cluster_readahead(swp_
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
-	return read_swap_cache_async(entry, gfp_mask, vma, addr, NULL);
+	page = read_swap_cache_async(entry, gfp_mask, vma, addr, NULL);
+#ifdef CONFIG_ZSWAP
+	if (page) {
+		struct lruvec *lruvec = folio_lruvec(page_folio(page));
+
+		atomic_long_inc(&lruvec->nr_zswap_protected);
+	}
+#endif
+	return page;
 }
 
 int init_swap_address_space(unsigned int type, unsigned long nr_pages)
@@ -843,8 +851,15 @@ static struct page *swap_vma_readahead(s
 	lru_add_drain();
 skip:
 	/* The page was likely read above, so no need for plugging here */
-	return read_swap_cache_async(fentry, gfp_mask, vma, vmf->address,
-				     NULL);
+	page = read_swap_cache_async(fentry, gfp_mask, vma, vmf->address, NULL);
+#ifdef CONFIG_ZSWAP
+	if (page) {
+		struct lruvec *lruvec = folio_lruvec(page_folio(page));
+
+		atomic_long_inc(&lruvec->nr_zswap_protected);
+	}
+#endif
+	return page;
 }
 
 /**
--- a/mm/zswap.c~zswap-shrinks-zswap-pool-based-on-memory-pressure
+++ a/mm/zswap.c
@@ -145,6 +145,10 @@ module_param_named(exclusive_loads, zswa
 /* Number of zpools in zswap_pool (empirically determined for scalability) */
 #define ZSWAP_NR_ZPOOLS 32
 
+/* Enable/disable memory pressure-based shrinker. */
+static bool zswap_shrinker_enabled;
+module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644);
+
 /*********************************
 * data structures
 **********************************/
@@ -174,6 +178,8 @@ struct zswap_pool {
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 	struct list_lru list_lru;
 	struct mem_cgroup *next_shrink;
+	struct shrinker *shrinker;
+	atomic_t nr_stored;
 };
 
 /*
@@ -272,17 +278,26 @@ static bool zswap_can_accept(void)
 			DIV_ROUND_UP(zswap_pool_total_size, PAGE_SIZE);
 }
 
+static u64 get_zswap_pool_size(struct zswap_pool *pool)
+{
+	u64 pool_size = 0;
+	int i;
+
+	for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
+		pool_size += zpool_get_total_size(pool->zpools[i]);
+
+	return pool_size;
+}
+
 static void zswap_update_total_size(void)
 {
 	struct zswap_pool *pool;
 	u64 total = 0;
-	int i;
 
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(pool, &zswap_pools, list)
-		for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
-			total += zpool_get_total_size(pool->zpools[i]);
+		total += get_zswap_pool_size(pool);
 
 	rcu_read_unlock();
 
@@ -326,8 +341,24 @@ static void zswap_entry_cache_free(struc
 static bool zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
 {
 	struct mem_cgroup *memcg = get_mem_cgroup_from_entry(entry);
-	bool added = __list_lru_add(list_lru, &entry->lru, entry_to_nid(entry), memcg);
-
+	int nid = entry_to_nid(entry);
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	bool added = __list_lru_add(list_lru, &entry->lru, nid, memcg);
+	unsigned long lru_size, old, new;
+
+	if (added) {
+		lru_size = list_lru_count_one(list_lru, entry_to_nid(entry), memcg);
+		old = atomic_long_inc_return(&lruvec->nr_zswap_protected);
+
+		/*
+		 * Decay to avoid overflow and adapt to changing workloads.
+		 * This is based on LRU reclaim cost decaying heuristics.
+		 */
+		do {
+			new = old > lru_size / 4 ? old / 2 : old;
+		} while (
+			!atomic_long_try_cmpxchg(&lruvec->nr_zswap_protected, &old, new));
+	}
 	mem_cgroup_put(memcg);
 	return added;
 }
@@ -427,6 +458,7 @@ static void zswap_free_entry(struct zswa
 	else {
 		zswap_lru_del(&entry->pool->list_lru, entry);
 		zpool_free(zswap_find_zpool(entry), entry->handle);
+		atomic_dec(&entry->pool->nr_stored);
 		zswap_pool_put(entry->pool);
 	}
 	zswap_entry_cache_free(entry);
@@ -469,6 +501,93 @@ static struct zswap_entry *zswap_entry_f
 }
 
 /*********************************
+* shrinker functions
+**********************************/
+static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
+				       spinlock_t *lock, void *arg);
+
+static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
+		struct shrink_control *sc)
+{
+	struct lruvec *lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
+	unsigned long shrink_ret, nr_protected, lru_size;
+	struct zswap_pool *pool = shrinker->private_data;
+	bool encountered_page_in_swapcache = false;
+
+	nr_protected = atomic_long_read(&lruvec->nr_zswap_protected);
+	lru_size = list_lru_shrink_count(&pool->list_lru, sc);
+
+	/*
+	 * Abort if the shrinker is disabled or if we are shrinking into the
+	 * protected region.
+	 */
+	if (!zswap_shrinker_enabled || nr_protected >= lru_size - sc->nr_to_scan) {
+		sc->nr_scanned = 0;
+		return SHRINK_STOP;
+	}
+
+	shrink_ret = list_lru_shrink_walk(&pool->list_lru, sc, &shrink_memcg_cb,
+		&encountered_page_in_swapcache);
+
+	if (encountered_page_in_swapcache)
+		return SHRINK_STOP;
+
+	return shrink_ret ? shrink_ret : SHRINK_STOP;
+}
+
+static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
+		struct shrink_control *sc)
+{
+	struct zswap_pool *pool = shrinker->private_data;
+	struct mem_cgroup *memcg = sc->memcg;
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(sc->nid));
+	unsigned long nr_backing, nr_stored, nr_freeable, nr_protected;
+
+#ifdef CONFIG_MEMCG_KMEM
+	cgroup_rstat_flush(memcg->css.cgroup);
+	nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
+	nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
+#else
+	/* use pool stats instead of memcg stats */
+	nr_backing = get_zswap_pool_size(pool) >> PAGE_SHIFT;
+	nr_stored = atomic_read(&pool->nr_stored);
+#endif
+
+	if (!zswap_shrinker_enabled || !nr_stored)
+		return 0;
+
+	nr_protected = atomic_long_read(&lruvec->nr_zswap_protected);
+	nr_freeable = list_lru_shrink_count(&pool->list_lru, sc);
+	/*
+	 * Subtract the lru size by an estimate of the number of pages
+	 * that should be protected.
+	 */
+	nr_freeable = nr_freeable > nr_protected ? nr_freeable - nr_protected : 0;
+
+	/*
+	 * Scale the number of freeable pages by the memory saving factor.
+	 * This ensures that the better zswap compresses memory, the fewer
+	 * pages we will evict to swap (as it will otherwise incur IO for
+	 * relatively small memory saving).
+	 */
+	return mult_frac(nr_freeable, nr_backing, nr_stored);
+}
+
+static void zswap_alloc_shrinker(struct zswap_pool *pool)
+{
+	pool->shrinker =
+		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	if (!pool->shrinker)
+		return;
+
+	pool->shrinker->private_data = pool;
+	pool->shrinker->scan_objects = zswap_shrinker_scan;
+	pool->shrinker->count_objects = zswap_shrinker_count;
+	pool->shrinker->batch = 0;
+	pool->shrinker->seeks = DEFAULT_SEEKS;
+}
+
+/*********************************
 * per-cpu code
 **********************************/
 static DEFINE_PER_CPU(u8 *, zswap_dstmem);
@@ -663,8 +782,10 @@ static enum lru_status shrink_memcg_cb(s
 				       spinlock_t *lock, void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
+	bool *encountered_page_in_swapcache = (bool *)arg;
 	struct mem_cgroup *memcg;
 	struct zswap_tree *tree;
+	struct lruvec *lruvec;
 	pgoff_t swpoffset;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
@@ -698,8 +819,22 @@ static enum lru_status shrink_memcg_cb(s
 		/* we cannot use zswap_lru_add here, because it increments node's lru count */
 		list_lru_putback(&entry->pool->list_lru, item, entry_to_nid(entry), memcg);
 		spin_unlock(lock);
-		mem_cgroup_put(memcg);
 		ret = LRU_RETRY;
+
+		/*
+		 * Encountering a page already in swap cache is a sign that we are shrinking
+		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
+		 * shrinker context).
+		 */
+		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+			ret = LRU_SKIP;
+			*encountered_page_in_swapcache = true;
+		}
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(entry_to_nid(entry)));
+		/* Increment the protection area to account for the LRU rotation. */
+		atomic_long_inc(&lruvec->nr_zswap_protected);
+
+		mem_cgroup_put(memcg);
 		goto put_unlock;
 	}
 	zswap_written_back_pages++;
@@ -822,6 +957,11 @@ static struct zswap_pool *zswap_pool_cre
 				       &pool->node);
 	if (ret)
 		goto error;
+
+	zswap_alloc_shrinker(pool);
+	if (!pool->shrinker)
+		goto error;
+
 	pr_debug("using %s compressor\n", pool->tfm_name);
 
 	/* being the current pool takes 1 ref; this func expects the
@@ -829,13 +969,18 @@ static struct zswap_pool *zswap_pool_cre
 	 */
 	kref_init(&pool->kref);
 	INIT_LIST_HEAD(&pool->list);
-	list_lru_init_memcg(&pool->list_lru, NULL);
+	if (list_lru_init_memcg(&pool->list_lru, pool->shrinker))
+		goto lru_fail;
+	shrinker_register(pool->shrinker);
 	INIT_WORK(&pool->shrink_work, shrink_worker);
 
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
+lru_fail:
+	list_lru_destroy(&pool->list_lru);
+	shrinker_free(pool->shrinker);
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -893,6 +1038,7 @@ static void zswap_pool_destroy(struct zs
 
 	zswap_pool_debug("destroying", pool);
 
+	shrinker_free(pool->shrinker);
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 	free_percpu(pool->acomp_ctx);
 	list_lru_destroy(&pool->list_lru);
@@ -1440,6 +1586,7 @@ insert_entry:
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
 		zswap_lru_add(&pool->list_lru, entry);
+		atomic_inc(&pool->nr_stored);
 	}
 	spin_unlock(&tree->lock);
 
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-list_lru-allow-external-numa-node-and-cgroup-tracking.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
memcontrol-add-helpers-for-hugetlb-memcg-accounting.patch
memcontrol-only-transfer-the-memcg-data-for-migration.patch
hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller.patch
selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg.patch

