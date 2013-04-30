From: akpm@linux-foundation.org
Subject: [merged] memcg-simplify-mem_cgroup_iter.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:00 -0700
Message-ID: <20130430184700.89A1E31C2B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56077 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159Ab3D3Sxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:53 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so86619vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, glommer@parallels.com, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: simplify mem_cgroup_iter
has been removed from the -mm tree.  Its filename was
     memcg-simplify-mem_cgroup_iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: simplify mem_cgroup_iter

Current implementation of mem_cgroup_iter has to consider both css and
memcg to find out whether no group has been found (css==NULL - aka the
loop is completed) and that no memcg is associated with the found node
(!memcg - aka css_tryget failed because the group is no longer alive). 
This leads to awkward tweaks like tests for css && !memcg to skip the
current node.

It will be much easier if we got rid off css variable altogether and only
rely on memcg.  In order to do that the iteration part has to skip dead
nodes.  This sounds natural to me and as a nice side effect we will get a
simple invariant that memcg is always alive when non-NULL and all nodes
have been visited otherwise.

We could get rid of the surrounding while loop but keep it in for now to
make review easier. It will go away in the following patch.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   52 ++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-mem_cgroup_iter mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1116,7 +1116,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	rcu_read_lock();
 	while (!memcg) {
 		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
-		struct cgroup_subsys_state *css = NULL;
 
 		if (reclaim) {
 			int nid = zone_to_nid(reclaim->zone);
@@ -1159,51 +1158,50 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		 * explicit visit.
 		 */
 		if (!last_visited) {
-			css = &root->css;
+			memcg = root;
 		} else {
 			struct cgroup *prev_cgroup, *next_cgroup;
 
 			prev_cgroup = (last_visited == root) ? NULL
 				: last_visited->css.cgroup;
-			next_cgroup = cgroup_next_descendant_pre(prev_cgroup,
-					root->css.cgroup);
-			if (next_cgroup)
-				css = cgroup_subsys_state(next_cgroup,
-						mem_cgroup_subsys_id);
-		}
+skip_node:
+			next_cgroup = cgroup_next_descendant_pre(
+					prev_cgroup, root->css.cgroup);
 
-		/*
-		 * Even if we found a group we have to make sure it is alive.
-		 * css && !memcg means that the groups should be skipped and
-		 * we should continue the tree walk.
-		 * last_visited css is safe to use because it is protected by
-		 * css_get and the tree walk is rcu safe.
-		 */
-		if (css == &root->css || (css && css_tryget(css)))
-			memcg = mem_cgroup_from_css(css);
+			/*
+			 * Even if we found a group we have to make sure it is
+			 * alive. css && !memcg means that the groups should be
+			 * skipped and we should continue the tree walk.
+			 * last_visited css is safe to use because it is
+			 * protected by css_get and the tree walk is rcu safe.
+			 */
+			if (next_cgroup) {
+				struct mem_cgroup *mem = mem_cgroup_from_cont(
+						next_cgroup);
+				if (css_tryget(&mem->css))
+					memcg = mem;
+				else {
+					prev_cgroup = next_cgroup;
+					goto skip_node;
+				}
+			}
+		}
 
 		if (reclaim) {
-			struct mem_cgroup *curr = memcg;
-
 			if (last_visited)
 				css_put(&last_visited->css);
 
-			if (css && !memcg)
-				curr = mem_cgroup_from_css(css);
-
-			iter->last_visited = curr;
+			iter->last_visited = memcg;
 			smp_wmb();
 			iter->last_dead_count = dead_count;
 
-			if (!css)
+			if (!memcg)
 				iter->generation++;
 			else if (!prev && memcg)
 				reclaim->generation = iter->generation;
-		} else if (css && !memcg) {
-			last_visited = mem_cgroup_from_css(css);
 		}
 
-		if (prev && !css)
+		if (prev && !memcg)
 			goto out_unlock;
 	}
 out_unlock:
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

