From: akpm@linux-foundation.org
Subject: [merged]
 mm-cris-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:08 -0700
Message-ID: <51db128c.sUMdz0WUDU+O7aen%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3GHT1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, jiang.liu@huawei.com, jesper.nilsson@axis.com, liuj97@gmail.com

Subject: [merged] mm-cris-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,jesper.nilsson@axis.com,jiang.liu@huawei.com,starvik@axis.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:08 -0700


The patch titled
     Subject: mm/cris: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-cris-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/cris: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/mm/init.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff -puN arch/cris/mm/init.c~mm-cris-prepare-for-removing-num_physpages-and-simplify-mem_init arch/cris/mm/init.c
--- a/arch/cris/mm/init.c~mm-cris-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/cris/mm/init.c
@@ -19,9 +19,6 @@ unsigned long empty_zero_page;
 void __init
 mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
-	unsigned long tmp;
-
 	BUG_ON(!mem_map);
 
 	/* max/min_low_pfn was set by setup.c
@@ -29,35 +26,9 @@ mem_init(void)
 	 *
 	 * high_memory was also set in setup.c
 	 */
-
-	max_mapnr = num_physpages = max_low_pfn - min_low_pfn;
- 
-	/* this will put all memory onto the freelists */
+	max_mapnr = max_low_pfn - min_low_pfn;
         free_all_bootmem();
-
-	reservedpages = 0;
-	for (tmp = 0; tmp < max_mapnr; tmp++) {
-		/*
-                 * Only count reserved RAM pages
-                 */
-		if (PageReserved(mem_map + tmp))
-			reservedpages++;
-	}
-
-	codesize =  (unsigned long) &_etext - (unsigned long) &_stext;
-        datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
-        initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-	
-        printk(KERN_INFO
-               "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, "
-	       "%dk init)\n" ,
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       max_mapnr << (PAGE_SHIFT-10),
-	       codesize >> 10,
-	       reservedpages << (PAGE_SHIFT-10),
-	       datasize >> 10,
-	       initsize >> 10
-               );
+	mem_init_print_info(NULL);
 }
 
 /* free the pages occupied by initialization code */
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

