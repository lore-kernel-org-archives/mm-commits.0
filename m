From: akpm@linux-foundation.org
Subject: [merged] vmscan-respect-higher-order-in-zone_reclaim.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:36 -0700
Message-ID: <200904011834.n31IYa1B007204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764353AbZDASkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: respect higher order in zone_reclaim()
has been removed from the -mm tree.  Its filename was
     vmscan-respect-higher-order-in-zone_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: respect higher order in zone_reclaim()
From: Johannes Weiner <hannes@cmpxchg.org>

During page allocation, there are two stages of direct reclaim that are
applied to each zone in the preferred list.  The first stage using
zone_reclaim() reclaims unmapped file backed pages and slab pages if over
defined limits as these are cheaper to reclaim.  The caller specifies the
order of the target allocation but the scan control is not being correctly
initialised.

The impact is that the correct number of pages are being reclaimed but
that lumpy reclaim is not being applied.  This increases the chances of a
full direct reclaim via try_to_free_pages() is required.

This patch initialises the order field of the scan control as requested by
the caller.

[mel@csn.ul.ie: rewrote changelog]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~vmscan-respect-higher-order-in-zone_reclaim mm/vmscan.c
--- a/mm/vmscan.c~vmscan-respect-higher-order-in-zone_reclaim
+++ a/mm/vmscan.c
@@ -2295,6 +2295,7 @@ static int __zone_reclaim(struct zone *z
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
 		.swappiness = vm_swappiness,
+		.order = order,
 		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
cifs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

