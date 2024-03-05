Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5506F5C604
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709655084; cv=none; b=GPUg6ZiQM3sAke+i6hocBOk3XKSdDnvuggg9cbnjpHRuFSe/KMKUaJmpJpuhhSXqpZNJAgH7NFVXUa+NNi0uPCpi2GiXaz0CZK4n24hZpJRVaai9aJjunba49CP0dPiDhaWal4I2tcEyOyawt0DqbKjNIBiriaLRmibx/Odw8Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709655084; c=relaxed/simple;
	bh=5/2yAsFquzZ96HQRzlvtlN4KDh7z5xEAT1AcpXFW6rg=;
	h=Date:To:From:Subject:Message-Id; b=oO1wPcYb5y40h737RQ/lKO4Y4ASwK+UMu6l37Ula2iKZCet2mYf5oPE9BEhj3qkAqmyJ7iviGg+EyM/N6VSgJX9h3c9qUZTsor44RPsCXc/OP3fVI58ekZ9ctosxhriSI8Z3FbYcJ1JJbvr4v81vHkEeBmInB09qIw4NTlF3/G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JKsTYQSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JKsTYQSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4BCC433C7;
	Tue,  5 Mar 2024 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709655083;
	bh=5/2yAsFquzZ96HQRzlvtlN4KDh7z5xEAT1AcpXFW6rg=;
	h=Date:To:From:Subject:From;
	b=JKsTYQSDUprZXYcGETxEWMvvt9A0I/9J7gzg6NkC/65qJQG+g+xY+Pmab1NLQw9UD
	 v2BIISUbWAn0X7QWDARYxxRjD9VnL+3dHqnFwBOSKTk1YyqfWCHM2NkscBzAUvdsd0
	 dAZOroulWbqwwcNozq+xD6xpPijLrvJnR4tPlHvA=
Date: Tue, 05 Mar 2024 08:11:23 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,oliver.sang@intel.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools-fix.patch added to mm-unstable branch
Message-Id: <20240305161123.CA4BCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: global lru and shrinker shared by all zswap_pools fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools-fix.patch

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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/zswap: global lru and shrinker shared by all zswap_pools fix
Date: Tue, 5 Mar 2024 07:53:45 +0000

Commit bf9b7df23cb3 ("mm/zswap: global lru and shrinker shared by all
zswap_pools") introduced a new lock to protect zswap_next_shrink, instead
of reusing zswap_pools_lock.

But the problem is that it's initialized only when zswap enabled, which
causes bug if zswap_memcg_offline_cleanup() called without zswap enabled.

Fix it by using DEFINE_SPINLOCK() to statically initialize them and define
them as multiple static variables to keep in consistent with the existing
global variables in zswap.

Link: https://lkml.kernel.org/r/20240305075345.1493214-1-chengming.zhou@linux.dev
Fixes: bf9b7df23cb3 ("mm/zswap: global lru and shrinker shared by all zswap_pools")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202403051008.a8cf8a94-lkp@intel.com
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   77 +++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

--- a/mm/zswap.c~mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools-fix
+++ a/mm/zswap.c
@@ -180,15 +180,16 @@ struct zswap_pool {
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
-static struct {
-	struct list_lru list_lru;
-	atomic_t nr_stored;
-	struct shrinker *shrinker;
-	struct work_struct shrink_work;
-	struct mem_cgroup *next_shrink;
-	/* The lock protects next_shrink. */
-	spinlock_t shrink_lock;
-} zswap;
+/* Global LRU lists shared by all zswap pools. */
+static struct list_lru zswap_list_lru;
+/* counter of pages stored in all zswap pools. */
+static atomic_t zswap_nr_stored = ATOMIC_INIT(0);
+
+/* The lock protects zswap_next_shrink updates. */
+static DEFINE_SPINLOCK(zswap_shrink_lock);
+static struct mem_cgroup *zswap_next_shrink;
+static struct work_struct zswap_shrink_work;
+static struct shrinker *zswap_shrinker;
 
 /*
  * struct zswap_entry
@@ -798,10 +799,10 @@ void zswap_folio_swapin(struct folio *fo
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
 {
 	/* lock out zswap shrinker walking memcg tree */
-	spin_lock(&zswap.shrink_lock);
-	if (zswap.next_shrink == memcg)
-		zswap.next_shrink = mem_cgroup_iter(NULL, zswap.next_shrink, NULL);
-	spin_unlock(&zswap.shrink_lock);
+	spin_lock(&zswap_shrink_lock);
+	if (zswap_next_shrink == memcg)
+		zswap_next_shrink = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
+	spin_unlock(&zswap_shrink_lock);
 }
 
 /*********************************
@@ -900,9 +901,9 @@ static void zswap_entry_free(struct zswa
 	if (!entry->length)
 		atomic_dec(&zswap_same_filled_pages);
 	else {
-		zswap_lru_del(&zswap.list_lru, entry);
+		zswap_lru_del(&zswap_list_lru, entry);
 		zpool_free(zswap_find_zpool(entry), entry->handle);
-		atomic_dec(&zswap.nr_stored);
+		atomic_dec(&zswap_nr_stored);
 		zswap_pool_put(entry->pool);
 	}
 	if (entry->objcg) {
@@ -1274,7 +1275,7 @@ static unsigned long zswap_shrinker_scan
 
 	nr_protected =
 		atomic_long_read(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	lru_size = list_lru_shrink_count(&zswap.list_lru, sc);
+	lru_size = list_lru_shrink_count(&zswap_list_lru, sc);
 
 	/*
 	 * Abort if we are shrinking into the protected region.
@@ -1291,7 +1292,7 @@ static unsigned long zswap_shrinker_scan
 		return SHRINK_STOP;
 	}
 
-	shrink_ret = list_lru_shrink_walk(&zswap.list_lru, sc, &shrink_memcg_cb,
+	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
 		&encountered_page_in_swapcache);
 
 	if (encountered_page_in_swapcache)
@@ -1317,7 +1318,7 @@ static unsigned long zswap_shrinker_coun
 #else
 	/* use pool stats instead of memcg stats */
 	nr_backing = zswap_pool_total_size >> PAGE_SHIFT;
-	nr_stored = atomic_read(&zswap.nr_stored);
+	nr_stored = atomic_read(&zswap_nr_stored);
 #endif
 
 	if (!nr_stored)
@@ -1325,7 +1326,7 @@ static unsigned long zswap_shrinker_coun
 
 	nr_protected =
 		atomic_long_read(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	nr_freeable = list_lru_shrink_count(&zswap.list_lru, sc);
+	nr_freeable = list_lru_shrink_count(&zswap_list_lru, sc);
 	/*
 	 * Subtract the lru size by an estimate of the number of pages
 	 * that should be protected.
@@ -1374,7 +1375,7 @@ static int shrink_memcg(struct mem_cgrou
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
 		unsigned long nr_to_walk = 1;
 
-		shrunk += list_lru_walk_one(&zswap.list_lru, nid, memcg,
+		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
 					    &shrink_memcg_cb, NULL, &nr_to_walk);
 	}
 	return shrunk ? 0 : -EAGAIN;
@@ -1387,9 +1388,9 @@ static void shrink_worker(struct work_st
 
 	/* global reclaim will select cgroup in a round-robin fashion. */
 	do {
-		spin_lock(&zswap.shrink_lock);
-		zswap.next_shrink = mem_cgroup_iter(NULL, zswap.next_shrink, NULL);
-		memcg = zswap.next_shrink;
+		spin_lock(&zswap_shrink_lock);
+		zswap_next_shrink = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
+		memcg = zswap_next_shrink;
 
 		/*
 		 * We need to retry if we have gone through a full round trip, or if we
@@ -1403,7 +1404,7 @@ static void shrink_worker(struct work_st
 		 * memcg is not killed when we are reclaiming.
 		 */
 		if (!memcg) {
-			spin_unlock(&zswap.shrink_lock);
+			spin_unlock(&zswap_shrink_lock);
 			if (++failures == MAX_RECLAIM_RETRIES)
 				break;
 
@@ -1413,15 +1414,15 @@ static void shrink_worker(struct work_st
 		if (!mem_cgroup_tryget_online(memcg)) {
 			/* drop the reference from mem_cgroup_iter() */
 			mem_cgroup_iter_break(NULL, memcg);
-			zswap.next_shrink = NULL;
-			spin_unlock(&zswap.shrink_lock);
+			zswap_next_shrink = NULL;
+			spin_unlock(&zswap_shrink_lock);
 
 			if (++failures == MAX_RECLAIM_RETRIES)
 				break;
 
 			goto resched;
 		}
-		spin_unlock(&zswap.shrink_lock);
+		spin_unlock(&zswap_shrink_lock);
 
 		ret = shrink_memcg(memcg);
 		/* drop the extra reference */
@@ -1542,7 +1543,7 @@ bool zswap_store(struct folio *folio)
 
 	if (objcg) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		if (memcg_list_lru_alloc(memcg, &zswap.list_lru, GFP_KERNEL)) {
+		if (memcg_list_lru_alloc(memcg, &zswap_list_lru, GFP_KERNEL)) {
 			mem_cgroup_put(memcg);
 			goto put_pool;
 		}
@@ -1573,8 +1574,8 @@ insert_entry:
 	}
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(&zswap.list_lru, entry);
-		atomic_inc(&zswap.nr_stored);
+		zswap_lru_add(&zswap_list_lru, entry);
+		atomic_inc(&zswap_nr_stored);
 	}
 	spin_unlock(&tree->lock);
 
@@ -1606,7 +1607,7 @@ check_old:
 	return false;
 
 shrink:
-	queue_work(shrink_wq, &zswap.shrink_work);
+	queue_work(shrink_wq, &zswap_shrink_work);
 	goto reject;
 }
 
@@ -1773,16 +1774,14 @@ static int zswap_setup(void)
 	if (!shrink_wq)
 		goto shrink_wq_fail;
 
-	zswap.shrinker = zswap_alloc_shrinker();
-	if (!zswap.shrinker)
+	zswap_shrinker = zswap_alloc_shrinker();
+	if (!zswap_shrinker)
 		goto shrinker_fail;
-	if (list_lru_init_memcg(&zswap.list_lru, zswap.shrinker))
+	if (list_lru_init_memcg(&zswap_list_lru, zswap_shrinker))
 		goto lru_fail;
-	shrinker_register(zswap.shrinker);
+	shrinker_register(zswap_shrinker);
 
-	INIT_WORK(&zswap.shrink_work, shrink_worker);
-	atomic_set(&zswap.nr_stored, 0);
-	spin_lock_init(&zswap.shrink_lock);
+	INIT_WORK(&zswap_shrink_work, shrink_worker);
 
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
@@ -1801,7 +1800,7 @@ static int zswap_setup(void)
 	return 0;
 
 lru_fail:
-	shrinker_free(zswap.shrinker);
+	shrinker_free(zswap_shrinker);
 shrinker_fail:
 	destroy_workqueue(shrink_wq);
 shrink_wq_fail:
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools-fix.patch

