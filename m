From: akpm@linux-foundation.org
Subject: [merged]
 mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:10 -0700
Message-ID: <51db128e.75qZIXpcDVsQfqxC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3GHT1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jiang.liu@huawei.com, gregkh@linuxfoundation.org, geert@linux-m68k.org, dhowells@redhat.com, ak@linux.intel.com, liuj97@gmail.com

Subject: [merged] mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,ak@linux.intel.com,dhowells@redhat.com,geert@linux-m68k.org,gregkh@linuxfoundation.org,jiang.liu@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:10 -0700


The patch titled
     Subject: mm/frv: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/frv: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/setup.c |   13 +++++----
 arch/frv/mm/init.c      |   51 +++++++++++---------------------------
 2 files changed, 22 insertions(+), 42 deletions(-)

diff -puN arch/frv/kernel/setup.c~mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/frv/kernel/setup.c
@@ -876,6 +876,7 @@ late_initcall(setup_arch_serial);
 static void __init setup_linux_memory(void)
 {
 	unsigned long bootmap_size, low_top_pfn, kstart, kend, high_mem;
+	unsigned long physpages;
 
 	kstart	= (unsigned long) &__kernel_image_start - PAGE_OFFSET;
 	kend	= (unsigned long) &__kernel_image_end - PAGE_OFFSET;
@@ -893,19 +894,19 @@ static void __init setup_linux_memory(vo
 					 );
 
 	/* pass the memory that the kernel can immediately use over to the bootmem allocator */
-	max_mapnr = num_physpages = (memory_end - memory_start) >> PAGE_SHIFT;
+	max_mapnr = physpages = (memory_end - memory_start) >> PAGE_SHIFT;
 	low_top_pfn = (KERNEL_LOWMEM_END - KERNEL_LOWMEM_START) >> PAGE_SHIFT;
 	high_mem = 0;
 
-	if (num_physpages > low_top_pfn) {
+	if (physpages > low_top_pfn) {
 #ifdef CONFIG_HIGHMEM
-		high_mem = num_physpages - low_top_pfn;
+		high_mem = physpages - low_top_pfn;
 #else
-		max_mapnr = num_physpages = low_top_pfn;
+		max_mapnr = physpages = low_top_pfn;
 #endif
 	}
 	else {
-		low_top_pfn = num_physpages;
+		low_top_pfn = physpages;
 	}
 
 	min_low_pfn = memory_start >> PAGE_SHIFT;
@@ -979,7 +980,7 @@ static void __init setup_uclinux_memory(
 	free_bootmem(memory_start, memory_end - memory_start);
 
 	high_memory = (void *) (memory_end & PAGE_MASK);
-	max_mapnr = num_physpages = ((unsigned long) high_memory - PAGE_OFFSET) >> PAGE_SHIFT;
+	max_mapnr = ((unsigned long) high_memory - PAGE_OFFSET) >> PAGE_SHIFT;
 
 	min_low_pfn = memory_start >> PAGE_SHIFT;
 	max_low_pfn = memory_end >> PAGE_SHIFT;
diff -puN arch/frv/mm/init.c~mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/frv/mm/init.c
@@ -78,7 +78,7 @@ void __init paging_init(void)
 	memset((void *) empty_zero_page, 0, PAGE_SIZE);
 
 #ifdef CONFIG_HIGHMEM
-	if (num_physpages - num_mappedpages) {
+	if (get_num_physpages() - num_mappedpages) {
 		pgd_t *pge;
 		pud_t *pue;
 		pmd_t *pme;
@@ -96,7 +96,7 @@ void __init paging_init(void)
 	 */
 	zones_size[ZONE_NORMAL]  = max_low_pfn - min_low_pfn;
 #ifdef CONFIG_HIGHMEM
-	zones_size[ZONE_HIGHMEM] = num_physpages - num_mappedpages;
+	zones_size[ZONE_HIGHMEM] = get_num_physpages() - num_mappedpages;
 #endif
 
 	free_area_init(zones_size);
@@ -114,45 +114,24 @@ void __init paging_init(void)
  */
 void __init mem_init(void)
 {
-	unsigned long npages = (memory_end - memory_start) >> PAGE_SHIFT;
-	unsigned long tmp;
-#ifdef CONFIG_MMU
-	unsigned long loop, pfn;
-	int datapages = 0;
-#endif
-	int codek = 0, datak = 0;
+	unsigned long code_size = _etext - _stext;
 
 	/* this will put all low memory onto the freelists */
 	free_all_bootmem();
-
-#ifdef CONFIG_MMU
-	for (loop = 0 ; loop < npages ; loop++)
-		if (PageReserved(&mem_map[loop]))
-			datapages++;
-
-#ifdef CONFIG_HIGHMEM
-	for (pfn = num_physpages - 1; pfn >= num_mappedpages; pfn--)
-		free_highmem_page(&mem_map[pfn]);
-#endif
-
-	codek = ((unsigned long) &_etext - (unsigned long) &_stext) >> 10;
-	datak = datapages << (PAGE_SHIFT - 10);
-
-#else
-	codek = (_etext - _stext) >> 10;
-	datak = 0; //(__bss_stop - _sdata) >> 10;
+#if defined(CONFIG_MMU) && defined(CONFIG_HIGHMEM)
+	{
+		unsigned long pfn;
+
+		for (pfn = get_num_physpages() - 1;
+		     pfn >= num_mappedpages; pfn--)
+			free_highmem_page(&mem_map[pfn]);
+	}
 #endif
 
-	tmp = nr_free_pages() << PAGE_SHIFT;
-	printk("Memory available: %luKiB/%luKiB RAM, %luKiB/%luKiB ROM (%dKiB kernel code, %dKiB data)\n",
-	       tmp >> 10,
-	       npages << (PAGE_SHIFT - 10),
-	       (rom_length > 0) ? ((rom_length >> 10) - codek) : 0,
-	       rom_length >> 10,
-	       codek,
-	       datak
-	       );
