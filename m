From: akpm@linux-foundation.org
Subject: +
 mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
Date: Fri, 31 May 2013 13:32:55 -0700
Message-ID: <51a908f7.O9ok2X1Jd9h9UPU/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3EaUc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulus@samba.org, jiang.liu@huawei.com, benh@kernel.crashing.org, liuj97@gmail.com

Subject: + mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,benh@kernel.crashing.org,jiang.liu@huawei.com,paulus@samba.org
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:55 -0700


The patch titled
     Subject: mm/ppc: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
-
+	mem_init_print_info(NULL);
 #ifdef CONFIG_PPC32
 	pr_info("Kernel virtual memory layout:\n");
 	pr_info("  * 0x%08lx..0x%08lx  : fixmap\n", FIXADDR_START, FIXADDR_TOP);
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
vmlinuxlds-add-comments-for-global-variables-and-clean-up-useless-declarations.patch
avr32-normalize-global-variables-exported-by-vmlinuxlds.patch
c6x-normalize-global-variables-exported-by-vmlinuxlds.patch
h8300-normalize-global-variables-exported-by-vmlinuxlds.patch
score-normalize-global-variables-exported-by-vmlinuxlds.patch
tile-normalize-global-variables-exported-by-vmlinuxlds.patch
uml-normalize-global-variables-exported-by-vmlinuxlds.patch
mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch
mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch
mm-hotplug-prepare-for-removing-num_physpages.patch
mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arm-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-avr32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-c6x-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-cris-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-hexagon-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-m68k-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-metag-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-mn10300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-openrisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-s390-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-score-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-um-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-unicore32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-xtensa-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-kill-global-variable-num_physpages.patch

