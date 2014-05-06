From: akpm@linux-foundation.org
Subject: + memcg-mm-introduce-lowlimit-reclaim-fix.patch added to -mm tree
Date: Tue, 06 May 2014 13:11:35 -0700
Message-ID: <536941f7.1LQci3OUykAxk1Xb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaEFULg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 16:11:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz

Subject: + memcg-mm-introduce-lowlimit-reclaim-fix.patch added to -mm tree
To: mhocko@suse.cz,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 13:11:35 -0700


The patch titled
     Subject: memcg-mm-introduce-lowlimit-reclaim-fix
has been added to the -mm tree.  Its filename is
     memcg-mm-introduce-lowlimit-reclaim-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-mm-introduce-lowlimit-reclaim-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-mm-introduce-lowlimit-reclaim-fix.patch

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
Subject: memcg-mm-introduce-lowlimit-reclaim-fix

mem_cgroup_reclaim_eligible -> mem_cgroup_within_guarantee
follow_low_limit -> honor_memcg_guarantee
and as suggested by Johannes.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +++---
 mm/memcontrol.c            |   15 ++++++++-------
 mm/vmscan.c                |   25 ++++++++++++++++---------
 3 files changed, 27 insertions(+), 19 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-mm-introduce-lowlimit-reclaim-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-mm-introduce-lowlimit-reclaim-fix
+++ a/include/linux/memcontrol.h
@@ -92,7 +92,7 @@ bool __mem_cgroup_same_or_subtree(const
 bool task_in_mem_cgroup(struct task_struct *task,
 			const struct mem_cgroup *memcg);
 
-extern bool mem_cgroup_reclaim_eligible(struct mem_cgroup *memcg,
+extern bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 		struct mem_cgroup *root);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
@@ -291,10 +291,10 @@ static inline struct lruvec *mem_cgroup_
 	return &zone->lruvec;
 }
 
-static inline bool mem_cgroup_reclaim_eligible(struct mem_cgroup *memcg,
+static inline bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
-	return true;
+	return false;
 }
 
 static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
diff -puN mm/memcontrol.c~memcg-mm-introduce-lowlimit-reclaim-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mm-introduce-lowlimit-reclaim-fix
+++ a/mm/memcontrol.c
@@ -2802,26 +2802,27 @@ static struct mem_cgroup *mem_cgroup_loo
 }
 
 /**
- * mem_cgroup_reclaim_eligible - checks whether given memcg is eligible for the
- * reclaim
+ * mem_cgroup_within_guarantee - checks whether given memcg is within its
+ * memory guarantee
  * @memcg: target memcg for the reclaim
  * @root: root of the reclaim hierarchy (null for the global reclaim)
  *
- * The given group is reclaimable if it is above its low limit and the same
- * applies for all parents up the hierarchy until root (including).
+ * The given group is within its reclaim gurantee if it is below its low limit
+ * or the same applies for any parent up the hierarchy until root (including).
+ * Such a group might be excluded from the reclaim.
  */
-bool mem_cgroup_reclaim_eligible(struct mem_cgroup *memcg,
+bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
 	do {
 		if (!res_counter_low_limit_excess(&memcg->res))
-			return false;
+			return true;
 		if (memcg == root)
 			break;
 
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
-	return true;
+	return false;
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
diff -puN mm/vmscan.c~memcg-mm-introduce-lowlimit-reclaim-fix mm/vmscan.c
--- a/mm/vmscan.c~memcg-mm-introduce-lowlimit-reclaim-fix
+++ a/mm/vmscan.c
@@ -2233,8 +2233,18 @@ static inline bool should_continue_recla
 	}
 }
 
+/**
+ * __shrink_zone - shrinks a given zone
+ *
+ * @zone: zone to shrink
+ * @sc: scan control with additional reclaim parameters
+ * @honor_memcg_guarantee: do not reclaim memcgs which are within their memory
+ * guarantee
+ *
+ * Returns the number of reclaimed memcgs.
+ */
 static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
-		bool follow_low_limit)
+		bool honor_memcg_guarantee)
 {
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned nr_scanned_groups = 0;
@@ -2254,12 +2264,9 @@ static unsigned __shrink_zone(struct zon
 		do {
 			struct lruvec *lruvec;
 
-			/*
-			 * Memcg might be under its low limit so we have to
-			 * skip it during the first reclaim round
-			 */
-			if (follow_low_limit &&
-					!mem_cgroup_reclaim_eligible(memcg, root)) {
+			/* Memcg might be protected from the reclaim */
+			if (honor_memcg_guarantee &&
+					mem_cgroup_within_guarantee(memcg, root)) {
 				/*
 				 * It would be more optimal to skip the memcg
 				 * subtree now but we do not have a memcg iter
@@ -2307,8 +2314,8 @@ static void shrink_zone(struct zone *zon
 	if (!__shrink_zone(zone, sc, true)) {
 		/*
 		 * First round of reclaim didn't find anything to reclaim
-		 * because of low limit protection so try again and ignore
-		 * the low limit this time.
+		 * because of the memory guantees for all memcgs in the
+		 * reclaim target so try again and ignore guarantees this time.
 		 */
 		__shrink_zone(zone, sc, false);
 	}
_

Patches currently in -mm which might be from mhocko@suse.cz are

slub-fix-memcg_propagate_slab_attrs.patch
mmwriteback-fix-divide-by-zero-in-pos_ratio_polynom.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
linux-next.patch

