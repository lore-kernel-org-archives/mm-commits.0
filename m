From: akpm@linux-foundation.org
Subject: + memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch added to -mm tree
Date: Wed, 13 Mar 2013 15:21:23 -0700
Message-ID: <20130313222123.E9CF55A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:44003 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3CMWVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Mar 2013 18:21:25 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so153062vbb.4
        for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2013 15:21:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, yinghan@google.com


The patch titled
     Subject: memcg: rework mem_cgroup_iter to use cgroup iterators
has been added to the -mm tree.  Its filename is
     memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch

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
Subject: memcg: rework mem_cgroup_iter to use cgroup iterators

mem_cgroup_iter curently relies on css->id when walking down a group
hierarchy tree.  This is really awkward because the tree walk depends on
the groups creation ordering.  The only guarantee is that a parent node is
visited before its children.

Example:

 1) mkdir -p a a/d a/b/c
 2) mkdir -a a/b/c a/d

Will create the same trees but the tree walks will be different:

 1) a, d, b, c
 2) a, b, c, d

574bd9f7 ("cgroup: implement generic child / descendant walk macros") has
introduced generic cgroup tree walkers which provide either pre-order or
post-order tree walk.  This patch converts css->id based iteration to
pre-order tree walk to keep the semantic with the original iterator where
parent is always visited before its subtree.

cgroup_for_each_descendant_pre suggests using post_create and pre_destroy
for proper synchronization with groups addidition resp.  removal.  This
implementation doesn't use those because a new memory cgroup is
initialized sufficiently for iteration in mem_cgroup_css_alloc already and
css reference counting enforces that the group is alive for both the last
seen cgroup and the found one resp.  it signals that the group is dead and
it should be skipped.

If the reclaim cookie is used we need to store the last visited group into
the iterator so we have to be careful that it doesn't disappear in the
mean time.  Elevated reference count on the css keeps it alive even though
the group have been removed (parked waiting for the last dput so that it
can be freed).

Per node-zone-prio iter_lock has been introduced to ensure that css_tryget
and iter->last_visited is set atomically.  Otherwise two racing walkers
could both take a references and only one release it leading to a css leak
(which pins cgroup dentry).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   86 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators
+++ a/mm/memcontrol.c
@@ -152,10 +152,12 @@ struct mem_cgroup_stat_cpu {
 };
 
 struct mem_cgroup_reclaim_iter {
-	/* css_id of the last scanned hierarchy member */
-	int position;
+	/* last scanned hierarchy member with elevated css ref count */
+	struct mem_cgroup *last_visited;
 	/* scan generation, increased every round-trip */
 	unsigned int generation;
+	/* lock to protect the position and generation */
+	spinlock_t iter_lock;
 };
 
 /*
@@ -1089,7 +1091,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				   struct mem_cgroup_reclaim_cookie *reclaim)
 {
 	struct mem_cgroup *memcg = NULL;
-	int id = 0;
+	struct mem_cgroup *last_visited = NULL;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1098,7 +1100,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		root = root_mem_cgroup;
 
 	if (prev && !reclaim)
-		id = css_id(&prev->css);
+		last_visited = prev;
 
 	if (!root->use_hierarchy && root != root_mem_cgroup) {
 		if (prev)
@@ -1106,9 +1108,10 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		return root;
 	}
 
+	rcu_read_lock();
 	while (!memcg) {
 		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
-		struct cgroup_subsys_state *css;
+		struct cgroup_subsys_state *css = NULL;
 
 		if (reclaim) {
 			int nid = zone_to_nid(reclaim->zone);
@@ -1117,31 +1120,74 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 			mz = mem_cgroup_zoneinfo(root, nid, zid);
 			iter = &mz->reclaim_iter[reclaim->priority];
-			if (prev && reclaim->generation != iter->generation)
-				goto out_css_put;
-			id = iter->position;
+			spin_lock(&iter->iter_lock);
+			last_visited = iter->last_visited;
+			if (prev && reclaim->generation != iter->generation) {
+				if (last_visited) {
+					css_put(&last_visited->css);
+					iter->last_visited = NULL;
+				}
+				spin_unlock(&iter->iter_lock);
+				goto out_unlock;
+			}
 		}
 
-		rcu_read_lock();
-		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
-		if (css) {
-			if (css == &root->css || css_tryget(css))
-				memcg = mem_cgroup_from_css(css);
-		} else
-			id = 0;
-		rcu_read_unlock();
+		/*
+		 * Root is not visited by cgroup iterators so it needs an
+		 * explicit visit.
+		 */
+		if (!last_visited) {
+			css = &root->css;
+		} else {
+			struct cgroup *prev_cgroup, *next_cgroup;
+
+			prev_cgroup = (last_visited == root) ? NULL
+				: last_visited->css.cgroup;
+			next_cgroup = cgroup_next_descendant_pre(prev_cgroup,
+					root->css.cgroup);
+			if (next_cgroup)
+				css = cgroup_subsys_state(next_cgroup,
+						mem_cgroup_subsys_id);
+		}
+
+		/*
+		 * Even if we found a group we have to make sure it is alive.
+		 * css && !memcg means that the groups should be skipped and
+		 * we should continue the tree walk.
+		 * last_visited css is safe to use because it is protected by
+		 * css_get and the tree walk is rcu safe.
+		 */
+		if (css == &root->css || (css && css_tryget(css)))
+			memcg = mem_cgroup_from_css(css);
 
 		if (reclaim) {
-			iter->position = id;
+			struct mem_cgroup *curr = memcg;
+
+			if (last_visited)
+				css_put(&last_visited->css);
+
+			if (css && !memcg)
+				curr = mem_cgroup_from_css(css);
+
+			/* make sure that the cached memcg is not removed */
+			if (curr)
+				css_get(&curr->css);
+			iter->last_visited = curr;
+
 			if (!css)
 				iter->generation++;
 			else if (!prev && memcg)
 				reclaim->generation = iter->generation;
+			spin_unlock(&iter->iter_lock);
+		} else if (css && !memcg) {
+			last_visited = mem_cgroup_from_css(css);
 		}
 
 		if (prev && !css)
-			goto out_css_put;
+			goto out_unlock;
 	}
+out_unlock:
+	rcu_read_unlock();
 out_css_put:
 	if (prev && prev != root)
 		css_put(&prev->css);
@@ -5929,8 +5975,12 @@ static int alloc_mem_cgroup_per_zone_inf
 		return 1;
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		int prio;
+
 		mz = &pn->zoneinfo[zone];
 		lruvec_init(&mz->lruvec);
+		for (prio = 0; prio < DEF_PRIORITY + 1; prio++)
+			spin_lock_init(&mz->reclaim_iter[prio].iter_lock);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
 		mz->memcg = memcg;
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

