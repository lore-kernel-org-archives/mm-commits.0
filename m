From: akpm@linux-foundation.org
Subject: [merged] mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:40 -0700
Message-ID: <20130430184540.7585931C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:43677 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3Spl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:41 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so84725qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, jonas@southpole.se, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/openrisc: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/openrisc: use common help functions to free reserved pages

Use common help functions to free reserved pages.
Also include <asm/sections.h> to avoid local declarations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/mm/init.c |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

diff -puN arch/openrisc/mm/init.c~mm-openrisc-use-common-help-functions-to-free-reserved-pages arch/openrisc/mm/init.c
--- a/arch/openrisc/mm/init.c~mm-openrisc-use-common-help-functions-to-free-reserved-pages
+++ a/arch/openrisc/mm/init.c
@@ -43,6 +43,7 @@
 #include <asm/kmap_types.h>
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
+#include <asm/sections.h>
 
 int mem_init_done;
 
@@ -201,9 +202,6 @@ void __init paging_init(void)
 
 /* References to section boundaries */
 
-extern char _stext, _etext, _edata, __bss_start, _end;
-extern char __init_begin, __init_end;
-
 static int __init free_pages_init(void)
 {
 	int reservedpages, pfn;
@@ -263,30 +261,11 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	printk(KERN_INFO "Freeing initrd memory: %ldk freed\n",
-	       (end - start) >> 10);
-
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-	}
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
 void free_initmem(void)
 {
-	unsigned long addr;
