From: akpm@linux-foundation.org
Subject: + mm-test-and-set-zone-reclaim-lock-before-starting.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:15:52 -0700
Message-ID: <200709262015.l8QKFqTm001911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbXIZUQD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:16:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     mm: test and set zone reclaim lock before starting reclaim
has been added to the -mm tree.  Its filename is
     mm-test-and-set-zone-reclaim-lock-before-starting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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


diff -puN include/linux/mmzone.h~mm-test-and-set-zone-reclaim-lock-before-starting include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-test-and-set-zone-reclaim-lock-before-starting
+++ a/include/linux/mmzone.h
@@ -353,6 +353,10 @@ static inline void zone_set_flag(struct 
 {
 	set_bit(flag, &zone->flags);
 }
+static inline int zone_test_and_set_flag(struct zone *zone, zone_flags_t flag)
+{
+	return test_and_set_bit(flag, &zone->flags);
+}
 static inline void zone_clear_flag(struct zone *zone, zone_flags_t flag)
 {
 	clear_bit(flag, &zone->flags);
diff -puN mm/vmscan.c~mm-test-and-set-zone-reclaim-lock-before-starting mm/vmscan.c
--- a/mm/vmscan.c~mm-test-and-set-zone-reclaim-lock-before-starting
+++ a/mm/vmscan.c
@@ -1112,8 +1112,6 @@ static unsigned long shrink_zone(int pri
 	unsigned long nr_to_scan;
 	unsigned long nr_reclaimed = 0;
 
-	zone_set_flag(zone, ZONE_RECLAIM_LOCKED);
-
 	/*
 	 * Add one to `nr_to_scan' just to make sure that the kernel will
 	 * slowly sift through the active list.
@@ -1152,8 +1150,6 @@ static unsigned long shrink_zone(int pri
 	}
 
 	throttle_vm_writeout(sc->gfp_mask);
-
-	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 	return nr_reclaimed;
 }
 
@@ -1932,6 +1928,7 @@ static int __zone_reclaim(struct zone *z
 int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 {
 	int node_id;
+	int ret;
 
 	/*
 	 * Zone reclaim reclaims unmapped file backed pages and
@@ -1949,13 +1946,13 @@ int zone_reclaim(struct zone *zone, gfp_
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
@@ -1967,6 +1964,12 @@ int zone_reclaim(struct zone *zone, gfp_
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

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-prototypes-to-appropriate-header-file-fix.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
oom-prevent-including-schedh-in-header-file.patch
oom-add-header-file-to-kbuild-as-unifdef.patch
oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
mm-test-and-set-zone-reclaim-lock-before-starting.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
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
