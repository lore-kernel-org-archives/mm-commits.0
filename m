From: akpm@linux-foundation.org
Subject: [merged] mm-frv-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:16 -0700
Message-ID: <20130430184516.7686F31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:43610 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760969Ab3D3SpR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:17 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so84607qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, dhowells@redhat.com, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/FRV: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-frv-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/FRV: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/init.c |   34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff -puN arch/frv/mm/init.c~mm-frv-use-common-help-functions-to-free-reserved-pages arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~mm-frv-use-common-help-functions-to-free-reserved-pages
+++ a/arch/frv/mm/init.c
@@ -122,7 +122,7 @@ void __init mem_init(void)
 #endif
 	int codek = 0, datak = 0;
 
-	/* this will put all memory onto the freelists */
+	/* this will put all low memory onto the freelists */
 	totalram_pages = free_all_bootmem();
 
 #ifdef CONFIG_MMU
@@ -132,11 +132,7 @@ void __init mem_init(void)
 
 #ifdef CONFIG_HIGHMEM
 	for (pfn = num_physpages - 1; pfn >= num_mappedpages; pfn--) {
-		struct page *page = &mem_map[pfn];
-
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
+		__free_reserved_page(&mem_map[pfn]);
 		totalram_pages++;
 	}
 #endif
@@ -168,21 +164,7 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 #if defined(CONFIG_RAMKERNEL) && !defined(CONFIG_PROTECT_KERNEL)
-	unsigned long start, end, addr;
-
-	start = PAGE_ALIGN((unsigned long) &__init_begin);	/* round up */
-	end   = ((unsigned long) &__init_end) & PAGE_MASK;	/* round down */
-
-	/* next to check that the page we free is not a partial page */
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-
-	printk("Freeing unused kernel memory: %ldKiB freed (0x%lx - 0x%lx)\n",
-	       (end - start) >> 10, start, end);
+	free_initmem_default(0);
 #endif
 } /* end free_initmem() */
 
@@ -193,14 +175,6 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	int pages = 0;
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-		pages++;
-	}
-	printk("Freeing initrd memory: %dKiB freed\n", (pages * PAGE_SIZE) >> 10);
+	free_reserved_area(start, end, 0, "initrd");
 } /* end free_initrd_mem() */
 #endif
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

