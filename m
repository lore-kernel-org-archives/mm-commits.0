From: akpm@linux-foundation.org
Subject: [merged] mm-x86-use-common-help-functions-to-free-reserved-pages.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:04 -0700
Message-ID: <20130430184604.8548F5A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:58715 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab3D3SqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:05 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so84771yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, hpa@zytor.com, jiang.liu@huawei.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/x86: use common help functions to free reserved pages
has been removed from the -mm tree.  Its filename was
     mm-x86-use-common-help-functions-to-free-reserved-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
