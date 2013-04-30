From: akpm@linux-foundation.org
Subject: [merged] mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:07 -0700
Message-ID: <20130430184607.7A6B331C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:62850 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3SqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:08 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so75490ves.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, chris@zankel.net, jcmvbkbc@gmail.com, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/xtensa: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/xtensa: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/init.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff -puN arch/xtensa/mm/init.c~mm-xtensa-use-common-help-functions-to-free-reserved-pages arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~mm-xtensa-use-common-help-functions-to-free-reserved-pages
+++ a/arch/xtensa/mm/init.c
@@ -208,32 +208,17 @@ void __init mem_init(void)
 	       highmemsize >> 10);
 }
 
-void
-free_reserved_mem(void *start, void *end)
-{
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page((unsigned long)start);
-		totalram_pages++;
-	}
-}
-
 #ifdef CONFIG_BLK_DEV_INITRD
 extern int initrd_is_mapped;
 
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (initrd_is_mapped) {
-		free_reserved_mem((void*)start, (void*)end);
-		printk ("Freeing initrd memory: %ldk freed\n",(end-start)>>10);
-	}
+	if (initrd_is_mapped)
+		free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
 void free_initmem(void)
 {
-	free_reserved_mem(__init_begin, __init_end);
-	printk("Freeing unused kernel memory: %zuk freed\n",
-	       (__init_end - __init_begin) >> 10);
+	free_initmem_default(0);
 }
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

