From: akpm@osdl.org
Subject: + ia64-register-memory-ranges-in-a-consistent-manner.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:36:00 -0800
Message-ID: <200701240636.l0O6a0oa010573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54362 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968AbXAXGgJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 01:36:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bob.picco@hp.com, mel@csn.ul.ie, tony.luck@intel.com


The patch titled
     ia64: register memory ranges in a consistent manner
has been added to the -mm tree.  Its filename is
     ia64-register-memory-ranges-in-a-consistent-manner.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: register memory ranges in a consistent manner
From: "Bob Picco" <bob.picco@hp.com>

While pursuing and unrelated issue with 64Mb granules I noticed a problem
related to inconsistent use of add_active_range.  There doesn't appear any
reason to me why FLATMEM versus DISCONTIG_MEM should register memory to
add_active_range with different code.  So I've changed the code into a
common implementation.

The other subtle issue fixed by this patch was calling add_active_range in
count_node_pages before granule aligning is performed.  We were lucky with
16MB granules but not so with 64MB granules.  count_node_pages has reserved
regions filtered out and as a consequence linked kernel text and data
aren't covered by calls to count_node_pages.  So linked kernel regions
wasn't reported to add_active_regions.  This resulted in free_initmem
causing numerous bad_page reports.  This won't occur with this patch
because now all known memory regions are reported by
register_active_ranges.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Bob Picco <bob.picco@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/mm/discontig.c   |    4 +++-
 arch/ia64/mm/init.c        |   19 +++++++++++++++++--
 include/asm-ia64/meminit.h |    3 ++-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff -puN arch/ia64/mm/discontig.c~ia64-register-memory-ranges-in-a-consistent-manner arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~ia64-register-memory-ranges-in-a-consistent-manner
+++ a/arch/ia64/mm/discontig.c
@@ -473,6 +473,9 @@ void __init find_memory(void)
 			node_clear(node, memory_less_mask);
 			mem_data[node].min_pfn = ~0UL;
 		}
+
+	efi_memmap_walk(register_active_ranges, NULL);
+
 	/*
 	 * Initialize the boot memory maps in reverse order since that's
 	 * what the bootmem allocator expects
@@ -654,7 +657,6 @@ static __init int count_node_pages(unsig
 {
 	unsigned long end = start + len;
 
-	add_active_range(node, start >> PAGE_SHIFT, end >> PAGE_SHIFT);
 	mem_data[node].num_physpages += len >> PAGE_SHIFT;
 	if (start <= __pa(MAX_DMA_ADDRESS))
 		mem_data[node].num_dma_physpages +=
diff -puN arch/ia64/mm/init.c~ia64-register-memory-ranges-in-a-consistent-manner arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~ia64-register-memory-ranges-in-a-consistent-manner
+++ a/arch/ia64/mm/init.c
@@ -19,6 +19,7 @@
 #include <linux/swap.h>
 #include <linux/proc_fs.h>
 #include <linux/bitops.h>
+#include <linux/kexec.h>
 
 #include <asm/a.out.h>
 #include <asm/dma.h>
@@ -614,13 +615,27 @@ find_largest_hole (u64 start, u64 end, v
 	return 0;
 }
 
+#endif /* CONFIG_VIRTUAL_MEM_MAP */
+
 int __init
 register_active_ranges(u64 start, u64 end, void *arg)
 {
-	add_active_range(0, __pa(start) >> PAGE_SHIFT, __pa(end) >> PAGE_SHIFT);
+	int nid = paddr_to_nid(__pa(start));
+
+	if (nid < 0)
+		nid = 0;
+#ifdef CONFIG_KEXEC
+	if (start > crashk_res.start && start < crashk_res.end)
+		start = crashk_res.end;
+	if (end > crashk_res.start && end < crashk_res.end)
+		end = crashk_res.start;
+#endif
+
+	if (start < end)
+		add_active_range(nid, __pa(start) >> PAGE_SHIFT,
+			__pa(end) >> PAGE_SHIFT);
 	return 0;
 }
-#endif /* CONFIG_VIRTUAL_MEM_MAP */
 
 static int __init
 count_reserved_pages (u64 start, u64 end, void *arg)
diff -puN include/asm-ia64/meminit.h~ia64-register-memory-ranges-in-a-consistent-manner include/asm-ia64/meminit.h
--- a/include/asm-ia64/meminit.h~ia64-register-memory-ranges-in-a-consistent-manner
+++ a/include/asm-ia64/meminit.h
@@ -51,12 +51,13 @@ extern void efi_memmap_init(unsigned lon
 
 #define IGNORE_PFN0	1	/* XXX fix me: ignore pfn 0 until TLB miss handler is updated... */
 
+extern int register_active_ranges (u64 start, u64 end, void *arg);
+
 #ifdef CONFIG_VIRTUAL_MEM_MAP
 # define LARGE_GAP	0x40000000 /* Use virtual mem map if hole is > than this */
   extern unsigned long vmalloc_end;
   extern struct page *vmem_map;
   extern int find_largest_hole (u64 start, u64 end, void *arg);
-  extern int register_active_ranges (u64 start, u64 end, void *arg);
   extern int create_mem_map_page_table (u64 start, u64 end, void *arg);
   extern int vmemmap_find_next_valid_pfn(int, int);
 #else
_

Patches currently in -mm which might be from bob.picco@hp.com are

ia64-register-memory-ranges-in-a-consistent-manner.patch
