From: akpm@linux-foundation.org
Subject: + i386-use-page-allocator-to-allocate-thread_info-structure.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:45:38 -0700
Message-ID: <200704070045.l370jcaA024077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40776 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964796AbXDGApo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, wli@holomorphy.com


The patch titled
     i386: use page allocator to allocate thread_info structure
has been added to the -mm tree.  Its filename is
     i386-use-page-allocator-to-allocate-thread_info-structure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: use page allocator to allocate thread_info structure
From: Christoph Lameter <clameter@sgi.com>

i386 uses kmalloc to allocate the threadinfo structure assuming that the
allocations result in a page sized aligned allocation.  That has worked so
far because SLAB exempts page sized slabs from debugging and aligns them in
special ways that goes beyond the restrictions imposed by
KMALLOC_ARCH_MINALIGN valid for other slabs in the kmalloc array.

SLUB also works fine without debugging since page sized allocations neatly
align at page boundaries.  However, if debugging is switched on then SLUB
will extend the slab with debug information.  The resulting slab is not
longer of page size.  It will only be aligned following the requirements
imposed by KMALLOC_ARCH_MINALIGN.  As a result the threadinfo structure may
not be page aligned which makes i386 fail to boot with SLUB debug on.

Replace the calls to kmalloc with calls into the page allocator.

An alternate solution may be to create a custom slab cache where the
alignment is set to PAGE_SIZE.  That would allow slub debugging to be
applied to the threadinfo structure.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/thread_info.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/asm-i386/thread_info.h~i386-use-page-allocator-to-allocate-thread_info-structure include/asm-i386/thread_info.h
--- a/include/asm-i386/thread_info.h~i386-use-page-allocator-to-allocate-thread_info-structure
+++ a/include/asm-i386/thread_info.h
@@ -95,12 +95,14 @@ static inline struct thread_info *curren
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info(tsk) ((struct thread_info *) \
+	__get_free_pages(GFP_KERNEL| __GFP_ZERO, get_order(THREAD_SIZE)))
 #else
-#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define alloc_thread_info(tsk) ((struct thread_info *) \
+	__get_free_pages(GFP_KERNEL, get_order(THREAD_SIZE)))
 #endif
 
-#define free_thread_info(info)	kfree(info)
+#define free_thread_info(info)	free_pages((unsigned long)(info), get_order(THREAD_SIZE))
 
 #else /* !__ASSEMBLY__ */
 
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
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-add-slabinfo-tool.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
