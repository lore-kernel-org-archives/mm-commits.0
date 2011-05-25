From: akpm@linux-foundation.org
Subject: [merged] memblock-nobootmem-remove-code-for-alloc_bootmem_node_high.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:08 -0700
Message-ID: <201105252028.p4PKSVMK014748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab1EYUuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, hpa@zytor.com, lucas.demarchi@profusion.mobi, mingo@elte.hu, olaf@aepfle.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     memblock/nobootmem: remove unneeded code from alloc_bootmem_node_high()
has been removed from the -mm tree.  Its filename was
     memblock-nobootmem-remove-code-for-alloc_bootmem_node_high.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memblock/nobootmem: remove unneeded code from alloc_bootmem_node_high()
From: Yinghai Lu <yinghai@kernel.org>

The bootmem wrapper with memblock supports top-down now, so we no longer
need this trick.

Signed-off-by: Yinghai LU <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nobootmem.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff -puN mm/nobootmem.c~memblock-nobootmem-remove-code-for-alloc_bootmem_node_high mm/nobootmem.c
--- a/mm/nobootmem.c~memblock-nobootmem-remove-code-for-alloc_bootmem_node_high
+++ a/mm/nobootmem.c
@@ -307,30 +307,7 @@ void * __init __alloc_bootmem_node(pg_da
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-#ifdef MAX_DMA32_PFN
-	unsigned long end_pfn;
-
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
-
-	/* update goal according ...MAX_DMA32_PFN */
-	end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
-
-	if (end_pfn > MAX_DMA32_PFN + (128 >> (20 - PAGE_SHIFT)) &&
-	    (goal >> PAGE_SHIFT) < MAX_DMA32_PFN) {
-		void *ptr;
-		unsigned long new_goal;
-
-		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
-		ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
-						 new_goal, -1ULL);
-		if (ptr)
-			return ptr;
-	}
-#endif
-
 	return __alloc_bootmem_node(pgdat, size, align, goal);
