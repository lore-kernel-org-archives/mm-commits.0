From: akpm@linux-foundation.org
Subject: + mm-vmalloc-make-lazy-unmapping-configurable.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:18:37 -0800
Message-ID: <200811130018.mAD0IbWt015645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbYKMATN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:19:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: vmalloc make lazy unmapping configurable
has been added to the -mm tree.  Its filename is
     mm-vmalloc-make-lazy-unmapping-configurable.patch

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
@@ -901,6 +922,7 @@ void vm_unmap_ram(const void *mem, unsig
 	BUG_ON(addr & (PAGE_SIZE-1));
 
 	debug_check_no_locks_freed(mem, size);
+	vmap_debug_free_range(addr, addr+size);
 
 	if (likely(count <= VMAP_MAX_ALLOC))
 		vb_free(mem, size);
@@ -1117,6 +1139,8 @@ struct vm_struct *remove_vm_area(const v
 	if (va && va->flags & VM_VM_AREA) {
 		struct vm_struct *vm = va->private;
 		struct vm_struct *tmp, **p;
+
+		vmap_debug_free_range(va->va_start, va->va_end);
 		free_unmap_vmap_area(va);
 		vm->size -= PAGE_SIZE;
 
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
mm-vmalloc-allocator-off-by-one.patch
mm-vmalloc-failure-flush-fix.patch
mm-vmalloc-search-restart-fix.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
mm-get-rid-of-pagevec_release_nonlru.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch
mm-vmalloc-use-mutex-for-purge.patch
mm-vmalloc-make-lazy-unmapping-configurable.patch
reiser4.patch

