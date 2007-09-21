From: akpm@linux-foundation.org
Subject: + oom-change-all_unreclaimable-zone-member-to-flags.patch added to -mm tree
Date: Fri, 21 Sep 2007 02:10:59 -0700
Message-ID: <200709210910.l8L9AxJs028192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592AbXIUJLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 05:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     oom: change all_unreclaimable zone member to flags
has been added to the -mm tree.  Its filename is
     oom-change-all_unreclaimable-zone-member-to-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: change all_unreclaimable zone member to flags
From: David Rientjes <rientjes@google.com>

Convert the int all_unreclaimable member of struct zone to unsigned long
flags.  This can now be used to specify several different zone flags such as
all_unreclaimable and reclaim_in_progress, which can now be removed and
converted to a per-zone flag.

Flags are set and cleared as follows:

	zone_set_flag(struct zone *zone, zone_flags_t flag)
	zone_clear_flag(struct zone *zone, zone_flags_t flag)

Defines the first zone flags, ZONE_ALL_UNRECLAIMABLE and ZONE_RECLAIM_LOCKED,
which have the same semantics as the old zone->all_unreclaimable and
zone->reclaim_in_progress, respectively.  Also converts all current users that
set or clear either flag to use the new interface.

Helper functions are defined to test the flags:

	int zone_is_all_unreclaimable(const struct zone *zone)
	int zone_is_reclaim_locked(const struct zone *zone)

All flag operators are of the atomic variety because there are currently
readers that are implemented that do not take zone->lock.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   28 ++++++++++++++++++++++++----
 mm/page_alloc.c        |    8 ++++----
 mm/vmscan.c            |   25 +++++++++++++------------
 mm/vmstat.c            |    2 +-
 4 files changed, 42 insertions(+), 21 deletions(-)

diff -puN include/linux/mmzone.h~oom-change-all_unreclaimable-zone-member-to-flags include/linux/mmzone.h
--- a/include/linux/mmzone.h~oom-change-all_unreclaimable-zone-member-to-flags
+++ a/include/linux/mmzone.h
@@ -264,10 +264,7 @@ struct zone {
 	unsigned long		nr_scan_active;
 	unsigned long		nr_scan_inactive;
 	unsigned long		pages_scanned;	   /* since last reclaim */
-	int			all_unreclaimable; /* All pages pinned */
-
-	/* A count of how many reclaimers are scanning this zone */
-	atomic_t		reclaim_in_progress;
+	unsigned long		flags;		   /* zone flags, see below */
 
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
@@ -345,6 +342,29 @@ struct zone {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
+typedef enum {
+	ZONE_ALL_UNRECLAIMABLE,		/* all pages pinned */
+	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
+} zone_flags_t;
+
+static inline void zone_set_flag(struct zone *zone, zone_flags_t flag)
+{
+	set_bit(flag, &zone->flags);
+}
+static inline void zone_clear_flag(struct zone *zone, zone_flags_t flag)
+{
+	clear_bit(flag, &zone->flags);
+}
+
+static inline int zone_is_all_unreclaimable(const struct zone *zone)
+{
+	return test_bit(ZONE_ALL_UNRECLAIMABLE, &zone->flags);
+}
+static inline int zone_is_reclaim_locked(const struct zone *zone)
+{
+	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
+}
+
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
  * go. A value of 12 for DEF_PRIORITY implies that we will scan 1/4096th of the
diff -puN mm/page_alloc.c~oom-change-all_unreclaimable-zone-member-to-flags mm/page_alloc.c
--- a/mm/page_alloc.c~oom-change-all_unreclaimable-zone-member-to-flags
+++ a/mm/page_alloc.c
@@ -490,7 +490,7 @@ static void free_pages_bulk(struct zone 
 					struct list_head *list, int order)
 {
 	spin_lock(&zone->lock);
-	zone->all_unreclaimable = 0;
+	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 	while (count--) {
 		struct page *page;
@@ -507,7 +507,7 @@ static void free_pages_bulk(struct zone 
 static void free_one_page(struct zone *zone, struct page *page, int order)
 {
 	spin_lock(&zone->lock);
-	zone->all_unreclaimable = 0;
+	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 	__free_one_page(page, zone, order);
 	spin_unlock(&zone->lock);
@@ -1872,7 +1872,7 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_INACTIVE)),
 			K(zone->present_pages),
 			zone->pages_scanned,
-			(zone->all_unreclaimable ? "yes" : "no")
+			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
 			);
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
@@ -3394,7 +3394,7 @@ static void __meminit free_area_init_cor
 		zone->nr_scan_active = 0;
 		zone->nr_scan_inactive = 0;
 		zap_zone_vm_stats(zone);
-		atomic_set(&zone->reclaim_in_progress, 0);
+		zone->flags = 0;
 		if (!size)
 			continue;
 
diff -puN mm/vmscan.c~oom-change-all_unreclaimable-zone-member-to-flags mm/vmscan.c
--- a/mm/vmscan.c~oom-change-all_unreclaimable-zone-member-to-flags
+++ a/mm/vmscan.c
@@ -1112,7 +1112,7 @@ static unsigned long shrink_zone(int pri
 	unsigned long nr_to_scan;
 	unsigned long nr_reclaimed = 0;
 
-	atomic_inc(&zone->reclaim_in_progress);
+	zone_set_flag(zone, ZONE_RECLAIM_LOCKED);
 
 	/*
 	 * Add one to `nr_to_scan' just to make sure that the kernel will
@@ -1153,7 +1153,7 @@ static unsigned long shrink_zone(int pri
 
 	throttle_vm_writeout(sc->gfp_mask);
 
-	atomic_dec(&zone->reclaim_in_progress);
+	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 	return nr_reclaimed;
 }
 
@@ -1191,7 +1191,7 @@ static unsigned long shrink_zones(int pr
 
 		note_zone_scanning_priority(zone, priority);
 
-		if (zone->all_unreclaimable && priority != DEF_PRIORITY)
+		if (zone_is_all_unreclaimable(zone) && priority != DEF_PRIORITY)
 			continue;	/* Let kswapd poll it */
 
 		sc->all_unreclaimable = 0;
@@ -1372,7 +1372,8 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
+			if (zone_is_all_unreclaimable(zone) &&
+			    priority != DEF_PRIORITY)
 				continue;
 
 			if (!zone_watermark_ok(zone, order, zone->pages_high,
@@ -1407,7 +1408,8 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
+			if (zone_is_all_unreclaimable(zone) &&
+					priority != DEF_PRIORITY)
 				continue;
 
 			if (!zone_watermark_ok(zone, order, zone->pages_high,
@@ -1428,12 +1430,13 @@ loop_again:
 						lru_pages);
 			nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
-			if (zone->all_unreclaimable)
+			if (zone_is_all_unreclaimable(zone))
 				continue;
 			if (nr_slab == 0 && zone->pages_scanned >=
 				(zone_page_state(zone, NR_ACTIVE)
 				+ zone_page_state(zone, NR_INACTIVE)) * 6)
-					zone->all_unreclaimable = 1;
+					zone_set_flag(zone,
+						      ZONE_ALL_UNRECLAIMABLE);
 			/*
 			 * If we've done a decent amount of scanning and
 			 * the reclaim ratio is low, start doing writepage
@@ -1627,7 +1630,7 @@ static unsigned long shrink_all_zones(un
 		if (!populated_zone(zone))
 			continue;
 
-		if (zone->all_unreclaimable && prio != DEF_PRIORITY)
+		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
 			continue;
 
 		/* For pass = 0 we don't shrink the active list */
@@ -1951,10 +1954,8 @@ int zone_reclaim(struct zone *zone, gfp_
 	 * not have reclaimable pages and if we should not delay the allocation
 	 * then do not scan.
 	 */
-	if (!(gfp_mask & __GFP_WAIT) ||
-		zone->all_unreclaimable ||
-		atomic_read(&zone->reclaim_in_progress) > 0 ||
-		(current->flags & PF_MEMALLOC))
+	if (!(gfp_mask & __GFP_WAIT) || zone_is_all_unreclaimable(zone) ||
+		zone_is_reclaim_locked(zone) || (current->flags & PF_MEMALLOC))
 			return 0;
 
 	/*
diff -puN mm/vmstat.c~oom-change-all_unreclaimable-zone-member-to-flags mm/vmstat.c
--- a/mm/vmstat.c~oom-change-all_unreclaimable-zone-member-to-flags
+++ a/mm/vmstat.c
@@ -704,7 +704,7 @@ static void zoneinfo_show_print(struct s
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
 		   "\n  start_pfn:         %lu",
-		   zone->all_unreclaimable,
+			   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
 		   zone->zone_start_pfn);
 	seq_putc(m, '\n');
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
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
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
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
