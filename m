From: akpm@linux-foundation.org
Subject: + lumpy-reclaim-v4.patch added to -mm tree
Date: Thu, 15 Mar 2007 19:18:49 -0800
Message-ID: <200703160318.l2G3InTv001376@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51421 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbXCPDTE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 23:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, a.p.zijlstra@chello.nl, mel@csn.ul.ie


The patch titled
     Lumpy Reclaim V4
has been added to the -mm tree.  Its filename is
     lumpy-reclaim-v4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Lumpy Reclaim V4
From: Andy Whitcroft <apw@shadowen.org>

When we are out of memory of a suitable size we enter reclaim.  The current
reclaim algorithm targets pages in LRU order, which is great for fairness at
order-0 but highly unsuitable if you desire pages at higher orders.  To get
pages of higher order we must shoot down a very high proportion of memory;
>95% in a lot of cases.

This patch set adds a lumpy reclaim algorithm to the allocator.  It targets
groups of pages at the specified order anchored at the end of the active and
inactive lists.  This encourages groups of pages at the requested orders to
move from active to inactive, and active to free lists.  This behaviour is
only triggered out of direct reclaim when higher order pages have been
requested.

This patch set is particularly effective when utilised with an
anti-fragmentation scheme which groups pages of similar reclaimability
together.

This patch set is based on Peter Zijlstra's lumpy reclaim V2 patch which forms
the foundation.  Credit to Mel Gorman for sanitity checking.

[akpm@osdl.org: ia64 pfn_to_nid fixes and loop cleanup]
[bunk@stusta.de: static declarations for internal functions]
[a.p.zijlstra@chello.nl: initial lumpy V2 implementation]
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c          |    2 
 include/linux/swap.h |    3 
 mm/page_alloc.c      |    2 
 mm/vmscan.c          |  126 ++++++++++++++++++++++++++++++++++-------
 4 files changed, 111 insertions(+), 22 deletions(-)

diff -puN fs/buffer.c~lumpy-reclaim-v4 fs/buffer.c
--- a/fs/buffer.c~lumpy-reclaim-v4
+++ a/fs/buffer.c
@@ -363,7 +363,7 @@ static void free_more_memory(void)
 	for_each_online_pgdat(pgdat) {
 		zones = pgdat->node_zonelists[gfp_zone(GFP_NOFS)].zones;
 		if (*zones)
-			try_to_free_pages(zones, GFP_NOFS);
+			try_to_free_pages(zones, 0, GFP_NOFS);
 	}
 }
 
diff -puN include/linux/swap.h~lumpy-reclaim-v4 include/linux/swap.h
--- a/include/linux/swap.h~lumpy-reclaim-v4
+++ a/include/linux/swap.h
@@ -188,7 +188,8 @@ extern int rotate_reclaimable_page(struc
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
-extern unsigned long try_to_free_pages(struct zone **, gfp_t);
+extern unsigned long try_to_free_pages(struct zone **zones, int order,
+					gfp_t gfp_mask);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
diff -puN mm/page_alloc.c~lumpy-reclaim-v4 mm/page_alloc.c
--- a/mm/page_alloc.c~lumpy-reclaim-v4
+++ a/mm/page_alloc.c
@@ -1637,7 +1637,7 @@ nofail_alloc:
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	did_some_progress = try_to_free_pages(zonelist->zones, gfp_mask);
+	did_some_progress = try_to_free_pages(zonelist->zones, order, gfp_mask);
 
 	p->reclaim_state = NULL;
 	p->flags &= ~PF_MEMALLOC;
diff -puN mm/vmscan.c~lumpy-reclaim-v4 mm/vmscan.c
--- a/mm/vmscan.c~lumpy-reclaim-v4
+++ a/mm/vmscan.c
@@ -66,6 +66,8 @@ struct scan_control {
 	int swappiness;
 
 	int all_unreclaimable;
+
+	int order;
 };
 
 /*
@@ -606,6 +608,41 @@ keep:
 }
 
 /*
+ * Attempt to remove the specified page from its LRU.  Only take this page
+ * if it is of the appropriate PageActive status.  Pages which are being
+ * freed elsewhere are also ignored.
+ *
+ * page:	page to consider
+ * active:	active/inactive flag only take pages of this type
+ *
+ * returns 0 on success, -ve errno on failure.
+ */
+static int __isolate_lru_page(struct page *page, int active)
+{
+	int ret = -EINVAL;
+
+	/*
+	 * When checking the active state, we need to be sure we are
+	 * dealing with comparible boolean values.  Take the logical not
+	 * of each.
+	 */
+	if (PageLRU(page) && (!PageActive(page) == !active)) {
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
+/*
  * zone->lru_lock is heavily contended.  Some of the functions that
  * shrink the lists perform better by taking out a batch of pages
  * and working on them outside the LRU lock.
@@ -619,38 +656,88 @@ keep:
  * @src:	The LRU list to pull pages off.
  * @dst:	The temp list to put pages on to.
  * @scanned:	The number of pages that were scanned.
+ * @order:	The caller's attempted allocation order
+ * @active:	The caller's trying to obtain active or inactive pages
  *
  * returns how many pages were moved onto *@dst.
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		struct list_head *src, struct list_head *dst,
-		unsigned long *scanned)
+		unsigned long *scanned, int order, int active)
 {
 	unsigned long nr_taken = 0;
-	struct page *page;
 	unsigned long scan;
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
-		struct list_head *target;
+		struct page *page;
+		unsigned long pfn;
+		unsigned long end_pfn;
+		unsigned long page_pfn;
+		int zone_id;
+
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
+		switch (__isolate_lru_page(page, active)) {
+		case 0:
+			list_move(&page->lru, dst);
 			nr_taken++;
-		} /* else it is being freed elsewhere */
+			break;
+
+		default:
+			/* page is being freed, or is a missmatch */
+			list_move(&page->lru, src);
+			continue;
+		}
+
+		if (!order)
+			continue;
 
-		list_add(&page->lru, target);
+		/*
+		 * Attempt to take all pages in the order aligned region
+		 * surrounding the tag page.  Only take those pages of
+		 * the same active state as that tag page.  We may safely
+		 * round the target page pfn down to the requested order
+		 * as the mem_map is guarenteed valid out to MAX_ORDER,
+		 * where that page is in a different zone we will detect
+		 * it from its zone id and abort this block scan.
+		 */
+		zone_id = page_zone_id(page);
+		page_pfn = page_to_pfn(page);
+		pfn = page_pfn & ~((1 << order) - 1);
+		end_pfn = pfn + (1 << order);
+		for (; pfn < end_pfn; pfn++) {
+			struct page *cursor_page;
+
+			/* The target page is in the block, ignore it. */
+			if (unlikely(pfn == page_pfn))
+				continue;
+#ifdef CONFIG_HOLES_IN_ZONE
+			/* Avoid holes within the zone. */
+			if (unlikely(!pfn_valid(pfn)))
+				break;
+#endif
+
+			cursor_page = pfn_to_page(pfn);
+			/* Check that we have not crossed a zone boundary. */
+			if (unlikely(page_zone_id(cursor_page) != zone_id))
+				continue;
+			scan++;
+			switch (__isolate_lru_page(cursor_page, active)) {
+			case 0:
+				list_move(&cursor_page->lru, dst);
+				nr_taken++;
+				break;
+
+			case -EBUSY:
+				/* else it is being freed elsewhere */
+				list_move(&cursor_page->lru, src);
+			default:
+				break;
+			}
+		}
 	}
 
 	*scanned = scan;
@@ -680,8 +767,8 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_freed;
 
 		nr_taken = isolate_lru_pages(sc->swap_cluster_max,
-					     &zone->inactive_list,
-					     &page_list, &nr_scan);
+				     &zone->inactive_list,
+				     &page_list, &nr_scan, sc->order, 0);
 		__mod_zone_page_state(zone, NR_INACTIVE, -nr_taken);
 		zone->pages_scanned += nr_scan;
 		spin_unlock_irq(&zone->lru_lock);
@@ -827,7 +914,7 @@ force_reclaim_mapped:
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	pgmoved = isolate_lru_pages(nr_pages, &zone->active_list,
-				    &l_hold, &pgscanned);
+				    &l_hold, &pgscanned, sc->order, 1);
 	zone->pages_scanned += pgscanned;
 	__mod_zone_page_state(zone, NR_ACTIVE, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
@@ -1022,7 +1109,7 @@ static unsigned long shrink_zones(int pr
  * holds filesystem locks which prevent writeout this might not work, and the
  * allocation attempt will fail.
  */
-unsigned long try_to_free_pages(struct zone **zones, gfp_t gfp_mask)
+unsigned long try_to_free_pages(struct zone **zones, int order, gfp_t gfp_mask)
 {
 	int priority;
 	int ret = 0;
@@ -1037,6 +1124,7 @@ unsigned long try_to_free_pages(struct z
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.may_swap = 1,
 		.swappiness = vm_swappiness,
+		.order = order,
 	};
 
 	count_vm_event(ALLOCSTALL);
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
move-free-pages-between-lists-on-steal-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
lumpy-reclaim-v4.patch
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch
