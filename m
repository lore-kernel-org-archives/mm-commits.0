From: akpm@linux-foundation.org
Subject: + mm-vmscan-clear-pgdat_writeback-when-zone-is-balanced.patch
 added to -mm tree
Date: Fri, 03 Feb 2017 15:04:11 -0800
Message-ID: <58950c6b.UxeKucD8JDHjFqHb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38518 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752268AbdBCXEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 18:04:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mhocko@suse.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: clear PGDAT_WRITEBACK when zone is balanced
has been added to the -mm tree.  Its filename is
     mm-vmscan-clear-pgdat_writeback-when-zone-is-balanced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-clear-pgdat_writeback-when-zone-is-balanced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-clear-pgdat_writeback-when-zone-is-balanced.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/20170203203222.gq7hk66yc36lpgtb@suse.de
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~mm-vmscan-clear-pgdat_writeback-when-zone-is-balanced mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-clear-pgdat_writeback-when-zone-is-balanced
+++ a/mm/vmscan.c
@@ -3103,6 +3103,7 @@ static bool zone_balanced(struct zone *z
 	 */
 	clear_bit(PGDAT_CONGESTED, &zone->zone_pgdat->flags);
 	clear_bit(PGDAT_DIRTY, &zone->zone_pgdat->flags);
+	clear_bit(PGDAT_WRITEBACK, &zone->zone_pgdat->flags);
 
 	return true;
 }
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-vmscan-clear-pgdat_writeback-when-zone-is-balanced.patch

