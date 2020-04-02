From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 064/155] mm: kmem: cleanup
 memcg_kmem_uncharge_memcg() arguments
Date: Wed, 01 Apr 2020 21:06:43 -0700
Message-ID: <20200402040643.EAnPdcohA%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbgDBEGp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:45 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

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
