From: akpm@linux-foundation.org
Subject: + mm-sparc-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:56 -0700
Message-ID: <20130312212256.961D05A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42089 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:58 -0400
Received: by mail-vc0-f202.google.com with SMTP id m8so38500vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, davem@davemloft.net, jiang.liu@huawei.com, sam@ravnborg.org


The patch titled
     Subject: mm/SPARC: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

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
Subject: mm/SPARC: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/leon_smp.c |   15 ++-----------
 arch/sparc/mm/init_32.c      |   37 ++-------------------------------
 arch/sparc/mm/init_64.c      |   26 ++++-------------------
 3 files changed, 11 insertions(+), 67 deletions(-)

diff -puN arch/sparc/kernel/leon_smp.c~mm-sparc-use-common-help-functions-to-free-reserved-pages arch/sparc/kernel/leon_smp.c
--- a/arch/sparc/kernel/leon_smp.c~mm-sparc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/sparc/kernel/leon_smp.c
@@ -253,24 +253,15 @@ void __init leon_smp_done(void)
 
 	/* Free unneeded trap tables */
 	if (!cpu_present(1)) {
-		ClearPageReserved(virt_to_page(&trapbase_cpu1));
-		init_page_count(virt_to_page(&trapbase_cpu1));
-		free_page((unsigned long)&trapbase_cpu1);
-		totalram_pages++;
+		free_reserved_page(virt_to_page(&trapbase_cpu1));
 		num_physpages++;
 	}
 	if (!cpu_present(2)) {
-		ClearPageReserved(virt_to_page(&trapbase_cpu2));
-		init_page_count(virt_to_page(&trapbase_cpu2));
-		free_page((unsigned long)&trapbase_cpu2);
-		totalram_pages++;
+		free_reserved_page(virt_to_page(&trapbase_cpu2));
 		num_physpages++;
 	}
 	if (!cpu_present(3)) {
-		ClearPageReserved(virt_to_page(&trapbase_cpu3));
-		init_page_count(virt_to_page(&trapbase_cpu3));
-		free_page((unsigned long)&trapbase_cpu3);
-		totalram_pages++;
+		free_reserved_page(virt_to_page(&trapbase_cpu3));
 		num_physpages++;
 	}
 	/* Ok, they are spinning and ready to go. */
diff -puN arch/sparc/mm/init_32.c~mm-sparc-use-common-help-functions-to-free-reserved-pages arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~mm-sparc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/sparc/mm/init_32.c
@@ -374,45 +374,14 @@ void __init mem_init(void)
 
 void free_initmem (void)
 {
-	unsigned long addr;
-	unsigned long freed;
-
-	addr = (unsigned long)(&__init_begin);
-	freed = (unsigned long)(&__init_end) - addr;
-	for (; addr < (unsigned long)(&__init_end); addr += PAGE_SIZE) {
-		struct page *p;
-
-		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		p = virt_to_page(addr);
-
-		ClearPageReserved(p);
-		init_page_count(p);
-		__free_page(p);
-		totalram_pages++;
-		num_physpages++;
-	}
-	printk(KERN_INFO "Freeing unused kernel memory: %ldk freed\n",
-		freed >> 10);
+	num_physpages += free_initmem_default(POISON_FREE_INITMEM);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (start < end)
-		printk(KERN_INFO "Freeing initrd memory: %ldk freed\n",
-			(end - start) >> 10);
-	for (; start < end; start += PAGE_SIZE) {
-		struct page *p;
-
-		memset((void *)start, POISON_FREE_INITMEM, PAGE_SIZE);
-		p = virt_to_page(start);
-
-		ClearPageReserved(p);
-		init_page_count(p);
-		__free_page(p);
-		totalram_pages++;
-		num_physpages++;
-	}
+	num_physpages += free_reserved_area(start, end, POISON_FREE_INITMEM,
+					    "initrd");
 }
 #endif
 
diff -puN arch/sparc/mm/init_64.c~mm-sparc-use-common-help-functions-to-free-reserved-pages arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~mm-sparc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/sparc/mm/init_64.c
@@ -2060,8 +2060,7 @@ void __init mem_init(void)
 	/* We subtract one to account for the mem_map_zero page
 	 * allocated below.
 	 */
-	totalram_pages -= 1;
-	num_physpages = totalram_pages;
+	num_physpages = totalram_pages - 1;
 
 	/*
 	 * Set up the zero page, mark it reserved, so that page count
@@ -2072,7 +2071,7 @@ void __init mem_init(void)
 		prom_printf("paging_init: Cannot alloc zero page.\n");
 		prom_halt();
 	}
-	SetPageReserved(mem_map_zero);
+	mark_page_reserved(mem_map_zero);
 
 	codepages = (((unsigned long) _etext) - ((unsigned long) _start));
 	codepages = PAGE_ALIGN(codepages) >> PAGE_SHIFT;
@@ -2112,7 +2111,6 @@ void free_initmem(void)
 	initend = (unsigned long)(__init_end) & PAGE_MASK;
 	for (; addr < initend; addr += PAGE_SIZE) {
 		unsigned long page;
-		struct page *p;
 
 		page = (addr +
 			((unsigned long) __va(kern_base)) -
@@ -2120,13 +2118,8 @@ void free_initmem(void)
 		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
 
 		if (do_free) {
-			p = virt_to_page(page);
-
-			ClearPageReserved(p);
-			init_page_count(p);
-			__free_page(p);
+			free_reserved_page(virt_to_page(page));
 			num_physpages++;
-			totalram_pages++;
 		}
 	}
 }
@@ -2134,17 +2127,8 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (start < end)
-		printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
-	for (; start < end; start += PAGE_SIZE) {
-		struct page *p = virt_to_page(start);
-
-		ClearPageReserved(p);
-		init_page_count(p);
-		__free_page(p);
-		num_physpages++;
-		totalram_pages++;
-	}
+	num_physpages += free_reserved_area(start, end, POISON_FREE_INITMEM,
+					    "initrd");
 }
 #endif
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-alpha-use-common-help-functions-to-free-reserved-pages.patch
mm-arm-use-common-help-functions-to-free-reserved-pages.patch
mm-avr32-use-common-help-functions-to-free-reserved-pages.patch
mm-blackfin-use-common-help-functions-to-free-reserved-pages.patch
mm-c6x-use-common-help-functions-to-free-reserved-pages.patch
mm-cris-use-common-help-functions-to-free-reserved-pages.patch
mm-frv-use-common-help-functions-to-free-reserved-pages.patch
mm-h8300-use-common-help-functions-to-free-reserved-pages.patch
mm-ia64-use-common-help-functions-to-free-reserved-pages.patch
mm-m32r-use-common-help-functions-to-free-reserved-pages.patch
mm-m68k-use-common-help-functions-to-free-reserved-pages.patch
mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch
mm-mips-use-common-help-functions-to-free-reserved-pages.patch
mm-mn10300-use-common-help-functions-to-free-reserved-pages.patch
mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch
mm-parisc-use-common-help-functions-to-free-reserved-pages.patch
mm-ppc-use-common-help-functions-to-free-reserved-pages.patch
mm-s390-use-common-help-functions-to-free-reserved-pages.patch
mm-score-use-common-help-functions-to-free-reserved-pages.patch
mm-sh-use-common-help-functions-to-free-reserved-pages.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch
mm-um-use-common-help-functions-to-free-reserved-pages.patch
mm-unicore32-use-common-help-functions-to-free-reserved-pages.patch
mm-x86-use-common-help-functions-to-free-reserved-pages.patch
mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch
mm-arc-use-common-help-functions-to-free-reserved-pages.patch
mm-metag-use-common-help-functions-to-free-reserved-pages.patch
mmkexec-use-common-help-functions-to-free-reserved-pages.patch

