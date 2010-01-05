From: akpm@linux-foundation.org
Subject: [to-be-updated] sparsemem-put-usemap-for-one-node-together.patch removed from -mm tree
Date: Mon, 04 Jan 2010 18:38:41 -0800
Message-ID: <201001050238.o052cfEI002757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753422Ab0AECjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 21:39:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, cl@linux-foundation.org, hannes@cmpxchg.org, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, shaohua.li@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sparsemem: put usemap for one node together
has been removed from the -mm tree.  Its filename was
     sparsemem-put-usemap-for-one-node-together.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparsemem: put usemap for one node together
From: Yinghai Lu <yinghai@kernel.org>

Could save some buf instead of applying one by one.

Could help that system that is going to use early_res instead of bootmem
less entries in early_res make search more faster on system with more
memory.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   86 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 19 deletions(-)

diff -puN mm/sparse.c~sparsemem-put-usemap-for-one-node-together mm/sparse.c
--- a/mm/sparse.c~sparsemem-put-usemap-for-one-node-together
+++ a/mm/sparse.c
@@ -271,7 +271,8 @@ static unsigned long *__kmalloc_section_
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static unsigned long * __init
-sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
+					 unsigned long count)
 {
 	unsigned long section_nr;
 
@@ -286,7 +287,7 @@ sparse_early_usemap_alloc_pgdat_section(
 	 * this problem.
 	 */
 	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
-	return alloc_bootmem_section(usemap_size(), section_nr);
+	return alloc_bootmem_section(usemap_size() * count, section_nr);
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
@@ -329,7 +330,8 @@ static void __init check_usemap_section_
 }
 #else
 static unsigned long * __init
-sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
+					 unsigned long count)
 {
 	return NULL;
 }
@@ -339,27 +341,40 @@ static void __init check_usemap_section_
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
+static void __init sparse_early_usemaps_alloc_node(unsigned long**usemap_map,
+				 unsigned long pnum_begin,
+				 unsigned long pnum_end,
+				 unsigned long usemap_count, int nodeid)
 {
-	unsigned long *usemap;
-	struct mem_section *ms = __nr_to_section(pnum);
-	int nid = sparse_early_nid(ms);
-
-	usemap = sparse_early_usemap_alloc_pgdat_section(NODE_DATA(nid));
-	if (usemap)
-		return usemap;
+	void *usemap;
+	unsigned long pnum;
+	int size = usemap_size();
 
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	usemap = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
+								 usemap_count);
 	if (usemap) {
-		check_usemap_section_nr(nid, usemap);
-		return usemap;
+		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
+			if (!present_section_nr(pnum))
+				continue;
+			usemap_map[pnum] = usemap;
+			usemap += size;
+		}
+		return;
 	}
 
-	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
-	nid = 0;
+	usemap = alloc_bootmem_node(NODE_DATA(nodeid), size * usemap_count);
+	if (usemap) {
+		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
+			if (!present_section_nr(pnum))
+				continue;
+			usemap_map[pnum] = usemap;
+			usemap += size;
+			check_usemap_section_nr(nodeid, usemap_map[pnum]);
+		}
+		return;
+	}
 
 	printk(KERN_WARNING "%s: allocation failed\n", __func__);
-	return NULL;
 }
 
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
@@ -396,6 +411,7 @@ static struct page __init *sparse_early_
 void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
 {
 }
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -407,6 +423,9 @@ void __init sparse_init(void)
 	unsigned long *usemap;
 	unsigned long **usemap_map;
 	int size;
+	int nodeid_begin = 0;
+	unsigned long pnum_begin = 0;
+	unsigned long usemap_count;
 
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
@@ -425,10 +444,39 @@ void __init sparse_init(void)
 		panic("can not allocate usemap_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+
 		if (!present_section_nr(pnum))
 			continue;
-		usemap_map[pnum] = sparse_early_usemap_alloc(pnum);
-	}
+		ms = __nr_to_section(pnum);
+		nodeid_begin = sparse_early_nid(ms);
+		pnum_begin = pnum;
+		break;
+	}
+	usemap_count = 1;
+	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+		int nodeid;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid = sparse_early_nid(ms);
+		if (nodeid == nodeid_begin) {
+			usemap_count++;
+			continue;
+		}
+		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
+		sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, pnum,
+						 usemap_count, nodeid_begin);
+		/* new start, update count etc*/
+		nodeid_begin = nodeid;
+		pnum_begin = pnum;
+		usemap_count = 1;
+	}
+	/* ok, last chunk */
+	sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, NR_MEM_SECTIONS,
+					 usemap_count, nodeid_begin);
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
sparsemem-put-usemap-for-one-node-together.patch

