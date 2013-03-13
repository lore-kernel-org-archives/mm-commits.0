From: akpm@linux-foundation.org
Subject: + memcg-relax-memcg-iter-caching.patch added to -mm tree
Date: Wed, 13 Mar 2013 15:21:26 -0700
Message-ID: <20130313222127.021685A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48858 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab3CMWV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Mar 2013 18:21:28 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so160807ghb.3
        for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2013 15:21:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, yinghan@google.com


The patch titled
     Subject: memcg: relax memcg iter caching
has been added to the -mm tree.  Its filename is
     memcg-relax-memcg-iter-caching.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: relax memcg iter caching

Now that per-node-zone-priority iterator caches memory cgroups rather than
their css ids we have to be careful and remove them from the iterator when
they are on the way out otherwise they might live for unbounded amount of
time even though their group is already gone (until the global/targeted
reclaim triggers the zone under priority to find out the group is dead and
let it to find the final rest).

We can fix this issue by relaxing rules for the last_visited memcg. 
Instead of taking a reference to the css before it is stored into
iter->last_visited we can just store its pointer and track the number of
removed groups from each memcg's subhierarchy.

This number would be stored into iterator everytime when a memcg is
cached.  If the iter count doesn't match the curent walker root's one we
will start from the root again.  The group counter is incremented upwards
the hierarchy every time a group is removed.

The iter_lock can be dropped because racing iterators cannot leak the
reference anymore as the reference count is not elevated for last_visited
when it is cached.

Locking rules got a bit complicated by this change though.  The iterator
primarily relies on rcu read lock which makes sure that once we see a
valid last_visited pointer then it will be valid for the whole RCU walk. 
smp_rmb makes sure that dead_count is read before last_visited and
last_dead_count while smp_wmb makes sure that last_visited is updated
before last_dead_count so the up-to-date last_dead_count cannot point to
an outdated last_visited.  css_tryget then makes sure that the
last_visited is still alive in case the iteration races with the cached
group removal (css is invalidated before mem_cgroup_css_offline increments
dead_count).

In short:
mem_cgroup_iter
 rcu_read_lock()
 dead_count = atomic_read(parent->dead_count)
 smp_rmb()
 if (dead_count != iter->last_dead_count)
 	last_visited POSSIBLY INVALID -> last_visited = NULL
 if (!css_tryget(iter->last_visited))
 	last_visited DEAD -> last_visited = NULL
 next = find_next(last_visited)
 css_tryget(next)
 css_put(last_visited) 	// css would be invalidated and parent->dead_count
 			// incremented if this was the last reference
 iter->last_visited = next
 smp_wmb()
 iter->last_dead_count = dead_count
 rcu_read_unlock()

cgroup_rmdir
 cgroup_destroy_locked
  atomic_add(CSS_DEACT_BIAS, &css->refcnt) // subsequent css_tryget fail
   mem_cgroup_css_offline
    mem_cgroup_invalidate_reclaim_iterators
     while(parent = parent_mem_cgroup)
     	atomic_inc(parent->dead_count)
  css_put(css) // last reference held by cgroup core

Spotted by Ying Han.

Original idea from Johannes Weiner.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   69 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-relax-memcg-iter-caching mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-relax-memcg-iter-caching
+++ a/mm/memcontrol.c
@@ -152,12 +152,15 @@ struct mem_cgroup_stat_cpu {
 };
 
 struct mem_cgroup_reclaim_iter {
-	/* last scanned hierarchy member with elevated css ref count */
+	/*
+	 * last scanned hierarchy member. Valid only if last_dead_count
+	 * matches memcg->dead_count of the hierarchy root group.
+	 */
 	struct mem_cgroup *last_visited;
+	unsigned long last_dead_count;
+
 	/* scan generation, increased every round-trip */
 	unsigned int generation;
-	/* lock to protect the position and generation */
-	spinlock_t iter_lock;
 };
 
 /*
@@ -337,6 +340,7 @@ struct mem_cgroup {
 	struct mem_cgroup_stat_cpu nocpu_base;
 	spinlock_t pcp_counter_lock;
 
+	atomic_t	dead_count;
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct tcp_memcontrol tcp_mem;
 #endif
@@ -1092,6 +1096,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 {
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *last_visited = NULL;
+	unsigned long uninitialized_var(dead_count);
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1120,16 +1125,33 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 			mz = mem_cgroup_zoneinfo(root, nid, zid);
 			iter = &mz->reclaim_iter[reclaim->priority];
-			spin_lock(&iter->iter_lock);
 			last_visited = iter->last_visited;
 			if (prev && reclaim->generation != iter->generation) {
-				if (last_visited) {
-					css_put(&last_visited->css);
-					iter->last_visited = NULL;
-				}
-				spin_unlock(&iter->iter_lock);
+				iter->last_visited = NULL;
 				goto out_unlock;
 			}
+
+			/*
+                         * If the dead_count mismatches, a destruction
+                         * has happened or is happening concurrently.
+                         * If the dead_count matches, a destruction
+                         * might still happen concurrently, but since
+                         * we checked under RCU, that destruction
+                         * won't free the object until we release the
+                         * RCU reader lock.  Thus, the dead_count
+                         * check verifies the pointer is still valid,
+                         * css_tryget() verifies the cgroup pointed to
+                         * is alive.
+			 */
+			dead_count = atomic_read(&root->dead_count);
+			smp_rmb();
+			last_visited = iter->last_visited;
+			if (last_visited) {
+				if ((dead_count != iter->last_dead_count) ||
+					!css_tryget(&last_visited->css)) {
+					last_visited = NULL;
+				}
+			}
 		}
 
 		/*
@@ -1169,16 +1191,14 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			if (css && !memcg)
 				curr = mem_cgroup_from_css(css);
 
-			/* make sure that the cached memcg is not removed */
-			if (curr)
-				css_get(&curr->css);
 			iter->last_visited = curr;
+			smp_wmb();
+			iter->last_dead_count = dead_count;
 
 			if (!css)
 				iter->generation++;
 			else if (!prev && memcg)
 				reclaim->generation = iter->generation;
-			spin_unlock(&iter->iter_lock);
 		} else if (css && !memcg) {
 			last_visited = mem_cgroup_from_css(css);
 		}
@@ -5975,12 +5995,8 @@ static int alloc_mem_cgroup_per_zone_inf
 		return 1;
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-		int prio;
-
 		mz = &pn->zoneinfo[zone];
 		lruvec_init(&mz->lruvec);
-		for (prio = 0; prio < DEF_PRIORITY + 1; prio++)
-			spin_lock_init(&mz->reclaim_iter[prio].iter_lock);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
 		mz->memcg = memcg;
@@ -6235,10 +6251,29 @@ mem_cgroup_css_online(struct cgroup *con
 	return error;
 }
 
+/*
+ * Announce all parents that a group from their hierarchy is gone.
+ */
+static void mem_cgroup_invalidate_reclaim_iterators(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = memcg;
+
+	while ((parent = parent_mem_cgroup(parent)))
+		atomic_inc(&parent->dead_count);
+
+	/*
+	 * if the root memcg is not hierarchical we have to check it
+	 * explicitely.
+	 */
+	if (!root_mem_cgroup->use_hierarchy)
+		atomic_inc(&root_mem_cgroup->dead_count);
+}
+
 static void mem_cgroup_css_offline(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
+	mem_cgroup_invalidate_reclaim_iterators(memcg);
 	mem_cgroup_reparent_charges(memcg);
 	mem_cgroup_destroy_all_caches(memcg);
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
rmap-recompute-pgoff-for-unmapping-huge-page.patch
memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch
memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch
memcg-relax-memcg-iter-caching.patch
memcg-simplify-mem_cgroup_iter.patch
memcg-further-simplify-mem_cgroup_iter.patch
cgroup-remove-css_get_next.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

