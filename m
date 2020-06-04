From: akpm@linux-foundation.org
Subject: [merged]
 mm-only-count-actual-rotations-as-lru-reclaim-cost.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:21:00 -0700
Message-ID: <20200604172100.mop5Z_nik%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgFDRVB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:21:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm: only count actual rotations as LRU reclaim cost
has been removed from the -mm tree.  Its filename was
     mm-only-count-actual-rotations-as-lru-reclaim-cost.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: only count actual rotations as LRU reclaim cost

When shrinking the active file list we rotate referenced pages only when
they're in an executable mapping.  The others get deactivated.  When it
comes to balancing scan pressure, though, we count all referenced pages as
rotated, even the deactivated ones.  Yet they do not carry the same cost
to the system: the deactivated page *might* refault later on, but the
deactivation is tangible progress toward freeing pages; rotations on the
other hand cost time and effort without getting any closer to freeing
memory.

Don't treat both events as equal.  The following patch will hook up LRU
balancing to cache and anon refaults, which are a much more concrete cost
signal for reclaiming one list over the other.  Thus, remove the maybe-IO
cost bias from page references, and only note the CPU cost for actual
rotations that prevent the pages from getting reclaimed.

Link: http://lkml.kernel.org/r/20200520232525.798933-11-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-only-count-actual-rotations-as-lru-reclaim-cost
+++ a/mm/vmscan.c
@@ -2054,7 +2054,6 @@ static void shrink_active_list(unsigned
 
 		if (page_referenced(page, 0, sc->target_mem_cgroup,
 				    &vm_flags)) {
-			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
 			 * give them one more trip around the active list. So
@@ -2065,6 +2064,7 @@ static void shrink_active_list(unsigned
 			 * so we ignore them here.
 			 */
 			if ((vm_flags & VM_EXEC) && page_is_file_lru(page)) {
+				nr_rotated += hpage_nr_pages(page);
 				list_add(&page->lru, &l_active);
 				continue;
 			}
@@ -2080,10 +2080,8 @@ static void shrink_active_list(unsigned
 	 */
 	spin_lock_irq(&pgdat->lru_lock);
 	/*
-	 * Count referenced pages from currently used mappings as rotated,
-	 * even though only some of them are actually re-activated.  This
-	 * helps balance scan pressure between file and anonymous pages in
-	 * get_scan_count.
+	 * Rotating pages costs CPU without actually
+	 * progressing toward the reclaim goal.
 	 */
 	lru_note_cost(lruvec, file, nr_rotated);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
