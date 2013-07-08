From: akpm@linux-foundation.org
Subject: [merged]
 mm-m68k-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:20 -0700
Message-ID: <51db1298.AmylRD/vMn76NEwr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3GHT1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jiang.liu@huawei.com, gerg@uclinux.org, geert@linux-m68k.org, liuj97@gmail.com

Subject: [merged] mm-m68k-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,geert@linux-m68k.org,gerg@uclinux.org,jiang.liu@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:20 -0700


The patch titled
     Subject: mm/m68k: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-m68k-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/m68k: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/init.c |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff -puN arch/m68k/mm/init.c~mm-m68k-prepare-for-removing-num_physpages-and-simplify-mem_init arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~mm-m68k-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/m68k/mm/init.c
@@ -149,33 +149,11 @@ void __init print_memmap(void)
 void __init mem_init(void)
 {
 	pg_data_t *pgdat;
-	int codepages = 0;
-	int datapages = 0;
-	int initpages = 0;
 	int i;
 
 	/* this will put all memory onto the freelists */
-	num_physpages = 0;
-	for_each_online_pgdat(pgdat) {
-		num_physpages += pgdat->node_present_pages;
-
+	for_each_online_pgdat(pgdat)
 		free_all_bootmem_node(pgdat);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page = pgdat->node_mem_map + i;
-			char *addr = page_to_virt(page);
-
-			if (!PageReserved(page))
-				continue;
-			if (addr >= _text &&
-			    addr < _etext)
-				codepages++;
-			else if (addr >= __init_begin &&
-				 addr < __init_end)
-				initpages++;
-			else
-				datapages++;
-		}
-	}
 
 #if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
 	/* insert pointer tables allocated so far into the tablelist */
@@ -190,12 +168,7 @@ void __init mem_init(void)
 		init_pointer_table((unsigned long)zero_pgtable);
 #endif
 
-	pr_info("Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init)\n",
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       totalram_pages << (PAGE_SHIFT-10),
-	       codepages << (PAGE_SHIFT-10),
-	       datapages << (PAGE_SHIFT-10),
-	       initpages << (PAGE_SHIFT-10));
+	mem_init_print_info(NULL);
 	print_memmap();
 }
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

