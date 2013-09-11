From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3.patch removed from -mm tree
Date: Wed, 11 Sep 2013 14:00:46 -0700
Message-ID: <5230d9fe.wpIysF6hMh+4WeHD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3IKVAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, joern@logfs.org, hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz

Subject: [folded-merged] mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3.patch removed from -mm tree
To: vbabka@suse.cz,hannes@cmpxchg.org,hughd@google.com,joern@logfs.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:00:46 -0700


The patch titled
     Subject: mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3
has been removed from the -mm tree.  Its filename was
     mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3.patch

This patch was dropped because it was folded into mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3

  o Split PTE walk to __munlock_pagevec_fill()
  o __munlock_pagevec() does not reinitialize the pagevec anymore
  o Use page_zone_id() for checking if pages are in the same zone (smaller
    overhead than page_zone())

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

 include/linux/mm.h |   12 +-
 mm/mlock.c         |  179 ++++++++++++++++++++-----------------------
 2 files changed, 91 insertions(+), 100 deletions(-)

diff -puN include/linux/mm.h~mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3 include/linux/mm.h
--- a/include/linux/mm.h~mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3
+++ a/include/linux/mm.h
@@ -643,12 +643,12 @@ static inline enum zone_type page_zonenu
 #endif
 
 /*
- * The identification function is only used by the buddy allocator for
- * determining if two pages could be buddies. We are not really
- * identifying a zone since we could be using a the section number
- * id if we have not node id available in page flags.
- * We guarantee only that it will return the same value for two
- * combinable pages in a zone.
+ * The identification function is mainly used by the buddy allocator for
+ * determining if two pages could be buddies. We are not really identifying
+ * the zone since we could be using the section number id if we do not have
+ * node id available in page flags.
+ * We only guarantee that it will return the same value for two combinable
+ * pages in a zone.
  */
 static inline int page_zone_id(struct page *page)
 {
diff -puN mm/mlock.c~mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3 mm/mlock.c
--- a/mm/mlock.c~mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3
+++ a/mm/mlock.c
@@ -280,8 +280,7 @@ static void __putback_lru_fast(struct pa
  * The second phase finishes the munlock only for pages where isolation
  * succeeded.
  *
- * Note that pvec is modified during the process. Before returning
- * pagevec_reinit() is called on it.
+ * Note that the pagevec may be modified during the process.
  */
 static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 {
@@ -356,8 +355,60 @@ skip_munlock:
 	 */
 	if (pagevec_count(&pvec_putback))
 		__putback_lru_fast(&pvec_putback, pgrescued);
+}
+
+/*
+ * Fill up pagevec for __munlock_pagevec using pte walk
+ *
+ * The function expects that the struct page corresponding to @start address is
+ * a non-TPH page already pinned and in the @pvec, and that it belongs to @zone.
+ *
+ * The rest of @pvec is filled by subsequent pages within the same pmd and same
+ * zone, as long as the pte's are present and vm_normal_page() succeeds. These
+ * pages also get pinned.
+ *
+ * Returns the address of the next page that should be scanned. This equals
+ * @start + PAGE_SIZE when no page could be added by the pte walk.
+ */
+static unsigned long __munlock_pagevec_fill(struct pagevec *pvec,
+		struct vm_area_struct *vma, int zoneid,	unsigned long start,
+		unsigned long end)
+{
+	pte_t *pte;
+	spinlock_t *ptl;
 
-	pagevec_reinit(pvec);
+	/*
+	 * Initialize pte walk starting at the already pinned page where we
+	 * are sure that there is a pte.
+	 */
+	pte = get_locked_pte(vma->vm_mm, start,	&ptl);
+	end = min(end, pmd_addr_end(start, end));
+
+	/* The page next to the pinned page is the first we will try to get */
+	start += PAGE_SIZE;
+	while (start < end) {
+		struct page *page = NULL;
+		pte++;
+		if (pte_present(*pte))
+			page = vm_normal_page(vma, start, *pte);
+		/*
+		 * Break if page could not be obtained or the page's node+zone does not
+		 * match
+		 */
+		if (!page || page_zone_id(page) != zoneid)
+			break;
+
+		get_page(page);
+		/*
+		 * Increase the address that will be returned *before* the
+		 * eventual break due to pvec becoming full by adding the page
+		 */
+		start += PAGE_SIZE;
+		if (pagevec_add(pvec, page) == 0)
+			break;
+	}
+	pte_unmap_unlock(pte, ptl);
+	return start;
 }
 
 /*
@@ -381,81 +432,28 @@ skip_munlock:
 void munlock_vma_pages_range(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end)
 {
-	struct pagevec pvec;
-	struct zone *zone = NULL;
-	pte_t *pte = NULL;
-	spinlock_t *ptl;
-	unsigned long pmd_end;
-
-	pagevec_init(&pvec, 0);
 	vma->vm_flags &= ~VM_LOCKED;
 
 	while (start < end) {
 		struct page *page = NULL;
 		unsigned int page_mask, page_increm;
-		struct zone *pagezone;
-
-		/* If we can, try pte walk instead of follow_page_mask() */
-		if (pte && start < pmd_end) {
-			pte++;
-			if (pte_present(*pte))
-				page = vm_normal_page(vma, start, *pte);
-			if (page) {
-				get_page(page);
-				page_mask = 0;
-			}
-		}
+		struct pagevec pvec;
+		struct zone *zone;
+		int zoneid;
 
+		pagevec_init(&pvec, 0);
 		/*
-		 * If we did sucessful pte walk step, use that page.
-		 * Otherwise (NULL pte, !pte_present or vm_normal_page failed
-		 * due to e.g. zero page), fallback to follow_page_mask() which
-		 * handles all exceptions.
+		 * Although FOLL_DUMP is intended for get_dump_page(),
+		 * it just so happens that its special treatment of the
+		 * ZERO_PAGE (returning an error instead of doing get_page)
+		 * suits munlock very well (and if somehow an abnormal page
+		 * has sneaked into the range, we won't oops here: great).
 		 */
-		if (!page) {
-			if (pte) {
-				pte_unmap_unlock(pte, ptl);
-				pte = NULL;
-			}
-
-			/*
-			 * Although FOLL_DUMP is intended for get_dump_page(),
-			 * it just so happens that its special treatment of the
-			 * ZERO_PAGE (returning an error instead of doing
-			 * get_page) suits munlock very well (and if somehow an
-			 * abnormal page has sneaked into the range, we won't
-			 * oops here: great).
-			 */
-			page = follow_page_mask(vma, start,
-					FOLL_GET | FOLL_DUMP, &page_mask);
-			pmd_end = pmd_addr_end(start, end);
-		}
+		page = follow_page_mask(vma, start, FOLL_GET | FOLL_DUMP,
+				&page_mask);
 
 		if (page && !IS_ERR(page)) {
-			pagezone = page_zone(page);
-			/* The whole pagevec must be in the same zone */
-			if (pagezone != zone) {
-				if (pagevec_count(&pvec)) {
-					if (pte) {
-						pte_unmap_unlock(pte, ptl);
-						pte = NULL;
-					}
-					__munlock_pagevec(&pvec, zone);
-				}
-				zone = pagezone;
-			}
 			if (PageTransHuge(page)) {
-				/*
-				 * We could not have stumbled upon a THP page
-				 * using the pte walk.
-				 */
-				VM_BUG_ON(pte);
-				/*
-				 * THP pages are not handled by pagevec due
-				 * to their possible split (see below).
-				 */
-				if (pagevec_count(&pvec))
-					__munlock_pagevec(&pvec, zone);
 				lock_page(page);
 				/*
 				 * Any THP page found by follow_page_mask() may
@@ -468,38 +466,31 @@ void munlock_vma_pages_range(struct vm_a
 				put_page(page); /* follow_page_mask() */
 			} else {
 				/*
-				 * Initialize pte walk for further pages. We
-				 * can do this here since we know the current
-				 * page is not THP.
-				 */
-				if (!pte)
-					pte = get_locked_pte(vma->vm_mm, start,
-							&ptl);
-				/*
-				 * Non-huge pages are handled in batches
-				 * via pagevec. The pin from
-				 * follow_page_mask() prevents them from
-				 * collapsing by THP.
-				 */
-				if (pagevec_add(&pvec, page) == 0) {
-					if (pte) {
-						pte_unmap_unlock(pte, ptl);
-						pte = NULL;
-					}
-					__munlock_pagevec(&pvec, zone);
-				}
+				 * Non-huge pages are handled in batches via
+				 * pagevec. The pin from follow_page_mask()
+				 * prevents them from collapsing by THP.
+				 */
+				pagevec_add(&pvec, page);
+				zone = page_zone(page);
+				zoneid = page_zone_id(page);
+
+				/*
+				 * Try to fill the rest of pagevec using fast
+				 * pte walk. This will also update start to
+				 * the next page to process. Then munlock the
+				 * pagevec.
+				 */
+				start = __munlock_pagevec_fill(&pvec, vma,
+						zoneid, start, end);
+				__munlock_pagevec(&pvec, zone);
+				goto next;
 			}
 		}
 		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
 		start += page_increm * PAGE_SIZE;
-		/* Don't resched while ptl is held */
-		if (!pte)
-			cond_resched();
+next:
+		cond_resched();
 	}
-	if (pte)
-		pte_unmap_unlock(pte, ptl);
-	if (pagevec_count(&pvec))
-		__munlock_pagevec(&pvec, zone);
 }
 
 /*
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch

