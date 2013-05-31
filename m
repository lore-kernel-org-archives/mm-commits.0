From: akpm@linux-foundation.org
Subject: +
 mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:47 -0700
Message-ID: <51a908ef.NriXCZUS43CELoY5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab3EaUcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, takata@linux-m32r.org, jiang.liu@huawei.com, liuj97@gmail.com

Subject: + mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,takata@linux-m32r.org
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:47 -0700


The patch titled
     Subject: mm/m32r: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/m32r: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/discontig.c |    6 ----
 arch/m32r/mm/init.c      |   49 +++----------------------------------
 2 files changed, 6 insertions(+), 49 deletions(-)

diff -puN arch/m32r/mm/discontig.c~mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/m32r/mm/discontig.c
@@ -129,11 +129,10 @@ unsigned long __init setup_memory(void)
 #define START_PFN(nid)		(NODE_DATA(nid)->bdata->node_min_pfn)
 #define MAX_LOW_PFN(nid)	(NODE_DATA(nid)->bdata->node_low_pfn)
 
-unsigned long __init zone_sizes_init(void)
+void __init zone_sizes_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES], zholes_size[MAX_NR_ZONES];
 	unsigned long low, start_pfn;
-	unsigned long holes = 0;
 	int nid, i;
 	mem_prof_t *mp;
 
@@ -147,7 +146,6 @@ unsigned long __init zone_sizes_init(voi
 		low = MAX_LOW_PFN(nid);
 		zones_size[ZONE_DMA] = low - start_pfn;
 		zholes_size[ZONE_DMA] = mp->holes;
-		holes += zholes_size[ZONE_DMA];
 
 		node_set_state(nid, N_NORMAL_MEMORY);
 		free_area_init_node(nid, zones_size, start_pfn, zholes_size);
@@ -161,6 +159,4 @@ unsigned long __init zone_sizes_init(voi
 	NODE_DATA(1)->node_zones->watermark[WMARK_MIN] = 0;
 	NODE_DATA(1)->node_zones->watermark[WMARK_LOW] = 0;
 	NODE_DATA(1)->node_zones->watermark[WMARK_HIGH] = 0;
-
-	return holes;
 }
diff -puN arch/m32r/mm/init.c~mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/m32r/mm/init.c
@@ -40,7 +40,6 @@ unsigned long mmu_context_cache_dat;
 #else
 unsigned long mmu_context_cache_dat[NR_CPUS];
 #endif
-static unsigned long hole_pages;
 
 /*
  * function prototype
@@ -57,7 +56,7 @@ void free_initrd_mem(unsigned long, unsi
 #define MAX_LOW_PFN(nid)	(NODE_DATA(nid)->bdata->node_low_pfn)
 
 #ifndef CONFIG_DISCONTIGMEM
-unsigned long __init zone_sizes_init(void)
+void __init zone_sizes_init(void)
 {
 	unsigned long  zones_size[MAX_NR_ZONES] = {0, };
 	unsigned long  max_dma;
@@ -83,11 +82,9 @@ unsigned long __init zone_sizes_init(voi
 #endif /* CONFIG_MMU */
 
 	free_area_init_node(0, zones_size, start_pfn, 0);
-
-	return 0;
 }
 #else	/* CONFIG_DISCONTIGMEM */
-extern unsigned long zone_sizes_init(void);
+extern void zone_sizes_init(void);
 #endif	/* CONFIG_DISCONTIGMEM */
 
 /*======================================================================*
@@ -105,24 +102,7 @@ void __init paging_init(void)
 	for (i = 0 ; i < USER_PTRS_PER_PGD * 2 ; i++)
 		pgd_val(pg_dir[i]) = 0;
 #endif /* CONFIG_MMU */
-	hole_pages = zone_sizes_init();
-}
-
-int __init reservedpages_count(void)
-{
-	int reservedpages, nid, i;
-
-	reservedpages = 0;
-	for_each_online_node(nid) {
-		unsigned long flags;
-		pgdat_resize_lock(NODE_DATA(nid), &flags);
-		for (i = 0 ; i < MAX_LOW_PFN(nid) - START_PFN(nid) ; i++)
-			if (PageReserved(nid_page_nr(nid, i)))
-				reservedpages++;
-		pgdat_resize_unlock(NODE_DATA(nid), &flags);
-	}
-
-	return reservedpages;
+	zone_sizes_init();
 }
 
 /*======================================================================*
@@ -131,20 +111,13 @@ int __init reservedpages_count(void)
  *======================================================================*/
 void __init mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
 	int nid;
 #ifndef CONFIG_MMU
 	extern unsigned long memory_end;
 #endif
 
-	num_physpages = 0;
-	for_each_online_node(nid)
-		num_physpages += MAX_LOW_PFN(nid) - START_PFN(nid) + 1;
-
-	num_physpages -= hole_pages;
-
 #ifndef CONFIG_DISCONTIGMEM
-	max_mapnr = num_physpages;
+	max_mapnr = get_num_physpages();
 #endif	/* CONFIG_DISCONTIGMEM */
 
 #ifdef CONFIG_MMU
@@ -160,19 +133,7 @@ void __init mem_init(void)
 	for_each_online_node(nid)
 		free_all_bootmem_node(NODE_DATA(nid));
 
-	reservedpages = reservedpages_count() - hole_pages;
-	codesize = (unsigned long) &_etext - (unsigned long)&_text;
-	datasize = (unsigned long) &_edata - (unsigned long)&_etext;
-	initsize = (unsigned long) &__init_end - (unsigned long)&__init_begin;
-
-	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
-		"%dk reserved, %dk data, %dk init)\n",
-		nr_free_pages() << (PAGE_SHIFT-10),
-		num_physpages << (PAGE_SHIFT-10),
-		codesize >> 10,
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		initsize >> 10);
+	mem_init_print_info(NULL);
 }
 
 /*======================================================================*
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

