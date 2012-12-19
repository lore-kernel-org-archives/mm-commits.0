From: akpm@linux-foundation.org
Subject: [merged] memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:41:52 -0800
Message-ID: <20121219204153.571C3200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42475 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2LSUl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:41:57 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so134131wey.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:41:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg/sl[au]b: track all the memcg children of a kmem_cache
has been removed from the -mm tree.  Its filename was
     memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -454,6 +454,7 @@ struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
 void mem_cgroup_destroy_cache(struct kmem_cache *cachep);
+void kmem_cache_destroy_memcg_children(struct kmem_cache *s);
 
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
@@ -601,6 +602,10 @@ memcg_kmem_get_cache(struct kmem_cache *
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
@@ -2772,6 +2772,8 @@ static void __mem_cgroup_commit_charge(s
 	memcg_check_events(memcg, page);
 }
 
+static DEFINE_MUTEX(set_limit_mutex);
+
 #ifdef CONFIG_MEMCG_KMEM
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
@@ -3176,6 +3178,51 @@ out:
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
@@ -4284,8 +4331,6 @@ void mem_cgroup_print_bad_page(struct pa
 }
 #endif
 
-static DEFINE_MUTEX(set_limit_mutex);
