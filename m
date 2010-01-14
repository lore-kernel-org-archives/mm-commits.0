From: akpm@linux-foundation.org
Subject: + mm-restore-zone-all_unreclaimable-to-independence-word.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:21:52 -0800
Message-ID: <201001142321.o0ENLq2L005872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708Ab0ANXWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com, shijie8@gmail.com


The patch titled
     mm: restore zone->all_unreclaimable to independence word
has been added to the -mm tree.  Its filename is
     mm-restore-zone-all_unreclaimable-to-independence-word.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: restore zone->all_unreclaimable to independence word
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit e815af95 ("change all_unreclaimable zone member to flags") changed
all_unreclaimable member to bit flag.  But it had an undesireble side
effect.  free_one_page() is one of most hot path in linux kernel and
increasing atomic ops in it can reduce kernel performance a bit.

Thus, this patch revert such commit partially. at least
all_unreclaimable shouldn't share memory word with other zone flags.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 +------
 mm/page_alloc.c        |    6 +++---
 mm/vmscan.c            |   20 ++++++++------------
 mm/vmstat.c            |    2 +-
 4 files changed, 13 insertions(+), 22 deletions(-)

diff -puN include/linux/mmzone.h~mm-restore-zone-all_unreclaimable-to-independence-word include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-restore-zone-all_unreclaimable-to-independence-word
+++ a/include/linux/mmzone.h
@@ -333,6 +333,7 @@ struct zone {
 
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
+	int                     all_unreclaimable; /* All pages pinned */
 
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
@@ -417,7 +418,6 @@ struct zone {
 } ____cacheline_internodealigned_in_smp;
 
 typedef enum {
-	ZONE_ALL_UNRECLAIMABLE,		/* all pages pinned */
 	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
 	ZONE_OOM_LOCKED,		/* zone is in OOM killer zonelist */
 } zone_flags_t;
@@ -437,11 +437,6 @@ static inline void zone_clear_flag(struc
 	clear_bit(flag, &zone->flags);
 }
 
-static inline int zone_is_all_unreclaimable(const struct zone *zone)
-{
-	return test_bit(ZONE_ALL_UNRECLAIMABLE, &zone->flags);
-}
-
 static inline int zone_is_reclaim_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
diff -puN mm/page_alloc.c~mm-restore-zone-all_unreclaimable-to-independence-word mm/page_alloc.c
--- a/mm/page_alloc.c~mm-restore-zone-all_unreclaimable-to-independence-word
+++ a/mm/page_alloc.c
@@ -549,7 +549,7 @@ static void free_pcppages_bulk(struct zo
 	int batch_free = 0;
 
 	spin_lock(&zone->lock);
-	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
+	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
@@ -586,7 +586,7 @@ static void free_one_page(struct zone *z
 				int migratetype)
 {
 	spin_lock(&zone->lock);
-	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
+	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
@@ -2280,7 +2280,7 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
 			zone->pages_scanned,
-			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
+			(zone->all_unreclaimable ? "yes" : "no")
 			);
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
diff -puN mm/vmscan.c~mm-restore-zone-all_unreclaimable-to-independence-word mm/vmscan.c
--- a/mm/vmscan.c~mm-restore-zone-all_unreclaimable-to-independence-word
+++ a/mm/vmscan.c
@@ -1721,8 +1721,7 @@ static void shrink_zones(int priority, s
 				continue;
 			note_zone_scanning_priority(zone, priority);
 
-			if (zone_is_all_unreclaimable(zone) &&
-						priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
 			sc->all_unreclaimable = 0;
 		} else {
@@ -2039,8 +2038,7 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_is_all_unreclaimable(zone) &&
-			    priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;
 
 			/*
@@ -2083,8 +2081,7 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_is_all_unreclaimable(zone) &&
-					priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;
 
 			temp_priority[i] = priority;
@@ -2111,12 +2108,11 @@ loop_again:
 						lru_pages);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
-			if (zone_is_all_unreclaimable(zone))
+			if (zone->all_unreclaimable)
 				continue;
-			if (nr_slab == 0 && zone->pages_scanned >=
-					(zone_reclaimable_pages(zone) * 6))
-					zone_set_flag(zone,
-						      ZONE_ALL_UNRECLAIMABLE);
+			if (nr_slab == 0 &&
+			    zone->pages_scanned >= (zone_reclaimable_pages(zone) * 6))
+				zone->all_unreclaimable = 1;
 			/*
 			 * If we've done a decent amount of scanning and
 			 * the reclaim ratio is low, start doing writepage
@@ -2646,7 +2642,7 @@ int zone_reclaim(struct zone *zone, gfp_
 	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
 		return ZONE_RECLAIM_FULL;
 
-	if (zone_is_all_unreclaimable(zone))
+	if (zone->all_unreclaimable)
 		return ZONE_RECLAIM_FULL;
 
 	/*
diff -puN mm/vmstat.c~mm-restore-zone-all_unreclaimable-to-independence-word mm/vmstat.c
--- a/mm/vmstat.c~mm-restore-zone-all_unreclaimable-to-independence-word
+++ a/mm/vmstat.c
@@ -765,7 +765,7 @@ static void zoneinfo_show_print(struct s
 		   "\n  start_pfn:         %lu"
 		   "\n  inactive_ratio:    %u"
 		   "\n  anon_scan_ratio:   %lu",
-			   zone_is_all_unreclaimable(zone),
+		   zone->all_unreclaimable,
 		   zone->prev_priority,
 		   zone->zone_start_pfn,
 		   zone->inactive_ratio,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
page-allocator-fix-update-nr_free_pages-only-as-necessary.patch
mm-page_alloc-fix-the-range-check-for-backward-merging.patch
vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
vmstat-add-anon_scan_ratio-field-to-zoneinfo.patch
memcg-add-anon_scan_ratio-to-memorystat-file.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

