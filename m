From: akpm@linux-foundation.org
Subject: + mm-score-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:52 -0700
Message-ID: <20130312212252.BB5975A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44947 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:53 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so38552ghb.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, jiang.liu@huawei.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com


The patch titled
     Subject: mm/score: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-score-use-common-help-functions-to-free-reserved-pages.patch

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
Subject: mm/score: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/mm/init.c |   33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff -puN arch/score/mm/init.c~mm-score-use-common-help-functions-to-free-reserved-pages arch/score/mm/init.c
--- a/arch/score/mm/init.c~mm-score-use-common-help-functions-to-free-reserved-pages
+++ a/arch/score/mm/init.c
@@ -43,7 +43,7 @@ EXPORT_SYMBOL_GPL(empty_zero_page);
 
 static struct kcore_list kcore_mem, kcore_vmalloc;
 
-static unsigned long setup_zero_page(void)
+static void setup_zero_page(void)
 {
 	struct page *page;
 
@@ -52,9 +52,7 @@ static unsigned long setup_zero_page(voi
 		panic("Oh boy, that early out of memory?");
 
 	page = virt_to_page((void *) empty_zero_page);
-	SetPageReserved(page);
-
-	return 1UL;
+	mark_page_reserved(page);
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -84,7 +82,7 @@ void __init mem_init(void)
 
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	totalram_pages += free_all_bootmem();
-	totalram_pages -= setup_zero_page();	/* Setup zeroed pages. */
+	setup_zero_page();	/* Setup zeroed pages. */
 	reservedpages = 0;
 
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
@@ -109,37 +107,16 @@ void __init mem_init(void)
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-static void free_init_pages(const char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long pfn;
-
-	for (pfn = PFN_UP(begin); pfn < PFN_DOWN(end); pfn++) {
-		struct page *page = pfn_to_page(pfn);
-		void *addr = phys_to_virt(PFN_PHYS(pfn));
-
-		ClearPageReserved(page);
-		init_page_count(page);
-		memset(addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		__free_page(page);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
-}
-
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory",
-		virt_to_phys((void *) start),
-		virt_to_phys((void *) end));
+	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
 }
 #endif
 
 void __init_refok free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
-	__pa(&__init_begin),
-	__pa(&__init_end));
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 unsigned long pgd_current;
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

