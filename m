From: akpm@linux-foundation.org
Subject: [merged]
 mm-initialize-memmap-of-unavailable-memory-directly.patch removed from -mm
 tree
Date: Tue, 04 Feb 2020 10:40:00 -0800
Message-ID: <20200204184000.0Ax_Pbs-4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDSkC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, bob.picco@oracle.com, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, david@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, osalvador@suse.de, pasha.tatashin@oracle.com, sfr@canb.auug.org.au, steven.sistare@oracle.com


The patch titled
     Subject: mm/page_alloc.c: initialize memmap of unavailable memory directly
has been removed from the -mm tree.  Its filename was
     mm-initialize-memmap-of-unavailable-memory-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc.c: initialize memmap of unavailable memory directly

Let's make sure that all memory holes are actually marked PageReserved(),
that page_to_pfn() produces reliable results, and that these pages are not
detected as "mmap" pages due to the mapcount.

E.g., booting a x86-64 QEMU guest with 4160 MB:

[    0.010585] Early memory node ranges
[    0.010586]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.010588]   node   0: [mem 0x0000000000100000-0x00000000bffdefff]
[    0.010589]   node   0: [mem 0x0000000100000000-0x0000000143ffffff]

max_pfn is 0x144000.

Before this change:

[root@localhost ~]# ./page-types -r -a 0x144000,
             flags      page-count       MB  symbolic-flags                     long-symbolic-flags
0x0000000000000800           16384       64  ___________M_______________________________        mmap
             total           16384       64

After this change:

[root@localhost ~]# ./page-types -r -a 0x144000,
             flags      page-count       MB  symbolic-flags                     long-symbolic-flags
0x0000000100000000           16384       64  ___________________________r_______________        reserved
             total           16384       64

IOW, especially the unavailable physical memory ("memory hole") in the
last section would not get properly marked PageReserved() and is indicated
to be "mmap" memory.

Drop the trace of that function from include/linux/mm.h - nobody else
needs it, and rename it accordingly.

Note: The fake zone/node might not be covered by the zone/node span.  This
is not an urgent issue (for now, we had the same node/zone due to the
zeroing).  We'll need a clean way to mark memory holes (e.g., using a page
type PageHole() if possible or a fake ZONE_INVALID) and eventually stop
marking these memory holes PageReserved().

Link: http://lkml.kernel.org/r/20191211163201.17179-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Sistare <steven.sistare@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ------
 mm/page_alloc.c    |   33 ++++++++++++++++++++++-----------
 2 files changed, 22 insertions(+), 17 deletions(-)

--- a/include/linux/mm.h~mm-initialize-memmap-of-unavailable-memory-directly
+++ a/include/linux/mm.h
@@ -2182,12 +2182,6 @@ extern int __meminit __early_pfn_to_nid(
 					struct mminit_pfnnid_cache *state);
 #endif
 
-#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
-void zero_resv_unavail(void);
-#else
-static inline void zero_resv_unavail(void) {}
-#endif
-
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
 		enum memmap_context, struct vmem_altmap *);
--- a/mm/page_alloc.c~mm-initialize-memmap-of-unavailable-memory-directly
+++ a/mm/page_alloc.c
@@ -6916,10 +6916,10 @@ void __init free_area_init_node(int nid,
 
 #if !defined(CONFIG_FLAT_NODE_MEM_MAP)
 /*
- * Zero all valid struct pages in range [spfn, epfn), return number of struct
- * pages zeroed
+ * Initialize all valid struct pages in the range [spfn, epfn) and mark them
+ * PageReserved(). Return the number of struct pages that were initialized.
  */
-static u64 zero_pfn_range(unsigned long spfn, unsigned long epfn)
+static u64 __init init_unavailable_range(unsigned long spfn, unsigned long epfn)
 {
 	unsigned long pfn;
 	u64 pgcnt = 0;
@@ -6930,7 +6930,13 @@ static u64 zero_pfn_range(unsigned long
 				+ pageblock_nr_pages - 1;
 			continue;
 		}
-		mm_zero_struct_page(pfn_to_page(pfn));
+		/*
+		 * Use a fake node/zone (0) for now. Some of these pages
+		 * (in memblock.reserved but not in memblock.memory) will
+		 * get re-initialized via reserve_bootmem_region() later.
+		 */
+		__init_single_page(pfn_to_page(pfn), pfn, 0, 0);
+		__SetPageReserved(pfn_to_page(pfn));
 		pgcnt++;
 	}
 
@@ -6942,7 +6948,7 @@ static u64 zero_pfn_range(unsigned long
  * initialized by going through __init_single_page(). But, there are some
  * struct pages which are reserved in memblock allocator and their fields
  * may be accessed (for example page_to_pfn() on some configuration accesses
- * flags). We must explicitly zero those struct pages.
+ * flags). We must explicitly initialize those struct pages.
  *
  * This function also addresses a similar issue where struct pages are left
  * uninitialized because the physical address range is not covered by
@@ -6950,7 +6956,7 @@ static u64 zero_pfn_range(unsigned long
  * layout is manually configured via memmap=, or when the highest physical
  * address (max_pfn) does not end on a section boundary.
  */
-void __init zero_resv_unavail(void)
+static void __init init_unavailable_mem(void)
 {
 	phys_addr_t start, end;
 	u64 i, pgcnt;
@@ -6963,7 +6969,8 @@ void __init zero_resv_unavail(void)
 	for_each_mem_range(i, &memblock.memory, NULL,
 			NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end, NULL) {
 		if (next < start)
-			pgcnt += zero_pfn_range(PFN_DOWN(next), PFN_UP(start));
+			pgcnt += init_unavailable_range(PFN_DOWN(next),
+							PFN_UP(start));
 		next = end;
 	}
 
@@ -6974,8 +6981,8 @@ void __init zero_resv_unavail(void)
 	 * considered initialized. Make sure that memmap has a well defined
 	 * state.
 	 */
-	pgcnt += zero_pfn_range(PFN_DOWN(next),
-				round_up(max_pfn, PAGES_PER_SECTION));
+	pgcnt += init_unavailable_range(PFN_DOWN(next),
+					round_up(max_pfn, PAGES_PER_SECTION));
 
 	/*
 	 * Struct pages that do not have backing memory. This could be because
@@ -6984,6 +6991,10 @@ void __init zero_resv_unavail(void)
 	if (pgcnt)
 		pr_info("Zeroed struct page in unavailable ranges: %lld pages", pgcnt);
 }
+#else
+static inline void __init init_unavailable_mem(void)
+{
+}
 #endif /* !CONFIG_FLAT_NODE_MEM_MAP */
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
@@ -7413,7 +7424,7 @@ void __init free_area_init_nodes(unsigne
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
 	setup_nr_node_ids();
-	zero_resv_unavail();
+	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid, NULL,
@@ -7608,7 +7619,7 @@ void __init set_dma_reserve(unsigned lon
 
 void __init free_area_init(unsigned long *zones_size)
 {
-	zero_resv_unavail();
+	init_unavailable_mem();
 	free_area_init_node(0, zones_size,
 			__pa(PAGE_OFFSET) >> PAGE_SHIFT, NULL);
 }
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
