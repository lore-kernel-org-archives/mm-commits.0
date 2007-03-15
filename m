From: akpm@linux-foundation.org
Subject: + fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:52:30 -0800
Message-ID: <200703151852.l2FIqWEe023391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbXCOSwm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:52:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bob.picco@hp.com, apw@shadowen.org, mel@csn.ul.ie, tony.luck@intel.com


The patch titled
     Fix corruption of memmap on IA64 SPARSEMEM when mem_section is not a power of 2
has been added to the -mm tree.  Its filename is
     fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix corruption of memmap on IA64 SPARSEMEM when mem_section is not a power of 2
From: mel@skynet.ie (Mel Gorman)

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

Signed-off-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++-
 mm/sparse.c            |   49 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2 include/linux/mmzone.h
--- a/include/linux/mmzone.h~fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2
+++ a/include/linux/mmzone.h
@@ -687,7 +687,7 @@ extern struct zone *next_zone(struct zon
 #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
 
 #define SECTION_BLOCKFLAGS_BITS \
-		((SECTION_SIZE_BITS - (MAX_ORDER-1)) * NR_PAGEBLOCK_BITS)
+		((1 << (PFN_SECTION_SHIFT - (MAX_ORDER-1))) * NR_PAGEBLOCK_BITS)
 
 #if (MAX_ORDER - 1 + PAGE_SHIFT) > SECTION_SIZE_BITS
 #error Allocator MAX_ORDER exceeds SECTION_SIZE
@@ -708,7 +708,9 @@ struct mem_section {
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
@@ -198,13 +198,15 @@ struct page *sparse_decode_mem_map(unsig
 }
 
 static int sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map)
+		unsigned long pnum, struct page *mem_map,
+		unsigned long *pageblock_bitmap)
 {
 	if (!valid_section(ms))
 		return -EINVAL;
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
 	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum);
+	ms->pageblock_flags = pageblock_bitmap;
 
 	return 1;
 }
@@ -268,6 +270,33 @@ static void __kfree_section_memmap(struc
 			   get_order(sizeof(struct page) * nr_pages));
 }
 
+static unsigned long usemap_size(void)
+{
+	unsigned long size_bytes;
+ 	size_bytes = roundup(SECTION_BLOCKFLAGS_BITS, 8) / 8;
+	size_bytes = roundup(size_bytes, sizeof(unsigned long));
+	return size_bytes;
+}
+
+static unsigned long *__kmalloc_section_usemap(void)
+{
+	return kmalloc(usemap_size(), GFP_KERNEL);
+}
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
+	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
+	return NULL;
+}
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -276,6 +305,7 @@ void sparse_init(void)
 {
 	unsigned long pnum;
 	struct page *map;
+	unsigned long *usemap;
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!valid_section_nr(pnum))
@@ -284,7 +314,13 @@ void sparse_init(void)
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
 
@@ -300,6 +336,7 @@ int sparse_add_one_section(struct zone *
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct mem_section *ms;
 	struct page *memmap;
+	unsigned long *usemap;
 	unsigned long flags;
 	int ret;
 
@@ -309,6 +346,7 @@ int sparse_add_one_section(struct zone *
 	 */
 	sparse_index_init(section_nr, pgdat->node_id);
 	memmap = __kmalloc_section_memmap(nr_pages);
+	usemap = __kmalloc_section_usemap();
 
 	pgdat_resize_lock(pgdat, &flags);
 
@@ -317,9 +355,14 @@ int sparse_add_one_section(struct zone *
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

Patches currently in -mm which might be from bob.picco@hp.com are

fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
