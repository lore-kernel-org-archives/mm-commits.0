From: akpm@linux-foundation.org
Subject: [merged] mm-m68k-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:28 -0700
Message-ID: <20130430184528.779C631C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:63867 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3Sp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:29 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so84701qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, geert@linux-m68k.org, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/m68k: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-m68k-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/m68k: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/init.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff -puN arch/m68k/mm/init.c~mm-m68k-use-common-help-functions-to-free-reserved-pages arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~mm-m68k-use-common-help-functions-to-free-reserved-pages
+++ a/arch/m68k/mm/init.c
@@ -110,18 +110,7 @@ void __init paging_init(void)
 void free_initmem(void)
 {
 #ifndef CONFIG_MMU_SUN3
-	unsigned long addr;
-
-	addr = (unsigned long) __init_begin;
-	for (; addr < ((unsigned long) __init_end); addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-	pr_notice("Freeing unused kernel memory: %luk freed (0x%x - 0x%x)\n",
-		(addr - (unsigned long) __init_begin) >> 10,
-		(unsigned int) __init_begin, (unsigned int) __init_end);
+	free_initmem_default(0);
 #endif /* CONFIG_MMU_SUN3 */
 }
 
@@ -213,15 +202,6 @@ void __init mem_init(void)
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
-		pages << (PAGE_SHIFT - 10));
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

