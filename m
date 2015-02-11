From: akpm@linux-foundation.org
Subject: [merged] memcg-zap-__memcg_chargeuncharge_slab.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:23:15 -0800
Message-ID: <54dbba33.sravLDMIAidfQxK3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbbBKUXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:23:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap __memcg_{charge,uncharge}_slab
has been removed from the -mm tree.  Its filename was
     memcg-zap-__memcg_chargeuncharge_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: zap __memcg_{charge,uncharge}_slab

They are simple wrappers around memcg_{charge,uncharge}_kmem, so let's
zap them and call these functions directly.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |   21 +++------------------
 mm/slab.h                  |    4 ++--
 3 files changed, 8 insertions(+), 22 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-zap-__memcg_chargeuncharge_slab include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-zap-__memcg_chargeuncharge_slab
+++ a/include/linux/memcontrol.h
@@ -403,8 +403,9 @@ void memcg_update_array_size(int num_gro
 struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep);
 void __memcg_kmem_put_cache(struct kmem_cache *cachep);
 
-int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order);
-void __memcg_uncharge_slab(struct kmem_cache *cachep, int order);
+int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
+		      unsigned long nr_pages);
+void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned long nr_pages);
 
 int __memcg_cleanup_cache_params(struct kmem_cache *s);
 
diff -puN mm/memcontrol.c~memcg-zap-__memcg_chargeuncharge_slab mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-__memcg_chargeuncharge_slab
+++ a/mm/memcontrol.c
@@ -2495,8 +2495,8 @@ static struct kmem_cache *memcg_params_t
 	return cache_from_memcg_idx(cachep, memcg_cache_id(p->memcg));
 }
 
-static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
-			     unsigned long nr_pages)
+int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
+		      unsigned long nr_pages)
 {
 	struct page_counter *counter;
 	int ret = 0;
@@ -2533,8 +2533,7 @@ static int memcg_charge_kmem(struct mem_
 	return ret;
 }
 
-static void memcg_uncharge_kmem(struct mem_cgroup *memcg,
-				unsigned long nr_pages)
+void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned long nr_pages)
 {
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	if (do_swap_account)
@@ -2767,20 +2766,6 @@ static void memcg_schedule_register_cach
 	current->memcg_kmem_skip_account = 0;
 }
 
-int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order)
-{
-	unsigned int nr_pages = 1 << order;
-
-	return memcg_charge_kmem(cachep->memcg_params->memcg, gfp, nr_pages);
-}
-
-void __memcg_uncharge_slab(struct kmem_cache *cachep, int order)
-{
-	unsigned int nr_pages = 1 << order;
-
-	memcg_uncharge_kmem(cachep->memcg_params->memcg, nr_pages);
-}
-
 /*
  * Return the kmem_cache we're supposed to use for a slab allocation.
  * We try to use the current memcg's version of the cache.
diff -puN mm/slab.h~memcg-zap-__memcg_chargeuncharge_slab mm/slab.h
--- a/mm/slab.h~memcg-zap-__memcg_chargeuncharge_slab
+++ a/mm/slab.h
@@ -235,7 +235,7 @@ static __always_inline int memcg_charge_
 		return 0;
 	if (is_root_cache(s))
 		return 0;
-	return __memcg_charge_slab(s, gfp, order);
+	return memcg_charge_kmem(s->memcg_params->memcg, gfp, 1 << order);
 }
 
 static __always_inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
@@ -244,7 +244,7 @@ static __always_inline void memcg_unchar
 		return;
 	if (is_root_cache(s))
 		return;
-	__memcg_uncharge_slab(s, order);
+	memcg_uncharge_kmem(s->memcg_params->memcg, 1 << order);
 }
 #else
 static inline bool is_root_cache(struct kmem_cache *s)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
mm-memcontrol-simplify-soft-limit-tree-init-code.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-embed-memcg_cache_params-to-kmem_cache-fix.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list-fix.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
vmstat-do-not-use-deferrable-delayed-work-for-vmstat_update.patch
memcg-cleanup-static-keys-decrement.patch

