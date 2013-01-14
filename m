From: akpm@linux-foundation.org
Subject: + page_alloc-bootmem-limit-with-movablecore_map.patch added to -mm tree
Date: Mon, 14 Jan 2013 14:35:50 -0800
Message-ID: <20130114223551.9D87720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:47384 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966Ab3ANWfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 17:35:55 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so170514wib.0
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 14:35:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, hpa@zytor.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: page_alloc: bootmem limit with movablecore_map
has been added to the -mm tree.  Its filename is
     page_alloc-bootmem-limit-with-movablecore_map.patch

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
Subject: page_alloc: bootmem limit with movablecore_map

Ensure the bootmem will not allocate memory from areas that may be
ZONE_MOVABLE.  The map info is from movablecore_map boot option.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 +
 mm/memblock.c            |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN include/linux/memblock.h~page_alloc-bootmem-limit-with-movablecore_map include/linux/memblock.h
--- a/include/linux/memblock.h~page_alloc-bootmem-limit-with-movablecore_map
+++ a/include/linux/memblock.h
@@ -42,6 +42,7 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
+extern struct movablecore_map movablecore_map;
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
diff -puN mm/memblock.c~page_alloc-bootmem-limit-with-movablecore_map mm/memblock.c
--- a/mm/memblock.c~page_alloc-bootmem-limit-with-movablecore_map
+++ a/mm/memblock.c
@@ -101,6 +101,7 @@ phys_addr_t __init_memblock memblock_fin
 {
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
+	int curr = movablecore_map.nr_map - 1;
 
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
@@ -114,13 +115,28 @@ phys_addr_t __init_memblock memblock_fin
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
-		if (this_end < size)
+restart:
+		if (this_end <= this_start || this_end < size)
 			continue;
 
+		for (; curr >= 0; curr--) {
+			if ((movablecore_map.map[curr].start_pfn << PAGE_SHIFT)
+			    < this_end)
+				break;
+		}
+
 		cand = round_down(this_end - size, align);
+		if (curr >= 0 &&
+		    cand < movablecore_map.map[curr].end_pfn << PAGE_SHIFT) {
+			this_end = movablecore_map.map[curr].start_pfn
+				   << PAGE_SHIFT;
+			goto restart;
+		}
+
 		if (cand >= this_start)
 			return cand;
 	}
+
 	return 0;
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

