From: akpm@linux-foundation.org
Subject: + mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:38 -0700
Message-ID: <20130312212238.CB25431C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45721 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:40 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so53799qaj.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, jiang.liu@huawei.com, monstr@monstr.eu


The patch titled
     Subject: mm/microblaze: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch

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
Subject: mm/microblaze: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/setup.h |    1 
 arch/microblaze/mm/init.c           |   28 +-------------------------
 2 files changed, 2 insertions(+), 27 deletions(-)

diff -puN arch/microblaze/include/asm/setup.h~mm-microblaze-use-common-help-functions-to-free-reserved-pages arch/microblaze/include/asm/setup.h
--- a/arch/microblaze/include/asm/setup.h~mm-microblaze-use-common-help-functions-to-free-reserved-pages
+++ a/arch/microblaze/include/asm/setup.h
@@ -46,7 +46,6 @@ void machine_shutdown(void);
 void machine_halt(void);
 void machine_power_off(void);
 
-void free_init_pages(char *what, unsigned long begin, unsigned long end);
 extern void *alloc_maybe_bootmem(size_t size, gfp_t mask);
 extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
 
diff -puN arch/microblaze/mm/init.c~mm-microblaze-use-common-help-functions-to-free-reserved-pages arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~mm-microblaze-use-common-help-functions-to-free-reserved-pages
+++ a/arch/microblaze/mm/init.c
@@ -236,40 +236,16 @@ void __init setup_memory(void)
 	paging_init();
 }
 
-void free_init_pages(char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long addr;
-
-	for (addr = begin; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-	pr_info("Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
-}
-
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	int pages = 0;
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-		pages++;
-	}
-	pr_notice("Freeing initrd memory: %dk freed\n",
-					(int)(pages * (PAGE_SIZE / 1024)));
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
 void free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
-			(unsigned long)(&__init_begin),
-			(unsigned long)(&__init_end));
+	free_initmem_default(0);
 }
 
 void __init mem_init(void)
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

