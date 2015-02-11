From: akpm@linux-foundation.org
Subject: [merged]
 memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:23:17 -0800
Message-ID: <54dbba35.8YZyieyJlA06eAfY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbbBKUXS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:23:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap memcg_name argument of memcg_create_kmem_cache
has been removed from the -mm tree.  Its filename was
     memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: zap memcg_name argument of memcg_create_kmem_cache

Instead of passing the name of the memory cgroup which the cache is
created for in the memcg_name_argument, let's obtain it immediately in
memcg_create_kmem_cache.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    3 +--
 mm/memcontrol.c      |    5 +----
 mm/slab_common.c     |    9 +++++----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN include/linux/slab.h~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache include/linux/slab.h
--- a/include/linux/slab.h~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache
+++ a/include/linux/slab.h
@@ -117,8 +117,7 @@ struct kmem_cache *kmem_cache_create(con
 			void (*)(void *));
 #ifdef CONFIG_MEMCG_KMEM
 struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *,
-					   struct kmem_cache *,
-					   const char *);
+					   struct kmem_cache *);
 #endif
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
diff -puN mm/memcontrol.c~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache
+++ a/mm/memcontrol.c
@@ -2607,8 +2607,6 @@ void memcg_update_array_size(int num)
 static void memcg_register_cache(struct mem_cgroup *memcg,
 				 struct kmem_cache *root_cache)
 {
-	static char memcg_name_buf[NAME_MAX + 1]; /* protected by
-						     memcg_slab_mutex */
 	struct kmem_cache *cachep;
 	int id;
 
@@ -2624,8 +2622,7 @@ static void memcg_register_cache(struct
 	if (cache_from_memcg_idx(root_cache, id))
 		return;
 
-	cgroup_name(memcg->css.cgroup, memcg_name_buf, NAME_MAX + 1);
-	cachep = memcg_create_kmem_cache(memcg, root_cache, memcg_name_buf);
+	cachep = memcg_create_kmem_cache(memcg, root_cache);
 	/*
 	 * If we could not create a memcg cache, do not complain, because
 	 * that's not critical at all as we can always proceed with the root
diff -puN mm/slab_common.c~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache mm/slab_common.c
--- a/mm/slab_common.c~memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache
+++ a/mm/slab_common.c
@@ -430,16 +430,15 @@ EXPORT_SYMBOL(kmem_cache_create);
  * memcg_create_kmem_cache - Create a cache for a memory cgroup.
  * @memcg: The memory cgroup the new cache is for.
  * @root_cache: The parent of the new cache.
- * @memcg_name: The name of the memory cgroup (used for naming the new cache).
  *
  * This function attempts to create a kmem cache that will serve allocation
  * requests going from @memcg to @root_cache. The new cache inherits properties
  * from its parent.
  */
 struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
-					   struct kmem_cache *root_cache,
-					   const char *memcg_name)
+					   struct kmem_cache *root_cache)
 {
+	static char memcg_name_buf[NAME_MAX + 1]; /* protected by slab_mutex */
 	struct kmem_cache *s = NULL;
 	char *cache_name;
 
@@ -448,8 +447,10 @@ struct kmem_cache *memcg_create_kmem_cac
 
 	mutex_lock(&slab_mutex);
 
+	cgroup_name(mem_cgroup_css(memcg)->cgroup,
+		    memcg_name_buf, sizeof(memcg_name_buf));
 	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       memcg_cache_id(memcg), memcg_name);
+			       memcg_cache_id(memcg), memcg_name_buf);
 	if (!cache_name)
 		goto out_unlock;
 
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

