From: akpm@linux-foundation.org
Subject: [withdrawn]
 memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch removed from
 -mm tree
Date: Tue, 15 Jul 2014 12:17:21 -0700
Message-ID: <53c57e41.v10d7J4oJD65nbW2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:45374 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003AbaGOTRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 15:17:22 -0400
Received: by mail-pd0-f201.google.com with SMTP id v10so1365995pde.0
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 12:17:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: wait for kfree's to finish before destroying cache
has been removed from the -mm tree.  Its filename was
     memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: wait for kfree's to finish before destroying cache

kmem_cache_free doesn't expect that the cache can be destroyed as soon as
the object is freed, e.g.  SLUB's implementation may want to update cache
stats after putting the object to the free list.

Therefore we should wait for all kmem_cache_free's to finish before
proceeding to cache destruction.  Since both SLAB and SLUB versions of
kmem_cache_free are non-preemptable, we wait for rcu-sched grace period to
elapse.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    6 ++----
 mm/memcontrol.c      |   34 ++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 6 deletions(-)

diff -puN include/linux/slab.h~memcg-wait-for-kfrees-to-finish-before-destroying-cache include/linux/slab.h
--- a/include/linux/slab.h~memcg-wait-for-kfrees-to-finish-before-destroying-cache
+++ a/include/linux/slab.h
@@ -532,11 +532,9 @@ static __always_inline void *kmalloc_nod
  */
 struct memcg_cache_params {
 	bool is_root_cache;
+	struct rcu_head rcu_head;
 	union {
-		struct {
-			struct rcu_head rcu_head;
-			struct kmem_cache *memcg_caches[0];
-		};
+		struct kmem_cache *memcg_caches[0];
 		struct {
 			struct mem_cgroup *memcg;
 			struct list_head list;
diff -puN mm/memcontrol.c~memcg-wait-for-kfrees-to-finish-before-destroying-cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-wait-for-kfrees-to-finish-before-destroying-cache
+++ a/mm/memcontrol.c
@@ -3194,6 +3194,14 @@ static void memcg_unregister_cache_func(
 	mutex_unlock(&memcg_slab_mutex);
 }
 
+static void memcg_unregister_cache_rcu_func(struct rcu_head *rcu)
+{
+	struct memcg_cache_params *params =
+		container_of(rcu, struct memcg_cache_params, rcu_head);
+
+	schedule_work(&params->unregister_work);
+}
+
 /*
  * During the creation a new cache, we need to disable our accounting mechanism
  * altogether. This is true even if we are not creating, but rather just
@@ -3249,6 +3257,7 @@ static void memcg_unregister_all_caches(
 {
 	struct kmem_cache *cachep;
 	struct memcg_cache_params *params, *tmp;
+	LIST_HEAD(empty_caches);
 
 	if (!memcg_kmem_is_active(memcg))
 		return;
@@ -3261,7 +3270,26 @@ static void memcg_unregister_all_caches(
 		kmem_cache_shrink(cachep);
 
 		if (atomic_long_dec_and_test(&cachep->memcg_params->refcnt))
-			memcg_unregister_cache(cachep);
+			list_move(&cachep->memcg_params->list, &empty_caches);
+	}
+
+	/*
+	 * kmem_cache_free doesn't expect that the cache can be destroyed as
+	 * soon as the object is freed, e.g. SLUB's implementation may want to
+	 * update cache stats after putting the object to the free list.
+	 *
+	 * Therefore we should wait for all kmem_cache_free's to finish before
+	 * proceeding to cache destruction. Since both SLAB and SLUB versions
+	 * of kmem_cache_free are non-preemptable, we wait for rcu-sched grace
+	 * period to elapse.
+	 */
+	synchronize_sched();
+
+	while (!list_empty(&empty_caches)) {
+		params = list_first_entry(&empty_caches,
+					  struct memcg_cache_params, list);
+		cachep = memcg_params_to_cache(params);
+		memcg_unregister_cache(cachep);
 	}
 	mutex_unlock(&memcg_slab_mutex);
 }
@@ -3343,7 +3371,9 @@ void __memcg_uncharge_slab(struct kmem_c
 	memcg_uncharge_kmem(cachep->memcg_params->memcg, PAGE_SIZE << order);
 
 	if (unlikely(atomic_long_dec_and_test(&cachep->memcg_params->refcnt)))
-		schedule_work(&cachep->memcg_params->unregister_work);
+		/* see memcg_unregister_all_caches */
+		call_rcu_sched(&cachep->memcg_params->rcu_head,
+			       memcg_unregister_cache_rcu_func);
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
fork-make-mm_init_owner-static.patch
linux-next.patch

