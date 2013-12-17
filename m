From: akpm@linux-foundation.org
Subject: + mm-munlock-fix-potential-race-with-thp-page-split.patch added
 to -mm tree
Date: Mon, 16 Dec 2013 16:34:39 -0800
Message-ID: <52af9c1f.+tT2c4IsJYkfkA7G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3LQAek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 19:34:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, stable@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, mgorman@suse.de, hughd@google.com, aarcange@redhat.com, vbabka@suse.cz

Subject: + mm-munlock-fix-potential-race-with-thp-page-split.patch added to -mm tree
To: vbabka@suse.cz,aarcange@redhat.com,hughd@google.com,mgorman@suse.de,riel@redhat.com,sasha.levin@oracle.com,stable@vger.kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 16:34:39 -0800


The patch titled
     Subject: mm: munlock: fix potential race with THP page split
has been added to the -mm tree.  Its filename is
     mm-munlock-fix-potential-race-with-thp-page-split.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-fix-potential-race-with-thp-page-split.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-fix-potential-race-with-thp-page-split.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: munlock: fix potential race with THP page split

Since commit ff6a6da60 ("mm: accelerate munlock() treatment of THP pages")
munlock skips tail pages of a munlocked THP page.  There is some attempt
to prevent bad consequences of racing with a THP page split, but code
inspection indicates that there are two problems that may lead to a
non-fatal, yet wrong outcome.

First, __split_huge_page_refcount() copies flags including PageMlocked
from the head page to the tail pages.  Clearing PageMlocked by
munlock_vma_page() in the middle of this operation might result in part of
tail pages left with PageMlocked flag.  As the head page still appears to
be a THP page until all tail pages are processed, munlock_vma_page() might
think it munlocked the whole THP page and skip all the former tail pages. 
Before ff6a6da60, those pages would be cleared in further iterations of
munlock_vma_pages_range(), but NR_MLOCK would still become undercounted
(related the next point).

Second, NR_MLOCK accounting is based on call to hpage_nr_pages() after the
PageMlocked is cleared.  The accounting might also become inconsistent due
to race with __split_huge_page_refcount()

- undercount when HUGE_PMD_NR is subtracted, but some tail pages are
  left with PageMlocked set and counted again (only possible before
  ff6a6da60)

- overcount when hpage_nr_pages() sees a normal page (split has already
  finished), but the parallel split has meanwhile cleared PageMlocked from
  additional tail pages

This patch prevents both problems via extending the scope of lru_lock in
munlock_vma_page().  This is convenient because:

- __split_huge_page_refcount() takes lru_lock for its whole operation

- munlock_vma_page() typically takes lru_lock anyway for page isolation

As this becomes a second function where page isolation is done with
lru_lock already held, factor this out to a new
__munlock_isolate_lru_page() function and clean up the code around.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |  104 +++++++++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 44 deletions(-)

diff -puN mm/mlock.c~mm-munlock-fix-potential-race-with-thp-page-split mm/mlock.c
--- a/mm/mlock.c~mm-munlock-fix-potential-race-with-thp-page-split
+++ a/mm/mlock.c
@@ -91,6 +91,26 @@ void mlock_vma_page(struct page *page)
 }
 
 /*
+ * Isolate a page from LRU with optional get_page() pin.
+ * Assumes lru_lock already held and page already pinned.
+ */
+static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
+{
+	if (PageLRU(page)) {
+		struct lruvec *lruvec = mem_cgroup_page_lruvec(page,
+				page_zone(page));
+
+		if (getpage)
+			get_page(page);
+		ClearPageLRU(page);
+		del_page_from_lru_list(page, lruvec, page_lru(page));
+		return true;
+	}
+
+	return false;
+}
+
+/*
  * Finish munlock after successful page isolation
  *
  * Page must be locked. This is a wrapper for try_to_munlock()
@@ -126,9 +146,9 @@ static void __munlock_isolated_page(stru
 static void __munlock_isolation_failed(struct page *page)
 {
 	if (PageUnevictable(page))
-		count_vm_event(UNEVICTABLE_PGSTRANDED);
+		__count_vm_event(UNEVICTABLE_PGSTRANDED);
 	else
-		count_vm_event(UNEVICTABLE_PGMUNLOCKED);
+		__count_vm_event(UNEVICTABLE_PGMUNLOCKED);
 }
 
 /**
@@ -149,28 +169,34 @@ static void __munlock_isolation_failed(s
 unsigned int munlock_vma_page(struct page *page)
 {
 	unsigned int nr_pages;
+	struct zone *zone = page_zone(page);
 
 	BUG_ON(!PageLocked(page));
 
-	if (TestClearPageMlocked(page)) {
-		nr_pages = hpage_nr_pages(page);
-		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
-		if (!isolate_lru_page(page))
-			__munlock_isolated_page(page);
-		else
-			__munlock_isolation_failed(page);
-	} else {
-		nr_pages = hpage_nr_pages(page);
-	}
-
 	/*
-	 * Regardless of the original PageMlocked flag, we determine nr_pages
-	 * after touching the flag. This leaves a possible race with a THP page
-	 * split, such that a whole THP page was munlocked, but nr_pages == 1.
-	 * Returning a smaller mask due to that is OK, the worst that can
-	 * happen is subsequent useless scanning of the former tail pages.
-	 * The NR_MLOCK accounting can however become broken.
+	 * Serialize with any parallel __split_huge_page_refcount() which
+	 * might otherwise copy PageMlocked to part of the tail pages before
+	 * we clear it in the head page. It also stabilizes hpage_nr_pages().
 	 */
+	spin_lock_irq(&zone->lru_lock);
+
+	nr_pages = hpage_nr_pages(page);
+	if (!TestClearPageMlocked(page))
+		goto unlock_out;
+
+	__mod_zone_page_state(zone, NR_MLOCK, -nr_pages);
+
+	if (__munlock_isolate_lru_page(page, true)) {
+		spin_unlock_irq(&zone->lru_lock);
+		__munlock_isolated_page(page);
+		goto out;
+	}
+	__munlock_isolation_failed(page);
+
+unlock_out:
+	spin_unlock_irq(&zone->lru_lock);
+
+out:
 	return nr_pages - 1;
 }
 
@@ -307,34 +333,24 @@ static void __munlock_pagevec(struct pag
 		struct page *page = pvec->pages[i];
 
 		if (TestClearPageMlocked(page)) {
-			struct lruvec *lruvec;
-			int lru;
-
-			if (PageLRU(page)) {
-				lruvec = mem_cgroup_page_lruvec(page, zone);
-				lru = page_lru(page);
-				/*
-				 * We already have pin from follow_page_mask()
-				 * so we can spare the get_page() here.
-				 */
-				ClearPageLRU(page);
-				del_page_from_lru_list(page, lruvec, lru);
-			} else {
-				__munlock_isolation_failed(page);
-				goto skip_munlock;
-			}
-
-		} else {
-skip_munlock:
 			/*
-			 * We won't be munlocking this page in the next phase
-			 * but we still need to release the follow_page_mask()
-			 * pin. We cannot do it under lru_lock however. If it's
-			 * the last pin, __page_cache_release would deadlock.
+			 * We already have pin from follow_page_mask()
+			 * so we can spare the get_page() here.
 			 */
-			pagevec_add(&pvec_putback, pvec->pages[i]);
-			pvec->pages[i] = NULL;
+			if (__munlock_isolate_lru_page(page, false))
+				continue;
+			else
+				__munlock_isolation_failed(page);
 		}
+
+		/*
+		 * We won't be munlocking this page in the next phase
+		 * but we still need to release the follow_page_mask()
+		 * pin. We cannot do it under lru_lock however. If it's
+		 * the last pin, __page_cache_release() would deadlock.
+		 */
+		pagevec_add(&pvec_putback, pvec->pages[i]);
+		pvec->pages[i] = NULL;
 	}
 	delta_munlocked = -nr + pagevec_count(&pvec_putback);
 	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch
mm-compaction-respect-ignore_skip_hint-in-update_pageblock_skip.patch
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
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
linux-next.patch

