From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:51 -0700
Message-ID: <56f03fbb.tc7BsJ17AyeGl9eQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485AbcCUT4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: pass root_mem_cgroup instead of NULL to memcg aware shrinker
has been removed from the -mm tree.  Its filename was
     mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: vmscan: pass root_mem_cgroup instead of NULL to memcg aware shrinker

It's just convenient to implement a memcg aware shrinker when you know
that shrink_control->memcg != NULL unless memcg_kmem_enabled() returns
false.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker
+++ a/mm/vmscan.c
@@ -382,9 +382,8 @@ static unsigned long do_shrink_slab(stru
  *
  * @memcg specifies the memory cgroup to target. If it is not NULL,
  * only shrinkers with SHRINKER_MEMCG_AWARE set will be called to scan
- * objects from the memory cgroup specified. Otherwise all shrinkers
- * are called, and memcg aware shrinkers are supposed to scan the
- * global list then.
+ * objects from the memory cgroup specified. Otherwise, only unaware
+ * shrinkers are called.
  *
  * @nr_scanned and @nr_eligible form a ratio that indicate how much of
  * the available objects should be scanned.  Page reclaim for example
@@ -404,7 +403,7 @@ static unsigned long shrink_slab(gfp_t g
 	struct shrinker *shrinker;
 	unsigned long freed = 0;
 
-	if (memcg && !memcg_kmem_online(memcg))
+	if (memcg && (!memcg_kmem_enabled() || !mem_cgroup_online(memcg)))
 		return 0;
 
 	if (nr_scanned == 0)
@@ -428,7 +427,13 @@ static unsigned long shrink_slab(gfp_t g
 			.memcg = memcg,
 		};
 
-		if (memcg && !(shrinker->flags & SHRINKER_MEMCG_AWARE))
+		/*
+		 * If kernel memory accounting is disabled, we ignore
+		 * SHRINKER_MEMCG_AWARE flag and call all shrinkers
+		 * passing NULL for memcg.
+		 */
+		if (memcg_kmem_enabled() &&
+		    !!memcg != !!(shrinker->flags & SHRINKER_MEMCG_AWARE))
 			continue;
 
 		if (!(shrinker->flags & SHRINKER_NUMA_AWARE))
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom_reaper-implement-oom-victims-queuing-fix.patch

