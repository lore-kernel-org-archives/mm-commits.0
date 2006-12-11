From: akpm@osdl.org
Subject: + lumpy-reclaim-v2.patch added to -mm tree
Date: Mon, 11 Dec 2006 14:42:34 -0800
Message-ID: <200612112242.kBBMgYZP010958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937701AbWLKWnN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 17:43:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, a.p.zijlstra@chello.nl


The patch titled
     lumpy reclaim v2
has been added to the -mm tree.  Its filename is
     lumpy-reclaim-v2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lumpy reclaim v2
From: Andy Whitcroft <apw@shadowen.org>

When trying to reclaim pages for a higher order allocation, make reclaim try
to move lumps of pages (fitting the requested order) about, instead of single
pages.  This should significantly reduce the number of reclaimed pages for
higher order allocations.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/buffer.c          |    2 
 include/linux/swap.h |    2 
 mm/page_alloc.c      |    2 
 mm/vmscan.c          |   94 ++++++++++++++++++++++++++++++++---------
 4 files changed, 77 insertions(+), 23 deletions(-)

diff -puN fs/buffer.c~lumpy-reclaim-v2 fs/buffer.c
--- a/fs/buffer.c~lumpy-reclaim-v2
+++ a/fs/buffer.c
@@ -362,7 +362,7 @@ static void free_more_memory(void)
 	for_each_online_pgdat(pgdat) {
 		zones = pgdat->node_zonelists[gfp_zone(GFP_NOFS)].zones;
 		if (*zones)
-			try_to_free_pages(zones, GFP_NOFS);
+			try_to_free_pages(zones, 0, GFP_NOFS);
 	}
 }
 
diff -puN include/linux/swap.h~lumpy-reclaim-v2 include/linux/swap.h
--- a/include/linux/swap.h~lumpy-reclaim-v2
+++ a/include/linux/swap.h
@@ -186,7 +186,7 @@ extern int rotate_reclaimable_page(struc
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
-extern unsigned long try_to_free_pages(struct zone **, gfp_t);
+extern unsigned long try_to_free_pages(struct zone **, int, gfp_t);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
diff -puN mm/page_alloc.c~lumpy-reclaim-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~lumpy-reclaim-v2
+++ a/mm/page_alloc.c
@@ -1314,7 +1314,7 @@ nofail_alloc:
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	did_some_progress = try_to_free_pages(zonelist->zones, gfp_mask);
+	did_some_progress = try_to_free_pages(zonelist->zones, order, gfp_mask);
 
 	p->reclaim_state = NULL;
 	p->flags &= ~PF_MEMALLOC;
diff -puN mm/vmscan.c~lumpy-reclaim-v2 mm/vmscan.c
--- a/mm/vmscan.c~lumpy-reclaim-v2
+++ a/mm/vmscan.c
@@ -66,6 +66,8 @@ struct scan_control {
 	int swappiness;
 
 	int all_unreclaimable;
+
+	int order;
 };
 
 /*
@@ -619,35 +621,86 @@ keep:
  *
  * returns how many pages were moved onto *@dst.
  */
+int __isolate_lru_page(struct page *page, int active)
+{
+	int ret = -EINVAL;
+
+	if (PageLRU(page) && (PageActive(page) == active)) {
+		ret = -EBUSY;
+		if (likely(get_page_unless_zero(page))) {
+			/*
+			 * Be careful not to clear PageLRU until after we're
+			 * sure the page is not being freed elsewhere -- the
+			 * page release code relies on it.
+			 */
+			ClearPageLRU(page);
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		struct list_head *src, struct list_head *dst,
-		unsigned long *scanned)
+		unsigned long *scanned, int order)
 {
 	unsigned long nr_taken = 0;
-	struct page *page;
-	unsigned long scan;
+	struct page *page, *tmp;
+	unsigned long scan, pfn, end_pfn, page_pfn;
+	int active;
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
-		struct list_head *target;
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
 
 		VM_BUG_ON(!PageLRU(page));
 
-		list_del(&page->lru);
-		target = src;
-		if (likely(get_page_unless_zero(page))) {
-			/*
-			 * Be careful not to clear PageLRU until after we're
-			 * sure the page is not being freed elsewhere -- the
-			 * page release code relies on it.
-			 */
-			ClearPageLRU(page);
-			target = dst;
-			nr_taken++;
-		} /* else it is being freed elsewhere */
+		active = PageActive(page);
+		switch (__isolate_lru_page(page, active)) {
+			case 0:
+				list_move(&page->lru, dst);
+				nr_taken++;
+				break;
+
+			case -EBUSY:
+				/* else it is being freed elsewhere */
+				list_move(&page->lru, src);
+				continue;
+
+			default:
+				BUG();
+		}
 
-		list_add(&page->lru, target);
+		if (!order)
+			continue;
+
+		page_pfn = pfn = __page_to_pfn(page);
+		end_pfn = pfn &= ~((1 << order) - 1);
+		end_pfn += 1 << order;
+		for (; pfn < end_pfn; pfn++) {
+			if (unlikely(pfn == page_pfn))
+				continue;
+			if (unlikely(!pfn_valid(pfn)))
+				break;
+
+			scan++;
+			tmp = __pfn_to_page(pfn);
+			switch (__isolate_lru_page(tmp, active)) {
+				case 0:
+					list_move(&tmp->lru, dst);
+					nr_taken++;
+					continue;
+
+				case -EBUSY:
+					/* else it is being freed elsewhere */
+					list_move(&tmp->lru, src);
+				default:
+					break;
+
+			}
+			break;
+		}
 	}
 
 	*scanned = scan;
@@ -678,7 +731,7 @@ static unsigned long shrink_inactive_lis
 
 		nr_taken = isolate_lru_pages(sc->swap_cluster_max,
 					     &zone->inactive_list,
-					     &page_list, &nr_scan);
+					     &page_list, &nr_scan, sc->order);
 		zone->nr_inactive -= nr_taken;
 		zone->pages_scanned += nr_scan;
 		spin_unlock_irq(&zone->lru_lock);
@@ -823,7 +876,7 @@ force_reclaim_mapped:
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	pgmoved = isolate_lru_pages(nr_pages, &zone->active_list,
-				    &l_hold, &pgscanned);
+				    &l_hold, &pgscanned, sc->order);
 	zone->pages_scanned += pgscanned;
 	zone->nr_active -= pgmoved;
 	spin_unlock_irq(&zone->lru_lock);
@@ -1012,7 +1065,7 @@ static unsigned long shrink_zones(int pr
  * holds filesystem locks which prevent writeout this might not work, and the
  * allocation attempt will fail.
  */
-unsigned long try_to_free_pages(struct zone **zones, gfp_t gfp_mask)
+unsigned long try_to_free_pages(struct zone **zones, int order, gfp_t gfp_mask)
 {
 	int priority;
 	int ret = 0;
@@ -1027,6 +1080,7 @@ unsigned long try_to_free_pages(struct z
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.may_swap = 1,
 		.swappiness = vm_swappiness,
+		.order = order,
 	};
 
 	count_vm_event(ALLOCSTALL);
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
git-acpi.patch
pci-device-ensure-sysdata-initialised-v2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
virtual-memmap-on-sparsemem-v3-generic-virtual.patch
virtual-memmap-on-sparsemem-v3-generic-virtual-fix.patch
virtual-memmap-on-sparsemem-v3-static-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual-update.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
lumpy-reclaim-v2.patch
lumpy-cleanup-a-missplaced-comment-and-simplify-some-code.patch
lumpy-ensure-we-respect-zone-boundaries.patch
lumpy-take-the-other-active-inactive-pages-in-the-area.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
optional-zone_dma-in-the-vm.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch

