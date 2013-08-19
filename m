From: akpm@linux-foundation.org
Subject: + mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch added to -mm tree
Date: Mon, 19 Aug 2013 15:49:09 -0700
Message-ID: <5212a0e5.i9rnwyv4XG74IFw6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3HSWtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 18:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, joern@logfs.org, hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz

Subject: + mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch added to -mm tree
To: vbabka@suse.cz,hannes@cmpxchg.org,hughd@google.com,joern@logfs.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 15:49:09 -0700


The patch titled
     Subject: mm: munlock: bypass per-cpu pvec for putback_lru_page
has been added to the -mm tree.  Its filename is
     mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch

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
Subject: mm: munlock: bypass per-cpu pvec for putback_lru_page

After introducing batching by pagevecs into munlock_vma_range(), we can
further improve performance by bypassing the copying into per-cpu pagevec
and the get_page/put_page pair associated with that.  Instead we perform
LRU putback directly from our pagevec.  However, this is possible only for
single-mapped pages that are evictable after munlock.  Unevictable pages
require rechecking after putting on the unevictable list, so for those we
fallback to putback_lru_page(), hich handles that.

After this patch, a 13% speedup was measured for munlocking a 56GB large
memory area with THP disabled.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Jörn Engel <joern@logfs.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

diff -puN mm/mlock.c~mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page mm/mlock.c
--- a/mm/mlock.c~mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page
+++ a/mm/mlock.c
@@ -227,6 +227,49 @@ static int __mlock_posix_error_return(lo
 }
 
 /*
+ * Prepare page for fast batched LRU putback via putback_lru_evictable_pagevec()
+ *
+ * The fast path is available only for evictable pages with single mapping.
+ * Then we can bypass the per-cpu pvec and get better performance.
+ * when mapcount > 1 we need try_to_munlock() which can fail.
+ * when !page_evictable(), we need the full redo logic of putback_lru_page to
+ * avoid leaving evictable page in unevictable list.
+ *
+ * In case of success, @page is added to @pvec and @pgrescued is incremented
+ * in case that the page was previously unevictable. @page is also unlocked.
+ */
+static bool __putback_lru_fast_prepare(struct page *page, struct pagevec *pvec,
+		int *pgrescued)
+{
+	VM_BUG_ON(PageLRU(page));
+	VM_BUG_ON(!PageLocked(page));
+
+	if (page_mapcount(page) <= 1 && page_evictable(page)) {
+		pagevec_add(pvec, page);
+		if (TestClearPageUnevictable(page))
+			(*pgrescued)++;
+		unlock_page(page);
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Putback multiple evictable pages to the LRU
+ *
+ * Batched putback of evictable pages that bypasses the per-cpu pvec. Some of
+ * the pages might have meanwhile become unevictable but that is OK.
+ */
+static void __putback_lru_fast(struct pagevec *pvec, int pgrescued)
+{
+	count_vm_events(UNEVICTABLE_PGMUNLOCKED, pagevec_count(pvec));
+	/* This includes put_page so we don't call it explicitly */
+	__pagevec_lru_add(pvec);
+	count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
+}
+
+/*
  * Munlock a batch of pages from the same zone
  *
  * The work is split to two main phases. First phase clears the Mlocked flag
@@ -239,6 +282,8 @@ static void __munlock_pagevec(struct pag
 	int i;
 	int nr = pagevec_count(pvec);
 	int delta_munlocked = -nr;
+	struct pagevec pvec_putback;
+	int pgrescued = 0;
 
 	/* Phase 1: page isolation */
 	spin_lock_irq(&zone->lru_lock);
@@ -276,17 +321,34 @@ skip_munlock:
 	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
 	spin_unlock_irq(&zone->lru_lock);
 
-	/* Phase 2: page munlock and putback */
+	/* Phase 2: page munlock */
+	pagevec_init(&pvec_putback, 0);
 	for (i = 0; i < nr; i++) {
 		struct page *page = pvec->pages[i];
 
 		if (page) {
 			lock_page(page);
-			__munlock_isolated_page(page);
-			unlock_page(page);
-			put_page(page); /* pin from follow_page_mask() */
+			if (!__putback_lru_fast_prepare(page, &pvec_putback,
+					&pgrescued)) {
+				/* Slow path */
+				__munlock_isolated_page(page);
+				unlock_page(page);
+			}
 		}
 	}
+
+	/* Phase 3: page putback for pages that qualified for the fast path */
+	if (pagevec_count(&pvec_putback))
+		__putback_lru_fast(&pvec_putback, pgrescued);
+
+	/* Phase 4: put_page to return pin from follow_page_mask() */
+	for (i = 0; i < nr; i++) {
+		struct page *page = pvec->pages[i];
+
+		if (page)
+			put_page(page);
+	}
+
 	pagevec_reinit(pvec);
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch

