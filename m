From: akpm@linux-foundation.org
Subject: + vmscan-add-some-sanity-checks-to-get_scan_ratio.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:18:35 -0700
Message-ID: <200806090618.m596IZW7006613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYFIGS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com


The patch titled
     vmscan: add some sanity checks to get_scan_ratio
has been added to the -mm tree.  Its filename is
     vmscan-add-some-sanity-checks-to-get_scan_ratio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: add some sanity checks to get_scan_ratio
From: Rik van Riel <riel@redhat.com>


The access ratio based scan rate determination in get_scan_ratio
works ok in most situations, but needs to be corrected in some
corner cases:
- if we run out of swap space, do not bother scanning the anon LRUs
- if we have already freed all of the page cache, we need to scan
  the anon LRUs
- restore the *actual* access ratio based scan rate algorithm, the
  previous versions of this patch series had the wrong version
- scale the number of pages added to zone->nr_scan[l]

Signed-off-by: Rik van Riel <riel@redhat.com>

---
 include/linux/mmzone.h |    2

Index: linux-2.6.26-rc2-mm1/mm/vmscan.c
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 
 mm/page_alloc.c        |    3 -
 mm/swap.c              |   13 ++++
 mm/vmscan.c            |  104 ++++++++++++++++++++++++++-------------
 4 files changed, 85 insertions(+), 37 deletions(-)

diff -puN include/linux/mmzone.h~add-some-sanity-checks-to-get_scan_ratio include/linux/mmzone.h
--- a/include/linux/mmzone.h~add-some-sanity-checks-to-get_scan_ratio
+++ a/include/linux/mmzone.h
@@ -289,6 +289,8 @@ struct zone {
 
 	unsigned long		recent_rotated_anon;
 	unsigned long		recent_rotated_file;
+	unsigned long		recent_scanned_anon;
+	unsigned long		recent_scanned_file;
 
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
diff -puN mm/page_alloc.c~add-some-sanity-checks-to-get_scan_ratio mm/page_alloc.c
--- a/mm/page_alloc.c~add-some-sanity-checks-to-get_scan_ratio
+++ a/mm/page_alloc.c
@@ -3436,7 +3436,8 @@ static void __paginginit free_area_init_
 		}
 		zone->recent_rotated_anon = 0;
 		zone->recent_rotated_file = 0;
-//TODO recent_scanned_* ???
+		zone->recent_scanned_anon = 0;
+		zone->recent_scanned_file = 0;
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
diff -puN mm/swap.c~add-some-sanity-checks-to-get_scan_ratio mm/swap.c
--- a/mm/swap.c~add-some-sanity-checks-to-get_scan_ratio
+++ a/mm/swap.c
@@ -176,8 +176,8 @@ void activate_page(struct page *page)
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page)) {
-		int lru = LRU_BASE;
-		lru += page_file_cache(page);
+		int file = page_file_cache(page);
+		int lru = LRU_BASE + file;
 		del_page_from_lru_list(zone, page, lru);
 
 		SetPageActive(page);
@@ -185,6 +185,15 @@ void activate_page(struct page *page)
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 		mem_cgroup_move_lists(page, true);
+
+		if (file) {
+			zone->recent_scanned_file++;
+			zone->recent_rotated_file++;
+		} else {
+			/* Can this happen?  Maybe through tmpfs... */
+			zone->recent_scanned_anon++;
+			zone->recent_rotated_anon++;
+		}
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
diff -puN mm/vmscan.c~add-some-sanity-checks-to-get_scan_ratio mm/vmscan.c
--- a/mm/vmscan.c~add-some-sanity-checks-to-get_scan_ratio
+++ a/mm/vmscan.c
@@ -911,8 +911,13 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scan_global_lru(sc))
+		if (scan_global_lru(sc)) {
 			zone->pages_scanned += nr_scan;
+			zone->recent_scanned_anon += count[LRU_ACTIVE_ANON] +
+						     count[LRU_INACTIVE_ANON];
+			zone->recent_scanned_file += count[LRU_ACTIVE_FILE] +
+						     count[LRU_INACTIVE_FILE];
+		}
 		spin_unlock_irq(&zone->lru_lock);
 
 		nr_scanned += nr_scan;
@@ -962,11 +967,13 @@ static unsigned long shrink_inactive_lis
 			VM_BUG_ON(PageLRU(page));
 			SetPageLRU(page);
 			list_del(&page->lru);
-			if (page_file_cache(page)) {
+			if (page_file_cache(page))
 				lru += LRU_FILE;
-				zone->recent_rotated_file++;
-			} else {
-				zone->recent_rotated_anon++;
+			if (scan_global_lru(sc)) {
+				if (page_file_cache(page))
+					zone->recent_rotated_file++;
+				else
+					zone->recent_rotated_anon++;
 			}
 			if (PageActive(page))
 				lru += LRU_ACTIVE;
@@ -1045,8 +1052,13 @@ static void shrink_active_list(unsigned 
 	 * zone->pages_scanned is used for detect zone's oom
 	 * mem_cgroup remembers nr_scan by itself.
 	 */
-	if (scan_global_lru(sc))
+	if (scan_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
+		if (file)
+			zone->recent_scanned_file += pgscanned;
+		else
+			zone->recent_scanned_anon += pgscanned;
+	}
 
 	if (file)
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
@@ -1188,9 +1200,8 @@ static unsigned long shrink_list(enum lr
 static void get_scan_ratio(struct zone *zone, struct scan_control * sc,
 					unsigned long *percent)
 {
-	unsigned long anon, file;
+	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
-	unsigned long rotate_sum;
 	unsigned long ap, fp;
 
 	anon  = zone_page_state(zone, NR_ACTIVE_ANON) +
@@ -1198,15 +1209,19 @@ static void get_scan_ratio(struct zone *
 	file  = zone_page_state(zone, NR_ACTIVE_FILE) +
 		zone_page_state(zone, NR_INACTIVE_FILE);
 
-	rotate_sum = zone->recent_rotated_file + zone->recent_rotated_anon;
-
 	/* Keep a floating average of RECENT references. */
-	if (unlikely(rotate_sum > min(anon, file))) {
+	if (unlikely(zone->recent_scanned_anon > anon / zone->inactive_ratio)) {
 		spin_lock_irq(&zone->lru_lock);
-		zone->recent_rotated_file /= 2;
+		zone->recent_scanned_anon /= 2;
 		zone->recent_rotated_anon /= 2;
 		spin_unlock_irq(&zone->lru_lock);
-		rotate_sum /= 2;
+	}
+
+	if (unlikely(zone->recent_scanned_file > file / 4)) {
+		spin_lock_irq(&zone->lru_lock);
+		zone->recent_scanned_file /= 2;
+		zone->recent_rotated_file /= 2;
+		spin_unlock_irq(&zone->lru_lock);
 	}
 
 	/*
@@ -1219,23 +1234,33 @@ static void get_scan_ratio(struct zone *
 	/*
 	 *                  anon       recent_rotated_anon
 	 * %anon = 100 * ----------- / ------------------- * IO cost
-	 *               anon + file       rotate_sum
+	 *               anon + file   recent_scanned_anon
 	 */
-	ap = (anon_prio * anon) / (anon + file + 1);
-	ap *= rotate_sum / (zone->recent_rotated_anon + 1);
-	if (ap == 0)
-		ap = 1;
-	else if (ap > 100)
-		ap = 100;
-	percent[0] = ap;
-
-	fp = (file_prio * file) / (anon + file + 1);
-	fp *= rotate_sum / (zone->recent_rotated_file + 1);
-	if (fp == 0)
-		fp = 1;
-	else if (fp > 100)
-		fp = 100;
-	percent[1] = fp;
+	ap = (anon_prio + 1) * (zone->recent_scanned_anon + 1);
+	ap /= zone->recent_rotated_anon + 1;
+
+	fp = (file_prio + 1) * (zone->recent_scanned_file + 1);
+	fp /= zone->recent_rotated_file + 1;
+
+	/* Normalize to percentages */
+	percent[0] = 100 * ap / (ap + fp + 1);
+	percent[1] = 100 - percent[0];
+
+	free = zone_page_state(zone, NR_FREE_PAGES);
+
+	/*
+	 * If we have no swap space, do not bother scanning anon pages.
+	 */
+	if (nr_swap_pages <= 0) {
+		percent[0] = 0;
+		percent[1] = 100;
+	}
+	/*
+	 * If we already freed most file pages, scan the anon pages
+	 * regardless of the page access ratios or swappiness setting.
+	 */
+	else if (file + free <= zone->pages_high)
+		percent[0] = 100;
 }
 
 
@@ -1256,13 +1281,17 @@ static unsigned long shrink_zone(int pri
 	for_each_lru(l) {
 		if (scan_global_lru(sc)) {
 			int file = is_file_lru(l);
+			int scan;
 			/*
 			 * Add one to nr_to_scan just to make sure that the
-			 * kernel will slowly sift through the active list.
+			 * kernel will slowly sift through each list.
 			 */
-			zone->nr_scan[l] += (zone_page_state(zone,
-				NR_INACTIVE_ANON + l) >> priority) + 1;
-			nr[l] = zone->nr_scan[l] * percent[file] / 100;
+			scan = zone_page_state(zone, NR_INACTIVE_ANON + l);
+			scan >>= priority;
+			scan = (scan * percent[file]) / 100;
+
+			zone->nr_scan[l] += scan + 1;
+			nr[l] = zone->nr_scan[l];
 			if (nr[l] >= sc->swap_cluster_max)
 				zone->nr_scan[l] = 0;
 			else
@@ -1279,7 +1308,7 @@ static unsigned long shrink_zone(int pri
 	}
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
-						 nr[LRU_INACTIVE_FILE]) {
+					nr[LRU_INACTIVE_FILE]) {
 		for_each_lru(l) {
 			if (nr[l]) {
 				nr_to_scan = min(nr[l],
@@ -1292,6 +1321,13 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
+	/*
+	 * Even if we did not try to evict anon pages at all, we want to
+	 * rebalance the anon lru active/inactive ratio.
+	 */
+	if (scan_global_lru(sc) && inactive_anon_low(zone))
+		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
+
 	throttle_vm_writeout(sc->gfp_mask);
 	return nr_reclaimed;
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
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
vmscan-use-an-array-for-the-lru-pagevecs.patch
vmscan-free-swap-space-on-swap-in-activation.patch
vmscan-define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
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
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch
make-mm-rmapc-anon_vma_cachep-static.patch

