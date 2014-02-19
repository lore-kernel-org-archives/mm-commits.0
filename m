From: akpm@linux-foundation.org
Subject: + mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch added to -mm tree
Date: Wed, 19 Feb 2014 14:32:10 -0800
Message-ID: <530530ea.L0fEaFFozqxnADhj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaBSWcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 17:32:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, weijie.yang@samsung.com

Subject: + mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch added to -mm tree
To: weijie.yang@samsung.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 14:32:10 -0800


The patch titled
     Subject: mm/vmscan: do not check compaction_ready on promoted zones
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/vmscan: do not check compaction_ready on promoted zones

We abort direct reclaim if we find the zone is ready for compaction. 
Sometimes the zone is just a promoted highmem zone to force a scan of
highmem, which is not the intended zone the caller want to allocate a page
from.  In this situation, setting aborted_reclaim to indicate the caller
turned back to retry the allocation is waste of time and could cause a
loop in __alloc_pages_slowpath().

This patch does not check compaction_ready() on promoted zones to avoid
the above situation.  Only set aborted_reclaim if the caller intended zone
is ready for compaction.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-check-compaction_ready-on-promoted-zones mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-check-compaction_ready-on-promoted-zones
+++ a/mm/vmscan.c
@@ -2318,6 +2318,7 @@ static bool shrink_zones(struct zonelist
 	struct shrink_control shrink = {
 		.gfp_mask = sc->gfp_mask,
 	};
+	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2358,7 +2359,8 @@ static bool shrink_zones(struct zonelist
 				 * noticeable problem, like transparent huge
 				 * page allocations.
 				 */
-				if (compaction_ready(zone, sc)) {
+				if ((zonelist_zone_idx(z) <= requested_highidx)
+				    && compaction_ready(zone, sc)) {
 					aborted_reclaim = true;
 					continue;
 				}
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch
mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch
linux-next.patch

