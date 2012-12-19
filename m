From: akpm@linux-foundation.org
Subject: [merged] memcg-slb-shrink-dead-caches.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:41:58 -0800
Message-ID: <20121219204159.473C6200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:64014 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2LSUmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:42:04 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so121357lag.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:42:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg/sl[au]b: shrink dead caches
has been removed from the -mm tree.  Its filename was
     memcg-slb-shrink-dead-caches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 mm/memcontrol.c |   46 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-slb-shrink-dead-caches mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slb-shrink-dead-caches
+++ a/mm/memcontrol.c
@@ -3080,7 +3080,27 @@ static void kmem_cache_destroy_work_func
 
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
+	} else
 		kmem_cache_destroy(cachep);
 }
 
@@ -3090,6 +3110,26 @@ void mem_cgroup_destroy_cache(struct kme
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
+	 * is the same lock we would hold for cancel_work_sync().)
+	 *
+	 * Since we can't possibly know who got us here, just refrain from
+	 * running if there is already work pending
+	 */
+	if (work_pending(&cachep->memcg_params->destroy))
+		return;
+	/*
 	 * We have to defer the actual destroying to a workqueue, because
 	 * we might currently be in a context that cannot sleep.
 	 */
@@ -3217,7 +3257,7 @@ void kmem_cache_destroy_memcg_children(s
 		 * set, so flip it down to guarantee we are in control.
 		 */
 		c->memcg_params->dead = false;
-		cancel_delayed_work_sync(&c->memcg_params->destroy);
+		cancel_work_sync(&c->memcg_params->destroy);
 		kmem_cache_destroy(c);
 	}
 	mutex_unlock(&set_limit_mutex);
@@ -3242,7 +3282,7 @@ static void mem_cgroup_destroy_all_cache
 		cachep = memcg_params_to_cache(params);
 		cachep->memcg_params->dead = true;
 		INIT_WORK(&cachep->memcg_params->destroy,
-			  kmem_cache_destroy_work_func);
+				  kmem_cache_destroy_work_func);
 		schedule_work(&cachep->memcg_params->destroy);
 	}
 	mutex_unlock(&memcg->slab_caches_mutex);
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

