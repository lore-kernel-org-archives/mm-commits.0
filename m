From: akpm@linux-foundation.org
Subject: - mm-test-and-set-zone-reclaim-lock-before-starting.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:11 -0700
Message-ID: <200710180652.l9I6qBqW030270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761341AbXJRHpT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:45:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andrea@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm: test and set zone reclaim lock before starting reclaim
has been removed from the -mm tree.  Its filename was
     mm-test-and-set-zone-reclaim-lock-before-starting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: test and set zone reclaim lock before starting reclaim
From: David Rientjes <rientjes@google.com>

Introduces new zone flag interface for testing and setting flags:

	int zone_test_and_set_flag(struct zone *zone, zone_flags_t flag)

Instead of setting and clearing ZONE_RECLAIM_LOCKED each time shrink_zone() is
called, this flag is test and set before starting zone reclaim.  Zone reclaim
starts in __alloc_pages() when a zone's watermark fails and the system is in
zone_reclaim_mode.  If it's already in reclaim, there's no need to start again
so it is simply considered full for that allocation attempt.

There is a change of behavior with regard to concurrent zone shrinking.  It is
now possible for try_to_free_pages() or kswapd to already be shrinking a
particular zone when __alloc_pages() starts zone reclaim.  In this case, it is
possible for two concurrent threads to invoke shrink_zone() for a single zone.

This change forbids a zone to be in zone reclaim twice, which was always the
behavior, but allows for concurrent try_to_free_pages() or kswapd shrinking
when starting zone reclaim.

Cc: Andrea Arcangeli <andrea@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 ++++++++
 mm/vmscan.c            |   23 +++++++++++++----------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-test-and-set-zone-reclaim-lock-before-starting include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-test-and-set-zone-reclaim-lock-before-starting
+++ a/include/linux/mmzone.h
@@ -351,6 +351,12 @@ static inline void zone_set_flag(struct 
 {
 	set_bit(flag, &zone->flags);
 }
+
+static inline int zone_test_and_set_flag(struct zone *zone, zone_flags_t flag)
+{
+	return test_and_set_bit(flag, &zone->flags);
+}
+
 static inline void zone_clear_flag(struct zone *zone, zone_flags_t flag)
 {
 	clear_bit(flag, &zone->flags);
@@ -360,10 +366,12 @@ static inline int zone_is_all_unreclaima
 {
 	return test_bit(ZONE_ALL_UNRECLAIMABLE, &zone->flags);
 }
+
 static inline int zone_is_reclaim_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
 }
+
 static inline int zone_is_oom_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
diff -puN mm/vmscan.c~mm-test-and-set-zone-reclaim-lock-before-starting mm/vmscan.c
--- a/mm/vmscan.c~mm-test-and-set-zone-reclaim-lock-before-starting
+++ a/mm/vmscan.c
@@ -1108,8 +1108,6 @@ static unsigned long shrink_zone(int pri
 	unsigned long nr_to_scan;
 	unsigned long nr_reclaimed = 0;
 
-	zone_set_flag(zone, ZONE_RECLAIM_LOCKED);
-
 	/*
 	 * Add one to `nr_to_scan' just to make sure that the kernel will
 	 * slowly sift through the active list.
@@ -1148,8 +1146,6 @@ static unsigned long shrink_zone(int pri
 	}
 
 	throttle_vm_writeout(sc->gfp_mask);
-
-	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 	return nr_reclaimed;
 }
 
@@ -1900,6 +1896,7 @@ static int __zone_reclaim(struct zone *z
 int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 {
 	int node_id;
+	int ret;
 
 	/*
 	 * Zone reclaim reclaims unmapped file backed pages and
@@ -1917,13 +1914,13 @@ int zone_reclaim(struct zone *zone, gfp_
 			<= zone->min_slab_pages)
 		return 0;
 
+	if (zone_is_all_unreclaimable(zone))
+		return 0;
+
 	/*
-	 * Avoid concurrent zone reclaims, do not reclaim in a zone that does
-	 * not have reclaimable pages and if we should not delay the allocation
-	 * then do not scan.
+	 * Do not scan if the allocation should not be delayed.
 	 */
-	if (!(gfp_mask & __GFP_WAIT) || zone_is_all_unreclaimable(zone) ||
-		zone_is_reclaim_locked(zone) || (current->flags & PF_MEMALLOC))
+	if (!(gfp_mask & __GFP_WAIT) || (current->flags & PF_MEMALLOC))
 			return 0;
 
 	/*
@@ -1935,6 +1932,12 @@ int zone_reclaim(struct zone *zone, gfp_
 	node_id = zone_to_nid(zone);
 	if (node_state(node_id, N_CPU) && node_id != numa_node_id())
 		return 0;
-	return __zone_reclaim(zone, gfp_mask, order);
+
+	if (zone_test_and_set_flag(zone, ZONE_RECLAIM_LOCKED))
+		return 0;
+	ret = __zone_reclaim(zone, gfp_mask, order);
+	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
+
+	return ret;
 }
 #endif
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
