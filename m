From: akpm@linux-foundation.org
Subject: - mm-vmalloc-make-lazy-unmapping-configurable.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:04 -0800
Message-ID: <200901072212.n07MC4rR012327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755114AbZAGWMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: vmalloc make lazy unmapping configurable
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-make-lazy-unmapping-configurable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmalloc make lazy unmapping configurable
From: Nick Piggin <npiggin@suse.de>

Lazy unmapping in the vmalloc code has now opened the possibility for use
after free bugs to go undetected.  We can catch those by forcing an unmap
and flush (which is going to be slow, but that's what happens).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN mm/vmalloc.c~mm-vmalloc-make-lazy-unmapping-configurable mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-make-lazy-unmapping-configurable
+++ a/mm/vmalloc.c
@@ -434,6 +434,27 @@ static void unmap_vmap_area(struct vmap_
 	vunmap_page_range(va->va_start, va->va_end);
 }
 
+static void vmap_debug_free_range(unsigned long start, unsigned long end)
+{
+	/*
+	 * Unmap page tables and force a TLB flush immediately if
+	 * CONFIG_DEBUG_PAGEALLOC is set. This catches use after free
+	 * bugs similarly to those in linear kernel virtual address
+	 * space after a page has been freed.
+	 *
+	 * All the lazy freeing logic is still retained, in order to
+	 * minimise intrusiveness of this debugging feature.
+	 *
+	 * This is going to be *slow* (linear kernel virtual address
+	 * debugging doesn't do a broadcast TLB flush so it is a lot
+	 * faster).
+	 */
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	vunmap_page_range(start, end);
+	flush_tlb_kernel_range(start, end);
+#endif
+}
+
 /*
  * lazy_max_pages is the maximum amount of virtual address space we gather up
  * before attempting to purge with a TLB flush.
@@ -914,6 +935,7 @@ void vm_unmap_ram(const void *mem, unsig
 	BUG_ON(addr & (PAGE_SIZE-1));
 
 	debug_check_no_locks_freed(mem, size);
+	vmap_debug_free_range(addr, addr+size);
 
 	if (likely(count <= VMAP_MAX_ALLOC))
 		vb_free(mem, size);
@@ -1130,6 +1152,8 @@ struct vm_struct *remove_vm_area(const v
 	if (va && va->flags & VM_VM_AREA) {
 		struct vm_struct *vm = va->private;
 		struct vm_struct *tmp, **p;
+
+		vmap_debug_free_range(va->va_start, va->va_end);
 		free_unmap_vmap_area(va);
 		vm->size -= PAGE_SIZE;
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

