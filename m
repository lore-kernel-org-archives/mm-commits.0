From: akpm@linux-foundation.org
Subject: [merged]
 mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:24 -0700
Message-ID: <51db129c.Gupjg0S6/DEMrJI2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHT1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, monstr@monstr.eu, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,monstr@monstr.eu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:24 -0700


The patch titled
     Subject: mm/microblaze: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/microblaze: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c      |    2 -
 arch/microblaze/mm/init.c |   51 ++++--------------------------------
 2 files changed, 7 insertions(+), 46 deletions(-)

diff -puN arch/arm64/mm/init.c~mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/arm64/mm/init.c
@@ -282,7 +282,7 @@ void __init mem_init(void)
 	/* this will put all unused low memory onto the freelists */
 	free_all_bootmem();
 
-	mem_init_print_info();
+	mem_init_print_info(NULL);
 
 #define MLK(b, t) b, t, ((t) - (b)) >> 10
 #define MLM(b, t) b, t, ((t) - (b)) >> 20
diff -puN arch/microblaze/mm/init.c~mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/microblaze/mm/init.c
@@ -71,24 +71,17 @@ static void __init highmem_init(void)
 	kmap_prot = PAGE_KERNEL;
 }
 
-static unsigned long highmem_setup(void)
+static void highmem_setup(void)
 {
 	unsigned long pfn;
-	unsigned long reservedpages = 0;
 
 	for (pfn = max_low_pfn; pfn < max_pfn; ++pfn) {
 		struct page *page = pfn_to_page(pfn);
 
 		/* FIXME not sure about */
-		if (memblock_is_reserved(pfn << PAGE_SHIFT))
-			continue;
-		free_highmem_page(page);
-		reservedpages++;
+		if (!memblock_is_reserved(pfn << PAGE_SHIFT))
+			free_highmem_page(page);
 	}
-	pr_info("High memory: %luk\n",
-					totalhigh_pages << (PAGE_SHIFT-10));
-
-	return reservedpages;
 }
 #endif /* CONFIG_HIGHMEM */
 
@@ -167,13 +160,12 @@ void __init setup_memory(void)
 	 * min_low_pfn - the first page (mm/bootmem.c - node_boot_start)
 	 * max_low_pfn
 	 * max_mapnr - the first unused page (mm/bootmem.c - node_low_pfn)
-	 * num_physpages - number of all pages
 	 */
 
 	/* memory start is from the kernel end (aligned) to higher addr */
 	min_low_pfn = memory_start >> PAGE_SHIFT; /* minimum for allocation */
 	/* RAM is assumed contiguous */
-	num_physpages = max_mapnr = memory_size >> PAGE_SHIFT;
+	max_mapnr = memory_size >> PAGE_SHIFT;
 	max_low_pfn = ((u64)memory_start + (u64)lowmem_size) >> PAGE_SHIFT;
 	max_pfn = ((u64)memory_start + (u64)memory_size) >> PAGE_SHIFT;
 
@@ -246,46 +238,15 @@ void free_initmem(void)
 
 void __init mem_init(void)
 {
-	pg_data_t *pgdat;
-	unsigned long reservedpages = 0, codesize, initsize, datasize, bsssize;
-
 	high_memory = (void *)__va(memory_start + lowmem_size - 1);
 
 	/* this will put all memory onto the freelists */
 	free_all_bootmem();
-
-	for_each_online_pgdat(pgdat) {
-		unsigned long i;
-		struct page *page;
-
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			if (!pfn_valid(pgdat->node_start_pfn + i))
-				continue;
-			page = pgdat_page_nr(pgdat, i);
-			if (PageReserved(page))
-				reservedpages++;
-		}
-	}
-
 #ifdef CONFIG_HIGHMEM
-	reservedpages -= highmem_setup();
+	highmem_setup();
 #endif
 
-	codesize = (unsigned long)&_sdata - (unsigned long)&_stext;
-	datasize = (unsigned long)&_edata - (unsigned long)&_sdata;
-	initsize = (unsigned long)&__init_end - (unsigned long)&__init_begin;
-	bsssize = (unsigned long)&__bss_stop - (unsigned long)&__bss_start;
-
-	pr_info("Memory: %luk/%luk available (%luk kernel code, ",
-		nr_free_pages() << (PAGE_SHIFT-10),
-		num_physpages << (PAGE_SHIFT-10),
-		codesize >> 10);
-	pr_cont("%luk reserved, %luk data, %luk bss, %luk init)\n",
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		bsssize >> 10,
-		initsize >> 10);
