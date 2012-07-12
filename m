From: akpm@linux-foundation.org
Subject: [merged] mm-sparse-fix-usemap-allocation-above-node-descriptor-section.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:46 -0700
Message-ID: <20120712193746.D07EC1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57595 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934241Ab2GLThr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:47 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so267943qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, hannes@cmpxchg.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sparse: fix usemap allocation above node descriptor section
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-usemap-allocation-above-node-descriptor-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: mm: sparse: fix usemap allocation above node descriptor section

After f5bf18f ("bootmem/sparsemem: remove limit constraint in
alloc_bootmem_section"), usemap allocations may easily be placed outside
the optimal section that holds the node descriptor, even if there is space
available in that section.  This results in unnecessary hotplug
dependencies that need to have the node unplugged before the section
holding the usemap.

The reason is that the bootmem allocator doesn't guarantee a linear search
starting from the passed allocation goal but may start out at a much
higher address absent an upper limit.

Fix this by trying the allocation with the limit at the section end, then
retry without if that fails.  This keeps the fix from f5bf18f of not
panicking if the allocation does not fit in the section, but still makes
sure to try to stay within the section at first.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.3.x, 3.4.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    5 +++++
 mm/bootmem.c            |    2 +-
 mm/nobootmem.c          |    2 +-
 mm/sparse.c             |   18 +++++++++++++-----
 4 files changed, 20 insertions(+), 7 deletions(-)

diff -puN include/linux/bootmem.h~mm-sparse-fix-usemap-allocation-above-node-descriptor-section include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-sparse-fix-usemap-allocation-above-node-descriptor-section
+++ a/include/linux/bootmem.h
@@ -91,6 +91,11 @@ extern void *__alloc_bootmem_node_nopani
 				  unsigned long size,
 				  unsigned long align,
 				  unsigned long goal);
+void *___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+				  unsigned long size,
+				  unsigned long align,
+				  unsigned long goal,
+				  unsigned long limit);
 extern void *__alloc_bootmem_low(unsigned long size,
 				 unsigned long align,
 				 unsigned long goal);
diff -puN mm/bootmem.c~mm-sparse-fix-usemap-allocation-above-node-descriptor-section mm/bootmem.c
--- a/mm/bootmem.c~mm-sparse-fix-usemap-allocation-above-node-descriptor-section
+++ a/mm/bootmem.c
@@ -698,7 +698,7 @@ void * __init __alloc_bootmem(unsigned l
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
-static void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
 {
diff -puN mm/nobootmem.c~mm-sparse-fix-usemap-allocation-above-node-descriptor-section mm/nobootmem.c
--- a/mm/nobootmem.c~mm-sparse-fix-usemap-allocation-above-node-descriptor-section
+++ a/mm/nobootmem.c
@@ -274,7 +274,7 @@ void * __init __alloc_bootmem(unsigned l
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
-static void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 						   unsigned long size,
 						   unsigned long align,
 						   unsigned long goal,
diff -puN mm/sparse.c~mm-sparse-fix-usemap-allocation-above-node-descriptor-section mm/sparse.c
--- a/mm/sparse.c~mm-sparse-fix-usemap-allocation-above-node-descriptor-section
+++ a/mm/sparse.c
@@ -275,8 +275,9 @@ static unsigned long * __init
 sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 					 unsigned long size)
 {
-	pg_data_t *host_pgdat;
-	unsigned long goal;
+	unsigned long goal, limit;
+	unsigned long *p;
+	int nid;
 	/*
 	 * A page may contain usemaps for other sections preventing the
 	 * page being freed and making a section unremovable while
@@ -288,9 +289,16 @@ sparse_early_usemaps_alloc_pgdat_section
 	 * this problem.
 	 */
 	goal = __pa(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
-	host_pgdat = NODE_DATA(early_pfn_to_nid(goal >> PAGE_SHIFT));
-	return __alloc_bootmem_node_nopanic(host_pgdat, size,
-					    SMP_CACHE_BYTES, goal);
+	limit = goal + (1UL << PA_SECTION_SHIFT);
+	nid = early_pfn_to_nid(goal >> PAGE_SHIFT);
+again:
+	p = ___alloc_bootmem_node_nopanic(NODE_DATA(nid), size,
+					  SMP_CACHE_BYTES, goal, limit);
+	if (!p && limit) {
+		limit = 0;
+		goto again;
+	}
+	return p;
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

