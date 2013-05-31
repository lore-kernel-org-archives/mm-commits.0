From: akpm@linux-foundation.org
Subject: +
 mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
Date: Fri, 31 May 2013 13:33:03 -0700
Message-ID: <51a908ff.CnDl+DeBJv0n/o+3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab3EaUdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wujianguo@huawei.com, wency@cn.fujitsu.com, tglx@linutronix.de, tangchen@cn.fujitsu.com, mingo@redhat.com, jiang.liu@huawei.com, hpa@zytor.com, andreas.herrmann3@amd.com, liuj97@gmail.com

Subject: + mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,andreas.herrmann3@amd.com,hpa@zytor.com,jiang.liu@huawei.com,mingo@redhat.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,wency@cn.fujitsu.com,wujianguo@huawei.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:33:03 -0700


The patch titled
     Subject: mm/x86: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/x86: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/amd.c |    2 +-
 arch/x86/kernel/setup.c   |    2 --
 arch/x86/mm/init_32.c     |   30 ++----------------------------
 arch/x86/mm/init_64.c     |   20 +-------------------
 arch/x86/mm/numa_32.c     |    2 --
 5 files changed, 4 insertions(+), 52 deletions(-)

diff -puN arch/x86/kernel/cpu/amd.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init arch/x86/kernel/cpu/amd.c
--- a/arch/x86/kernel/cpu/amd.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/x86/kernel/cpu/amd.c
@@ -90,7 +90,7 @@ static void __cpuinit init_amd_k5(struct
 static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
-	int mbytes = num_physpages >> (20-PAGE_SHIFT);
+	int mbytes = get_num_physpages() >> (20-PAGE_SHIFT);
 
 	if (c->x86_model < 6) {
 		/* Based on AMD doc 20734R - June 2000 */
diff -puN arch/x86/kernel/setup.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/x86/kernel/setup.c
@@ -1040,8 +1040,6 @@ void __init setup_arch(char **cmdline_p)
 	/* max_low_pfn get updated here */
 	find_low_pfn_range();
 #else
-	num_physpages = max_pfn;
-
 	check_x2apic();
 
 	/* How many end-of-memory variables you have, grandma! */
diff -puN arch/x86/mm/init_32.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/x86/mm/init_32.c
@@ -660,10 +660,8 @@ void __init initmem_init(void)
 		highstart_pfn = max_low_pfn;
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
-	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
 
@@ -671,7 +669,7 @@ void __init initmem_init(void)
 	sparse_memory_present_with_active_regions(0);
 
 #ifdef CONFIG_FLATMEM
-	max_mapnr = num_physpages;
+	max_mapnr = IS_ENABLED(CONFIG_HIGHMEM) ? highend_pfn : max_low_pfn;
 #endif
 	__vmalloc_start_set = true;
 
@@ -739,9 +737,6 @@ static void __init test_wp_bit(void)
 
 void __init mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
-	int tmp;
-
 	pci_iommu_alloc();
 
 #ifdef CONFIG_FLATMEM
@@ -761,30 +756,9 @@ void __init mem_init(void)
 	/* this will put all low memory onto the freelists */
 	free_all_bootmem();
 
-	reservedpages = 0;
-	for (tmp = 0; tmp < max_low_pfn; tmp++)
-		/*
-		 * Only count reserved RAM pages:
-		 */
-		if (page_is_ram(tmp) && PageReserved(pfn_to_page(tmp)))
-			reservedpages++;
-
 	after_bootmem = 1;
 
-	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-
-	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
-			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
-		nr_free_pages() << (PAGE_SHIFT-10),
-		num_physpages << (PAGE_SHIFT-10),
-		codesize >> 10,
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		initsize >> 10,
-		totalhigh_pages << (PAGE_SHIFT-10));
-
+	mem_init_print_info(NULL);
 	printk(KERN_INFO "virtual kernel memory layout:\n"
 		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
 #ifdef CONFIG_HIGHMEM
diff -puN arch/x86/mm/init_64.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/x86/mm/init_64.c
@@ -1044,9 +1044,6 @@ static void __init register_page_bootmem
 
 void __init mem_init(void)
 {
-	long codesize, reservedpages, datasize, initsize;
-	unsigned long absent_pages;
-
 	pci_iommu_alloc();
 
 	/* clear_bss() already clear the empty_zero_page */
@@ -1055,28 +1052,13 @@ void __init mem_init(void)
 
 	/* this will put all memory onto the freelists */
 	free_all_bootmem();
-
-	absent_pages = absent_pages_in_range(0, max_pfn);
-	reservedpages = max_pfn - totalram_pages - absent_pages;
 	after_bootmem = 1;
 
-	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-
 	/* Register memory areas for /proc/kcore */
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
 			 VSYSCALL_END - VSYSCALL_START, KCORE_OTHER);
 
-	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
-			 "%ldk absent, %ldk reserved, %ldk data, %ldk init)\n",
-		nr_free_pages() << (PAGE_SHIFT-10),
-		max_pfn << (PAGE_SHIFT-10),
-		codesize >> 10,
-		absent_pages << (PAGE_SHIFT-10),
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		initsize >> 10);
+	mem_init_print_info(NULL);
 }
 
 #ifdef CONFIG_DEBUG_RODATA
diff -puN arch/x86/mm/numa_32.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init arch/x86/mm/numa_32.c
--- a/arch/x86/mm/numa_32.c~mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/x86/mm/numa_32.c
@@ -83,10 +83,8 @@ void __init initmem_init(void)
 		highstart_pfn = max_low_pfn;
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 	       pages_to_mb(highend_pfn - highstart_pfn));
-	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
 	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
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

