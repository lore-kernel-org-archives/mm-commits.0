From: akpm@linux-foundation.org
Subject: [merged] mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:32 -0800
Message-ID: <20130225205132.ABE995A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:60742 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759636Ab3BYUvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:33 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so362498qah.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: use CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect movablecore_map in memblock_overlaps_region().
has been removed from the -mm tree.  Its filename was
     mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm/memblock.c: use CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect movablecore_map in memblock_overlaps_region().

The definition of struct movablecore_map is protected by
CONFIG_HAVE_MEMBLOCK_NODE_MAP but its use in memblock_overlaps_region() is
not.  So add CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect the use of
movablecore_map in memblock_overlaps_region().

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    1 +
 mm/memblock.c            |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff -puN include/linux/memblock.h~mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region
+++ a/include/linux/memblock.h
@@ -61,6 +61,7 @@ int memblock_reserve(phys_addr_t base, p
 void memblock_trim_memory(phys_addr_t align);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 			  unsigned long *out_end_pfn, int *out_nid);
 
diff -puN mm/memblock.c~mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-use-config_have_memblock_node_map-to-protect-movablecore_map-in-memblock_overlaps_region
+++ a/mm/memblock.c
@@ -92,9 +92,13 @@ static long __init_memblock memblock_ove
  *
  * Find @size free area aligned to @align in the specified range and node.
  *
+ * If we have CONFIG_HAVE_MEMBLOCK_NODE_MAP defined, we need to check if the
+ * memory we found if not in hotpluggable ranges.
+ *
  * RETURNS:
  * Found address on success, %0 on failure.
  */
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 					phys_addr_t end, phys_addr_t size,
 					phys_addr_t align, int nid)
@@ -139,6 +143,36 @@ restart:
 
 	return 0;
 }
+#else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
+					phys_addr_t end, phys_addr_t size,
+					phys_addr_t align, int nid)
+{
+	phys_addr_t this_start, this_end, cand;
+	u64 i;
+
+	/* pump up @end */
+	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
+		end = memblock.current_limit;
+
+	/* avoid allocating the first page */
+	start = max_t(phys_addr_t, start, PAGE_SIZE);
+	end = max(start, end);
+
+	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
+		this_start = clamp(this_start, start, end);
+		this_end = clamp(this_end, start, end);
+
+		if (this_end < size)
+			continue;
+
+		cand = round_down(this_end - size, align);
+		if (cand >= this_start)
+			return cand;
+	}
+	return 0;
+}
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 /**
  * memblock_find_in_range - find free area in given range
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

