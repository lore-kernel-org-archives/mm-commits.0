From: akpm@linux-foundation.org
Subject: [merged] mm-move-pagevec-stripping-to-save-unlock-relock.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:16 -0700
Message-ID: <200904011838.n31IcGSE008184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755707AbZDASlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: move pagevec stripping to save unlock-relock
has been removed from the -mm tree.  Its filename was
     mm-move-pagevec-stripping-to-save-unlock-relock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move pagevec stripping to save unlock-relock
From: Johannes Weiner <hannes@cmpxchg.org>

In shrink_active_list() after the deactivation loop, we strip buffer heads
from the potentially remaining pages in the pagevec.

Currently, this drops the zone's lru lock for stripping, only to reacquire
it again afterwards to update statistics.

It is not necessary to strip the pages before updating the stats, so move
the whole thing out of the protected region and save the extra locking.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: MinChan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-move-pagevec-stripping-to-save-unlock-relock mm/vmscan.c
--- a/mm/vmscan.c~mm-move-pagevec-stripping-to-save-unlock-relock
+++ a/mm/vmscan.c
@@ -1298,14 +1298,11 @@ static void shrink_active_list(unsigned 
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 	pgdeactivate += pgmoved;
-	if (buffer_heads_over_limit) {
-		spin_unlock_irq(&zone->lru_lock);
-		pagevec_strip(&pvec);
-		spin_lock_irq(&zone->lru_lock);
-	}
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
 	spin_unlock_irq(&zone->lru_lock);
+	if (buffer_heads_over_limit)
+		pagevec_strip(&pvec);
 	if (vm_swap_full())
 		pagevec_swap_free(&pvec);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
cifs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

