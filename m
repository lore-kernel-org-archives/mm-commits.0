From: akpm@linux-foundation.org
Subject: + mm-ia64-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:32 -0700
Message-ID: <20130312212232.C7A9F5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39126 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:33 -0400
Received: by mail-gg0-f202.google.com with SMTP id l4so38328ggi.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, fenghua.yu@intel.com, jiang.liu@huawei.com, tony.luck@intel.com


The patch titled
     Subject: mm/IA64: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-ia64-use-common-help-functions-to-free-reserved-pages.patch

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
Subject: mm/IA64: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff -puN arch/ia64/mm/init.c~mm-ia64-use-common-help-functions-to-free-reserved-pages arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-ia64-use-common-help-functions-to-free-reserved-pages
+++ a/arch/ia64/mm/init.c
@@ -154,25 +154,14 @@ ia64_init_addr_space (void)
 void
 free_initmem (void)
 {
-	unsigned long addr, eaddr;
-
-	addr = (unsigned long) ia64_imva(__init_begin);
-	eaddr = (unsigned long) ia64_imva(__init_end);
-	while (addr < eaddr) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
-		free_page(addr);
-		++totalram_pages;
-		addr += PAGE_SIZE;
-	}
-	printk(KERN_INFO "Freeing unused kernel memory: %ldkB freed\n",
-	       (__init_end - __init_begin) >> 10);
+	free_reserved_area((unsigned long)ia64_imva(__init_begin),
+			   (unsigned long)ia64_imva(__init_end),
+			   0, "unused kernel");
 }
 
 void __init
 free_initrd_mem (unsigned long start, unsigned long end)
 {
-	struct page *page;
 	/*
 	 * EFI uses 4KB pages while the kernel can use 4KB or bigger.
 	 * Thus EFI and the kernel may have different page sizes. It is
@@ -213,11 +202,7 @@ free_initrd_mem (unsigned long start, un
 	for (; start < end; start += PAGE_SIZE) {
 		if (!virt_addr_valid(start))
 			continue;
-		page = virt_to_page(start);
-		ClearPageReserved(page);
-		init_page_count(page);
-		free_page(start);
-		++totalram_pages;
+		free_reserved_page(virt_to_page(start));
 	}
 }
 
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

