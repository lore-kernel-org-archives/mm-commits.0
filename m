From: akpm@linux-foundation.org
Subject: [merged]
 mm-s390-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:36 -0700
Message-ID: <51db12a8.CwUg1pq/8ZPnBv59%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3GHT1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, jiang.liu@huawei.com, heiko.carstens@de.ibm.com, liuj97@gmail.com

Subject: [merged] mm-s390-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,heiko.carstens@de.ibm.com,jiang.liu@huawei.com,schwidefsky@de.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:36 -0700


The patch titled
     Subject: mm/s390: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-s390-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/s390: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN arch/s390/mm/init.c~mm-s390-prepare-for-removing-num_physpages-and-simplify-mem_init arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-s390-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/s390/mm/init.c
@@ -135,9 +135,7 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	unsigned long codesize, reservedpages, datasize, initsize;
-
-        max_mapnr = num_physpages = max_low_pfn;
+        max_mapnr = max_low_pfn;
         high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 
 	/* Setup guest page hinting */
@@ -147,18 +145,7 @@ void __init mem_init(void)
 	free_all_bootmem();
 	setup_zero_pages();	/* Setup zeroed pages. */
 
-	reservedpages = 0;
