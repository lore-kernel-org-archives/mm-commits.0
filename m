From: akpm@linux-foundation.org
Subject: +
 mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
Date: Fri, 31 May 2013 13:32:36 -0700
Message-ID: <51a908e4.6CI8qE96JTWkNUNw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3EaUch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, rob.herring@calxeda.com, jiang.liu@huawei.com, james.hogan@imgtec.com, liuj97@gmail.com

Subject: + mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,james.hogan@imgtec.com,jiang.liu@huawei.com,rob.herring@calxeda.com,vgupta@synopsys.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:36 -0700


The patch titled
     Subject: mm/ARC: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/ARC: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>   # for arch/arc
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |   36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff -puN arch/arc/mm/init.c~mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init arch/arc/mm/init.c
--- a/arch/arc/mm/init.c~mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/arc/mm/init.c
@@ -74,7 +74,7 @@ void __init setup_arch_memory(void)
 	/* Last usable page of low mem (no HIGHMEM yet for ARC port) */
 	max_low_pfn = max_pfn = PFN_DOWN(end_mem);
 
-	max_mapnr = num_physpages = max_low_pfn - min_low_pfn;
+	max_mapnr = max_low_pfn - min_low_pfn;
 
 	/*------------- reserve kernel image -----------------------*/
 	memblock_reserve(CONFIG_LINUX_LINK_BASE,
@@ -84,7 +84,7 @@ void __init setup_arch_memory(void)
 
 	/*-------------- node setup --------------------------------*/
 	memset(zones_size, 0, sizeof(zones_size));
-	zones_size[ZONE_NORMAL] = num_physpages;
+	zones_size[ZONE_NORMAL] = max_low_pfn - min_low_pfn;
 
 	/*
 	 * We can't use the helper free_area_init(zones[]) because it uses
@@ -106,39 +106,9 @@ void __init setup_arch_memory(void)
  */
 void __init mem_init(void)
 {
-	int codesize, datasize, initsize, reserved_pages, free_pages;
-	int tmp;
-
 	high_memory = (void *)(CONFIG_LINUX_LINK_BASE + arc_mem_sz);
-
 	free_all_bootmem();
-
-	/* count all reserved pages [kernel code/data/mem_map..] */
-	reserved_pages = 0;
-	for (tmp = 0; tmp < max_mapnr; tmp++)
-		if (PageReserved(mem_map + tmp))
-			reserved_pages++;
-
-	/* XXX: nr_free_pages() is equivalent */
-	free_pages = max_mapnr - reserved_pages;
-
-	/*
-	 * For the purpose of display below, split the "reserve mem"
-	 * kernel code/data is already shown explicitly,
-	 * Show any other reservations (mem_map[ ] et al)
-	 */
-	reserved_pages -= (((unsigned int)_end - CONFIG_LINUX_LINK_BASE) >>
-								PAGE_SHIFT);
-
-	codesize = _etext - _text;
-	datasize = _end - _etext;
-	initsize = __init_end - __init_begin;
-
-	pr_info("Memory Available: %dM / %ldM (%dK code, %dK data, %dK init, %dK reserv)\n",
-		PAGES_TO_MB(free_pages),
-		TO_MB(arc_mem_sz),
-		TO_KB(codesize), TO_KB(datasize), TO_KB(initsize),
-		PAGES_TO_KB(reserved_pages));
+	mem_init_print_info(NULL);
 }
 
 /*
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

