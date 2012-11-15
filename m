From: akpm@linux-foundation.org
Subject: + memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch added to -mm tree
Date: Wed, 14 Nov 2012 16:59:11 -0800
Message-ID: <20121115005912.C99925C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:45582 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946014Ab2KOA7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 19:59:15 -0500
Received: by mail-bk0-f74.google.com with SMTP id jm19so71598bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 16:59:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg: get rid of once-per-second cache shrinking for dead memcgs
has been added to the -mm tree.  Its filename is
     memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch

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
Subject: memcg: get rid of once-per-second cache shrinking for dead memcgs

The idea is to synchronously do it, leaving it up to the shrinking
facilities in vmscan.c and/or others.  Not actively retrying shrinking may
leave the caches alive for more time, but it will remove the ugly wakeups.
 One would argue that if the caches have free objects but are not being
shrunk, it is because we don't need that memory yet.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 mm/memcontrol.c      |   17 +++++++----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff -puN include/linux/slab.h~memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs include/linux/slab.h
--- a/include/linux/slab.h~memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs
+++ a/include/linux/slab.h
@@ -213,7 +213,7 @@ struct memcg_cache_params {
 			struct kmem_cache *root_cache;
 			bool dead;
 			atomic_t nr_pages;
-			struct delayed_work destroy;
+			struct work_struct destroy;
 		};
 	};
 };
diff -puN mm/memcontrol.c~memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs
+++ a/mm/memcontrol.c
@@ -3076,9 +3076,8 @@ static void kmem_cache_destroy_work_func
 {
 	struct kmem_cache *cachep;
 	struct memcg_cache_params *p;
-	struct delayed_work *dw = to_delayed_work(w);
 
-	p = container_of(dw, struct memcg_cache_params, destroy);
+	p = container_of(w, struct memcg_cache_params, destroy);
 
 	cachep = memcg_params_to_cache(p);
 
@@ -3102,8 +3101,6 @@ static void kmem_cache_destroy_work_func
 		kmem_cache_shrink(cachep);
 		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
 			return;
-		/* Once per minute should be good enough. */
-		schedule_delayed_work(&cachep->memcg_params->destroy, 60 * HZ);
 	} else
 		kmem_cache_destroy(cachep);
 }
@@ -3126,18 +3123,18 @@ void mem_cgroup_destroy_cache(struct kme
 	 * kmem_cache_shrink is enough to shake all the remaining objects and
 	 * get the page count to 0. In this case, we'll deadlock if we try to
 	 * cancel the work (the worker runs with an internal lock held, which
-	 * is the same lock we would hold for cancel_delayed_work_sync().)
+	 * is the same lock we would hold for cancel_work_sync().)
 	 *
 	 * Since we can't possibly know who got us here, just refrain from
 	 * running if there is already work pending
 	 */
-	if (delayed_work_pending(&cachep->memcg_params->destroy))
+	if (work_pending(&cachep->memcg_params->destroy))
 		return;
 	/*
 	 * We have to defer the actual destroying to a workqueue, because
 	 * we might currently be in a context that cannot sleep.
 	 */
-	schedule_delayed_work(&cachep->memcg_params->destroy, 0);
+	schedule_work(&cachep->memcg_params->destroy);
 }
 
 static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
@@ -3261,7 +3258,7 @@ void kmem_cache_destroy_memcg_children(s
 		 * set, so flip it down to guarantee we are in control.
 		 */
 		c->memcg_params->dead = false;
-		cancel_delayed_work_sync(&c->memcg_params->destroy);
+		cancel_work_sync(&c->memcg_params->destroy);
 		kmem_cache_destroy(c);
 	}
 	mutex_unlock(&set_limit_mutex);
@@ -3285,9 +3282,9 @@ static void mem_cgroup_destroy_all_cache
 	list_for_each_entry(params, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
 		cachep->memcg_params->dead = true;
-		INIT_DELAYED_WORK(&cachep->memcg_params->destroy,
+		INIT_WORK(&cachep->memcg_params->destroy,
 				  kmem_cache_destroy_work_func);
-		schedule_delayed_work(&cachep->memcg_params->destroy, 0);
+		schedule_work(&cachep->memcg_params->destroy);
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
memcg-kmem-controller-infrastructure-replace-__always_inline-with-plain-inline.patch
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
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears-simplify-ida-initialization.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions-remove-test-for-current-mm-in-memcg_stop-resume_kmem_account.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-destroy-memcg-caches-move-include-of-workqueueh-to-top-of-slabh-file.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-slb-shrink-dead-caches-get-rid-of-once-per-second-cache-shrinking-for-dead-memcgs.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch

