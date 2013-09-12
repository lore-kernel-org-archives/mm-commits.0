From: akpm@linux-foundation.org
Subject: [merged] memblock-numa-binary-search-node-id.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:44:33 -0700
Message-ID: <523219a1.ZseL6o5i0Gp3qXyD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rja@sgi.com, yinghai@kernel.org

Subject: [merged] memblock-numa-binary-search-node-id.patch removed from -mm tree
To: yinghai@kernel.org,rja@sgi.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:33 -0700


The patch titled
     Subject: memblock, numa: binary search node id
has been removed from the -mm tree.  Its filename was
     memblock-numa-binary-search-node-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: memblock, numa: binary search node id

Current early_pfn_to_nid() on arch that support memblock go over
memblock.memory one by one, so will take too many try near the end.

We can use existing memblock_search to find the node id for given pfn,
that could save some time on bigger system that have many entries
memblock.memory array.

Here are the timing differences for several machines.  In each case with
the patch less time was spent in __early_pfn_to_nid().

                        3.11-rc5        with patch      difference (%)
                        --------        ----------      --------------
UV1: 256 nodes  9TB:     411.66          402.47         -9.19 (2.23%)
UV2: 255 nodes 16TB:    1141.02         1138.12         -2.90 (0.25%)
UV2:  64 nodes  2TB:     128.15          126.53         -1.62 (1.26%)
UV2:  32 nodes  2TB:     121.87          121.07         -0.80 (0.66%)
                        Time in seconds.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    2 ++
 mm/memblock.c            |   18 ++++++++++++++++++
 mm/page_alloc.c          |   19 +++++++++----------
 3 files changed, 29 insertions(+), 10 deletions(-)

diff -puN include/linux/memblock.h~memblock-numa-binary-search-node-id include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-numa-binary-search-node-id
+++ a/include/linux/memblock.h
@@ -60,6 +60,8 @@ int memblock_reserve(phys_addr_t base, p
 void memblock_trim_memory(phys_addr_t align);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
+			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 			  unsigned long *out_end_pfn, int *out_nid);
 
diff -puN mm/memblock.c~memblock-numa-binary-search-node-id mm/memblock.c
--- a/mm/memblock.c~memblock-numa-binary-search-node-id
+++ a/mm/memblock.c
@@ -914,6 +914,24 @@ int __init_memblock memblock_is_memory(p
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
+			 unsigned long *start_pfn, unsigned long *end_pfn)
+{
+	struct memblock_type *type = &memblock.memory;
+	int mid = memblock_search(type, (phys_addr_t)pfn << PAGE_SHIFT);
+
+	if (mid == -1)
+		return -1;
+
+	*start_pfn = type->regions[mid].base >> PAGE_SHIFT;
+	*end_pfn = (type->regions[mid].base + type->regions[mid].size)
+			>> PAGE_SHIFT;
+
+	return type->regions[mid].nid;
+}
+#endif
+
 /**
  * memblock_is_region_memory - check if a region is a subset of memory
  * @base: base of region to check
diff -puN mm/page_alloc.c~memblock-numa-binary-search-node-id mm/page_alloc.c
--- a/mm/page_alloc.c~memblock-numa-binary-search-node-id
+++ a/mm/page_alloc.c
@@ -4306,7 +4306,7 @@ int __meminit init_currently_empty_zone(
 int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
 	unsigned long start_pfn, end_pfn;
-	int i, nid;
+	int nid;
 	/*
 	 * NOTE: The following SMP-unsafe globals are only used early in boot
 	 * when the kernel is running single-threaded.
@@ -4317,15 +4317,14 @@ int __meminit __early_pfn_to_nid(unsigne
 	if (last_start_pfn <= pfn && pfn < last_end_pfn)
 		return last_nid;
 
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
-		if (start_pfn <= pfn && pfn < end_pfn) {
-			last_start_pfn = start_pfn;
-			last_end_pfn = end_pfn;
-			last_nid = nid;
-			return nid;
-		}
-	/* This is a memory hole */
-	return -1;
+	nid = memblock_search_pfn_nid(pfn, &start_pfn, &end_pfn);
+	if (nid != -1) {
+		last_start_pfn = start_pfn;
+		last_end_pfn = end_pfn;
+		last_nid = nid;
+	}
+
+	return nid;
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch

