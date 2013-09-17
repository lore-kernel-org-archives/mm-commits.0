From: akpm@linux-foundation.org
Subject: +
 revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch added to -mm tree
Date: Tue, 17 Sep 2013 13:58:11 -0700
Message-ID: <5238c263.bldH6nK4RQe5nN4l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3IQU6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 16:58:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org, akpm@linux-foundation.org

Subject: + revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch added to -mm tree
To: akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@suse.cz,torvalds@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 13:58:11 -0700


The patch titled
     Subject: revert "memcg, vmscan: integrate soft reclaim tighter with zone shrinking code"
has been added to the -mm tree.  Its filename is
     revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch

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
Subject: revert "memcg, vmscan: integrate soft reclaim tighter with zone shrinking code"

Revert

: commit 3b38722efd9f66da63bbbd41520c2e6fa9db3d68
: Author:     Michal Hocko <mhocko@suse.cz>
: AuthorDate: Thu Sep 12 15:13:21 2013 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Sep 12 15:38:00 2013 -0700
: 
:     memcg, vmscan: integrate soft reclaim tighter with zone shrinking code

I merged this prematurely - Michal and Johannes still disagree about the
overall design direction and the future remains unclear.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +-
 mm/memcontrol.c            |  163 ++++++++++++++++++++++++++++++-----
 mm/vmscan.c                |   62 +++++--------
 3 files changed, 175 insertions(+), 60 deletions(-)

diff -puN include/linux/memcontrol.h~revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code
+++ a/include/linux/memcontrol.h
@@ -234,7 +234,9 @@ static inline void mem_cgroup_dec_page_s
 	mem_cgroup_update_page_stat(page, idx, -1);
 }
 
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg);
+unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
+						gfp_t gfp_mask,
+						unsigned long *total_scanned);
 
 void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
@@ -434,9 +436,11 @@ static inline void mem_cgroup_dec_page_s
 }
 
 static inline
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg)
+unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
+					    gfp_t gfp_mask,
+					    unsigned long *total_scanned)
 {
-	return false;
+	return 0;
 }
 
 static inline void mem_cgroup_split_huge_fixup(struct page *head)
diff -puN mm/memcontrol.c~revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code mm/memcontrol.c
--- a/mm/memcontrol.c~revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code
+++ a/mm/memcontrol.c
@@ -1991,28 +1991,57 @@ static bool mem_cgroup_reclaimable(struc
 }
 #endif
 
-/*
- * A group is eligible for the soft limit reclaim if
- * 	a) it is over its soft limit
- *	b) any parent up the hierarchy is over its soft limit
- */
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg)
+static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
+				   struct zone *zone,
+				   gfp_t gfp_mask,
+				   unsigned long *total_scanned)
 {
-	struct mem_cgroup *parent = memcg;
-
-	if (res_counter_soft_limit_excess(&memcg->res))
-		return true;
-
-	/*
-	 * If any parent up the hierarchy is over its soft limit then we
-	 * have to obey and reclaim from this group as well.
-	 */
-	while ((parent = parent_mem_cgroup(parent))) {
-		if (res_counter_soft_limit_excess(&parent->res))
-			return true;
-	}
-
-	return false;
+	struct mem_cgroup *victim = NULL;
+	int total = 0;
+	int loop = 0;
+	unsigned long excess;
+	unsigned long nr_scanned;
+	struct mem_cgroup_reclaim_cookie reclaim = {
+		.zone = zone,
+		.priority = 0,
+	};
+
+	excess = res_counter_soft_limit_excess(&root_memcg->res) >> PAGE_SHIFT;
+
+	while (1) {
+		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
+		if (!victim) {
+			loop++;
+			if (loop >= 2) {
+				/*
+				 * If we have not been able to reclaim
+				 * anything, it might because there are
+				 * no reclaimable pages under this hierarchy
+				 */
+				if (!total)
+					break;
+				/*
+				 * We want to do more targeted reclaim.
+				 * excess >> 2 is not to excessive so as to
+				 * reclaim too much, nor too less that we keep
+				 * coming back to reclaim from this cgroup
+				 */
+				if (total >= (excess >> 2) ||
+					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
+					break;
+			}
+			continue;
+		}
+		if (!mem_cgroup_reclaimable(victim, false))
+			continue;
+		total += mem_cgroup_shrink_node_zone(victim, gfp_mask, false,
+						     zone, &nr_scanned);
+		*total_scanned += nr_scanned;
+		if (!res_counter_soft_limit_excess(&root_memcg->res))
+			break;
+ 	}
+	mem_cgroup_iter_break(root_memcg, victim);
+	return total;
 }
 
 static DEFINE_SPINLOCK(memcg_oom_lock);
@@ -4761,6 +4790,98 @@ static int mem_cgroup_resize_memsw_limit
 	return ret;
 }
 
+unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
+					    gfp_t gfp_mask,
+					    unsigned long *total_scanned)
+{
+	unsigned long nr_reclaimed = 0;
+	struct mem_cgroup_per_zone *mz, *next_mz = NULL;
+	unsigned long reclaimed;
+	int loop = 0;
+	struct mem_cgroup_tree_per_zone *mctz;
+	unsigned long long excess;
+	unsigned long nr_scanned;
+
+	if (order > 0)
+		return 0;
+
+	mctz = soft_limit_tree_node_zone(zone_to_nid(zone), zone_idx(zone));
+	/*
+	 * This loop can run a while, specially if mem_cgroup's continuously
+	 * keep exceeding their soft limit and putting the system under
+	 * pressure
+	 */
+	do {
+		if (next_mz)
+			mz = next_mz;
+		else
+			mz = mem_cgroup_largest_soft_limit_node(mctz);
+		if (!mz)
+			break;
+
+		nr_scanned = 0;
+		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, zone,
+						    gfp_mask, &nr_scanned);
+		nr_reclaimed += reclaimed;
+		*total_scanned += nr_scanned;
+		spin_lock(&mctz->lock);
+
+		/*
+		 * If we failed to reclaim anything from this memory cgroup
+		 * it is time to move on to the next cgroup
+		 */
+		next_mz = NULL;
+		if (!reclaimed) {
+			do {
+				/*
+				 * Loop until we find yet another one.
+				 *
+				 * By the time we get the soft_limit lock
+				 * again, someone might have aded the
+				 * group back on the RB tree. Iterate to
+				 * make sure we get a different mem.
+				 * mem_cgroup_largest_soft_limit_node returns
+				 * NULL if no other cgroup is present on
+				 * the tree
+				 */
+				next_mz =
+				__mem_cgroup_largest_soft_limit_node(mctz);
+				if (next_mz == mz)
+					css_put(&next_mz->memcg->css);
+				else /* next_mz == NULL or other memcg */
+					break;
+			} while (1);
+		}
+		__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
+		excess = res_counter_soft_limit_excess(&mz->memcg->res);
+		/*
+		 * One school of thought says that we should not add
+		 * back the node to the tree if reclaim returns 0.
+		 * But our reclaim could return 0, simply because due
+		 * to priority we are exposing a smaller subset of
+		 * memory to reclaim from. Consider this as a longer
+		 * term TODO.
+		 */
+		/* If excess == 0, no tree ops */
+		__mem_cgroup_insert_exceeded(mz->memcg, mz, mctz, excess);
+		spin_unlock(&mctz->lock);
+		css_put(&mz->memcg->css);
+		loop++;
+		/*
+		 * Could not reclaim anything and there are no more
+		 * mem cgroups to try or we seem to be looping without
+		 * reclaiming anything.
+		 */
+		if (!nr_reclaimed &&
+			(next_mz == NULL ||
+			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
+			break;
+	} while (!nr_reclaimed);
+	if (next_mz)
+		css_put(&next_mz->memcg->css);
+	return nr_reclaimed;
+}
+
 /**
  * mem_cgroup_force_empty_list - clears LRU of a group
  * @memcg: group to clear
diff -puN mm/vmscan.c~revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code mm/vmscan.c
--- a/mm/vmscan.c~revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code
+++ a/mm/vmscan.c
@@ -139,21 +139,11 @@ static bool global_reclaim(struct scan_c
 {
 	return !sc->target_mem_cgroup;
 }
-
-static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
-{
-	return !mem_cgroup_disabled() && global_reclaim(sc);
-}
 #else
 static bool global_reclaim(struct scan_control *sc)
 {
 	return true;
 }
-
-static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
-{
-	return false;
-}
 #endif
 
 unsigned long zone_reclaimable_pages(struct zone *zone)
@@ -2174,8 +2164,7 @@ static inline bool should_continue_recla
 	}
 }
 
-static void
-__shrink_zone(struct zone *zone, struct scan_control *sc, bool soft_reclaim)
+static void shrink_zone(struct zone *zone, struct scan_control *sc)
 {
 	unsigned long nr_reclaimed, nr_scanned;
 
@@ -2194,12 +2183,6 @@ __shrink_zone(struct zone *zone, struct
 		do {
 			struct lruvec *lruvec;
 
-			if (soft_reclaim &&
-			    !mem_cgroup_soft_reclaim_eligible(memcg)) {
-				memcg = mem_cgroup_iter(root, memcg, &reclaim);
-				continue;
-			}
-
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 			shrink_lruvec(lruvec, sc);
@@ -2230,24 +2213,6 @@ __shrink_zone(struct zone *zone, struct
 					 sc->nr_scanned - nr_scanned, sc));
 }
 
-
-static void shrink_zone(struct zone *zone, struct scan_control *sc)
-{
-	bool do_soft_reclaim = mem_cgroup_should_soft_reclaim(sc);
-	unsigned long nr_scanned = sc->nr_scanned;
-
-	__shrink_zone(zone, sc, do_soft_reclaim);
-
-	/*
-	 * No group is over the soft limit or those that are do not have
-	 * pages in the zone we are reclaiming so we have to reclaim everybody
-	 */
-	if (do_soft_reclaim && (sc->nr_scanned == nr_scanned)) {
-		__shrink_zone(zone, sc, false);
-		return;
-	}
-}
-
 /* Returns true if compaction should go ahead for a high-order request */
 static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 {
@@ -2309,6 +2274,8 @@ static bool shrink_zones(struct zonelist
 {
 	struct zoneref *z;
 	struct zone *zone;
+	unsigned long nr_soft_reclaimed;
+	unsigned long nr_soft_scanned;
 	bool aborted_reclaim = false;
 
 	/*
@@ -2348,6 +2315,18 @@ static bool shrink_zones(struct zonelist
 					continue;
 				}
 			}
+			/*
+			 * This steals pages from memory cgroups over softlimit
+			 * and returns the number of reclaimed pages and
+			 * scanned pages. This works for global memory pressure
+			 * and balancing, not for a memcg's limit.
+			 */
+			nr_soft_scanned = 0;
+			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
+						sc->order, sc->gfp_mask,
+						&nr_soft_scanned);
+			sc->nr_reclaimed += nr_soft_reclaimed;
+			sc->nr_scanned += nr_soft_scanned;
 			/* need some check for avoid more shrink_zone() */
 		}
 
@@ -2941,6 +2920,8 @@ static unsigned long balance_pgdat(pg_da
 {
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
+	unsigned long nr_soft_reclaimed;
+	unsigned long nr_soft_scanned;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.priority = DEF_PRIORITY,
@@ -3055,6 +3036,15 @@ static unsigned long balance_pgdat(pg_da
 
 			sc.nr_scanned = 0;
 
+			nr_soft_scanned = 0;
+			/*
+			 * Call soft limit reclaim before calling shrink_zone.
+			 */
+			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
+							order, sc.gfp_mask,
+							&nr_soft_scanned);
+			sc.nr_reclaimed += nr_soft_reclaimed;
+
 			/*
 			 * There should be no need to raise the scanning
 			 * priority if enough pages are already being scanned
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

