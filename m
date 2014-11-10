From: akpm@linux-foundation.org
Subject: [withdrawn] memcg-do-not-destroy-kmem-caches-on-css-offline.patch removed from -mm tree
Date: Mon, 10 Nov 2014 14:15:37 -0800
Message-ID: <54613909.SXd603rP+3WYNFzC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKJWPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:15:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not destroy kmem caches on css offline
has been removed from the -mm tree.  Its filename was
     memcg-do-not-destroy-kmem-caches-on-css-offline.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: do not destroy kmem caches on css offline

Currently, each kmem active memory cgroup has its own set of kmem caches. 
The caches are only used by the memory cgroup they were created for, so
when the cgroup is taken offline they must be destroyed.  However, we
can't easily destroy all the caches on css offline, because they still may
contain objects accounted to the cgroup.  Actually, we don't bother
destroying busy caches on css offline at all, effectively leaking them. 
To make this scheme work as it was intended to, we have to introduce a
kind of asynchronous caches destruction, which is going to be quite a
complex stuff, because we'd have to handle a lot of various race
conditions.  And even if we manage to solve them all, kmem caches created
for memory cgroups that are now dead will be dangling indefinitely long
wasting memory.

In this patch set I implement a different approach, which can be
described by the following statements:

 1. Never destroy per memcg kmem caches (except the root cache is
    destroyed, of course).

 2. Reuse kmemcg_id and therefore the set of per memcg kmem caches left
    from a dead memory cgroup.

 3. After allocating a kmem object, check if the slab is accounted to
    the proper (i.e. current) memory cgroup. If it doesn't recharge it.

The benefits are:

 - It's much simpler than what we have now, even though the current
   implementation is incomplete.

 - The number of per cgroup caches of the same kind cannot be be greater
   than the maximal number of online kmem active memory cgroups that
   have ever existed simultaneously. Currently it is unlimited, which is
   really bad.

 - Once a new memory cgroup starts using a cache that was used by a dead
   cgroup before, it will be recharging slabs accounted to the dead
   cgroup while allocating objects from the cache. Therefore all
   references to the old cgroup will be put sooner or later, and it will
   be freed. Currently, cgroups that have kmem objects accounted to them
   on css offline leak for good.



This patch (of 8):

Currently, we try to destroy per memcg kmem caches on css offline.  Since
a cache can contain active objects when the memory cgroup is removed, we
can't destroy all caches immediately and therefore should introduce
asynchronous destruction for this scheme to work properly.  However, this
requires a lot of trickery and complex synchronization stuff, so I'm
planning to go another way.  I'm going to reuse caches left from dead
memory cgroups instead of recreating them.  This patch makes the first
step in this direction: it removes caches destruction from css offline.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    4 ---
 mm/memcontrol.c      |   52 +----------------------------------------
 2 files changed, 2 insertions(+), 54 deletions(-)

diff -puN include/linux/slab.h~memcg-do-not-destroy-kmem-caches-on-css-offline include/linux/slab.h
--- a/include/linux/slab.h~memcg-do-not-destroy-kmem-caches-on-css-offline
+++ a/include/linux/slab.h
@@ -491,9 +491,7 @@ static __always_inline void *kmalloc_nod
  * Child caches will hold extra metadata needed for its operation. Fields are:
  *
  * @memcg: pointer to the memcg this cache belongs to
- * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
- * @nr_pages: number of pages that belongs to this cache.
  */
 struct memcg_cache_params {
 	bool is_root_cache;
@@ -504,9 +502,7 @@ struct memcg_cache_params {
 		};
 		struct {
 			struct mem_cgroup *memcg;
-			struct list_head list;
 			struct kmem_cache *root_cache;
-			atomic_t nr_pages;
 		};
 	};
 };
diff -puN mm/memcontrol.c~memcg-do-not-destroy-kmem-caches-on-css-offline mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-destroy-kmem-caches-on-css-offline
+++ a/mm/memcontrol.c
@@ -344,9 +344,6 @@ struct mem_cgroup {
 	struct cg_proto tcp_mem;
 #endif
 #if defined(CONFIG_MEMCG_KMEM)
-	/* analogous to slab_common's slab_caches list, but per-memcg;
-	 * protected by memcg_slab_mutex */
-	struct list_head memcg_slab_caches;
         /* Index in the kmem_cache->memcg_params->memcg_caches array */
 	int kmemcg_id;
 #endif
@@ -2489,23 +2486,10 @@ static void commit_charge(struct page *p
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * The memcg_slab_mutex is held whenever a per memcg kmem cache is created or
- * destroyed. It protects memcg_caches arrays and memcg_slab_caches lists.
+ * destroyed. It protects memcg_caches arrays.
  */
 static DEFINE_MUTEX(memcg_slab_mutex);
 
-/*
- * This is a bit cumbersome, but it is rarely used and avoids a backpointer
- * in the memcg_cache_params struct.
- */
-static struct kmem_cache *memcg_params_to_cache(struct memcg_cache_params *p)
-{
-	struct kmem_cache *cachep;
-
-	VM_BUG_ON(p->is_root_cache);
-	cachep = p->root_cache;
-	return cache_from_memcg_idx(cachep, memcg_cache_id(p->memcg));
-}
-
 static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
 			     unsigned long nr_pages)
 {
@@ -2647,7 +2631,6 @@ static void memcg_register_cache(struct
 		return;
 
 	css_get(&memcg->css);
-	list_add(&cachep->memcg_params->list, &memcg->memcg_slab_caches);
 
 	/*
 	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
@@ -2677,8 +2660,6 @@ static void memcg_unregister_cache(struc
 	BUG_ON(root_cache->memcg_params->memcg_caches[id] != cachep);
 	root_cache->memcg_params->memcg_caches[id] = NULL;
 
-	list_del(&cachep->memcg_params->list);
-
 	kmem_cache_destroy(cachep);
 
 	/* drop the reference taken in memcg_register_cache */
@@ -2736,24 +2717,6 @@ int __memcg_cleanup_cache_params(struct
 	return failed;
 }
 
-static void memcg_unregister_all_caches(struct mem_cgroup *memcg)
-{
-	struct kmem_cache *cachep;
-	struct memcg_cache_params *params, *tmp;
-
-	if (!memcg_kmem_is_active(memcg))
-		return;
-
-	mutex_lock(&memcg_slab_mutex);
-	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
-		cachep = memcg_params_to_cache(params);
-		kmem_cache_shrink(cachep);
-		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
-			memcg_unregister_cache(cachep);
-	}
-	mutex_unlock(&memcg_slab_mutex);
-}
-
 struct memcg_register_cache_work {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *cachep;
@@ -2818,12 +2781,8 @@ static void memcg_schedule_register_cach
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
@@ -2831,7 +2790,6 @@ void __memcg_uncharge_slab(struct kmem_c
 	unsigned int nr_pages = 1 << order;
 
 	memcg_uncharge_kmem(cachep->memcg_params->memcg, nr_pages);
-	atomic_sub(nr_pages, &cachep->memcg_params->nr_pages);
 }
 
 /*
@@ -2985,10 +2943,6 @@ void __memcg_kmem_uncharge_pages(struct
 	memcg_uncharge_kmem(memcg, 1 << order);
 	page->mem_cgroup = NULL;
 }
-#else
-static inline void memcg_unregister_all_caches(struct mem_cgroup *memcg)
-{
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -3571,7 +3525,6 @@ static int memcg_activate_kmem(struct me
 	}
 
 	memcg->kmemcg_id = memcg_id;
-	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
 
 	/*
 	 * We couldn't have accounted to this cgroup, because it hasn't got the
@@ -4885,7 +4838,6 @@ static void mem_cgroup_css_offline(struc
 	}
 	spin_unlock(&memcg->event_list_lock);
 
-	memcg_unregister_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
 }
 
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
slab-charge-slab-pages-to-the-current-memory-cgroup.patch
memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg.patch
memcg-zap-memcg_unregister_cache.patch
memcg-free-kmem-cache-id-on-css-offline.patch
memcg-introduce-memcg_kmem_should_charge-helper.patch
slab-introduce-slab_free-helper.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2-checkpatch-fixes.patch
memcg-zap-kmem_account_flags.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

