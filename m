From: akpm@linux-foundation.org
Subject: - add-pagemlocked-page-state-bit-and-lru-infrastructure.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:42:11 -0800
Message-ID: <200703060042.l260gBwx006512@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43106 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933674AbXCFAmT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:42:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Add PageMlocked() page state bit and lru infrastructure
has been removed from the -mm tree.  Its filename was
     add-pagemlocked-page-state-bit-and-lru-infrastructure.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add PageMlocked() page state bit and lru infrastructure
From: Christoph Lameter <clameter@sgi.com>

Add PageMlocked() infrastructure

This adds a new PG_mlocked to mark pages that were taken off the LRU because
they have a reference from a VM_LOCKED vma.

(Yes, we still have 4 free page flag bits....  BITS_PER_LONG-FLAGS_RESERVED =
32 - 9 = 23 page flags).

Also add pagevec handling for returning mlocked pages to the LRU.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   13 +++++++++
 include/linux/pagevec.h    |    1 
 include/linux/swap.h       |    1 
 mm/page_alloc.c            |    7 +++++
 mm/swap.c                  |   47 +++++++++++++++++++++++++++++++++++
 5 files changed, 69 insertions(+)

diff -puN include/linux/page-flags.h~add-pagemlocked-page-state-bit-and-lru-infrastructure include/linux/page-flags.h
--- a/include/linux/page-flags.h~add-pagemlocked-page-state-bit-and-lru-infrastructure
+++ a/include/linux/page-flags.h
@@ -91,6 +91,8 @@
 #define PG_nosave_free		18	/* Used for system suspend/resume */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
+#define PG_mlocked		20	/* Page is mlocked */
+
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 
@@ -253,6 +255,17 @@ static inline void SetPageUptodate(struc
 #define SetPageUncached(page)	set_bit(PG_uncached, &(page)->flags)
 #define ClearPageUncached(page)	clear_bit(PG_uncached, &(page)->flags)
 
+/*
+ * PageMlocked set means that the page was taken off the LRU because
+ * a VM_LOCKED vma does exist. PageMlocked must be cleared before a
+ * page is put back onto the LRU. PageMlocked is only modified
+ * under the zone->lru_lock like PageLRU.
+ */
+#define PageMlocked(page)	test_bit(PG_mlocked, &(page)->flags)
+#define SetPageMlocked(page)	set_bit(PG_mlocked, &(page)->flags)
+#define ClearPageMlocked(page)	clear_bit(PG_mlocked, &(page)->flags)
+#define __ClearPageMlocked(page) __clear_bit(PG_mlocked, &(page)->flags)
+
 struct page;	/* forward declaration */
 
 extern void cancel_dirty_page(struct page *page, unsigned int account_size);
diff -puN include/linux/pagevec.h~add-pagemlocked-page-state-bit-and-lru-infrastructure include/linux/pagevec.h
--- a/include/linux/pagevec.h~add-pagemlocked-page-state-bit-and-lru-infrastructure
+++ a/include/linux/pagevec.h
@@ -25,6 +25,7 @@ void __pagevec_release_nonlru(struct pag
 void __pagevec_free(struct pagevec *pvec);
 void __pagevec_lru_add(struct pagevec *pvec);
 void __pagevec_lru_add_active(struct pagevec *pvec);
+void __pagevec_lru_add_mlock(struct pagevec *pvec);
 void pagevec_strip(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
diff -puN include/linux/swap.h~add-pagemlocked-page-state-bit-and-lru-infrastructure include/linux/swap.h
--- a/include/linux/swap.h~add-pagemlocked-page-state-bit-and-lru-infrastructure
+++ a/include/linux/swap.h
@@ -182,6 +182,7 @@ extern void FASTCALL(lru_cache_add(struc
 extern void FASTCALL(lru_cache_add_active(struct page *));
 extern void FASTCALL(activate_page(struct page *));
 extern void FASTCALL(mark_page_accessed(struct page *));
+extern void FASTCALL(lru_cache_add_mlock(struct page *));
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern int rotate_reclaimable_page(struct page *page);
diff -puN mm/swap.c~add-pagemlocked-page-state-bit-and-lru-infrastructure mm/swap.c
--- a/mm/swap.c~add-pagemlocked-page-state-bit-and-lru-infrastructure
+++ a/mm/swap.c
@@ -176,6 +176,7 @@ EXPORT_SYMBOL(mark_page_accessed);
  */
 static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
 static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_add_mlock_pvecs) = { 0, };
 
 void fastcall lru_cache_add(struct page *page)
 {
@@ -197,6 +198,16 @@ void fastcall lru_cache_add_active(struc
 	put_cpu_var(lru_add_active_pvecs);
 }
 
+void fastcall lru_cache_add_mlock(struct page *page)
+{
+	struct pagevec *pvec = &get_cpu_var(lru_add_mlock_pvecs);
+
+	page_cache_get(page);
+	if (!pagevec_add(pvec, page))
+		__pagevec_lru_add_mlock(pvec);
+	put_cpu_var(lru_add_mlock_pvecs);
+}
+
 static void __lru_add_drain(int cpu)
 {
 	struct pagevec *pvec = &per_cpu(lru_add_pvecs, cpu);
@@ -207,6 +218,9 @@ static void __lru_add_drain(int cpu)
 	pvec = &per_cpu(lru_add_active_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add_active(pvec);
+	pvec = &per_cpu(lru_add_mlock_pvecs, cpu);
+	if (pagevec_count(pvec))
+		__pagevec_lru_add_mlock(pvec);
 }
 
 void lru_add_drain(void)
@@ -364,6 +378,7 @@ void __pagevec_lru_add(struct pagevec *p
 			spin_lock_irq(&zone->lru_lock);
 		}
 		VM_BUG_ON(PageLRU(page));
+		VM_BUG_ON(PageMlocked(page));
 		SetPageLRU(page);
 		add_page_to_inactive_list(zone, page);
 	}
@@ -394,6 +409,38 @@ void __pagevec_lru_add_active(struct pag
 		SetPageLRU(page);
 		VM_BUG_ON(PageActive(page));
 		SetPageActive(page);
+		VM_BUG_ON(PageMlocked(page));
+		add_page_to_active_list(zone, page);
+	}
+	if (zone)
+		spin_unlock_irq(&zone->lru_lock);
+	release_pages(pvec->pages, pvec->nr, pvec->cold);
+	pagevec_reinit(pvec);
+}
+
+void __pagevec_lru_add_mlock(struct pagevec *pvec)
+{
+	int i;
+	struct zone *zone = NULL;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		struct zone *pagezone = page_zone(page);
+
+		if (pagezone != zone) {
+			if (zone)
+				spin_unlock_irq(&zone->lru_lock);
+			zone = pagezone;
+			spin_lock_irq(&zone->lru_lock);
+		}
+		if (!PageMlocked(page))
+			/* Another process already moved page to LRU */
+			continue;
+		BUG_ON(PageLRU(page));
+		SetPageLRU(page);
+		ClearPageMlocked(page);
+		SetPageActive(page);
+		__dec_zone_state(zone, NR_MLOCK);
 		add_page_to_active_list(zone, page);
 	}
 	if (zone)
diff -puN mm/page_alloc.c~add-pagemlocked-page-state-bit-and-lru-infrastructure mm/page_alloc.c
--- a/mm/page_alloc.c~add-pagemlocked-page-state-bit-and-lru-infrastructure
+++ a/mm/page_alloc.c
@@ -203,6 +203,7 @@ static void bad_page(struct page *page)
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
+			1 << PG_mlocked |
 			1 << PG_buddy );
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
@@ -442,6 +443,11 @@ static inline int free_pages_check(struc
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageMlocked(page)) {
+		/* Page is unused so no need to take the lru lock */
+		__ClearPageMlocked(page);
+		dec_zone_page_state(page, NR_MLOCK);
+	}
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
@@ -588,6 +594,7 @@ static int prep_new_page(struct page *pa
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+			1 << PG_mlocked |
 			1 << PG_buddy ))))
 		bad_page(page);
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
logic-to-move-mlocked-pages.patch
consolidate-new-anonymous-page-code-paths.patch
avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
opportunistically-move-mlocked-pages-off-the-lru.patch
take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
