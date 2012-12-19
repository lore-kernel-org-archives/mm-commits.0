From: akpm@linux-foundation.org
Subject: [merged] memcg-destroy-memcg-caches.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:41:46 -0800
Message-ID: <20121219204147.56E1120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f73.google.com ([209.85.214.73]:51260 "EHLO
	mail-bk0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2LSUlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:41:51 -0500
Received: by mail-bk0-f73.google.com with SMTP id jf3so133871bkc.4
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:41:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: destroy memcg caches
has been removed from the -mm tree.  Its filename was
     memcg-destroy-memcg-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: destroy memcg caches

Implement destruction of memcg caches.  Right now, only caches where our
reference counter is the last remaining are deleted.  If there are any
other reference counters around, we just leave the caches lying around
until they go away.

When that happens, a destruction function is called from the cache code. 
Caches are only destroyed in process context, so we queue them up for
later processing in the general case.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +
 include/linux/slab.h       |   10 +++++
 mm/memcontrol.c            |   63 +++++++++++++++++++++++++++++++++++
 mm/slab.c                  |    3 +
 mm/slab.h                  |   23 ++++++++++++
 mm/slub.c                  |    7 +++
 6 files changed, 106 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-destroy-memcg-caches include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-destroy-memcg-caches
+++ a/include/linux/memcontrol.h
@@ -453,6 +453,8 @@ void memcg_update_array_size(int num_gro
 struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
+void mem_cgroup_destroy_cache(struct kmem_cache *cachep);
+
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
  * @gfp: the gfp allocation flags.
diff -puN include/linux/slab.h~memcg-destroy-memcg-caches include/linux/slab.h
--- a/include/linux/slab.h~memcg-destroy-memcg-caches
+++ a/include/linux/slab.h
@@ -11,6 +11,8 @@
 
 #include <linux/gfp.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
+
 
 /*
  * Flags to pass to kmem_cache_create().
@@ -179,7 +181,6 @@ void kmem_cache_free(struct kmem_cache *
 #ifndef ARCH_SLAB_MINALIGN
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
-
 /*
  * This is the main placeholder for memcg-related information in kmem caches.
  * struct kmem_cache will hold a pointer to it, so the memory cost while
@@ -197,6 +198,10 @@ void kmem_cache_free(struct kmem_cache *
  * @memcg: pointer to the memcg this cache belongs to
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
+ * @dead: set to true after the memcg dies; the cache may still be around.
+ * @nr_pages: number of pages that belongs to this cache.
+ * @destroy: worker to be called whenever we are ready, or believe we may be
+ *           ready, to destroy this cache.
  */
 struct memcg_cache_params {
 	bool is_root_cache;
@@ -206,6 +211,9 @@ struct memcg_cache_params {
 			struct mem_cgroup *memcg;
 			struct list_head list;
 			struct kmem_cache *root_cache;
+			bool dead;
+			atomic_t nr_pages;
+			struct work_struct destroy;
 		};
 	};
 };
diff -puN mm/memcontrol.c~memcg-destroy-memcg-caches mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-destroy-memcg-caches
+++ a/mm/memcontrol.c
@@ -2779,6 +2779,19 @@ static inline bool memcg_can_account_kme
 		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK);
 }
 
+/*
+ * This is a bit cumbersome, but it is rarely used and avoids a backpointer
+ * in the memcg_cache_params struct.
+ */
+static struct kmem_cache *memcg_params_to_cache(struct memcg_cache_params *p)
+{
+	struct kmem_cache *cachep;
+
+	VM_BUG_ON(p->is_root_cache);
+	cachep = p->root_cache;
+	return cachep->memcg_params->memcg_caches[memcg_cache_id(p->memcg)];
+}
+
 static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
 {
 	struct res_counter *fail_res;
@@ -3056,6 +3069,31 @@ static inline void memcg_resume_kmem_acc
 	current->memcg_kmem_skip_account--;
 }
 
+static void kmem_cache_destroy_work_func(struct work_struct *w)
+{
+	struct kmem_cache *cachep;
+	struct memcg_cache_params *p;
+
+	p = container_of(w, struct memcg_cache_params, destroy);
+
+	cachep = memcg_params_to_cache(p);
+
+	if (!atomic_read(&cachep->memcg_params->nr_pages))
+		kmem_cache_destroy(cachep);
+}
+
+void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
+{
+	if (!cachep->memcg_params->dead)
+		return;
+
+	/*
+	 * We have to defer the actual destroying to a workqueue, because
+	 * we might currently be in a context that cannot sleep.
+	 */
+	schedule_work(&cachep->memcg_params->destroy);
+}
+
 static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
 {
 	char *name;
@@ -3125,6 +3163,7 @@ static struct kmem_cache *memcg_create_k
 
 	mem_cgroup_get(memcg);
 	new_cachep->memcg_params->root_cache = cachep;
+	atomic_set(&new_cachep->memcg_params->nr_pages , 0);
 
 	cachep->memcg_params->memcg_caches[idx] = new_cachep;
 	/*
@@ -3143,6 +3182,25 @@ struct create_work {
 	struct work_struct work;
 };
 
+static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
+{
+	struct kmem_cache *cachep;
+	struct memcg_cache_params *params;
+
+	if (!memcg_kmem_is_active(memcg))
+		return;
+
+	mutex_lock(&memcg->slab_caches_mutex);
+	list_for_each_entry(params, &memcg->memcg_slab_caches, list) {
+		cachep = memcg_params_to_cache(params);
+		cachep->memcg_params->dead = true;
+		INIT_WORK(&cachep->memcg_params->destroy,
+			  kmem_cache_destroy_work_func);
+		schedule_work(&cachep->memcg_params->destroy);
+	}
+	mutex_unlock(&memcg->slab_caches_mutex);
+}
+
 static void memcg_create_cache_work_func(struct work_struct *w)
 {
 	struct create_work *cw;
@@ -3358,6 +3416,10 @@ void __memcg_kmem_uncharge_pages(struct 
 	VM_BUG_ON(mem_cgroup_is_root(memcg));
 	memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
 }
+#else
+static inline void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
+{
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -5975,6 +6037,7 @@ static void mem_cgroup_css_offline(struc
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
 	mem_cgroup_reparent_charges(memcg);
+	mem_cgroup_destroy_all_caches(memcg);
 }
 
 static void mem_cgroup_css_free(struct cgroup *cont)
diff -puN mm/slab.c~memcg-destroy-memcg-caches mm/slab.c
--- a/mm/slab.c~memcg-destroy-memcg-caches
+++ a/mm/slab.c
@@ -1895,6 +1895,7 @@ static void *kmem_getpages(struct kmem_c
 		if (page->pfmemalloc)
 			SetPageSlabPfmemalloc(page + i);
 	}
+	memcg_bind_pages(cachep, cachep->gfporder);
 
 	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK)) {
 		kmemcheck_alloc_shadow(page, cachep->gfporder, flags, nodeid);
@@ -1931,6 +1932,8 @@ static void kmem_freepages(struct kmem_c
 		__ClearPageSlab(page);
 		page++;
 	}
+
+	memcg_release_pages(cachep, cachep->gfporder);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += nr_freed;
 	free_memcg_kmem_pages((unsigned long)addr, cachep->gfporder);
diff -puN mm/slab.h~memcg-destroy-memcg-caches mm/slab.h
--- a/mm/slab.h~memcg-destroy-memcg-caches
+++ a/mm/slab.h
@@ -117,6 +117,21 @@ static inline bool cache_match_memcg(str
 				(cachep->memcg_params->memcg == memcg);
 }
 
+static inline void memcg_bind_pages(struct kmem_cache *s, int order)
+{
+	if (!is_root_cache(s))
+		atomic_add(1 << order, &s->memcg_params->nr_pages);
+}
+
+static inline void memcg_release_pages(struct kmem_cache *s, int order)
+{
+	if (is_root_cache(s))
+		return;
+
+	if (atomic_sub_and_test((1 << order), &s->memcg_params->nr_pages))
+		mem_cgroup_destroy_cache(s);
+}
+
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 					struct kmem_cache *p)
 {
@@ -135,6 +150,14 @@ static inline bool cache_match_memcg(str
 	return true;
 }
 
+static inline void memcg_bind_pages(struct kmem_cache *s, int order)
+{
+}
+
+static inline void memcg_release_pages(struct kmem_cache *s, int order)
+{
+}
+
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 				      struct kmem_cache *p)
 {
diff -puN mm/slub.c~memcg-destroy-memcg-caches mm/slub.c
--- a/mm/slub.c~memcg-destroy-memcg-caches
+++ a/mm/slub.c
@@ -1344,6 +1344,7 @@ static struct page *new_slab(struct kmem
 	void *start;
 	void *last;
 	void *p;
+	int order;
 
 	BUG_ON(flags & GFP_SLAB_BUG_MASK);
 
@@ -1352,7 +1353,9 @@ static struct page *new_slab(struct kmem
 	if (!page)
 		goto out;
 
+	order = compound_order(page);
 	inc_slabs_node(s, page_to_nid(page), page->objects);
+	memcg_bind_pages(s, order);
 	page->slab_cache = s;
 	__SetPageSlab(page);
 	if (page->pfmemalloc)
@@ -1361,7 +1364,7 @@ static struct page *new_slab(struct kmem
 	start = page_address(page);
 
 	if (unlikely(s->flags & SLAB_POISON))
-		memset(start, POISON_INUSE, PAGE_SIZE << compound_order(page));
+		memset(start, POISON_INUSE, PAGE_SIZE << order);
 
 	last = start;
 	for_each_object(p, s, start, page->objects) {
@@ -1402,6 +1405,8 @@ static void __free_slab(struct kmem_cach
 
 	__ClearPageSlabPfmemalloc(page);
 	__ClearPageSlab(page);
+
+	memcg_release_pages(s, order);
 	reset_page_mapcount(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

