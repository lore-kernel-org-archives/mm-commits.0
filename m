From: akpm@linux-foundation.org
Subject: [merged]
 memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:18 -0700
Message-ID: <5390c9fa.adVzNL4QHYHixqiD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaFETuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch removed from -mm tree
To: vdavydov@parallels.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:18 -0700


The patch titled
     Subject: memcg, slab: do not schedule cache destruction when last page goes away
has been removed from the -mm tree.  Its filename was
     memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg, slab: do not schedule cache destruction when last page goes away

This patchset is a part of preparations for kmemcg re-parenting.  It
targets at simplifying kmemcg work-flows and synchronization.

First, it removes async per memcg cache destruction (see patches 1, 2). 
Now caches are only destroyed on memcg offline.  That means the caches
that are not empty on memcg offline will be leaked.  However, they are
already leaked, because memcg_cache_params::nr_pages normally never drops
to 0 so the destruction work is never scheduled except kmem_cache_shrink
is called explicitly.  In the future I'm planning reaping such dead caches
on vmpressure or periodically.

Second, it substitutes per memcg slab_caches_mutex's with the global
memcg_slab_mutex, which should be taken during the whole per memcg cache
creation/destruction path before the slab_mutex (see patch 3).  This
greatly simplifies synchronization among various per memcg cache
creation/destruction paths.

I'm still not quite sure about the end picture, in particular I don't know
whether we should reap dead memcgs' kmem caches periodically or try to
merge them with their parents (see https://lkml.org/lkml/2014/4/20/38 for
more details), but whichever way we choose, this set looks like a
reasonable change to me, because it greatly simplifies kmemcg work-flows
and eases further development.



This patch (of 3):

After a memcg is offlined, we mark its kmem caches that cannot be deleted
right now due to pending objects as dead by setting the
memcg_cache_params::dead flag, so that memcg_release_pages will schedule
cache destruction (memcg_cache_params::destroy) as soon as the last slab
of the cache is freed (memcg_cache_params::nr_pages drops to zero).

I guess the idea was to destroy the caches as soon as possible, i.e. 
immediately after freeing the last object.  However, it just doesn't work
that way, because kmem caches always preserve some pages for the sake of
performance, so that nr_pages never gets to zero unless the cache is
shrunk explicitly using kmem_cache_shrink.  Of course, we could account
the total number of objects on the cache or check if all the slabs
allocated for the cache are empty on kmem_cache_free and schedule
destruction if so, but that would be too costly.

Thus we have a piece of code that works only when we explicitly call
kmem_cache_shrink, but complicates the whole picture a lot.  Moreover,
it's racy in fact.  For instance, kmem_cache_shrink may free the last slab
and thus schedule cache destruction before it finishes checking that the
cache is empty, which can lead to use-after-free.

So I propose to remove this async cache destruction from
memcg_release_pages, and check if the cache is empty explicitly after
calling kmem_cache_shrink instead.  This will simplify things a lot w/o
introducing any functional changes.

And regarding dead memcg caches (i.e.  those that are left hanging around
after memcg offline for they have objects), I suppose we should reap them
either periodically or on vmpressure as Glauber suggested initially.  I'm
going to implement this later.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 
 include/linux/slab.h       |    2 -
 mm/memcontrol.c            |   63 +----------------------------------
 mm/slab.h                  |    7 +--
 4 files changed, 4 insertions(+), 69 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away
+++ a/include/linux/memcontrol.h
@@ -509,7 +509,6 @@ __memcg_kmem_get_cache(struct kmem_cache
 int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size);
 void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size);
 
-void mem_cgroup_destroy_cache(struct kmem_cache *cachep);
 int __kmem_cache_destroy_memcg_children(struct kmem_cache *s);
 
 /**
diff -puN include/linux/slab.h~memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away include/linux/slab.h
--- a/include/linux/slab.h~memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away
+++ a/include/linux/slab.h
@@ -524,7 +524,6 @@ static __always_inline void *kmalloc_nod
  * @memcg: pointer to the memcg this cache belongs to
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
- * @dead: set to true after the memcg dies; the cache may still be around.
  * @nr_pages: number of pages that belongs to this cache.
  * @destroy: worker to be called whenever we are ready, or believe we may be
  *           ready, to destroy this cache.
@@ -540,7 +539,6 @@ struct memcg_cache_params {
 			struct mem_cgroup *memcg;
 			struct list_head list;
 			struct kmem_cache *root_cache;
-			bool dead;
 			atomic_t nr_pages;
 			struct work_struct destroy;
 		};
diff -puN mm/memcontrol.c~memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away
+++ a/mm/memcontrol.c
@@ -3277,60 +3277,11 @@ static void kmem_cache_destroy_work_func
 
 	cachep = memcg_params_to_cache(p);
 
-	/*
-	 * If we get down to 0 after shrink, we could delete right away.
-	 * However, memcg_release_pages() already puts us back in the workqueue
-	 * in that case. If we proceed deleting, we'll get a dangling
-	 * reference, and removing the object from the workqueue in that case
-	 * is unnecessary complication. We are not a fast path.
-	 *
-	 * Note that this case is fundamentally different from racing with
-	 * shrink_slab(): if memcg_cgroup_destroy_cache() is called in
-	 * kmem_cache_shrink, not only we would be reinserting a dead cache
-	 * into the queue, but doing so from inside the worker racing to
-	 * destroy it.
-	 *
-	 * So if we aren't down to zero, we'll just schedule a worker and try
-	 * again
-	 */
-	if (atomic_read(&cachep->memcg_params->nr_pages) != 0)
-		kmem_cache_shrink(cachep);
-	else
+	kmem_cache_shrink(cachep);
+	if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
 		kmem_cache_destroy(cachep);
 }
 
-void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
-{
-	if (!cachep->memcg_params->dead)
-		return;
-
-	/*
-	 * There are many ways in which we can get here.
-	 *
-	 * We can get to a memory-pressure situation while the delayed work is
-	 * still pending to run. The vmscan shrinkers can then release all
-	 * cache memory and get us to destruction. If this is the case, we'll
-	 * be executed twice, which is a bug (the second time will execute over
-	 * bogus data). In this case, cancelling the work should be fine.
-	 *
-	 * But we can also get here from the worker itself, if
-	 * kmem_cache_shrink is enough to shake all the remaining objects and
-	 * get the page count to 0. In this case, we'll deadlock if we try to
-	 * cancel the work (the worker runs with an internal lock held, which
-	 * is the same lock we would hold for cancel_work_sync().)
-	 *
-	 * Since we can't possibly know who got us here, just refrain from
-	 * running if there is already work pending
-	 */
-	if (work_pending(&cachep->memcg_params->destroy))
-		return;
-	/*
-	 * We have to defer the actual destroying to a workqueue, because
-	 * we might currently be in a context that cannot sleep.
-	 */
-	schedule_work(&cachep->memcg_params->destroy);
-}
-
 int __kmem_cache_destroy_memcg_children(struct kmem_cache *s)
 {
 	struct kmem_cache *c;
@@ -3356,16 +3307,7 @@ int __kmem_cache_destroy_memcg_children(
 		 * We will now manually delete the caches, so to avoid races
 		 * we need to cancel all pending destruction workers and
 		 * proceed with destruction ourselves.
-		 *
-		 * kmem_cache_destroy() will call kmem_cache_shrink internally,
-		 * and that could spawn the workers again: it is likely that
-		 * the cache still have active pages until this very moment.
-		 * This would lead us back to mem_cgroup_destroy_cache.
-		 *
-		 * But that will not execute at all if the "dead" flag is not
-		 * set, so flip it down to guarantee we are in control.
 		 */
-		c->memcg_params->dead = false;
 		cancel_work_sync(&c->memcg_params->destroy);
 		kmem_cache_destroy(c);
 
@@ -3387,7 +3329,6 @@ static void mem_cgroup_destroy_all_cache
 	mutex_lock(&memcg->slab_caches_mutex);
 	list_for_each_entry(params, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
-		cachep->memcg_params->dead = true;
 		schedule_work(&cachep->memcg_params->destroy);
 	}
 	mutex_unlock(&memcg->slab_caches_mutex);
diff -puN mm/slab.h~memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away mm/slab.h
--- a/mm/slab.h~memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away
+++ a/mm/slab.h
@@ -129,11 +129,8 @@ static inline void memcg_bind_pages(stru
 
 static inline void memcg_release_pages(struct kmem_cache *s, int order)
 {
-	if (is_root_cache(s))
-		return;
