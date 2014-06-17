From: akpm@linux-foundation.org
Subject: + slub-make-slab_free-non-preemptable.patch added to -mm tree
Date: Tue, 17 Jun 2014 14:44:26 -0700
Message-ID: <53a0b6ba.1oAWBvpgSKKkXiXq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965125AbaFQVo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, cl@linux.com, vdavydov@parallels.com


The patch titled
     Subject: slub: make slab_free non-preemptable
has been added to the -mm tree.  Its filename is
     slub-make-slab_free-non-preemptable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-make-slab_free-non-preemptable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-make-slab_free-non-preemptable.patch

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
@@ -3495,6 +3495,12 @@ static inline void __cache_free(struct k
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
@@ -2665,18 +2665,17 @@ static __always_inline void slab_free(st
 
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
@@ -2693,6 +2692,7 @@ redo:
 	} else
 		__slab_free(s, page, x, addr);
 
+	preempt_enable();
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-fix-oops-when-reading-proc-slab_allocators.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
linux-next.patch

