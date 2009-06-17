From: akpm@linux-foundation.org
Subject: [merged] vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:29 -0700
Message-ID: <200906171835.n5HIZTVX001437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbZFQSuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: prevent shrinking of active anon lru list in case of no swap space V3
has been removed from the -mm tree.  Its filename was
     vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: prevent shrinking of active anon lru list in case of no swap space V3
From: MinChan Kim <minchan.kim@gmail.com>

shrink_zone() can deactivate active anon pages even if we don't have a
swap device.  Many embedded products don't have a swap device.  So the
deactivation of anon pages is unnecessary.

This patch prevents unnecessary deactivation of anon lru pages.  But, it
don't prevent aging of anon pages to swap out.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3 mm/vmscan.c
--- a/mm/vmscan.c~vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3
+++ a/mm/vmscan.c
@@ -1570,7 +1570,7 @@ static void shrink_zone(int priority, st
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (inactive_anon_is_low(zone, sc))
+	if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
memcg-fix-lru-rotation-in-isolate_pages.patch

