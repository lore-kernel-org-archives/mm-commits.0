From: akpm@linux-foundation.org
Subject: [withdrawn]
 memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch removed from
 -mm tree
Date: Tue, 15 Jul 2014 12:17:27 -0700
Message-ID: <53c57e47.YgVxtzOPChi4kL09%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:33859 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbaGOTWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 15:22:49 -0400
Received: by mail-qc0-f201.google.com with SMTP id m20so690584qcx.4
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 12:22:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: mark caches that belong to offline memcgs as dead
has been removed from the -mm tree.  Its filename was
     memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: mark caches that belong to offline memcgs as dead

This will be used by the next patches.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 ++
 mm/memcontrol.c      |    3 +++
 mm/slab.h            |   25 +++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff -puN include/linux/slab.h~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead include/linux/slab.h
--- a/include/linux/slab.h~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead
+++ a/include/linux/slab.h
@@ -527,6 +527,7 @@ static __always_inline void *kmalloc_nod
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
  * @refcnt: reference counter
+ * @dead: set to true when owner memcg is turned offline
  * @unregister_work: worker to destroy the cache
  */
 struct memcg_cache_params {
@@ -541,6 +542,7 @@ struct memcg_cache_params {
 			struct list_head list;
 			struct kmem_cache *root_cache;
 			atomic_long_t refcnt;
+			bool dead;
 			struct work_struct unregister_work;
 		};
 	};
diff -puN mm/memcontrol.c~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead
+++ a/mm/memcontrol.c
@@ -3256,7 +3256,10 @@ static void memcg_unregister_all_caches(
 	mutex_lock(&memcg_slab_mutex);
 	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
+
+		memcg_cache_mark_dead(cachep);
 		kmem_cache_shrink(cachep);
+
 		if (atomic_long_dec_and_test(&cachep->memcg_params->refcnt))
 			memcg_unregister_cache(cachep);
 	}
diff -puN mm/slab.h~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead mm/slab.h
--- a/mm/slab.h~memcg-mark-caches-that-belong-to-offline-memcgs-as-dead
+++ a/mm/slab.h
@@ -121,6 +121,26 @@ static inline bool is_root_cache(struct
 	return !s->memcg_params || s->memcg_params->is_root_cache;
 }
 
+static inline bool memcg_cache_dead(struct kmem_cache *s)
+{
+	if (is_root_cache(s))
+		return false;
+
+	/*
+	 * Since this function can be called without holding any locks, it
+	 * needs a barrier here to guarantee the read won't be reordered.
+	 */
+	smp_rmb();
+	return s->memcg_params->dead;
+}
+
+static inline void memcg_cache_mark_dead(struct kmem_cache *s)
+{
+	BUG_ON(is_root_cache(s));
+	s->memcg_params->dead = true;
+	smp_wmb();		/* matches rmb in memcg_cache_dead() */
+}
+
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 					struct kmem_cache *p)
 {
@@ -203,6 +223,11 @@ static inline bool is_root_cache(struct
 	return true;
 }
 
+static inline bool memcg_cache_dead(struct kmem_cache *s)
+{
+	return false;
+}
+
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 				      struct kmem_cache *p)
 {
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
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

