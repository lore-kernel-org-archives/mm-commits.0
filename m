From: akpm@linux-foundation.org
Subject: [merged]
 mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:26 -0700
Message-ID: <51db129e.WZ2yVl+IY+21Yh8w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHT11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, minchan@kernel.org, jkosina@suse.cz, jiang.liu@huawei.com, gregkh@linuxfoundation.org, david.daney@cavium.com, blogic@openwrt.org, arnd@arndb.de, liuj97@gmail.com

Subject: [merged] mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,arnd@arndb.de,blogic@openwrt.org,david.daney@cavium.com,gregkh@linuxfoundation.org,jiang.liu@huawei.com,jkosina@suse.cz,minchan@kernel.org,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:26 -0700


The patch titled
     Subject: mm/MIPS: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/MIPS: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: John Crispin <blogic@openwrt.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c              |   57 +++++++++--------------------
 arch/mips/pci/pci-lantiq.c       |    2 -
 arch/mips/sgi-ip27/ip27-memory.c |   21 +---------
 3 files changed, 21 insertions(+), 59 deletions(-)

diff -puN arch/mips/mm/init.c~mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/mips/mm/init.c
@@ -359,11 +359,24 @@ void __init paging_init(void)
 static struct kcore_list kcore_kseg0;
 #endif
 
-void __init mem_init(void)
+static inline void mem_init_free_highmem(void)
 {
-	unsigned long codesize, reservedpages, datasize, initsize;
-	unsigned long tmp, ram;
+#ifdef CONFIG_HIGHMEM
+	unsigned long tmp;
+
+	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
+		struct page *page = pfn_to_page(tmp);
+
+		if (!page_is_ram(tmp))
+			SetPageReserved(page);
+		else
+			free_highmem_page(page);
+	}
+#endif
+}
 
+void __init mem_init(void)
+{
 #ifdef CONFIG_HIGHMEM
 #ifdef CONFIG_DISCONTIGMEM
 #error "CONFIG_HIGHMEM and CONFIG_DISCONTIGMEM dont work together yet"
@@ -376,32 +389,8 @@ void __init mem_init(void)
 
 	free_all_bootmem();
 	setup_zero_pages();	/* Setup zeroed pages.  */
-
-	reservedpages = ram = 0;
-	for (tmp = 0; tmp < max_low_pfn; tmp++)
-		if (page_is_ram(tmp) && pfn_valid(tmp)) {
-			ram++;
-			if (PageReserved(pfn_to_page(tmp)))
-				reservedpages++;
-		}
-	num_physpages = ram;
-
-#ifdef CONFIG_HIGHMEM
-	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
-		struct page *page = pfn_to_page(tmp);
-
-		if (!page_is_ram(tmp)) {
-			SetPageReserved(page);
-			continue;
-		}
-		free_highmem_page(page);
-	}
-	num_physpages += totalhigh_pages;
-#endif
-
-	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
+	mem_init_free_highmem();
+	mem_init_print_info(NULL);
 
 #ifdef CONFIG_64BIT
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
@@ -410,16 +399,6 @@ void __init mem_init(void)
 		kclist_add(&kcore_kseg0, (void *) CKSEG0,
 				0x80000000 - 4, KCORE_TEXT);
 #endif
-
-	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
-	       "%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       ram << (PAGE_SHIFT-10),
-	       codesize >> 10,
-	       reservedpages << (PAGE_SHIFT-10),
-	       datasize >> 10,
-	       initsize >> 10,
-	       totalhigh_pages << (PAGE_SHIFT-10));
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
diff -puN arch/mips/pci/pci-lantiq.c~mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init arch/mips/pci/pci-lantiq.c
--- a/arch/mips/pci/pci-lantiq.c~mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/mips/pci/pci-lantiq.c
@@ -89,7 +89,7 @@ static inline u32 ltq_calc_bar11mask(voi
 	u32 mem, bar11mask;
 
 	/* BAR11MASK value depends on available memory on system. */
-	mem = num_physpages * PAGE_SIZE;
+	mem = get_num_physpages() * PAGE_SIZE;
 	bar11mask = (0x0ffffff0 & ~((1 << (fls(mem) - 1)) - 1)) | 8;
 
 	return bar11mask;
diff -puN arch/mips/sgi-ip27/ip27-memory.c~mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c~mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -357,8 +357,6 @@ static void __init szmem(void)
 	int slot;
 	cnodeid_t node;
 
-	num_physpages = 0;
-
 	for_each_online_node(node) {
 		nodebytes = 0;
 		for (slot = 0; slot < MAX_MEM_SLOTS; slot++) {
@@ -381,7 +379,6 @@ static void __init szmem(void)
 				slot = MAX_MEM_SLOTS;
 				continue;
 			}
-			num_physpages += slot_psize;
 			memblock_add_node(PFN_PHYS(slot_getbasepfn(node, slot)),
 					  PFN_PHYS(slot_psize), node);
 		}
@@ -480,10 +477,9 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	unsigned long codesize, datasize, initsize, tmp;
 	unsigned node;
 
-	high_memory = (void *) __va(num_physpages << PAGE_SHIFT);
+	high_memory = (void *) __va(get_num_physpages() << PAGE_SHIFT);
 
 	for_each_online_node(node) {
 		/*
@@ -494,18 +490,5 @@ void __init mem_init(void)
 
 	setup_zero_pages();	/* This comes from node 0 */
 
-	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
