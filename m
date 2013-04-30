From: akpm@linux-foundation.org
Subject: [merged] mm-ia64-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:22 -0700
Message-ID: <20130430184522.7CF8931C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:62463 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3SpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:23 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so84392yha.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, fenghua.yu@intel.com, jiang.liu@huawei.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/IA64: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-ia64-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/IA64: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff -puN arch/ia64/mm/init.c~mm-ia64-use-common-help-functions-to-free-reserved-pages arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-ia64-use-common-help-functions-to-free-reserved-pages
+++ a/arch/ia64/mm/init.c
@@ -154,25 +154,14 @@ ia64_init_addr_space (void)
 void
 free_initmem (void)
 {
-	unsigned long addr, eaddr;
-
-	addr = (unsigned long) ia64_imva(__init_begin);
-	eaddr = (unsigned long) ia64_imva(__init_end);
-	while (addr < eaddr) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		++totalram_pages;
-		addr += PAGE_SIZE;
-	}
-	printk(KERN_INFO "Freeing unused kernel memory: %ldkB freed\n",
-	       (__init_end - __init_begin) >> 10);
+	free_reserved_area((unsigned long)ia64_imva(__init_begin),
+			   (unsigned long)ia64_imva(__init_end),
+			   0, "unused kernel");
 }
 
 void __init
 free_initrd_mem (unsigned long start, unsigned long end)
 {
-	struct page *page;
 	/*
 	 * EFI uses 4KB pages while the kernel can use 4KB or bigger.
 	 * Thus EFI and the kernel may have different page sizes. It is
@@ -213,11 +202,7 @@ free_initrd_mem (unsigned long start, un
 	for (; start < end; start += PAGE_SIZE) {
 		if (!virt_addr_valid(start))
 			continue;
-		page = virt_to_page(start);
-		ClearPageReserved(page);
-		init_page_count(page);
-		free_page(start);
-		++totalram_pages;
+		free_reserved_page(virt_to_page(start));
 	}
 }
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

