From: akpm@linux-foundation.org
Subject: [merged] mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:24 -0700
Message-ID: <20130430184624.853425A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:35144 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311Ab3D3SqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:25 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so84767yen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, linus.walleij@linaro.org, linux@arm.linux.org.uk, m.szyprowski@samsung.com, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ARM: use free_highmem_page() to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

