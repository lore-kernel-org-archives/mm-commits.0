From: akpm@linux-foundation.org
Subject: + memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch added to -mm tree
Date: Mon, 08 Dec 2014 14:55:41 -0800
Message-ID: <54862c6d.Xzi+jNlGrRlINIuB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbaLHWzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2014 17:55:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix possible use-after-free in memcg_kmem_get_cache()
has been added to the -mm tree.  Its filename is
     memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: fix possible use-after-free in memcg_kmem_get_cache()

Suppose task @t that belongs to a memory cgroup @memcg is going to
allocate an object from a kmem cache @c.  The copy of @c corresponding to
@memcg, @mc, is empty.  Then if kmem_cache_alloc races with the memory
cgroup destruction we can access the memory cgroup's copy of the cache
after it was destroyed:

CPU0				CPU1
----				----
[ current=@t
  @mc->memcg_params->nr_pages=0 ]

kmem_cache_alloc(@c):
  call memcg_kmem_get_cache(@c);
  proceed to allocation from @mc:
    alloc a page for @mc:
      ...

				move @t from @memcg
				destroy @memcg:
				  mem_cgroup_css_offline(@memcg):
				    memcg_unregister_all_caches(@memcg):
				      kmem_cache_destroy(@mc)

    add page to @mc

We could fix this issue by taking a reference to a per-memcg cache, but
that would require adding a per-cpu reference counter to per-memcg caches,
which would look cumbersome.

Instead, let's take a reference to a memory cgroup, which already has a
per-cpu reference counter, in the beginning of kmem_cache_alloc to be
dropped in the end, and move per memcg caches destruction from css offline
to css free.  As a side effect, per-memcg caches will be destroyed not one
by one, but all at once when the last page accounted to the memory cgroup
is freed.  This doesn't sound as a high price for code readability though.

Note, this patch does add some overhead to the kmem_cache_alloc hot path,
but it is pretty negligible - it's just a function call plus a per cpu
counter decrement, which is comparable to what we already have in
memcg_kmem_get_cache.  Besides, it's only relevant if there are memory
cgroups with kmem accounting enabled.  I don't think we can find a way to
handle this race w/o it, because alloc_page called from kmem_cache_alloc
may sleep so we can't flush all pending kmallocs w/o reference counting.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 ++++++++-
 include/linux/slab.h       |    2 -
 mm/memcontrol.c            |   51 ++++++++++-------------------------
 mm/slab.c                  |    2 +
 mm/slub.c                  |   14 ++++++---
 5 files changed, 39 insertions(+), 44 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache
+++ a/include/linux/memcontrol.h
@@ -400,8 +400,8 @@ int memcg_cache_id(struct mem_cgroup *me
 
 void memcg_update_array_size(int num_groups);
 
-struct kmem_cache *
-__memcg_kmem_get_cache(struct kmem_cache *cachep);
+struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep);
+void __memcg_kmem_put_cache(struct kmem_cache *cachep);
 
 int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order);
 void __memcg_uncharge_slab(struct kmem_cache *cachep, int order);
@@ -494,6 +494,12 @@ memcg_kmem_get_cache(struct kmem_cache *
 
 	return __memcg_kmem_get_cache(cachep);
 }
+
+static __always_inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
+{
+	if (memcg_kmem_enabled())
+		__memcg_kmem_put_cache(cachep);
+}
 #else
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
@@ -528,6 +534,10 @@ memcg_kmem_get_cache(struct kmem_cache *
 {
 	return cachep;
 }
+
+static inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
+{
+}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN include/linux/slab.h~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache include/linux/slab.h
--- a/include/linux/slab.h~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache
+++ a/include/linux/slab.h
@@ -493,7 +493,6 @@ static __always_inline void *kmalloc_nod
  * @memcg: pointer to the memcg this cache belongs to
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
- * @nr_pages: number of pages that belongs to this cache.
  */
 struct memcg_cache_params {
 	bool is_root_cache;
@@ -506,7 +505,6 @@ struct memcg_cache_params {
 			struct mem_cgroup *memcg;
 			struct list_head list;
 			struct kmem_cache *root_cache;
-			atomic_t nr_pages;
 		};
 	};
 };
diff -puN mm/memcontrol.c~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache
+++ a/mm/memcontrol.c
@@ -2635,7 +2635,6 @@ static void memcg_register_cache(struct
 	if (!cachep)
 		return;
 
-	css_get(&memcg->css);
 	list_add(&cachep->memcg_params->list, &memcg->memcg_slab_caches);
 
 	/*
@@ -2669,9 +2668,6 @@ static void memcg_unregister_cache(struc
 	list_del(&cachep->memcg_params->list);
 
 	kmem_cache_destroy(cachep);
-
-	/* drop the reference taken in memcg_register_cache */
-	css_put(&memcg->css);
 }
 
 int __memcg_cleanup_cache_params(struct kmem_cache *s)
@@ -2705,9 +2701,7 @@ static void memcg_unregister_all_caches(
 	mutex_lock(&memcg_slab_mutex);
 	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
-		kmem_cache_shrink(cachep);
-		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
-			memcg_unregister_cache(cachep);
+		memcg_unregister_cache(cachep);
 	}
 	mutex_unlock(&memcg_slab_mutex);
 }
@@ -2742,10 +2736,10 @@ static void __memcg_schedule_register_ca
 	struct memcg_register_cache_work *cw;
 
 	cw = kmalloc(sizeof(*cw), GFP_NOWAIT);
-	if (cw == NULL) {
-		css_put(&memcg->css);
+	if (!cw)
 		return;
-	}
+
+	css_get(&memcg->css);
 
 	cw->memcg = memcg;
 	cw->cachep = cachep;
@@ -2776,12 +2770,8 @@ static void memcg_schedule_register_cach
 int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order)
 {
 	unsigned int nr_pages = 1 << order;
-	int res;
 
-	res = memcg_charge_kmem(cachep->memcg_params->memcg, gfp, nr_pages);
-	if (!res)
-		atomic_add(nr_pages, &cachep->memcg_params->nr_pages);
-	return res;
+	return memcg_charge_kmem(cachep->memcg_params->memcg, gfp, nr_pages);
 }
 
 void __memcg_uncharge_slab(struct kmem_cache *cachep, int order)
@@ -2789,7 +2779,6 @@ void __memcg_uncharge_slab(struct kmem_c
 	unsigned int nr_pages = 1 << order;
 
 	memcg_uncharge_kmem(cachep->memcg_params->memcg, nr_pages);
-	atomic_sub(nr_pages, &cachep->memcg_params->nr_pages);
 }
 
 /*
@@ -2816,22 +2805,13 @@ struct kmem_cache *__memcg_kmem_get_cach
 	if (current->memcg_kmem_skip_account)
 		return cachep;
 
-	rcu_read_lock();
-	memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
-
+	memcg = get_mem_cgroup_from_mm(current->mm);
 	if (!memcg_kmem_is_active(memcg))
 		goto out;
 
 	memcg_cachep = cache_from_memcg_idx(cachep, memcg_cache_id(memcg));
-	if (likely(memcg_cachep)) {
-		cachep = memcg_cachep;
-		goto out;
-	}
-
-	/* The corresponding put will be done in the workqueue. */
-	if (!css_tryget_online(&memcg->css))
-		goto out;
-	rcu_read_unlock();
+	if (likely(memcg_cachep))
+		return memcg_cachep;
 
 	/*
 	 * If we are in a safe context (can wait, and not in interrupt
@@ -2846,12 +2826,17 @@ struct kmem_cache *__memcg_kmem_get_cach
 	 * defer everything.
 	 */
 	memcg_schedule_register_cache(memcg, cachep);
-	return cachep;
 out:
-	rcu_read_unlock();
+	css_put(&memcg->css);
 	return cachep;
 }
 
+void __memcg_kmem_put_cache(struct kmem_cache *cachep)
+{
+	if (!is_root_cache(cachep))
+		css_put(&cachep->memcg_params->memcg->css);
+}
+
 /*
  * We need to verify if the allocation against current->mm->owner's memcg is
  * possible for the given order. But the page is not allocated yet, so we'll
@@ -2914,10 +2899,6 @@ void __memcg_kmem_uncharge_pages(struct
 	memcg_uncharge_kmem(memcg, 1 << order);
 	page->mem_cgroup = NULL;
 }
-#else
-static inline void memcg_unregister_all_caches(struct mem_cgroup *memcg)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -4188,6 +4169,7 @@ static int memcg_init_kmem(struct mem_cg
 
 static void memcg_destroy_kmem(struct mem_cgroup *memcg)
 {
+	memcg_unregister_all_caches(memcg);
 	mem_cgroup_sockets_destroy(memcg);
 }
 #else
@@ -4797,7 +4779,6 @@ static void mem_cgroup_css_offline(struc
 	}
 	spin_unlock(&memcg->event_list_lock);
 
-	memcg_unregister_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
 }
 
diff -puN mm/slab.c~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache mm/slab.c
--- a/mm/slab.c~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache
+++ a/mm/slab.c
@@ -3182,6 +3182,7 @@ slab_alloc_node(struct kmem_cache *cache
 			memset(ptr, 0, cachep->object_size);
 	}
 
+	memcg_kmem_put_cache(cachep);
 	return ptr;
 }
 
@@ -3247,6 +3248,7 @@ slab_alloc(struct kmem_cache *cachep, gf
 			memset(objp, 0, cachep->object_size);
 	}
 
+	memcg_kmem_put_cache(cachep);
 	return objp;
 }
 
diff -puN mm/slub.c~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache mm/slub.c
--- a/mm/slub.c~memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache
+++ a/mm/slub.c
@@ -1233,13 +1233,17 @@ static inline void kfree_hook(const void
 	kmemleak_free(x);
 }
 
-static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
+static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
+						     gfp_t flags)
 {
 	flags &= gfp_allowed_mask;
 	lockdep_trace_alloc(flags);
 	might_sleep_if(flags & __GFP_WAIT);
 
-	return should_failslab(s->object_size, flags, s->flags);
+	if (should_failslab(s->object_size, flags, s->flags))
+		return NULL;
+
+	return memcg_kmem_get_cache(s, flags);
 }
 
 static inline void slab_post_alloc_hook(struct kmem_cache *s,
@@ -1248,6 +1252,7 @@ static inline void slab_post_alloc_hook(
 	flags &= gfp_allowed_mask;
 	kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
 	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags, flags);
+	memcg_kmem_put_cache(s);
 }
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
@@ -2383,10 +2388,9 @@ static __always_inline void *slab_alloc_
 	struct page *page;
 	unsigned long tid;
 
-	if (slab_pre_alloc_hook(s, gfpflags))
+	s = slab_pre_alloc_hook(s, gfpflags);
+	if (!s)
 		return NULL;
-
-	s = memcg_kmem_get_cache(s, gfpflags);
 redo:
 	/*
 	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

