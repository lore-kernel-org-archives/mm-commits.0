From: akpm@osdl.org
Subject: - numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:52 -0800
Message-ID: <200612072257.kB7MvqZh029332@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50731 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163643AbWLGW60 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, clameter@engr.sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     numa node ids are int, page_to_nid and zone_to_nid should return int
has been removed from the -mm tree.  Its filename was
     numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: numa node ids are int, page_to_nid and zone_to_nid should return int
From: Andy Whitcroft <apw@shadowen.org>

NUMA node ids are passed as either int or unsigned int almost exclusivly
page_to_nid and zone_to_nid both return unsigned long.  This is a throw
back to when page_to_nid was a #define and was thus exposing the real type
of the page flags field.

In addition to fixing up the definitions of page_to_nid and zone_to_nid I
audited the users of these functions identifying the following incorrect
uses:

1) mm/page_alloc.c show_node() -- printk dumping the node id,
2) include/asm-ia64/pgalloc.h pgtable_quicklist_free() -- comparison
   against numa_node_id() which returns an int from cpu_to_node(), and
3) mm/mpolicy.c check_pte_range -- used as an index in node_isset which
   uses bit_set which in generic code takes an int.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-ia64/pgalloc.h |    2 +-
 include/linux/mm.h         |    6 +++---
 mm/mempolicy.c             |    2 +-
 mm/page_alloc.c            |    2 +-
 mm/sparse.c                |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/asm-ia64/pgalloc.h~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int include/asm-ia64/pgalloc.h
--- a/include/asm-ia64/pgalloc.h~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int
+++ a/include/asm-ia64/pgalloc.h
@@ -60,7 +60,7 @@ static inline void *pgtable_quicklist_al
 static inline void pgtable_quicklist_free(void *pgtable_entry)
 {
 #ifdef CONFIG_NUMA
-	unsigned long nid = page_to_nid(virt_to_page(pgtable_entry));
+	int nid = page_to_nid(virt_to_page(pgtable_entry));
 
 	if (unlikely(nid != numa_node_id())) {
 		free_page((unsigned long)pgtable_entry);
diff -puN include/linux/mm.h~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int include/linux/mm.h
--- a/include/linux/mm.h~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int
+++ a/include/linux/mm.h
@@ -456,7 +456,7 @@ static inline int page_zone_id(struct pa
 	return (page->flags >> ZONEID_PGSHIFT) & ZONEID_MASK;
 }
 
-static inline unsigned long zone_to_nid(struct zone *zone)
+static inline int zone_to_nid(struct zone *zone)
 {
 #ifdef CONFIG_NUMA
 	return zone->node;
@@ -466,9 +466,9 @@ static inline unsigned long zone_to_nid(
 }
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
-extern unsigned long page_to_nid(struct page *page);
+extern int page_to_nid(struct page *page);
 #else
-static inline unsigned long page_to_nid(struct page *page)
+static inline int page_to_nid(struct page *page)
 {
 	return (page->flags >> NODES_PGSHIFT) & NODES_MASK;
 }
diff -puN mm/mempolicy.c~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int mm/mempolicy.c
--- a/mm/mempolicy.c~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int
+++ a/mm/mempolicy.c
@@ -221,7 +221,7 @@ static int check_pte_range(struct vm_are
 	orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	do {
 		struct page *page;
-		unsigned int nid;
+		int nid;
 
 		if (!pte_present(*pte))
 			continue;
diff -puN mm/page_alloc.c~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int mm/page_alloc.c
--- a/mm/page_alloc.c~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int
+++ a/mm/page_alloc.c
@@ -1407,7 +1407,7 @@ unsigned int nr_free_pagecache_pages(voi
 static inline void show_node(struct zone *zone)
 {
 	if (NUMA_BUILD)
-		printk("Node %ld ", zone_to_nid(zone));
+		printk("Node %d ", zone_to_nid(zone));
 }
 
 void si_meminfo(struct sysinfo *val)
diff -puN mm/sparse.c~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int mm/sparse.c
--- a/mm/sparse.c~numa-node-ids-are-int-page_to_nid-and-zone_to_nid-should-return-int
+++ a/mm/sparse.c
@@ -36,7 +36,7 @@ static u8 section_to_node_table[NR_MEM_S
 static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
 #endif
 
-unsigned long page_to_nid(struct page *page)
+int page_to_nid(struct page *page)
 {
 	return section_to_node_table[page_to_section(page)];
 }
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
git-acpi.patch
pci-device-ensure-sysdata-initialised-v2.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
optional-zone_dma-in-the-vm.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch

