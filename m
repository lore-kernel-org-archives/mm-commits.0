From: akpm@linux-foundation.org
Subject: [merged]
 mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:32 -0700
Message-ID: <51db12a4.ED57vBsfTGlAc/gY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3GHT1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rientjes@google.com, mhocko@suse.cz, jiang.liu@huawei.com, jejb@parisc-linux.org, deller@gmx.de, liuj97@gmail.com

Subject: [merged] mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,deller@gmx.de,jejb@parisc-linux.org,jiang.liu@huawei.com,mhocko@suse.cz,rientjes@google.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:32 -0700


The patch titled
     Subject: mm/PARISC: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/PARISC: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/init.c |   47 ++--------------------------------------
 1 file changed, 3 insertions(+), 44 deletions(-)

diff -puN arch/parisc/mm/init.c~mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/parisc/mm/init.c
@@ -214,7 +214,6 @@ static void __init setup_bootmem(void)
 	mem_limit_func();       /* check for "mem=" argument */
 
 	mem_max = 0;
-	num_physpages = 0;
 	for (i = 0; i < npmem_ranges; i++) {
 		unsigned long rsize;
 
@@ -229,10 +228,8 @@ static void __init setup_bootmem(void)
 				npmem_ranges = i + 1;
 				mem_max = mem_limit;
 			}
-	        num_physpages += pmem_ranges[i].pages;
 			break;
 		}
-	    num_physpages += pmem_ranges[i].pages;
 		mem_max += rsize;
 	}
 
@@ -532,7 +529,7 @@ void free_initmem(void)
 	 * pages are no-longer executable */
 	flush_icache_range(init_begin, init_end);
 	
-	num_physpages += free_initmem_default(-1);
+	free_initmem_default(-1);
 
 	/* set up a new led state on systems shipped LED State panel */
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_BCOMPLETE);
@@ -580,8 +577,6 @@ unsigned long pcxl_dma_start __read_most
 
 void __init mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
-
 	/* Do sanity checks on page table constants */
 	BUILD_BUG_ON(PTE_ENTRY_SIZE != sizeof(pte_t));
 	BUILD_BUG_ON(PMD_ENTRY_SIZE != sizeof(pmd_t));
@@ -603,33 +598,6 @@ void __init mem_init(void)
 	}
 #endif
 
-	codesize = (unsigned long)_etext - (unsigned long)_text;
-	datasize = (unsigned long)_edata - (unsigned long)_etext;
-	initsize = (unsigned long)__init_end - (unsigned long)__init_begin;
-
-	reservedpages = 0;
-{
-	unsigned long pfn;
-#ifdef CONFIG_DISCONTIGMEM
-	int i;
-
-	for (i = 0; i < npmem_ranges; i++) {
-		for (pfn = node_start_pfn(i); pfn < node_end_pfn(i); pfn++) {
-			if (PageReserved(pfn_to_page(pfn)))
-				reservedpages++;
-		}
-	}
-#else /* !CONFIG_DISCONTIGMEM */
-	for (pfn = 0; pfn < max_pfn; pfn++) {
-		/*
-		 * Only count reserved RAM pages
-		 */
-		if (PageReserved(pfn_to_page(pfn)))
-			reservedpages++;
-	}
-#endif
-}
-
 #ifdef CONFIG_PA11
 	if (hppa_dma_ops == &pcxl_dma_ops) {
 		pcxl_dma_start = (unsigned long)SET_MAP_OFFSET(MAP_START);
@@ -643,15 +611,7 @@ void __init mem_init(void)
 	parisc_vmalloc_start = SET_MAP_OFFSET(MAP_START);
 #endif
 
-	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init)\n",
-		nr_free_pages() << (PAGE_SHIFT-10),
-		num_physpages << (PAGE_SHIFT-10),
-		codesize >> 10,
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		initsize >> 10
-	);
