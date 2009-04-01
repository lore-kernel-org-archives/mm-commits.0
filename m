From: akpm@linux-foundation.org
Subject: [merged] mm-dont-free-swap-slots-on-page-deactivation.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:18 -0700
Message-ID: <200904011838.n31IcIaW008187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762262AbZDASwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:52:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hugh@veritas.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: don't free swap slots on page deactivation
has been removed from the -mm tree.  Its filename was
     mm-dont-free-swap-slots-on-page-deactivation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't free swap slots on page deactivation
From: Johannes Weiner <hannes@cmpxchg.org>

The pagevec_swap_free() at the end of shrink_active_list() was introduced
in 68a22394 "vmscan: free swap space on swap-in/activation" when
shrink_active_list() was still rotating referenced active pages.

In 7e9cd48 "vmscan: fix pagecache reclaim referenced bit check" this was
changed, the rotating removed but the pagevec_swap_free() after the
rotation loop was forgotten, applying now to the pagevec of the
deactivation loop instead.

Now swap space is freed for deactivated pages.  And only for those that
happen to be on the pagevec after the deactivation loop.

Complete 7e9cd48 and remove the rest of the swap freeing.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/vmscan.c~mm-dont-free-swap-slots-on-page-deactivation mm/vmscan.c
--- a/mm/vmscan.c~mm-dont-free-swap-slots-on-page-deactivation
+++ a/mm/vmscan.c
@@ -1303,9 +1303,6 @@ static void shrink_active_list(unsigned 
 	spin_unlock_irq(&zone->lru_lock);
 	if (buffer_heads_over_limit)
 		pagevec_strip(&pvec);
-	if (vm_swap_full())
-		pagevec_swap_free(&pvec);
