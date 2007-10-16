From: akpm@linux-foundation.org
Subject: - fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:52 -0700
Message-ID: <200710162034.l9GKYqkZ015001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934701AbXJPVze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, bill.irwin@oracle.com, bob.picco@hp.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix corruption of memmap on IA64 SPARSEMEM when mem_section is not a power of 2
has been removed from the -mm tree.  Its filename was
     fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix corruption of memmap on IA64 SPARSEMEM when mem_section is not a power of 2
From: Mel Gorman <mel@csn.ul.ie>

There are problems in the use of SPARSEMEM and pageblock flags that causes
problems on ia64.

The first part of the problem is that units are incorrect in
SECTION_BLOCKFLAGS_BITS computation.  This results in a map_section's
section_mem_map being treated as part of a bitmap which isn't good.  This
was evident with an invalid virtual address when mem_init attempted to free
bootmem pages while relinquishing control from the bootmem allocator.

The second part of the problem occurs because the pageblock flags bitmap is
be located with the mem_section.  The SECTIONS_PER_ROOT computation using
sizeof (mem_section) may not be a power of 2 depending on the size of the
bitmap.  This renders masks and other such things not power of 2 base. 
This issue was seen with SPARSEMEM_EXTREME on ia64.  This patch moves the
bitmap outside of mem_section and uses a pointer instead in the
mem_section.  The bitmaps are allocated when the section is being
initialised.

Note that sparse_early_usemap_alloc() does not use alloc_remap() like
sparse_early_mem_map_alloc().  The allocation required for the bitmap on
x86, the only architecture that uses alloc_remap is typically smaller than
a cache line.  alloc_remap() pads out allocations to the cache size which
would be a needless waste.

Credit to Bob Picco for identifying the original problem and effecting a
fix for the SECTION_BLOCKFLAGS_BITS calculation.  Credit to Andy Whitcroft
for devising the best way of allocating the bitmaps only when required for
the section.

[wli@holomorphy.com: warning fix]
Signed-off-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: William Irwin <bill.irwin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++--
 mm/sparse.c            |   54 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 55 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2 include/linux/mmzone.h
--- a/include/linux/mmzone.h~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2
+++ a/include/linux/mmzone.h
@@ -748,7 +748,7 @@ extern struct zone *next_zone(struct zon
 #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
 
 #define SECTION_BLOCKFLAGS_BITS \
-		((SECTION_SIZE_BITS - (MAX_ORDER-1)) * NR_PAGEBLOCK_BITS)
+		((1 << (PFN_SECTION_SHIFT - (MAX_ORDER-1))) * NR_PAGEBLOCK_BITS)
 
 #if (MAX_ORDER - 1 + PAGE_SHIFT) > SECTION_SIZE_BITS
 #error Allocator MAX_ORDER exceeds SECTION_SIZE
@@ -769,7 +769,9 @@ struct mem_section {
 	 * before using it wrong.
 	 */
 	unsigned long section_mem_map;
-	DECLARE_BITMAP(pageblock_flags, SECTION_BLOCKFLAGS_BITS);
+
+	/* See declaration of similar field in struct zone */
+	unsigned long *pageblock_flags;
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
diff -puN mm/sparse.c~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2 mm/sparse.c
--- a/mm/sparse.c~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2
+++ a/mm/sparse.c
@@ -206,7 +206,8 @@ struct page *sparse_decode_mem_map(unsig
 }
 
 static int __meminit sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map)
+		unsigned long pnum, struct page *mem_map,
+		unsigned long *pageblock_bitmap)
 {
 	if (!present_section(ms))
 		return -EINVAL;
@@ -214,6 +215,7 @@ static int __meminit sparse_init_one_sec
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
 	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum) |
 							SECTION_HAS_MEM_MAP;
+ 	ms->pageblock_flags = pageblock_bitmap;
 
 	return 1;
 }
@@ -224,6 +226,38 @@ void *alloc_bootmem_high_node(pg_data_t 
 	return NULL;
 }
 
+static unsigned long usemap_size(void)
+{
+	unsigned long size_bytes;
+	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
+	size_bytes = roundup(size_bytes, sizeof(unsigned long));
+	return size_bytes;
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+static unsigned long *__kmalloc_section_usemap(void)
+{
+	return kmalloc(usemap_size(), GFP_KERNEL);
+}
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
+static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
+{
+	unsigned long *usemap;
+	struct mem_section *ms = __nr_to_section(pnum);
+	int nid = sparse_early_nid(ms);
+
+	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	if (usemap)
+		return usemap;
+
+	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
+	nid = 0;
+
+	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
+	return NULL;
+}
+
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *sparse_early_mem_map_populate(unsigned long pnum, int nid)
 {
@@ -268,6 +302,7 @@ void __init sparse_init(void)
 {
 	unsigned long pnum;
 	struct page *map;
+	unsigned long *usemap;
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
@@ -276,7 +311,13 @@ void __init sparse_init(void)
 		map = sparse_early_mem_map_alloc(pnum);
 		if (!map)
 			continue;
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
+
+		usemap = sparse_early_usemap_alloc(pnum);
+		if (!usemap)
+			continue;
+
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
+								usemap);
 	}
 }
 
@@ -332,6 +373,7 @@ int sparse_add_one_section(struct zone *
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct mem_section *ms;
 	struct page *memmap;
+	unsigned long *usemap;
 	unsigned long flags;
 	int ret;
 
@@ -341,6 +383,7 @@ int sparse_add_one_section(struct zone *
 	 */
 	sparse_index_init(section_nr, pgdat->node_id);
 	memmap = __kmalloc_section_memmap(nr_pages);
+	usemap = __kmalloc_section_usemap();
 
 	pgdat_resize_lock(pgdat, &flags);
 
@@ -349,9 +392,14 @@ int sparse_add_one_section(struct zone *
 		ret = -EEXIST;
 		goto out;
 	}
+
+	if (!usemap) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
-	ret = sparse_init_one_section(ms, section_nr, memmap);
+	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
 
 out:
 	pgdat_resize_unlock(pgdat, &flags);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
