From: akpm@linux-foundation.org
Subject: +
 mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:38 -0700
Message-ID: <51a908e6.s0AdfEP3GWdYpG5D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3EaUcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, linux@arm.linux.org.uk, jiang.liu@huawei.com, catalin.marinas@arm.com, liuj97@gmail.com

Subject: + mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,catalin.marinas@arm.com,jiang.liu@huawei.com,linux@arm.linux.org.uk,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:38 -0700


The patch titled
     Subject: mm/ARM64: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
-
-	pr_notice("Memory: %luk/%luk available, %luk reserved\n",
-		  nr_free_pages() << (PAGE_SHIFT-10),
-		  free_pages << (PAGE_SHIFT-10),
-		  reserved_pages << (PAGE_SHIFT-10));
+	mem_init_print_info();
 
 #define MLK(b, t) b, t, ((t) - (b)) >> 10
 #define MLM(b, t) b, t, ((t) - (b)) >> 20
@@ -366,7 +324,7 @@ void __init mem_init(void)
 	BUILD_BUG_ON(TASK_SIZE_64			> MODULES_VADDR);
 	BUG_ON(TASK_SIZE_64				> MODULES_VADDR);
 
-	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {
+	if (PAGE_SIZE >= 16384 && get_num_physpages() <= 128) {
 		extern int sysctl_overcommit_memory;
 		/*
 		 * On a machine this small we won't get anywhere without
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

