From: akpm@linux-foundation.org
Subject: [merged]
 mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:56 -0700
Message-ID: <51db1280.10/wCyG4/cogT6Yd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3GHT05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, rob.herring@calxeda.com, jiang.liu@huawei.com, james.hogan@imgtec.com, liuj97@gmail.com

Subject: [merged] mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,james.hogan@imgtec.com,jiang.liu@huawei.com,rob.herring@calxeda.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:56 -0700


The patch titled
     Subject: mm/ARC: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/ARC: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>   # for arch/arc
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |   36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff -puN arch/arc/mm/init.c~mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init arch/arc/mm/init.c
--- a/arch/arc/mm/init.c~mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/arc/mm/init.c
@@ -74,7 +74,7 @@ void __init setup_arch_memory(void)
 	/* Last usable page of low mem (no HIGHMEM yet for ARC port) */
 	max_low_pfn = max_pfn = PFN_DOWN(end_mem);
 
-	max_mapnr = num_physpages = max_low_pfn - min_low_pfn;
+	max_mapnr = max_low_pfn - min_low_pfn;
 
 	/*------------- reserve kernel image -----------------------*/
 	memblock_reserve(CONFIG_LINUX_LINK_BASE,
@@ -84,7 +84,7 @@ void __init setup_arch_memory(void)
 
 	/*-------------- node setup --------------------------------*/
 	memset(zones_size, 0, sizeof(zones_size));
-	zones_size[ZONE_NORMAL] = num_physpages;
+	zones_size[ZONE_NORMAL] = max_low_pfn - min_low_pfn;
 
 	/*
 	 * We can't use the helper free_area_init(zones[]) because it uses
@@ -106,39 +106,9 @@ void __init setup_arch_memory(void)
  */
 void __init mem_init(void)
 {
-	int codesize, datasize, initsize, reserved_pages, free_pages;
-	int tmp;
-
 	high_memory = (void *)(CONFIG_LINUX_LINK_BASE + arc_mem_sz);
-
 	free_all_bootmem();
-
-	/* count all reserved pages [kernel code/data/mem_map..] */
-	reserved_pages = 0;
-	for (tmp = 0; tmp < max_mapnr; tmp++)
-		if (PageReserved(mem_map + tmp))
-			reserved_pages++;
-
-	/* XXX: nr_free_pages() is equivalent */
-	free_pages = max_mapnr - reserved_pages;
-
-	/*
-	 * For the purpose of display below, split the "reserve mem"
-	 * kernel code/data is already shown explicitly,
-	 * Show any other reservations (mem_map[ ] et al)
-	 */
-	reserved_pages -= (((unsigned int)_end - CONFIG_LINUX_LINK_BASE) >>
-								PAGE_SHIFT);
-
-	codesize = _etext - _text;
-	datasize = _end - _etext;
-	initsize = __init_end - __init_begin;
