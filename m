From: akpm@linux-foundation.org
Subject: [merged]
 mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch removed from
 -mm tree
Date: Fri, 03 Jan 2014 12:37:54 -0800
Message-ID: <52c71fa2.Y7SalQJZLiZcxXNo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaACUhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 15:37:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, stable@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, mgorman@suse.de, hughd@google.com, bob.liu@oracle.com, aarcange@redhat.com, vbabka@suse.cz

Subject: [merged] mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch removed from -mm tree
To: vbabka@suse.cz,aarcange@redhat.com,bob.liu@oracle.com,hughd@google.com,mgorman@suse.de,riel@redhat.com,sasha.levin@oracle.com,stable@vger.kernel.org,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 12:37:54 -0800


The patch titled
     Subject: mm: munlock: fix a bug where THP tail page is encountered
has been removed from the -mm tree.  Its filename was
     mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: munlock: fix a bug where THP tail page is encountered

Since ff6a6da60 ("mm: accelerate munlock() treatment of THP pages")
munlock skips tail pages of a munlocked THP page.  However, when the head
page already has PageMlocked unset, it will not skip the tail pages.

Commit 7225522bb ("mm: munlock: batch non-THP page isolation and
munlock+putback using pagevec") has added a PageTransHuge() check which
contains VM_BUG_ON(PageTail(page)).  Sasha Levin found this triggered
using trinity, on the first tail page of a THP page without PageMlocked
flag.

This patch fixes the issue by skipping tail pages also in the case when
PageMlocked flag is unset.  There is still a possibility of race with THP
page split between clearing PageMlocked and determining how many pages to
skip.  The race might result in former tail pages not being skipped, which
is however no longer a bug, as during the skip the PageTail flags are
cleared.

However this race also affects correctness of NR_MLOCK accounting, which
is to be fixed in a separate patch.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff -puN mm/mlock.c~mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered mm/mlock.c
--- a/mm/mlock.c~mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered
+++ a/mm/mlock.c
@@ -133,7 +133,10 @@ static void __munlock_isolation_failed(s
 
 /**
  * munlock_vma_page - munlock a vma page
- * @page - page to be unlocked
+ * @page - page to be unlocked, either a normal page or THP page head
+ *
+ * returns the size of the page as a page mask (0 for normal page,
+ *         HPAGE_PMD_NR - 1 for THP head page)
  *
  * called from munlock()/munmap() path with page supposedly on the LRU.
  * When we munlock a page, because the vma where we found the page is being
@@ -148,21 +151,30 @@ static void __munlock_isolation_failed(s
  */
 unsigned int munlock_vma_page(struct page *page)
 {
-	unsigned int page_mask = 0;
+	unsigned int nr_pages;
 
 	BUG_ON(!PageLocked(page));
 
 	if (TestClearPageMlocked(page)) {
-		unsigned int nr_pages = hpage_nr_pages(page);
+		nr_pages = hpage_nr_pages(page);
 		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
-		page_mask = nr_pages - 1;
 		if (!isolate_lru_page(page))
 			__munlock_isolated_page(page);
 		else
 			__munlock_isolation_failed(page);
+	} else {
+		nr_pages = hpage_nr_pages(page);
 	}
 
-	return page_mask;
+	/*
+	 * Regardless of the original PageMlocked flag, we determine nr_pages
+	 * after touching the flag. This leaves a possible race with a THP page
+	 * split, such that a whole THP page was munlocked, but nr_pages == 1.
+	 * Returning a smaller mask due to that is OK, the worst that can
+	 * happen is subsequent useless scanning of the former tail pages.
+	 * The NR_MLOCK accounting can however become broken.
+	 */
+	return nr_pages - 1;
 }
 
 /**
@@ -440,7 +452,8 @@ void munlock_vma_pages_range(struct vm_a
 
 	while (start < end) {
 		struct page *page = NULL;
-		unsigned int page_mask, page_increm;
+		unsigned int page_mask;
+		unsigned long page_increm;
 		struct pagevec pvec;
 		struct zone *zone;
 		int zoneid;
@@ -490,7 +503,9 @@ void munlock_vma_pages_range(struct vm_a
 				goto next;
 			}
 		}
-		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
+		/* It's a bug to munlock in the middle of a THP page */
+		VM_BUG_ON((start >> PAGE_SHIFT) & page_mask);
+		page_increm = 1 + page_mask;
 		start += page_increm * PAGE_SIZE;
 next:
 		cond_resched();
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
mm-documentation-remove-hopelessly-out-of-date-locking-doc.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-remove-bug_on-from-mlock_vma_page.patch
linux-next.patch

