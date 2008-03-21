From: akpm@linux-foundation.org
Subject: - mm-fix-various-kernel-doc-comments.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:28:57 -0700
Message-ID: <200803212028.m2LKSvuF008754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbYCUU3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix various kernel-doc comments
has been removed from the -mm tree.  Its filename was
     mm-fix-various-kernel-doc-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix various kernel-doc comments
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix various kernel-doc notation in mm/:

filemap.c: add function short description; convert 2 to kernel-doc
fremap.c: change parameter 'prot' to @prot
pagewalk.c: change "-" in function parameters to ":"
slab.c: fix short description of kmem_ptr_validate()
swap.c: fix description & parameters of put_pages_list()
swap_state.c: fix function parameters
vmalloc.c: change "@returns" to "Returns:" since that is not a parameter

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |   20 +++++++++++++++++---
 mm/fremap.c     |    2 +-
 mm/pagewalk.c   |   10 +++++-----
 mm/slab.c       |    5 ++---
 mm/swap.c       |    5 ++---
 mm/swap_state.c |    2 ++
 mm/vmalloc.c    |    6 ++++--
 7 files changed, 33 insertions(+), 17 deletions(-)

diff -puN mm/filemap.c~mm-fix-various-kernel-doc-comments mm/filemap.c
--- a/mm/filemap.c~mm-fix-various-kernel-doc-comments
+++ a/mm/filemap.c
@@ -343,7 +343,7 @@ int sync_page_range(struct inode *inode,
 EXPORT_SYMBOL(sync_page_range);
 
 /**
- * sync_page_range_nolock
+ * sync_page_range_nolock - write & wait on all pages in the passed range without locking
  * @inode:	target inode
  * @mapping:	target address_space
  * @pos:	beginning offset in pages to write
@@ -611,7 +611,10 @@ int __lock_page_killable(struct page *pa
 					sync_page_killable, TASK_KILLABLE);
 }
 
-/*
+/**
+ * __lock_page_nosync - get a lock on the page, without calling sync_page()
+ * @page: the page to lock
+ *
  * Variant of lock_page that does not require the caller to hold a reference
  * on the page's mapping.
  */
@@ -1538,9 +1541,20 @@ repeat:
 	return page;
 }
 
-/*
+/**
+ * read_cache_page_async - read into page cache, fill it if needed
+ * @mapping:	the page's address_space
+ * @index:	the page index
+ * @filler:	function to perform the read
+ * @data:	destination for read data
+ *
  * Same as read_cache_page, but don't wait for page to become unlocked
  * after submitting it to the filler.
+ *
+ * Read into the page cache. If a page already exists, and PageUptodate() is
+ * not set, try to fill the page but don't wait for it to become unlocked.
+ *
+ * If the page does not get brought uptodate, return -EIO.
  */
 struct page *read_cache_page_async(struct address_space *mapping,
 				pgoff_t index,
diff -puN mm/fremap.c~mm-fix-various-kernel-doc-comments mm/fremap.c
--- a/mm/fremap.c~mm-fix-various-kernel-doc-comments
+++ a/mm/fremap.c
@@ -113,7 +113,7 @@ static int populate_range(struct mm_stru
  * mmap()/mremap() it does not create any new vmas. The new mappings are
  * also safe across swapout.
  *
- * NOTE: the 'prot' parameter right now is ignored (but must be zero),
+ * NOTE: the @prot parameter right now is ignored (but must be zero),
  * and the vma's default protection is used. Arbitrary protections
  * might be implemented in the future.
  */
diff -puN mm/pagewalk.c~mm-fix-various-kernel-doc-comments mm/pagewalk.c
--- a/mm/pagewalk.c~mm-fix-various-kernel-doc-comments
+++ a/mm/pagewalk.c
@@ -77,11 +77,11 @@ static int walk_pud_range(pgd_t *pgd, un
 
 /**
  * walk_page_range - walk a memory map's page tables with a callback
- * @mm - memory map to walk
- * @addr - starting address
- * @end - ending address
- * @walk - set of callbacks to invoke for each level of the tree
- * @private - private data passed to the callback function
+ * @mm: memory map to walk
+ * @addr: starting address
+ * @end: ending address
+ * @walk: set of callbacks to invoke for each level of the tree
+ * @private: private data passed to the callback function
  *
  * Recursively walk the page table for the memory area in a VMA,
  * calling supplied callbacks. Callbacks are called in-order (first
diff -puN mm/slab.c~mm-fix-various-kernel-doc-comments mm/slab.c
--- a/mm/slab.c~mm-fix-various-kernel-doc-comments
+++ a/mm/slab.c
@@ -3624,12 +3624,11 @@ void *kmem_cache_alloc(struct kmem_cache
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 /**
- * kmem_ptr_validate - check if an untrusted pointer might
- *	be a slab entry.
+ * kmem_ptr_validate - check if an untrusted pointer might be a slab entry.
  * @cachep: the cache we're checking against
  * @ptr: pointer to validate
  *
- * This verifies that the untrusted pointer looks sane:
+ * This verifies that the untrusted pointer looks sane;
  * it is _not_ a guarantee that the pointer is actually
  * part of the slab cache in question, but it at least
  * validates that the pointer can be dereferenced and
diff -puN mm/swap.c~mm-fix-various-kernel-doc-comments mm/swap.c
--- a/mm/swap.c~mm-fix-various-kernel-doc-comments
+++ a/mm/swap.c
@@ -78,12 +78,11 @@ void put_page(struct page *page)
 EXPORT_SYMBOL(put_page);
 
 /**
- * put_pages_list(): release a list of pages
+ * put_pages_list() - release a list of pages
+ * @pages: list of pages threaded on page->lru
  *
  * Release a list of pages which are strung together on page.lru.  Currently
  * used by read_cache_pages() and related error recovery code.
- *
- * @pages: list of pages threaded on page->lru
  */
 void put_pages_list(struct list_head *pages)
 {
diff -puN mm/swap_state.c~mm-fix-various-kernel-doc-comments mm/swap_state.c
--- a/mm/swap_state.c~mm-fix-various-kernel-doc-comments
+++ a/mm/swap_state.c
@@ -115,6 +115,7 @@ void __delete_from_swap_cache(struct pag
 /**
  * add_to_swap - allocate swap space for a page
  * @page: page we want to move to swap
+ * @gfp_mask: memory allocation flags
  *
  * Allocate swap space for the page and add the page to the
  * swap cache.  Caller needs to hold the page lock. 
@@ -315,6 +316,7 @@ struct page *read_swap_cache_async(swp_e
 /**
  * swapin_readahead - swap in pages in hope we need them soon
  * @entry: swap entry of this memory
+ * @gfp_mask: memory allocation flags
  * @vma: user vma this address belongs to
  * @addr: target address for mempolicy
  *
diff -puN mm/vmalloc.c~mm-fix-various-kernel-doc-comments mm/vmalloc.c
--- a/mm/vmalloc.c~mm-fix-various-kernel-doc-comments
+++ a/mm/vmalloc.c
@@ -757,7 +757,8 @@ finished:
  *	@vma:		vma to cover (map full range of vma)
  *	@addr:		vmalloc memory
  *	@pgoff:		number of pages into addr before first page to map
- *	@returns:	0 for success, -Exxx on failure
+ *
+ *	Returns:	0 for success, -Exxx on failure
  *
  *	This function checks that addr is a valid vmalloc'ed area, and
  *	that it is big enough to cover the vma. Will return failure if
@@ -829,7 +830,8 @@ static int f(pte_t *pte, pgtable_t table
 /**
  *	alloc_vm_area - allocate a range of kernel address space
  *	@size:		size of the area
- *	@returns:	NULL on failure, vm_struct on success
+ *
+ *	Returns:	NULL on failure, vm_struct on success
  *
  *	This function reserves a range of kernel address space, and
  *	allocates pagetables to map that range.  No actual mappings
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
profile-likely-unlikely-macros.patch

