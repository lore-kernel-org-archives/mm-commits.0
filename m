From: akpm@linux-foundation.org
Subject: [merged] mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:31 -0700
Message-ID: <20130430184531.7AB945A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:47000 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3Spc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:32 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so84723yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/microblaze: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

