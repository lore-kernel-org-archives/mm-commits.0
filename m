From: akpm@linux-foundation.org
Subject: + page_alloc-make-movablecore_map-has-higher-priority.patch added to -mm tree
Date: Mon, 14 Jan 2013 14:35:47 -0800
Message-ID: <20130114223548.3632682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:54222 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3ANWfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 17:35:50 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so560693vba.4
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 14:35:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: page_alloc: make movablecore_map has higher priority
has been added to the -mm tree.  Its filename is
     page_alloc-make-movablecore_map-has-higher-priority.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: page_alloc: make movablecore_map has higher priority

If kernelcore or movablecore is specified at the same time with
movablecore_map, movablecore_map will have higher priority to be
satisfied.  This patch will make find_zone_movable_pfns_for_nodes()
calculate zone_movable_pfn[] with the limit from zone_movable_limit[].

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~page_alloc-make-movablecore_map-has-higher-priority mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-make-movablecore_map-has-higher-priority
+++ a/mm/page_alloc.c
@@ -4902,9 +4902,17 @@ static void __init find_zone_movable_pfn
 		required_kernelcore = max(required_kernelcore, corepages);
 	}
 
-	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
-	if (!required_kernelcore)
+	/*
+	 * If neither kernelcore/movablecore nor movablecore_map is specified,
+	 * there is no ZONE_MOVABLE. But if movablecore_map is specified, the
+	 * start pfn of ZONE_MOVABLE has been stored in zone_movable_limit[].
+	 */
+	if (!required_kernelcore) {
+		if (movablecore_map.nr_map)
+			memcpy(zone_movable_pfn, zone_movable_limit,
+				sizeof(zone_movable_pfn));
 		goto out;
+	}
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
@@ -4934,10 +4942,24 @@ restart:
 		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 			unsigned long size_pages;
 
+			/*
+			 * Find more memory for kernelcore in
+			 * [zone_movable_pfn[nid], zone_movable_limit[nid]).
+			 */
 			start_pfn = max(start_pfn, zone_movable_pfn[nid]);
 			if (start_pfn >= end_pfn)
 				continue;
 
+			if (zone_movable_limit[nid]) {
+				end_pfn = min(end_pfn, zone_movable_limit[nid]);
+				/* No range left for kernelcore in this node */
+				if (start_pfn >= end_pfn) {
+					zone_movable_pfn[nid] =
+							zone_movable_limit[nid];
+					break;
+				}
+			}
+
 			/* Account for what is only usable for kernelcore */
 			if (start_pfn < usable_startpfn) {
 				unsigned long kernel_pages;
@@ -4997,12 +5019,12 @@ restart:
 	if (usable_nodes && required_kernelcore > usable_nodes)
 		goto restart;
 
+out:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
 	for (nid = 0; nid < MAX_NUMNODES; nid++)
 		zone_movable_pfn[nid] =
 			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 
-out:
 	/* restore the node_state */
 	node_states[N_MEMORY] = saved_node_state;
 }
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
x86-get-pg_data_ts-memory-from-other-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-introduce-zone_movable_limit-to-keep-movable-limit-for-nodes.patch
page_alloc-make-movablecore_map-has-higher-priority.patch
page_alloc-bootmem-limit-with-movablecore_map.patch

