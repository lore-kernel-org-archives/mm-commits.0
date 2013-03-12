From: akpm@linux-foundation.org
Subject: + mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:23:04 -0700
Message-ID: <20130312212304.CA43431C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:57296 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab3CLVXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:23:06 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so30865vbb.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:23:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, chris@zankel.net, jcmvbkbc@gmail.com, jiang.liu@huawei.com


The patch titled
     Subject: mm/xtensa: use common help functions to free reserved pages
has been added to the -mm tree.  Its filename is
     mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch

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

