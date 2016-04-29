From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch removed
 from -mm tree
Date: Fri, 29 Apr 2016 15:05:28 -0700
Message-ID: <5723daa8.HFonhv0VZ5Kugh9S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbcD2WF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: reclaim highmem zone if buffer_heads is over limit
has been removed from the -mm tree.  Its filename was
     mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: vmscan: reclaim highmem zone if buffer_heads is over limit

We have been reclaimed highmem zone if buffer_heads is over limit but
6b4f7799c6a5 ("mm: vmscan: invoke slab shrinkers from shrink_zone()")
changed the behavior so it doesn't reclaim highmem zone although
buffer_heads is over the limit.  This patch restores the logic.

Fixes: 6b4f7799c6a5 ("mm: vmscan: invoke slab shrinkers from shrink_zone()")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit
+++ a/mm/vmscan.c
@@ -2553,7 +2553,7 @@ static bool shrink_zones(struct zonelist
 		sc->gfp_mask |= __GFP_HIGHMEM;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-					requested_highidx, sc->nodemask) {
+					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		enum zone_type classzone_idx;
 
 		if (!populated_zone(zone))
_

Patches currently in -mm which might be from minchan@kernel.org are

zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch

