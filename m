From: akpm@linux-foundation.org
Subject: [withdrawn]
 slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch removed from -mm tree
Date: Tue, 15 Jul 2014 12:17:25 -0700
Message-ID: <53c57e45.LbAxBXzr5jjMMu+3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:65304 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003AbaGOTR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 15:17:26 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so748igd.2
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 12:17:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: don't fail kmem_cache_shrink if slab placement optimization fails
has been removed from the -mm tree.  Its filename was
     slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: don't fail kmem_cache_shrink if slab placement optimization fails

SLUB's kmem_cache_shrink not only removes empty slabs from the cache, but
also sorts slabs by the number of objects in-use to cope with
fragmentation.  To achieve that, it tries to allocate a temporary array. 
If it fails, it will abort the whole procedure.

This is unacceptable for kmemcg, where we want to be sure that all empty
slabs are removed from the cache on memcg offline, so let's just skip the
slab placement optimization step if the allocation fails, but still get
rid of empty slabs.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails mm/slub.c
--- a/mm/slub.c~slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails
+++ a/mm/slub.c
@@ -3367,12 +3367,20 @@ int __kmem_cache_shrink(struct kmem_cach
 	struct page *page;
 	struct page *t;
 	int objects = oo_objects(s->max);
+	struct list_head empty_slabs;
 	struct list_head *slabs_by_inuse =
 		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
 	unsigned long flags;
 
-	if (!slabs_by_inuse)
-		return -ENOMEM;
+	if (!slabs_by_inuse) {
+		/*
+		 * Do not fail shrinking empty slabs if allocation of the
+		 * temporary array failed. Just skip the slab placement
+		 * optimization then.
+		 */
+		slabs_by_inuse = &empty_slabs;
+		objects = 1;
+	}
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
@@ -3391,7 +3399,9 @@ int __kmem_cache_shrink(struct kmem_cach
 		 * list_lock. page->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			list_move(&page->lru, slabs_by_inuse + page->inuse);
+			if (page->inuse < objects)
+				list_move(&page->lru,
+					  slabs_by_inuse + page->inuse);
 			if (!page->inuse)
 				n->nr_partial--;
 		}
@@ -3410,7 +3420,8 @@ int __kmem_cache_shrink(struct kmem_cach
 			discard_slab(s, page);
 	}
 
-	kfree(slabs_by_inuse);
+	if (slabs_by_inuse != &empty_slabs)
+		kfree(slabs_by_inuse);
 	return 0;
 }
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
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

