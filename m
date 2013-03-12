From: akpm@linux-foundation.org
Subject: + mm-s390-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:50 -0700
Message-ID: <20130312212250.CBE1E31C23C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:48023 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933595Ab3CLVWw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:52 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so53812qah.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, heiko.carstens@de.ibm.com, jiang.liu@huawei.com, schwidefsky@de.ibm.com


The patch titled
     Subject: mm/s390: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-s390-use-common-help-functions-to-free-reserved-pages.patch

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
Subject: mm/s390: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |   35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff -puN arch/s390/mm/init.c~mm-s390-use-common-help-functions-to-free-reserved-pages arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-s390-use-common-help-functions-to-free-reserved-pages
+++ a/arch/s390/mm/init.c
@@ -42,11 +42,10 @@ pgd_t swapper_pg_dir[PTRS_PER_PGD] __att
 unsigned long empty_zero_page, zero_page_mask;
 EXPORT_SYMBOL(empty_zero_page);
 
-static unsigned long __init setup_zero_pages(void)
+static void __init setup_zero_pages(void)
 {
 	struct cpuid cpu_id;
 	unsigned int order;
-	unsigned long size;
 	struct page *page;
 	int i;
 
@@ -83,14 +82,11 @@ static unsigned long __init setup_zero_p
 	page = virt_to_page((void *) empty_zero_page);
 	split_page(page, order);
 	for (i = 1 << order; i > 0; i--) {
-		SetPageReserved(page);
+		mark_page_reserved(page);
 		page++;
 	}
 
-	size = PAGE_SIZE << order;
-	zero_page_mask = (size - 1) & PAGE_MASK;
-
-	return 1UL << order;
+	zero_page_mask = ((PAGE_SIZE << order) - 1) & PAGE_MASK;
 }
 
 /*
@@ -147,7 +143,7 @@ void __init mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
-	totalram_pages -= setup_zero_pages();	/* Setup zeroed pages. */
+	setup_zero_pages();	/* Setup zeroed pages. */
 
 	reservedpages = 0;
 
@@ -166,34 +162,15 @@ void __init mem_init(void)
 	       PFN_ALIGN((unsigned long)&_eshared) - 1);
 }
 
-void free_init_pages(char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long addr = begin;
-
-	if (begin >= end)
-		return;
-	for (; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		memset((void *)(addr & PAGE_MASK), POISON_FREE_INITMEM,
-		       PAGE_SIZE);
-		free_page(addr);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
-}
-
 void free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
-			(unsigned long)&__init_begin,
-			(unsigned long)&__init_end);
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory", start, end);
+	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
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

