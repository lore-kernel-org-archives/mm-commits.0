From: akpm@linux-foundation.org
Subject: + slub-fix-bug-in-slub-debug-support.patch added to -mm tree
Date: Thu, 26 Jul 2007 23:19:04 -0700
Message-ID: <200707270619.l6R6J4I7009191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757395AbXG0GTO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 02:19:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, clameter@sgi.com


The patch titled
     slub: fix bug in slub debug support
has been added to the -mm tree.  Its filename is
     slub-fix-bug-in-slub-debug-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: fix bug in slub debug support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

We ClearSlabDebug() before the last SlabDebug() check. Clear it later.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-fix-bug-in-slub-debug-support mm/slub.c
--- a/mm/slub.c~slub-fix-bug-in-slub-debug-support
+++ a/mm/slub.c
@@ -1131,6 +1131,7 @@ static void __free_slab(struct kmem_cach
 		slab_pad_check(s, page);
 		for_each_object(p, s, page_address(page))
 			check_object(s, page, p, 0);
+		ClearSlabDebug(page);
 	}
 
 	mod_zone_page_state(page_zone(page),
@@ -1169,7 +1170,6 @@ static void discard_slab(struct kmem_cac
 
 	atomic_long_dec(&n->nr_slabs);
 	reset_page_mapcount(page);
-	ClearSlabDebug(page);
 	__ClearPageSlab(page);
 	free_slab(s, page);
 }
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

slub-add-lock-debugging-check.patch
slub-fix-bug-in-slub-debug-support.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
