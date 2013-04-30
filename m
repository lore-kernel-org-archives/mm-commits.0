From: akpm@linux-foundation.org
Subject: [merged] mm-microblaze-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:33 -0700
Message-ID: <20130430184633.7B7D25A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:35545 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab3D3Sqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:34 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so84758qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, jiang.liu@huawei.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/microblaze: use free_highmem_page() to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-microblaze-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/microblaze: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/mm/init.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/microblaze/mm/init.c~mm-microblaze-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~mm-microblaze-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/microblaze/mm/init.c
@@ -82,13 +82,9 @@ static unsigned long highmem_setup(void)
 		/* FIXME not sure about */
 		if (memblock_is_reserved(pfn << PAGE_SHIFT))
 			continue;
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-		totalhigh_pages++;
+		free_highmem_page(page);
 		reservedpages++;
 	}
-	totalram_pages += totalhigh_pages;
 	pr_info("High memory: %luk\n",
 					totalhigh_pages << (PAGE_SHIFT-10));
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

