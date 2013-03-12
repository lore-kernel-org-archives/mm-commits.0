From: akpm@linux-foundation.org
Subject: + mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:43:48 -0700
Message-ID: <20130312214348.D8C3F31C230@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38708 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641Ab3CLVnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:43:50 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so32712vbb.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:43:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, jdike@addtoit.com, jiang.liu@huawei.com, richard@nod.at


The patch titled
     Subject: mm/um: use free_highmem_page() to free highmem pages into buddy system
has been added to the -mm tree.  Its filename is
     mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

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
Subject: mm/um: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff -puN arch/um/kernel/mem.c~mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/um/kernel/mem.c
@@ -42,17 +42,12 @@ static unsigned long brk_end;
 static void setup_highmem(unsigned long highmem_start,
 			  unsigned long highmem_len)
 {
-	struct page *page;
 	unsigned long highmem_pfn;
 	int i;
 
 	highmem_pfn = __pa(highmem_start) >> PAGE_SHIFT;
-	for (i = 0; i < highmem_len >> PAGE_SHIFT; i++) {
-		page = &mem_map[highmem_pfn + i];
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-	}
+	for (i = 0; i < highmem_len >> PAGE_SHIFT; i++)
+		free_highmem_page(&mem_map[highmem_pfn + i]);
 }
 #endif
 
@@ -73,18 +68,13 @@ void __init mem_init(void)
 	totalram_pages = free_all_bootmem();
 	max_low_pfn = totalram_pages;
 #ifdef CONFIG_HIGHMEM
-	totalhigh_pages = highmem >> PAGE_SHIFT;
-	totalram_pages += totalhigh_pages;
+	setup_highmem(end_iomem, highmem);
 #endif
 	num_physpages = totalram_pages;
 	max_pfn = totalram_pages;
 	printk(KERN_INFO "Memory: %luk available\n",
 	       nr_free_pages() << (PAGE_SHIFT-10));
 	kmalloc_ok = 1;
-
-#ifdef CONFIG_HIGHMEM
-	setup_highmem(end_iomem, highmem);
-#endif
 }
 
 /*
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
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-metag-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-microblaze-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-ppc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-sparc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

