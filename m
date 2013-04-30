From: akpm@linux-foundation.org
Subject: [merged] mm-um-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:58 -0700
Message-ID: <20130430184558.75AAC31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39056 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3Sp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:59 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so84900vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jdike@addtoit.com, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/um: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-um-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/um: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN arch/um/kernel/mem.c~mm-um-use-common-help-functions-to-free-reserved-pages arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~mm-um-use-common-help-functions-to-free-reserved-pages
+++ a/arch/um/kernel/mem.c
@@ -254,15 +254,7 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (start < end)
-		printk(KERN_INFO "Freeing initrd memory: %ldk freed\n",
-		       (end - start) >> 10);
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-	}
+	free_reserved_area(start, end, 0, "initrd");
 }
 #endif
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

