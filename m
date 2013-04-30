From: akpm@linux-foundation.org
Subject: [merged] mm-ppc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:39 -0700
Message-ID: <20130430184639.889F95A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:36587 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab3D3Sql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:41 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so75543ves.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, agraf@suse.de, benh@kernel.crashing.org, jiang.liu@huawei.com, paulus@samba.org, suzuki@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/PPC: use free_highmem_page() to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-ppc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/PPC: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/powerpc/mm/mem.c~mm-ppc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-ppc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/powerpc/mm/mem.c
@@ -352,13 +352,9 @@ void __init mem_init(void)
 			struct page *page = pfn_to_page(pfn);
 			if (memblock_is_reserved(paddr))
 				continue;
-			ClearPageReserved(page);
-			init_page_count(page);
-			__free_page(page);
-			totalhigh_pages++;
+			free_highmem_page(page);
 			reservedpages--;
 		}
-		totalram_pages += totalhigh_pages;
 		printk(KERN_DEBUG "High memory: %luk\n",
 		       totalhigh_pages << (PAGE_SHIFT-10));
 	}
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

