From: akpm@linux-foundation.org
Subject: + mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:43:34 -0700
Message-ID: <20130312214334.D269F5A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:52512 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab3CLVng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:43:36 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so55707qah.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:43:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, jiang.liu@huawei.com, linus.walleij@linaro.org, linux@arm.linux.org.uk, m.szyprowski@samsung.com, sboyd@codeaurora.org


The patch titled
     Subject: mm/ARM: use free_highmem_page() to free highmem pages into buddy system
has been added to the -mm tree.  Its filename is
     mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

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
Subject: mm/ARM: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/arm/mm/init.c~mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/arm/mm/init.c
@@ -522,10 +522,8 @@ static void __init free_unused_memmap(st
 #ifdef CONFIG_HIGHMEM
 static inline void free_area_high(unsigned long pfn, unsigned long end)
 {
-	for (; pfn < end; pfn++) {
-		__free_reserved_page(pfn_to_page(pfn));
-		totalhigh_pages++;
-	}
+	for (; pfn < end; pfn++)
+		free_highmem_page(pfn_to_page(pfn));
 }
 #endif
 
@@ -574,7 +572,6 @@ static void __init free_highpages(void)
 		if (start < end)
 			free_area_high(start, end);
 	}
-	totalram_pages += totalhigh_pages;
 #endif
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
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-metag-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-microblaze-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-ppc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-sparc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

