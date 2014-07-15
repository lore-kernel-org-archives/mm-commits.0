From: akpm@linux-foundation.org
Subject: [withdrawn] memcg-cleanup-memcg_cache_params-refcnt-usage.patch
 removed from -mm tree
Date: Tue, 15 Jul 2014 12:17:31 -0700
Message-ID: <53c57e4b.+ivh0AfxJoCXdvFc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:33023 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892AbaGOTRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 15:17:35 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so734433iec.3
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 12:17:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup memcg_cache_params refcnt usage
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-memcg_cache_params-refcnt-usage.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: cleanup memcg_cache_params refcnt usage

When a memcg is turned offline, some of its kmem caches can still have
active objects and therefore cannot be destroyed immediately.  Currently,
we simply leak such caches along with the owner memcg, which is bad and
should be resolved.

It would be perfect if we could move all slab pages of such dead caches to
the root/parent cache on memcg offline.  However, when I tried to
implement such re-parenting, I was pointed out by Christoph that the
overhead of this would be unacceptable, at least for SLUB (see
https://lkml.org/lkml/2014/5/13/446)

The problem with re-parenting of individual slabs is that it requires
tracking of all slabs allocated to a cache, but SLUB doesn't track full
slabs if !debug.  Changing this behavior would result in significant
performance degradation of regular alloc/free paths, because it would make
alloc/free take per node list locks more often.

After pondering about this problem for some time, I think we should return
to dead caches self-destruction, i.e.  scheduling cache destruction work
when the last slab page is freed.

This is the behavior we had before commit 5bd93da9917f ("memcg, slab:
simplify synchronization scheme").  The reason why it was removed was that
it simply didn't work, because SL[AU]B are implemented in such a way that
they don't discard empty slabs immediately, but prefer keeping them cached
for indefinite time to speed up further allocations.

However, we can change this w/o noticeable performance impact for both
SLAB and SLUB by making them drop free slabs as soon as they become empty.
 Since dead caches should never be allocated from, removing empty slabs
from them shouldn't result in noticeable performance degradation.

So, this patch set reintroduces dead cache self-destruction and adds some
tweaks to SL[AU]B to prevent dead caches from hanging around indefinitely.
 It is organized as follows:

 - patches 1-3 reintroduce dead memcg cache self-destruction;
 - patch 4 makes SLUB's version of kmem_cache_shrink always drop empty
   slabs, even if it fails to allocate a temporary array;
 - patches 5 and 6 fix possible use-after-free connected with
   asynchronous cache destruction;
 - patches 7 and 8 disable caching of empty slabs for dead memcg caches
   for SLUB and SLAB respectively.

Note, this doesn't resolve the problem of memcgs pinned by dead kmem
caches. I'm planning to solve this by re-parenting dead kmem caches to
the parent memcg.



This patch (of 8):

Currently, we count the number of pages allocated to a per memcg cache in
memcg_cache_params->nr_pages.  We only use this counter to find out if the
cache is empty and can be destroyed.  So let's rename it to refcnt and
make it count not pages, but slabs so that we can use atomic_inc/dec
instead of atomic_add/sub in memcg_charge/uncharge_slab.

Also, as the number of slabs theoretically can be greater than INT_MAX,
let's use atomic_long for the counter.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    4 ++--
 mm/memcontrol.c      |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/slab.h~memcg-cleanup-memcg_cache_params-refcnt-usage include/linux/slab.h
--- a/include/linux/slab.h~memcg-cleanup-memcg_cache_params-refcnt-usage
+++ a/include/linux/slab.h
@@ -526,7 +526,7 @@ static __always_inline void *kmalloc_nod
  * @memcg: pointer to the memcg this cache belongs to
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
- * @nr_pages: number of pages that belongs to this cache.
+ * @refcnt: reference counter
  */
 struct memcg_cache_params {
 	bool is_root_cache;
@@ -539,7 +539,7 @@ struct memcg_cache_params {
 			struct mem_cgroup *memcg;
 			struct list_head list;
 			struct kmem_cache *root_cache;
-			atomic_t nr_pages;
+			atomic_long_t refcnt;
 		};
 	};
 };
diff -puN mm/memcontrol.c~memcg-cleanup-memcg_cache_params-refcnt-usage mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cleanup-memcg_cache_params-refcnt-usage
+++ a/mm/memcontrol.c
@@ -3241,7 +3241,7 @@ static void memcg_unregister_all_caches(
 	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
 		kmem_cache_shrink(cachep);
-		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
+		if (atomic_long_read(&cachep->memcg_params->refcnt) == 0)
 			memcg_unregister_cache(cachep);
 	}
 	mutex_unlock(&memcg_slab_mutex);
@@ -3315,14 +3315,14 @@ int __memcg_charge_slab(struct kmem_cach
 	res = memcg_charge_kmem(cachep->memcg_params->memcg, gfp,
 				PAGE_SIZE << order);
 	if (!res)
-		atomic_add(1 << order, &cachep->memcg_params->nr_pages);
+		atomic_long_inc(&cachep->memcg_params->refcnt);
 	return res;
 }
 
 void __memcg_uncharge_slab(struct kmem_cache *cachep, int order)
 {
 	memcg_uncharge_kmem(cachep->memcg_params->memcg, PAGE_SIZE << order);
-	atomic_sub(1 << order, &cachep->memcg_params->nr_pages);
+	atomic_long_dec(&cachep->memcg_params->refcnt);
 }
 
 /*
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
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
fork-make-mm_init_owner-static.patch
linux-next.patch

