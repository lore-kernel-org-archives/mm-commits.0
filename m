From: akpm@linux-foundation.org
Subject: [merged]
 mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:12 -0700
Message-ID: <51db1290.W+EAVwuufXYHKMI3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3GHT1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ysato@users.sourceforge.jp, jiang.liu@huawei.com, geert@linux-m68k.org, liuj97@gmail.com

Subject: [merged] mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,geert@linux-m68k.org,jiang.liu@huawei.com,ysato@users.sourceforge.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:12 -0700


The patch titled
     Subject: mm/h8300: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/h8300: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/mm/init.c |   36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff -puN arch/h8300/mm/init.c~mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/h8300/mm/init.c
@@ -121,40 +121,20 @@ void __init paging_init(void)
 
 void __init mem_init(void)
 {
-	int codek = 0, datak = 0, initk = 0;
-	/* DAVIDM look at setup memory map generically with reserved area */
-	unsigned long tmp;
-	extern unsigned long  _ramend, _ramstart;
-	unsigned long len = &_ramend - &_ramstart;
-	unsigned long start_mem = memory_start; /* DAVIDM - these must start at end of kernel */
-	unsigned long end_mem   = memory_end; /* DAVIDM - this must not include kernel stack at top */
-
-#ifdef DEBUG
-	printk(KERN_DEBUG "Mem_init: start=%lx, end=%lx\n", start_mem, end_mem);
-#endif
+	unsigned long codesize = _etext - _stext;
 
-	end_mem &= PAGE_MASK;
-	high_memory = (void *) end_mem;
+	pr_devel("Mem_init: start=%lx, end=%lx\n", memory_start, memory_end);
 
-	start_mem = PAGE_ALIGN(start_mem);
-	max_mapnr = num_physpages = MAP_NR(high_memory);
+	high_memory = (void *) (memory_end & PAGE_MASK);
+	max_mapnr = MAP_NR(high_memory);
 
 	/* this will put all low memory onto the freelists */
 	free_all_bootmem();
 
-	codek = (_etext - _stext) >> 10;
-	datak = (__bss_stop - _sdata) >> 10;
-	initk = (__init_begin - __init_end) >> 10;
