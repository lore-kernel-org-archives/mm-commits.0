From: akpm@linux-foundation.org
Subject: [merged] mm-rename-foll_mlock-to-foll_populate.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:09:06 -0700
Message-ID: <552eb752.elPL+bH3SI3USBY8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbbDOTJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, riel@redhat.com, rientjes@google.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename FOLL_MLOCK to FOLL_POPULATE
has been removed from the -mm tree.  Its filename was
     mm-rename-foll_mlock-to-foll_populate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: rename FOLL_MLOCK to FOLL_POPULATE

After a1fde08c74e9 ("VM: skip the stack guard page lookup in
get_user_pages only for mlock") FOLL_MLOCK has lost its original meaning:
we don't necessarily mlock the page if the flags is set -- we also take
VM_LOCKED into consideration.

Since we use the same codepath for __mm_populate(), let's rename
FOLL_MLOCK to FOLL_POPULATE.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/gup.c           |    6 +++---
 mm/huge_memory.c   |    2 +-
 mm/mlock.c         |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~mm-rename-foll_mlock-to-foll_populate include/linux/mm.h
--- a/include/linux/mm.h~mm-rename-foll_mlock-to-foll_populate
+++ a/include/linux/mm.h
@@ -2109,7 +2109,7 @@ static inline struct page *follow_page(s
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 #define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
 				 * and return without waiting upon it */
-#define FOLL_MLOCK	0x40	/* mark page as mlocked */
+#define FOLL_POPULATE	0x40	/* fault in page */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
diff -puN mm/gup.c~mm-rename-foll_mlock-to-foll_populate mm/gup.c
--- a/mm/gup.c~mm-rename-foll_mlock-to-foll_populate
+++ a/mm/gup.c
@@ -92,7 +92,7 @@ retry:
 		 */
 		mark_page_accessed(page);
 	}
-	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
+	if ((flags & FOLL_POPULATE) && (vma->vm_flags & VM_LOCKED)) {
 		/*
 		 * The preliminary mapping check is mainly to avoid the
 		 * pointless overhead of lock_page on the ZERO_PAGE
@@ -265,8 +265,8 @@ static int faultin_page(struct task_stru
 	unsigned int fault_flags = 0;
 	int ret;
 
-	/* For mlock, just skip the stack guard page. */
-	if ((*flags & FOLL_MLOCK) &&
+	/* For mm_populate(), just skip the stack guard page. */
+	if ((*flags & FOLL_POPULATE) &&
 			(stack_guard_page_start(vma, address) ||
 			 stack_guard_page_end(vma, address + PAGE_SIZE)))
 		return -ENOENT;
diff -puN mm/huge_memory.c~mm-rename-foll_mlock-to-foll_populate mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rename-foll_mlock-to-foll_populate
+++ a/mm/huge_memory.c
@@ -1231,7 +1231,7 @@ struct page *follow_trans_huge_pmd(struc
 					  pmd, _pmd,  1))
 			update_mmu_cache_pmd(vma, addr, pmd);
 	}
-	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
+	if ((flags & FOLL_POPULATE) && (vma->vm_flags & VM_LOCKED)) {
 		if (page->mapping && trylock_page(page)) {
 			lru_add_drain();
 			if (page->mapping)
diff -puN mm/mlock.c~mm-rename-foll_mlock-to-foll_populate mm/mlock.c
--- a/mm/mlock.c~mm-rename-foll_mlock-to-foll_populate
+++ a/mm/mlock.c
@@ -237,7 +237,7 @@ long __mlock_vma_pages_range(struct vm_a
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
 
-	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
+	gup_flags = FOLL_TOUCH | FOLL_POPULATE;
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
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

