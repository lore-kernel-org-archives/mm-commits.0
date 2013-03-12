From: akpm@linux-foundation.org
Subject: + mm-x86-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:23:02 -0700
Message-ID: <20130312212302.D39FE31C23C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:60585 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:23:04 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so38372vea.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:23:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, hpa@zytor.com, jiang.liu@huawei.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm/x86: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-x86-use-common-help-functions-to-free-reserved-pages.patch

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
Subject: mm/x86: use common help functions to free reserved pages

Use common help functions to free reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c    |    5 +----
 arch/x86/mm/init_64.c |    5 ++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN arch/x86/mm/init.c~mm-x86-use-common-help-functions-to-free-reserved-pages arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~mm-x86-use-common-help-functions-to-free-reserved-pages
+++ a/arch/x86/mm/init.c
@@ -515,11 +515,8 @@ void free_init_pages(char *what, unsigne
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(addr));
-		init_page_count(virt_to_page(addr));
 		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		free_page(addr);
-		totalram_pages++;
+		free_reserved_page(virt_to_page(addr));
 	}
 #endif
 }
diff -puN arch/x86/mm/init_64.c~mm-x86-use-common-help-functions-to-free-reserved-pages arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-x86-use-common-help-functions-to-free-reserved-pages
+++ a/arch/x86/mm/init_64.c
@@ -1067,10 +1067,9 @@ void __init mem_init(void)
 
 	/* clear_bss() already clear the empty_zero_page */
 
-	reservedpages = 0;
-
-	/* this will put all low memory onto the freelists */
 	register_page_bootmem_info();
+
+	/* this will put all memory onto the freelists */
 	totalram_pages = free_all_bootmem();
 
 	absent_pages = absent_pages_in_range(0, max_pfn);
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

