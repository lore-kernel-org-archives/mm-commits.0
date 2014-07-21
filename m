From: akpm@linux-foundation.org
Subject: + memcg-release-memcg_cache_id-on-css-offline.patch added to -mm
 tree
Date: Mon, 21 Jul 2014 14:37:42 -0700
Message-ID: <53cd8826.K94LlE5ZMb66Es5l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:59592 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbaGUVhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 17:37:43 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so2483646iec.5
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 14:37:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: release memcg_cache_id on css offline
has been added to the -mm tree.  Its filename is
     memcg-release-memcg_cache_id-on-css-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-release-memcg_cache_id-on-css-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-release-memcg_cache_id-on-css-offline.patch

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
Subject: memcg: release memcg_cache_id on css offline

The memcg_cache_id (mem_cgroup->kmemcg_id) is used as the index in root
cache's memcg_cache_params->memcg_caches array.  Whenever a new kmem
active cgroup is created we must allocate an id for it.  As a result, the
array size must always be greater than or equal to the number of memory
cgroups that have memcg_cache_id assigned to them.

Currently we release the id only on css free.  This is bad, because css
can be zombieing around for quite a long time after css offline, occupying
an array slot and making the arrays grow larger and larger.  Although the
number of arrays is limited - only root kmem caches have them - we can
still experience problems while creating new kmem active cgroups, because
they might require arrays relocation and each array relocation will
require costly high-order page allocations if there are a lot of ids
allocated.  The situation will become even worse when per-memcg list_lru's
are introduced, because each super block has a list_lru, and the number of
super blocks is practically unlimited.

So let's release memcg_cache_id on css offline - there's nothing that
prevents us from doing so.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-release-memcg_cache_id-on-css-offline mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-release-memcg_cache_id-on-css-offline
+++ a/mm/memcontrol.c
@@ -648,10 +648,8 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
 static void disarm_kmem_keys(struct mem_cgroup *memcg)
 {
-	if (memcg_kmem_is_active(memcg)) {
+	if (memcg_kmem_is_active(memcg))
 		static_key_slow_dec(&memcg_kmem_enabled_key);
-		ida_simple_remove(&kmem_limited_groups, memcg->kmemcg_id);
-	}
 	/*
 	 * This check can't live in kmem destruction function,
 	 * since the charges will outlive the cgroup
@@ -3017,6 +3015,12 @@ static void memcg_register_cache(struct
 	lockdep_assert_held(&memcg_slab_mutex);
 
 	id = memcg_cache_id(memcg);
+	/*
+	 * The cgroup was taken offline while the create work was pending,
+	 * nothing to do then.
+	 */
+	if (id < 0)
+		return;
 
 	/*
 	 * Since per-memcg caches are created asynchronously on first
@@ -3071,8 +3075,17 @@ static void memcg_unregister_cache(struc
 	memcg = cachep->memcg_params->memcg;
 	id = memcg_cache_id(memcg);
 
-	BUG_ON(root_cache->memcg_params->memcg_caches[id] != cachep);
-	root_cache->memcg_params->memcg_caches[id] = NULL;
+	/*
+	 * This function can be called both after and before css offline. If
+	 * it's called before css offline, which happens on the root cache
+	 * destruction, we should clear the slot corresponding to the cache in
+	 * memcg_caches array. Otherwise the slot must have already been
+	 * cleared in memcg_unregister_all_caches.
+	 */
+	if (id >= 0) {
+		BUG_ON(root_cache->memcg_params->memcg_caches[id] != cachep);
+		root_cache->memcg_params->memcg_caches[id] = NULL;
+	}
 
 	list_del(&cachep->memcg_params->list);
 
@@ -3124,19 +3137,27 @@ void __memcg_cleanup_cache_params(struct
 static void memcg_unregister_all_caches(struct mem_cgroup *memcg)
 {
 	struct memcg_cache_params *params, *tmp;
+	int id = memcg_cache_id(memcg);
 
 	if (!memcg_kmem_is_active(memcg))
 		return;
 
 	mutex_lock(&memcg_slab_mutex);
+	memcg->kmemcg_id = -1;
 	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
 		struct kmem_cache *cachep = params->cachep;
+		struct kmem_cache *root_cache = params->root_cache;
+
+		BUG_ON(root_cache->memcg_params->memcg_caches[id] != cachep);
+		root_cache->memcg_params->memcg_caches[id] = NULL;
 
 		kmem_cache_shrink(cachep);
 		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
 			memcg_unregister_cache(cachep);
 	}
 	mutex_unlock(&memcg_slab_mutex);
+
+	ida_simple_remove(&kmem_limited_groups, id);
 }
 
 struct memcg_register_cache_work {
@@ -3235,6 +3256,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *memcg_cachep;
+	int id;
 
 	VM_BUG_ON(!cachep->memcg_params);
 	VM_BUG_ON(!cachep->memcg_params->is_root_cache);
@@ -3248,7 +3270,15 @@ struct kmem_cache *__memcg_kmem_get_cach
 	if (!memcg_can_account_kmem(memcg))
 		goto out;
 
-	memcg_cachep = cache_from_memcg_idx(cachep, memcg_cache_id(memcg));
+	id = memcg_cache_id(memcg);
+	/*
+	 * This can happen if current was migrated to another cgroup and this
+	 * cgroup was taken offline after we issued mem_cgroup_from_task above.
+	 */
+	if (unlikely(id < 0))
+		goto out;
+
+	memcg_cachep = cache_from_memcg_idx(cachep, id);
 	if (likely(memcg_cachep)) {
 		cachep = memcg_cachep;
 		goto out;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
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
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
slab-use-mem_cgroup_id-for-per-memcg-cache-naming.patch
memcg-make-memcg_cache_id-static.patch
memcg-add-pointer-to-owner-cache-to-memcg_cache_params.patch
memcg-keep-all-children-of-each-root-cache-on-a-list.patch
memcg-release-memcg_cache_id-on-css-offline.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
fork-make-mm_init_owner-static.patch
linux-next.patch

