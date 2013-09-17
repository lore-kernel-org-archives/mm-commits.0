From: akpm@linux-foundation.org
Subject: + revert-memcg-enhance-memcg-iterator-to-support-predicates.patch added to -mm tree
Date: Tue, 17 Sep 2013 13:58:05 -0700
Message-ID: <5238c25d.TWMsiSLvYcrngYqa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab3IQU6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 16:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: + revert-memcg-enhance-memcg-iterator-to-support-predicates.patch added to -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 13:58:05 -0700


The patch titled
     Subject: revert "memcg: enhance memcg iterator to support predicates"
has been added to the -mm tree.  Its filename is
     revert-memcg-enhance-memcg-iterator-to-support-predicates.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-memcg-enhance-memcg-iterator-to-support-predicates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "memcg: enhance memcg iterator to support predicates"

Revert

: commit de57780dc659f95b17ccb649f003278dde0b5b86
: Author:     Michal Hocko <mhocko@suse.cz>
: AuthorDate: Thu Sep 12 15:13:26 2013 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Sep 12 15:38:00 2013 -0700
: 
:     memcg: enhance memcg iterator to support predicates

I merged this prematurely - Michal and Johannes still disagree about the
overall design direction and the future remains unclear.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   49 +++---------------------
 mm/memcontrol.c            |   70 +++++++----------------------------
 mm/vmscan.c                |   16 +++++---
 3 files changed, 32 insertions(+), 103 deletions(-)

diff -puN include/linux/memcontrol.h~revert-memcg-enhance-memcg-iterator-to-support-predicates include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~revert-memcg-enhance-memcg-iterator-to-support-predicates
+++ a/include/linux/memcontrol.h
@@ -53,23 +53,6 @@ struct mem_cgroup_reclaim_cookie {
 	unsigned int generation;
 };
 
-enum mem_cgroup_filter_t {
-	VISIT,		/* visit current node */
-	SKIP,		/* skip the current node and continue traversal */
-	SKIP_TREE,	/* skip the whole subtree and continue traversal */
-};
-
-/*
- * mem_cgroup_filter_t predicate might instruct mem_cgroup_iter_cond how to
- * iterate through the hierarchy tree. Each tree element is checked by the
- * predicate before it is returned by the iterator. If a filter returns
- * SKIP or SKIP_TREE then the iterator code continues traversal (with the
- * next node down the hierarchy or the next node that doesn't belong under the
- * memcg's subtree).
- */
-typedef enum mem_cgroup_filter_t
-(*mem_cgroup_iter_filter)(struct mem_cgroup *memcg, struct mem_cgroup *root);
-
 #ifdef CONFIG_MEMCG
 /*
  * All "charge" functions with gfp_mask should use GFP_KERNEL or
@@ -137,18 +120,9 @@ mem_cgroup_prepare_migration(struct page
 extern void mem_cgroup_end_migration(struct mem_cgroup *memcg,
 	struct page *oldpage, struct page *newpage, bool migration_ok);
 
-struct mem_cgroup *mem_cgroup_iter_cond(struct mem_cgroup *root,
-				   struct mem_cgroup *prev,
-				   struct mem_cgroup_reclaim_cookie *reclaim,
-				   mem_cgroup_iter_filter cond);
-
-static inline struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
-				   struct mem_cgroup *prev,
-				   struct mem_cgroup_reclaim_cookie *reclaim)
-{
-	return mem_cgroup_iter_cond(root, prev, reclaim, NULL);
-}
-
+struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *,
+				   struct mem_cgroup *,
+				   struct mem_cgroup_reclaim_cookie *);
 void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 
 /*
@@ -260,8 +234,7 @@ static inline void mem_cgroup_dec_page_s
 	mem_cgroup_update_page_stat(page, idx, -1);
 }
 
-enum mem_cgroup_filter_t
-mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
 		struct mem_cgroup *root);
 
 void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
@@ -376,15 +349,6 @@ static inline void mem_cgroup_end_migrat
 		struct page *oldpage, struct page *newpage, bool migration_ok)
 {
 }
-static inline struct mem_cgroup *
-mem_cgroup_iter_cond(struct mem_cgroup *root,
-		struct mem_cgroup *prev,
-		struct mem_cgroup_reclaim_cookie *reclaim,
-		mem_cgroup_iter_filter cond)
-{
-	/* first call must return non-NULL, second return NULL */
-	return (struct mem_cgroup *)(unsigned long)!prev;
-}
 
 static inline struct mem_cgroup *
 mem_cgroup_iter(struct mem_cgroup *root,
@@ -471,11 +435,10 @@ static inline void mem_cgroup_dec_page_s
 }
 
 static inline
-enum mem_cgroup_filter_t
-mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
-	return VISIT;
+	return false;
 }
 
 static inline void mem_cgroup_split_huge_fixup(struct page *head)
diff -puN mm/memcontrol.c~revert-memcg-enhance-memcg-iterator-to-support-predicates mm/memcontrol.c
--- a/mm/memcontrol.c~revert-memcg-enhance-memcg-iterator-to-support-predicates
+++ a/mm/memcontrol.c
@@ -862,15 +862,6 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	return memcg;
 }
 
-static enum mem_cgroup_filter_t
-mem_cgroup_filter(struct mem_cgroup *memcg, struct mem_cgroup *root,
-		mem_cgroup_iter_filter cond)
-{
-	if (!cond)
-		return VISIT;
-	return cond(memcg, root);
-}
-
 /*
  * Returns a next (in a pre-order walk) alive memcg (with elevated css
  * ref. count) or NULL if the whole root's subtree has been visited.
@@ -878,7 +869,7 @@ mem_cgroup_filter(struct mem_cgroup *mem
  * helper function to be used by mem_cgroup_iter
  */
 static struct mem_cgroup *__mem_cgroup_iter_next(struct mem_cgroup *root,
-		struct mem_cgroup *last_visited, mem_cgroup_iter_filter cond)
+		struct mem_cgroup *last_visited)
 {
 	struct cgroup_subsys_state *prev_css, *next_css;
 
@@ -896,31 +887,11 @@ skip_node:
 	if (next_css) {
 		struct mem_cgroup *mem = mem_cgroup_from_css(next_css);
 
-		switch (mem_cgroup_filter(mem, root, cond)) {
-		case SKIP:
+		if (css_tryget(&mem->css))
+			return mem;
+		else {
 			prev_css = next_css;
 			goto skip_node;
-		case SKIP_TREE:
-			if (mem == root)
-				return NULL;
-			/*
-			 * css_rightmost_descendant is not an optimal way to
-			 * skip through a subtree (especially for imbalanced
-			 * trees leaning to right) but that's what we have right
-			 * now. More effective solution would be traversing
-			 * right-up for first non-NULL without calling
-			 * css_next_descendant_pre afterwards.
-			 */
-			prev_css = css_rightmost_descendant(next_css);
-			goto skip_node;
-		case VISIT:
-			if (css_tryget(&mem->css))
-				return mem;
-			else {
-				prev_css = next_css;
-				goto skip_node;
-			}
-			break;
 		}
 	}
 
@@ -984,7 +955,6 @@ static void mem_cgroup_iter_update(struc
  * @root: hierarchy root
  * @prev: previously returned memcg, NULL on first invocation
  * @reclaim: cookie for shared reclaim walks, NULL for full walks
- * @cond: filter for visited nodes, NULL for no filter
  *
  * Returns references to children of the hierarchy below @root, or
  * @root itself, or %NULL after a full round-trip.
@@ -997,18 +967,15 @@ static void mem_cgroup_iter_update(struc
  * divide up the memcgs in the hierarchy among all concurrent
  * reclaimers operating on the same zone and priority.
  */
-struct mem_cgroup *mem_cgroup_iter_cond(struct mem_cgroup *root,
+struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				   struct mem_cgroup *prev,
-				   struct mem_cgroup_reclaim_cookie *reclaim,
-				   mem_cgroup_iter_filter cond)
+				   struct mem_cgroup_reclaim_cookie *reclaim)
 {
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *last_visited = NULL;
 
-	if (mem_cgroup_disabled()) {
-		/* first call must return non-NULL, second return NULL */
-		return (struct mem_cgroup *)(unsigned long)!prev;
-	}
+	if (mem_cgroup_disabled())
+		return NULL;
 
 	if (!root)
 		root = root_mem_cgroup;
@@ -1019,9 +986,7 @@ struct mem_cgroup *mem_cgroup_iter_cond(
 	if (!root->use_hierarchy && root != root_mem_cgroup) {
 		if (prev)
 			goto out_css_put;
-		if (mem_cgroup_filter(root, root, cond) == VISIT)
-			return root;
-		return NULL;
+		return root;
 	}
 
 	rcu_read_lock();
@@ -1044,7 +1009,7 @@ struct mem_cgroup *mem_cgroup_iter_cond(
 			last_visited = mem_cgroup_iter_load(iter, root, &seq);
 		}
 
-		memcg = __mem_cgroup_iter_next(root, last_visited, cond);
+		memcg = __mem_cgroup_iter_next(root, last_visited);
 
 		if (reclaim) {
 			mem_cgroup_iter_update(iter, last_visited, memcg, seq);
@@ -1055,11 +1020,7 @@ struct mem_cgroup *mem_cgroup_iter_cond(
 				reclaim->generation = iter->generation;
 		}
 
-		/*
-		 * We have finished the whole tree walk or no group has been
-		 * visited because filter told us to skip the root node.
-		 */
-		if (!memcg && (prev || (cond && !last_visited)))
+		if (prev && !memcg)
 			goto out_unlock;
 	}
 out_unlock:
@@ -1804,14 +1765,13 @@ int mem_cgroup_select_victim_node(struct
  *	a) it is over its soft limit
  *	b) any parent up the hierarchy is over its soft limit
  */
-enum mem_cgroup_filter_t
-mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
 	struct mem_cgroup *parent = memcg;
 
 	if (res_counter_soft_limit_excess(&memcg->res))
-		return VISIT;
+		return true;
 
 	/*
 	 * If any parent up to the root in the hierarchy is over its soft limit
@@ -1819,12 +1779,12 @@ mem_cgroup_soft_reclaim_eligible(struct
 	 */
 	while ((parent = parent_mem_cgroup(parent))) {
 		if (res_counter_soft_limit_excess(&parent->res))
-			return VISIT;
+			return true;
 		if (parent == root)
 			break;
 	}
 
-	return SKIP;
+	return false;
 }
 
 static DEFINE_SPINLOCK(memcg_oom_lock);
diff -puN mm/vmscan.c~revert-memcg-enhance-memcg-iterator-to-support-predicates mm/vmscan.c
--- a/mm/vmscan.c~revert-memcg-enhance-memcg-iterator-to-support-predicates
+++ a/mm/vmscan.c
@@ -2185,16 +2185,21 @@ __shrink_zone(struct zone *zone, struct
 			.zone = zone,
 			.priority = sc->priority,
 		};
-		struct mem_cgroup *memcg = NULL;
-		mem_cgroup_iter_filter filter = (soft_reclaim) ?
-			mem_cgroup_soft_reclaim_eligible : NULL;
+		struct mem_cgroup *memcg;
 
 		nr_reclaimed = sc->nr_reclaimed;
 		nr_scanned = sc->nr_scanned;
 
-		while ((memcg = mem_cgroup_iter_cond(root, memcg, &reclaim, filter))) {
+		memcg = mem_cgroup_iter(root, NULL, &reclaim);
+		do {
 			struct lruvec *lruvec;
 
+			if (soft_reclaim &&
+			    !mem_cgroup_soft_reclaim_eligible(memcg, root)) {
+				memcg = mem_cgroup_iter(root, memcg, &reclaim);
+				continue;
+			}
+
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 			shrink_lruvec(lruvec, sc);
@@ -2214,7 +2219,8 @@ __shrink_zone(struct zone *zone, struct
 				mem_cgroup_iter_break(root, memcg);
 				break;
 			}
-		}
+			memcg = mem_cgroup_iter(root, memcg, &reclaim);
+		} while (memcg);
 
 		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
 			   sc->nr_scanned - nr_scanned,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch

