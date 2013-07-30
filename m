From: akpm@linux-foundation.org
Subject: + memcg-enhance-memcg-iterator-to-support-predicates.patch added
 to -mm tree
Date: Tue, 30 Jul 2013 15:33:56 -0700
Message-ID: <51f83f54.DwAdvG6lHi6sStl1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3G3Wd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 18:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, bsingharora@gmail.com, mhocko@suse.cz

Subject: + memcg-enhance-memcg-iterator-to-support-predicates.patch added to -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 15:33:56 -0700


The patch titled
     Subject: memcg: enhance memcg iterator to support predicates
has been added to the -mm tree.  Its filename is
     memcg-enhance-memcg-iterator-to-support-predicates.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-enhance-memcg-iterator-to-support-predicates.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-enhance-memcg-iterator-to-support-predicates.patch

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

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   48 +++++++++++++++++++--
 mm/memcontrol.c            |   77 +++++++++++++++++++++++++++--------
 mm/vmscan.c                |   16 ++-----
 3 files changed, 108 insertions(+), 33 deletions(-)

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
@@ -295,6 +322,14 @@ static inline void mem_cgroup_end_migrat
 		struct page *oldpage, struct page *newpage, bool migration_ok)
 {
 }
+static inline struct mem_cgroup *
+mem_cgroup_iter_cond(struct mem_cgroup *root,
+		struct mem_cgroup *prev,
+		struct mem_cgroup_reclaim_cookie *reclaim,
+		mem_cgroup_iter_filter cond)
+{
+	return NULL;
+}
 
 static inline struct mem_cgroup *
 mem_cgroup_iter(struct mem_cgroup *root,
@@ -358,10 +393,11 @@ static inline void mem_cgroup_dec_page_s
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
@@ -882,6 +882,15 @@ struct mem_cgroup *try_get_mem_cgroup_fr
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
@@ -889,7 +898,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
  * helper function to be used by mem_cgroup_iter
  */
 static struct mem_cgroup *__mem_cgroup_iter_next(struct mem_cgroup *root,
-		struct mem_cgroup *last_visited)
+		struct mem_cgroup *last_visited, mem_cgroup_iter_filter cond)
 {
 	struct cgroup *prev_cgroup, *next_cgroup;
 
@@ -897,10 +906,18 @@ static struct mem_cgroup *__mem_cgroup_i
 	 * Root is not visited by cgroup iterators so it needs an
 	 * explicit visit.
 	 */
-	if (!last_visited)
-		return root;
+	if (!last_visited) {
+		switch(mem_cgroup_filter(root, root, cond)) {
+		case VISIT:
+			return root;
+		case SKIP:
+			break;
+		case SKIP_TREE:
+			return NULL;
+		}
+	}
 
-	prev_cgroup = (last_visited == root) ? NULL
+	prev_cgroup = (last_visited == root || !last_visited) ? NULL
 		: last_visited->css.cgroup;
 skip_node:
 	next_cgroup = cgroup_next_descendant_pre(
@@ -916,11 +933,30 @@ skip_node:
 	if (next_cgroup) {
 		struct mem_cgroup *mem = mem_cgroup_from_cont(
 				next_cgroup);
-		if (css_tryget(&mem->css))
-			return mem;
-		else {
+
+		switch (mem_cgroup_filter(mem, root, cond)) {
+		case SKIP:
 			prev_cgroup = next_cgroup;
 			goto skip_node;
+		case SKIP_TREE:
+			/*
+			 * cgroup_rightmost_descendant is not an optimal way to
+			 * skip through a subtree (especially for imbalanced
+			 * trees leaning to right) but that's what we have right
+			 * now. More effective solution would be traversing
+			 * right-up for first non-NULL without calling
+			 * cgroup_next_descendant_pre afterwards.
+			 */
+			prev_cgroup = cgroup_rightmost_descendant(next_cgroup);
+			goto skip_node;
+		case VISIT:
+			if (css_tryget(&mem->css))
+				return mem;
+			else {
+				prev_cgroup = next_cgroup;
+				goto skip_node;
+			}
+			break;
 		}
 	}
 
@@ -984,6 +1020,7 @@ static void mem_cgroup_iter_update(struc
  * @root: hierarchy root
  * @prev: previously returned memcg, NULL on first invocation
  * @reclaim: cookie for shared reclaim walks, NULL for full walks
+ * @cond: filter for visited nodes, NULL for no filter
  *
  * Returns references to children of the hierarchy below @root, or
  * @root itself, or %NULL after a full round-trip.
@@ -996,9 +1033,10 @@ static void mem_cgroup_iter_update(struc
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
@@ -1015,7 +1053,9 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	if (!root->use_hierarchy && root != root_mem_cgroup) {
 		if (prev)
 			goto out_css_put;
-		return root;
+		if (mem_cgroup_filter(root, root, cond) == VISIT)
+			return root;
+		return NULL;
 	}
 
 	rcu_read_lock();
@@ -1038,7 +1078,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			last_visited = mem_cgroup_iter_load(iter, root, &seq);
 		}
 
-		memcg = __mem_cgroup_iter_next(root, last_visited);
+		memcg = __mem_cgroup_iter_next(root, last_visited, cond);
 
 		if (reclaim) {
 			mem_cgroup_iter_update(iter, last_visited, memcg, seq);
@@ -1049,7 +1089,11 @@ struct mem_cgroup *mem_cgroup_iter(struc
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
@@ -1797,13 +1841,14 @@ int mem_cgroup_select_victim_node(struct
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
@@ -1811,12 +1856,12 @@ bool mem_cgroup_soft_reclaim_eligible(st
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
@@ -2132,21 +2132,16 @@ __shrink_zone(struct zone *zone, struct
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
-
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 			shrink_lruvec(lruvec, sc);
@@ -2166,8 +2161,7 @@ __shrink_zone(struct zone *zone, struct
 				mem_cgroup_iter_break(root, memcg);
 				break;
 			}
-			memcg = mem_cgroup_iter(root, memcg, &reclaim);
-		} while (memcg);
+		}
 
 		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
 			   sc->nr_scanned - nr_scanned,
_

Patches currently in -mm which might be from mhocko@suse.cz are

vmpressure-change-vmpressure-sr_lock-to-spinlock.patch
vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
mm-fix-potential-null-pointer-dereference.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
memcg-trivial-cleanups.patch
linux-next.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

