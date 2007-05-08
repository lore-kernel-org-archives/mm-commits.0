From: akpm@linux-foundation.org
Subject: - i386-use-page-allocator-to-allocate-thread_info-structure.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:52 -0700
Message-ID: <200705080002.l4802qVG008884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967325AbXEHADN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     i386: use page allocator to allocate thread_info structure
has been removed from the -mm tree.  Its filename was
     i386-use-page-allocator-to-allocate-thread_info-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
