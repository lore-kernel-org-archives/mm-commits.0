From: akpm@linux-foundation.org
Subject: [merged] mm-sparse-introduce-alloc_usemap_and_memmap.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:03 -0700
Message-ID: <523219bf.Cfj/khb7HpnQqxDw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab3ILTpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tj@kernel.org, rientjes@google.com, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, jkosina@suse.cz, isimatu.yasuaki@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, fengguang.wu@intel.com, dave.hansen@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-sparse-introduce-alloc_usemap_and_memmap.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,dave.hansen@linux.intel.com,fengguang.wu@intel.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,isimatu.yasuaki@jp.fujitsu.com,jkosina@suse.cz,kosaki.motohiro@jp.fujitsu.com,riel@redhat.com,rientjes@google.com,tj@kernel.org,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:03 -0700


The patch titled
     Subject: mm/sparse: introduce alloc_usemap_and_memmap
has been removed from the -mm tree.  Its filename was
     mm-sparse-introduce-alloc_usemap_and_memmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/sparse: introduce alloc_usemap_and_memmap

After commit 9bdac91424075 ("sparsemem: Put mem map for one node
together."), vmemmap for one node will be allocated together, its logic is
similar as memory allocation for pageblock flags.  This patch introduces
alloc_usemap_and_memmap to extract the same logic of memory alloction for
pageblock flags and vmemmap.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |  133 +++++++++++++++++++++-----------------------------
 1 file changed, 57 insertions(+), 76 deletions(-)

diff -puN mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap mm/sparse.c
--- a/mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap
+++ a/mm/sparse.c
@@ -339,13 +339,14 @@ static void __init check_usemap_section_
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-static void __init sparse_early_usemaps_alloc_node(unsigned long**usemap_map,
+static void __init sparse_early_usemaps_alloc_node(void *data,
 				 unsigned long pnum_begin,
 				 unsigned long pnum_end,
 				 unsigned long usemap_count, int nodeid)
 {
 	void *usemap;
 	unsigned long pnum;
+	unsigned long **usemap_map = (unsigned long **)data;
 	int size = usemap_size();
 
 	usemap = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
@@ -430,11 +431,12 @@ void __init sparse_mem_maps_populate_nod
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
+static void __init sparse_early_mem_maps_alloc_node(void *data,
 				 unsigned long pnum_begin,
 				 unsigned long pnum_end,
 				 unsigned long map_count, int nodeid)
 {
+	struct page **map_map = (struct page **)data;
 	sparse_mem_maps_populate_node(map_map, pnum_begin, pnum_end,
 					 map_count, nodeid);
 }
@@ -460,6 +462,55 @@ void __attribute__((weak)) __meminit vme
 {
 }
 
+/**
+ *  alloc_usemap_and_memmap - memory alloction for pageblock flags and vmemmap
+ *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
+ */
+static void __init alloc_usemap_and_memmap(void (*alloc_func)
+					(void *, unsigned long, unsigned long,
+					unsigned long, int), void *data)
+{
+	unsigned long pnum;
+	unsigned long map_count;
+	int nodeid_begin = 0;
+	unsigned long pnum_begin = 0;
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid_begin = sparse_early_nid(ms);
+		pnum_begin = pnum;
+		break;
+	}
+	map_count = 1;
+	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+		int nodeid;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid = sparse_early_nid(ms);
+		if (nodeid == nodeid_begin) {
+			map_count++;
+			continue;
+		}
+		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
+		alloc_func(data, pnum_begin, pnum,
+						map_count, nodeid_begin);
+		/* new start, update count etc*/
+		nodeid_begin = nodeid;
+		pnum_begin = pnum;
+		map_count = 1;
+	}
+	/* ok, last chunk */
+	alloc_func(data, pnum_begin, NR_MEM_SECTIONS,
+						map_count, nodeid_begin);
+}
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -471,11 +522,7 @@ void __init sparse_init(void)
 	unsigned long *usemap;
 	unsigned long **usemap_map;
 	int size;
-	int nodeid_begin = 0;
-	unsigned long pnum_begin = 0;
-	unsigned long usemap_count;
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-	unsigned long map_count;
 	int size2;
 	struct page **map_map;
 #endif
@@ -501,82 +548,16 @@ void __init sparse_init(void)
 	usemap_map = alloc_bootmem(size);
 	if (!usemap_map)
 		panic("can not allocate usemap_map\n");
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid_begin = sparse_early_nid(ms);
-		pnum_begin = pnum;
-		break;
-	}
-	usemap_count = 1;
-	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-		int nodeid;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid = sparse_early_nid(ms);
-		if (nodeid == nodeid_begin) {
-			usemap_count++;
-			continue;
-		}
-		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
-		sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, pnum,
-						 usemap_count, nodeid_begin);
-		/* new start, update count etc*/
-		nodeid_begin = nodeid;
-		pnum_begin = pnum;
-		usemap_count = 1;
-	}
-	/* ok, last chunk */
-	sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, NR_MEM_SECTIONS,
-					 usemap_count, nodeid_begin);
+	alloc_usemap_and_memmap(sparse_early_usemaps_alloc_node,
+							(void *)usemap_map);
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
 	map_map = alloc_bootmem(size2);
 	if (!map_map)
 		panic("can not allocate map_map\n");
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid_begin = sparse_early_nid(ms);
-		pnum_begin = pnum;
-		break;
-	}
-	map_count = 1;
-	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-		int nodeid;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid = sparse_early_nid(ms);
-		if (nodeid == nodeid_begin) {
-			map_count++;
-			continue;
-		}
-		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
-		sparse_early_mem_maps_alloc_node(map_map, pnum_begin, pnum,
-						 map_count, nodeid_begin);
-		/* new start, update count etc*/
-		nodeid_begin = nodeid;
-		pnum_begin = pnum;
-		map_count = 1;
-	}
-	/* ok, last chunk */
-	sparse_early_mem_maps_alloc_node(map_map, pnum_begin, NR_MEM_SECTIONS,
-					 map_count, nodeid_begin);
+	alloc_usemap_and_memmap(sparse_early_mem_maps_alloc_node,
+							(void *)map_map);
 #endif
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

