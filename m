From: akpm@linux-foundation.org
Subject: +
 mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 added to -mm tree
Date: Fri, 31 May 2013 13:32:59 -0700
Message-ID: <51a908fb.hLeghFdfuIW9jnEo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab3EaUdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com, sam@ravnborg.org, jiang.liu@huawei.com, isimatu.yasuaki@jp.fujitsu.com, davem@davemloft.net, liuj97@gmail.com

Subject: + mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch added to -mm tree
To: liuj97@gmail.com,davem@davemloft.net,isimatu.yasuaki@jp.fujitsu.com,jiang.liu@huawei.com,sam@ravnborg.org,tangchen@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:59 -0700


The patch titled
     Subject: mm/SPARC: prepare for removing num_physpages and simplify mem_init()
has been added to the -mm tree.  Its filename is
     mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

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
Subject: mm/SPARC: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/leon_smp.c |    3 --
 arch/sparc/mm/init_32.c      |   34 +++------------------------------
 arch/sparc/mm/init_64.c      |   24 ++---------------------
 3 files changed, 7 insertions(+), 54 deletions(-)

diff -puN arch/sparc/kernel/leon_smp.c~mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init arch/sparc/kernel/leon_smp.c
--- a/arch/sparc/kernel/leon_smp.c~mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/sparc/kernel/leon_smp.c
@@ -254,15 +254,12 @@ void __init leon_smp_done(void)
 	/* Free unneeded trap tables */
 	if (!cpu_present(1)) {
 		free_reserved_page(virt_to_page(&trapbase_cpu1));
-		num_physpages++;
 	}
 	if (!cpu_present(2)) {
 		free_reserved_page(virt_to_page(&trapbase_cpu2));
-		num_physpages++;
 	}
 	if (!cpu_present(3)) {
 		free_reserved_page(virt_to_page(&trapbase_cpu3));
-		num_physpages++;
 	}
 	/* Ok, they are spinning and ready to go. */
 	smp_processors_ready = 1;
diff -puN arch/sparc/mm/init_32.c~mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/sparc/mm/init_32.c
@@ -288,10 +288,6 @@ static void map_high_region(unsigned lon
 
 void __init mem_init(void)
 {
-	int codepages = 0;
-	int datapages = 0;
-	int initpages = 0; 
-	int reservedpages = 0;
 	int i;
 
 	if (PKMAP_BASE+LAST_PKMAP*PAGE_SIZE >= FIXADDR_START) {
@@ -329,8 +325,6 @@ void __init mem_init(void)
 		unsigned long start_pfn = sp_banks[i].base_addr >> PAGE_SHIFT;
 		unsigned long end_pfn = (sp_banks[i].base_addr + sp_banks[i].num_bytes) >> PAGE_SHIFT;
 
-		num_physpages += sp_banks[i].num_bytes >> PAGE_SHIFT;
-
 		if (end_pfn <= highstart_pfn)
 			continue;
 
@@ -340,39 +334,19 @@ void __init mem_init(void)
 		map_high_region(start_pfn, end_pfn);
 	}
 	
-	codepages = (((unsigned long) &_etext) - ((unsigned long)&_start));
-	codepages = PAGE_ALIGN(codepages) >> PAGE_SHIFT;
-	datapages = (((unsigned long) &_edata) - ((unsigned long)&_etext));
-	datapages = PAGE_ALIGN(datapages) >> PAGE_SHIFT;
-	initpages = (((unsigned long) &__init_end) - ((unsigned long) &__init_begin));
-	initpages = PAGE_ALIGN(initpages) >> PAGE_SHIFT;
-
-	/* Ignore memory holes for the purpose of counting reserved pages */
-	for (i=0; i < max_low_pfn; i++)
-		if (test_bit(i >> (20 - PAGE_SHIFT), sparc_valid_addr_bitmap)
-		    && PageReserved(pfn_to_page(i)))
-			reservedpages++;
-
-	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init, %ldk highmem)\n",
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       num_physpages << (PAGE_SHIFT - 10),
-	       codepages << (PAGE_SHIFT-10),
-	       reservedpages << (PAGE_SHIFT - 10),
-	       datapages << (PAGE_SHIFT-10), 
-	       initpages << (PAGE_SHIFT-10),
-	       totalhigh_pages << (PAGE_SHIFT-10));
+	mem_init_print_info(NULL);
 }
 
 void free_initmem (void)
 {
-	num_physpages += free_initmem_default(POISON_FREE_INITMEM);
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	num_physpages += free_reserved_area((void *)start, (void *)end,
-					    POISON_FREE_INITMEM, "initrd");
+	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
+			   "initrd");
 }
 #endif
 
diff -puN arch/sparc/mm/init_64.c~mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/sparc/mm/init_64.c
@@ -2038,7 +2038,6 @@ static void __init register_page_bootmem
 }
 void __init mem_init(void)
 {
-	unsigned long codepages, datapages, initpages;
 	unsigned long addr, last;
 
 	addr = PAGE_OFFSET + kern_base;
@@ -2056,11 +2055,6 @@ void __init mem_init(void)
 	register_page_bootmem_info();
 	free_all_bootmem();
 
-	/* We subtract one to account for the mem_map_zero page
-	 * allocated below.
-	 */
-	num_physpages = totalram_pages - 1;
-
 	/*
 	 * Set up the zero page, mark it reserved, so that page count
 	 * is not manipulated when freeing the page from user ptes.
@@ -2072,19 +2066,7 @@ void __init mem_init(void)
 	}
 	mark_page_reserved(mem_map_zero);
 
-	codepages = (((unsigned long) _etext) - ((unsigned long) _start));
-	codepages = PAGE_ALIGN(codepages) >> PAGE_SHIFT;
-	datapages = (((unsigned long) _edata) - ((unsigned long) _etext));
-	datapages = PAGE_ALIGN(datapages) >> PAGE_SHIFT;
-	initpages = (((unsigned long) __init_end) - ((unsigned long) __init_begin));
-	initpages = PAGE_ALIGN(initpages) >> PAGE_SHIFT;
-
-	printk("Memory: %luk available (%ldk kernel code, %ldk data, %ldk init) [%016lx,%016lx]\n",
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       codepages << (PAGE_SHIFT-10),
-	       datapages << (PAGE_SHIFT-10), 
-	       initpages << (PAGE_SHIFT-10), 
-	       PAGE_OFFSET, (last_valid_pfn << PAGE_SHIFT));
+	mem_init_print_info(NULL);
 
 	if (tlb_type == cheetah || tlb_type == cheetah_plus)
 		cheetah_ecache_flush_init();
@@ -2124,8 +2106,8 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	num_physpages += free_reserved_area((void *)start, (void *)end,
-					    POISON_FREE_INITMEM, "initrd");
+	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
+			   "initrd");
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

