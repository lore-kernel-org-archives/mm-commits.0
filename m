Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE53D4084B
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884617; cv=none; b=oVSohmniACcsfbv/w1gf8qdmzqO2+vO7Vq4y1ACAPm574DDSLHLHDytEQQI+FJBLULfIv58fnfv6t+NAiDHviK9oEKHuuQF2aGYZIbDyRnvaS7o0qxsZZofq4PiaFmonLYm+VMwbzHx9aF4wgBX55+cQDxw9TOCoFNZaGV9QV2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884617; c=relaxed/simple;
	bh=Q2DMR3mtOJsQgyirNEm56wHRlrSG+2MsrWSMZft0Zps=;
	h=Date:To:From:Subject:Message-Id; b=ERSo4kHQuboX4O9o4odPd4mQnKsCIDh/2RoxaCBq51/XBGj1fQoz585rHE8hmw3Cq75mUjchiT9GPaFYAYj0xzlWU+EvYK5Y3fmNtWKjaZrKeLofmGpmF95XpiZgrdpskk6+QOHs3FnPd0e5GnsAeykQjjzdbhknXLohHmPIAy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pFsPDk/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pFsPDk/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DBEC433C7;
	Tue, 19 Mar 2024 21:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710884617;
	bh=Q2DMR3mtOJsQgyirNEm56wHRlrSG+2MsrWSMZft0Zps=;
	h=Date:To:From:Subject:From;
	b=pFsPDk/JbZNrkP8RBaFnGCAJpncYrd7I534IMA3hnVEor4W0iSei8ICxjBugoJWU/
	 McCZF1WlvVa4rn/qT4G/mAor59XYLHDGyKqL2O2c2ll+5ZmzY+kPIM0Q0YNDK7Hcw9
	 SrGIPpncIcN3zQgXjnrO6bD7qwaX4KpYDFd7Okr0=
Date: Tue, 19 Mar 2024 14:43:36 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,chengming.zhou@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-optimize-zswap-pool-size-tracking.patch added to mm-unstable branch
Message-Id: <20240319214337.52DBEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: optimize zswap pool size tracking
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-optimize-zswap-pool-size-tracking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-optimize-zswap-pool-size-tracking.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: optimize zswap pool size tracking
Date: Tue, 12 Mar 2024 11:34:11 -0400

Profiling the munmap() of a zswapped memory region shows 60% of the total
cycles currently going into updating the zswap_pool_total_size.

There are three consumers of this counter:
- store, to enforce the globally configured pool limit
- meminfo & debugfs, to report the size to the user
- shrink, to determine the batch size for each cycle

Instead of aggregating everytime an entry enters or exits the zswap
pool, aggregate the value from the zpools on-demand:

- Stores aggregate the counter anyway upon success. Aggregating to
  check the limit instead is the same amount of work.

- Meminfo & debugfs might benefit somewhat from a pre-aggregated
  counter, but aren't exactly hotpaths.

- Shrinking can aggregate once for every cycle instead of doing it for
  every freed entry. As the shrinker might work on tens or hundreds of
  objects per scan cycle, this is a large reduction in aggregations.

The paths that benefit dramatically are swapin, swapoff, and unmaps. 
There could be millions of pages being processed until somebody asks for
the pool size again.  This eliminates the pool size updates from those
paths entirely.

Top profile entries for a 24G range munmap(), before:

    38.54%  zswap-unmap  [kernel.kallsyms]  [k] zs_zpool_total_size
    12.51%  zswap-unmap  [kernel.kallsyms]  [k] zpool_get_total_size
     9.10%  zswap-unmap  [kernel.kallsyms]  [k] zswap_update_total_size
     2.95%  zswap-unmap  [kernel.kallsyms]  [k] obj_cgroup_uncharge_zswap
     2.88%  zswap-unmap  [kernel.kallsyms]  [k] __slab_free
     2.86%  zswap-unmap  [kernel.kallsyms]  [k] xas_store

and after:

     7.70%  zswap-unmap  [kernel.kallsyms]  [k] __slab_free
     7.16%  zswap-unmap  [kernel.kallsyms]  [k] obj_cgroup_uncharge_zswap
     6.74%  zswap-unmap  [kernel.kallsyms]  [k] xas_store

It was also briefly considered to move to a single atomic in zswap
that is updated by the backends, since zswap only cares about the sum
of all pools anyway. However, zram directly needs per-pool information
out of zsmalloc. To keep the backend from having to update two atomics
every time, I opted for the lazy aggregation instead for now.

Link: https://lkml.kernel.org/r/20240312153901.3441-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c     |    3 -
 include/linux/zswap.h |    2 
 mm/zswap.c            |  101 +++++++++++++++++++---------------------
 3 files changed, 52 insertions(+), 54 deletions(-)

--- a/fs/proc/meminfo.c~mm-zswap-optimize-zswap-pool-size-tracking
+++ a/fs/proc/meminfo.c
@@ -89,8 +89,7 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "SwapTotal:      ", i.totalswap);
 	show_val_kb(m, "SwapFree:       ", i.freeswap);
 #ifdef CONFIG_ZSWAP
-	seq_printf(m,  "Zswap:          %8lu kB\n",
-		   (unsigned long)(zswap_pool_total_size >> 10));
+	show_val_kb(m, "Zswap:          ", zswap_total_pages());
 	seq_printf(m,  "Zswapped:       %8lu kB\n",
 		   (unsigned long)atomic_read(&zswap_stored_pages) <<
 		   (PAGE_SHIFT - 10));
--- a/include/linux/zswap.h~mm-zswap-optimize-zswap-pool-size-tracking
+++ a/include/linux/zswap.h
@@ -7,7 +7,6 @@
 
 struct lruvec;
 
-extern u64 zswap_pool_total_size;
 extern atomic_t zswap_stored_pages;
 
 #ifdef CONFIG_ZSWAP
@@ -27,6 +26,7 @@ struct zswap_lruvec_state {
 	atomic_long_t nr_zswap_protected;
 };
 
+unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 bool zswap_load(struct folio *folio);
 void zswap_invalidate(swp_entry_t swp);
--- a/mm/zswap.c~mm-zswap-optimize-zswap-pool-size-tracking
+++ a/mm/zswap.c
@@ -43,8 +43,6 @@
 /*********************************
 * statistics
 **********************************/
-/* Total bytes used by the compressed storage */
-u64 zswap_pool_total_size;
 /* The number of compressed pages currently stored in zswap */
 atomic_t zswap_stored_pages = ATOMIC_INIT(0);
 /* The number of same-value filled pages currently stored in zswap */
@@ -265,45 +263,6 @@ static inline struct zswap_tree *swap_zs
 	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
 		 zpool_get_type((p)->zpools[0]))
 
-static bool zswap_is_full(void)
-{
-	return totalram_pages() * zswap_max_pool_percent / 100 <
-			DIV_ROUND_UP(zswap_pool_total_size, PAGE_SIZE);
-}
-
-static bool zswap_can_accept(void)
-{
-	return totalram_pages() * zswap_accept_thr_percent / 100 *
-				zswap_max_pool_percent / 100 >
-			DIV_ROUND_UP(zswap_pool_total_size, PAGE_SIZE);
-}
-
-static u64 get_zswap_pool_size(struct zswap_pool *pool)
-{
-	u64 pool_size = 0;
-	int i;
-
-	for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
-		pool_size += zpool_get_total_size(pool->zpools[i]);
-
-	return pool_size;
-}
-
-static void zswap_update_total_size(void)
-{
-	struct zswap_pool *pool;
-	u64 total = 0;
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(pool, &zswap_pools, list)
-		total += get_zswap_pool_size(pool);
-
-	rcu_read_unlock();
-
-	zswap_pool_total_size = total;
-}
-
 /*********************************
 * pool functions
 **********************************/
@@ -541,6 +500,33 @@ static struct zswap_pool *zswap_pool_fin
 	return NULL;
 }
 
+static unsigned long zswap_max_pages(void)
+{
+	return totalram_pages() * zswap_max_pool_percent / 100;
+}
+
+static unsigned long zswap_accept_thr_pages(void)
+{
+	return zswap_max_pages() * zswap_accept_thr_percent / 100;
+}
+
+unsigned long zswap_total_pages(void)
+{
+	struct zswap_pool *pool;
+	u64 total = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pool, &zswap_pools, list) {
+		int i;
+
+		for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
+			total += zpool_get_total_size(pool->zpools[i]);
+	}
+	rcu_read_unlock();
+
+	return total >> PAGE_SHIFT;
+}
+
 /*********************************
 * param callbacks
 **********************************/
@@ -913,7 +899,6 @@ static void zswap_entry_free(struct zswa
 	}
 	zswap_entry_cache_free(entry);
 	atomic_dec(&zswap_stored_pages);
-	zswap_update_total_size();
 }
 
 /*
@@ -1329,7 +1314,7 @@ static unsigned long zswap_shrinker_coun
 	nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 #else
 	/* use pool stats instead of memcg stats */
-	nr_backing = zswap_pool_total_size >> PAGE_SHIFT;
+	nr_backing = zswap_total_pages();
 	nr_stored = atomic_read(&zswap_nr_stored);
 #endif
 
@@ -1397,6 +1382,10 @@ static void shrink_worker(struct work_st
 {
 	struct mem_cgroup *memcg;
 	int ret, failures = 0;
+	unsigned long thr;
+
+	/* Reclaim down to the accept threshold */
+	thr = zswap_accept_thr_pages();
 
 	/* global reclaim will select cgroup in a round-robin fashion. */
 	do {
@@ -1444,10 +1433,9 @@ static void shrink_worker(struct work_st
 			break;
 		if (ret && ++failures == MAX_RECLAIM_RETRIES)
 			break;
-
 resched:
 		cond_resched();
-	} while (!zswap_can_accept());
+	} while (zswap_total_pages() > thr);
 }
 
 static int zswap_is_page_same_filled(void *ptr, unsigned long *value)
@@ -1488,6 +1476,7 @@ bool zswap_store(struct folio *folio)
 	struct zswap_entry *entry, *dupentry;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
+	unsigned long max_pages, cur_pages;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1499,6 +1488,7 @@ bool zswap_store(struct folio *folio)
 	if (!zswap_enabled)
 		goto check_old;
 
+	/* Check cgroup limits */
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
@@ -1509,15 +1499,18 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	/* reclaim space if needed */
-	if (zswap_is_full()) {
+	/* Check global limits */
+	cur_pages = zswap_total_pages();
+	max_pages = zswap_max_pages();
+
+	if (cur_pages >= max_pages) {
 		zswap_pool_limit_hit++;
 		zswap_pool_reached_full = true;
 		goto shrink;
 	}
 
 	if (zswap_pool_reached_full) {
-	       if (!zswap_can_accept())
+		if (cur_pages > zswap_accept_thr_pages())
 			goto shrink;
 		else
 			zswap_pool_reached_full = false;
@@ -1593,7 +1586,6 @@ insert_entry:
 
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
-	zswap_update_total_size();
 	count_vm_event(ZSWPOUT);
 
 	return true;
@@ -1722,6 +1714,13 @@ void zswap_swapoff(int type)
 
 static struct dentry *zswap_debugfs_root;
 
+static int debugfs_get_total_size(void *data, u64 *val)
+{
+	*val = zswap_total_pages() * PAGE_SIZE;
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(total_size_fops, debugfs_get_total_size, NULL, "%llu\n");
+
 static int zswap_debugfs_init(void)
 {
 	if (!debugfs_initialized())
@@ -1743,8 +1742,8 @@ static int zswap_debugfs_init(void)
 			   zswap_debugfs_root, &zswap_reject_compress_poor);
 	debugfs_create_u64("written_back_pages", 0444,
 			   zswap_debugfs_root, &zswap_written_back_pages);
-	debugfs_create_u64("pool_total_size", 0444,
-			   zswap_debugfs_root, &zswap_pool_total_size);
+	debugfs_create_file("pool_total_size", 0444,
+			    zswap_debugfs_root, NULL, &total_size_fops);
 	debugfs_create_atomic_t("stored_pages", 0444,
 				zswap_debugfs_root, &zswap_stored_pages);
 	debugfs_create_atomic_t("same_filled_pages", 0444,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-cachestat-fix-two-shmem-bugs.patch
mm-zswap-optimize-zswap-pool-size-tracking.patch
mm-zpool-return-pool-size-in-pages.patch

