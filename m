From: akpm@linux-foundation.org
Subject: +
 vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch added to -mm tree
Date: Fri, 02 May 2014 13:40:19 -0700
Message-ID: <536402b3.IWix+bTfX5tXz3r0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaEBUkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 16:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz

Subject: + vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch added to -mm tree
To: mhocko@suse.cz,hannes@cmpxchg.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 13:40:19 -0700


The patch titled
     Subject: vmscan: memcg: always use swappiness of the reclaimed memcg
has been added to the -mm tree.  Its filename is
     vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch

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
Subject: vmscan: memcg: always use swappiness of the reclaimed memcg

Memory reclaim always uses swappiness of the reclaim target memcg (origin
of the memory pressure) or vm_swappiness for global memory reclaim.  This
behavior was consistent (except for difference between global and hard
limit reclaim) because swappiness was enforced to be consistent within
each memcg hierarchy.

After "mm: memcontrol: remove hierarchy restrictions for swappiness and
oom_control" each memcg can have its own swappiness independent of
hierarchical parents, though, so the consistency guarantee is gone.  This
can lead to an unexpected behavior.  Say that a group is explicitly
configured to not swapout by memory.swappiness=0 but its memory gets
swapped out anyway when the memory pressure comes from its parent with a
It is also unexpected that the knob is meaningless without setting the
hard limit which would trigger the reclaim and enforce the swappiness. 
There are setups where the hard limit is configured higher in the
hierarchy by an administrator and children groups are under control of
somebody else who is interested in the swapout behavior but not
necessarily about the memory limit.

From a semantic point of view swappiness is an attribute defining anon vs.
 file proportional scanning of LRU which is memcg specific (unlike charges
which are propagated up the hierarchy) so it should be applied to the
particular memcg's LRU regardless where the memory pressure comes from.

This patch removes vmscan_swappiness() and stores the swappiness into the
scan_control structure.  mem_cgroup_swappiness is then used to provide the
correct value before shrink_lruvec is called.  The global vm_swappiness is
used for the root memcg.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   13 ++++++-------
 mm/vmscan.c                      |   18 ++++++++----------
 2 files changed, 14 insertions(+), 17 deletions(-)

diff -puN Documentation/cgroups/memory.txt~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control
+++ a/Documentation/cgroups/memory.txt
@@ -552,14 +552,13 @@ Note:
 
 5.3 swappiness
 
-Similar to /proc/sys/vm/swappiness, but only affecting reclaim that is
-triggered by this cgroup's hard limit.  The tunable in the root cgroup
-corresponds to the global swappiness setting.
+Overrides /proc/sys/vm/swappiness for the particular group. The tunable
+in the root cgroup corresponds to the global swappiness setting.
 
-Please note that unlike the global swappiness, memcg knob set to 0
-really prevents from any swapping even if there is a swap storage
-available. This might lead to memcg OOM killer if there are no file
-pages to reclaim.
+Please note that unlike during the global reclaim, limit reclaim
+enforces that 0 swappiness really prevents from any swapping even if
+there is a swap storage available. This might lead to memcg OOM killer
+if there are no file pages to reclaim.
 
 5.4 failcnt
 
diff -puN mm/vmscan.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control mm/vmscan.c
--- a/mm/vmscan.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control
+++ a/mm/vmscan.c
@@ -86,6 +86,9 @@ struct scan_control {
 	/* Scan (total_size >> priority) pages at once */
 	int priority;
 
+	/* anon vs. file LRUs scanning "ratio" */
+	int swappiness;
+
 	/*
 	 * The memory cgroup that hit its limit and as a result is the
 	 * primary target of this reclaim invocation.
@@ -1848,13 +1851,6 @@ static unsigned long shrink_list(enum lr
 	return shrink_inactive_list(nr_to_scan, lruvec, sc, lru);
 }
 
-static int vmscan_swappiness(struct scan_control *sc)
-{
-	if (global_reclaim(sc))
-		return vm_swappiness;
-	return mem_cgroup_swappiness(sc->target_mem_cgroup);
-}
-
 enum scan_balance {
 	SCAN_EQUAL,
 	SCAN_FRACT,
@@ -1915,7 +1911,7 @@ static void get_scan_count(struct lruvec
 	 * using the memory controller's swap limit feature would be
 	 * too expensive.
 	 */
-	if (!global_reclaim(sc) && !vmscan_swappiness(sc)) {
+	if (!global_reclaim(sc) && !sc->swappiness) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -1925,7 +1921,7 @@ static void get_scan_count(struct lruvec
 	 * system is close to OOM, scan both anon and file equally
 	 * (unless the swappiness setting disagrees with swapping).
 	 */
-	if (!sc->priority && vmscan_swappiness(sc)) {
+	if (!sc->priority && sc->swappiness) {
 		scan_balance = SCAN_EQUAL;
 		goto out;
 	}
@@ -1968,7 +1964,7 @@ static void get_scan_count(struct lruvec
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = vmscan_swappiness(sc);
+	anon_prio = sc->swappiness;
 	file_prio = 200 - anon_prio;
 
 	/*
@@ -2272,6 +2268,7 @@ static unsigned __shrink_zone(struct zon
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 			nr_scanned_groups++;
 
+			sc->swappiness = mem_cgroup_swappiness(memcg);
 			shrink_lruvec(lruvec, sc);
 
 			/*
@@ -2753,6 +2750,7 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_swap = !noswap,
 		.order = 0,
 		.priority = 0,
+		.swappiness = mem_cgroup_swappiness(memcg),
 		.target_mem_cgroup = memcg,
 	};
 	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
_

Patches currently in -mm which might be from mhocko@suse.cz are

slub-fix-memcg_propagate_slab_attrs.patch
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
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch

