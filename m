From: akpm@linux-foundation.org
Subject: [merged] mm-add-foll_mlock-follow_page-flag.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:30 -0800
Message-ID: <201101142248.p0EMmK1G005191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1ANWss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com, tglx@


The patch titled
     mm: add FOLL_MLOCK follow_page flag.
has been removed from the -mm tree.  Its filename was
     mm-add-foll_mlock-follow_page-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add FOLL_MLOCK follow_page flag.
From: Michel Lespinasse <walken@google.com>

Move the code to mlock pages from __mlock_vma_pages_range() to
follow_page().

This allows __mlock_vma_pages_range() to not have to break down work into
16-page batches.

An additional motivation for doing this within the present patch series is
that it'll make it easier for a later chagne to drop mmap_sem when
blocking on disk (we'd like to be able to resume at the page that was read
from disk instead of at the start of a 16-page batch).

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/memory.c        |   22 ++++++++++++++
 mm/mlock.c         |   65 +++----------------------------------------
 3 files changed, 28 insertions(+), 60 deletions(-)

diff -puN include/linux/mm.h~mm-add-foll_mlock-follow_page-flag include/linux/mm.h
--- a/include/linux/mm.h~mm-add-foll_mlock-follow_page-flag
+++ a/include/linux/mm.h
@@ -1415,6 +1415,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
+#define FOLL_MLOCK	0x40	/* mark page as mlocked */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN mm/memory.c~mm-add-foll_mlock-follow_page-flag mm/memory.c
--- a/mm/memory.c~mm-add-foll_mlock-follow_page-flag
+++ a/mm/memory.c
@@ -1310,6 +1310,28 @@ struct page *follow_page(struct vm_area_
 		 */
 		mark_page_accessed(page);
 	}
+	if (flags & FOLL_MLOCK) {
+		/*
+		 * The preliminary mapping check is mainly to avoid the
+		 * pointless overhead of lock_page on the ZERO_PAGE
+		 * which might bounce very badly if there is contention.
+		 *
+		 * If the page is already locked, we don't need to
+		 * handle it now - vmscan will handle it later if and
+		 * when it attempts to reclaim the page.
+		 */
+		if (page->mapping && trylock_page(page)) {
+			lru_add_drain();  /* push cached pages to LRU */
+			/*
+			 * Because we lock page here and migration is
+			 * blocked by the pte's page reference, we need
+			 * only check for file-cache page truncation.
+			 */
+			if (page->mapping)
+				mlock_vma_page(page);
+			unlock_page(page);
+		}
+	}
 unlock:
 	pte_unmap_unlock(ptep, ptl);
 out:
diff -puN mm/mlock.c~mm-add-foll_mlock-follow_page-flag mm/mlock.c
--- a/mm/mlock.c~mm-add-foll_mlock-follow_page-flag
+++ a/mm/mlock.c
@@ -159,10 +159,9 @@ static long __mlock_vma_pages_range(stru
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start;
-	struct page *pages[16]; /* 16 gives a reasonable batch */
 	int nr_pages = (end - start) / PAGE_SIZE;
-	int ret = 0;
 	int gup_flags;
+	int ret;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
 	VM_BUG_ON(end   & ~PAGE_MASK);
@@ -170,7 +169,7 @@ static long __mlock_vma_pages_range(stru
 	VM_BUG_ON(end   > vma->vm_end);
 	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
-	gup_flags = FOLL_TOUCH | FOLL_GET;
+	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
@@ -185,63 +184,9 @@ static long __mlock_vma_pages_range(stru
 		nr_pages--;
 	}
 
-	while (nr_pages > 0) {
-		int i;
-
-		cond_resched();
-
-		/*
-		 * get_user_pages makes pages present if we are
-		 * setting mlock. and this extra reference count will
-		 * disable migration of this page.  However, page may
-		 * still be truncated out from under us.
-		 */
-		ret = __get_user_pages(current, mm, addr,
-				min_t(int, nr_pages, ARRAY_SIZE(pages)),
-				gup_flags, pages, NULL);
-		/*
-		 * This can happen for, e.g., VM_NONLINEAR regions before
-		 * a page has been allocated and mapped at a given offset,
-		 * or for addresses that map beyond end of a file.
-		 * We'll mlock the pages if/when they get faulted in.
-		 */
-		if (ret < 0)
-			break;
-
-		lru_add_drain();	/* push cached pages to LRU */
-
-		for (i = 0; i < ret; i++) {
-			struct page *page = pages[i];
-
-			if (page->mapping) {
-				/*
-				 * That preliminary check is mainly to avoid
-				 * the pointless overhead of lock_page on the
-				 * ZERO_PAGE: which might bounce very badly if
-				 * there is contention.  However, we're still
-				 * dirtying its cacheline with get/put_page:
-				 * we'll add another __get_user_pages flag to
-				 * avoid it if that case turns out to matter.
-				 */
-				lock_page(page);
-				/*
-				 * Because we lock page here and migration is
-				 * blocked by the elevated reference, we need
-				 * only check for file-cache page truncation.
-				 */
-				if (page->mapping)
-					mlock_vma_page(page);
-				unlock_page(page);
-			}
-			put_page(page);	/* ref from get_user_pages() */
-		}
-
-		addr += ret * PAGE_SIZE;
-		nr_pages -= ret;
-		ret = 0;
-	}
