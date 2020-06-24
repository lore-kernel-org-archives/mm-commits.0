From: akpm@linux-foundation.org
Subject: + mm-memcg-slab-simplify-memcg-cache-creation.patch added
 to -mm tree
Date: Wed, 24 Jun 2020 14:47:20 -0700
Message-ID: <20200624214720.7kvh6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404274AbgFXVrW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org, shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org, cl@linux.com, guro@fb.com


The patch titled
     Subject: mm: memcg/slab: simplify memcg cache creation
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-simplify-memcg-cache-creation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-simplify-memcg-cache-creation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-simplify-memcg-cache-creation.patch

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
Subject: mm: memcg/slab: simplify memcg cache creation

Because the number of non-root kmem_caches doesn't depend on the number of
memory cgroups anymore and is generally not very big, there is no more
need for a dedicated workqueue.

Also, as there is no more need to pass any arguments to the
memcg_create_kmem_cache() except the root kmem_cache, it's possible to
just embed the work structure into the kmem_cache and avoid the dynamic
allocation of the work structure.

This will also simplify the synchronization: for each root kmem_cache
there is only one work.  So there will be no more concurrent attempts to
create a non-root kmem_cache for a root kmem_cache: the second and all
following attempts to queue the work will fail.

On the kmem_cache destruction path there is no more need to call the
expensive flush_workqueue() and wait for all pending works to be finished.
Instead, cancel_work_sync() can be used to cancel/wait for only one work.

Link: http://lkml.kernel.org/r/20200623174037.3951353-14-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 
 mm/memcontrol.c            |   48 -----------------------------------
 mm/slab.h                  |    2 +
 mm/slab_common.c           |   22 ++++++++--------
 4 files changed, 15 insertions(+), 58 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-simplify-memcg-cache-creation
+++ a/include/linux/memcontrol.h
@@ -1418,7 +1418,6 @@ int obj_cgroup_charge(struct obj_cgroup
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
 
 extern struct static_key_false memcg_kmem_enabled_key;
-extern struct workqueue_struct *memcg_kmem_cache_wq;
 
 extern int memcg_nr_cache_ids;
 void memcg_get_cache_ids(void);
--- a/mm/memcontrol.c~mm-memcg-slab-simplify-memcg-cache-creation
+++ a/mm/memcontrol.c
@@ -399,8 +399,6 @@ void memcg_put_cache_ids(void)
  */
 DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
-
-struct workqueue_struct *memcg_kmem_cache_wq;
 #endif
 
 static int memcg_shrinker_map_size;
@@ -2902,39 +2900,6 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
-struct memcg_kmem_cache_create_work {
-	struct kmem_cache *cachep;
-	struct work_struct work;
-};
-
-static void memcg_kmem_cache_create_func(struct work_struct *w)
-{
-	struct memcg_kmem_cache_create_work *cw =
-		container_of(w, struct memcg_kmem_cache_create_work, work);
-	struct kmem_cache *cachep = cw->cachep;
-
-	memcg_create_kmem_cache(cachep);
-
-	kfree(cw);
-}
-
-/*
- * Enqueue the creation of a per-memcg kmem_cache.
- */
-static void memcg_schedule_kmem_cache_create(struct kmem_cache *cachep)
-{
-	struct memcg_kmem_cache_create_work *cw;
-
-	cw = kmalloc(sizeof(*cw), GFP_NOWAIT | __GFP_NOWARN);
-	if (!cw)
-		return;
-
-	cw->cachep = cachep;
-	INIT_WORK(&cw->work, memcg_kmem_cache_create_func);
-
-	queue_work(memcg_kmem_cache_wq, &cw->work);
-}
-
 /**
  * memcg_kmem_get_cache: select memcg or root cache for allocation
  * @cachep: the original global kmem cache
@@ -2951,7 +2916,7 @@ struct kmem_cache *memcg_kmem_get_cache(
 
 	memcg_cachep = READ_ONCE(cachep->memcg_params.memcg_cache);
 	if (unlikely(!memcg_cachep)) {
-		memcg_schedule_kmem_cache_create(cachep);
+		queue_work(system_wq, &cachep->memcg_params.work);
 		return cachep;
 	}
 
@@ -7026,17 +6991,6 @@ static int __init mem_cgroup_init(void)
 {
 	int cpu, node;
 
-#ifdef CONFIG_MEMCG_KMEM
-	/*
-	 * Kmem cache creation is mostly done with the slab_mutex held,
-	 * so use a workqueue with limited concurrency to avoid stalling
-	 * all worker threads in case lots of cgroups are created and
-	 * destroyed simultaneously.
-	 */
-	memcg_kmem_cache_wq = alloc_workqueue("memcg_kmem_cache", 0, 1);
-	BUG_ON(!memcg_kmem_cache_wq);
-#endif
-
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
--- a/mm/slab_common.c~mm-memcg-slab-simplify-memcg-cache-creation
+++ a/mm/slab_common.c
@@ -132,10 +132,18 @@ int __kmem_cache_alloc_bulk(struct kmem_
 
 LIST_HEAD(slab_root_caches);
 
+static void memcg_kmem_cache_create_func(struct work_struct *work)
+{
+	struct kmem_cache *cachep = container_of(work, struct kmem_cache,
+						 memcg_params.work);
+	memcg_create_kmem_cache(cachep);
+}
+
 void slab_init_memcg_params(struct kmem_cache *s)
 {
 	s->memcg_params.root_cache = NULL;
 	s->memcg_params.memcg_cache = NULL;
+	INIT_WORK(&s->memcg_params.work, memcg_kmem_cache_create_func);
 }
 
 static void init_memcg_params(struct kmem_cache *s,
@@ -584,15 +592,9 @@ static int shutdown_memcg_caches(struct
 	return 0;
 }
 
-static void flush_memcg_workqueue(struct kmem_cache *s)
+static void cancel_memcg_cache_creation(struct kmem_cache *s)
 {
-	/*
-	 * SLAB and SLUB create memcg kmem_caches through workqueue and SLUB
-	 * deactivates the memcg kmem_caches through workqueue. Make sure all
-	 * previous workitems on workqueue are processed.
-	 */
-	if (likely(memcg_kmem_cache_wq))
-		flush_workqueue(memcg_kmem_cache_wq);
+	cancel_work_sync(&s->memcg_params.work);
 }
 #else
 static inline int shutdown_memcg_caches(struct kmem_cache *s)
@@ -600,7 +602,7 @@ static inline int shutdown_memcg_caches(
 	return 0;
 }
 
-static inline void flush_memcg_workqueue(struct kmem_cache *s)
+static inline void cancel_memcg_cache_creation(struct kmem_cache *s)
 {
 }
 #endif /* CONFIG_MEMCG_KMEM */
@@ -619,7 +621,7 @@ void kmem_cache_destroy(struct kmem_cach
 	if (unlikely(!s))
 		return;
 
-	flush_memcg_workqueue(s);
+	cancel_memcg_cache_creation(s);
 
 	get_online_cpus();
 	get_online_mems();
--- a/mm/slab.h~mm-memcg-slab-simplify-memcg-cache-creation
+++ a/mm/slab.h
@@ -45,12 +45,14 @@ struct kmem_cache {
  * @memcg_cache: pointer to memcg kmem cache, used by all non-root memory
  *		cgroups.
  * @root_caches_node: list node for slab_root_caches list.
+ * @work: work struct used to create the non-root cache.
  */
 struct memcg_cache_params {
 	struct kmem_cache *root_cache;
 
 	struct kmem_cache *memcg_cache;
 	struct list_head __root_caches_node;
+	struct work_struct work;
 };
 #endif /* CONFIG_SLOB */
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch
mm-memcg-prepare-for-byte-sized-vmstat-items.patch
mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
mm-slub-implement-slub-version-of-obj_to_index.patch
mm-memcg-slab-obj_cgroup-api.patch
mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch
mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch
mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch
mm-memcg-slab-deprecate-memorykmemslabinfo.patch
mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-accounted-allocations.patch
mm-memcg-slab-simplify-memcg-cache-creation.patch
mm-memcg-slab-remove-memcg_kmem_get_cache.patch
mm-memcg-slab-deprecate-slab_root_caches.patch
mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations.patch
kselftests-cgroup-add-kernel-memory-accounting-tests.patch
tools-cgroup-add-memcg_slabinfopy-tool.patch
percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
