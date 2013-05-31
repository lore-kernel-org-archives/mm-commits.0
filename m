From: akpm@linux-foundation.org
Subject: +
 mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:46 -0700
Message-ID: <51a908ee.mfZhSmADQ/d/OO3q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab3EaUcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, tony.luck@intel.com, jiang.liu@huawei.com, fenghua.yu@intel.com, liuj97@gmail.com

Subject: + mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,fenghua.yu@intel.com,jiang.liu@huawei.com,tony.luck@intel.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:46 -0700


The patch titled
     Subject: mm/IA64: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
-
+	mem_init_print_info(NULL);
 
 	/*
 	 * For fsyscall entrpoints with no light-weight handler, use the ordinary
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

