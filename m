From: akpm@linux-foundation.org
Subject: [merged] memcg-enhance-memcg-iterator-to-support-predicates.patch removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:08 -0700
Message-ID: <52336f40.VPtKNL82DqJ9RkZK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3IMUCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, bsingharora@gmail.com, mhocko@suse.cz

Subject: [merged] memcg-enhance-memcg-iterator-to-support-predicates.patch removed from -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:08 -0700


The patch titled
     Subject: memcg: enhance memcg iterator to support predicates
has been removed from the -mm tree.  Its filename was
     memcg-enhance-memcg-iterator-to-support-predicates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: enhance memcg iterator to support predicates

The caller of the iterator might know that some nodes or even subtrees
should be skipped but there is no way to tell iterators about that so the
only choice left is to let iterators to visit each node and do the
selection outside of the iterating code.  This, however, doesn't scale
well with hierarchies with many groups where only few groups are
interesting.

This patch adds mem_cgroup_iter_cond variant of the iterator with a
callback which gets called for every visited node.  There are three
possible ways how the callback can influence the walk.  Either the node is
visited, it is skipped but the tree walk continues down the tree or the
whole subtree of the current group is skipped.

[hughd@google.com: fix memcg-less page reclaim]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   49 +++++++++++++++++++++---
 mm/memcontrol.c            |   70 +++++++++++++++++++++++++++--------
 mm/vmscan.c                |   16 ++------
 3 files changed, 103 insertions(+), 32 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-enhance-memcg-iterator-to-support-predicates include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-enhance-memcg-iterator-to-support-predicates
+++ a/include/linux/memcontrol.h
@@ -41,6 +41,23 @@ struct mem_cgroup_reclaim_cookie {
 	unsigned int generation;
 };
 
+enum mem_cgroup_filter_t {
+	VISIT,		/* visit current node */
+	SKIP,		/* skip the current node and continue traversal */
+	SKIP_TREE,	/* skip the whole subtree and continue traversal */
+};
+
+/*
+ * mem_cgroup_filter_t predicate might instruct mem_cgroup_iter_cond how to
+ * iterate through the hierarchy tree. Each tree element is checked by the
+ * predicate before it is returned by the iterator. If a filter returns
+ * SKIP or SKIP_TREE then the iterator code continues traversal (with the
+ * next node down the hierarchy or the next node that doesn't belong under the
+ * memcg's subtree).
+ */
+typedef enum mem_cgroup_filter_t
+(*mem_cgroup_iter_filter)(struct mem_cgroup *memcg, struct mem_cgroup *root);
+
 #ifdef CONFIG_MEMCG
 /*
  * All "charge" functions with gfp_mask should use GFP_KERNEL or
@@ -108,9 +125,18 @@ mem_cgroup_prepare_migration(struct page
 extern void mem_cgroup_end_migration(struct mem_cgroup *memcg,
 	struct page *oldpage, struct page *newpage, bool migration_ok);
 
-struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *,
-				   struct mem_cgroup *,
-				   struct mem_cgroup_reclaim_cookie *);
+struct mem_cgroup *mem_cgroup_iter_cond(struct mem_cgroup *root,
+				   struct mem_cgroup *prev,
+				   struct mem_cgroup_reclaim_cookie *reclaim,
+				   mem_cgroup_iter_filter cond);
+
+static inline struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
+				   struct mem_cgroup *prev,
+				   struct mem_cgroup_reclaim_cookie *reclaim)
+{
+	return mem_cgroup_iter_cond(root, prev, reclaim, NULL);
+}
+
 void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 
 /*
@@ -180,7 +206,8 @@ static inline void mem_cgroup_dec_page_s
 	mem_cgroup_update_page_stat(page, idx, -1);
 }
 
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
+enum mem_cgroup_filter_t
+mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
 		struct mem_cgroup *root);
 
 void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
@@ -295,6 +322,15 @@ static inline void mem_cgroup_end_migrat
 		struct page *oldpage, struct page *newpage, bool migration_ok)
 {
 }
+static inline struct mem_cgroup *
+mem_cgroup_iter_cond(struct mem_cgroup *root,
+		struct mem_cgroup *prev,
+		struct mem_cgroup_reclaim_cookie *reclaim,
+		mem_cgroup_iter_filter cond)
+{
+	/* first call must return non-NULL, second return NULL */
+	return (struct mem_cgroup *)(unsigned long)!prev;
+}
 
 static inline struct mem_cgroup *
 mem_cgroup_iter(struct mem_cgroup *root,
@@ -358,10 +394,11 @@ static inline void mem_cgroup_dec_page_s
 }
 
 static inline
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
+enum mem_cgroup_filter_t
+mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
-	return false;
+	return VISIT;
 }
 
 static inline void mem_cgroup_split_huge_fixup(struct page *head)
diff -puN mm/memcontrol.c~memcg-enhance-memcg-iterator-to-support-predicates mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-enhance-memcg-iterator-to-support-predicates
+++ a/mm/memcontrol.c
@@ -875,6 +875,15 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	return memcg;
 }
 
+static enum mem_cgroup_filter_t
+mem_cgroup_filter(struct mem_cgroup *memcg, struct mem_cgroup *root,
+		mem_cgroup_iter_filter cond)
+{
+	if (!cond)
+		return VISIT;
+	return cond(memcg, root);
+}
+
 /*
  * Returns a next (in a pre-order walk) alive memcg (with elevated css
  * ref. count) or NULL if the whole root's subtree has been visited.
@@ -882,7 +891,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
  * helper function to be used by mem_cgroup_iter
  */
 static struct mem_cgroup *__mem_cgroup_iter_next(struct mem_cgroup *root,
-		struct mem_cgroup *last_visited)
+		struct mem_cgroup *last_visited, mem_cgroup_iter_filter cond)
 {
 	struct cgroup_subsys_state *prev_css, *next_css;
 
@@ -900,11 +909,31 @@ skip_node:
 	if (next_css) {
 		struct mem_cgroup *mem = mem_cgroup_from_css(next_css);
 
-		if (css_tryget(&mem->css))
-			return mem;
-		else {
+		switch (mem_cgroup_filter(mem, root, cond)) {
+		case SKIP:
 			prev_css = next_css;
 			goto skip_node;
+		case SKIP_TREE:
+			if (mem == root)
+				return NULL;
+			/*
+			 * css_rightmost_descendant is not an optimal way to
+			 * skip through a subtree (especially for imbalanced
+			 * trees leaning to right) but that's what we have right
+			 * now. More effective solution would be traversing
+			 * right-up for first non-NULL without calling
+			 * css_next_descendant_pre afterwards.
+			 */
+			prev_css = css_rightmost_descendant(next_css);
+			goto skip_node;
+		case VISIT:
+			if (css_tryget(&mem->css))
+				return mem;
+			else {
+				prev_css = next_css;
+				goto skip_node;
+			}
+			break;
 		}
 	}
 
@@ -968,6 +997,7 @@ static void mem_cgroup_iter_update(struc
  * @root: hierarchy root
  * @prev: previously returned memcg, NULL on first invocation
  * @reclaim: cookie for shared reclaim walks, NULL for full walks
+ * @cond: filter for visited nodes, NULL for no filter
  *
  * Returns references to children of the hierarchy below @root, or
  * @root itself, or %NULL after a full round-trip.
@@ -980,15 +1010,18 @@ static void mem_cgroup_iter_update(struc
  * divide up the memcgs in the hierarchy among all concurrent
  * reclaimers operating on the same zone and priority.
  */
-struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
+struct mem_cgroup *mem_cgroup_iter_cond(struct mem_cgroup *root,
 				   struct mem_cgroup *prev,
-				   struct mem_cgroup_reclaim_cookie *reclaim)
+				   struct mem_cgroup_reclaim_cookie *reclaim,
+				   mem_cgroup_iter_filter cond)
 {
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *last_visited = NULL;
 
-	if (mem_cgroup_disabled())
-		return NULL;
+	if (mem_cgroup_disabled()) {
+		/* first call must return non-NULL, second return NULL */
+		return (struct mem_cgroup *)(unsigned long)!prev;
+	}
 
 	if (!root)
 		root = root_mem_cgroup;
@@ -999,7 +1032,9 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	if (!root->use_hierarchy && root != root_mem_cgroup) {
 		if (prev)
 			goto out_css_put;
-		return root;
+		if (mem_cgroup_filter(root, root, cond) == VISIT)
+			return root;
+		return NULL;
 	}
 
 	rcu_read_lock();
@@ -1022,7 +1057,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			last_visited = mem_cgroup_iter_load(iter, root, &seq);
 		}
 
-		memcg = __mem_cgroup_iter_next(root, last_visited);
+		memcg = __mem_cgroup_iter_next(root, last_visited, cond);
 
 		if (reclaim) {
 			mem_cgroup_iter_update(iter, last_visited, memcg, seq);
@@ -1033,7 +1068,11 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				reclaim->generation = iter->generation;
 		}
 
-		if (prev && !memcg)
+		/*
+		 * We have finished the whole tree walk or no group has been
+		 * visited because filter told us to skip the root node.
+		 */
+		if (!memcg && (prev || (cond && !last_visited)))
 			goto out_unlock;
 	}
 out_unlock:
@@ -1778,13 +1817,14 @@ int mem_cgroup_select_victim_node(struct
  * 	a) it is over its soft limit
  * 	b) any parent up the hierarchy is over its soft limit
  */
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
+enum mem_cgroup_filter_t
+mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
 	struct mem_cgroup *parent = memcg;
 
 	if (res_counter_soft_limit_excess(&memcg->res))
-		return true;
+		return VISIT;
 
 	/*
 	 * If any parent up to the root in the hierarchy is over its soft limit
@@ -1792,12 +1832,12 @@ bool mem_cgroup_soft_reclaim_eligible(st
 	 */
 	while((parent = parent_mem_cgroup(parent))) {
 		if (res_counter_soft_limit_excess(&parent->res))
-			return true;
+			return VISIT;
 		if (parent == root)
 			break;
 	}
 
-	return false;
+	return SKIP;
 }
 
 /*
diff -puN mm/vmscan.c~memcg-enhance-memcg-iterator-to-support-predicates mm/vmscan.c
--- a/mm/vmscan.c~memcg-enhance-memcg-iterator-to-support-predicates
+++ a/mm/vmscan.c
@@ -2151,21 +2151,16 @@ __shrink_zone(struct zone *zone, struct
 			.zone = zone,
 			.priority = sc->priority,
 		};
-		struct mem_cgroup *memcg;
+		struct mem_cgroup *memcg = NULL;
+		mem_cgroup_iter_filter filter = (soft_reclaim) ?
+			mem_cgroup_soft_reclaim_eligible : NULL;
 
 		nr_reclaimed = sc->nr_reclaimed;
 		nr_scanned = sc->nr_scanned;
 
-		memcg = mem_cgroup_iter(root, NULL, &reclaim);
-		do {
+		while ((memcg = mem_cgroup_iter_cond(root, memcg, &reclaim, filter))) {
 			struct lruvec *lruvec;
 
-			if (soft_reclaim &&
-			    !mem_cgroup_soft_reclaim_eligible(memcg, root)) {
-				memcg = mem_cgroup_iter(root, memcg, &reclaim);
-				continue;
-			}
