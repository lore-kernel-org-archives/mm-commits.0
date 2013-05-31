From: akpm@linux-foundation.org
Subject: +
 mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
Date: Fri, 31 May 2013 13:32:50 -0700
Message-ID: <51a908f2.0Y09Vr3z4k0rcnsX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3EaUcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, monstr@monstr.eu, jiang.liu@huawei.com, liuj97@gmail.com

Subject: + mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,monstr@monstr.eu
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:50 -0700


The patch titled
     Subject: mm/microblaze: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/microblaze: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/mm/init.c |   51 ++++--------------------------------
 1 file changed, 6 insertions(+), 45 deletions(-)

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
-
+	mem_init_print_info(str);
 #ifdef CONFIG_MMU
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

