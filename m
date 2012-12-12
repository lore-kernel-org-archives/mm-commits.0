From: akpm@linux-foundation.org
Subject: [merged] mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:26 -0800
Message-ID: <20121212195826.AA88C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:59230 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:27 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so116541yhr.2
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, highmem: use PKMAP_NR() to calculate an index of pkmap
has been removed from the -mm tree.  Its filename was
     mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, highmem: use PKMAP_NR() to calculate an index of pkmap

To calculate an index of pkmap, using PKMAP_NR() is more understandable
and maintainable, so change it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/highmem.c~mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap mm/highmem.c
--- a/mm/highmem.c~mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap
+++ a/mm/highmem.c
@@ -99,7 +99,7 @@ struct page *kmap_to_page(void *vaddr)
 	unsigned long addr = (unsigned long)vaddr;
 
 	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
-		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
+		int i = PKMAP_NR(addr);
 		return pte_page(pkmap_page_table[i]);
 	}
 
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch
bootmem-remove-alloc_arch_preferred_bootmem.patch
mm-warn_on_once-if-f_op-mmap-change-vmas-start-address.patch
linux-next.patch

