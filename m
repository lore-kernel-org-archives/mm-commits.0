From: akpm@linux-foundation.org
Subject: - remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:22:28 -0800
Message-ID: <200703060122.l261MSAs007557@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45051 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779AbXCFBWe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:22:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Remove uses of kmem_cache_t from mm/* and include/linux/slab.h
has been removed from the -mm tree.  Its filename was
     remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch

This patch was dropped because it was folded into mm-implement-swap-prefetching.patch

------------------------------------------------------
Subject: Remove uses of kmem_cache_t from mm/* and include/linux/slab.h
From: Christoph Lameter <clameter@sgi.com>

Remove all uses of kmem_cache_t (the most were left in slab.h).  The
typedef for kmem_cache_t is then only necessary for other kernel
subsystems.  Add a comment to that effect.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/swap_prefetch.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_prefetch.c~remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch
+++ a/mm/swap_prefetch.c
@@ -39,7 +39,7 @@ struct swapped_root {
 	struct radix_tree_root	swap_tree;	/* Lookup tree of pages */
 	unsigned int		count;		/* Number of entries */
 	unsigned int		maxcount;	/* Maximum entries allowed */
-	kmem_cache_t		*cache;		/* Of struct swapped_entry */
+	struct kmem_cache	*cache;		/* Of struct swapped_entry */
 };
 
 static struct swapped_root swapped = {
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
