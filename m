From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:31 -0700
Message-ID: <56e9ba6f.TkiM/DoZELWAn/CW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbcCPT4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not clear SHRINKER_NUMA_AWARE if nr_node_ids == 1
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: vmscan: do not clear SHRINKER_NUMA_AWARE if nr_node_ids == 1

Currently, on shrinker registration we clear SHRINKER_NUMA_AWARE if
there's the only NUMA node present.  The comment states that this will
allow us to save some small loop time later.  It used to be true when this
code was added (see commit 1d3d4437eae1b ("vmscan: per-node deferred
work")), but since commit 6b4f7799c6a57 ("mm: vmscan: invoke slab
shrinkers from shrink_zone()") it doesn't make any difference.  Anyway,
running on non-NUMA machine shouldn't make a shrinker NUMA unaware, so zap
this hunk.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1 mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1
+++ a/mm/vmscan.c
@@ -228,14 +228,6 @@ int register_shrinker(struct shrinker *s
 {
 	size_t size = sizeof(*shrinker->nr_deferred);
 
-	/*
-	 * If we only have one possible node in the system anyway, save
-	 * ourselves the trouble and disable NUMA aware behavior. This way we
-	 * will save memory and some small loop time later.
-	 */
-	if (nr_node_ids == 1)
-		shrinker->flags &= ~SHRINKER_NUMA_AWARE;
-
 	if (shrinker->flags & SHRINKER_NUMA_AWARE)
 		size *= nr_node_ids;
 
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom_reaper-implement-oom-victims-queuing-fix.patch
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
mm-memcontrol-cleanup-css_reset-callback.patch
mm-memcontrol-zap-oom_info_lock.patch

