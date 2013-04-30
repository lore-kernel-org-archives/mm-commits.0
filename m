From: akpm@linux-foundation.org
Subject: [merged] mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:48 -0700
Message-ID: <20130430184648.995AE31C2B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:32860 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab3D3Squ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:50 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so84862yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, amwang@redhat.com, attilio.rao@citrix.com, hpa@zytor.com, jiang.liu@huawei.com, konrad.wilk@oracle.com, mingo@redhat.com, penberg@kernel.org, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/x86: use free_highmem_page() to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/x86: use free_highmem_page() to free highmem pages into buddy system

Use helper function free_highmem_page() to free highmem pages into
the buddy system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Attilio Rao <attilio.rao@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/highmem_32.c |    1 -
 arch/x86/mm/init_32.c    |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/x86/mm/highmem_32.c~mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/x86/mm/highmem_32.c
@@ -137,5 +137,4 @@ void __init set_highmem_pages_init(void)
 		add_highpages_with_active_regions(nid, zone_start_pfn,
 				 zone_end_pfn);
 	}
-	totalram_pages += totalhigh_pages;
 }
diff -puN arch/x86/mm/init_32.c~mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system
+++ a/arch/x86/mm/init_32.c
@@ -427,14 +427,6 @@ static void __init permanent_kmaps_init(
 	pkmap_page_table = pte;
 }
 
-static void __init add_one_highpage_init(struct page *page)
-{
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	totalhigh_pages++;
-}
