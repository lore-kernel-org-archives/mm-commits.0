From: akpm@linux-foundation.org
Subject: - x86_64-clean-up-sparsemem-memory_present-call.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:53:04 -0800
Message-ID: <200702082153.l18Lr4YN027681@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41519 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423470AbXBHVxY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:53:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bob.picco@hp.com, ak@muc.de, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     x86_64: clean up sparsemem memory_present call
has been removed from the -mm tree.  Its filename was
     x86_64-clean-up-sparsemem-memory_present-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: clean up sparsemem memory_present call
From: "Bob Picco" <bob.picco@hp.com>

Eliminate arch specific memory_present call x86_64 NUMA by utilizing
sparse_memory_present_with_active_regions.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Bob Picco <bob.picco@hp.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-clean-up-sparsemem-memory_present-call arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-clean-up-sparsemem-memory_present-call
+++ a/arch/x86_64/mm/numa.c
@@ -460,20 +460,6 @@ unsigned long __init numa_free_all_bootm
 	return pages;
 } 
 
-#ifdef CONFIG_SPARSEMEM
-static void __init arch_sparse_init(void)
-{
-	int i;
-
-	for_each_online_node(i)
-		memory_present(i, node_start_pfn(i), node_end_pfn(i));
-
-	sparse_init();
-}
-#else
-#define arch_sparse_init() do {} while (0)
-#endif
-
 void __init paging_init(void)
 { 
 	int i;
@@ -483,7 +469,8 @@ void __init paging_init(void)
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = end_pfn;
 
-	arch_sparse_init();
+	sparse_memory_present_with_active_regions(MAX_NUMNODES);
+	sparse_init();
 
 	for_each_online_node(i) {
 		setup_node_zones(i); 
_

Patches currently in -mm which might be from bob.picco@hp.com are

origin.patch
