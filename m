From: akpm@linux-foundation.org
Subject: + bootmem-replace-node_boot_start-in-struct-bootmem_data.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:45 -0700
Message-ID: <200806082335.m58NZjXo025634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbYFHXgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, hannes@saeureba.de, linux-arch@vger.kernel.org


The patch titled
     bootmem: replace node_boot_start in struct bootmem_data
has been added to the -mm tree.  Its filename is
     bootmem-replace-node_boot_start-in-struct-bootmem_data.patch

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
Subject: bootmem: replace node_boot_start in struct bootmem_data
From: Johannes Weiner <hannes@saeurebad.de>

Almost all users of this field need a PFN instead of a physical address,
so replace node_boot_start with node_min_pfn.

Signed-off-by: Johannes Weiner <hannes@saeureba.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/numa.c     |    2 -
 arch/arm/plat-omap/fb.c  |    4 ---
 arch/avr32/mm/init.c     |    3 --
 arch/ia64/mm/discontig.c |   19 +++++++++---------
 arch/m32r/mm/discontig.c |    3 --
 arch/m32r/mm/init.c      |    4 ---
 arch/mn10300/mm/init.c   |    6 ++---
 arch/sh/mm/init.c        |    2 -
 include/linux/bootmem.h  |    2 -
 mm/bootmem.c             |   39 ++++++++++++++++++-------------------
 10 files changed, 40 insertions(+), 44 deletions(-)

diff -puN arch/alpha/mm/numa.c~bootmem-replace-node_boot_start-in-struct-bootmem_data arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/arch/alpha/mm/numa.c
@@ -304,7 +304,7 @@ void __init paging_init(void)
 
 	for_each_online_node(nid) {
 		bootmem_data_t *bdata = &bootmem_node_data[nid];
-		unsigned long start_pfn = bdata->node_boot_start >> PAGE_SHIFT;
+		unsigned long start_pfn = bdata->node_min_pfn;
 		unsigned long end_pfn = bdata->node_low_pfn;
 
 		if (dma_local_pfn >= end_pfn - start_pfn)
diff -puN arch/arm/plat-omap/fb.c~bootmem-replace-node_boot_start-in-struct-bootmem_data arch/arm/plat-omap/fb.c
--- a/arch/arm/plat-omap/fb.c~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/arch/arm/plat-omap/fb.c
@@ -182,7 +182,7 @@ void __init omapfb_reserve_sdram(void)
 		return;
 
 	bdata = NODE_DATA(0)->bdata;
-	sdram_start = bdata->node_boot_start;
+	sdram_start = bdata->node_min_pfn << PAGE_SHIFT;
 	sdram_size = (bdata->node_low_pfn << PAGE_SHIFT) - sdram_start;
 	reserved = 0;
 	for (i = 0; ; i++) {
@@ -340,5 +340,3 @@ unsigned long omapfb_reserve_sram(unsign
 
 
 #endif
-
-
diff -puN arch/avr32/mm/init.c~bootmem-replace-node_boot_start-in-struct-bootmem_data arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/arch/avr32/mm/init.c
@@ -125,8 +125,7 @@ void __init paging_init(void)
 		unsigned long zones_size[MAX_NR_ZONES];
 		unsigned long low, start_pfn;
 
-		start_pfn = pgdat->bdata->node_boot_start;
-		start_pfn >>= PAGE_SHIFT;
+		start_pfn = pgdat->bdata->node_min_pfn;
 		low = pgdat->bdata->node_low_pfn;
 
 		memset(zones_size, 0, sizeof(zones_size));
diff -puN arch/ia64/mm/discontig.c~bootmem-replace-node_boot_start-in-struct-bootmem_data arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/arch/ia64/mm/discontig.c
@@ -74,17 +74,17 @@ pg_data_t *pgdat_list[MAX_NUMNODES];
 static int __init build_node_maps(unsigned long start, unsigned long len,
 				  int node)
 {
-	unsigned long cstart, epfn, end = start + len;
+	unsigned long spfn, epfn, end = start + len;
 	struct bootmem_data *bdp = &bootmem_node_data[node];
 
 	epfn = GRANULEROUNDUP(end) >> PAGE_SHIFT;
-	cstart = GRANULEROUNDDOWN(start);
+	spfn = GRANULEROUNDDOWN(start) >> PAGE_SHIFT;
 
 	if (!bdp->node_low_pfn) {
-		bdp->node_boot_start = cstart;
+		bdp->node_min_pfn = spfn;
 		bdp->node_low_pfn = epfn;
 	} else {
-		bdp->node_boot_start = min(cstart, bdp->node_boot_start);
+		bdp->node_min_pfn = min(spfn, bdp->node_min_pfn);
 		bdp->node_low_pfn = max(epfn, bdp->node_low_pfn);
 	}
 
@@ -221,20 +221,21 @@ static void __init fill_pernode(int node
 static int __init find_pernode_space(unsigned long start, unsigned long len,
 				     int node)
 {
-	unsigned long epfn;
+	unsigned long spfn, epfn;
 	unsigned long pernodesize = 0, pernode, pages, mapsize;
 	struct bootmem_data *bdp = &bootmem_node_data[node];
 
+	spfn = start >> PAGE_SHIFT;
 	epfn = (start + len) >> PAGE_SHIFT;
 
-	pages = bdp->node_low_pfn - (bdp->node_boot_start >> PAGE_SHIFT);
+	pages = bdp->node_low_pfn - bdp->node_min_pfn;
 	mapsize = bootmem_bootmap_pages(pages) << PAGE_SHIFT;
 
 	/*
 	 * Make sure this memory falls within this node's usable memory
 	 * since we may have thrown some away in build_maps().
 	 */
-	if (start < bdp->node_boot_start || epfn > bdp->node_low_pfn)
+	if (spfn < bdp->node_min_pfn || epfn > bdp->node_low_pfn)
 		return 0;
 
 	/* Don't setup this node's local space twice... */
@@ -296,7 +297,7 @@ static void __init reserve_pernode_space
 		bdp = pdp->bdata;
 
 		/* First the bootmem_map itself */
-		pages = bdp->node_low_pfn - (bdp->node_boot_start>>PAGE_SHIFT);
+		pages = bdp->node_low_pfn - bdp->node_min_pfn;
 		size = bootmem_bootmap_pages(pages) << PAGE_SHIFT;
 		base = __pa(bdp->node_bootmem_map);
 		reserve_bootmem_node(pdp, base, size, BOOTMEM_DEFAULT);
@@ -466,7 +467,7 @@ void __init find_memory(void)
 
 		init_bootmem_node(pgdat_list[node],
 				  map>>PAGE_SHIFT,
-				  bdp->node_boot_start>>PAGE_SHIFT,
+				  bdp->node_min_pfn,
 				  bdp->node_low_pfn);
 	}
 
diff -puN arch/m32r/mm/discontig.c~bootmem-replace-node_boot_start-in-struct-bootmem_data arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/arch/m32r/mm/discontig.c
@@ -123,8 +123,7 @@ unsigned long __init setup_memory(void)
 	return max_low_pfn;
 }
 
-#define START_PFN(nid)	\
-	(NODE_DATA(nid)->bdata->node_boot_start >> PAGE_SHIFT)
+#define START_PFN(nid)		(NODE_DATA(nid)->bdata->node_min_pfn)
 #define MAX_LOW_PFN(nid)	(NODE_DATA(nid)->bdata->node_low_pfn)
 
 unsigned long __init zone_sizes_init(void)
diff -puN arch/m32r/mm/init.c~bootmem-replace-node_boot_start-in-struct-bootmem_data arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/arch/m32r/mm/init.c
@@ -93,8 +93,7 @@ void free_initrd_mem(unsigned long, unsi
 #endif
 
 /* It'd be good if these lines were in the standard header file. */
-#define START_PFN(nid)	\
-	(NODE_DATA(nid)->bdata->node_boot_start >> PAGE_SHIFT)
+#define START_PFN(nid)		(NODE_DATA(nid)->bdata->node_min_pfn)
 #define MAX_LOW_PFN(nid)	(NODE_DATA(nid)->bdata->node_low_pfn)
 
 #ifndef CONFIG_DISCONTIGMEM
@@ -252,4 +251,3 @@ void free_initrd_mem(unsigned long start
 	printk (KERN_INFO "Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
 }
 #endif
-
diff -puN arch/mn10300/mm/init.c~bootmem-replace-node_boot_start-in-struct-bootmem_data arch/mn10300/mm/init.c
--- a/arch/mn10300/mm/init.c~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/arch/mn10300/mm/init.c
@@ -67,8 +67,8 @@ void __init paging_init(void)
 
 	/* declare the sizes of the RAM zones (only use the normal zone) */
 	zones_size[ZONE_NORMAL] =
-		(contig_page_data.bdata->node_low_pfn) -
-		(contig_page_data.bdata->node_boot_start >> PAGE_SHIFT);
+		contig_page_data.bdata->node_low_pfn -
+		contig_page_data.bdata->node_min_pfn;
 
 	/* pass the memory from the bootmem allocator to the main allocator */
 	free_area_init(zones_size);
@@ -87,7 +87,7 @@ void __init mem_init(void)
 	if (!mem_map)
 		BUG();
 
-#define START_PFN	(contig_page_data.bdata->node_boot_start >> PAGE_SHIFT)
+#define START_PFN	(contig_page_data.bdata->node_min_pfn)
 #define MAX_LOW_PFN	(contig_page_data.bdata->node_low_pfn)
 
 	max_mapnr = num_physpages = MAX_LOW_PFN - START_PFN;
diff -puN arch/sh/mm/init.c~bootmem-replace-node_boot_start-in-struct-bootmem_data arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/arch/sh/mm/init.c
@@ -191,7 +191,7 @@ void __init paging_init(void)
 		pg_data_t *pgdat = NODE_DATA(nid);
 		unsigned long low, start_pfn;
 
-		start_pfn = pgdat->bdata->node_boot_start >> PAGE_SHIFT;
+		start_pfn = pgdat->bdata->node_min_pfn;
 		low = pgdat->bdata->node_low_pfn;
 
 		if (max_zone_pfns[ZONE_NORMAL] < low)
diff -puN include/linux/bootmem.h~bootmem-replace-node_boot_start-in-struct-bootmem_data include/linux/bootmem.h
--- a/include/linux/bootmem.h~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/include/linux/bootmem.h
@@ -28,7 +28,7 @@ extern unsigned long saved_max_pfn;
  * memory pages (including holes) on the node.
  */
 typedef struct bootmem_data {
-	unsigned long node_boot_start;
+	unsigned long node_min_pfn;
 	unsigned long node_low_pfn;
 	void *node_bootmem_map;
 	unsigned long last_end_off;
diff -puN mm/bootmem.c~bootmem-replace-node_boot_start-in-struct-bootmem_data mm/bootmem.c
--- a/mm/bootmem.c~bootmem-replace-node_boot_start-in-struct-bootmem_data
+++ a/mm/bootmem.c
@@ -80,7 +80,7 @@ static void __init link_bootmem(bootmem_
 		bootmem_data_t *ent;
 
 		ent = list_entry(iter, bootmem_data_t, list);
-		if (bdata->node_boot_start < ent->node_boot_start)
+		if (bdata->node_min_pfn < ent->node_min_pfn)
 			break;
 	}
 	list_add_tail(&bdata->list, iter);
@@ -96,7 +96,7 @@ static unsigned long __init init_bootmem
 
 	mminit_validate_memmodel_limits(&start, &end);
 	bdata->node_bootmem_map = phys_to_virt(PFN_PHYS(mapstart));
-	bdata->node_boot_start = PFN_PHYS(start);
+	bdata->node_min_pfn = start;
 	bdata->node_low_pfn = end;
 	link_bootmem(bdata);
 
@@ -151,7 +151,7 @@ static unsigned long __init free_all_boo
 	if (!bdata->node_bootmem_map)
 		return 0;
 
-	start = PFN_DOWN(bdata->node_boot_start);
+	start = bdata->node_min_pfn;
 	end = bdata->node_low_pfn;
 
 	/*
@@ -167,7 +167,7 @@ static unsigned long __init free_all_boo
 		unsigned long *map, idx, vec;
 
 		map = bdata->node_bootmem_map;
-		idx = start - PFN_DOWN(bdata->node_boot_start);
+		idx = start - bdata->node_min_pfn;
 		vec = ~map[idx / BITS_PER_LONG];
 
 		if (aligned && vec == ~0UL && start + BITS_PER_LONG < end) {
@@ -192,7 +192,7 @@ static unsigned long __init free_all_boo
 	}
 
 	page = virt_to_page(bdata->node_bootmem_map);
-	pages = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+	pages = bdata->node_low_pfn - bdata->node_min_pfn;
 	pages = bootmem_bootmap_pages(pages);
 	count += pages;
 	while (pages--)
@@ -231,8 +231,8 @@ static void __init __free(bootmem_data_t
 	unsigned long idx;
 
 	bdebug("nid=%d start=%lx end=%lx\n", bdata - bootmem_node_data,
-		sidx + PFN_DOWN(bdata->node_boot_start),
-		eidx + PFN_DOWN(bdata->node_boot_start));
+		sidx + bdata->node_min_pfn,
+		eidx + bdata->node_min_pfn);
 
 	if (bdata->hint_idx > sidx)
 		bdata->hint_idx = sidx;
@@ -250,8 +250,8 @@ static int __init __reserve(bootmem_data
 
 	bdebug("nid=%d start=%lx end=%lx flags=%x\n",
 		bdata - bootmem_node_data,
-		sidx + PFN_DOWN(bdata->node_boot_start),
-		eidx + PFN_DOWN(bdata->node_boot_start),
+		sidx + bdata->node_min_pfn,
+		eidx + bdata->node_min_pfn,
 		flags);
 
 	for (idx = sidx; idx < eidx; idx++)
@@ -261,7 +261,7 @@ static int __init __reserve(bootmem_data
 				return -EBUSY;
 			}
 			bdebug("silent double reserve of PFN %lx\n",
-				idx + PFN_DOWN(bdata->node_boot_start));
+				idx + bdata->node_min_pfn);
 		}
 	return 0;
 }
@@ -275,11 +275,11 @@ static int __init mark_bootmem_node(boot
 	bdebug("nid=%d start=%lx end=%lx reserve=%d flags=%x\n",
 		bdata - bootmem_node_data, start, end, reserve, flags);
 
-	BUG_ON(start < PFN_DOWN(bdata->node_boot_start));
+	BUG_ON(start < bdata->node_min_pfn);
 	BUG_ON(end > bdata->node_low_pfn);
 
-	sidx = start - PFN_DOWN(bdata->node_boot_start);
-	eidx = end - PFN_DOWN(bdata->node_boot_start);
+	sidx = start - bdata->node_min_pfn;
+	eidx = end - bdata->node_min_pfn;
 
 	if (reserve)
 		return __reserve(bdata, sidx, eidx, flags);
@@ -299,7 +299,7 @@ static int __init mark_bootmem(unsigned 
 		int err;
 		unsigned long max;
 
-		if (pos < PFN_DOWN(bdata->node_boot_start)) {
+		if (pos < bdata->node_min_pfn) {
 			BUG_ON(pos != start);
 			continue;
 		}
@@ -422,7 +422,7 @@ static void * __init alloc_bootmem_core(
 		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
 		align, goal, limit);
 
-	min = PFN_DOWN(bdata->node_boot_start);
+	min = bdata->node_min_pfn;
 	max = bdata->node_low_pfn;
 
 	goal >>= PAGE_SHIFT;
@@ -440,8 +440,8 @@ static void * __init alloc_bootmem_core(
 	else
 		start = ALIGN(min, step);
 
-	sidx = start - PFN_DOWN(bdata->node_boot_start);
-	midx = max - PFN_DOWN(bdata->node_boot_start);
+	sidx = start - bdata->node_min_pfn;;
+	midx = max - bdata->node_min_pfn;
 
 	if (bdata->hint_idx > sidx) {
 		/*
@@ -491,7 +491,8 @@ find_block:
 				PFN_UP(end_off), BOOTMEM_EXCLUSIVE))
 			BUG();
 
-		region = phys_to_virt(bdata->node_boot_start + start_off);
+		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
+				start_off);
 		memset(region, 0, size);
 		return region;
 	}
@@ -518,7 +519,7 @@ restart:
 
 		if (goal && bdata->node_low_pfn <= PFN_DOWN(goal))
 			continue;
-		if (limit && bdata->node_boot_start >= limit)
+		if (limit && bdata->node_min_pfn >= PFN_DOWN(limit))
 			break;
 
 		region = alloc_bootmem_core(bdata, size, align, goal, limit);
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
bootmem-clean-up-bootmemc-file-header.patch
bootmem-add-documentation-to-api-functions.patch
bootmem-add-debugging-framework.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch

