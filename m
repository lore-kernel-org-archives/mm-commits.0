From: akpm@linux-foundation.org
Subject: + slab-set-free_limit-for-dead-caches-to-0.patch added to -mm
 tree
Date: Tue, 24 Jun 2014 14:48:52 -0700
Message-ID: <53a9f244.dH4NaDJf0TnJ1i13%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaFXVsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:48:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: set free_limit for dead caches to 0
has been added to the -mm tree.  Its filename is
     slab-set-free_limit-for-dead-caches-to-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-set-free_limit-for-dead-caches-to-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-set-free_limit-for-dead-caches-to-0.patch

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
Subject: slab: set free_limit for dead caches to 0

We mustn't keep empty slabs on dead memcg caches, because otherwise they
will never be destroyed.

Currently, we check if the cache is dead in free_block and drop empty slab
if so irrespective of the node's free_limit.  This can be pretty
expensive.  So let's avoid this additional check by zeroing nodes'
free_limit for dead caches on kmem_cache_shrink.  This way no additional
overhead is added to free hot path.

Note, since ->free_limit can be updated on cpu/memory hotplug, we must
handle it properly there.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN mm/slab.c~slab-set-free_limit-for-dead-caches-to-0 mm/slab.c
--- a/mm/slab.c~slab-set-free_limit-for-dead-caches-to-0
+++ a/mm/slab.c
@@ -1156,11 +1156,13 @@ static int init_cache_node_node(int node
 			cachep->node[node] = n;
 		}
 
-		spin_lock_irq(&n->list_lock);
-		n->free_limit =
-			(1 + nr_cpus_node(node)) *
-			cachep->batchcount + cachep->num;
-		spin_unlock_irq(&n->list_lock);
+		if (!memcg_cache_dead(cachep)) {
+			spin_lock_irq(&n->list_lock);
+			n->free_limit =
+				(1 + nr_cpus_node(node)) *
+				cachep->batchcount + cachep->num;
+			spin_unlock_irq(&n->list_lock);
+		}
 	}
 	return 0;
 }
@@ -1194,7 +1196,8 @@ static void cpuup_canceled(long cpu)
 		spin_lock_irq(&n->list_lock);
 
 		/* Free limit for this kmem_cache_node */
-		n->free_limit -= cachep->batchcount;
+		if (!memcg_cache_dead(cachep))
+			n->free_limit -= cachep->batchcount;
 		if (nc)
 			free_block(cachep, nc->entry, nc->avail, node);
 
@@ -2545,6 +2548,12 @@ int __kmem_cache_shrink(struct kmem_cach
 
 	check_irq_on();
 	for_each_kmem_cache_node(cachep, node, n) {
+		if (memcg_cache_dead(cachep)) {
+			spin_lock_irq(&n->list_lock);
+			n->free_limit = 0;
+			spin_unlock_irq(&n->list_lock);
+		}
+
 		drain_freelist(cachep, n, slabs_tofree(cachep, n));
 
 		ret += !list_empty(&n->slabs_full) ||
@@ -3427,8 +3436,7 @@ static void free_block(struct kmem_cache
 
 		/* fixup slab chains */
 		if (page->active == 0) {
-			if (n->free_objects > n->free_limit ||
-			    memcg_cache_dead(cachep)) {
+			if (n->free_objects > n->free_limit) {
 				n->free_objects -= cachep->num;
 				/* No need to drop any previously held
 				 * lock here, even if we have a off-slab slab
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
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
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

