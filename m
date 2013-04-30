From: akpm@linux-foundation.org
Subject: [merged] mm-m32r-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:25 -0700
Message-ID: <20130430184525.7678E5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45278 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3Sp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:26 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so86184qab.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/m32r: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-m32r-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/m32r: use common help functions to free reserved pages

Use common help functions to free reserved pages.
Also include <asm/sections.h> to avoid local declarations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/init.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff -puN arch/m32r/mm/init.c~mm-m32r-use-common-help-functions-to-free-reserved-pages arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~mm-m32r-use-common-help-functions-to-free-reserved-pages
+++ a/arch/m32r/mm/init.c
@@ -28,10 +28,7 @@
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/tlb.h>
-
-/* References to section boundaries */
-extern char _text, _etext, _edata;
-extern char __init_begin, __init_end;
+#include <asm/sections.h>
 
 pgd_t swapper_pg_dir[1024];
 
@@ -184,17 +181,7 @@ void __init mem_init(void)
  *======================================================================*/
 void free_initmem(void)
 {
-	unsigned long addr;
-
-	addr = (unsigned long)(&__init_begin);
-	for (; addr < (unsigned long)(&__init_end); addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-	printk (KERN_INFO "Freeing unused kernel memory: %dk freed\n", \
-	  (int)(&__init_end - &__init_begin) >> 10);
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -204,13 +191,6 @@ void free_initmem(void)
  *======================================================================*/
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	unsigned long p;
-	for (p = start; p < end; p += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(p));
-		init_page_count(virt_to_page(p));
-		free_page(p);
-		totalram_pages++;
-	}
-	printk (KERN_INFO "Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

