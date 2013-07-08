From: akpm@linux-foundation.org
Subject: [merged]
 mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:54 -0700
Message-ID: <51db127e.y4us7AMI0ZNQ/4l7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHT0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rth@twiddle.net, mattst88@gmail.com, jiang.liu@huawei.com, ink@jurassic.park.msu.ru, dhowells@redhat.com, liuj97@gmail.com

Subject: [merged] mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,dhowells@redhat.com,ink@jurassic.park.msu.ru,jiang.liu@huawei.com,mattst88@gmail.com,rth@twiddle.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:54 -0700


The patch titled
     Subject: mm/alpha: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/alpha: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/init.c |   32 ++------------------------------
 arch/alpha/mm/numa.c |   34 ++--------------------------------
 2 files changed, 4 insertions(+), 62 deletions(-)

diff -puN arch/alpha/mm/init.c~mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/alpha/mm/init.c
@@ -277,42 +277,14 @@ srm_paging_stop (void)
 #endif
 
 #ifndef CONFIG_DISCONTIGMEM
-static void __init
-printk_memory_info(void)
-{
-	unsigned long codesize, reservedpages, datasize, initsize, tmp;
-	extern int page_is_ram(unsigned long) __init;
-
-	/* printk all informations */
-	reservedpages = 0;
-	for (tmp = 0; tmp < max_low_pfn; tmp++)
-		/*
-		 * Only count reserved RAM pages
-		 */
-		if (page_is_ram(tmp) && PageReserved(mem_map+tmp))
-			reservedpages++;
-
-	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_data;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
-
-	printk("Memory: %luk/%luk available (%luk kernel code, %luk reserved, %luk data, %luk init)\n",
-	       nr_free_pages() << (PAGE_SHIFT-10),
-	       max_mapnr << (PAGE_SHIFT-10),
-	       codesize >> 10,
-	       reservedpages << (PAGE_SHIFT-10),
-	       datasize >> 10,
-	       initsize >> 10);
-}
-
 void __init
 mem_init(void)
 {
-	max_mapnr = num_physpages = max_low_pfn;
+	max_mapnr = max_low_pfn;
 	free_all_bootmem();
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 
-	printk_memory_info();
+	mem_init_print_info(NULL);
 }
 #endif /* CONFIG_DISCONTIGMEM */
 
diff -puN arch/alpha/mm/numa.c~mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/alpha/mm/numa.c
@@ -129,8 +129,6 @@ setup_memory_node(int nid, void *kernel_
 	if (node_max_pfn > max_low_pfn)
 		max_pfn = max_low_pfn = node_max_pfn;
 
-	num_physpages += node_max_pfn - node_min_pfn;
-
 #if 0 /* we'll try this one again in a little while */
 	/* Cute trick to make sure our local node data is on local memory */
 	node_data[nid] = (pg_data_t *)(__va(node_min_pfn << PAGE_SHIFT));
@@ -324,37 +322,9 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	unsigned long codesize, reservedpages, datasize, initsize, pfn;
-	extern int page_is_ram(unsigned long) __init;
-	unsigned long nid, i;
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
-
-	reservedpages = 0;
-	for_each_online_node(nid) {
-		/*
-		 * This will free up the bootmem, ie, slot 0 memory
-		 */
-		free_all_bootmem_node(NODE_DATA(nid));
-
-		pfn = NODE_DATA(nid)->node_start_pfn;
-		for (i = 0; i < node_spanned_pages(nid); i++, pfn++)
-			if (page_is_ram(pfn) &&
-			    PageReserved(nid_page_nr(nid, i)))
-				reservedpages++;
-	}
-
-	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
-	datasize =  (unsigned long) &_edata - (unsigned long) &_data;
-	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
