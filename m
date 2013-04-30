From: akpm@linux-foundation.org
Subject: [merged] mm-parisc-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:43 -0700
Message-ID: <20130430184543.7C64E31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:62530 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3Spo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:44 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so84624yen.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, deller@gmx.de, jejb@parisc-linux.org, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/parisc: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-parisc-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/parisc: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/init.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff -puN arch/parisc/mm/init.c~mm-parisc-use-common-help-functions-to-free-reserved-pages arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-parisc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/parisc/mm/init.c
@@ -505,7 +505,6 @@ static void __init map_pages(unsigned lo
 
 void free_initmem(void)
 {
-	unsigned long addr;
 	unsigned long init_begin = (unsigned long)__init_begin;
 	unsigned long init_end = (unsigned long)__init_end;
 
@@ -533,19 +532,10 @@ void free_initmem(void)
 	 * pages are no-longer executable */
 	flush_icache_range(init_begin, init_end);
 	
-	for (addr = init_begin; addr < init_end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		num_physpages++;
-		totalram_pages++;
-	}
+	num_physpages += free_initmem_default(0);
 
 	/* set up a new led state on systems shipped LED State panel */
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_BCOMPLETE);
-	
-	printk(KERN_INFO "Freeing unused kernel memory: %luk freed\n",
-		(init_end - init_begin) >> 10);
 }
 
 
@@ -1109,15 +1099,6 @@ void flush_tlb_all(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (start >= end)
-		return;
-	printk(KERN_INFO "Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		num_physpages++;
-		totalram_pages++;
-	}
+	num_physpages += free_reserved_area(start, end, 0, "initrd");
 }
 #endif
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

