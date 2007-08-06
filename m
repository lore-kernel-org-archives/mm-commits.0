From: akpm@linux-foundation.org
Subject: + wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:22:16 -0700
Message-ID: <200708061922.l76JMG36010622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757988AbXHFTW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, mel@csn.ul.ie


The patch titled
     synchronous lumpy reclaim: wait for page writeback when directly reclaiming contiguous areas
has been added to the -mm tree.  Its filename is
     wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synchronous lumpy reclaim: wait for page writeback when directly reclaiming contiguous areas
From: Andy Whitcroft <apw@shadowen.org>

Lumpy reclaim works by selecting a lead page from the LRU list and then
selecting pages for reclaim from the order-aligned area of pages.  In the
situation were all pages in that region are inactive and not referenced by any
process over time, it works well.

In the situation where there is even light load on the system, the pages may
not free quickly.  Out of a area of 1024 pages, maybe only 950 of them are
freed when the allocation attempt occurs because lumpy reclaim returned early.
 This patch alters the behaviour of direct reclaim for large contiguous
blocks.

The first attempt to call shrink_page_list() is asynchronous but if it fails,
the pages are submitted a second time and the calling process waits for the IO
to complete.  This may stall allocators waiting for contiguous memory but that
should be expected behaviour for high-order users.  It is preferable behaviour
to potentially queueing unnecessary areas for IO.  Note that kswapd will not
stall in this fashion.

[apw@shadowen.org: update to version 2]
[apw@shadowen.org: update to version 3]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   60 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~wait-for-page-writeback-when-directly-reclaiming-contiguous-areas mm/vmscan.c
--- a/mm/vmscan.c~wait-for-page-writeback-when-directly-reclaiming-contiguous-areas
+++ a/mm/vmscan.c
@@ -271,6 +271,12 @@ static void handle_write_error(struct ad
 	unlock_page(page);
 }
 
+/* Request for sync pageout. */
+enum pageout_io {
+	PAGEOUT_IO_ASYNC,
+	PAGEOUT_IO_SYNC,
+};
+
 /* possible outcome of pageout() */
 typedef enum {
 	/* failed to write page out, page is locked */
@@ -287,7 +293,8 @@ typedef enum {
  * pageout is called by shrink_page_list() for each dirty page.
  * Calls ->writepage().
  */
-static pageout_t pageout(struct page *page, struct address_space *mapping)
+static pageout_t pageout(struct page *page, struct address_space *mapping,
+						enum pageout_io sync_writeback)
 {
 	/*
 	 * If the page is dirty, only perform writeback if that write
@@ -346,6 +353,15 @@ static pageout_t pageout(struct page *pa
 			ClearPageReclaim(page);
 			return PAGE_ACTIVATE;
 		}
+
+		/*
+		 * Wait on writeback if requested to. This happens when
+		 * direct reclaiming a large contiguous area and the
+		 * first attempt to free a range of pages fails.
+		 */
+		if (PageWriteback(page) && sync_writeback == PAGEOUT_IO_SYNC)
+			wait_on_page_writeback(page);
+
 		if (!PageWriteback(page)) {
 			/* synchronous write or broken a_ops? */
 			ClearPageReclaim(page);
@@ -423,7 +439,8 @@ cannot_free:
  * shrink_page_list() returns the number of reclaimed pages
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
-					struct scan_control *sc)
+					struct scan_control *sc,
+					enum pageout_io sync_writeback)
 {
 	LIST_HEAD(ret_pages);
 	struct pagevec freed_pvec;
@@ -458,8 +475,15 @@ static unsigned long shrink_page_list(st
 		if (page_mapped(page) || PageSwapCache(page))
 			sc->nr_scanned++;
 
-		if (PageWriteback(page))
-			goto keep_locked;
+		may_enter_fs = (sc->gfp_mask & __GFP_FS) ||
+			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
+
+		if (PageWriteback(page)) {
+			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
+				wait_on_page_writeback(page);
+			else
+				goto keep_locked;
+		}
 
 		referenced = page_referenced(page, 1);
 		/* In active use or really unfreeable?  Activate it. */
@@ -478,8 +502,6 @@ static unsigned long shrink_page_list(st
 #endif /* CONFIG_SWAP */
 
 		mapping = page_mapping(page);
-		may_enter_fs = (sc->gfp_mask & __GFP_FS) ||
-			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		/*
 		 * The page is mapped into the page tables of one or more
@@ -505,7 +527,7 @@ static unsigned long shrink_page_list(st
 				goto keep_locked;
 
 			/* Page is dirty, try to write it out here */
-			switch(pageout(page, mapping)) {
+			switch (pageout(page, mapping, sync_writeback)) {
 			case PAGE_KEEP:
 				goto keep_locked;
 			case PAGE_ACTIVATE:
@@ -786,7 +808,29 @@ static unsigned long shrink_inactive_lis
 		spin_unlock_irq(&zone->lru_lock);
 
 		nr_scanned += nr_scan;
-		nr_freed = shrink_page_list(&page_list, sc);
+		nr_freed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC);
+
+		/*
+		 * If we are direct reclaiming for contiguous pages and we do
+		 * not reclaim everything in the list, try again and wait
+		 * for IO to complete. This will stall high-order allocations
+		 * but that should be acceptable to the caller
+		 */
+		if (nr_freed < nr_taken && !current_is_kswapd() &&
+					sc->order > PAGE_ALLOC_COSTLY_ORDER) {
+			congestion_wait(WRITE, HZ/10);
+
+			/*
+			 * The attempt at page out may have made some
+			 * of the pages active, mark them inactive again.
+			 */
+			nr_active = clear_active_flags(&page_list);
+			count_vm_events(PGDEACTIVATE, nr_active);
+
+			nr_freed += shrink_page_list(&page_list, sc,
+							PAGEOUT_IO_SYNC);
+		}
+
 		nr_reclaimed += nr_freed;
 		local_irq_disable();
 		if (current_is_kswapd()) {
_

Patches currently in -mm which might be from apw@shadowen.org are

x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
pci-device-ensure-sysdata-initialised-v4.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
