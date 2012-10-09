From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-cleanup-early_node_map-related-comments.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:02 -0700
Message-ID: <20121009181203.0580F1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53699 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab2JISME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:04 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so662627qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, shangw@linux.vnet.ibm.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: cleanup early_node_map[] related comments
has been removed from the -mm tree.  Its filename was
     mm-memblock-cleanup-early_node_map-related-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/memblock: cleanup early_node_map[] related comments

0ee332c14518699 ("memblock: Kill early_node_map[]") removed
early_node_map[].  Clean up the comments to comply with that change.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    3 +--
 mm/nobootmem.c           |    2 --
 mm/page_alloc.c          |    2 +-
 3 files changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-cleanup-early_node_map-related-comments include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-cleanup-early_node_map-related-comments
+++ a/include/linux/memblock.h
@@ -70,8 +70,7 @@ void __next_mem_pfn_range(int *idx, int 
  * @p_end: ptr to ulong for end pfn of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
  *
- * Walks over configured memory ranges.  Available after early_node_map is
- * populated.
+ * Walks over configured memory ranges.
  */
 #define for_each_mem_pfn_range(i, nid, p_start, p_end, p_nid)		\
 	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid); \
diff -puN mm/nobootmem.c~mm-memblock-cleanup-early_node_map-related-comments mm/nobootmem.c
--- a/mm/nobootmem.c~mm-memblock-cleanup-early_node_map-related-comments
+++ a/mm/nobootmem.c
@@ -162,8 +162,6 @@ unsigned long __init free_all_bootmem(vo
 	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
 	 *  because in some case like Node0 doesn't have RAM installed
 	 *  low ram will be on Node1
-	 * Use MAX_NUMNODES will make sure all ranges in early_node_map[]
-	 *  will be used instead of only Node0 related
 	 */
 	return free_low_memory_core_early(MAX_NUMNODES);
 }
diff -puN mm/page_alloc.c~mm-memblock-cleanup-early_node_map-related-comments mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memblock-cleanup-early_node_map-related-comments
+++ a/mm/page_alloc.c
@@ -4931,7 +4931,7 @@ void __init free_area_init_nodes(unsigne
 			       zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
-	/* Print out the early_node_map[] */
+	/* Print out the early node map */
 	printk("Early memory node ranges\n");
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		printk("  node %3d: [mem %#010lx-%#010lx]\n", nid,
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-memblock-reduce-overhead-in-binary-search.patch

