From: akpm@linux-foundation.org
Subject: [withdrawn]
 memcg-destroy-kmem-caches-when-last-slab-is-freed.patch removed from -mm
 tree
Date: Tue, 15 Jul 2014 12:17:29 -0700
Message-ID: <53c57e49.+eWU/w58KQQ2wK7Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:44139 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170AbaGOTRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 15:17:30 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so1081383oac.5
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 12:17:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: destroy kmem caches when last slab is freed
has been removed from the -mm tree.  Its filename was
     memcg-destroy-kmem-caches-when-last-slab-is-freed.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: destroy kmem caches when last slab is freed

When the memcg_cache_params->refcnt goes to 0, schedule the worker that
will unregister the cache.  To prevent this from happening when the owner
memcg is alive, keep the refcnt incremented during memcg lifetime.

Note, this doesn't guarantee that the cache that belongs to a dead memcg
will go away as soon as the last object is freed, because SL[AU]B
implementation can cache empty slabs for performance reasons.  Hence the
cache may be hanging around indefinitely after memcg offline.  This is to
be resolved by the next patches.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 ++
 mm/memcontrol.c      |   22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff -puN include/linux/slab.h~memcg-destroy-kmem-caches-when-last-slab-is-freed include/linux/slab.h
--- a/include/linux/slab.h~memcg-destroy-kmem-caches-when-last-slab-is-freed
+++ a/include/linux/slab.h
@@ -527,6 +527,7 @@ static __always_inline void *kmalloc_nod
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
  * @refcnt: reference counter
+ * @unregister_work: worker to destroy the cache
  */
 struct memcg_cache_params {
 	bool is_root_cache;
@@ -540,6 +541,7 @@ struct memcg_cache_params {
 			struct list_head list;
 			struct kmem_cache *root_cache;
 			atomic_long_t refcnt;
+			struct work_struct unregister_work;
 		};
 	};
 };
diff -puN mm/memcontrol.c~memcg-destroy-kmem-caches-when-last-slab-is-freed mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-destroy-kmem-caches-when-last-slab-is-freed
+++ a/mm/memcontrol.c
@@ -3076,6 +3076,8 @@ int memcg_update_cache_size(struct kmem_
 	return 0;
 }
 
+static void memcg_unregister_cache_func(struct work_struct *work);
+
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache)
 {
@@ -3097,6 +3099,9 @@ int memcg_alloc_cache_params(struct mem_
 	if (memcg) {
 		s->memcg_params->memcg = memcg;
 		s->memcg_params->root_cache = root_cache;
+		atomic_long_set(&s->memcg_params->refcnt, 1);
+		INIT_WORK(&s->memcg_params->unregister_work,
+			  memcg_unregister_cache_func);
 		css_get(&memcg->css);
 	} else
 		s->memcg_params->is_root_cache = true;
@@ -3178,6 +3183,17 @@ static void memcg_unregister_cache(struc
 	kmem_cache_destroy(cachep);
 }
 
+static void memcg_unregister_cache_func(struct work_struct *work)
+{
+	struct memcg_cache_params *params =
+		container_of(work, struct memcg_cache_params, unregister_work);
+	struct kmem_cache *cachep = memcg_params_to_cache(params);
+
+	mutex_lock(&memcg_slab_mutex);
+	memcg_unregister_cache(cachep);
+	mutex_unlock(&memcg_slab_mutex);
+}
+
 /*
  * During the creation a new cache, we need to disable our accounting mechanism
  * altogether. This is true even if we are not creating, but rather just
@@ -3241,7 +3257,7 @@ static void memcg_unregister_all_caches(
 	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
 		kmem_cache_shrink(cachep);
-		if (atomic_long_read(&cachep->memcg_params->refcnt) == 0)
+		if (atomic_long_dec_and_test(&cachep->memcg_params->refcnt))
 			memcg_unregister_cache(cachep);
 	}
 	mutex_unlock(&memcg_slab_mutex);
@@ -3322,7 +3338,9 @@ int __memcg_charge_slab(struct kmem_cach
 void __memcg_uncharge_slab(struct kmem_cache *cachep, int order)
 {
 	memcg_uncharge_kmem(cachep->memcg_params->memcg, PAGE_SIZE << order);
-	atomic_long_dec(&cachep->memcg_params->refcnt);
+
+	if (unlikely(atomic_long_dec_and_test(&cachep->memcg_params->refcnt)))
+		schedule_work(&cachep->memcg_params->unregister_work);
 }
 
 /*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
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

