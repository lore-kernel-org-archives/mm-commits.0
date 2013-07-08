From: akpm@linux-foundation.org
Subject: [merged]
 mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:18 -0700
Message-ID: <51db1296.7+bKM3ZJ3EKkqH4r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3GHT1S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, takata@linux-m32r.org, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,takata@linux-m32r.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:18 -0700


The patch titled
     Subject: mm/m32r: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/m32r: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/discontig.c |    6 ----
 arch/m32r/mm/init.c      |   49 +++----------------------------------
 2 files changed, 6 insertions(+), 49 deletions(-)

diff -puN arch/m32r/mm/discontig.c~mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/m32r/mm/discontig.c
@@ -129,11 +129,10 @@ unsigned long __init setup_memory(void)
 #define START_PFN(nid)		(NODE_DATA(nid)->bdata->node_min_pfn)
 #define MAX_LOW_PFN(nid)	(NODE_DATA(nid)->bdata->node_low_pfn)
 
-unsigned long __init zone_sizes_init(void)
+void __init zone_sizes_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES], zholes_size[MAX_NR_ZONES];
 	unsigned long low, start_pfn;
-	unsigned long holes = 0;
 	int nid, i;
 	mem_prof_t *mp;
 
@@ -147,7 +146,6 @@ unsigned long __init zone_sizes_init(voi
 		low = MAX_LOW_PFN(nid);
 		zones_size[ZONE_DMA] = low - start_pfn;
 		zholes_size[ZONE_DMA] = mp->holes;
-		holes += zholes_size[ZONE_DMA];
 
 		node_set_state(nid, N_NORMAL_MEMORY);
 		free_area_init_node(nid, zones_size, start_pfn, zholes_size);
@@ -161,6 +159,4 @@ unsigned long __init zone_sizes_init(voi
 	NODE_DATA(1)->node_zones->watermark[WMARK_MIN] = 0;
 	NODE_DATA(1)->node_zones->watermark[WMARK_LOW] = 0;
 	NODE_DATA(1)->node_zones->watermark[WMARK_HIGH] = 0;
-
-	return holes;
 }
diff -puN arch/m32r/mm/init.c~mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/m32r/mm/init.c
@@ -40,7 +40,6 @@ unsigned long mmu_context_cache_dat;
 #else
 unsigned long mmu_context_cache_dat[NR_CPUS];
 #endif
-static unsigned long hole_pages;
 
 /*
  * function prototype
@@ -57,7 +56,7 @@ void free_initrd_mem(unsigned long, unsi
 #define MAX_LOW_PFN(nid)	(NODE_DATA(nid)->bdata->node_low_pfn)
 
 #ifndef CONFIG_DISCONTIGMEM
-unsigned long __init zone_sizes_init(void)
+void __init zone_sizes_init(void)
 {
 	unsigned long  zones_size[MAX_NR_ZONES] = {0, };
 	unsigned long  max_dma;
@@ -83,11 +82,9 @@ unsigned long __init zone_sizes_init(voi
 #endif /* CONFIG_MMU */
 
 	free_area_init_node(0, zones_size, start_pfn, 0);
-
-	return 0;
 }
 #else	/* CONFIG_DISCONTIGMEM */
-extern unsigned long zone_sizes_init(void);
+extern void zone_sizes_init(void);
 #endif	/* CONFIG_DISCONTIGMEM */
 
 /*======================================================================*
@@ -105,24 +102,7 @@ void __init paging_init(void)
 	for (i = 0 ; i < USER_PTRS_PER_PGD * 2 ; i++)
 		pgd_val(pg_dir[i]) = 0;
 #endif /* CONFIG_MMU */
-	hole_pages = zone_sizes_init();
-}
-
-int __init reservedpages_count(void)
-{
-	int reservedpages, nid, i;
-
-	reservedpages = 0;
-	for_each_online_node(nid) {
-		unsigned long flags;
-		pgdat_resize_lock(NODE_DATA(nid), &flags);
-		for (i = 0 ; i < MAX_LOW_PFN(nid) - START_PFN(nid) ; i++)
-			if (PageReserved(nid_page_nr(nid, i)))
-				reservedpages++;
-		pgdat_resize_unlock(NODE_DATA(nid), &flags);
-	}
-
-	return reservedpages;
+	zone_sizes_init();
 }
 
 /*======================================================================*
@@ -131,20 +111,13 @@ int __init reservedpages_count(void)
  *======================================================================*/
 void __init mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
 	int nid;
 #ifndef CONFIG_MMU
 	extern unsigned long memory_end;
 #endif
 
-	num_physpages = 0;
-	for_each_online_node(nid)
-		num_physpages += MAX_LOW_PFN(nid) - START_PFN(nid) + 1;
-
-	num_physpages -= hole_pages;
-
 #ifndef CONFIG_DISCONTIGMEM
-	max_mapnr = num_physpages;
+	max_mapnr = get_num_physpages();
 #endif	/* CONFIG_DISCONTIGMEM */
 
 #ifdef CONFIG_MMU
@@ -160,19 +133,7 @@ void __init mem_init(void)
 	for_each_online_node(nid)
 		free_all_bootmem_node(NODE_DATA(nid));
 
-	reservedpages = reservedpages_count() - hole_pages;
-	codesize = (unsigned long) &_etext - (unsigned long)&_text;
-	datasize = (unsigned long) &_edata - (unsigned long)&_etext;
-	initsize = (unsigned long) &__init_end - (unsigned long)&__init_begin;
