From: akpm@linux-foundation.org
Subject: + memcg-slb-shrink-dead-caches.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:04:58 -0700
Message-ID: <20121102000458.E139B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:50660 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992679Ab2KBAFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:05:03 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so194003lah.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:05:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg/sl[au]b: shrink dead caches
has been added to the -mm tree.  Its filename is
     memcg-slb-shrink-dead-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg/sl[au]b: shrink dead caches

This means that when we destroy a memcg cache that happened to be empty,
those caches may take a lot of time to go away: removing the memcg
reference won't destroy them - because there are pending references, and
the empty pages will stay there, until a shrinker is called upon for any
reason.

In this patch, we will call kmem_cache_shrink() for all dead caches that
cannot be destroyed because of remaining pages.  After shrinking, it is
possible that it could be freed.  If this is not the case, we'll schedule
a lazy worker to keep trying.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 -
 mm/memcontrol.c      |   55 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 7 deletions(-)

diff -puN include/linux/slab.h~memcg-slb-shrink-dead-caches include/linux/slab.h
--- a/include/linux/slab.h~memcg-slb-shrink-dead-caches
+++ a/include/linux/slab.h
@@ -213,7 +213,7 @@ struct memcg_cache_params {
 			struct kmem_cache *root_cache;
 			bool dead;
 			atomic_t nr_pages;
-			struct work_struct destroy;
+			struct delayed_work destroy;
 		};
 	};
 };
diff -puN mm/memcontrol.c~memcg-slb-shrink-dead-caches mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slb-shrink-dead-caches
+++ a/mm/memcontrol.c
@@ -3048,12 +3048,35 @@ static void kmem_cache_destroy_work_func
 {
 	struct kmem_cache *cachep;
 	struct memcg_cache_params *p;
+	struct delayed_work *dw = to_delayed_work(w);
 
-	p = container_of(w, struct memcg_cache_params, destroy);
+	p = container_of(dw, struct memcg_cache_params, destroy);
 
 	cachep = memcg_params_to_cache(p);
 
-	if (!atomic_read(&cachep->memcg_params->nr_pages))
+	/*
+	 * If we get down to 0 after shrink, we could delete right away.
+	 * However, memcg_release_pages() already puts us back in the workqueue
+	 * in that case. If we proceed deleting, we'll get a dangling
+	 * reference, and removing the object from the workqueue in that case
+	 * is unnecessary complication. We are not a fast path.
+	 *
+	 * Note that this case is fundamentally different from racing with
+	 * shrink_slab(): if memcg_cgroup_destroy_cache() is called in
+	 * kmem_cache_shrink, not only we would be reinserting a dead cache
+	 * into the queue, but doing so from inside the worker racing to
+	 * destroy it.
+	 *
+	 * So if we aren't down to zero, we'll just schedule a worker and try
+	 * again
+	 */
+	if (atomic_read(&cachep->memcg_params->nr_pages) != 0) {
+		kmem_cache_shrink(cachep);
+		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
+			return;
+		/* Once per minute should be good enough. */
+		schedule_delayed_work(&cachep->memcg_params->destroy, 60 * HZ);
+	} else
 		kmem_cache_destroy(cachep);
 }
 
@@ -3063,10 +3086,30 @@ void mem_cgroup_destroy_cache(struct kme
 		return;
 
 	/*
+	 * There are many ways in which we can get here.
+	 *
+	 * We can get to a memory-pressure situation while the delayed work is
+	 * still pending to run. The vmscan shrinkers can then release all
+	 * cache memory and get us to destruction. If this is the case, we'll
+	 * be executed twice, which is a bug (the second time will execute over
+	 * bogus data). In this case, cancelling the work should be fine.
+	 *
+	 * But we can also get here from the worker itself, if
+	 * kmem_cache_shrink is enough to shake all the remaining objects and
+	 * get the page count to 0. In this case, we'll deadlock if we try to
+	 * cancel the work (the worker runs with an internal lock held, which
+	 * is the same lock we would hold for cancel_delayed_work_sync().)
+	 *
+	 * Since we can't possibly know who got us here, just refrain from
+	 * running if there is already work pending
+	 */
+	if (delayed_work_pending(&cachep->memcg_params->destroy))
+		return;
+	/*
 	 * We have to defer the actual destroying to a workqueue, because
 	 * we might currently be in a context that cannot sleep.
 	 */
-	schedule_work(&cachep->memcg_params->destroy);
+	schedule_delayed_work(&cachep->memcg_params->destroy, 0);
 }
 
 static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
@@ -3218,9 +3261,9 @@ static void mem_cgroup_destroy_all_cache
 	list_for_each_entry(params, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
 		cachep->memcg_params->dead = true;
-		INIT_WORK(&cachep->memcg_params->destroy,
-			  kmem_cache_destroy_work_func);
-		schedule_work(&cachep->memcg_params->destroy);
+		INIT_DELAYED_WORK(&cachep->memcg_params->destroy,
+				  kmem_cache_destroy_work_func);
+		schedule_delayed_work(&cachep->memcg_params->destroy, 0);
 	}
 	mutex_unlock(&memcg->slab_caches_mutex);
 }
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

