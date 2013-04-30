From: akpm@linux-foundation.org
Subject: [merged] memcg-further-simplify-mem_cgroup_iter.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:03 -0700
Message-ID: <20130430184703.87C4E5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:50845 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217Ab3D3SzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:19 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so86757yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, glommer@parallels.com, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: further simplify mem_cgroup_iter
has been removed from the -mm tree.  Its filename was
     memcg-further-simplify-mem_cgroup_iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: further simplify mem_cgroup_iter

mem_cgroup_iter basically does two things currently.  It takes care of the
house keeping (reference counting, raclaim cookie) and it iterates through
a hierarchy tree (by using cgroup generic tree walk).  The code would be
much more easier to follow if we move the iteration outside of the
function (to __mem_cgrou_iter_next) so the distinction is more clear. 
This patch doesn't introduce any functional changes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   79 ++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff -puN mm/memcontrol.c~memcg-further-simplify-mem_cgroup_iter mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-further-simplify-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1073,6 +1073,51 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	return memcg;
 }
 
+/*
+ * Returns a next (in a pre-order walk) alive memcg (with elevated css
+ * ref. count) or NULL if the whole root's subtree has been visited.
+ *
+ * helper function to be used by mem_cgroup_iter
+ */
+static struct mem_cgroup *__mem_cgroup_iter_next(struct mem_cgroup *root,
+		struct mem_cgroup *last_visited)
+{
+	struct cgroup *prev_cgroup, *next_cgroup;
+
+	/*
+	 * Root is not visited by cgroup iterators so it needs an
+	 * explicit visit.
+	 */
+	if (!last_visited)
+		return root;
+
+	prev_cgroup = (last_visited == root) ? NULL
+		: last_visited->css.cgroup;
+skip_node:
+	next_cgroup = cgroup_next_descendant_pre(
+			prev_cgroup, root->css.cgroup);
+
+	/*
+	 * Even if we found a group we have to make sure it is
+	 * alive. css && !memcg means that the groups should be
+	 * skipped and we should continue the tree walk.
+	 * last_visited css is safe to use because it is
+	 * protected by css_get and the tree walk is rcu safe.
+	 */
+	if (next_cgroup) {
+		struct mem_cgroup *mem = mem_cgroup_from_cont(
+				next_cgroup);
+		if (css_tryget(&mem->css))
+			return mem;
+		else {
+			prev_cgroup = next_cgroup;
+			goto skip_node;
+		}
+	}
+
+	return NULL;
+}
+
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
@@ -1153,39 +1198,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			}
 		}
 
-		/*
-		 * Root is not visited by cgroup iterators so it needs an
-		 * explicit visit.
-		 */
-		if (!last_visited) {
-			memcg = root;
-		} else {
-			struct cgroup *prev_cgroup, *next_cgroup;
-
-			prev_cgroup = (last_visited == root) ? NULL
-				: last_visited->css.cgroup;
-skip_node:
-			next_cgroup = cgroup_next_descendant_pre(
-					prev_cgroup, root->css.cgroup);
-
-			/*
-			 * Even if we found a group we have to make sure it is
-			 * alive. css && !memcg means that the groups should be
-			 * skipped and we should continue the tree walk.
-			 * last_visited css is safe to use because it is
-			 * protected by css_get and the tree walk is rcu safe.
-			 */
-			if (next_cgroup) {
-				struct mem_cgroup *mem = mem_cgroup_from_cont(
-						next_cgroup);
-				if (css_tryget(&mem->css))
-					memcg = mem;
-				else {
-					prev_cgroup = next_cgroup;
-					goto skip_node;
-				}
-			}
-		}
+		memcg = __mem_cgroup_iter_next(root, last_visited);
 
 		if (reclaim) {
 			if (last_visited)
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

