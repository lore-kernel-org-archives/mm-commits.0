From: akpm@linux-foundation.org
Subject: [merged] mm-mn10300-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:37 -0700
Message-ID: <20130430184537.767FF5A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51419 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3Spi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:38 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so84720yen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mn10300: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-mn10300-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/mn10300: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/mm/init.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff -puN arch/mn10300/mm/init.c~mm-mn10300-use-common-help-functions-to-free-reserved-pages arch/mn10300/mm/init.c
--- a/arch/mn10300/mm/init.c~mm-mn10300-use-common-help-functions-to-free-reserved-pages
+++ a/arch/mn10300/mm/init.c
@@ -139,30 +139,11 @@ void __init mem_init(void)
 }
 
 /*
- *
- */
-void free_init_pages(char *what, unsigned long begin, unsigned long end)
-{
-	unsigned long addr;
-
-	for (addr = begin; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		memset((void *) addr, 0xcc, PAGE_SIZE);
-		free_page(addr);
-		totalram_pages++;
-	}
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
-}
-
-/*
  * recycle memory containing stuff only required for initialisation
  */
 void free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
-			(unsigned long) &__init_begin,
-			(unsigned long) &__init_end);
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 /*
@@ -171,6 +152,6 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_init_pages("initrd memory", start, end);
+	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
 }
 #endif
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

