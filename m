From: akpm@linux-foundation.org
Subject: + memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch added to -mm tree
Date: Thu, 01 Nov 2012 17:04:52 -0700
Message-ID: <20121102000452.E6A865C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:50660 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992658Ab2KBAE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2012 20:04:56 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so194003lah.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Nov 2012 17:04:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org


The patch titled
     Subject: memcg/sl[au]b: track all the memcg children of a kmem_cache
has been added to the -mm tree.  Its filename is
     memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch

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
Subject: memcg/sl[au]b: track all the memcg children of a kmem_cache

This enables us to remove all the children of a kmem_cache being
destroyed, if for example the kernel module it's being used in gets
unloaded.  Otherwise, the children will still point to the destroyed
parent.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
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
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++
 mm/memcontrol.c            |   49 +++++++++++++++++++++++++++++++++--
 mm/slab_common.c           |    3 ++
 3 files changed, 55 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-slb-track-all-the-memcg-children-of-a-kmem_cache include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slb-track-all-the-memcg-children-of-a-kmem_cache
+++ a/include/linux/memcontrol.h
@@ -447,6 +447,7 @@ struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
 void mem_cgroup_destroy_cache(struct kmem_cache *cachep);
+void kmem_cache_destroy_memcg_children(struct kmem_cache *s);
 
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
@@ -594,6 +595,10 @@ memcg_kmem_get_cache(struct kmem_cache *
 {
 	return cachep;
 }
+
+static inline void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
+{
+}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN mm/memcontrol.c~memcg-slb-track-all-the-memcg-children-of-a-kmem_cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slb-track-all-the-memcg-children-of-a-kmem_cache
+++ a/mm/memcontrol.c
@@ -2741,6 +2741,8 @@ static void __mem_cgroup_commit_charge(s
 	memcg_check_events(memcg, page);
 }
 
+static DEFINE_MUTEX(set_limit_mutex);
+
 #ifdef CONFIG_MEMCG_KMEM
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
@@ -3153,6 +3155,51 @@ out:
 	return new_cachep;
 }
 
+void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
+{
+	struct kmem_cache *c;
+	int i;
+
+	if (!s->memcg_params)
+		return;
+	if (!s->memcg_params->is_root_cache)
+		return;
+
+	/*
+	 * If the cache is being destroyed, we trust that there is no one else
+	 * requesting objects from it. Even if there are, the sanity checks in
+	 * kmem_cache_destroy should caught this ill-case.
+	 *
+	 * Still, we don't want anyone else freeing memcg_caches under our
+	 * noses, which can happen if a new memcg comes to life. As usual,
+	 * we'll take the set_limit_mutex to protect ourselves against this.
+	 */
+	mutex_lock(&set_limit_mutex);
+	for (i = 0; i < memcg_limited_groups_array_size; i++) {
+		c = s->memcg_params->memcg_caches[i];
+		if (!c)
+			continue;
+
+		/*
+		 * We will now manually delete the caches, so to avoid races
+		 * we need to cancel all pending destruction workers and
+		 * proceed with destruction ourselves.
+		 *
+		 * kmem_cache_destroy() will call kmem_cache_shrink internally,
+		 * and that could spawn the workers again: it is likely that
+		 * the cache still have active pages until this very moment.
+		 * This would lead us back to mem_cgroup_destroy_cache.
+		 *
+		 * But that will not execute at all if the "dead" flag is not
+		 * set, so flip it down to guarantee we are in control.
+		 */
+		c->memcg_params->dead = false;
+		cancel_delayed_work_sync(&c->memcg_params->destroy);
+		kmem_cache_destroy(c);
+	}
+	mutex_unlock(&set_limit_mutex);
+}
+
 struct create_work {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *cachep;
@@ -4280,8 +4327,6 @@ void mem_cgroup_print_bad_page(struct pa
 }
 #endif
 
-static DEFINE_MUTEX(set_limit_mutex);
-
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 				unsigned long long val)
 {
diff -puN mm/slab_common.c~memcg-slb-track-all-the-memcg-children-of-a-kmem_cache mm/slab_common.c
--- a/mm/slab_common.c~memcg-slb-track-all-the-memcg-children-of-a-kmem_cache
+++ a/mm/slab_common.c
@@ -221,6 +221,9 @@ EXPORT_SYMBOL(kmem_cache_create);
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
+	/* Destroy all the children caches if we aren't a memcg cache */
+	kmem_cache_destroy_memcg_children(s);
+
 	get_online_cpus();
 	mutex_lock(&slab_mutex);
 	s->refcount--;
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

