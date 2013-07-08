From: akpm@linux-foundation.org
Subject: [merged]
 mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:48 -0700
Message-ID: <51db1278.jHkwauMbxg50Hzvt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3GHT0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, minchan@kernel.org, mgorman@suse.de, m.szyprowski@samsung.com, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,m.szyprowski@samsung.com,mgorman@suse.de,minchan@kernel.org,riel@redhat.com,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:48 -0700


The patch titled
     Subject: mm: introduce helper function mem_init_print_info() to simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: introduce helper function mem_init_print_info() to simplify mem_init()

Introduce helper function mem_init_print_info() to simplify mem_init()
across different architectures, which also unifies the format and
information printed.

Function mem_init_print_info() calculates memory statistics information
without walking each page, so it should be a little faster on some
architectures.

Also introduce another helper get_num_physpages() to kill the global
variable num_physpages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 +++++++++
 mm/page_alloc.c    |   52 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff -puN include/linux/mm.h~mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init
+++ a/include/linux/mm.h
@@ -1323,6 +1323,7 @@ extern void free_highmem_page(struct pag
 #endif
 
 extern void adjust_managed_page_count(struct page *page, long count);
+extern void mem_init_print_info(const char *str);
 
 /* Free the reserved page into the buddy system, so it gets managed. */
 static inline void __free_reserved_page(struct page *page)
@@ -1358,6 +1359,17 @@ static inline unsigned long free_initmem
 				  poison, "unused kernel");
 }
 
+static inline unsigned long get_num_physpages(void)
+{
+	int nid;
+	unsigned long phys_pages = 0;
+
+	for_each_online_node(nid)
+		phys_pages += node_present_pages(nid);
+
+	return phys_pages;
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
  * With CONFIG_HAVE_MEMBLOCK_NODE_MAP set, an architecture may initialise its
diff -puN mm/page_alloc.c~mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init
+++ a/mm/page_alloc.c
@@ -61,6 +61,7 @@
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
 
+#include <asm/sections.h>
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
 #include "internal.h"
@@ -5246,6 +5247,57 @@ void free_highmem_page(struct page *page
 }
 #endif
 
+
+void __init mem_init_print_info(const char *str)
+{
+	unsigned long physpages, codesize, datasize, rosize, bss_size;
+	unsigned long init_code_size, init_data_size;
+
+	physpages = get_num_physpages();
+	codesize = _etext - _stext;
+	datasize = _edata - _sdata;
+	rosize = __end_rodata - __start_rodata;
+	bss_size = __bss_stop - __bss_start;
+	init_data_size = __init_end - __init_begin;
+	init_code_size = _einittext - _sinittext;
+
+	/*
+	 * Detect special cases and adjust section sizes accordingly:
+	 * 1) .init.* may be embedded into .data sections
+	 * 2) .init.text.* may be out of [__init_begin, __init_end],
+	 *    please refer to arch/tile/kernel/vmlinux.lds.S.
+	 * 3) .rodata.* may be embedded into .text or .data sections.
+	 */
+#define adj_init_size(start, end, size, pos, adj) \
+	if (start <= pos && pos < end && size > adj) \
+		size -= adj;
+
+	adj_init_size(__init_begin, __init_end, init_data_size,
+		     _sinittext, init_code_size);
+	adj_init_size(_stext, _etext, codesize, _sinittext, init_code_size);
+	adj_init_size(_sdata, _edata, datasize, __init_begin, init_data_size);
+	adj_init_size(_stext, _etext, codesize, __start_rodata, rosize);
+	adj_init_size(_sdata, _edata, datasize, __start_rodata, rosize);
+
+#undef	adj_init_size
+
+	printk("Memory: %luK/%luK available "
+	       "(%luK kernel code, %luK rwdata, %luK rodata, "
+	       "%luK init, %luK bss, %luK reserved"
+#ifdef	CONFIG_HIGHMEM
+	       ", %luK highmem"
+#endif
+	       "%s%s)\n",
+	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
+	       codesize >> 10, datasize >> 10, rosize >> 10,
+	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
+	       (physpages - totalram_pages) << (PAGE_SHIFT-10),
+#ifdef	CONFIG_HIGHMEM
+	       totalhigh_pages << (PAGE_SHIFT-10),
+#endif
+	       str ? ", " : "", str ? str : "");
+}
+
 /**
  * set_dma_reserve - set the specified number of pages reserved in the first zone
  * @new_dma_reserve: The number of pages to mark reserved
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

