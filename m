From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch added to -mm tree
Date: Tue, 09 Feb 2016 13:18:07 -0800
Message-ID: <56ba578f.n2QhHYgCV4WojQqL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbcBIVSI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 16:18:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: pass root_mem_cgroup instead of NULL to memcg aware shrinker
has been added to the -mm tree.  Its filename is
     mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch
tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix.patch
mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch
mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch
mm-memcontrol-zap-memcg_kmem_online-helper.patch
radix-tree-account-radix_tree_node-to-memory-cgroup.patch
mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch
mm-workingset-make-shadow-node-shrinker-memcg-aware.patch

