From: akpm@linux-foundation.org
Subject: [merged]
 mm-c6x-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:06 -0700
Message-ID: <51db128a.ERQLzlkTooGl64/I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3GHT1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, msalter@redhat.com, jiang.liu@huawei.com, a-jacquiot@ti.com, liuj97@gmail.com

Subject: [merged] mm-c6x-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,a-jacquiot@ti.com,jiang.liu@huawei.com,msalter@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:06 -0700


The patch titled
     Subject: mm/c6x: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-c6x-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/c6x: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/mm/init.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/c6x/mm/init.c~mm-c6x-prepare-for-removing-num_physpages-and-simplify-mem_init arch/c6x/mm/init.c
--- a/arch/c6x/mm/init.c~mm-c6x-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/c6x/mm/init.c
@@ -58,21 +58,12 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	int codek, datak;
-	unsigned long tmp;
-	unsigned long len = memory_end - memory_start;
-
 	high_memory = (void *)(memory_end & PAGE_MASK);
 
 	/* this will put all memory onto the freelists */
 	free_all_bootmem();
 
-	codek = (_etext - _stext) >> 10;
-	datak = (_end - _sdata) >> 10;
