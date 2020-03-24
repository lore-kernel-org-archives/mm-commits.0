From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-fork-fix-kernel=5Fstack-memcg-stats-for-various-stack-?=
 =?US-ASCII?Q?implementations-v2.patch?= added to -mm tree
Date: Mon, 23 Mar 2020 18:11:25 -0700
Message-ID: <20200324011125.aIK63naNn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbgCXBL1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 21:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@linux.ibm.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: fork: fix kernel_stack memcg stats for various stack implementations
has been added to the -mm tree.  Its filename is
     mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: fork: fix kernel_stack memcg stats for various stack implementations

introduce mem_cgroup_from_obj()

Link: http://lkml.kernel.org/r/20200324004221.GA36662@carbon.dhcp.thefacebook.com
Fixes: 4d96ba353075 ("mm: memcg/slab: stop setting page->mem_cgroup pointer for slab pages")
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |   27 +++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/include/linux/memcontrol.h~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations-v2
+++ a/include/linux/memcontrol.h
@@ -1432,6 +1432,8 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
+struct mem_cgroup *mem_cgroup_from_obj(void *p);
+
 #else
 
 static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
@@ -1473,6 +1475,11 @@ static inline void memcg_put_cache_ids(v
 {
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+       return NULL;
+}
+
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/mm/memcontrol.c~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations-v2
+++ a/mm/memcontrol.c
@@ -2672,6 +2672,33 @@ static void commit_charge(struct page *p
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * Returns a pointer to the memory cgroup to which the kernel object is charged.
+ *
+ * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
+ * cgroup_mutex, etc.
+ */
+struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+	struct page *page;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	page = virt_to_head_page(p);
+
+	/*
+	 * Slab pages don't have page->mem_cgroup set because corresponding
+	 * kmem caches can be reparented during the lifetime. That's why
+	 * memcg_from_slab_page() should be used instead.
+	 */
+	if (PageSlab(page))
+		return memcg_from_slab_page(page);
+
+	/* All other pages use page->mem_cgroup */
+	return page->mem_cgroup;
+}
+
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
