From: akpm@linux-foundation.org
Subject: + mm-move-pagevec-stripping-to-save-unlock-relock.patch added to -mm tree
Date: Thu, 26 Feb 2009 12:44:49 -0800
Message-ID: <200902262044.n1QKinbV020616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbZBZUo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 15:44:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, minchan.kim@gmail.com


The patch titled
     mm: move pagevec stripping to save unlock-relock
has been added to the -mm tree.  Its filename is
     mm-move-pagevec-stripping-to-save-unlock-relock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
cifs-use-kzfree.patch
md-use-kzfree.patch
s390-use-kzfree.patch
usb-use-kzfree.patch
crypto-use-kzfree.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-move-pagevec-stripping-to-save-unlock-relock.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

