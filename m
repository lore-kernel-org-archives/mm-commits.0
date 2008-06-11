From: akpm@linux-foundation.org
Subject: - vmscan-second-chance-replacement-for-anonymous-pages.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:08 -0700
Message-ID: <200806111946.m5BJk9AS014556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbYFKTq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:46:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: second chance replacement for anonymous pages
has been removed from the -mm tree.  Its filename was
     vmscan-second-chance-replacement-for-anonymous-pages.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: second chance replacement for anonymous pages
From: Rik van Riel <riel@redhat.com>

We avoid evicting and scanning anonymous pages for the most part, but
under some workloads we can end up with most of memory filled with
anonymous pages.  At that point, we suddenly need to clear the referenced
bits on all of memory, which can take ages on very large memory systems.

We can reduce the maximum number of pages that need to be scanned by not
taking the referenced state into account when deactivating an anonymous
page.  After all, every anonymous page starts out referenced, so why
check?

If an anonymous page gets referenced again before it reaches the end of
the inactive list, we move it back to the active list.

To keep the maximum amount of necessary work reasonable, we scale the
active to inactive ratio with the size of memory, using the formula
active:inactive ratio = sqrt(memory in GB * 10).

Kswapd CPU use now seems to scale by the amount of pageout bandwidth,
instead of by the amount of memory present in the system.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   12 +++++++++
 include/linux/mmzone.h    |    5 ++++
 mm/page_alloc.c           |   40 ++++++++++++++++++++++++++++++++
 mm/vmscan.c               |   45 +++++++++++++++++++++++++++++-------
 mm/vmstat.c               |    6 +++-
 5 files changed, 98 insertions(+), 10 deletions(-)

diff -puN include/linux/mm_inline.h~vmscan-second-chance-replacement-for-anonymous-pages include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/include/linux/mm_inline.h
@@ -97,4 +97,16 @@ del_page_from_lru(struct zone *zone, str
 	__dec_zone_state(zone, NR_INACTIVE_ANON + l);
 }
 
+static inline int inactive_anon_low(struct zone *zone)
+{
+	unsigned long active, inactive;
+
+	active = zone_page_state(zone, NR_ACTIVE_ANON);
+	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
+
+	if (inactive * zone->inactive_ratio < active)
+		return 1;
+
+	return 0;
+}
 #endif
diff -puN include/linux/mmzone.h~vmscan-second-chance-replacement-for-anonymous-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/include/linux/mmzone.h
@@ -311,6 +311,11 @@ struct zone {
 	 */
 	int prev_priority;
 
+	/*
+	 * The ratio of active to inactive pages.
+	 */
+	unsigned int inactive_ratio;
+
 
 	ZONE_PADDING(_pad2_)
 	/* Rarely used or read-mostly fields */
diff -puN mm/page_alloc.c~vmscan-second-chance-replacement-for-anonymous-pages mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/mm/page_alloc.c
@@ -4193,6 +4193,45 @@ void setup_per_zone_pages_min(void)
 	calculate_totalreserve_pages();
 }
 
+/**
+ * setup_per_zone_inactive_ratio - called when min_free_kbytes changes.
+ *
+ * The inactive anon list should be small enough that the VM never has to
+ * do too much work, but large enough that each inactive page has a chance
+ * to be referenced again before it is swapped out.
+ *
+ * The inactive_anon ratio is the ratio of active to inactive anonymous
+ * pages.  Ie. a ratio of 3 means 3:1 or 25% of the anonymous pages are
+ * on the inactive list.
+ *
+ * total     return    max
+ * memory    value     inactive anon
+ * -------------------------------------
+ *   10MB       1         5MB
+ *  100MB       1        50MB
+ *    1GB       3       250MB
+ *   10GB      10       0.9GB
+ *  100GB      31         3GB
+ *    1TB     101        10GB
+ *   10TB     320        32GB
+ */
+void setup_per_zone_inactive_ratio(void)
+{
+	struct zone *zone;
+
+	for_each_zone(zone) {
+		unsigned int gb, ratio;
+
+		/* Zone size in gigabytes */
+		gb = zone->present_pages >> (30 - PAGE_SHIFT);
+		ratio = int_sqrt(10 * gb);
+		if (!ratio)
+			ratio = 1;
+
+		zone->inactive_ratio = ratio;
+	}
+}
+
 /*
  * Initialise min_free_kbytes.
  *
@@ -4230,6 +4269,7 @@ static int __init init_per_zone_pages_mi
 		min_free_kbytes = 65536;
 	setup_per_zone_pages_min();
 	setup_per_zone_lowmem_reserve();
+	setup_per_zone_inactive_ratio();
 	return 0;
 }
 module_init(init_per_zone_pages_min)
diff -puN mm/vmscan.c~vmscan-second-chance-replacement-for-anonymous-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/mm/vmscan.c
@@ -114,7 +114,7 @@ struct scan_control {
 /*
  * From 0 .. 100.  Higher means more swappy.
  */
-int vm_swappiness = 60;
+int vm_swappiness = 20;
 long vm_total_pages;	/* The total number of pages which the VM controls */
 
 static LIST_HEAD(shrinker_list);
@@ -1034,7 +1034,7 @@ static inline int zone_is_near_oom(struc
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			struct scan_control *sc, int priority, int file)
 {
-	unsigned long pgmoved;
+	unsigned long pgmoved = 0;
 	int pgdeactivate = 0;
 	unsigned long pgscanned;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
@@ -1062,17 +1062,32 @@ static void shrink_active_list(unsigned 
 		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 
+	pgmoved = 0;
 	while (!list_empty(&l_hold)) {
 		cond_resched();
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
-		if (page_referenced(page, 0, sc->mem_cgroup))
-			list_add(&page->lru, &l_active);
-		else
+		if (page_referenced(page, 0, sc->mem_cgroup)) {
+			if (file) {
+				/* Referenced file pages stay active. */
+				list_add(&page->lru, &l_active);
+			} else {
+				/* Anonymous pages always get deactivated. */
+				list_add(&page->lru, &l_inactive);
+				pgmoved++;
+			}
+		} else
 			list_add(&page->lru, &l_inactive);
 	}
 
 	/*
+	 * Count the referenced anon pages as rotated, to balance pageout
+	 * scan pressure between file and anonymous pages in get_sacn_ratio.
+	 */
+	if (!file)
+		zone->recent_rotated_anon += pgmoved;
+
+	/*
 	 * Now put the pages back on the appropriate [file or anon] inactive
 	 * and active lists.
 	 */
@@ -1155,7 +1170,13 @@ static unsigned long shrink_list(enum lr
 {
 	int file = is_file_lru(lru);
 
-	if (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE) {
+	if (lru == LRU_ACTIVE_FILE) {
+		shrink_active_list(nr_to_scan, zone, sc, priority, file);
+		return 0;
+	}
+
+	if (lru == LRU_ACTIVE_ANON &&
+	    (!scan_global_lru(sc) || inactive_anon_low(zone))) {
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
@@ -1265,8 +1286,8 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
-	while (nr[LRU_ACTIVE_ANON] || nr[LRU_INACTIVE_ANON] ||
-				nr[LRU_ACTIVE_FILE] || nr[LRU_INACTIVE_FILE]) {
+	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
+						 nr[LRU_INACTIVE_FILE]) {
 		for_each_lru(l) {
 			if (nr[l]) {
 				nr_to_scan = min(nr[l],
@@ -1572,6 +1593,14 @@ loop_again:
 			    priority != DEF_PRIORITY)
 				continue;
 
+			/*
+			 * Do some background aging of the anon list, to give
+			 * pages a chance to be referenced before reclaiming.
+			 */
+			if (inactive_anon_low(zone))
+				shrink_active_list(SWAP_CLUSTER_MAX, zone,
+							&sc, priority, 0);
+
 			if (!zone_watermark_ok(zone, order, zone->pages_high,
 					       0, 0)) {
 				end_zone = i;
diff -puN mm/vmstat.c~vmscan-second-chance-replacement-for-anonymous-pages mm/vmstat.c
--- a/mm/vmstat.c~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/mm/vmstat.c
@@ -721,10 +721,12 @@ static void zoneinfo_show_print(struct s
 	seq_printf(m,
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
-		   "\n  start_pfn:         %lu",
+		   "\n  start_pfn:         %lu"
+		   "\n  inactive_ratio:    %u",
 			   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
-		   zone->zone_start_pfn);
+		   zone->zone_start_pfn,
+		   zone->inactive_ratio);
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

ntp-let-update_persistent_clock-sleep.patch
access_process_vm-device-memory-infrastructure.patch
access_process_vm-device-memory-infrastructure-fix.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-add-some-sanity-checks-to-get_scan_ratio.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
vmscan-more-aggressively-use-lumpy-reclaim.patch
vmscan-pageflag-helpers-for-configed-out-flags.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-cull-non-reclaimable-pages-in-fault-path.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl-fix.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch
make-mm-rmapc-anon_vma_cachep-static.patch

