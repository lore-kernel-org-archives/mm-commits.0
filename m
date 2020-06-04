From: akpm@linux-foundation.org
Subject: [merged]
 mm-deactivations-shouldnt-bias-the-lru-balance.patch removed from -mm tree
Date: Thu, 04 Jun 2020 10:20:57 -0700
Message-ID: <20200604172057.WNxubrexK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgFDRU7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm: deactivations shouldn't bias the LRU balance
has been removed from the -mm tree.  Its filename was
     mm-deactivations-shouldnt-bias-the-lru-balance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: deactivations shouldn't bias the LRU balance

Operations like MADV_FREE, FADV_DONTNEED etc.  currently move any affected
active pages to the inactive list to accelerate their reclaim (good) but
also steer page reclaim toward that LRU type, or away from the other
(bad).

The reason why this is undesirable is that such operations are not part of
the regular page aging cycle, and rather a fluke that doesn't say much
about the remaining pages on that list; they might all be in heavy use,
and once the chunk of easy victims has been purged, the VM continues to
apply elevated pressure on those remaining hot pages.  The other LRU,
meanwhile, might have easily reclaimable pages, and there was never a need
to steer away from it in the first place.

As the previous patch outlined, we should focus on recording actually
observed cost to steer the balance rather than speculating about the
potential value of one LRU list over the other.  In that spirit, leave
explicitely deactivated pages to the LRU algorithm to pick up, and let
rotations decide which list is the easiest to reclaim.

[cai@lca.pw: fix set-but-not-used warning]
  Link: http://lkml.kernel.org/r/20200522133335.GA624@Qians-MacBook-Air.local
Link: http://lkml.kernel.org/r/20200520232525.798933-10-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/swap.c~mm-deactivations-shouldnt-bias-the-lru-balance
+++ a/mm/swap.c
@@ -498,7 +498,7 @@ void lru_cache_add_active_or_unevictable
 static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
 			      void *arg)
 {
-	int lru, file;
+	int lru;
 	bool active;
 
 	if (!PageLRU(page))
@@ -512,7 +512,6 @@ static void lru_deactivate_file_fn(struc
 		return;
 
 	active = PageActive(page);
-	file = page_is_file_lru(page);
 	lru = page_lru_base_type(page);
 
 	del_page_from_lru_list(page, lruvec, lru + active);
@@ -538,14 +537,12 @@ static void lru_deactivate_file_fn(struc
 
 	if (active)
 		__count_vm_event(PGDEACTIVATE);
-	lru_note_cost(lruvec, !file, hpage_nr_pages(page));
 }
 
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
 			    void *arg)
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
-		int file = page_is_file_lru(page);
 		int lru = page_lru_base_type(page);
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
@@ -554,7 +551,6 @@ static void lru_deactivate_fn(struct pag
 		add_page_to_lru_list(page, lruvec, lru);
 
 		__count_vm_events(PGDEACTIVATE, hpage_nr_pages(page));
-		lru_note_cost(lruvec, !file, hpage_nr_pages(page));
 	}
 }
 
@@ -579,7 +575,6 @@ static void lru_lazyfree_fn(struct page
 
 		__count_vm_events(PGLAZYFREE, hpage_nr_pages(page));
 		count_memcg_page_event(page, PGLAZYFREE);
-		lru_note_cost(lruvec, 0, hpage_nr_pages(page));
 	}
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
