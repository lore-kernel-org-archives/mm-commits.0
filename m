From: akpm@linux-foundation.org
Subject: [withdrawn] slub-make-slab_free-non-preemptable.patch removed
 from -mm tree
Date: Tue, 15 Jul 2014 12:17:23 -0700
Message-ID: <53c57e43.Ytt//e2YtA0xOSps%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:41759 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170AbaGOTRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 15:17:24 -0400
Received: by mail-pd0-f201.google.com with SMTP id v10so1366004pde.0
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 12:17:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: make slab_free non-preemptable
has been removed from the -mm tree.  Its filename was
     slub-make-slab_free-non-preemptable.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: make slab_free non-preemptable

Since per memcg cache destruction is scheduled when the last slab is
freed, to avoid use-after-free in kmem_cache_free we should either
rearrange code in kmem_cache_free so that it won't dereference the cache
ptr after freeing the object, or wait for all kmem_cache_free's to
complete before proceeding to cache destruction.

The former approach isn't a good option from the future development point
of view, because every modifications to kmem_cache_free must be done with
great care then.  Hence we should provide a method to wait for all
currently executing kmem_cache_free's to finish.

This patch makes SLUB's implementation of kmem_cache_free non-preemptable.
 As a result, synchronize_sched() will work as a barrier against
kmem_cache_free's in flight, so that issuing it before cache destruction
will protect us against the use-after-free.

This won't affect performance of kmem_cache_free, because we already
disable preemption there, and this patch only moves preempt_enable to the
end of the function.  Neither should it affect the system latency, because
kmem_cache_free is extremely short, even in its slow path.

SLAB's version of kmem_cache_free already proceeds with irqs disabled, so
we only add a comment explaining why it's necessary for kmemcg there.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 ++++++
 mm/slub.c |   12 ++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/slab.c~slub-make-slab_free-non-preemptable mm/slab.c
--- a/mm/slab.c~slub-make-slab_free-non-preemptable
+++ a/mm/slab.c
@@ -3499,6 +3499,12 @@ static inline void __cache_free(struct k
 {
 	struct array_cache *ac = cpu_cache_get(cachep);
 
+	/*
+	 * Since we free objects with irqs and therefore preemption disabled,
+	 * we can use synchronize_sched() to wait for all currently executing
+	 * kfree's to finish. This is necessary to avoid use-after-free on
+	 * per memcg cache destruction.
+	 */
 	check_irq_off();
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
diff -puN mm/slub.c~slub-make-slab_free-non-preemptable mm/slub.c
--- a/mm/slub.c~slub-make-slab_free-non-preemptable
+++ a/mm/slub.c
@@ -2640,18 +2640,17 @@ static __always_inline void slab_free(st
 
 	slab_free_hook(s, x);
 
-redo:
 	/*
-	 * Determine the currently cpus per cpu slab.
-	 * The cpu may change afterward. However that does not matter since
-	 * data is retrieved via this pointer. If we are on the same cpu
-	 * during the cmpxchg then the free will succedd.
+	 * We could make this function fully preemptable, but then we wouldn't
+	 * have a method to wait for all currently executing kfree's to finish,
+	 * which is necessary to avoid use-after-free on per memcg cache
+	 * destruction.
 	 */
 	preempt_disable();
+redo:
 	c = this_cpu_ptr(s->cpu_slab);
 
 	tid = c->tid;
-	preempt_enable();
 
 	if (likely(page == c->page)) {
 		set_freepointer(s, object, c->freelist);
@@ -2668,6 +2667,7 @@ redo:
 	} else
 		__slab_free(s, page, x, addr);
 
+	preempt_enable();
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
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

