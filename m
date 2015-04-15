From: akpm@linux-foundation.org
Subject: [merged]
 mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch removed
 from -mm tree
Date: Wed, 15 Apr 2015 12:09:08 -0700
Message-ID: <552eb754.EICuDgEofQ9U5xGp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668AbbDOTJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, riel@redhat.com, rientjes@google.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename __mlock_vma_pages_range() to populate_vma_page_range()
has been removed from the -mm tree.  Its filename was
     mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: rename __mlock_vma_pages_range() to populate_vma_page_range()

__mlock_vma_pages_range() doesn't necessarily mlock pages.  It depends on
vma flags.  The same codepath is used for MAP_POPULATE.

Let's rename __mlock_vma_pages_range() to populate_vma_page_range().

This patch also drops mlock_vma_pages_range() references from
documentation.  It has gone in cea10a19b797 ("mm: directly use
__mlock_vma_pages_range() in find_extend_vma()").

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |   24 +++++++-----------------
 mm/internal.h                        |    2 +-
 mm/mlock.c                           |   12 ++++++------
 mm/mmap.c                            |    4 ++--
 4 files changed, 16 insertions(+), 26 deletions(-)

diff -puN Documentation/vm/unevictable-lru.txt~mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range
+++ a/Documentation/vm/unevictable-lru.txt
@@ -317,7 +317,7 @@ If the VMA passes some filtering as desc
 below, mlock_fixup() will attempt to merge the VMA with its neighbors or split
 off a subset of the VMA if the range does not cover the entire VMA.  Once the
 VMA has been merged or split or neither, mlock_fixup() will call
-__mlock_vma_pages_range() to fault in the pages via get_user_pages() and to
+populate_vma_page_range() to fault in the pages via get_user_pages() and to
 mark the pages as mlocked via mlock_vma_page().
 
 Note that the VMA being mlocked might be mapped with PROT_NONE.  In this case,
@@ -327,7 +327,7 @@ fault path or in vmscan.
 
 Also note that a page returned by get_user_pages() could be truncated or
 migrated out from under us, while we're trying to mlock it.  To detect this,
-__mlock_vma_pages_range() checks page_mapping() after acquiring the page lock.
+populate_vma_page_range() checks page_mapping() after acquiring the page lock.
 If the page is still associated with its mapping, we'll go ahead and call
 mlock_vma_page().  If the mapping is gone, we just unlock the page and move on.
 In the worst case, this will result in a page mapped in a VM_LOCKED VMA
@@ -392,7 +392,7 @@ ignored for munlock.
 
 If the VMA is VM_LOCKED, mlock_fixup() again attempts to merge or split off the
 specified range.  The range is then munlocked via the function
-__mlock_vma_pages_range() - the same function used to mlock a VMA range -
+populate_vma_page_range() - the same function used to mlock a VMA range -
 passing a flag to indicate that munlock() is being performed.
 
 Because the VMA access protections could have been changed to PROT_NONE after
@@ -402,7 +402,7 @@ get_user_pages() was enhanced to accept
 fetching the pages - all of which should be resident as a result of previous
 mlocking.
 
-For munlock(), __mlock_vma_pages_range() unlocks individual pages by calling
+For munlock(), populate_vma_page_range() unlocks individual pages by calling
 munlock_vma_page().  munlock_vma_page() unconditionally clears the PG_mlocked
 flag using TestClearPageMlocked().  As with mlock_vma_page(),
 munlock_vma_page() use the Test*PageMlocked() function to handle the case where
@@ -463,21 +463,11 @@ populate the page table.
 
 To mlock a range of memory under the unevictable/mlock infrastructure, the
 mmap() handler and task address space expansion functions call
-mlock_vma_pages_range() specifying the vma and the address range to mlock.
-mlock_vma_pages_range() filters VMAs like mlock_fixup(), as described above in
-"Filtering Special VMAs".  It will clear the VM_LOCKED flag, which will have
-already been set by the caller, in filtered VMAs.  Thus these VMA's need not be
-visited for munlock when the region is unmapped.
-
-For "normal" VMAs, mlock_vma_pages_range() calls __mlock_vma_pages_range() to
-fault/allocate the pages and mlock them.  Again, like mlock_fixup(),
-mlock_vma_pages_range() downgrades the mmap semaphore to read mode before
-attempting to fault/allocate and mlock the pages and "upgrades" the semaphore
-back to write mode before returning.
+populate_vma_page_range() specifying the vma and the address range to mlock.
 
-The callers of mlock_vma_pages_range() will have already added the memory range
+The callers of populate_vma_page_range() will have already added the memory range
 to be mlocked to the task's "locked_vm".  To account for filtered VMAs,
-mlock_vma_pages_range() returns the number of pages NOT mlocked.  All of the
+populate_vma_page_range() returns the number of pages NOT mlocked.  All of the
 callers then subtract a non-negative return value from the task's locked_vm.  A
 negative return value represent an error - for example, from get_user_pages()
 attempting to fault in a VMA with PROT_NONE access.  In this case, we leave the
diff -puN mm/internal.h~mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range mm/internal.h
--- a/mm/internal.h~mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range
+++ a/mm/internal.h
@@ -240,7 +240,7 @@ void __vma_link_list(struct mm_struct *m
 		struct vm_area_struct *prev, struct rb_node *rb_parent);
 
 #ifdef CONFIG_MMU
-extern long __mlock_vma_pages_range(struct vm_area_struct *vma,
+extern long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *nonblocking);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
diff -puN mm/mlock.c~mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range mm/mlock.c
--- a/mm/mlock.c~mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range
+++ a/mm/mlock.c
@@ -206,13 +206,13 @@ out:
 }
 
 /**
- * __mlock_vma_pages_range() -  mlock a range of pages in the vma.
+ * populate_vma_page_range() -  populate a range of pages in the vma.
  * @vma:   target vma
  * @start: start address
  * @end:   end address
  * @nonblocking:
  *
- * This takes care of making the pages present too.
+ * This takes care of mlocking the pages too if VM_LOCKED is set.
  *
  * return 0 on success, negative error code on error.
  *
@@ -224,7 +224,7 @@ out:
  * If @nonblocking is non-NULL, it must held for read only and may be
  * released.  If it's released, *@nonblocking will be set to 0.
  */
-long __mlock_vma_pages_range(struct vm_area_struct *vma,
+long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *nonblocking)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -596,7 +596,7 @@ success:
 	/*
 	 * vm_flags is protected by the mmap_sem held in write mode.
 	 * It's okay if try_to_unmap_one unmaps a page just after we
-	 * set VM_LOCKED, __mlock_vma_pages_range will bring it back.
+	 * set VM_LOCKED, populate_vma_page_range will bring it back.
 	 */
 
 	if (lock)
@@ -702,11 +702,11 @@ int __mm_populate(unsigned long start, u
 		if (nstart < vma->vm_start)
 			nstart = vma->vm_start;
 		/*
-		 * Now fault in a range of pages. __mlock_vma_pages_range()
+		 * Now fault in a range of pages. populate_vma_page_range()
 		 * double checks the vma flags, so that it won't mlock pages
 		 * if the vma was already munlocked.
 		 */
-		ret = __mlock_vma_pages_range(vma, nstart, nend, &locked);
+		ret = populate_vma_page_range(vma, nstart, nend, &locked);
 		if (ret < 0) {
 			if (ignore_errors) {
 				ret = 0;
diff -puN mm/mmap.c~mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range mm/mmap.c
--- a/mm/mmap.c~mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range
+++ a/mm/mmap.c
@@ -2316,7 +2316,7 @@ find_extend_vma(struct mm_struct *mm, un
 	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED)
-		__mlock_vma_pages_range(prev, addr, prev->vm_end, NULL);
+		populate_vma_page_range(prev, addr, prev->vm_end, NULL);
 	return prev;
 }
 #else
@@ -2351,7 +2351,7 @@ find_extend_vma(struct mm_struct *mm, un
 	if (expand_stack(vma, addr))
 		return NULL;
 	if (vma->vm_flags & VM_LOCKED)
-		__mlock_vma_pages_range(vma, addr, start, NULL);
+		populate_vma_page_range(vma, addr, start, NULL);
 	return vma;
 }
 #endif
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
mm-migrate-check-before-clear-pageswapcache.patch
mm-page-writeback-check-before-clear-pagereclaim.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-sanitize-page-mapping-for-tail-pages-v2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
thp-cleanup-khugepaged-startup.patch
mmv41-new-pfn_mkwrite-same-as-page_mkwrite-for-vm_pfnmap.patch
dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection.patch
dax-unify-ext2-4_dax_file_operations.patch
linux-next.patch

