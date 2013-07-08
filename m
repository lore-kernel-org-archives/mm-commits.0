From: akpm@linux-foundation.org
Subject: [merged]
 mm-avr32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:02 -0700
Message-ID: <51db1286.d8cqfe1zuKx+tF/Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3GHT1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jiang.liu@huawei.com, hskinnemoen@gmail.com, egtvedt@samfundet.no, liuj97@gmail.com

Subject: [merged] mm-avr32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,egtvedt@samfundet.no,hskinnemoen@gmail.com,jiang.liu@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:02 -0700


The patch titled
     Subject: mm/AVR32: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-avr32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/AVR32: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/init.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff -puN arch/avr32/mm/init.c~mm-avr32-prepare-for-removing-num_physpages-and-simplify-mem_init arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~mm-avr32-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/avr32/mm/init.c
@@ -100,26 +100,16 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
-	int nid, i;
+	pg_data_t *pgdat;
 
-	reservedpages = 0;
 	high_memory = NULL;
 
 	/* this will put all low memory onto the freelists */
-	for_each_online_node(nid) {
-		pg_data_t *pgdat = NODE_DATA(nid);
-		unsigned long node_pages = 0;
+	for_each_online_pgdat(pgdat) {
 		void *node_high_memory;
 
-		num_physpages += pgdat->node_present_pages;
-
 		if (pgdat->node_spanned_pages != 0)
-			node_pages = free_all_bootmem_node(pgdat);
-
-		for (i = 0; i < node_pages; i++)
-			if (PageReserved(pgdat->node_mem_map + i))
-				reservedpages++;
+			free_all_bootmem_node(pgdat);
 
 		node_high_memory = (void *)((pgdat->node_start_pfn
 					     + pgdat->node_spanned_pages)
@@ -130,18 +120,7 @@ void __init mem_init(void)
 
 	max_mapnr = MAP_NR(high_memory);
 
-	codesize = (unsigned long)_etext - (unsigned long)_text;
-	datasize = (unsigned long)_edata - (unsigned long)_data;
-	initsize = (unsigned long)__init_end - (unsigned long)__init_begin;
