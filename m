From: akpm@linux-foundation.org
Subject: [merged]
 mm-score-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:38 -0700
Message-ID: <51db12aa.VntfxSSnGf8f8eqg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3GHT1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liqin.chen@sunplusct.com, lennox.wu@gmail.com, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] mm-score-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,lennox.wu@gmail.com,liqin.chen@sunplusct.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:38 -0700


The patch titled
     Subject: mm/score: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-score-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/score: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/mm/init.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff -puN arch/score/mm/init.c~mm-score-prepare-for-removing-num_physpages-and-simplify-mem_init arch/score/mm/init.c
--- a/arch/score/mm/init.c~mm-score-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/score/mm/init.c
@@ -75,33 +75,11 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	unsigned long codesize, reservedpages, datasize, initsize;
-	unsigned long tmp, ram = 0;
-
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	free_all_bootmem();
 	setup_zero_page();	/* Setup zeroed pages. */
-	reservedpages = 0;
-
-	for (tmp = 0; tmp < max_low_pfn; tmp++)
-		if (page_is_ram(tmp)) {
-			ram++;
-			if (PageReserved(pfn_to_page(tmp)))
-				reservedpages++;
-		}
