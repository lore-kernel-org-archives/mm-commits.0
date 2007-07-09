From: akpm@linux-foundation.org
Subject: - print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:59:03 -0700
Message-ID: <200707092359.l69Nx3lR021994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760306AbXGIX7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Print out PAGE_OWNER statistics in relation to fragmentation avoidance
has been removed from the -mm tree.  Its filename was
     print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch

This patch was dropped because it was folded into page-owner-tracking-leak-detector.patch

------------------------------------------------------
Subject: Print out PAGE_OWNER statistics in relation to fragmentation avoidance
From: Mel Gorman <mel@csn.ul.ie>

When PAGE_OWNER is set, more information is available of relevance to
fragmentation avoidance.  A second line is added to /proc/page_owner showing
the PFN, the pageblock number, the mobility type of the page based on its
allocation flags, whether the allocation is improperly placed and the flags. 
A sample entry looks like

Page allocated via order 0, mask 0x1280d2
PFN 7355 Block 7 type 3 Fallback Flags      LA
[0xc01528c6] __handle_mm_fault+598
[0xc0320427] do_page_fault+279
[0xc031ed9a] error_code+114

This information can be used to identify pages that are improperly placed.  As
the format of PAGE_OWNER data is now different, the comment at the top of
Documentation/page_owner.c is updated with new instructions.

As PAGE_OWNER tracks the GFP flags used to allocate the pages,
/proc/pagetypeinfo is enhanced to contain how many mixed blocks exist.  The
additional output looks like

Number of mixed blocks    Unmovable  Reclaimable      Movable      Reserve
Node 0, zone      DMA            0            1            2            1
Node 0, zone   Normal            2           11           33            0

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/page_owner.c |    3 -
 fs/proc/proc_misc.c        |   28 ++++++++++
 mm/vmstat.c                |   93 +++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+), 1 deletion(-)

diff -puN Documentation/page_owner.c~print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance Documentation/page_owner.c
--- a/Documentation/page_owner.c~print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance
+++ a/Documentation/page_owner.c
@@ -2,7 +2,8 @@
  * User-space helper to sort the output of /proc/page_owner
  *
  * Example use:
- * cat /proc/page_owner > page_owner.txt
+ * cat /proc/page_owner > page_owner_full.txt
+ * grep -v ^PFN page_owner_full.txt > page_owner.txt
  * ./sort page_owner.txt sorted_page_owner.txt
 */
 
diff -puN fs/proc/proc_misc.c~print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance
+++ a/fs/proc/proc_misc.c
@@ -761,6 +761,7 @@ read_page_owner(struct file *file, char 
 	unsigned long offset = 0, symsize;
 	int i;
 	ssize_t num_written = 0;
+	int blocktype = 0, pagetype = 0;
 
 	pfn = min_low_pfn + *ppos;
 	page = pfn_to_page(pfn);
@@ -797,6 +798,33 @@ read_page_owner(struct file *file, char 
 		goto out;
 	}
 
+	/* Print information relevant to grouping pages by mobility */
+	blocktype = get_pageblock_migratetype(page);
+	pagetype  = allocflags_to_migratetype(page->gfp_mask);
+	ret += snprintf(kbuf+ret, count-ret,
+			"PFN %lu Block %lu type %d %s "
+			"Flags %s%s%s%s%s%s%s%s%s%s%s%s\n",
+			pfn,
+			pfn >> pageblock_order,
+			blocktype,
+			blocktype != pagetype ? "Fallback" : "        ",
+			PageLocked(page)	? "K" : " ",
+			PageError(page)		? "E" : " ",
+			PageReferenced(page)	? "R" : " ",
+			PageUptodate(page)	? "U" : " ",
+			PageDirty(page)		? "D" : " ",
+			PageLRU(page)		? "L" : " ",
+			PageActive(page)	? "A" : " ",
+			PageSlab(page)		? "S" : " ",
+			PageWriteback(page)	? "W" : " ",
+			PageCompound(page)	? "C" : " ",
+			PageSwapCache(page)	? "B" : " ",
+			PageMappedToDisk(page)	? "M" : " ");
+	if (ret >= count) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	num_written = ret;
 
 	for (i = 0; i < 8; i++) {
diff -puN mm/vmstat.c~print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance mm/vmstat.c
--- a/mm/vmstat.c~print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance
+++ a/mm/vmstat.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>
+#include "internal.h"
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -552,6 +553,97 @@ static int pagetypeinfo_showblockcount(s
 	return 0;
 }
 
+#ifdef CONFIG_PAGE_OWNER
+static void pagetypeinfo_showmixedcount_print(struct seq_file *m,
+							pg_data_t *pgdat,
+							struct zone *zone)
+{
+	int mtype, pagetype;
+	unsigned long pfn;
+	unsigned long start_pfn = zone->zone_start_pfn;
+	unsigned long end_pfn = start_pfn + zone->spanned_pages;
+	unsigned long count[MIGRATE_TYPES] = { 0, };
+
+	/* Align PFNs to pageblock_nr_pages boundary */
+	pfn = start_pfn & ~(pageblock_nr_pages-1);
+
+	/*
+	 * Walk the zone in pageblock_nr_pages steps. If a page block spans
+	 * a zone boundary, it will be double counted between zones. This does
+	 * not matter as the mixed block count will still be correct
+	 */
+	for (; pfn < end_pfn; pfn += pageblock_nr_pages) {
+		struct page *page;
+		unsigned long offset = 0;
+
+		/* Do not read before the zone start, use a valid page */
+		if (pfn < start_pfn)
+			offset = start_pfn - pfn;
+
+		if (!pfn_valid(pfn + offset))
+			continue;
+
+		page = pfn_to_page(pfn + offset);
+		mtype = get_pageblock_migratetype(page);
+
+		/* Check the block for bad migrate types */
+		for (; offset < pageblock_nr_pages; offset++) {
+			/* Do not past the end of the zone */
+			if (pfn + offset >= end_pfn)
+				break;
+
+			if (!pfn_valid_within(pfn + offset))
+				continue;
+
+			page = pfn_to_page(pfn + offset);
+
+			/* Skip free pages */
+			if (PageBuddy(page)) {
+				offset += (1UL << page_order(page)) - 1UL;
+				continue;
+			}
+			if (page->order < 0)
+				continue;
+
+			pagetype = allocflags_to_migratetype(page->gfp_mask);
+			if (pagetype != mtype) {
+				count[mtype]++;
+				break;
+			}
+
+			/* Move to end of this allocation */
+			offset += (1 << page->order) - 1;
+		}
+	}
+
+	/* Print counts */
+	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
+	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
+		seq_printf(m, "%12lu ", count[mtype]);
+	seq_putc(m, '\n');
+}
+#endif /* CONFIG_PAGE_OWNER */
+
+/*
+ * Print out the number of pageblocks for each migratetype that contain pages
+ * of other types. This gives an indication of how well fallbacks are being
+ * contained by rmqueue_fallback(). It requires information from PAGE_OWNER
+ * to determine what is going on
+ */
+static void pagetypeinfo_showmixedcount(struct seq_file *m, pg_data_t *pgdat)
+{
+#ifdef CONFIG_PAGE_OWNER
+	int mtype;
+
+	seq_printf(m, "\n%-23s", "Number of mixed blocks ");
+	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++)
+		seq_printf(m, "%12s ", migratetype_names[mtype]);
+	seq_putc(m, '\n');
+
+	walk_zones_in_node(m, pgdat, pagetypeinfo_showmixedcount_print);
+#endif /* CONFIG_PAGE_OWNER */
+}
+
 /*
  * This prints out statistics in relation to grouping pages by mobility.
  * It is expensive to collect so do not constantly read the file.
@@ -565,6 +657,7 @@ static int pagetypeinfo_show(struct seq_
 	seq_putc(m, '\n');
 	pagetypeinfo_showfree(m, pgdat);
 	pagetypeinfo_showblockcount(m, pgdat);
+	pagetypeinfo_showmixedcount(m, pgdat);
 
 	return 0;
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
allow-page_owner-to-be-set-on-any-architecture.patch
allow-page_owner-to-be-set-on-any-architecture-fix.patch
allow-page_owner-to-be-set-on-any-architecture-fix-fix.patch
add-debugging-aid-for-memory-initialisation-problems.patch
