Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEA7210FB
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jWJw8Y51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C625AC433C7;
	Tue, 12 Dec 2023 18:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407109;
	bh=cxm7bsYgmAPTg/ZxWHULrXUXuvldN/qYdZwLPLQu/XU=;
	h=Date:To:From:Subject:From;
	b=jWJw8Y510pOQMUBjKcMch0LCBVA/x4S91ogJkikSGQikqE+PbY9fvzo6dNzfBAB8i
	 uZb3DzNRW1PTEjHVBptDDPZCZf/CA56qeeE3VNrRwD7lLvURtX0n3M9Nuz3YCWVyZW
	 BM5f8IUnwzRntsxgCNHhi922ICSqUteknYWWSo9o=
Date: Tue, 12 Dec 2023 10:51:48 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,shuah@kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,chengming.zhou@linux.dev,cerasuolodomenico@gmail.com,bagasdotme@gmail.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch removed from -mm tree
Message-Id: <20231212185149.C625AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zswap: shrinks zswap pool based on memory pressure (fix)
has been removed from the -mm tree.  Its filename was
     zswap-shrinks-zswap-pool-based-on-memory-pressure-fix.patch

This patch was dropped because it was folded into zswap-shrinks-zswap-pool-based-on-memory-pressure.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: shrinks zswap pool based on memory pressure (fix)
Date: Wed, 6 Dec 2023 11:44:56 -0800

Check shrinker enablement early, and use a less costly stat flushing.

Link: https://lkml.kernel.org/r/20231206194456.3234203-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~zswap-shrinks-zswap-pool-based-on-memory-pressure-fix
+++ a/mm/zswap.c
@@ -596,13 +596,17 @@ static unsigned long zswap_shrinker_scan
 	struct zswap_pool *pool = shrinker->private_data;
 	bool encountered_page_in_swapcache = false;
 
+	if (!zswap_shrinker_enabled) {
+		sc->nr_scanned = 0;
+		return SHRINK_STOP;
+	}
+
 	nr_protected =
 		atomic_long_read(&lruvec->zswap_lruvec_state.nr_zswap_protected);
 	lru_size = list_lru_shrink_count(&pool->list_lru, sc);
 
 	/*
-	 * Abort if the shrinker is disabled or if we are shrinking into the
-	 * protected region.
+	 * Abort if we are shrinking into the protected region.
 	 *
 	 * This short-circuiting is necessary because if we have too many multiple
 	 * concurrent reclaimers getting the freeable zswap object counts at the
@@ -611,7 +615,7 @@ static unsigned long zswap_shrinker_scan
 	 * objects (i.e the reclaimers will reclaim into the protected area of the
 	 * zswap LRU).
 	 */
-	if (!zswap_shrinker_enabled || nr_protected >= lru_size - sc->nr_to_scan) {
+	if (nr_protected >= lru_size - sc->nr_to_scan) {
 		sc->nr_scanned = 0;
 		return SHRINK_STOP;
 	}
@@ -633,8 +637,11 @@ static unsigned long zswap_shrinker_coun
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(sc->nid));
 	unsigned long nr_backing, nr_stored, nr_freeable, nr_protected;
 
+	if (!zswap_shrinker_enabled)
+		return 0;
+
 #ifdef CONFIG_MEMCG_KMEM
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 	nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 	nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 #else
@@ -643,7 +650,7 @@ static unsigned long zswap_shrinker_coun
 	nr_stored = atomic_read(&pool->nr_stored);
 #endif
 
-	if (!zswap_shrinker_enabled || !nr_stored)
+	if (!nr_stored)
 		return 0;
 
 	nr_protected =
_

Patches currently in -mm which might be from nphamcs@gmail.com are

list_lru-allows-explicit-memcg-and-numa-node-selection.patch
memcontrol-implement-mem_cgroup_tryget_online.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
zswap-memcontrol-implement-zswap-writeback-disabling.patch

