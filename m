From: akpm@linux-foundation.org
Subject: [merged] mm-metag-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:30 -0700
Message-ID: <20130430184630.7781731C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:37158 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab3D3Sqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:31 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so84430yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, james.hogan@imgtec.com, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/metag: use free_highmem_page() to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-metag-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/metag: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/mm/init.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN arch/metag/mm/init.c~mm-metag-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/metag/mm/init.c
--- a/arch/metag/mm/init.c~mm-metag-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/metag/mm/init.c
@@ -380,14 +380,8 @@ void __init mem_init(void)
 
 #ifdef CONFIG_HIGHMEM
 	unsigned long tmp;
-	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++) {
-		struct page *page = pfn_to_page(tmp);
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-		totalhigh_pages++;
-	}
-	totalram_pages += totalhigh_pages;
+	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++)
+		free_highmem_page(pfn_to_page(tmp));
 	num_physpages += totalhigh_pages;
 #endif /* CONFIG_HIGHMEM */
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

