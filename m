From: akpm@linux-foundation.org
Subject: + slab-use-mem_cgroup_id-for-per-memcg-cache-naming.patch added
 to -mm tree
Date: Mon, 21 Jul 2014 14:37:37 -0700
Message-ID: <53cd8821./TEC1wPvvbo1rSfc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:35562 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaGUVhi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 17:37:38 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1990431pab.5
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 14:37:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use mem_cgroup_id for per memcg cache naming
has been added to the -mm tree.  Its filename is
     slab-use-mem_cgroup_id-for-per-memcg-cache-naming.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-mem_cgroup_id-for-per-memcg-cache-naming.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-mem_cgroup_id-for-per-memcg-cache-naming.patch

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
Subject: slab: use mem_cgroup_id for per memcg cache naming

Currently, we use memcg_cache_id as a part of a per memcg cache name. 
Since memcg_cache_id is released only on css free, this guarantees cache
name uniqueness.

However, it's bad practice to keep memcg_cache_id till css free, because
it occupies a slot in kmem_cache->memcg_params->memcg_caches arrays.  So
I'm going to make memcg release memcg_cache_id on css offline.  As a
result, memcg_cache_id won't guarantee cache name uniqueness any more.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 mm/memcontrol.c      |   13 +++++++++++--
 mm/slab_common.c     |   15 +++------------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff -puN include/linux/slab.h~slab-use-mem_cgroup_id-for-per-memcg-cache-naming include/linux/slab.h
--- a/include/linux/slab.h~slab-use-mem_cgroup_id-for-per-memcg-cache-naming
+++ a/include/linux/slab.h
@@ -118,7 +118,7 @@ struct kmem_cache *kmem_cache_create(con
 #ifdef CONFIG_MEMCG_KMEM
 struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *,
 					   struct kmem_cache *,
-					   const char *);
+					   char *);
 #endif
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
diff -puN mm/memcontrol.c~slab-use-mem_cgroup_id-for-per-memcg-cache-naming mm/memcontrol.c
--- a/mm/memcontrol.c~slab-use-mem_cgroup_id-for-per-memcg-cache-naming
+++ a/mm/memcontrol.c
@@ -3017,6 +3017,7 @@ static void memcg_register_cache(struct
 	static char memcg_name_buf[NAME_MAX + 1]; /* protected by
 						     memcg_slab_mutex */
 	struct kmem_cache *cachep;
+	char *cache_name;
 	int id;
 
 	lockdep_assert_held(&memcg_slab_mutex);
@@ -3032,14 +3033,22 @@ static void memcg_register_cache(struct
 		return;
 
 	cgroup_name(memcg->css.cgroup, memcg_name_buf, NAME_MAX + 1);
-	cachep = memcg_create_kmem_cache(memcg, root_cache, memcg_name_buf);
+
+	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
+			       mem_cgroup_id(memcg), memcg_name_buf);
+	if (!cache_name)
+		return;
+
+	cachep = memcg_create_kmem_cache(memcg, root_cache, cache_name);
 	/*
 	 * If we could not create a memcg cache, do not complain, because
 	 * that's not critical at all as we can always proceed with the root
 	 * cache.
 	 */
-	if (!cachep)
+	if (!cachep) {
+		kfree(cache_name);
 		return;
+	}
 
 	list_add(&cachep->memcg_params->list, &memcg->memcg_slab_caches);
 
diff -puN mm/slab_common.c~slab-use-mem_cgroup_id-for-per-memcg-cache-naming mm/slab_common.c
--- a/mm/slab_common.c~slab-use-mem_cgroup_id-for-per-memcg-cache-naming
+++ a/mm/slab_common.c
@@ -266,7 +266,7 @@ EXPORT_SYMBOL(kmem_cache_create);
  * memcg_create_kmem_cache - Create a cache for a memory cgroup.
  * @memcg: The memory cgroup the new cache is for.
  * @root_cache: The parent of the new cache.
- * @memcg_name: The name of the memory cgroup (used for naming the new cache).
+ * @cache_name: The string to be used as the new cache name.
  *
  * This function attempts to create a kmem cache that will serve allocation
  * requests going from @memcg to @root_cache. The new cache inherits properties
@@ -274,31 +274,22 @@ EXPORT_SYMBOL(kmem_cache_create);
  */
 struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 					   struct kmem_cache *root_cache,
-					   const char *memcg_name)
+					   char *cache_name)
 {
 	struct kmem_cache *s = NULL;
-	char *cache_name;
 
 	get_online_cpus();
 	get_online_mems();
 
 	mutex_lock(&slab_mutex);
 
-	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       memcg_cache_id(memcg), memcg_name);
-	if (!cache_name)
-		goto out_unlock;
-
 	s = do_kmem_cache_create(cache_name, root_cache->object_size,
 				 root_cache->size, root_cache->align,
 				 root_cache->flags, root_cache->ctor,
 				 memcg, root_cache);
-	if (IS_ERR(s)) {
-		kfree(cache_name);
+	if (IS_ERR(s))
 		s = NULL;
-	}
 
-out_unlock:
 	mutex_unlock(&slab_mutex);
 
 	put_online_mems();
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

