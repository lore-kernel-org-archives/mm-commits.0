From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch removed from
 -mm tree
Date: Thu, 17 Mar 2016 13:48:25 -0700
Message-ID: <56eb1819.G4n2GEJOTY3VVDA1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbcCQUs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-make-tree_statevents-fetch-all-stats-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch

This patch was dropped because it was folded into mm-memcontrol-make-tree_statevents-fetch-all-stats.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm-memcontrol-make-tree_statevents-fetch-all-stats-fix

> This looks much better, and most of the callstacks involved here are
> very flat, so the increased stack consumption should be alright.
>
> The only exception there is the threshold code, which can happen from
> the direct reclaim path and thus with a fairly deep stack already.

Yeah, I missed this case. Thought mem_cgroup_usage is only used for
reporting to userspace. Thanks for catching this.

>
> Would it be better to leave mem_cgroup_usage() alone, open-code it,
> and then use tree_stat() and tree_events() only for v2 memory.stat?
>

Definitely.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-make-tree_statevents-fetch-all-stats-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-make-tree_statevents-fetch-all-stats-fix
+++ a/mm/memcontrol.c
@@ -2745,14 +2745,20 @@ static void tree_events(struct mem_cgrou
 
 static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
-	unsigned long stat[MEMCG_NR_STAT];
-	unsigned long val;
+	unsigned long val = 0;
 
 	if (mem_cgroup_is_root(memcg)) {
-		tree_stat(memcg, stat);
-		val = stat[MEM_CGROUP_STAT_CACHE] + stat[MEM_CGROUP_STAT_RSS];
-		if (swap)
-			val += stat[MEM_CGROUP_STAT_SWAP];
+		struct mem_cgroup *iter;
+
+		for_each_mem_cgroup_tree(iter, memcg) {
+			val += mem_cgroup_read_stat(iter,
+					MEM_CGROUP_STAT_CACHE);
+			val += mem_cgroup_read_stat(iter,
+					MEM_CGROUP_STAT_RSS);
+			if (swap)
+				val += mem_cgroup_read_stat(iter,
+						MEM_CGROUP_STAT_SWAP);
+		}
 	} else {
 		if (!swap)
 			val = page_counter_read(&memcg->memory);
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
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
mm-memcontrol-cleanup-css_reset-callback.patch
mm-memcontrol-zap-oom_info_lock.patch

