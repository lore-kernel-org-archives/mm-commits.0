From: akpm@linux-foundation.org
Subject: [merged] mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:36 -0700
Message-ID: <20130430184636.7C8FF5A4278@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39572 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab3D3Sqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:37 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so84737qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, amwang@redhat.com, arnd@arndb.de, david.daney@cavium.com, jiang.liu@huawei.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/MIPS: use free_highmem_page() to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/MIPS: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/mips/mm/init.c~mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/mips/mm/init.c
@@ -393,12 +393,8 @@ void __init mem_init(void)
 			SetPageReserved(page);
 			continue;
 		}
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
-		totalhigh_pages++;
+		free_highmem_page(page);
 	}
-	totalram_pages += totalhigh_pages;
 	num_physpages += totalhigh_pages;
 #endif
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

