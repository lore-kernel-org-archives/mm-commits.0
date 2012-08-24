From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-memblock-cleanup-early_node_map-related-comments.patch removed from -mm tree
Date: Fri, 24 Aug 2012 15:55:18 -0700
Message-ID: <20120824225519.40E8520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46520 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2HXWzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 18:55:22 -0400
Received: by wgbdt11 with SMTP id dt11so112590wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 15:55:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, benh@kernel.crashing.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, minchan@kernel.org, shangw@linux.vnet.ibm.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: cleanup early_node_map[] related comments
has been removed from the -mm tree.  Its filename was
     mm-memblock-cleanup-early_node_map-related-comments.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/memblock: cleanup early_node_map[] related comments

Commit 0ee332c14518699 ("memblock: Kill early_node_map[]") removed
early_node_map[], the patch does cleanup on comments to comply with that
change.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
@@ -4908,7 +4908,7 @@ void __init free_area_init_nodes(unsigne
 			       zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
-	/* Print out the early_node_map[] */
+	/* Print out the early node map */
 	printk("Early memory node ranges\n");
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		printk("  node %3d: [mem %#010lx-%#010lx]\n", nid,
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-mmu_notifier-init-notifier-if-necessary.patch
mm-vmscan-fix-error-number-for-failed-kthread.patch

