From: akpm@linux-foundation.org
Subject: - vunmap-return-page-array-passed-on-vmap.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:45:13 -0800
Message-ID: <200802050244.m152isuq031147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbYBECo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:44:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     vunmap: return page array passed on vmap()
has been removed from the -mm tree.  Its filename was
     vunmap-return-page-array-passed-on-vmap.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vunmap: return page array passed on vmap()
From: Christoph Lameter <clameter@sgi.com>

Make vunmap return the page array that was used at vmap.  This is useful if
one has no structures to track the page array but simply stores the virtual
address somewhere.  The disposition of the page array can be decided upon
after vunmap.  vfree() may now also be used instead of vunmap which will
release the page array after vunmap'ping it.

As noted by Kamezawa: The same subsystem that provides the page array
to vmap must must use its own method to dispose of the page array.

If vfree() is called to free the page array passed to vmap() [We currently
do not do that] then the page array must either be

1. Allocated via the slab allocator

2. Allocated via vmalloc but then VM_VPAGES must have been passed at
   vunmap to specify that a vfree is needed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 +-
 mm/vmalloc.c            |   33 +++++++++++++++++++++++----------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff -puN include/linux/vmalloc.h~vunmap-return-page-array-passed-on-vmap include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~vunmap-return-page-array-passed-on-vmap
+++ a/include/linux/vmalloc.h
@@ -49,7 +49,7 @@ extern void vfree(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
-extern void vunmap(const void *addr);
+extern struct page **vunmap(const void *addr);
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
diff -puN mm/vmalloc.c~vunmap-return-page-array-passed-on-vmap mm/vmalloc.c
--- a/mm/vmalloc.c~vunmap-return-page-array-passed-on-vmap
+++ a/mm/vmalloc.c
@@ -357,17 +357,18 @@ struct vm_struct *remove_vm_area(const v
 	return v;
 }
 
-static void __vunmap(const void *addr, int deallocate_pages)
+static struct page **__vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
+	struct page **pages;
 
 	if (!addr)
-		return;
+		return NULL;
 
 	if ((PAGE_SIZE-1) & (unsigned long)addr) {
 		printk(KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
 		WARN_ON(1);
-		return;
+		return NULL;
 	}
 
 	area = remove_vm_area(addr);
@@ -375,29 +376,30 @@ static void __vunmap(const void *addr, i
 		printk(KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
 				addr);
 		WARN_ON(1);
-		return;
+		return NULL;
 	}
 
+	pages = area->pages;
 	debug_check_no_locks_freed(addr, area->size);
 
 	if (deallocate_pages) {
 		int i;
 
 		for (i = 0; i < area->nr_pages; i++) {
-			struct page *page = area->pages[i];
+			struct page *page = pages[i];
 
 			BUG_ON(!page);
 			__free_page(page);
 		}
 
 		if (area->flags & VM_VPAGES)
-			vfree(area->pages);
+			vfree(pages);
 		else
-			kfree(area->pages);
+			kfree(pages);
 	}
 
 	kfree(area);
-	return;
+	return pages;
 }
 
 /**
@@ -425,11 +427,13 @@ EXPORT_SYMBOL(vfree);
  *	which was created from the page array passed to vmap().
  *
  *	Must not be called in interrupt context.
+ *
+ *	Returns a pointer to the array of pointers to page structs
  */
-void vunmap(const void *addr)
+struct page **vunmap(const void *addr)
 {
 	BUG_ON(in_interrupt());
-	__vunmap(addr, 0);
+	return __vunmap(addr, 0);
 }
 EXPORT_SYMBOL(vunmap);
 
@@ -442,6 +446,13 @@ EXPORT_SYMBOL(vunmap);
  *
  *	Maps @count pages from @pages into contiguous kernel virtual
  *	space.
+ *
+ *	The page array may be freed via vfree() with the virtual address
+ *	returned from vmap. In that case the page array must be allocated via
+ *	the slab allocator. If the page array was allocated via
+ *	vmalloc then VM_VPAGES must be specified in the flags. There is
+ *	no support for vfree() freeing pages allocated via the
+ *	page allocator.
  */
 void *vmap(struct page **pages, unsigned int count,
 		unsigned long flags, pgprot_t prot)
@@ -454,6 +465,8 @@ void *vmap(struct page **pages, unsigned
 	area = get_vm_area((count << PAGE_SHIFT), flags);
 	if (!area)
 		return NULL;
+	area->pages = pages;
+	area->nr_pages = count;
 	if (map_vm_area(area, prot, &pages)) {
 		vunmap(area->addr);
 		return NULL;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
slub-fix-sysfs-refcounting.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
vmstat-remove-prefetch.patch
set_page_refcounted-vm_bug_on-fix.patch
page-migraton-handle-orphaned-pages.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-newsetup.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
