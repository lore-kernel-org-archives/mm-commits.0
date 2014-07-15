From: akpm@linux-foundation.org
Subject: [withdrawn]
 slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch removed from -mm tree
Date: Tue, 15 Jul 2014 12:17:17 -0700
Message-ID: <53c57e3d.WMlKWQuIliW7gBvb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:58103 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039AbaGOTXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 15:23:07 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so995140yha.2
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 12:23:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: do not keep free objects/slabs on dead memcg caches
has been removed from the -mm tree.  Its filename was
     slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: do not keep free objects/slabs on dead memcg caches

Since a dead memcg cache is destroyed only after the last slab allocated
to it is freed, we must disable caching of free objects/slabs for such
caches, otherwise they will be hanging around forever.

For SLAB that means we must disable per cpu free object arrays and make
free_block always discard empty slabs irrespective of node's free_limit.

To disable per cpu arrays, we free them on kmem_cache_shrink (see
drain_cpu_caches -> do_drain) and make __cache_free fall back to
free_block if there is no per cpu array.  Also, we have to disable
allocation of per cpu arrays on cpu hotplug for dead caches (see
cpuup_prepare, __do_tune_cpucache).

After we disabled free objects/slabs caching, there is no need to reap
those caches periodically.  Moreover, it will only result in slowdown.  So
we also make cache_reap skip then.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches mm/slab.c
--- a/mm/slab.c~slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches
+++ a/mm/slab.c
@@ -1262,6 +1262,9 @@ static int cpuup_prepare(long cpu)
 		struct array_cache *shared = NULL;
 		struct array_cache **alien = NULL;
 
+		if (memcg_cache_dead(cachep))
+			continue;
+
 		nc = alloc_arraycache(node, cachep->limit,
 					cachep->batchcount, GFP_KERNEL);
 		if (!nc)
@@ -2462,11 +2465,18 @@ static void do_drain(void *arg)
 
 	check_irq_off();
 	ac = cpu_cache_get(cachep);
+	if (!ac)
+		return;
+
 	n = get_node(cachep, node);
 	spin_lock(&n->list_lock);
 	free_block(cachep, ac->entry, ac->avail, node);
 	spin_unlock(&n->list_lock);
 	ac->avail = 0;
+	if (memcg_cache_dead(cachep)) {
+		cachep->array[smp_processor_id()] = NULL;
+		kfree(ac);
+	}
 }
 
 static void drain_cpu_caches(struct kmem_cache *cachep)
@@ -3417,7 +3427,8 @@ static void free_block(struct kmem_cache
 
 		/* fixup slab chains */
 		if (page->active == 0) {
-			if (n->free_objects > n->free_limit) {
+			if (n->free_objects > n->free_limit ||
+			    memcg_cache_dead(cachep)) {
 				n->free_objects -= cachep->num;
 				/* No need to drop any previously held
 				 * lock here, even if we have a off-slab slab
@@ -3511,6 +3522,17 @@ static inline void __cache_free(struct k
 
 	kmemcheck_slab_free(cachep, objp, cachep->object_size);
 
+#ifdef CONFIG_MEMCG_KMEM
+	if (unlikely(!ac)) {
+		int nodeid = page_to_nid(virt_to_page(objp));
+
+		spin_lock(&cachep->node[nodeid]->list_lock);
+		free_block(cachep, &objp, 1, nodeid);
+		spin_unlock(&cachep->node[nodeid]->list_lock);
+		return;
+	}
+#endif
+
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
 	 * This will avoid cache misses that happen while accessing slabp (which
@@ -3851,6 +3873,9 @@ static int __do_tune_cpucache(struct kme
 	struct ccupdate_struct *new;
 	int i;
 
+	if (memcg_cache_dead(cachep))
+		return 0;
+
 	new = kzalloc(sizeof(*new) + nr_cpu_ids * sizeof(struct array_cache *),
 		      gfp);
 	if (!new)
@@ -4042,6 +4067,9 @@ static void cache_reap(struct work_struc
 	list_for_each_entry(searchp, &slab_caches, list) {
 		check_irq_on();
 
+		if (memcg_cache_dead(searchp))
+			continue;
+
 		/*
 		 * We only take the node lock if absolutely necessary and we
 		 * have established with reasonable certainty that
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
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

