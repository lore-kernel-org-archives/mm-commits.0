From: akpm@linux-foundation.org
Subject: [merged] page_allocc-remove-add_from_early_node_map.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:16 -0700
Message-ID: <20120322201916.8368AA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:48151 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030587Ab2CVUTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2012 16:19:18 -0400
Received: by laai8 with SMTP id i8so133932laa.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: consul.kautuk@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc.c: remove add_from_early_node_map()
has been removed from the -mm tree.  Its filename was
     page_allocc-remove-add_from_early_node_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: page_alloc.c: remove add_from_early_node_map()

add_from_early_node_map() is unused.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/page_alloc.c    |   12 ------------
 2 files changed, 14 deletions(-)

diff -puN include/linux/mm.h~page_allocc-remove-add_from_early_node_map include/linux/mm.h
--- a/include/linux/mm.h~page_allocc-remove-add_from_early_node_map
+++ a/include/linux/mm.h
@@ -1295,8 +1295,6 @@ extern void get_pfn_range_for_nid(unsign
 extern unsigned long find_min_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
-int add_from_early_node_map(struct range *range, int az,
-				   int nr_range, int nid);
 extern void sparse_memory_present_with_active_regions(int nid);
 
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
diff -puN mm/page_alloc.c~page_allocc-remove-add_from_early_node_map mm/page_alloc.c
--- a/mm/page_alloc.c~page_allocc-remove-add_from_early_node_map
+++ a/mm/page_alloc.c
@@ -3940,18 +3940,6 @@ void __init free_bootmem_with_active_reg
 	}
 }
 
-int __init add_from_early_node_map(struct range *range, int az,
-				   int nr_range, int nid)
-{
-	unsigned long start_pfn, end_pfn;
-	int i;
-
-	/* need to go over early_node_map to find out good range for node */
-	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL)
-		nr_range = add_range(range, az, nr_range, start_pfn, end_pfn);
-	return nr_range;
-}
