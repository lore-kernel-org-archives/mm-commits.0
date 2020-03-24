From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch removed from -mm tree
Date: Mon, 23 Mar 2020 18:07:40 -0700
Message-ID: <20200324010740.Lm6Jimsia%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgCXBHm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 21:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm-memcg-slab-introduce-mem_cgroup_from_obj-v2
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-introduce-mem_cgroup_from_obj-v2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm-memcg-slab-introduce-mem_cgroup_from_obj-v2

fix build issues

Link: http://lkml.kernel.org/r/20200225022154.GA573375@carbon.DHCP.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 +++++++-------
 mm/memcontrol.c            |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-introduce-mem_cgroup_from_obj-v2
+++ a/include/linux/memcontrol.h
@@ -420,8 +420,6 @@ struct lruvec *mem_cgroup_page_lruvec(st
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
-struct mem_cgroup *mem_cgroup_from_obj(void *p);
-
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
@@ -915,11 +913,6 @@ static inline bool mm_match_cgroup(struc
 	return true;
 }
 
-static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
-{
-	return NULL;
-}
-
 static inline struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	return NULL;
@@ -1439,6 +1432,8 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
+struct mem_cgroup *mem_cgroup_from_obj(void *p);
+
 #else
 
 static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
@@ -1480,6 +1475,11 @@ static inline void memcg_put_cache_ids(v
 {
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+       return NULL;
+}
+
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/mm/memcontrol.c~mm-memcg-slab-introduce-mem_cgroup_from_obj-v2
+++ a/mm/memcontrol.c
@@ -2670,6 +2670,7 @@ static void commit_charge(struct page *p
 		unlock_page_lru(page, isolated);
 }
 
+#ifdef CONFIG_MEMCG_KMEM
 /*
  * Returns a pointer to the memory cgroup to which the kernel object is charged.
  *
@@ -2697,7 +2698,6 @@ struct mem_cgroup *mem_cgroup_from_obj(v
 	return page->mem_cgroup;
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
_

Patches currently in -mm which might be from guro@fb.com are

mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations.patch
mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations-v2.patch
mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
mm-memcg-make-memoryoomgroup-tolerable-to-task-migration.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
mm-hugetlb-fix-hugetlb_cma_reserve-if-config_numa-isnt-set.patch
