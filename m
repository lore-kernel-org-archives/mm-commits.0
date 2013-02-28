From: akpm@linux-foundation.org
Subject: [merged] mm-accelerate-munlock-treatment-of-thp-pages.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:35 -0800
Message-ID: <20130228201035.B4B7B31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40914 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3B1UKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:37 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so244748ggi.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, aarcange@redhat.com, hughd@google.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: accelerate munlock() treatment of THP pages
has been removed from the -mm tree.  Its filename was
     mm-accelerate-munlock-treatment-of-thp-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: accelerate munlock() treatment of THP pages

munlock_vma_pages_range() was always incrementing addresses by PAGE_SIZE
at a time.  When munlocking THP pages (or the huge zero page), this
resulted in taking the mm->page_table_lock 512 times in a row.

We can do better by making use of the page_mask returned by
follow_page_mask (for the huge zero page case), or the size of the page
munlock_vma_page() operated on (for the true THP page case).

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

origin.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-remove-free_area_cache.patch
mutex-subsystem-synchro-test-module.patch

