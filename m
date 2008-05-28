From: akpm@linux-foundation.org
Subject: + mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch added to -mm tree
Date: Wed, 28 May 2008 15:42:15 -0700
Message-ID: <200805282242.m4SMgGTc004025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbYE1Wmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 18:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de


The patch titled
     mm: drop unneeded pgdat argument from free_area_init_node()
has been added to the -mm tree.  Its filename is
     mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch

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
Subject: mm: drop unneeded pgdat argument from free_area_init_node()
From: Johannes Weiner <hannes@saeurebad.de>

free_area_init_node() gets passed in the node id as well as the node
descriptor.  This is redundant as the function can trivially get the node
descriptor itself by means of NODE_DATA() and the node's id.

I checked all the users and NODE_DATA() seems to be usable everywhere
from where this function is called.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/numa.c             |    2 +-
 arch/arm/mm/init.c               |    2 +-
 arch/avr32/mm/init.c             |    2 +-
 arch/cris/arch-v10/mm/init.c     |    2 +-
 arch/cris/arch-v32/mm/init.c     |    2 +-
 arch/m32r/mm/discontig.c         |    3 +--
 arch/m32r/mm/init.c              |    2 +-
 arch/m68k/mm/motorola.c          |    2 +-
 arch/m68k/mm/sun3mmu.c           |    2 +-
 arch/mips/sgi-ip27/ip27-memory.c |    3 +--
 arch/parisc/mm/init.c            |    2 +-
 arch/sparc/mm/srmmu.c            |    3 +--
 arch/sparc/mm/sun4c.c            |    3 +--
 arch/v850/kernel/setup.c         |    3 +--
 include/linux/mm.h               |    5 ++---
 mm/memory_hotplug.c              |    2 +-
 mm/page_alloc.c                  |   11 ++++++-----
 17 files changed, 23 insertions(+), 28 deletions(-)

diff -puN arch/alpha/mm/numa.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/alpha/mm/numa.c
@@ -313,7 +313,7 @@ void __init paging_init(void)
 			zones_size[ZONE_DMA] = dma_local_pfn;
 			zones_size[ZONE_NORMAL] = (end_pfn - start_pfn) - dma_local_pfn;
 		}
-		free_area_init_node(nid, NODE_DATA(nid), zones_size, start_pfn, NULL);
+		free_area_init_node(nid, zones_size, start_pfn, NULL);
 	}
 
 	/* Initialize the kernel's ZERO_PGE. */
diff -puN arch/arm/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/arm/mm/init.c
@@ -284,7 +284,7 @@ bootmem_init_node(int node, int initrd_n
 	 */
 	arch_adjust_zones(node, zone_size, zhole_size);
 
-	free_area_init_node(node, pgdat, zone_size, start_pfn, zhole_size);
+	free_area_init_node(node, zone_size, start_pfn, zhole_size);
 
 	return end_pfn;
 }
diff -puN arch/avr32/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/avr32/mm/init.c
@@ -135,7 +135,7 @@ void __init paging_init(void)
 		printk("Node %u: start_pfn = 0x%lx, low = 0x%lx\n",
 		       nid, start_pfn, low);
 
-		free_area_init_node(nid, pgdat, zones_size, start_pfn, NULL);
+		free_area_init_node(nid, zones_size, start_pfn, NULL);
 
 		printk("Node %u: mem_map starts at %p\n",
 		       pgdat->node_id, pgdat->node_mem_map);
diff -puN arch/cris/arch-v10/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/cris/arch-v10/mm/init.c
--- a/arch/cris/arch-v10/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/cris/arch-v10/mm/init.c
@@ -182,7 +182,7 @@ paging_init(void)
 	 * mem_map page array.
 	 */
 
-	free_area_init_node(0, &contig_page_data, zones_size, PAGE_OFFSET >> PAGE_SHIFT, 0);
+	free_area_init_node(0, zones_size, PAGE_OFFSET >> PAGE_SHIFT, 0);
 }
 
 /* Initialize remaps of some I/O-ports. It is important that this
diff -puN arch/cris/arch-v32/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/cris/arch-v32/mm/init.c
--- a/arch/cris/arch-v32/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/cris/arch-v32/mm/init.c
@@ -162,7 +162,7 @@ paging_init(void)
 	 * substantially higher than 0, like us (we start at PAGE_OFFSET). This
 	 * saves space in the mem_map page array.
 	 */
-	free_area_init_node(0, &contig_page_data, zones_size, PAGE_OFFSET >> PAGE_SHIFT, 0);
+	free_area_init_node(0, zones_size, PAGE_OFFSET >> PAGE_SHIFT, 0);
 
 	mem_map = contig_page_data.node_mem_map;
 }
diff -puN arch/m32r/mm/discontig.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/m32r/mm/discontig.c
@@ -147,8 +147,7 @@ unsigned long __init zone_sizes_init(voi
 		zholes_size[ZONE_DMA] = mp->holes;
 		holes += zholes_size[ZONE_DMA];
 
-		free_area_init_node(nid, NODE_DATA(nid), zones_size,
-			start_pfn, zholes_size);
+		free_area_init_node(nid, zones_size, start_pfn, zholes_size);
 	}
 
 	/*
diff -puN arch/m32r/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/m32r/mm/init.c
@@ -123,7 +123,7 @@ unsigned long __init zone_sizes_init(voi
 	start_pfn = __MEMORY_START >> PAGE_SHIFT;
 #endif /* CONFIG_MMU */
 
-	free_area_init_node(0, NODE_DATA(0), zones_size, start_pfn, 0);
+	free_area_init_node(0, zones_size, start_pfn, 0);
 
 	return 0;
 }
diff -puN arch/m68k/mm/motorola.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/m68k/mm/motorola.c
--- a/arch/m68k/mm/motorola.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/m68k/mm/motorola.c
@@ -297,7 +297,7 @@ void __init paging_init(void)
 #endif
 	for (i = 0; i < m68k_num_memory; i++) {
 		zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
-		free_area_init_node(i, pg_data_map + i, zones_size,
+		free_area_init_node(i, zones_size,
 				    m68k_memory[i].addr >> PAGE_SHIFT, NULL);
 	}
 }
diff -puN arch/m68k/mm/sun3mmu.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/m68k/mm/sun3mmu.c
--- a/arch/m68k/mm/sun3mmu.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/m68k/mm/sun3mmu.c
@@ -95,7 +95,7 @@ void __init paging_init(void)
 
 	/* I really wish I knew why the following change made things better...  -- Sam */
 /*	free_area_init(zones_size); */
-	free_area_init_node(0, NODE_DATA(0), zones_size,
+	free_area_init_node(0, zones_size,
 			    (__pa(PAGE_OFFSET) >> PAGE_SHIFT) + 1, NULL);
 
 
diff -puN arch/mips/sgi-ip27/ip27-memory.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -518,8 +518,7 @@ void __init paging_init(void)
 		pfn_t end_pfn = node_getmaxclick(node) + 1;
 
 		zones_size[ZONE_NORMAL] = end_pfn - start_pfn;
-		free_area_init_node(node, NODE_DATA(node),
-				zones_size, start_pfn, NULL);
+		free_area_init_node(node, zones_size, start_pfn, NULL);
 
 		if (end_pfn > max_low_pfn)
 			max_low_pfn = end_pfn;
diff -puN arch/parisc/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/parisc/mm/init.c
@@ -887,7 +887,7 @@ void __init paging_init(void)
 		}
 #endif
 
-		free_area_init_node(i, NODE_DATA(i), zones_size,
+		free_area_init_node(i, zones_size,
 				pmem_ranges[i].start_pfn, NULL);
 	}
 }
diff -puN arch/sparc/mm/srmmu.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/sparc/mm/srmmu.c
--- a/arch/sparc/mm/srmmu.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/sparc/mm/srmmu.c
@@ -1348,8 +1348,7 @@ void __init srmmu_paging_init(void)
 		zones_size[ZONE_HIGHMEM] = npages;
 		zholes_size[ZONE_HIGHMEM] = npages - calc_highpages();
 
-		free_area_init_node(0, &contig_page_data, zones_size,
-				    pfn_base, zholes_size);
+		free_area_init_node(0, zones_size, pfn_base, zholes_size);
 	}
 }
 
diff -puN arch/sparc/mm/sun4c.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/sparc/mm/sun4c.c
--- a/arch/sparc/mm/sun4c.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/sparc/mm/sun4c.c
@@ -2123,8 +2123,7 @@ void __init sun4c_paging_init(void)
 		zones_size[ZONE_HIGHMEM] = npages;
 		zholes_size[ZONE_HIGHMEM] = npages - calc_highpages();
 
-		free_area_init_node(0, &contig_page_data, zones_size,
-				    pfn_base, zholes_size);
+		free_area_init_node(0, zones_size, pfn_base, zholes_size);
 	}
 
 	cnt = 0;
diff -puN arch/v850/kernel/setup.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node arch/v850/kernel/setup.c
--- a/arch/v850/kernel/setup.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/arch/v850/kernel/setup.c
@@ -295,8 +295,7 @@ init_mem_alloc (unsigned long ram_start,
 #error MAX_ORDER is too large for given PAGE_OFFSET (use CONFIG_FORCE_MAX_ZONEORDER to change it)
 #endif
 	NODE_DATA(0)->node_mem_map = NULL;
-	free_area_init_node (0, NODE_DATA(0), zones_size,
-			     ADDR_TO_PAGE (PAGE_OFFSET), 0);
+	free_area_init_node(0, zones_size, ADDR_TO_PAGE (PAGE_OFFSET), 0);
 }
 
 
diff -puN include/linux/mm.h~mm-drop-unneeded-pgdat-argument-from-free_area_init_node include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/include/linux/mm.h
@@ -960,9 +960,8 @@ static inline void pgtable_page_dtor(str
 		NULL: pte_offset_kernel(pmd, address))
 
 extern void free_area_init(unsigned long * zones_size);
-extern void free_area_init_node(int nid, pg_data_t *pgdat,
-	unsigned long * zones_size, unsigned long zone_start_pfn, 
-	unsigned long *zholes_size);
+extern void free_area_init_node(int nid, unsigned long * zones_size,
+		unsigned long zone_start_pfn, unsigned long *zholes_size);
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
 /*
  * With CONFIG_ARCH_POPULATES_NODE_MAP set, an architecture may initialise its
diff -puN mm/memory_hotplug.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/mm/memory_hotplug.c
@@ -455,7 +455,7 @@ static pg_data_t *hotadd_new_pgdat(int n
 	/* we can use NODE_DATA(nid) from here */
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
-	free_area_init_node(nid, pgdat, zones_size, start_pfn, zholes_size);
+	free_area_init_node(nid, zones_size, start_pfn, zholes_size);
 
 	return pgdat;
 }
diff -puN mm/page_alloc.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-drop-unneeded-pgdat-argument-from-free_area_init_node
+++ a/mm/page_alloc.c
@@ -3478,10 +3478,11 @@ static void __init_refok alloc_node_mem_
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
 }
 
-void __paginginit free_area_init_node(int nid, struct pglist_data *pgdat,
-		unsigned long *zones_size, unsigned long node_start_pfn,
-		unsigned long *zholes_size)
+void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
+		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
+	pg_data_t *pgdat = NODE_DATA(nid);
+
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
@@ -3932,7 +3933,7 @@ void __init free_area_init_nodes(unsigne
 	setup_nr_node_ids();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
-		free_area_init_node(nid, pgdat, NULL,
+		free_area_init_node(nid, NULL,
 				find_min_pfn_for_node(nid), NULL);
 
 		/* Any memory on that node */
@@ -4003,7 +4004,7 @@ EXPORT_SYMBOL(contig_page_data);
 
 void __init free_area_init(unsigned long *zones_size)
 {
-	free_area_init_node(0, NODE_DATA(0), zones_size,
+	free_area_init_node(0, zones_size,
 			__pa(PAGE_OFFSET) >> PAGE_SHIFT, NULL);
 }
 
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch

