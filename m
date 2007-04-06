From: akpm@linux-foundation.org
Subject: + slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch added to -mm tree
Date: Fri, 06 Apr 2007 15:50:35 -0700
Message-ID: <200704062250.l36MoZs8021333@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36548 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290AbXDFWun (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 18:50:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     SLUB: Treat SLAB_HWCACHE_ALIGN as a mininum and not as *the* alignment
has been added to the -mm tree.  Its filename is
     slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Treat SLAB_HWCACHE_ALIGN as a mininum and not as *the* alignment
From: Christoph Lameter <clameter@sgi.com>

Checking for slabs used in powerpc arch code:

The pgtable cache is configured as

          pgtable_cache[i] = kmem_cache_create(name,
                                                     size, size,
                                                     SLAB_HWCACHE_ALIGN |
                                                     SLAB_MUST_HWCACHE_ALIGN,
                                                     zero_ctor,
                                                     NULL);

Hmmm.... aligned slabs at size and then we MUST_HWCACHE_ALIGN?? Two
competing alignment requirements and a constructor. Constructor requires
the moving of the free pointer after the slab and thus increases the slab
size.

Sigh. IF SLAB_HWCACHE_ALIGN is set then SLUB believes this to be the
ultimate demand that overrides all other alignments and only aligns to the
cacheline. Try the following fix:

SLUB: Treat SLAB_HWCACHE_ALIGN as a mininum and not as *the* alignment

If the specified alignment is higher than L1_CACHE_BYTES and
SLAB_HWCACHE_ALIGN is set then use the higher alignment.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/slub.c~slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment mm/slub.c
--- a/mm/slub.c~slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment
+++ a/mm/slub.c
@@ -1373,10 +1373,7 @@ static int calculate_order(int size)
 static unsigned long calculate_alignment(unsigned long flags,
 		unsigned long align)
 {
-	if (flags & SLAB_HWCACHE_ALIGN)
-		return L1_CACHE_BYTES;
-
-	if (flags & SLAB_MUST_HWCACHE_ALIGN)
+	if (flags & (SLAB_MUST_HWCACHE_ALIGN | SLAB_HWCACHE_ALIGN))
 		return max_t(unsigned long, align, L1_CACHE_BYTES);
 
 	if (align < ARCH_SLAB_MINALIGN)
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
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-add-slabinfo-tool.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
