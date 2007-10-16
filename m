From: akpm@linux-foundation.org
Subject: - add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:27 -0700
Message-ID: <200710162034.l9GKYRbH014942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966214AbXJPVt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Add a bitmap that is used to track flags affecting a block of pages
has been removed from the -mm tree.  Its filename was
     add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add a bitmap that is used to track flags affecting a block of pages
From: Mel Gorman <mel@csn.ul.ie>

Here is the latest revision of the anti-fragmentation patches.  Of particular
note in this version is special treatment of high-order atomic allocations. 
Care is taken to group them together and avoid grouping pages of other types
near them.  Artifical tests imply that it works.  I'm trying to get the
hardware together that would allow setting up of a "real" test.  If anyone
already has a setup and test that can trigger the atomic-allocation problem,
I'd appreciate a test of these patches and a report.  The second major change
is that these patches will apply cleanly with patches that implement
anti-fragmentation through zones.

kernbench shows effectively no performance difference varying between -0.2%
and +2% on a variety of test machines.  Success rates for huge page allocation
are dramatically increased.  For example, on a ppc64 machine, the vanilla
kernel was only able to allocate 1% of memory as a hugepage and this was due
to a single hugepage reserved as min_free_kbytes.  With these patches applied,
17% was allocatable as superpages.  With reclaim-related fixes from Andy
Whitcroft, it was 40% and further reclaim-related improvements should increase
this further.

Changelog Since V28
o Group high-order atomic allocations together
o It is no longer required to set min_free_kbytes to 10% of memory. A value
  of 16384 in most cases will be sufficient
o Now applied with zone-based anti-fragmentation
o Fix incorrect VM_BUG_ON within buffered_rmqueue()
o Reorder the stack so later patches do not back out work from earlier patches
o Fix bug were journal pages were being treated as movable
o Bias placement of non-movable pages to lower PFNs
o More agressive clustering of reclaimable pages in reactions to workloads
  like updatedb that flood the size of inode caches

Changelog Since V27

o Renamed anti-fragmentation to Page Clustering. Anti-fragmentation was giving
  the mistaken impression that it was the 100% solution for high order
  allocations. Instead, it greatly increases the chances high-order
  allocations will succeed and lays the foundation for defragmentation and
  memory hot-remove to work properly
o Redefine page groupings based on ability to migrate or reclaim instead of
  basing on reclaimability alone
o Get rid of spurious inits
o Per-cpu lists are no longer split up per-type. Instead the per-cpu list is
  searched for a page of the appropriate type
o Added more explanation commentary
o Fix up bug in pageblock code where bitmap was used before being initalised

Changelog Since V26
o Fix double init of lists in setup_pageset

Changelog Since V25
o Fix loop order of for_each_rclmtype_order so that order of loop matches args
o gfpflags_to_rclmtype uses gfp_t instead of unsigned long
o Rename get_pageblock_type() to get_page_rclmtype()
o Fix alignment problem in move_freepages()
o Add mechanism for assigning flags to blocks of pages instead of page->flags
o On fallback, do not examine the preferred list of free pages a second time

The purpose of these patches is to reduce external fragmentation by grouping
pages of related types together.  When pages are migrated (or reclaimed under
memory pressure), large contiguous pages will be freed.  

This patch works by categorising allocations by their ability to migrate;

Movable - The pages may be moved with the page migration mechanism. These are
	generally userspace pages. 

Reclaimable - These are allocations for some kernel caches that are
	reclaimable or allocations that are known to be very short-lived.

Unmovable - These are pages that are allocated by the kernel that
	are not trivially reclaimed. For example, the memory allocated for a
	loaded module would be in this category. By default, allocations are
	considered to be of this type

HighAtomic - These are high-order allocations belonging to callers that
	cannot sleep or perform any IO. In practice, this is restricted to
	jumbo frame allocation for network receive. It is assumed that the
	allocations are short-lived

Instead of having one MAX_ORDER-sized array of free lists in struct free_area,
there is one for each type of reclaimability.  Once a 2^MAX_ORDER block of
pages is split for a type of allocation, it is added to the free-lists for
that type, in effect reserving it.  Hence, over time, pages of the different
types can be clustered together.

When the preferred freelists are expired, the largest possible block is taken
from an alternative list.  Buddies that are split from that large block are
placed on the preferred allocation-type freelists to mitigate fragmentation.

This implementation gives best-effort for low fragmentation in all zones. 
Ideally, min_free_kbytes needs to be set to a value equal to 4 * (1 <<
(MAX_ORDER-1)) pages in most cases.  This would be 16384 on x86 and x86_64 for
example.

Our tests show that about 60-70% of physical memory can be allocated on a
desktop after a few days uptime.  In benchmarks and stress tests, we are
finding that 80% of memory is available as contiguous blocks at the end of the
test.  To compare, a standard kernel was getting < 1% of memory as large pages
on a desktop and about 8-12% of memory as large pages at the end of stress
tests.

Following this email are 12 patches that implement thie page grouping feature.
 The first patch introduces a mechanism for storing flags related to a whole
block of pages.  Then allocations are split between movable and all other
allocations.  Following that are patches to deal with per-cpu pages and make
the mechanism configurable.  The next patch moves free pages between lists
when partially allocated blocks are used for pages of another migrate type. 
The second last patch groups reclaimable kernel allocations such as inode
caches together.  The final patch related to groupings keeps high-order atomic
allocations.

The last two patches are more concerned with control of fragmentation.  The
second last patch biases placement of non-movable allocations towards the
start of memory.  This is with a view of supporting memory hot-remove of DIMMs
with higher PFNs in the future.  The biasing could be enforced a lot heavier
but it would cost.  The last patch agressively clusters reclaimable pages like
inode caches together.




The fragmentation reduction strategy needs to track if pages within a block
can be moved or reclaimed so that pages are freed to the appropriate list. 
This patch adds a bitmap for flags affecting a whole a MAX_ORDER block of
pages.

In non-SPARSEMEM configurations, the bitmap is stored in the struct zone and
allocated during initialisation.  SPARSEMEM statically allocates the bitmap in
a struct mem_section so that bitmaps do not have to be resized during memory
hotadd.  This wastes a small amount of memory per unused section (usually
sizeof(unsigned long)) but the complexity of dynamically allocating the memory
is quite high.

Additional credit to Andy Whitcroft who reviewed up an earlier implementation
of the mechanism an suggested how to make it a *lot* cleaner.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |   13 +++
 include/linux/pageblock-flags.h |   51 +++++++++++++
 mm/page_alloc.c                 |  111 ++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+)

diff -puN include/linux/mmzone.h~add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages
+++ a/include/linux/mmzone.h
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/seqlock.h>
 #include <linux/nodemask.h>
+#include <linux/pageblock-flags.h>
 #include <asm/atomic.h>
 #include <asm/page.h>
 
@@ -222,6 +223,14 @@ struct zone {
 #endif
 	struct free_area	free_area[MAX_ORDER];
 
+#ifndef CONFIG_SPARSEMEM
+	/*
+	 * Flags for a MAX_ORDER_NR_PAGES block. See pageblock-flags.h.
+	 * In SPARSEMEM, this map is stored in struct mem_section
+	 */
+	unsigned long		*pageblock_flags;
+#endif /* CONFIG_SPARSEMEM */
+
 
 	ZONE_PADDING(_pad1_)
 
@@ -720,6 +729,9 @@ extern struct zone *next_zone(struct zon
 #define PAGES_PER_SECTION       (1UL << PFN_SECTION_SHIFT)
 #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
 
+#define SECTION_BLOCKFLAGS_BITS \
+		((SECTION_SIZE_BITS - (MAX_ORDER-1)) * NR_PAGEBLOCK_BITS)
+
 #if (MAX_ORDER - 1 + PAGE_SHIFT) > SECTION_SIZE_BITS
 #error Allocator MAX_ORDER exceeds SECTION_SIZE
 #endif
@@ -739,6 +751,7 @@ struct mem_section {
 	 * before using it wrong.
 	 */
 	unsigned long section_mem_map;
+	DECLARE_BITMAP(pageblock_flags, SECTION_BLOCKFLAGS_BITS);
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
diff -puN include/linux/pageblock-flags.h~add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages
+++ a/include/linux/pageblock-flags.h
@@ -0,0 +1,51 @@
+/*
+ * Macros for manipulating and testing flags related to a
+ * MAX_ORDER_NR_PAGES block of pages.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2006
+ *
+ * Original author, Mel Gorman
+ * Major cleanups and reduction of bit operations, Andy Whitcroft
+ */
+#ifndef PAGEBLOCK_FLAGS_H
+#define PAGEBLOCK_FLAGS_H
+
+#include <linux/types.h>
+
+/* Macro to aid the definition of ranges of bits */
+#define PB_range(name, required_bits) \
+	name, name ## _end = (name + required_bits) - 1
+
+/* Bit indices that affect a whole block of pages */
+enum pageblock_bits {
+	NR_PAGEBLOCK_BITS
+};
+
+/* Forward declaration */
+struct page;
+
+/* Declarations for getting and setting flags. See mm/page_alloc.c */
+unsigned long get_pageblock_flags_group(struct page *page,
+					int start_bitidx, int end_bitidx);
+void set_pageblock_flags_group(struct page *page, unsigned long flags,
+					int start_bitidx, int end_bitidx);
+
+#define get_pageblock_flags(page) \
+			get_pageblock_flags_group(page, 0, NR_PAGEBLOCK_BITS-1)
+#define set_pageblock_flags(page) \
+			set_pageblock_flags_group(page, 0, NR_PAGEBLOCK_BITS-1)
+
+#endif	/* PAGEBLOCK_FLAGS_H */
diff -puN mm/page_alloc.c~add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages mm/page_alloc.c
--- a/mm/page_alloc.c~add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages
+++ a/mm/page_alloc.c
@@ -2931,6 +2931,41 @@ static void __meminit calculate_node_tot
 							realtotalpages);
 }
 
+#ifndef CONFIG_SPARSEMEM
+/*
+ * Calculate the size of the zone->blockflags rounded to an unsigned long
+ * Start by making sure zonesize is a multiple of MAX_ORDER-1 by rounding up
+ * Then figure 1 NR_PAGEBLOCK_BITS worth of bits per MAX_ORDER-1, finally
+ * round what is now in bits to nearest long in bits, then return it in
+ * bytes.
+ */
+static unsigned long __init usemap_size(unsigned long zonesize)
+{
+	unsigned long usemapsize;
+
+	usemapsize = roundup(zonesize, MAX_ORDER_NR_PAGES);
+	usemapsize = usemapsize >> (MAX_ORDER-1);
+	usemapsize *= NR_PAGEBLOCK_BITS;
+	usemapsize = roundup(usemapsize, 8 * sizeof(unsigned long));
+
+	return usemapsize / 8;
+}
+
+static void __init setup_usemap(struct pglist_data *pgdat,
+				struct zone *zone, unsigned long zonesize)
+{
+	unsigned long usemapsize = usemap_size(zonesize);
+	zone->pageblock_flags = NULL;
+	if (usemapsize) {
+		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
+		memset(zone->pageblock_flags, 0, usemapsize);
+	}
+}
+#else
+static void inline setup_usemap(struct pglist_data *pgdat,
+				struct zone *zone, unsigned long zonesize) {}
+#endif /* CONFIG_SPARSEMEM */
+
 /*
  * Set up the zone data structures:
  *   - mark all pages reserved
@@ -3011,6 +3046,7 @@ static void __meminit free_area_init_cor
 		if (!size)
 			continue;
 
+		setup_usemap(pgdat, zone, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
 		BUG_ON(ret);
@@ -3991,4 +4027,79 @@ EXPORT_SYMBOL(pfn_to_page);
 EXPORT_SYMBOL(page_to_pfn);
 #endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
 
+/* Return a pointer to the bitmap storing bits affecting a block of pages */
+static inline unsigned long *get_pageblock_bitmap(struct zone *zone,
+							unsigned long pfn)
+{
+#ifdef CONFIG_SPARSEMEM
+	return __pfn_to_section(pfn)->pageblock_flags;
+#else
+	return zone->pageblock_flags;
+#endif /* CONFIG_SPARSEMEM */
+}
+
+static inline int pfn_to_bitidx(struct zone *zone, unsigned long pfn)
+{
+#ifdef CONFIG_SPARSEMEM
+	pfn &= (PAGES_PER_SECTION-1);
+	return (pfn >> (MAX_ORDER-1)) * NR_PAGEBLOCK_BITS;
+#else
+	pfn = pfn - zone->zone_start_pfn;
+	return (pfn >> (MAX_ORDER-1)) * NR_PAGEBLOCK_BITS;
+#endif /* CONFIG_SPARSEMEM */
+}
+
+/**
+ * get_pageblock_flags_group - Return the requested group of flags for the MAX_ORDER_NR_PAGES block of pages
+ * @page: The page within the block of interest
+ * @start_bitidx: The first bit of interest to retrieve
+ * @end_bitidx: The last bit of interest
+ * returns pageblock_bits flags
+ */
+unsigned long get_pageblock_flags_group(struct page *page,
+					int start_bitidx, int end_bitidx)
+{
+	struct zone *zone;
+	unsigned long *bitmap;
+	unsigned long pfn, bitidx;
+	unsigned long flags = 0;
+	unsigned long value = 1;
+
+	zone = page_zone(page);
+	pfn = page_to_pfn(page);
+	bitmap = get_pageblock_bitmap(zone, pfn);
+	bitidx = pfn_to_bitidx(zone, pfn);
+
+	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
+		if (test_bit(bitidx + start_bitidx, bitmap))
+			flags |= value;
 
+	return flags;
+}
+
+/**
+ * set_pageblock_flags_group - Set the requested group of flags for a MAX_ORDER_NR_PAGES block of pages
+ * @page: The page within the block of interest
+ * @start_bitidx: The first bit of interest
+ * @end_bitidx: The last bit of interest
+ * @flags: The flags to set
+ */
+void set_pageblock_flags_group(struct page *page, unsigned long flags,
+					int start_bitidx, int end_bitidx)
+{
+	struct zone *zone;
+	unsigned long *bitmap;
+	unsigned long pfn, bitidx;
+	unsigned long value = 1;
+
+	zone = page_zone(page);
+	pfn = page_to_pfn(page);
+	bitmap = get_pageblock_bitmap(zone, pfn);
+	bitidx = pfn_to_bitidx(zone, pfn);
+
+	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
+		if (flags & value)
+			__set_bit(bitidx + start_bitidx, bitmap);
+		else
+			__clear_bit(bitidx + start_bitidx, bitmap);
+}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
