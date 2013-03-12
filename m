From: akpm@linux-foundation.org
Subject: + mm-frv-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:28 -0700
Message-ID: <20130312212228.C2D445A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:56764 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:30 -0400
Received: by mail-gg0-f202.google.com with SMTP id l4so38326ggi.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, dhowells@redhat.com, jiang.liu@huawei.com


The patch titled
     Subject: mm/FRV: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-frv-use-common-help-functions-to-free-reserved-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/FRV: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/init.c |   34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff -puN arch/frv/mm/init.c~mm-frv-use-common-help-functions-to-free-reserved-pages arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~mm-frv-use-common-help-functions-to-free-reserved-pages
+++ a/arch/frv/mm/init.c
@@ -122,7 +122,7 @@ void __init mem_init(void)
 #endif
 	int codek = 0, datak = 0;
 
-	/* this will put all memory onto the freelists */
+	/* this will put all low memory onto the freelists */
 	totalram_pages = free_all_bootmem();
 
 #ifdef CONFIG_MMU
@@ -132,11 +132,7 @@ void __init mem_init(void)
 
 #ifdef CONFIG_HIGHMEM
 	for (pfn = num_physpages - 1; pfn >= num_mappedpages; pfn--) {
-		struct page *page = &mem_map[pfn];
-
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
+		__free_reserved_page(&mem_map[pfn]);
 		totalram_pages++;
 	}
 #endif
@@ -168,21 +164,7 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 #if defined(CONFIG_RAMKERNEL) && !defined(CONFIG_PROTECT_KERNEL)
-	unsigned long start, end, addr;
-
-	start = PAGE_ALIGN((unsigned long) &__init_begin);	/* round up */
-	end   = ((unsigned long) &__init_end) & PAGE_MASK;	/* round down */
-
-	/* next to check that the page we free is not a partial page */
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		totalram_pages++;
-	}
-
-	printk("Freeing unused kernel memory: %ldKiB freed (0x%lx - 0x%lx)\n",
-	       (end - start) >> 10, start, end);
+	free_initmem_default(0);
 #endif
 } /* end free_initmem() */
 
@@ -193,14 +175,6 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	int pages = 0;
-	for (; start < end; start += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(start));
-		init_page_count(virt_to_page(start));
-		free_page(start);
-		totalram_pages++;
-		pages++;
-	}
-	printk("Freeing initrd memory: %dKiB freed\n", (pages * PAGE_SIZE) >> 10);
+	free_reserved_area(start, end, 0, "initrd");
 } /* end free_initrd_mem() */
 #endif
_

Patches currently in -mm which might be from liuj97@gmail.com are

mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-alpha-use-common-help-functions-to-free-reserved-pages.patch
mm-arm-use-common-help-functions-to-free-reserved-pages.patch
mm-avr32-use-common-help-functions-to-free-reserved-pages.patch
mm-blackfin-use-common-help-functions-to-free-reserved-pages.patch
mm-c6x-use-common-help-functions-to-free-reserved-pages.patch
mm-cris-use-common-help-functions-to-free-reserved-pages.patch
mm-frv-use-common-help-functions-to-free-reserved-pages.patch
mm-h8300-use-common-help-functions-to-free-reserved-pages.patch
mm-ia64-use-common-help-functions-to-free-reserved-pages.patch
mm-m32r-use-common-help-functions-to-free-reserved-pages.patch
mm-m68k-use-common-help-functions-to-free-reserved-pages.patch
mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch
mm-mips-use-common-help-functions-to-free-reserved-pages.patch
mm-mn10300-use-common-help-functions-to-free-reserved-pages.patch
mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch
mm-parisc-use-common-help-functions-to-free-reserved-pages.patch
mm-ppc-use-common-help-functions-to-free-reserved-pages.patch
mm-s390-use-common-help-functions-to-free-reserved-pages.patch
mm-score-use-common-help-functions-to-free-reserved-pages.patch
mm-sh-use-common-help-functions-to-free-reserved-pages.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch
mm-um-use-common-help-functions-to-free-reserved-pages.patch
mm-unicore32-use-common-help-functions-to-free-reserved-pages.patch
mm-x86-use-common-help-functions-to-free-reserved-pages.patch
mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch
mm-arc-use-common-help-functions-to-free-reserved-pages.patch
mm-metag-use-common-help-functions-to-free-reserved-pages.patch
mmkexec-use-common-help-functions-to-free-reserved-pages.patch

