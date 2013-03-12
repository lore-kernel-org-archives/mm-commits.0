From: akpm@linux-foundation.org
Subject: + mm-h8300-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:30 -0700
Message-ID: <20130312212230.C690E31C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59381 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:31 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so38526ghb.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, jiang.liu@huawei.com, ysato@users.sourceforge.jp


The patch titled
     Subject: mm/h8300: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-h8300-use-common-help-functions-to-free-reserved-pages.patch

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
Subject: mm/h8300: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/mm/init.c |   30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff -puN arch/h8300/mm/init.c~mm-h8300-use-common-help-functions-to-free-reserved-pages arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~mm-h8300-use-common-help-functions-to-free-reserved-pages
+++ a/arch/h8300/mm/init.c
@@ -139,7 +139,7 @@ void __init mem_init(void)
 	start_mem = PAGE_ALIGN(start_mem);
 	max_mapnr = num_physpages = MAP_NR(high_memory);
 
-	/* this will put all memory onto the freelists */
+	/* this will put all low memory onto the freelists */
 	totalram_pages = free_all_bootmem();
 
 	codek = (_etext - _stext) >> 10;
@@ -161,15 +161,7 @@ void __init mem_init(void)
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
-	printk ("Freeing initrd memory: %dk freed\n", pages);
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
@@ -177,23 +169,7 @@ void
 free_initmem(void)
 {
 #ifdef CONFIG_RAMKERNEL
-	unsigned long addr;
-/*
- *	the following code should be cool even if these sections
- *	are not page aligned.
- */
-	addr = PAGE_ALIGN((unsigned long)(__init_begin));
-	/* next to check that the page we free is not a partial page */
-	for (; addr + PAGE_SIZE < (unsigned long)__init_end; addr +=PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing unused kernel memory: %ldk freed (0x%x - 0x%x)\n",
-			(addr - PAGE_ALIGN((long) __init_begin)) >> 10,
-			(int)(PAGE_ALIGN((unsigned long)__init_begin)),
-			(int)(addr - PAGE_SIZE));
+	free_initmem_default(0);
 #endif
 }
 
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

