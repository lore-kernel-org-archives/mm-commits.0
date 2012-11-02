From: akpm@linux-foundation.org
Subject: + memcg-destroy-memcg-caches.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:04:46 -0700
Message-ID: <20121102000447.047355C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:50660 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992641Ab2KBAEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:04:51 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so194003lah.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:04:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg: destroy memcg caches
has been added to the -mm tree.  Its filename is
     memcg-destroy-memcg-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 include/linux/slab.h       |    8 ++++
 mm/memcontrol.c            |   63 +++++++++++++++++++++++++++++++++++
 mm/slab.c                  |    3 +
 mm/slab.h                  |   23 ++++++++++++
 mm/slub.c                  |    7 +++
 6 files changed, 105 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-destroy-memcg-caches include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-destroy-memcg-caches
+++ a/include/linux/memcontrol.h
@@ -446,6 +446,8 @@ void memcg_update_array_size(int num_gro
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
@@ -180,6 +180,7 @@ void kmem_cache_free(struct kmem_cache *
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
+#include <linux/workqueue.h>
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
@@ -2748,6 +2748,19 @@ static inline bool memcg_can_account_kme
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
@@ -3029,6 +3042,31 @@ static inline void memcg_resume_kmem_acc
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
@@ -3102,6 +3140,7 @@ static struct kmem_cache *memcg_create_k
 
 	mem_cgroup_get(memcg);
 	new_cachep->memcg_params->root_cache = cachep;
+	atomic_set(&new_cachep->memcg_params->nr_pages , 0);
 
 	cachep->memcg_params->memcg_caches[idx] = new_cachep;
 	/*
@@ -3120,6 +3159,25 @@ struct create_work {
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
@@ -3335,6 +3393,10 @@ void __memcg_kmem_uncharge_pages(struct 
 	VM_BUG_ON(mem_cgroup_is_root(memcg));
 	memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
 }
+#else
+static inline void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
+{
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -5979,6 +6041,7 @@ static int mem_cgroup_pre_destroy(struct
 
 	css_get(&memcg->css);
 	ret = mem_cgroup_reparent_charges(memcg);
+	mem_cgroup_destroy_all_caches(memcg);
 	css_put(&memcg->css);
 
 	return ret;
diff -puN mm/slab.c~memcg-destroy-memcg-caches mm/slab.c
--- a/mm/slab.c~memcg-destroy-memcg-caches
+++ a/mm/slab.c
@@ -1936,6 +1936,7 @@ static void *kmem_getpages(struct kmem_c
 		if (page->pfmemalloc)
 			SetPageSlabPfmemalloc(page + i);
 	}
+	memcg_bind_pages(cachep, cachep->gfporder);
 
 	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK)) {
 		kmemcheck_alloc_shadow(page, cachep->gfporder, flags, nodeid);
@@ -1972,6 +1973,8 @@ static void kmem_freepages(struct kmem_c
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
@@ -109,6 +109,21 @@ static inline bool cache_match_memcg(str
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
@@ -127,6 +142,14 @@ static inline bool cache_match_memcg(str
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
@@ -1346,6 +1346,7 @@ static struct page *new_slab(struct kmem
 	void *start;
 	void *last;
 	void *p;
+	int order;
 
 	BUG_ON(flags & GFP_SLAB_BUG_MASK);
 
@@ -1354,7 +1355,9 @@ static struct page *new_slab(struct kmem
 	if (!page)
 		goto out;
 
+	order = compound_order(page);
 	inc_slabs_node(s, page_to_nid(page), page->objects);
+	memcg_bind_pages(s, order);
 	page->slab_cache = s;
 	__SetPageSlab(page);
 	if (page->pfmemalloc)
@@ -1363,7 +1366,7 @@ static struct page *new_slab(struct kmem
 	start = page_address(page);
 
 	if (unlikely(s->flags & SLAB_POISON))
-		memset(start, POISON_INUSE, PAGE_SIZE << compound_order(page));
+		memset(start, POISON_INUSE, PAGE_SIZE << order);
 
 	last = start;
 	for_each_object(p, s, start, page->objects) {
@@ -1404,6 +1407,8 @@ static void __free_slab(struct kmem_cach
 
 	__ClearPageSlabPfmemalloc(page);
 	__ClearPageSlab(page);
+
+	memcg_release_pages(s, order);
 	reset_page_mapcount(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

