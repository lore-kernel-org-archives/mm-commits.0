From: akpm@linux-foundation.org
Subject: + mm-clear_page_mlock-in-page_remove_rmap.patch added to -mm tree
Date: Wed, 19 Sep 2012 15:02:07 -0700
Message-ID: <20120919220207.E01D65C0080@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:46237 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2ISWCL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 18:02:11 -0400
Received: by faet1 with SMTP id t1so91057fae.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 15:02:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, mel@csn.ul.ie, riel@redhat.com, walken@google.com, yinghan@google.com


The patch titled
     Subject: mm: clear_page_mlock in page_remove_rmap
has been added to the -mm tree.  Its filename is
     mm-clear_page_mlock-in-page_remove_rmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: clear_page_mlock in page_remove_rmap

We had thought that pages could no longer get freed while still marked as
mlocked; but Johannes Weiner posted this program to demonstrate that
truncating an mlocked private file mapping containing COWed pages is still
mishandled:

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

int main(void)
{
	char *map;
	int fd;

	system("grep mlockfreed /proc/vmstat");
	fd = open("chigurh", O_CREAT|O_EXCL|O_RDWR);
	unlink("chigurh");
	ftruncate(fd, 4096);
	map = mmap(NULL, 4096, PROT_WRITE, MAP_PRIVATE, fd, 0);
	map[0] = 11;
	mlock(map, sizeof(fd));
	ftruncate(fd, 0);
	close(fd);
	munlock(map, sizeof(fd));
	munmap(map, 4096);
	system("grep mlockfreed /proc/vmstat");
	return 0;
}

The anon COWed pages are not caught by truncation's clear_page_mlock() of
the pagecache pages; but unmap_mapping_range() unmaps them, so we ought to
look out for them there in page_remove_rmap().  Indeed, why should
truncation or invalidation be doing the clear_page_mlock() when removing
from pagecache?  mlock is a property of mapping in userspace, not a
properthihughy of pagecache: an mlocked unmapped page is nonsensical.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    7 +------
 mm/memory.c   |   10 +++++-----
 mm/mlock.c    |   16 +++-------------
 mm/rmap.c     |    4 ++++
 mm/truncate.c |    4 ----
 5 files changed, 13 insertions(+), 28 deletions(-)

diff -puN mm/internal.h~mm-clear_page_mlock-in-page_remove_rmap mm/internal.h
--- a/mm/internal.h~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/internal.h
@@ -202,12 +202,7 @@ extern void munlock_vma_page(struct page
  * If called for a page that is still mapped by mlocked vmas, all we do
  * is revert to lazy LRU behaviour -- semantics are not broken.
  */
-extern void __clear_page_mlock(struct page *page);
-static inline void clear_page_mlock(struct page *page)
-{
-	if (unlikely(TestClearPageMlocked(page)))
-		__clear_page_mlock(page);
-}
+extern void clear_page_mlock(struct page *page);
 
 /*
  * mlock_migrate_page - called only from migrate_page_copy() to
diff -puN mm/memory.c~mm-clear_page_mlock-in-page_remove_rmap mm/memory.c
--- a/mm/memory.c~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/memory.c
@@ -1577,12 +1577,12 @@ split_fallthrough:
 		if (page->mapping && trylock_page(page)) {
 			lru_add_drain();  /* push cached pages to LRU */
 			/*
-			 * Because we lock page here and migration is
-			 * blocked by the pte's page reference, we need
-			 * only check for file-cache page truncation.
+			 * Because we lock page here, and migration is
+			 * blocked by the pte's page reference, and we
+			 * know the page is still mapped, we don't even
+			 * need to check for file-cache page truncation.
 			 */
-			if (page->mapping)
-				mlock_vma_page(page);
+			mlock_vma_page(page);
 			unlock_page(page);
 		}
 	}
diff -puN mm/mlock.c~mm-clear_page_mlock-in-page_remove_rmap mm/mlock.c
--- a/mm/mlock.c~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/mlock.c
@@ -51,13 +51,10 @@ EXPORT_SYMBOL(can_do_mlock);
 /*
  *  LRU accounting for clear_page_mlock()
  */
-void __clear_page_mlock(struct page *page)
+void clear_page_mlock(struct page *page)
 {
-	VM_BUG_ON(!PageLocked(page));
-
-	if (!page->mapping) {	/* truncated ? */
+	if (!TestClearPageMlocked(page))
 		return;
-	}
 
 	dec_zone_page_state(page, NR_MLOCK);
 	count_vm_event(UNEVICTABLE_PGCLEARED);
@@ -290,14 +287,7 @@ void munlock_vma_pages_range(struct vm_a
 		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 		if (page && !IS_ERR(page)) {
 			lock_page(page);
-			/*
-			 * Like in __mlock_vma_pages_range(),
-			 * because we lock page here and migration is
-			 * blocked by the elevated reference, we need
-			 * only check for file-cache page truncation.
-			 */
-			if (page->mapping)
-				munlock_vma_page(page);
+			munlock_vma_page(page);
 			unlock_page(page);
 			put_page(page);
 		}
diff -puN mm/rmap.c~mm-clear_page_mlock-in-page_remove_rmap mm/rmap.c
--- a/mm/rmap.c~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/rmap.c
@@ -1158,7 +1158,10 @@ void page_remove_rmap(struct page *page)
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_MAPPED);
+		mem_cgroup_end_update_page_stat(page, &locked, &flags);
 	}
+	if (unlikely(PageMlocked(page)))
+		clear_page_mlock(page);
 	/*
 	 * It would be tidy to reset the PageAnon mapping here,
 	 * but that might overwrite a racing page_add_anon_rmap
@@ -1168,6 +1171,7 @@ void page_remove_rmap(struct page *page)
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
 	 */
+	return;
 out:
 	if (!anon)
 		mem_cgroup_end_update_page_stat(page, &locked, &flags);
diff -puN mm/truncate.c~mm-clear_page_mlock-in-page_remove_rmap mm/truncate.c
--- a/mm/truncate.c~mm-clear_page_mlock-in-page_remove_rmap
+++ a/mm/truncate.c
@@ -107,7 +107,6 @@ truncate_complete_page(struct address_sp
 
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
-	clear_page_mlock(page);
 	ClearPageMappedToDisk(page);
 	delete_from_page_cache(page);
 	return 0;
@@ -132,7 +131,6 @@ invalidate_complete_page(struct address_
 	if (page_has_private(page) && !try_to_release_page(page, 0))
 		return 0;
 
-	clear_page_mlock(page);
 	ret = remove_mapping(mapping, page);
 
 	return ret;
@@ -394,8 +392,6 @@ invalidate_complete_page2(struct address
 	if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
-	clear_page_mlock(page);
-
 	spin_lock_irq(&mapping->tree_lock);
 	if (PageDirty(page))
 		goto failed;
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-remove-vma-arg-from-page_evictable.patch
mm-clear_page_mlock-in-page_remove_rmap.patch
mm-remove-free_page_mlock.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch

