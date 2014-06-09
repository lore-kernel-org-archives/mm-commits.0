From: akpm@linux-foundation.org
Subject: [merged]
 vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:40:21 -0700
Message-ID: <53960da5.hWxM7J4CfrltTqVY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaFITkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, hughd@google.com, hannes@cmpxchg.org, mhocko@suse.cz

Subject: [merged] vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch removed from -mm tree
To: mhocko@suse.cz,hannes@cmpxchg.org,hughd@google.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:40:21 -0700


The patch titled
     Subject: vmscan: memcg: always use swappiness of the reclaimed memcg
has been removed from the -mm tree.  Its filename was
     vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[hughd@google.com: oopses immediately when booted with cgroup_disable=memory]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   13 ++++++-------
 mm/memcontrol.c                  |    2 +-
 mm/vmscan.c                      |   18 ++++++++----------
 3 files changed, 15 insertions(+), 18 deletions(-)

diff -puN Documentation/cgroups/memory.txt~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control
+++ a/Documentation/cgroups/memory.txt
@@ -540,14 +540,13 @@ Note:
 
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
 
diff -puN mm/memcontrol.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control
+++ a/mm/memcontrol.c
@@ -1550,7 +1550,7 @@ static unsigned long mem_cgroup_margin(s
 int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	/* root ? */
-	if (!css_parent(&memcg->css))
+	if (mem_cgroup_disabled() || !css_parent(&memcg->css))
 		return vm_swappiness;
 
 	return memcg->swappiness;
diff -puN mm/vmscan.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control mm/vmscan.c
--- a/mm/vmscan.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control
+++ a/mm/vmscan.c
@@ -83,6 +83,9 @@ struct scan_control {
 	/* Scan (total_size >> priority) pages at once */
 	int priority;
 
+	/* anon vs. file LRUs scanning "ratio" */
+	int swappiness;
+
 	/*
 	 * The memory cgroup that hit its limit and as a result is the
 	 * primary target of this reclaim invocation.
@@ -1845,13 +1848,6 @@ static unsigned long shrink_list(enum lr
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
@@ -1912,7 +1908,7 @@ static void get_scan_count(struct lruvec
 	 * using the memory controller's swap limit feature would be
 	 * too expensive.
 	 */
-	if (!global_reclaim(sc) && !vmscan_swappiness(sc)) {
+	if (!global_reclaim(sc) && !sc->swappiness) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -1922,7 +1918,7 @@ static void get_scan_count(struct lruvec
 	 * system is close to OOM, scan both anon and file equally
 	 * (unless the swappiness setting disagrees with swapping).
 	 */
-	if (!sc->priority && vmscan_swappiness(sc)) {
+	if (!sc->priority && sc->swappiness) {
 		scan_balance = SCAN_EQUAL;
 		goto out;
 	}
@@ -1965,7 +1961,7 @@ static void get_scan_count(struct lruvec
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = vmscan_swappiness(sc);
+	anon_prio = sc->swappiness;
 	file_prio = 200 - anon_prio;
 
 	/*
@@ -2265,6 +2261,7 @@ static void shrink_zone(struct zone *zon
 
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
+			sc->swappiness = mem_cgroup_swappiness(memcg);
 			shrink_lruvec(lruvec, sc);
 
 			/*
@@ -2731,6 +2728,7 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_swap = !noswap,
 		.order = 0,
 		.priority = 0,
+		.swappiness = mem_cgroup_swappiness(memcg),
 		.target_mem_cgroup = memcg,
 	};
 	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
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
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch

