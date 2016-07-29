From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-remove-redundant-check-in-shrink_zones.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:55:51 -0700
Message-ID: <579ba6b7.zNa6dTXibY85LqD2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbcG2Szw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: remove redundant check in shrink_zones()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-redundant-check-in-shrink_zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: remove redundant check in shrink_zones()

As pointed out by Minchan Kim, shrink_zones() checks for populated zones
in a zonelist but a zonelist can never contain unpopulated zones.  While
it's not related to the node-lru series, it can be cleaned up now.

Link: http://lkml.kernel.org/r/1468853426-12858-2-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-redundant-check-in-shrink_zones mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-redundant-check-in-shrink_zones
+++ a/mm/vmscan.c
@@ -2605,9 +2605,6 @@ static void shrink_zones(struct zonelist
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					sc->reclaim_idx, sc->nodemask) {
-		if (!populated_zone(zone))
-			continue;
