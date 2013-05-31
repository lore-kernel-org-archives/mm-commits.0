From: akpm@linux-foundation.org
Subject: +
 mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:54 -0700
Message-ID: <51a908f6.cS0Vk0G9uiu2HDjj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab3EaUcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rientjes@google.com, mhocko@suse.cz, jiang.liu@huawei.com, jejb@parisc-linux.org, deller@gmx.de, liuj97@gmail.com

Subject: + mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,deller@gmx.de,jejb@parisc-linux.org,jiang.liu@huawei.com,mhocko@suse.cz,rientjes@google.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:54 -0700


The patch titled
     Subject: mm/PARISC: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/PARISC: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/init.c |   47 ++--------------------------------------
 1 file changed, 3 insertions(+), 44 deletions(-)

diff -puN arch/parisc/mm/init.c~mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/parisc/mm/init.c
@@ -214,7 +214,6 @@ static void __init setup_bootmem(void)
 	mem_limit_func();       /* check for "mem=" argument */
 
 	mem_max = 0;
-	num_physpages = 0;
 	for (i = 0; i < npmem_ranges; i++) {
 		unsigned long rsize;
 
@@ -229,10 +228,8 @@ static void __init setup_bootmem(void)
 				npmem_ranges = i + 1;
 				mem_max = mem_limit;
 			}
-	        num_physpages += pmem_ranges[i].pages;
 			break;
 		}
-	    num_physpages += pmem_ranges[i].pages;
 		mem_max += rsize;
 	}
 
@@ -532,7 +529,7 @@ void free_initmem(void)
 	 * pages are no-longer executable */
 	flush_icache_range(init_begin, init_end);
 	
-	num_physpages += free_initmem_default(-1);
+	free_initmem_default(-1);
 
 	/* set up a new led state on systems shipped LED State panel */
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_BCOMPLETE);
@@ -580,8 +577,6 @@ unsigned long pcxl_dma_start __read_most
 
 void __init mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
-
 	/* Do sanity checks on page table constants */
 	BUILD_BUG_ON(PTE_ENTRY_SIZE != sizeof(pte_t));
 	BUILD_BUG_ON(PMD_ENTRY_SIZE != sizeof(pmd_t));
@@ -603,33 +598,6 @@ void __init mem_init(void)
 	}
 #endif
 
-	codesize = (unsigned long)_etext - (unsigned long)_text;
-	datasize = (unsigned long)_edata - (unsigned long)_etext;
-	initsize = (unsigned long)__init_end - (unsigned long)__init_begin;
-
-	reservedpages = 0;
-{
-	unsigned long pfn;
-#ifdef CONFIG_DISCONTIGMEM
-	int i;
-
-	for (i = 0; i < npmem_ranges; i++) {
-		for (pfn = node_start_pfn(i); pfn < node_end_pfn(i); pfn++) {
-			if (PageReserved(pfn_to_page(pfn)))
-				reservedpages++;
-		}
-	}
-#else /* !CONFIG_DISCONTIGMEM */
-	for (pfn = 0; pfn < max_pfn; pfn++) {
-		/*
-		 * Only count reserved RAM pages
-		 */
-		if (PageReserved(pfn_to_page(pfn)))
-			reservedpages++;
-	}
-#endif
-}
-
 #ifdef CONFIG_PA11
 	if (hppa_dma_ops == &pcxl_dma_ops) {
 		pcxl_dma_start = (unsigned long)SET_MAP_OFFSET(MAP_START);
@@ -643,15 +611,7 @@ void __init mem_init(void)
 	parisc_vmalloc_start = SET_MAP_OFFSET(MAP_START);
 #endif
 
-	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init)\n",
-		nr_free_pages() << (PAGE_SHIFT-10),
-		num_physpages << (PAGE_SHIFT-10),
-		codesize >> 10,
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		initsize >> 10
-	);
-
+	mem_init_print_info(NULL);
 #ifdef CONFIG_DEBUG_KERNEL /* double-sanity-check paranoia */
 	printk("virtual kernel memory layout:\n"
 	       "    vmalloc : 0x%p - 0x%p   (%4ld MB)\n"
@@ -1101,7 +1061,6 @@ void flush_tlb_all(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	num_physpages += free_reserved_area((void *)start, (void *)end, -1,
-					    "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
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

