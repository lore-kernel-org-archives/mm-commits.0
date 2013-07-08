From: akpm@linux-foundation.org
Subject: [merged]
 mm-openrisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:30 -0700
Message-ID: <51db12a2.bY2v+lQEV76AbaoM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab3GHT1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jonas@southpole.se, jiang.liu@huawei.com, dhowells@redhat.com, arnd@arndb.de, liuj97@gmail.com

Subject: [merged] mm-openrisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,arnd@arndb.de,dhowells@redhat.com,jiang.liu@huawei.com,jonas@southpole.se,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:30 -0700


The patch titled
     Subject: mm/openrisc: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-openrisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/openrisc: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Jonas Bonn <jonas@southpole.se>
Cc: David Howells <dhowells@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/mm/init.c |   44 +++-----------------------------------
 1 file changed, 4 insertions(+), 40 deletions(-)

diff -puN arch/openrisc/mm/init.c~mm-openrisc-prepare-for-removing-num_physpages-and-simplify-mem_init arch/openrisc/mm/init.c
--- a/arch/openrisc/mm/init.c~mm-openrisc-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/openrisc/mm/init.c
@@ -202,56 +202,20 @@ void __init paging_init(void)
 
 /* References to section boundaries */
 
-static int __init free_pages_init(void)
-{
-	int reservedpages, pfn;
-
-	/* this will put all low memory onto the freelists */
-	free_all_bootmem();
-
-	reservedpages = 0;
-	for (pfn = 0; pfn < max_low_pfn; pfn++) {
-		/*
-		 * Only count reserved RAM pages
-		 */
-		if (PageReserved(mem_map + pfn))
-			reservedpages++;
-	}
-
-	return reservedpages;
-}
-
-static void __init set_max_mapnr_init(void)
-{
-	max_mapnr = num_physpages = max_low_pfn;
-}
-
 void __init mem_init(void)
 {
-	int codesize, reservedpages, datasize, initsize;
-
 	BUG_ON(!mem_map);
 
-	set_max_mapnr_init();
-
+	max_mapnr = max_low_pfn;
 	high_memory = (void *)__va(max_low_pfn * PAGE_SIZE);
 
 	/* clear the zero-page */
 	memset((void *)empty_zero_page, 0, PAGE_SIZE);
 
-	reservedpages = free_pages_init();
+	/* this will put all low memory onto the freelists */
+	free_all_bootmem();
 
-	codesize = (unsigned long)&_etext - (unsigned long)&_stext;
-	datasize = (unsigned long)&_edata - (unsigned long)&_etext;
-	initsize = (unsigned long)&__init_end - (unsigned long)&__init_begin;
