From: akpm@linux-foundation.org
Subject: + slub-fix-numa-bootstrap.patch added to -mm tree
Date: Tue, 03 Apr 2007 18:24:08 -0700
Message-ID: <200704040124.l341O8RT008845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52037 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966237AbXDDBYL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 21:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Fix numa bootstrap
has been added to the -mm tree.  Its filename is
     slub-fix-numa-bootstrap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Fix numa bootstrap
From: Christoph Lameter <clameter@sgi.com>

NUMA bootstrap calls new_slab() if more than one node is found on bootup. 
new_slab() assumes a standard slab context where interrupts must be
disabled.  It enables interrupts for the call into the page allocator and
then disables them again.  Interrupts do not have to be disabled during on
bootstrap because we still run single threaded there.

I dropped the interrupt preservation code just before SLUB v6 because it
looked useless there.  SLUB worked on the following NUMA tests that just
had a single node.  Sigh.

Enable interrupts after calling new_slab.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/slub.c~slub-fix-numa-bootstrap mm/slub.c
--- a/mm/slub.c~slub-fix-numa-bootstrap
+++ a/mm/slub.c
@@ -1436,6 +1436,8 @@ static int init_kmem_cache_nodes(struct 
 
 			BUG_ON(s->size < sizeof(struct kmem_cache_node));
 			page = new_slab(kmalloc_caches, gfpflags, node);
+			/* new_slab() disables interupts */
+			local_irq_enable();
 
 			BUG_ON(!page);
 			n = page->freelist;
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
slub-add-slabinfo-tool.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
