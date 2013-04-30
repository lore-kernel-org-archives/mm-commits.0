From: akpm@linux-foundation.org
Subject: [merged] mm-avr32-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:04 -0700
Message-ID: <20130430184504.7B6E85A426B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45856 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772Ab3D3SpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:05 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so84585vbf.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/avr32: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-avr32-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/avr32: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/init.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff -puN arch/avr32/mm/init.c~mm-avr32-use-common-help-functions-to-free-reserved-pages arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~mm-avr32-use-common-help-functions-to-free-reserved-pages
+++ a/arch/avr32/mm/init.c
@@ -146,34 +146,14 @@ void __init mem_init(void)
 		initsize >> 10);
 }
 
-static inline void free_area(unsigned long addr, unsigned long end, char *s)
-{
-	unsigned int size = (end - addr) >> 10;
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		struct page *page = virt_to_page(addr);
-		ClearPageReserved(page);
-		init_page_count(page);
-		free_page(addr);
-		totalram_pages++;
-	}
-
-	if (size && s)
-		printk(KERN_INFO "Freeing %s memory: %dK (%lx - %lx)\n",
-		       s, size, end - (size << 10), end);
-}
-
 void free_initmem(void)
 {
-	free_area((unsigned long)__init_begin, (unsigned long)__init_end,
-		  "init");
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_area(start, end, "initrd");
+	free_reserved_area(start, end, 0, "initrd");
 }
