From: akpm@linux-foundation.org
Subject: [merged]
 mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:40 -0700
Message-ID: <51db12ac.159woOn4yJPtSoIS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab3GHT1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, lethal@linux-sh.org, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,lethal@linux-sh.org,tangchen@cn.fujitsu.com,wency@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:40 -0700


The patch titled
     Subject: mm/SH: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/SH: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/init.c |   25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff -puN arch/sh/mm/init.c~mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/sh/mm/init.c
@@ -407,24 +407,18 @@ unsigned int mem_init_done = 0;
 
 void __init mem_init(void)
 {
-	int codesize, datasize, initsize;
-	int nid;
+	pg_data_t *pgdat;
 
 	iommu_init();
 
-	num_physpages = 0;
 	high_memory = NULL;
 
-	for_each_online_node(nid) {
-		pg_data_t *pgdat = NODE_DATA(nid);
+	for_each_online_pgdat(pgdat) {
 		void *node_high_memory;
 
-		num_physpages += pgdat->node_present_pages;
-
 		if (pgdat->node_spanned_pages)
 			free_all_bootmem_node(pgdat);
 
-
 		node_high_memory = (void *)__va((pgdat->node_start_pfn +
 						 pgdat->node_spanned_pages) <<
 						 PAGE_SHIFT);
@@ -441,19 +435,8 @@ void __init mem_init(void)
 
 	vsyscall_init();
 
-	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-
-	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
-	       "%dk data, %dk init)\n",
-		nr_free_pages() << (PAGE_SHIFT-10),
-		num_physpages << (PAGE_SHIFT-10),
-		codesize >> 10,
-		datasize >> 10,
-		initsize >> 10);
