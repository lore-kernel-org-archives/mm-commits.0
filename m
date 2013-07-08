From: akpm@linux-foundation.org
Subject: [merged]
 mm-metag-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:22 -0700
Message-ID: <51db129a.NwGpnvS1B9Lqr5QJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3GHT1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] mm-metag-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:22 -0700


The patch titled
     Subject: mm/metag: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-metag-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/metag: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/mm/init.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/metag/mm/init.c~mm-metag-prepare-for-removing-num_physpages-and-simplify-mem_init arch/metag/mm/init.c
--- a/arch/metag/mm/init.c~mm-metag-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/metag/mm/init.c
@@ -388,22 +388,16 @@ void __init mem_init(void)
 	reset_all_zones_managed_pages();
 	for (tmp = highstart_pfn; tmp < highend_pfn; tmp++)
 		free_highmem_page(pfn_to_page(tmp));
-	num_physpages += totalhigh_pages;
 #endif /* CONFIG_HIGHMEM */
 
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 
-		num_physpages += pgdat->node_present_pages;
-
 		if (pgdat->node_spanned_pages)
 			free_all_bootmem_node(pgdat);
 	}
 
-	pr_info("Memory: %luk/%luk available\n",
-		(unsigned long)nr_free_pages() << (PAGE_SHIFT - 10),
-		num_physpages << (PAGE_SHIFT - 10));
