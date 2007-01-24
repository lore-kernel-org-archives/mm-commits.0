From: akpm@osdl.org
Subject: + x86_64-clean-up-sparsemem-memory_present-call.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:39:55 -0800
Message-ID: <200701240639.l0O6dtms010637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54455 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933093AbXAXGkI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 01:40:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bob.picco@hp.com, ak@muc.de, mel@csn.ul.ie


The patch titled
     x86_64: clean up sparsemem memory_present call
has been added to the -mm tree.  Its filename is
     x86_64-clean-up-sparsemem-memory_present-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: clean up sparsemem memory_present call
From: "Bob Picco" <bob.picco@hp.com>

Eliminate arch specific memory_present call x86_64 NUMA by utilizing
sparse_memory_present_with_active_regions.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Bob Picco <bob.picco@hp.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

ia64-register-memory-ranges-in-a-consistent-manner.patch
ia64-clean-up-sparsemem-memory_present-calls.patch
x86_64-clean-up-sparsemem-memory_present-call.patch
