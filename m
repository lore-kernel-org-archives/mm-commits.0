From: akpm@linux-foundation.org
Subject: [merged]
 mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:57 -0700
Message-ID: <523219b9.bX07XAvPuaVnBQTh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3ILTo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, joern@logfs.org, hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz

Subject: [merged] mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch removed from -mm tree
To: vbabka@suse.cz,hannes@cmpxchg.org,hughd@google.com,joern@logfs.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:57 -0700


The patch titled
     Subject: mm: munlock: remove redundant get_page/put_page pair on the fast path
has been removed from the -mm tree.  Its filename was
     mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: munlock: remove redundant get_page/put_page pair on the fast path

The performance of the fast path in munlock_vma_range() can be further
improved by avoiding atomic ops of a redundant get_page()/put_page() pair.

When calling get_page() during page isolation, we already have the pin
from follow_page_mask().  This pin will be then returned by
__pagevec_lru_add(), after which we do not reference the pages anymore.

After this patch, an 8% speedup was measured for munlocking a 56GB large
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

 mm/mlock.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN mm/mlock.c~mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path mm/mlock.c
--- a/mm/mlock.c~mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path
+++ a/mm/mlock.c
@@ -303,8 +303,10 @@ static void __munlock_pagevec(struct pag
 			if (PageLRU(page)) {
 				lruvec = mem_cgroup_page_lruvec(page, zone);
 				lru = page_lru(page);
-
-				get_page(page);
+				/*
+				 * We already have pin from follow_page_mask()
+				 * so we can spare the get_page() here.
+				 */
 				ClearPageLRU(page);
 				del_page_from_lru_list(page, lruvec, lru);
 			} else {
@@ -336,25 +338,25 @@ skip_munlock:
 			lock_page(page);
 			if (!__putback_lru_fast_prepare(page, &pvec_putback,
 					&pgrescued)) {
-				/* Slow path */
+				/*
+				 * Slow path. We don't want to lose the last
+				 * pin before unlock_page()
+				 */
+				get_page(page); /* for putback_lru_page() */
 				__munlock_isolated_page(page);
 				unlock_page(page);
+				put_page(page); /* from follow_page_mask() */
 			}
 		}
 	}
 
-	/* Phase 3: page putback for pages that qualified for the fast path */
+	/*
+	 * Phase 3: page putback for pages that qualified for the fast path
+	 * This will also call put_page() to return pin from follow_page_mask()
+	 */
 	if (pagevec_count(&pvec_putback))
 		__putback_lru_fast(&pvec_putback, pgrescued);
 
-	/* Phase 4: put_page to return pin from follow_page_mask() */
-	for (i = 0; i < nr; i++) {
-		struct page *page = pvec->pages[i];
-
-		if (page)
-			put_page(page);
-	}
