From: akpm@linux-foundation.org
Subject: [merged] mm-sparc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:42 -0700
Message-ID: <20130430184642.7B8B05A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:58730 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab3D3Sqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:43 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so86404qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, davem@davemloft.net, jiang.liu@huawei.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/SPARC: use free_highmem_page() to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-sparc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/SPARC: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_32.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN arch/sparc/mm/init_32.c~mm-sparc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~mm-sparc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/sparc/mm/init_32.c
@@ -282,14 +282,8 @@ static void map_high_region(unsigned lon
 	printk("mapping high region %08lx - %08lx\n", start_pfn, end_pfn);
 #endif
 
-	for (tmp = start_pfn; tmp < end_pfn; tmp++) {
-		struct page *page = pfn_to_page(tmp);
-
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-		totalhigh_pages++;
-	}
+	for (tmp = start_pfn; tmp < end_pfn; tmp++)
+		free_highmem_page(pfn_to_page(tmp));
 }
 
 void __init mem_init(void)
@@ -347,8 +341,6 @@ void __init mem_init(void)
 		map_high_region(start_pfn, end_pfn);
 	}
 	
-	totalram_pages += totalhigh_pages;
