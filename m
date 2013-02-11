From: akpm@linux-foundation.org
Subject: + mm-accelerate-munlock-treatment-of-thp-pages.patch added to -mm tree
Date: Mon, 11 Feb 2013 15:25:59 -0800
Message-ID: <20130211232600.685A231C1D6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:62937 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128Ab3BKX0C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Feb 2013 18:26:02 -0500
Received: by mail-ob0-f201.google.com with SMTP id un3so1256993obb.4
        for <mm-commits@vger.kernel.org>; Mon, 11 Feb 2013 15:26:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, aarcange@redhat.com, hughd@google.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: mm: accelerate munlock() treatment of THP pages
has been added to the -mm tree.  Its filename is
     mm-accelerate-munlock-treatment-of-thp-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: accelerate munlock() treatment of THP pages

munlock_vma_pages_range() was always incrementing addresses by PAGE_SIZE
at a time.  When munlocking THP pages (or the huge zero page), this
resulted in taking the mm->page_table_lock 512 times in a row.

We can do better by making use of the page_mask returned by
follow_page_mask (for the huge zero page case), or the size of the page
munlock_vma_page() operated on (for the true THP page case).

Note - I am sending this as RFC only for now as I can't currently put my
finger on what if anything prevents split_huge_page() from operating
concurrently on the same page as munlock_vma_page(), which would mess up
our NR_MLOCK statistics.  Is this a latent bug or is there a subtle point
I missed here ?

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/mlock.c    |   34 +++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff -puN mm/internal.h~mm-accelerate-munlock-treatment-of-thp-pages mm/internal.h
--- a/mm/internal.h~mm-accelerate-munlock-treatment-of-thp-pages
+++ a/mm/internal.h
@@ -195,7 +195,7 @@ static inline int mlocked_vma_newpage(st
  * must be called with vma's mmap_sem held for read or write, and page locked.
  */
 extern void mlock_vma_page(struct page *page);
-extern void munlock_vma_page(struct page *page);
+extern unsigned int munlock_vma_page(struct page *page);
 
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
diff -puN mm/mlock.c~mm-accelerate-munlock-treatment-of-thp-pages mm/mlock.c
--- a/mm/mlock.c~mm-accelerate-munlock-treatment-of-thp-pages
+++ a/mm/mlock.c
@@ -102,13 +102,16 @@ void mlock_vma_page(struct page *page)
  * can't isolate the page, we leave it for putback_lru_page() and vmscan
  * [page_referenced()/try_to_unmap()] to deal with.
  */
-void munlock_vma_page(struct page *page)
+unsigned int munlock_vma_page(struct page *page)
 {
+	unsigned int page_mask = 0;
+
 	BUG_ON(!PageLocked(page));
 
 	if (TestClearPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    -hpage_nr_pages(page));
+		unsigned int nr_pages = hpage_nr_pages(page);
+		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
+		page_mask = nr_pages - 1;
 		if (!isolate_lru_page(page)) {
 			int ret = SWAP_AGAIN;
 
@@ -141,6 +144,8 @@ void munlock_vma_page(struct page *page)
 				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
 		}
 	}
+
+	return page_mask;
 }
 
 /**
@@ -159,7 +164,6 @@ long __mlock_vma_pages_range(struct vm_a
 		unsigned long start, unsigned long end, int *nonblocking)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start;
 	unsigned long nr_pages = (end - start) / PAGE_SIZE;
 	int gup_flags;
 
@@ -189,7 +193,7 @@ long __mlock_vma_pages_range(struct vm_a
 	 * We made sure addr is within a VMA, so the following will
 	 * not result in a stack expansion that recurses back here.
 	 */
-	return __get_user_pages(current, mm, addr, nr_pages, gup_flags,
+	return __get_user_pages(current, mm, start, nr_pages, gup_flags,
 				NULL, NULL, nonblocking);
 }
 
@@ -226,13 +230,12 @@ static int __mlock_posix_error_return(lo
 void munlock_vma_pages_range(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end)
 {
-	unsigned long addr;
-
-	lru_add_drain();
 	vma->vm_flags &= ~VM_LOCKED;
 
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
+	while (start < end) {
 		struct page *page;
+		unsigned int page_mask, page_increm;
+
 		/*
 		 * Although FOLL_DUMP is intended for get_dump_page(),
 		 * it just so happens that its special treatment of the
@@ -240,13 +243,22 @@ void munlock_vma_pages_range(struct vm_a
 		 * suits munlock very well (and if somehow an abnormal page
 		 * has sneaked into the range, we won't oops here: great).
 		 */
-		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
+		page = follow_page_mask(vma, start, FOLL_GET | FOLL_DUMP,
+					&page_mask);
 		if (page && !IS_ERR(page)) {
 			lock_page(page);
-			munlock_vma_page(page);
+			lru_add_drain();
+			/*
+			 * Any THP page found by follow_page_mask() may have
+			 * gotten split before reaching munlock_vma_page(),
+			 * so we need to recompute the page_mask here.
+			 */
+			page_mask = munlock_vma_page(page);
 			unlock_page(page);
 			put_page(page);
 		}
+		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
+		start += page_increm * PAGE_SIZE;
 		cond_resched();
 	}
 }
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mm-remove-free_area_cache.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mm-use-vm_unmapped_area-on-alpha-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

