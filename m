From: akpm@linux-foundation.org
Subject: [merged] memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:16:07 -0800
Message-ID: <563d0a87.vfPmJ/yzy+qK6Cd/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162891AbbKFUQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: simplify and inline __mem_cgroup_from_kmem
has been removed from the -mm tree.  Its filename was
     memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: memcg: simplify and inline __mem_cgroup_from_kmem

Before the previous patch ("memcg: unify slab and other kmem pages
charging"), __mem_cgroup_from_kmem had to handle two types of kmem - slab
pages and pages allocated with alloc_kmem_pages - memcg in the page
struct.  Now we can unify it.  Since after it, this function becomes tiny
we can fold it into mem_cgroup_from_kmem.

[hughd@google.com: move mem_cgroup_from_kmem into list_lru.c]
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ---------------
 mm/list_lru.c              |   10 ++++++++++
 mm/memcontrol.c            |   18 ------------------
 3 files changed, 10 insertions(+), 33 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem
+++ a/include/linux/memcontrol.h
@@ -770,8 +770,6 @@ static inline int memcg_cache_id(struct
 struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep);
 void __memcg_kmem_put_cache(struct kmem_cache *cachep);
 
-struct mem_cgroup *__mem_cgroup_from_kmem(void *ptr);
-
 static inline bool __memcg_kmem_bypass(gfp_t gfp)
 {
 	if (!memcg_kmem_enabled())
@@ -830,13 +828,6 @@ static __always_inline void memcg_kmem_p
 	if (memcg_kmem_enabled())
 		__memcg_kmem_put_cache(cachep);
 }
-
-static __always_inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
-{
-	if (!memcg_kmem_enabled())
-		return NULL;
-	return __mem_cgroup_from_kmem(ptr);
-}
 #else
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
@@ -882,11 +873,5 @@ memcg_kmem_get_cache(struct kmem_cache *
 static inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
 {
 }
-
-static inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
-{
-	return NULL;
-}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
-
diff -puN mm/list_lru.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem mm/list_lru.c
--- a/mm/list_lru.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem
+++ a/mm/list_lru.c
@@ -63,6 +63,16 @@ list_lru_from_memcg_idx(struct list_lru_
 	return &nlru->lru;
 }
 
+static __always_inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
+{
+	struct page *page;
+
+	if (!memcg_kmem_enabled())
+		return NULL;
+	page = virt_to_head_page(ptr);
+	return page->mem_cgroup;
+}
+
 static inline struct list_lru_one *
 list_lru_from_kmem(struct list_lru_node *nlru, void *ptr)
 {
diff -puN mm/memcontrol.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem
+++ a/mm/memcontrol.c
@@ -2430,24 +2430,6 @@ void __memcg_kmem_uncharge(struct page *
 	page->mem_cgroup = NULL;
 	css_put_many(&memcg->css, nr_pages);
 }
-
-struct mem_cgroup *__mem_cgroup_from_kmem(void *ptr)
-{
-	struct mem_cgroup *memcg = NULL;
-	struct kmem_cache *cachep;
-	struct page *page;
-
-	page = virt_to_head_page(ptr);
-	if (PageSlab(page)) {
-		cachep = page->slab_cache;
-		if (!is_root_cache(cachep))
-			memcg = cachep->memcg_params.memcg;
-	} else
-		/* page allocated by alloc_kmem_pages */
-		memcg = page->mem_cgroup;
