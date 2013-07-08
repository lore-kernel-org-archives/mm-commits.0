From: akpm@linux-foundation.org
Subject: [merged]
 mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:16 -0700
Message-ID: <51db1294.evQkJzXSvaOUD8Ip%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3GHT1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, tony.luck@intel.com, jiang.liu@huawei.com, fenghua.yu@intel.com, liuj97@gmail.com

Subject: [merged] mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,fenghua.yu@intel.com,jiang.liu@huawei.com,tony.luck@intel.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:16 -0700


The patch titled
     Subject: mm/IA64: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/IA64: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/contig.c    |   11 -----------
 arch/ia64/mm/discontig.c |    3 ---
 arch/ia64/mm/init.c      |   27 +--------------------------
 3 files changed, 1 insertion(+), 40 deletions(-)

diff -puN arch/ia64/mm/contig.c~mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/ia64/mm/contig.c
@@ -295,14 +295,6 @@ find_memory (void)
 	alloc_per_cpu_data();
 }
 
-static int count_pages(u64 start, u64 end, void *arg)
-{
-	unsigned long *count = arg;
-
-	*count += (end - start) >> PAGE_SHIFT;
-	return 0;
-}
-
 /*
  * Set up the page tables.
  */
@@ -313,9 +305,6 @@ paging_init (void)
 	unsigned long max_dma;
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
-	num_physpages = 0;
-	efi_memmap_walk(count_pages, &num_physpages);
-
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 #ifdef CONFIG_ZONE_DMA
 	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
diff -puN arch/ia64/mm/discontig.c~mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/ia64/mm/discontig.c
@@ -37,7 +37,6 @@ struct early_node_data {
 	struct ia64_node_data *node_data;
 	unsigned long pernode_addr;
 	unsigned long pernode_size;
-	unsigned long num_physpages;
 #ifdef CONFIG_ZONE_DMA
 	unsigned long num_dma_physpages;
 #endif
@@ -732,7 +731,6 @@ static __init int count_node_pages(unsig
 {
 	unsigned long end = start + len;
 
-	mem_data[node].num_physpages += len >> PAGE_SHIFT;
 #ifdef CONFIG_ZONE_DMA
 	if (start <= __pa(MAX_DMA_ADDRESS))
 		mem_data[node].num_dma_physpages +=
@@ -778,7 +776,6 @@ void __init paging_init(void)
 #endif
 
 	for_each_online_node(node) {
-		num_physpages += mem_data[node].num_physpages;
 		pfn_offset = mem_data[node].min_pfn;
 
 #ifdef CONFIG_VIRTUAL_MEM_MAP
diff -puN arch/ia64/mm/init.c~mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/ia64/mm/init.c
@@ -545,19 +545,6 @@ int __init register_active_ranges(u64 st
 	return 0;
 }
 
-static int __init
-count_reserved_pages(u64 start, u64 end, void *arg)
-{
-	unsigned long num_reserved = 0;
-	unsigned long *count = arg;
-
-	for (; start < end; start += PAGE_SIZE)
-		if (PageReserved(virt_to_page(start)))
-			++num_reserved;
-	*count += num_reserved;
-	return 0;
-}
-
 int
 find_max_min_low_pfn (u64 start, u64 end, void *arg)
 {
@@ -596,7 +583,6 @@ __setup("nolwsys", nolwsys_setup);
 void __init
 mem_init (void)
 {
-	long reserved_pages, codesize, datasize, initsize;
 	pg_data_t *pgdat;
 	int i;
 
@@ -624,18 +610,7 @@ mem_init (void)
 		if (pgdat->bdata->node_bootmem_map)
 			free_all_bootmem_node(pgdat);
 
-	reserved_pages = 0;
-	efi_memmap_walk(count_reserved_pages, &reserved_pages);
-
-	codesize =  (unsigned long) _etext - (unsigned long) _stext;
-	datasize =  (unsigned long) _edata - (unsigned long) _etext;
-	initsize =  (unsigned long) __init_end - (unsigned long) __init_begin;
-
-	printk(KERN_INFO "Memory: %luk/%luk available (%luk code, %luk reserved, "
-	       "%luk data, %luk init)\n", nr_free_pages() << (PAGE_SHIFT - 10),
-	       num_physpages << (PAGE_SHIFT - 10), codesize >> 10,
-	       reserved_pages << (PAGE_SHIFT - 10), datasize >> 10, initsize >> 10);
