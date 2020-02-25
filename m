From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-slab-introduce-mem_cgroup_from_obj.patch added
 to -mm tree
Date: Mon, 24 Feb 2020 16:32:57 -0800
Message-ID: <20200225003257.1g_qNtUec%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBYAdA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 19:33:00 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: memcg/slab: introduce mem_cgroup_from_obj()
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-introduce-mem_cgroup_from_obj.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-introduce-mem_cgroup_from_obj.patch

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
Subject: mm: memcg/slab: introduce mem_cgroup_from_obj()

Sometimes we need to get a memcg pointer from a charged kernel object. 
The right way to get it depends on whether it's a proper slab object or
it's backed by raw pages (e.g.  it's a vmalloc alloction).  In the first
case the kmem_cache->memcg_params.memcg indirection should be used; in
other cases it's just page->mem_cgroup.

To simplify this task and hide the implementation details let's introduce
a mem_cgroup_from_obj() helper, which takes a pointer to any kernel object
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

 include/linux/memcontrol.h |    7 +++++++
 mm/list_lru.c              |   12 +-----------
 mm/memcontrol.c            |   32 +++++++++++++++++++++++++++++---
 3 files changed, 37 insertions(+), 14 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-introduce-mem_cgroup_from_obj
+++ a/include/linux/memcontrol.h
@@ -420,6 +420,8 @@ struct lruvec *mem_cgroup_page_lruvec(st
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
+struct mem_cgroup *mem_cgroup_from_obj(void *p);
+
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
@@ -912,6 +914,11 @@ static inline bool mm_match_cgroup(struc
 	return true;
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+	return NULL;
+}
+
 static inline struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	return NULL;
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
@@ -2637,6 +2636,33 @@ static void commit_charge(struct page *p
 		unlock_page_lru(page, isolated);
 }
 
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
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_alloc_cache_id(void)
 {
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
