From: akpm@linux-foundation.org
Subject: [merged] mm-h8300-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:19 -0700
Message-ID: <20130430184519.7832831C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:51845 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3SpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:20 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so84629qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/h8300: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-h8300-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

