From: akpm@linux-foundation.org
Subject: + mm-munlock-fix-deadlock-in-__munlock_pagevec.patch added to -mm tree
Date: Mon, 16 Dec 2013 16:34:37 -0800
Message-ID: <52af9c1d.a8Wtz5GXMOuSqMMV%akpm__26386.8502494462$1387240492$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3LQAei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 19:34:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, stable@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, mgorman@suse.de, hughd@google.com, aarcange@redhat.com, vbabka@suse.cz

Subject: + mm-munlock-fix-deadlock-in-__munlock_pagevec.patch added to -mm tree
To: vbabka@suse.cz,aarcange@redhat.com,hughd@google.com,mgorman@suse.de,riel@redhat.com,sasha.levin@oracle.com,stable@vger.kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 16:34:37 -0800


The patch titled
     Subject: mm: munlock: fix deadlock in __munlock_pagevec()
has been added to the -mm tree.  Its filename is
     mm-munlock-fix-deadlock-in-__munlock_pagevec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-fix-deadlock-in-__munlock_pagevec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-fix-deadlock-in-__munlock_pagevec.patch

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
Subject: mm: munlock: fix deadlock in __munlock_pagevec()

Commit 7225522bb ("mm: munlock: batch non-THP page isolation and
munlock+putback using pagevec" introduced __munlock_pagevec() to speed up
munlock by holding lru_lock over multiple isolated pages.  Pages that fail
to be isolated are put_page()d immediately, also within the lock.

This can lead to deadlock when __munlock_pagevec() becomes the holder of
the last page pin and put_page() leads to __page_cache_release() which
also locks lru_lock.  The deadlock has been observed by Sasha Levin using
trinity.

This patch avoids the deadlock by deferring put_page() operations until
lru_lock is released.  Another pagevec (which is also used by later phases
of the function is reused to gather the pages for put_page() operation.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN mm/mlock.c~mm-munlock-fix-deadlock-in-__munlock_pagevec mm/mlock.c
--- a/mm/mlock.c~mm-munlock-fix-deadlock-in-__munlock_pagevec
+++ a/mm/mlock.c
@@ -295,10 +295,12 @@ static void __munlock_pagevec(struct pag
 {
 	int i;
 	int nr = pagevec_count(pvec);
-	int delta_munlocked = -nr;
+	int delta_munlocked;
 	struct pagevec pvec_putback;
 	int pgrescued = 0;
 
+	pagevec_init(&pvec_putback, 0);
+
 	/* Phase 1: page isolation */
 	spin_lock_irq(&zone->lru_lock);
 	for (i = 0; i < nr; i++) {
@@ -327,16 +329,22 @@ skip_munlock:
 			/*
 			 * We won't be munlocking this page in the next phase
 			 * but we still need to release the follow_page_mask()
-			 * pin.
+			 * pin. We cannot do it under lru_lock however. If it's
+			 * the last pin, __page_cache_release would deadlock.
 			 */
+			pagevec_add(&pvec_putback, pvec->pages[i]);
 			pvec->pages[i] = NULL;
-			put_page(page);
-			delta_munlocked++;
 		}
 	}
+	delta_munlocked = -nr + pagevec_count(&pvec_putback);
 	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
 	spin_unlock_irq(&zone->lru_lock);
 
+	/* Now we can release pins of pages that we are not munlocking */
+	for (i = 0; i < pagevec_count(&pvec_putback); i++) {
+		put_page(pvec_putback.pages[i]);
+	}
+
 	/* Phase 2: page munlock */
 	pagevec_init(&pvec_putback, 0);
 	for (i = 0; i < nr; i++) {
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

