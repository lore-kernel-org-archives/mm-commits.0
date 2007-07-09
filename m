From: akpm@linux-foundation.org
Subject: - allow-page_owner-to-be-set-on-any-architecture.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:59:05 -0700
Message-ID: <200707092359.l69Nx6PY021997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760359AbXGIX7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:59:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Allow PAGE_OWNER to be set on any architecture
has been removed from the -mm tree.  Its filename was
     allow-page_owner-to-be-set-on-any-architecture.patch

This patch was dropped because it was folded into page-owner-tracking-leak-detector.patch

------------------------------------------------------
Subject: Allow PAGE_OWNER to be set on any architecture
From: Mel Gorman <mel@csn.ul.ie>

Currently PAGE_OWNER depends on CONFIG_X86.  This appears to be due to
pfn_to_page() being called in an inappropriate for many memory models and
the presense of memory holes.  This patch ensures that pfn_valid() and
pfn_valid_within() is called at the appropriate places and the offsets
correctly updated so that PAGE_OWNER is safe on any architecture.

In situations where CONFIG_HOLES_IN_ZONES is set (IA64 with
VIRTUAL_MEM_MAP), there may be cases where pages allocated within a
MAX_ORDER_NR_PAGES block of pages may not be displayed in /proc/page_owner
if the hole is at the start of the block.  Addressing this would be quite
complex, perform slowly and is of no clear benefit.

Once PAGE_OWNER is allowed on all architectures, the statistics for
grouping pages by mobility that declare how many pageblocks contain mixed
page types becomes optionally available on all arches.

This patch was tested successfully on x86, x86_64, ppc64 and IA64 machines.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |   31 ++++++++++++++++++++++++-------
 lib/Kconfig.debug   |    2 +-
 2 files changed, 25 insertions(+), 8 deletions(-)

diff -puN fs/proc/proc_misc.c~allow-page_owner-to-be-set-on-any-architecture fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~allow-page_owner-to-be-set-on-any-architecture
+++ a/fs/proc/proc_misc.c
@@ -756,18 +756,35 @@ read_page_owner(struct file *file, char 
 	struct page *page;
 	char *kbuf, *modname;
 	const char *symname;
-	int ret = 0, next_idx = 1;
+	int ret = 0;
 	char namebuf[128];
 	unsigned long offset = 0, symsize;
 	int i;
 	ssize_t num_written = 0;
 	int blocktype = 0, pagetype = 0;
 
+	page = NULL;
 	pfn = min_low_pfn + *ppos;
-	page = pfn_to_page(pfn);
+
+	/* Find a valid PFN or the start of a MAX_ORDER_NR_PAGES area */
+	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
+		pfn++;
+
+	/* Find an allocated page */
 	for (; pfn < max_pfn; pfn++) {
-		if (!pfn_valid(pfn))
+		/*
+		 * If the new page is in a new MAX_ORDER_NR_PAGES area,
+		 * validate the area as existing, skip it if not
+		 */
+		if ((pfn & (MAX_ORDER_NR_PAGES - 1)) == 0 && !pfn_valid(pfn)) {
+			pfn += MAX_ORDER_NR_PAGES - 1;
 			continue;
+		}
+
+		/* Check for holes within a MAX_ORDER area */
+		if (!pfn_valid_within(pfn))
+			continue;
+
 		page = pfn_to_page(pfn);
 
 		/* Catch situations where free pages have a bad ->order  */
@@ -776,16 +793,16 @@ read_page_owner(struct file *file, char 
 				"PageOwner info inaccurate for PFN %lu\n",
 				pfn);
 
-		if (page->order >= 0)
+		/* Stop search if page is allocated and has trace info */
+		if (page->order >= 0 && page->trace[0])
 			break;
-
-		next_idx++;
 	}
 
 	if (!pfn_valid(pfn))
 		return 0;
 
-	*ppos += next_idx;
+	/* Record the next PFN to read in the file offset */
+	*ppos = (pfn - min_low_pfn) + 1;
 
 	kbuf = kmalloc(count, GFP_KERNEL);
 	if (!kbuf)
diff -puN lib/Kconfig.debug~allow-page_owner-to-be-set-on-any-architecture lib/Kconfig.debug
--- a/lib/Kconfig.debug~allow-page_owner-to-be-set-on-any-architecture
+++ a/lib/Kconfig.debug
@@ -49,7 +49,7 @@ config UNUSED_SYMBOLS
 
 config PAGE_OWNER
 	bool "Track page owner"
-	depends on DEBUG_KERNEL && X86
+	depends on DEBUG_KERNEL
 	help
 	  This keeps track of what call chain is the owner of a page, may
 	  help to find bare alloc_page(s) leaks. Eats a fair amount of memory.
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
allow-page_owner-to-be-set-on-any-architecture.patch
allow-page_owner-to-be-set-on-any-architecture-fix.patch
allow-page_owner-to-be-set-on-any-architecture-fix-fix.patch
add-debugging-aid-for-memory-initialisation-problems.patch
