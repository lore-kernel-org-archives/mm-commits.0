From: akpm@linux-foundation.org
Subject: [merged] vmscan-simplify-code.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:22 -0800
Message-ID: <200912152154.nBFLsMEq015352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761310AbZLOWKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:10:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: simplify code
has been removed from the -mm tree.  Its filename was
     vmscan-simplify-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: simplify code
From: Huang Shijie <shijie8@gmail.com>

Simplify the code for shrink_inactive_list().

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-simplify-code mm/vmscan.c
--- a/mm/vmscan.c~vmscan-simplify-code
+++ a/mm/vmscan.c
@@ -1165,10 +1165,8 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
 		__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
 
-		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
-		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
-		reclaim_stat->recent_scanned[1] += count[LRU_INACTIVE_FILE];
-		reclaim_stat->recent_scanned[1] += count[LRU_ACTIVE_FILE];
+		reclaim_stat->recent_scanned[0] += nr_anon;
+		reclaim_stat->recent_scanned[1] += nr_file;
 
 		spin_unlock_irq(&zone->lru_lock);
 
_

Patches currently in -mm which might be from shijie8@gmail.com are

origin.patch

