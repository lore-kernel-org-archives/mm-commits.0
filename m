From: akpm@linux-foundation.org
Subject: +
 mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:40 -0700
Message-ID: <51a908e8.M4prrVKj5T5GbkOH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3EaUcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vapier@gentoo.org, lliubbo@gmail.com, jiang.liu@huawei.com, liuj97@gmail.com

Subject: + mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,lliubbo@gmail.com,vapier@gentoo.org
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:40 -0700


The patch titled
     Subject: mm/blackfin: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/blackfin: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mm/init.c |   38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff -puN arch/blackfin/mm/init.c~mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init arch/blackfin/mm/init.c
--- a/arch/blackfin/mm/init.c~mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/blackfin/mm/init.c
@@ -90,43 +90,17 @@ asmlinkage void __init init_pda(void)
 
 void __init mem_init(void)
 {
-	unsigned int codek = 0, datak = 0, initk = 0;
-	unsigned int reservedpages = 0, freepages = 0;
-	unsigned long tmp;
-	unsigned long start_mem = memory_start;
-	unsigned long end_mem = memory_end;
+	char buf[64];
 
-	end_mem &= PAGE_MASK;
-	high_memory = (void *)end_mem;
-
-	start_mem = PAGE_ALIGN(start_mem);
-	max_mapnr = num_physpages = MAP_NR(high_memory);
-	printk(KERN_DEBUG "Kernel managed physical pages: %lu\n", num_physpages);
+	high_memory = (void *)(memory_end & PAGE_MASK);
+	max_mapnr = MAP_NR(high_memory);
+	printk(KERN_DEBUG "Kernel managed physical pages: %lu\n", max_mapnr);
 
 	/* This will put all low memory onto the freelists. */
 	free_all_bootmem();
 
-	reservedpages = 0;
-	for (tmp = ARCH_PFN_OFFSET; tmp < max_mapnr; tmp++)
-		if (PageReserved(pfn_to_page(tmp)))
-			reservedpages++;
-	freepages =  max_mapnr - ARCH_PFN_OFFSET - reservedpages;
-
-	/* do not count in kernel image between _rambase and _ramstart */
-	reservedpages -= (_ramstart - _rambase) >> PAGE_SHIFT;
-#if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
-	reservedpages += (_ramend - memory_end - DMA_UNCACHED_REGION) >> PAGE_SHIFT;
-#endif
-
-	codek = (_etext - _stext) >> 10;
-	initk = (__init_end - __init_begin) >> 10;
-	datak = ((_ramstart - _rambase) >> 10) - codek - initk;
-
-	printk(KERN_INFO
-	     "Memory available: %luk/%luk RAM, "
-		"(%uk init code, %uk kernel code, %uk data, %uk dma, %uk reserved)\n",
-		(unsigned long) freepages << (PAGE_SHIFT-10), (_ramend - CONFIG_PHY_RAM_BASE_ADDRESS) >> 10,
-		initk, codek, datak, DMA_UNCACHED_REGION >> 10, (reservedpages << (PAGE_SHIFT-10)));
+	snprintf(buf, sizeof(buf) - 1, "%uK DMA", DMA_UNCACHED_REGION >> 10);
+	mem_init_print_info(buf);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
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

