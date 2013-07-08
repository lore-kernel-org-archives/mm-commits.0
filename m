From: akpm@linux-foundation.org
Subject: [merged]
 mm-mn10300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:28 -0700
Message-ID: <51db12a0.9yF+UXD6R+achkvA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3GHT13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yasutake.koichi@jp.panasonic.com, jiang.liu@huawei.com, dhowells@redhat.com, liuj97@gmail.com

Subject: [merged] mm-mn10300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,dhowells@redhat.com,jiang.liu@huawei.com,yasutake.koichi@jp.panasonic.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:28 -0700


The patch titled
     Subject: mm/mn10300: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-mn10300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/mn10300: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/mm/init.c |   26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff -puN arch/mn10300/mm/init.c~mm-mn10300-prepare-for-removing-num_physpages-and-simplify-mem_init arch/mn10300/mm/init.c
--- a/arch/mn10300/mm/init.c~mm-mn10300-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/mn10300/mm/init.c
@@ -99,15 +99,12 @@ void __init paging_init(void)
  */
 void __init mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
-	int tmp;
-
 	BUG_ON(!mem_map);
 
 #define START_PFN	(contig_page_data.bdata->node_min_pfn)
 #define MAX_LOW_PFN	(contig_page_data.bdata->node_low_pfn)
 
-	max_mapnr = num_physpages = MAX_LOW_PFN - START_PFN;
+	max_mapnr = MAX_LOW_PFN - START_PFN;
 	high_memory = (void *) __va(MAX_LOW_PFN * PAGE_SIZE);
 
 	/* clear the zero-page */
@@ -116,26 +113,7 @@ void __init mem_init(void)
 	/* this will put all low memory onto the freelists */
 	free_all_bootmem();
 
-	reservedpages = 0;
-	for (tmp = 0; tmp < num_physpages; tmp++)
-		if (PageReserved(&mem_map[tmp]))
-			reservedpages++;
-
-	codesize =  (unsigned long) &_etext - (unsigned long) &_stext;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
