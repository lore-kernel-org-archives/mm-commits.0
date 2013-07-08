From: akpm@linux-foundation.org
Subject: [merged]
 mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:00 -0700
Message-ID: <51db1284.CeueU9oOpZI8iURn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3GHT1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, linux@arm.linux.org.uk, jiang.liu@huawei.com, catalin.marinas@arm.com, liuj97@gmail.com

Subject: [merged] mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,catalin.marinas@arm.com,jiang.liu@huawei.com,linux@arm.linux.org.uk,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:00 -0700


The patch titled
     Subject: mm/ARM64: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/ARM64: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c |   48 ++---------------------------------------
 1 file changed, 3 insertions(+), 45 deletions(-)

diff -puN arch/arm64/mm/init.c~mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/arm64/mm/init.c
@@ -272,59 +272,17 @@ static void __init free_unused_memmap(vo
  */
 void __init mem_init(void)
 {
-	unsigned long reserved_pages, free_pages;
-	struct memblock_region *reg;
-
 	arm64_swiotlb_init();
 
 	max_mapnr   = pfn_to_page(max_pfn + PHYS_PFN_OFFSET) - mem_map;
 
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-	/* this will put all unused low memory onto the freelists */
 	free_unused_memmap();
 #endif
-
+	/* this will put all unused low memory onto the freelists */
 	free_all_bootmem();
 
-	reserved_pages = free_pages = 0;
-
-	for_each_memblock(memory, reg) {
-		unsigned int pfn1, pfn2;
-		struct page *page, *end;
-
-		pfn1 = __phys_to_pfn(reg->base);
-		pfn2 = pfn1 + __phys_to_pfn(reg->size);
-
-		page = pfn_to_page(pfn1);
-		end  = pfn_to_page(pfn2 - 1) + 1;
-
-		do {
-			if (PageReserved(page))
-				reserved_pages++;
-			else if (!page_count(page))
-				free_pages++;
-			page++;
-		} while (page < end);
-	}
-
-	/*
-	 * Since our memory may not be contiguous, calculate the real number
-	 * of pages we have in this system.
-	 */
-	pr_info("Memory:");
-	num_physpages = 0;
-	for_each_memblock(memory, reg) {
-		unsigned long pages = memblock_region_memory_end_pfn(reg) -
-			memblock_region_memory_base_pfn(reg);
-		num_physpages += pages;
-		printk(" %ldMB", pages >> (20 - PAGE_SHIFT));
-	}
-	printk(" = %luMB total\n", num_physpages >> (20 - PAGE_SHIFT));
