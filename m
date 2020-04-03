From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:37:28 -0700
Message-ID: <20200403203728.QKBs-XR0e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUhb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: kmem: cleanup memcg_kmem_uncharge_memcg() arguments
has been removed from the -mm tree.  Its filename was
     mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: cleanup memcg_kmem_uncharge_memcg() arguments

Drop the unused page argument and put the memcg pointer at the first
place.  This make the function consistent with its peers:
__memcg_kmem_uncharge_memcg(), memcg_kmem_charge_memcg(), etc.

Link: http://lkml.kernel.org/r/20200109202659.752357-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/slab.h                  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments
+++ a/include/linux/memcontrol.h
@@ -1414,8 +1414,8 @@ static inline int memcg_kmem_charge_memc
 	return 0;
 }
 
-static inline void memcg_kmem_uncharge_memcg(struct page *page, int order,
-					     struct mem_cgroup *memcg)
+static inline void memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
+					     int order)
 {
 	if (memcg_kmem_enabled())
 		__memcg_kmem_uncharge_memcg(memcg, 1 << order);
--- a/mm/slab.h~mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments
+++ a/mm/slab.h
@@ -395,7 +395,7 @@ static __always_inline void memcg_unchar
 	if (likely(!mem_cgroup_is_root(memcg))) {
 		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
 		mod_lruvec_state(lruvec, cache_vmstat_idx(s), -(1 << order));
-		memcg_kmem_uncharge_memcg(page, order, memcg);
+		memcg_kmem_uncharge_memcg(memcg, order);
 	} else {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 				    -(1 << order));
_

Patches currently in -mm which might be from guro@fb.com are

mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
