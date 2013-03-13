From: akpm@linux-foundation.org
Subject: + memcg-further-simplify-mem_cgroup_iter.patch added to -mm tree
Date: Wed, 13 Mar 2013 15:21:31 -0700
Message-ID: <20130313222131.7E0075A432D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57907 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab3CMWVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Mar 2013 18:21:33 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so176210qaj.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2013 15:21:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, yinghan@google.com


The patch titled
     Subject: memcg: further simplify mem_cgroup_iter
has been added to the -mm tree.  Its filename is
     memcg-further-simplify-mem_cgroup_iter.patch

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

