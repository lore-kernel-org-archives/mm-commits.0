From: akpm@linux-foundation.org
Subject: [merged]
 mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:04 -0700
Message-ID: <51db1288.BQDTPreltshOAMGI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3GHT1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vapier@gentoo.org, lliubbo@gmail.com, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,lliubbo@gmail.com,vapier@gentoo.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:04 -0700


The patch titled
     Subject: mm/blackfin: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/blackfin: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mm/init.c |   38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff -puN arch/blackfin/mm/init.c~mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init arch/blackfin/mm/init.c
--- a/arch/blackfin/mm/init.c~mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/blackfin/mm/init.c
@@ -90,43 +90,17 @@ asmlinkage void __init init_pda(void)
 
 void __init mem_init(void)
 {
-	unsigned int codek = 0, datak = 0, initk = 0;
-	unsigned int reservedpages = 0, freepages = 0;
-	unsigned long tmp;
-	unsigned long start_mem = memory_start;
-	unsigned long end_mem = memory_end;
+	char buf[64];
 
-	end_mem &= PAGE_MASK;
-	high_memory = (void *)end_mem;
-
-	start_mem = PAGE_ALIGN(start_mem);
-	max_mapnr = num_physpages = MAP_NR(high_memory);
-	printk(KERN_DEBUG "Kernel managed physical pages: %lu\n", num_physpages);
+	high_memory = (void *)(memory_end & PAGE_MASK);
+	max_mapnr = MAP_NR(high_memory);
+	printk(KERN_DEBUG "Kernel managed physical pages: %lu\n", max_mapnr);
 
 	/* This will put all low memory onto the freelists. */
 	free_all_bootmem();
 
-	reservedpages = 0;
-	for (tmp = ARCH_PFN_OFFSET; tmp < max_mapnr; tmp++)
-		if (PageReserved(pfn_to_page(tmp)))
-			reservedpages++;
-	freepages =  max_mapnr - ARCH_PFN_OFFSET - reservedpages;
-
-	/* do not count in kernel image between _rambase and _ramstart */
-	reservedpages -= (_ramstart - _rambase) >> PAGE_SHIFT;
-#if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
-	reservedpages += (_ramend - memory_end - DMA_UNCACHED_REGION) >> PAGE_SHIFT;
-#endif
-
-	codek = (_etext - _stext) >> 10;
-	initk = (__init_end - __init_begin) >> 10;
-	datak = ((_ramstart - _rambase) >> 10) - codek - initk;
