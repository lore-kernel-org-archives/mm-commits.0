From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-fix-goal-calculating-with-usemap.patch removed from -mm tree
Date: Tue, 10 Jul 2012 15:31:05 -0700
Message-ID: <20120710223106.5A08E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:37728 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2GJWbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 18:31:09 -0400
Received: by bkcjc3 with SMTP id jc3so22388bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 15:31:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, hannes@cmpxchg.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix goal calculating with usemap
has been removed from the -mm tree.  Its filename was
     mm-fix-goal-calculating-with-usemap.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: mm: fix goal calculating with usemap

PAGE_SECTION_MASK should be used with pfn instead of pa.

Also restore the old behavoir: limit the allocating to same section at
first.  need to expose __alloc_bootmem_node_nopanic with limit.  

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    5 +++++
 mm/bootmem.c            |    2 +-
 mm/nobootmem.c          |    2 +-
 mm/sparse.c             |   22 ++++++++++++++++------
 4 files changed, 23 insertions(+), 8 deletions(-)

diff -puN include/linux/bootmem.h~mm-fix-goal-calculating-with-usemap include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-fix-goal-calculating-with-usemap
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
diff -puN mm/bootmem.c~mm-fix-goal-calculating-with-usemap mm/bootmem.c
--- a/mm/bootmem.c~mm-fix-goal-calculating-with-usemap
+++ a/mm/bootmem.c
@@ -698,7 +698,7 @@ void * __init __alloc_bootmem(unsigned l
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
-static void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
 {
diff -puN mm/nobootmem.c~mm-fix-goal-calculating-with-usemap mm/nobootmem.c
--- a/mm/nobootmem.c~mm-fix-goal-calculating-with-usemap
+++ a/mm/nobootmem.c
@@ -274,7 +274,7 @@ void * __init __alloc_bootmem(unsigned l
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
-static void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
+void * __init ___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 						   unsigned long size,
 						   unsigned long align,
 						   unsigned long goal,
diff -puN mm/sparse.c~mm-fix-goal-calculating-with-usemap mm/sparse.c
--- a/mm/sparse.c~mm-fix-goal-calculating-with-usemap
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
@@ -287,10 +288,19 @@ sparse_early_usemaps_alloc_pgdat_section
 	 * from the same section as the pgdat where possible to avoid
 	 * this problem.
 	 */
-	goal = __pa(pgdat) & PAGE_SECTION_MASK;
-	host_pgdat = NODE_DATA(early_pfn_to_nid(goal >> PAGE_SHIFT));
-	return __alloc_bootmem_node_nopanic(host_pgdat, size,
-					    SMP_CACHE_BYTES, goal);
+	goal = __pa(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
+	limit = goal + (1UL << PA_SECTION_SHIFT);
+	nid = early_pfn_to_nid(goal >> PAGE_SHIFT);
+
+again:
+	p = ___alloc_bootmem_node_nopanic(NODE_DATA(nid), size,
+					  SMP_CACHE_BYTES, goal, limit);
+	if (!p && limit) {
+		limit = 0;
+		goto again;
+	}
+
+	return p;
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
memblock-free-allocated-memblock_reserved_regions-later.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

