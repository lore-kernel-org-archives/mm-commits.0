From: akpm@linux-foundation.org
Subject: [merged] mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:27 -0700
Message-ID: <20130430184627.7DBBD31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:43180 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab3D3Sq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:28 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so84539yha.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, jiang.liu@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/FRV: use free_highmem_page() to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/FRV: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Also fix a bug that totalhigh_pages should be increased when freeing
a highmem page into the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/init.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/frv/mm/init.c~mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/frv/mm/init.c
@@ -131,10 +131,8 @@ void __init mem_init(void)
 			datapages++;
 
 #ifdef CONFIG_HIGHMEM
-	for (pfn = num_physpages - 1; pfn >= num_mappedpages; pfn--) {
-		__free_reserved_page(&mem_map[pfn]);
-		totalram_pages++;
-	}
+	for (pfn = num_physpages - 1; pfn >= num_mappedpages; pfn--)
+		free_highmem_page(&mem_map[pfn]);
 #endif
 
 	codek = ((unsigned long) &_etext - (unsigned long) &_stext) >> 10;
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

