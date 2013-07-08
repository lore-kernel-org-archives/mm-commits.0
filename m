From: akpm@linux-foundation.org
Subject: [merged]
 mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:34 -0700
Message-ID: <51db12a6.gPAMYD7B701GaqFK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3GHT1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulus@samba.org, jiang.liu@huawei.com, benh@kernel.crashing.org, liuj97@gmail.com

Subject: [merged] mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,benh@kernel.crashing.org,jiang.liu@huawei.com,paulus@samba.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:34 -0700


The patch titled
     Subject: mm/ppc: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/ppc: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |   56 ++++++++--------------------------------
 1 file changed, 12 insertions(+), 44 deletions(-)

diff -puN arch/powerpc/mm/mem.c~mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/powerpc/mm/mem.c
@@ -299,46 +299,27 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-	int nid;
-#endif
-	pg_data_t *pgdat;
-	unsigned long i;
-	struct page *page;
-	unsigned long reservedpages = 0, codesize, initsize, datasize, bsssize;
-
 #ifdef CONFIG_SWIOTLB
 	swiotlb_init(0);
 #endif
 
-	num_physpages = memblock_phys_mem_size() >> PAGE_SHIFT;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-        for_each_online_node(nid) {
-		if (NODE_DATA(nid)->node_spanned_pages != 0) {
-			printk("freeing bootmem node %d\n", nid);
-			free_all_bootmem_node(NODE_DATA(nid));
-		}
+	{
+		pg_data_t *pgdat;
+
+		for_each_online_pgdat(pgdat)
+			if (pgdat->node_spanned_pages != 0) {
+				printk("freeing bootmem node %d\n",
+					pgdat->node_id);
+				free_all_bootmem_node(pgdat);
+			}
 	}
 #else
 	max_mapnr = max_pfn;
 	free_all_bootmem();
 #endif
-	for_each_online_pgdat(pgdat) {
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			if (!pfn_valid(pgdat->node_start_pfn + i))
-				continue;
-			page = pgdat_page_nr(pgdat, i);
-			if (PageReserved(page))
-				reservedpages++;
-		}
-	}
-
-	codesize = (unsigned long)&_sdata - (unsigned long)&_stext;
-	datasize = (unsigned long)&_edata - (unsigned long)&_sdata;
-	initsize = (unsigned long)&__init_end - (unsigned long)&__init_begin;
-	bsssize = (unsigned long)&__bss_stop - (unsigned long)&__bss_start;
 
 #ifdef CONFIG_HIGHMEM
 	{
@@ -348,13 +329,9 @@ void __init mem_init(void)
 		for (pfn = highmem_mapnr; pfn < max_mapnr; ++pfn) {
 			phys_addr_t paddr = (phys_addr_t)pfn << PAGE_SHIFT;
 			struct page *page = pfn_to_page(pfn);
-			if (memblock_is_reserved(paddr))
-				continue;
-			free_highmem_page(page);
-			reservedpages--;
+			if (!memblock_is_reserved(paddr))
+				free_highmem_page(page);
 		}
-		printk(KERN_DEBUG "High memory: %luk\n",
-		       totalhigh_pages << (PAGE_SHIFT-10));
 	}
 #endif /* CONFIG_HIGHMEM */
 
@@ -367,16 +344,7 @@ void __init mem_init(void)
 		(mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) - 1;
 #endif
 
-	printk(KERN_INFO "Memory: %luk/%luk available (%luk kernel code, "
-	       "%luk reserved, %luk data, %luk bss, %luk init)\n",
-		nr_free_pages() << (PAGE_SHIFT-10),
-		num_physpages << (PAGE_SHIFT-10),
-		codesize >> 10,
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		bsssize >> 10,
-		initsize >> 10);
