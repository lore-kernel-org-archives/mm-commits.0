From: akpm@linux-foundation.org
Subject: [merged] mm-unicore32-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:01 -0700
Message-ID: <20130430184601.75F5231C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:36150 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760813Ab3D3SqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:03 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so75524veb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, gxt@mprc.pku.edu.cn, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/unicore32: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-unicore32-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/unicore32: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/mm/init.c |   28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff -puN arch/unicore32/mm/init.c~mm-unicore32-use-common-help-functions-to-free-reserved-pages arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c~mm-unicore32-use-common-help-functions-to-free-reserved-pages
+++ a/arch/unicore32/mm/init.c
@@ -316,24 +316,6 @@ void __init bootmem_init(void)
 	max_pfn = max_high - PHYS_PFN_OFFSET;
 }
 
-static inline int free_area(unsigned long pfn, unsigned long end, char *s)
-{
-	unsigned int pages = 0, size = (end - pfn) << (PAGE_SHIFT - 10);
-
-	for (; pfn < end; pfn++) {
-		struct page *page = pfn_to_page(pfn);
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-		pages++;
-	}
-
-	if (size && s)
-		printk(KERN_INFO "Freeing %s memory: %dK\n", s, size);
-
-	return pages;
-}
-
 static inline void
 free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -407,9 +389,9 @@ void __init mem_init(void)
 
 	max_mapnr   = pfn_to_page(max_pfn + PHYS_PFN_OFFSET) - mem_map;
 
-	/* this will put all unused low memory onto the freelists */
 	free_unused_memmap(&meminfo);
 
+	/* this will put all unused low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
 
 	reserved_pages = free_pages = 0;
@@ -494,9 +476,7 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	totalram_pages += free_area(__phys_to_pfn(__pa(__init_begin)),
-				    __phys_to_pfn(__pa(__init_end)),
-				    "init");
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -506,9 +486,7 @@ static int keep_initrd;
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (!keep_initrd)
-		totalram_pages += free_area(__phys_to_pfn(__pa(start)),
-					    __phys_to_pfn(__pa(end)),
-					    "initrd");
+		free_reserved_area(start, end, 0, "initrd");
 }
 
 static int __init keepinitrd_setup(char *__unused)
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

