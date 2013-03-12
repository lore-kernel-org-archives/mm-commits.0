From: akpm@linux-foundation.org
Subject: + mm-avr32-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:22:20 -0700
Message-ID: <20130312212220.CCEAE5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:50613 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab3CLVWW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:22:22 -0400
Received: by mail-ye0-f201.google.com with SMTP id m12so38307yen.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:22:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, jiang.liu@huawei.com


The patch titled
     Subject: mm/avr32: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-avr32-use-common-help-functions-to-free-reserved-pages.patch

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
-
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

