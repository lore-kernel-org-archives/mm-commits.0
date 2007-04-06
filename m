From: akpm@linux-foundation.org
Subject: + slub-use-correct-flags-to-check-for-dma-cache.patch added to -mm tree
Date: Fri, 06 Apr 2007 15:49:15 -0700
Message-ID: <200704062249.l36MnFZw021272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294AbXDFWtR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 18:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Use correct flags to check for DMA cache
has been added to the -mm tree.  Its filename is
     slub-use-correct-flags-to-check-for-dma-cache.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Use correct flags to check for DMA cache
From: Christoph Lameter <clameter@sgi.com>

We use a GFP mask to check the SLAB flags if this is a DMA cache.

Fix this by using the correct SLAB mask and then use the SLUB_DMA for the
ORing of flags.  If the system does not support DMA then we will OR zero
which will hopefully get the compiler to drop the useless if statement as
well.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-use-correct-flags-to-check-for-dma-cache mm/slub.c
--- a/mm/slub.c~slub-use-correct-flags-to-check-for-dma-cache
+++ a/mm/slub.c
@@ -678,8 +678,8 @@ static struct page *allocate_slab(struct
 	if (s->order)
 		flags |= __GFP_COMP;
 
-	if (s->flags & SLUB_DMA)
-		flags |= GFP_DMA;
+	if (s->flags & SLAB_CACHE_DMA)
+		flags |= SLUB_DMA;
 
 	if (node == -1)
 		page = alloc_pages(flags, s->order);
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-add-slabinfo-tool.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
