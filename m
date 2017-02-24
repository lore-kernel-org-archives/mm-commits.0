From: akpm@linux-foundation.org
Subject: [patch 071/124] mm, vmscan: clear PGDAT_WRITEBACK when zone is
 balanced
Date: Fri, 24 Feb 2017 14:59:07 -0800
Message-ID: <58b0babb.WM9WpvBzKI0FkJfQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdBXW7J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mhocko@suse.com, minchan.kim@gmail.com, riel@redhat.com

From: Mel Gorman <mgorman@suse.de>
Subject: mm, vmscan: clear PGDAT_WRITEBACK when zone is balanced

Hillf Danton pointed out that since commit 1d82de618dd ("mm, vmscan: make
kswapd reclaim in terms of nodes") that PGDAT_WRITEBACK is no longer
cleared.  It was not noticed as triggering it requires pages under
writeback to cycle twice through the LRU and before kswapd gets stalled. 
Historically, such issues tended to occur on small machines writing
heavily to slow storage such as a USB stick.  Once kswapd stalls, direct
reclaim stalls may be higher but due to the fact that memory pressure is
required, it would not be very noticable.  Michal Hocko suggested removing
the flag entirely but the conservative fix is to restore the intended
PGDAT_WRITEBACK behaviour and clear the flag when a suitable zone is
balanced.

Fixes: 1d82de618ddd ("mm, vmscan: make kswapd reclaim in terms of nodes")
Link: http://lkml.kernel.org/r/20170203203222.gq7hk66yc36lpgtb@suse.de
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~mm-vmscan-clear-pgdat_writeback-when-zone-is-balanced mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-clear-pgdat_writeback-when-zone-is-balanced
+++ a/mm/vmscan.c
@@ -3096,6 +3096,7 @@ static bool zone_balanced(struct zone *z
 	 */
 	clear_bit(PGDAT_CONGESTED, &zone->zone_pgdat->flags);
 	clear_bit(PGDAT_DIRTY, &zone->zone_pgdat->flags);
+	clear_bit(PGDAT_WRITEBACK, &zone->zone_pgdat->flags);
 
 	return true;
 }
_
