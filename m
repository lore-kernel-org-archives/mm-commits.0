From: akpm@linux-foundation.org
Subject: +
 mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch
 added to -mm tree
Date: Mon, 19 Aug 2013 15:49:14 -0700
Message-ID: <5212a0ea.ghltL52ZMLT9k2oM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3HSWtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 18:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, joern@logfs.org, hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz

Subject: + mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch added to -mm tree
To: vbabka@suse.cz,hannes@cmpxchg.org,hughd@google.com,joern@logfs.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 15:49:14 -0700


The patch titled
     Subject: mm: munlock: manual pte walk in fast path instead of follow_page_mask()
has been added to the -mm tree.  Its filename is
     mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch

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
Subject: mm: munlock: manual pte walk in fast path instead of follow_page_mask()

Currently munlock_vma_pages_range() calls follow_page_mask() to obtain
each struct page.  This entails repeated full page table translations and
page table lock taken for each page separately.

This patch attempts to avoid the costly follow_page_mask() where possible,
by iterating over ptes within single pmd under single page table lock. 
The first pte is obtained by get_locked_pte() for non-THP page acquired by
the initial follow_page_mask().  The latter function is also used as a
fallback in case simple pte_present() and vm_normal_page() are not
sufficient to obtain the struct page.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jörn Engel <joern@logfs.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   79 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 68 insertions(+), 11 deletions(-)

diff -puN mm/mlock.c~mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask mm/mlock.c
--- a/mm/mlock.c~mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask
+++ a/mm/mlock.c
@@ -380,34 +380,74 @@ void munlock_vma_pages_range(struct vm_a
 {
 	struct pagevec pvec;
 	struct zone *zone = NULL;
+	pte_t *pte = NULL;
+	spinlock_t *ptl;
+	unsigned long pmd_end;
 
 	pagevec_init(&pvec, 0);
 	vma->vm_flags &= ~VM_LOCKED;
 
 	while (start < end) {
-		struct page *page;
+		struct page *page = NULL;
 		unsigned int page_mask, page_increm;
 		struct zone *pagezone;
 
+		/* If we can, try pte walk instead of follow_page_mask() */
+		if (pte && start < pmd_end) {
+			pte++;
+			if (pte_present(*pte))
+				page = vm_normal_page(vma, start, *pte);
+			if (page) {
+				get_page(page);
+				page_mask = 0;
+			}
+		}
+
 		/*
-		 * Although FOLL_DUMP is intended for get_dump_page(),
-		 * it just so happens that its special treatment of the
-		 * ZERO_PAGE (returning an error instead of doing get_page)
-		 * suits munlock very well (and if somehow an abnormal page
-		 * has sneaked into the range, we won't oops here: great).
+		 * If we did sucessful pte walk step, use that page.
+		 * Otherwise (NULL pte, !pte_present or vm_normal_page failed
+		 * due to e.g. zero page), fallback to follow_page_mask() which
+		 * handles all exceptions.
 		 */
-		page = follow_page_mask(vma, start, FOLL_GET | FOLL_DUMP,
-					&page_mask);
+		if (!page) {
+			if (pte) {
+				pte_unmap_unlock(pte, ptl);
+				pte = NULL;
+			}
+
+			/*
+			 * Although FOLL_DUMP is intended for get_dump_page(),
+			 * it just so happens that its special treatment of the
+			 * ZERO_PAGE (returning an error instead of doing
+			 * get_page) suits munlock very well (and if somehow an
+			 * abnormal page has sneaked into the range, we won't
+			 * oops here: great).
+			 */
+			page = follow_page_mask(vma, start,
+					FOLL_GET | FOLL_DUMP, &page_mask);
+			pmd_end = pmd_addr_end(start, end);
+		}
+
 		if (page && !IS_ERR(page)) {
 			pagezone = page_zone(page);
 			/* The whole pagevec must be in the same zone */
 			if (pagezone != zone) {
-				if (pagevec_count(&pvec))
+				if (pagevec_count(&pvec)) {
+					if (pte) {
+						pte_unmap_unlock(pte, ptl);
+						pte = NULL;
+					}
 					__munlock_pagevec(&pvec, zone);
+				}
 				zone = pagezone;
 			}
 			if (PageTransHuge(page)) {
 				/*
+				 * We could not have stumbled upon a THP page
+				 * using the pte walk.
+				 */
+				VM_BUG_ON(pte);
+				/*
 				 * THP pages are not handled by pagevec due
 				 * to their possible split (see below).
 				 */
@@ -425,19 +465,36 @@ void munlock_vma_pages_range(struct vm_a
 				put_page(page); /* follow_page_mask() */
 			} else {
 				/*
+				 * Initialize pte walk for further pages. We
+				 * can do this here since we know the current
+				 * page is not THP.
+				 */
+				if (!pte)
+					pte = get_locked_pte(vma->vm_mm, start,
+							&ptl);
+				/*
 				 * Non-huge pages are handled in batches
 				 * via pagevec. The pin from
 				 * follow_page_mask() prevents them from
 				 * collapsing by THP.
 				 */
-				if (pagevec_add(&pvec, page) == 0)
+				if (pagevec_add(&pvec, page) == 0) {
+					if (pte) {
+						pte_unmap_unlock(pte, ptl);
+						pte = NULL;
+					}
 					__munlock_pagevec(&pvec, zone);
+				}
 			}
 		}
 		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
 		start += page_increm * PAGE_SIZE;
-		cond_resched();
+		/* Don't resched while ptl is held */
+		if (!pte)
+			cond_resched();
 	}
+	if (pte)
+		pte_unmap_unlock(pte, ptl);
 	if (pagevec_count(&pvec))
 		__munlock_pagevec(&pvec, zone);
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

