From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-slab-introduce-mem_cgroup_from_obj.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:37:23 -0700
Message-ID: <20200403203723.priq4cx-x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUh0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: memcg/slab: use mem_cgroup_from_obj()
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-introduce-mem_cgroup_from_obj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: use mem_cgroup_from_obj()

Sometimes we need to get a memcg pointer from a charged kernel object. 
The right way to get it depends on whether it's a proper slab object or
it's backed by raw pages (e.g.  it's a vmalloc alloction).  In the first
case the kmem_cache->memcg_params.memcg indirection should be used; in
other cases it's just page->mem_cgroup.

To simplify this task and hide the implementation details let's use the
mem_cgroup_from_obj() helper, which takes a pointer to any kernel object
and returns a valid memcg pointer or NULL.

Passing a kernel address rather than a pointer to a page will allow to use
this helper for per-object (rather than per-page) tracked objects in the
future.

The caller is still responsible to ensure that the returned memcg isn't
going away underneath: take the rcu read lock, cgroup mutex etc; depending
on the context.

mem_cgroup_from_kmem() defined in mm/list_lru.c is now obsolete and can be
removed.

Link: http://lkml.kernel.org/r/20200117203609.3146239-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c   |   12 +-----------
 mm/memcontrol.c |    5 ++---
 2 files changed, 3 insertions(+), 14 deletions(-)

--- a/mm/list_lru.c~mm-memcg-slab-introduce-mem_cgroup_from_obj
+++ a/mm/list_lru.c
@@ -57,16 +57,6 @@ list_lru_from_memcg_idx(struct list_lru_
 	return &nlru->lru;
 }
 
-static __always_inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
-{
-	struct page *page;
-
-	if (!memcg_kmem_enabled())
-		return NULL;
-	page = virt_to_head_page(ptr);
-	return memcg_from_slab_page(page);
-}
-
 static inline struct list_lru_one *
 list_lru_from_kmem(struct list_lru_node *nlru, void *ptr,
 		   struct mem_cgroup **memcg_ptr)
@@ -77,7 +67,7 @@ list_lru_from_kmem(struct list_lru_node
 	if (!nlru->memcg_lrus)
 		goto out;
 
-	memcg = mem_cgroup_from_kmem(ptr);
+	memcg = mem_cgroup_from_obj(ptr);
 	if (!memcg)
 		goto out;
 
--- a/mm/memcontrol.c~mm-memcg-slab-introduce-mem_cgroup_from_obj
+++ a/mm/memcontrol.c
@@ -759,13 +759,12 @@ void __mod_lruvec_state(struct lruvec *l
 
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
 {
-	struct page *page = virt_to_head_page(p);
-	pg_data_t *pgdat = page_pgdat(page);
+	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = memcg_from_slab_page(page);
+	memcg = mem_cgroup_from_obj(p);
 
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg || memcg == root_mem_cgroup) {
_

Patches currently in -mm which might be from guro@fb.com are

mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
