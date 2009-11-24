From: akpm@linux-foundation.org
Subject: + ksm-fix-mlockfreed-to-munlocked.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:35:19 -0800
Message-ID: <200911241935.nAOJZJPR027711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758135AbZKXTfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:35:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com, ieidus@redhat.com


The patch titled
     ksm: fix mlockfreed to munlocked
has been added to the -mm tree.  Its filename is
     ksm-fix-mlockfreed-to-munlocked.patch

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
Subject: ksm: fix mlockfreed to munlocked
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

When KSM merges an mlocked page, it has been forgetting to munlock it:
that's been left to free_page_mlock(), which reports it in /proc/vmstat as
unevictable_pgs_mlockfreed instead of unevictable_pgs_munlocked (and
whinges "Page flag mlocked set for process" in mmotm, whereas mainline is
silently forgiving).  Call munlock_vma_page() to fix that.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 ++-
 mm/ksm.c      |    4 ++++
 mm/mlock.c    |    4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/internal.h~ksm-fix-mlockfreed-to-munlocked mm/internal.h
--- a/mm/internal.h~ksm-fix-mlockfreed-to-munlocked
+++ a/mm/internal.h
@@ -105,9 +105,10 @@ static inline int is_mlocked_vma(struct 
 }
 
 /*
- * must be called with vma's mmap_sem held for read, and page locked.
+ * must be called with vma's mmap_sem held for read or write, and page locked.
  */
 extern void mlock_vma_page(struct page *page);
+extern void munlock_vma_page(struct page *page);
 
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
diff -puN mm/ksm.c~ksm-fix-mlockfreed-to-munlocked mm/ksm.c
--- a/mm/ksm.c~ksm-fix-mlockfreed-to-munlocked
+++ a/mm/ksm.c
@@ -34,6 +34,7 @@
 #include <linux/ksm.h>
 
 #include <asm/tlbflush.h>
+#include "internal.h"
 
 /*
  * A few notes about the KSM scanning process,
@@ -762,6 +763,9 @@ static int try_to_merge_one_page(struct 
 	    pages_identical(page, kpage))
 		err = replace_page(vma, page, kpage, orig_pte);
 
+	if ((vma->vm_flags & VM_LOCKED) && !err)
+		munlock_vma_page(page);
+
 	unlock_page(page);
 out:
 	return err;
diff -puN mm/mlock.c~ksm-fix-mlockfreed-to-munlocked mm/mlock.c
--- a/mm/mlock.c~ksm-fix-mlockfreed-to-munlocked
+++ a/mm/mlock.c
@@ -99,14 +99,14 @@ void mlock_vma_page(struct page *page)
  * not get another chance to clear PageMlocked.  If we successfully
  * isolate the page and try_to_munlock() detects other VM_LOCKED vmas
  * mapping the page, it will restore the PageMlocked state, unless the page
- * is mapped in a non-linear vma.  So, we go ahead and SetPageMlocked(),
+ * is mapped in a non-linear vma.  So, we go ahead and ClearPageMlocked(),
  * perhaps redundantly.
  * If we lose the isolation race, and the page is mapped by other VM_LOCKED
  * vmas, we'll detect this in vmscan--via try_to_munlock() or try_to_unmap()
  * either of which will restore the PageMlocked state by calling
  * mlock_vma_page() above, if it can grab the vma's mmap sem.
  */
-static void munlock_vma_page(struct page *page)
+void munlock_vma_page(struct page *page)
 {
 	BUG_ON(!PageLocked(page));
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
ksm-three-remove_rmap_item_from_tree-cleanups.patch
ksm-remove-redundancies-when-merging-page.patch
ksm-cleanup-some-function-arguments.patch
ksm-singly-linked-rmap_list.patch
ksm-separate-stable_node.patch
ksm-stable_node-point-to-page-and-back.patch
ksm-fix-mlockfreed-to-munlocked.patch
ksm-let-shared-pages-be-swappable.patch
ksm-hold-anon_vma-in-rmap_item.patch
ksm-take-keyhole-reference-to-page.patch
ksm-share-anon-page-without-allocating.patch
ksm-mem-cgroup-charge-swapin-copy.patch
ksm-rmap_walk-to-remove_migation_ptes.patch
ksm-memory-hotremove-migration-only.patch
ksm-remove-unswappable-max_kernel_pages.patch
hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch
mm-simplify-try_to_unmap_one.patch
mm-simplify-try_to_unmap_one-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

