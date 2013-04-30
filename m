From: akpm@linux-foundation.org
Subject: [merged] mm-arm-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:45:01 -0700
Message-ID: <20130430184501.7FF695A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36026 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab3D3SpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:45:02 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so84501ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:45:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, catalin.marinas@arm.com, jiang.liu@huawei.com, linux@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ARM: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-arm-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/ARM: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c   |   48 +++++++++++++----------------------------
 arch/arm64/mm/init.c |   26 +---------------------
 2 files changed, 18 insertions(+), 56 deletions(-)

diff -puN arch/arm/mm/init.c~mm-arm-use-common-help-functions-to-free-reserved-pages arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~mm-arm-use-common-help-functions-to-free-reserved-pages
+++ a/arch/arm/mm/init.c
@@ -427,24 +427,6 @@ void __init bootmem_init(void)
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
 /*
  * Poison init memory with an undefined instruction (ARM) or a branch to an
  * undefined instruction (Thumb).
@@ -537,6 +519,16 @@ static void __init free_unused_memmap(st
 #endif
 }
 
+#ifdef CONFIG_HIGHMEM
+static inline void free_area_high(unsigned long pfn, unsigned long end)
+{
+	for (; pfn < end; pfn++) {
+		__free_reserved_page(pfn_to_page(pfn));
+		totalhigh_pages++;
+	}
+}
+#endif
+
 static void __init free_highpages(void)
 {
 #ifdef CONFIG_HIGHMEM
@@ -572,8 +564,7 @@ static void __init free_highpages(void)
 			if (res_end > end)
 				res_end = end;
 			if (res_start != start)
-				totalhigh_pages += free_area(start, res_start,
-							     NULL);
+				free_area_high(start, res_start);
 			start = res_end;
 			if (start == end)
 				break;
@@ -581,7 +572,7 @@ static void __init free_highpages(void)
 
 		/* And now free anything which remains */
 		if (start < end)
-			totalhigh_pages += free_area(start, end, NULL);
+			free_area_high(start, end);
 	}
 	totalram_pages += totalhigh_pages;
 #endif
@@ -612,8 +603,7 @@ void __init mem_init(void)
 
 #ifdef CONFIG_SA1111
 	/* now that our DMA memory is actually so designated, we can free it */
-	totalram_pages += free_area(PHYS_PFN_OFFSET,
-				    __phys_to_pfn(__pa(swapper_pg_dir)), NULL);
+	free_reserved_area(__va(PHYS_PFN_OFFSET), swapper_pg_dir, 0, NULL);
 #endif
 
 	free_highpages();
@@ -741,16 +731,12 @@ void free_initmem(void)
 	extern char __tcm_start, __tcm_end;
 
 	poison_init_mem(&__tcm_start, &__tcm_end - &__tcm_start);
-	totalram_pages += free_area(__phys_to_pfn(__pa(&__tcm_start)),
-				    __phys_to_pfn(__pa(&__tcm_end)),
-				    "TCM link");
+	free_reserved_area(&__tcm_start, &__tcm_end, 0, "TCM link");
 #endif
 
 	poison_init_mem(__init_begin, __init_end - __init_begin);
 	if (!machine_is_integrator() && !machine_is_cintegrator())
-		totalram_pages += free_area(__phys_to_pfn(__pa(__init_begin)),
-					    __phys_to_pfn(__pa(__init_end)),
-					    "init");
+		free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -761,9 +747,7 @@ void free_initrd_mem(unsigned long start
 {
 	if (!keep_initrd) {
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
-		totalram_pages += free_area(__phys_to_pfn(__pa(start)),
-					    __phys_to_pfn(__pa(end)),
-					    "initrd");
+		free_reserved_area(start, end, 0, "initrd");
 	}
 }
 
diff -puN arch/arm64/mm/init.c~mm-arm-use-common-help-functions-to-free-reserved-pages arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~mm-arm-use-common-help-functions-to-free-reserved-pages
+++ a/arch/arm64/mm/init.c
@@ -197,24 +197,6 @@ void __init bootmem_init(void)
 	max_pfn = max_low_pfn = max;
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
-		pr_info("Freeing %s memory: %dK\n", s, size);
-
-	return pages;
-}
-
 /*
  * Poison init memory with an undefined instruction (0x0).
  */
@@ -405,9 +387,7 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 	poison_init_mem(__init_begin, __init_end - __init_begin);
-	totalram_pages += free_area(__phys_to_pfn(__pa(__init_begin)),
-				    __phys_to_pfn(__pa(__init_end)),
-				    "init");
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -418,9 +398,7 @@ void free_initrd_mem(unsigned long start
 {
 	if (!keep_initrd) {
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
-		totalram_pages += free_area(__phys_to_pfn(__pa(start)),
-					    __phys_to_pfn(__pa(end)),
-					    "initrd");
+		free_reserved_area(start, end, 0, "initrd");
 	}
 }
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

