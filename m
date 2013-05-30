From: akpm@linux-foundation.org
Subject: +
 mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch added
 to -mm tree
Date: Thu, 30 May 2013 15:17:09 -0700
Message-ID: <51a7cfe5.sJFhboN6r9QhlyVz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab3E3WRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: + mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch added to -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:17:09 -0700


The patch titled
     Subject: mm: concentrate modification of totalram_pages into the mm core
has been added to the -mm tree.  Its filename is
     mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: concentrate modification of totalram_pages into the mm core

Concentrate code to modify totalram_pages into the mm core, so the arch
memory initialized code doesn't need to take care of it.  With these
changes applied, only following functions from mm core modify global
variable totalram_pages: free_bootmem_late(), free_all_bootmem(),
free_all_bootmem_node(), adjust_managed_page_count().

With this patch applied, it will be much more easier for us to keep
totalram_pages and zone->managed_pages in consistence.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <sworddragon2@aol.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/init.c             |    2 +-
 arch/alpha/mm/numa.c             |    2 +-
 arch/arc/mm/init.c               |    2 +-
 arch/arm/mm/init.c               |    3 +--
 arch/arm64/mm/init.c             |    2 +-
 arch/avr32/mm/init.c             |    2 --
 arch/blackfin/mm/init.c          |    2 +-
 arch/c6x/mm/init.c               |    2 +-
 arch/cris/mm/init.c              |    2 +-
 arch/frv/mm/init.c               |    2 +-
 arch/h8300/mm/init.c             |    2 +-
 arch/hexagon/mm/init.c           |    2 +-
 arch/ia64/mm/init.c              |    2 +-
 arch/m32r/mm/init.c              |    2 +-
 arch/m68k/mm/init.c              |    4 ++--
 arch/metag/mm/init.c             |    5 +----
 arch/microblaze/mm/init.c        |    2 +-
 arch/mips/mm/init.c              |    2 +-
 arch/mips/sgi-ip27/ip27-memory.c |    2 +-
 arch/mn10300/mm/init.c           |    2 +-
 arch/openrisc/mm/init.c          |    2 +-
 arch/parisc/mm/init.c            |    4 ++--
 arch/powerpc/mm/mem.c            |    5 ++---
 arch/s390/mm/init.c              |    2 +-
 arch/score/mm/init.c             |    2 +-
 arch/sh/mm/init.c                |    2 +-
 arch/sparc/mm/init_32.c          |    3 +--
 arch/sparc/mm/init_64.c          |    2 +-
 arch/tile/mm/init.c              |    2 +-
 arch/um/kernel/mem.c             |    2 +-
 arch/unicore32/mm/init.c         |    2 +-
 arch/x86/mm/init_32.c            |    2 +-
 arch/x86/mm/init_64.c            |    2 +-
 arch/xtensa/mm/init.c            |    2 +-
 mm/bootmem.c                     |    9 ++++++++-
 mm/nobootmem.c                   |    7 ++++++-
 36 files changed, 50 insertions(+), 46 deletions(-)

diff -puN arch/alpha/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/alpha/mm/init.c
@@ -309,7 +309,7 @@ void __init
 mem_init(void)
 {
 	max_mapnr = num_physpages = max_low_pfn;
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 
 	printk_memory_info();
diff -puN arch/alpha/mm/numa.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/alpha/mm/numa.c
@@ -334,7 +334,7 @@ void __init mem_init(void)
 		/*
 		 * This will free up the bootmem, ie, slot 0 memory
 		 */
-		totalram_pages += free_all_bootmem_node(NODE_DATA(nid));
+		free_all_bootmem_node(NODE_DATA(nid));
 
 		pfn = NODE_DATA(nid)->node_start_pfn;
 		for (i = 0; i < node_spanned_pages(nid); i++, pfn++)
diff -puN arch/arc/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/arc/mm/init.c
--- a/arch/arc/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/arc/mm/init.c
@@ -111,7 +111,7 @@ void __init mem_init(void)
 
 	high_memory = (void *)(CONFIG_LINUX_LINK_BASE + arc_mem_sz);
 
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 
 	/* count all reserved pages [kernel code/data/mem_map..] */
 	reserved_pages = 0;
diff -puN arch/arm/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/arm/mm/init.c
@@ -595,8 +595,7 @@ void __init mem_init(void)
 
 	/* this will put all unused low memory onto the freelists */
 	free_unused_memmap(&meminfo);
-
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 
 #ifdef CONFIG_SA1111
 	/* now that our DMA memory is actually so designated, we can free it */
diff -puN arch/arm64/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/arm64/mm/init.c
@@ -284,7 +284,7 @@ void __init mem_init(void)
 	free_unused_memmap();
 #endif
 
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 
 	reserved_pages = free_pages = 0;
 
diff -puN arch/avr32/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/avr32/mm/init.c
@@ -117,8 +117,6 @@ void __init mem_init(void)
 		if (pgdat->node_spanned_pages != 0)
 			node_pages = free_all_bootmem_node(pgdat);
 
-		totalram_pages += node_pages;
-
 		for (i = 0; i < node_pages; i++)
 			if (PageReserved(pgdat->node_mem_map + i))
 				reservedpages++;
diff -puN arch/blackfin/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/blackfin/mm/init.c
--- a/arch/blackfin/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/blackfin/mm/init.c
@@ -104,7 +104,7 @@ void __init mem_init(void)
 	printk(KERN_DEBUG "Kernel managed physical pages: %lu\n", num_physpages);
 
 	/* This will put all low memory onto the freelists. */
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 
 	reservedpages = 0;
 	for (tmp = ARCH_PFN_OFFSET; tmp < max_mapnr; tmp++)
diff -puN arch/c6x/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/c6x/mm/init.c
--- a/arch/c6x/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/c6x/mm/init.c
@@ -64,7 +64,7 @@ void __init mem_init(void)
 	high_memory = (void *)(memory_end & PAGE_MASK);
 
 	/* this will put all memory onto the freelists */
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 
 	codek = (_etext - _stext) >> 10;
 	datak = (_end - _sdata) >> 10;
diff -puN arch/cris/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/cris/mm/init.c
--- a/arch/cris/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/cris/mm/init.c
@@ -33,7 +33,7 @@ mem_init(void)
 	max_mapnr = num_physpages = max_low_pfn - min_low_pfn;
  
 	/* this will put all memory onto the freelists */
-        totalram_pages = free_all_bootmem();
+        free_all_bootmem();
 
 	reservedpages = 0;
 	for (tmp = 0; tmp < max_mapnr; tmp++) {
diff -puN arch/frv/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/frv/mm/init.c
@@ -123,7 +123,7 @@ void __init mem_init(void)
 	int codek = 0, datak = 0;
 
 	/* this will put all low memory onto the freelists */
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 
 #ifdef CONFIG_MMU
 	for (loop = 0 ; loop < npages ; loop++)
diff -puN arch/h8300/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/h8300/mm/init.c
@@ -140,7 +140,7 @@ void __init mem_init(void)
 	max_mapnr = num_physpages = MAP_NR(high_memory);
 
 	/* this will put all low memory onto the freelists */
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 
 	codek = (_etext - _stext) >> 10;
 	datak = (__bss_stop - _sdata) >> 10;
diff -puN arch/hexagon/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/hexagon/mm/init.c
--- a/arch/hexagon/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/hexagon/mm/init.c
@@ -70,7 +70,7 @@ unsigned long long kmap_generation;
 void __init mem_init(void)
 {
 	/*  No idea where this is actually declared.  Seems to evade LXR.  */
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 	num_physpages = bootmem_lastpg-ARCH_PFN_OFFSET;
 
 	printk(KERN_INFO "totalram_pages = %ld\n", totalram_pages);
diff -puN arch/ia64/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/ia64/mm/init.c
@@ -622,7 +622,7 @@ mem_init (void)
 
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
-			totalram_pages += free_all_bootmem_node(pgdat);
+			free_all_bootmem_node(pgdat);
 
 	reserved_pages = 0;
 	efi_memmap_walk(count_reserved_pages, &reserved_pages);
diff -puN arch/m32r/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/m32r/mm/init.c
@@ -158,7 +158,7 @@ void __init mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	for_each_online_node(nid)
-		totalram_pages += free_all_bootmem_node(NODE_DATA(nid));
+		free_all_bootmem_node(NODE_DATA(nid));
 
 	reservedpages = reservedpages_count() - hole_pages;
 	codesize = (unsigned long) &_etext - (unsigned long)&_text;
diff -puN arch/m68k/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/m68k/mm/init.c
@@ -155,11 +155,11 @@ void __init mem_init(void)
 	int i;
 
 	/* this will put all memory onto the freelists */
-	totalram_pages = num_physpages = 0;
+	num_physpages = 0;
 	for_each_online_pgdat(pgdat) {
 		num_physpages += pgdat->node_present_pages;
 
-		totalram_pages += free_all_bootmem_node(pgdat);
+		free_all_bootmem_node(pgdat);
 		for (i = 0; i < pgdat->node_spanned_pages; i++) {
 			struct page *page = pgdat->node_mem_map + i;
 			char *addr = page_to_virt(page);
diff -puN arch/metag/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/metag/mm/init.c
--- a/arch/metag/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/metag/mm/init.c
@@ -393,14 +393,11 @@ void __init mem_init(void)
 
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
-		unsigned long node_pages = 0;
 
 		num_physpages += pgdat->node_present_pages;
 
 		if (pgdat->node_spanned_pages)
-			node_pages = free_all_bootmem_node(pgdat);
-
-		totalram_pages += node_pages;
+			free_all_bootmem_node(pgdat);
 	}
 
 	pr_info("Memory: %luk/%luk available\n",
diff -puN arch/microblaze/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/microblaze/mm/init.c
@@ -252,7 +252,7 @@ void __init mem_init(void)
 	high_memory = (void *)__va(memory_start + lowmem_size - 1);
 
 	/* this will put all memory onto the freelists */
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 
 	for_each_online_pgdat(pgdat) {
 		unsigned long i;
diff -puN arch/mips/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/mips/mm/init.c
@@ -374,7 +374,7 @@ void __init mem_init(void)
 #endif
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 	setup_zero_pages();	/* Setup zeroed pages.  */
 
 	reservedpages = ram = 0;
diff -puN arch/mips/sgi-ip27/ip27-memory.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/mips/sgi-ip27/ip27-memory.c
--- a/arch/mips/sgi-ip27/ip27-memory.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -489,7 +489,7 @@ void __init mem_init(void)
 		/*
 		 * This will free up the bootmem, ie, slot 0 memory.
 		 */
-		totalram_pages += free_all_bootmem_node(NODE_DATA(node));
+		free_all_bootmem_node(NODE_DATA(node));
 	}
 
 	setup_zero_pages();	/* This comes from node 0 */
diff -puN arch/mn10300/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/mn10300/mm/init.c
--- a/arch/mn10300/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/mn10300/mm/init.c
@@ -114,7 +114,7 @@ void __init mem_init(void)
 	memset(empty_zero_page, 0, PAGE_SIZE);
 
 	/* this will put all low memory onto the freelists */
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 
 	reservedpages = 0;
 	for (tmp = 0; tmp < num_physpages; tmp++)
diff -puN arch/openrisc/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/openrisc/mm/init.c
--- a/arch/openrisc/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/openrisc/mm/init.c
@@ -207,7 +207,7 @@ static int __init free_pages_init(void)
 	int reservedpages, pfn;
 
 	/* this will put all low memory onto the freelists */
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 
 	reservedpages = 0;
 	for (pfn = 0; pfn < max_low_pfn; pfn++) {
diff -puN arch/parisc/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/parisc/mm/init.c
@@ -593,13 +593,13 @@ void __init mem_init(void)
 
 #ifndef CONFIG_DISCONTIGMEM
 	max_mapnr = page_to_pfn(virt_to_page(high_memory - 1)) + 1;
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 #else
 	{
 		int i;
 
 		for (i = 0; i < npmem_ranges; i++)
-			totalram_pages += free_all_bootmem_node(NODE_DATA(i));
+			free_all_bootmem_node(NODE_DATA(i));
 	}
 #endif
 
diff -puN arch/powerpc/mm/mem.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/powerpc/mm/mem.c
@@ -318,13 +318,12 @@ void __init mem_init(void)
         for_each_online_node(nid) {
 		if (NODE_DATA(nid)->node_spanned_pages != 0) {
 			printk("freeing bootmem node %d\n", nid);
-			totalram_pages +=
-				free_all_bootmem_node(NODE_DATA(nid));
+			free_all_bootmem_node(NODE_DATA(nid));
 		}
 	}
 #else
 	max_mapnr = max_pfn;
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 #endif
 	for_each_online_pgdat(pgdat) {
 		for (i = 0; i < pgdat->node_spanned_pages; i++) {
diff -puN arch/s390/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/s390/mm/init.c
@@ -144,7 +144,7 @@ void __init mem_init(void)
 	cmma_init();
 
 	/* this will put all low memory onto the freelists */
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 	setup_zero_pages();	/* Setup zeroed pages. */
 
 	reservedpages = 0;
diff -puN arch/score/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/score/mm/init.c
--- a/arch/score/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/score/mm/init.c
@@ -79,7 +79,7 @@ void __init mem_init(void)
 	unsigned long tmp, ram = 0;
 
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 	setup_zero_page();	/* Setup zeroed pages. */
 	reservedpages = 0;
 
diff -puN arch/sh/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/sh/mm/init.c
@@ -422,7 +422,7 @@ void __init mem_init(void)
 		num_physpages += pgdat->node_present_pages;
 
 		if (pgdat->node_spanned_pages)
-			totalram_pages += free_all_bootmem_node(pgdat);
+			free_all_bootmem_node(pgdat);
 
 
 		node_high_memory = (void *)__va((pgdat->node_start_pfn +
diff -puN arch/sparc/mm/init_32.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/sparc/mm/init_32.c
@@ -323,8 +323,7 @@ void __init mem_init(void)
 
 	max_mapnr = last_valid_pfn - pfn_base;
 	high_memory = __va(max_low_pfn << PAGE_SHIFT);
-
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 
 	for (i = 0; sp_banks[i].num_bytes != 0; i++) {
 		unsigned long start_pfn = sp_banks[i].base_addr >> PAGE_SHIFT;
diff -puN arch/sparc/mm/init_64.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/sparc/mm/init_64.c
@@ -2054,7 +2054,7 @@ void __init mem_init(void)
 	high_memory = __va(last_valid_pfn << PAGE_SHIFT);
 
 	register_page_bootmem_info();
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 
 	/* We subtract one to account for the mem_map_zero page
 	 * allocated below.
diff -puN arch/tile/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/tile/mm/init.c
@@ -846,7 +846,7 @@ void __init mem_init(void)
 	set_max_mapnr_init();
 
 	/* this will put all bootmem onto the freelists */
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 
 #ifndef CONFIG_64BIT
 	/* count all remaining LOWMEM and give all HIGHMEM to page allocator */
diff -puN arch/um/kernel/mem.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/um/kernel/mem.c
@@ -65,7 +65,7 @@ void __init mem_init(void)
 	uml_reserved = brk_end;
 
 	/* this will put all low memory onto the freelists */
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 	max_low_pfn = totalram_pages;
 #ifdef CONFIG_HIGHMEM
 	setup_highmem(end_iomem, highmem);
diff -puN arch/unicore32/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/unicore32/mm/init.c
@@ -392,7 +392,7 @@ void __init mem_init(void)
 	free_unused_memmap(&meminfo);
 
 	/* this will put all unused low memory onto the freelists */
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 
 	reserved_pages = free_pages = 0;
 
diff -puN arch/x86/mm/init_32.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/x86/mm/init_32.c
@@ -759,7 +759,7 @@ void __init mem_init(void)
 	set_highmem_pages_init();
 
 	/* this will put all low memory onto the freelists */
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 
 	reservedpages = 0;
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
diff -puN arch/x86/mm/init_64.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/x86/mm/init_64.c
@@ -1054,7 +1054,7 @@ void __init mem_init(void)
 	register_page_bootmem_info();
 
 	/* this will put all memory onto the freelists */
-	totalram_pages = free_all_bootmem();
+	free_all_bootmem();
 
 	absent_pages = absent_pages_in_range(0, max_pfn);
 	reservedpages = max_pfn - totalram_pages - absent_pages;
diff -puN arch/xtensa/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/arch/xtensa/mm/init.c
@@ -184,7 +184,7 @@ void __init mem_init(void)
 #error HIGHGMEM not implemented in init.c
 #endif
 
-	totalram_pages += free_all_bootmem();
+	free_all_bootmem();
 
 	reservedpages = ram = 0;
 	for (tmp = 0; tmp < max_mapnr; tmp++) {
diff -puN mm/bootmem.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core mm/bootmem.c
--- a/mm/bootmem.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/mm/bootmem.c
@@ -271,9 +271,14 @@ void __init reset_all_zones_managed_page
  */
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
+	unsigned long pages;
+
 	register_page_bootmem_info_node(pgdat);
 	reset_node_managed_pages(pgdat);
-	return free_all_bootmem_core(pgdat->bdata);
+	pages = free_all_bootmem_core(pgdat->bdata);
+	totalram_pages += pages;
+
+	return pages;
 }
 
 /**
@@ -291,6 +296,8 @@ unsigned long __init free_all_bootmem(vo
 	list_for_each_entry(bdata, &bdata_list, list)
 		total_pages += free_all_bootmem_core(bdata);
 
+	totalram_pages += total_pages;
+
 	return total_pages;
 }
 
diff -puN mm/nobootmem.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core mm/nobootmem.c
--- a/mm/nobootmem.c~mm-concentrate-modification-of-totalram_pages-into-the-mm-core
+++ a/mm/nobootmem.c
@@ -165,6 +165,8 @@ void __init reset_all_zones_managed_page
  */
 unsigned long __init free_all_bootmem(void)
 {
+	unsigned long pages;
+
 	reset_all_zones_managed_pages();
 
 	/*
@@ -172,7 +174,10 @@ unsigned long __init free_all_bootmem(vo
 	 *  because in some case like Node0 doesn't have RAM installed
 	 *  low ram will be on Node1
 	 */
-	return free_low_memory_core_early();
+	pages = free_low_memory_core_early();
+	totalram_pages += pages;
+
+	return pages;
 }
 
 /**
_

Patches currently in -mm which might be from liuj97@gmail.com are

linux-next.patch
mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch
mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch
mm-arm64-kill-poison_init_mem.patch
mm-x86-use-free_reserved_area-to-simplify-code.patch
mm-tile-use-common-help-functions-to-free-reserved-pages.patch
mm-fix-some-trivial-typos-in-comments.patch
mm-use-managed_pages-to-calculate-default-zonelist-order.patch
mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-make-__free_pages_bootmem-only-available-at-boot-time.patch
mm-correctly-update-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch
mm-report-available-pages-as-memtotal-for-each-numa-node.patch

