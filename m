From: akpm@linux-foundation.org
Subject: + memblock-nobootmem-remove-code-for-alloc_bootmem_node_high.patch added to -mm tree
Date: Mon, 09 May 2011 15:57:53 -0700
Message-ID: <201105092257.p49MvroN024069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab1EIW6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 18:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, hpa@zytor.com, lucas.demarchi@profusion.mobi, mingo@elte.hu, olaf@aepfle.de, tj@kernel.org


The patch titled
     memblock/nobootmem: remove unneeded code from alloc_bootmem_node_high()
has been added to the -mm tree.  Its filename is
     memblock-nobootmem-remove-code-for-alloc_bootmem_node_high.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
