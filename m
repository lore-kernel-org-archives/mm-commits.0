From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely.patch removed from -mm tree
Date: Wed, 25 May 2011 13:26:53 -0700
Message-ID: <201105252025.p4PKPGge014382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994Ab1EYU0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, James.Bottomley@HansenPartnership.com, chris.mason@oracle.com, cl@linux.com, colin.king@canonical.com, fengguang.wu@intel.com, jack@suse.cz, mgorman@suse.de, minch


The patch titled
     mm: vmscan: correct use of pgdat_balanced in sleeping_prematurely
has been removed from the -mm tree.  Its filename was
     mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmscan: correct use of pgdat_balanced in sleeping_prematurely
From: Johannes Weiner <hannes@cmpxchg.org>

There are a few reports of people experiencing hangs when copying large
amounts of data with kswapd using a large amount of CPU which appear to be
due to recent reclaim changes.  SLUB using high orders is the trigger but
not the root cause as SLUB has been using high orders for a while.  The
root cause was bugs introduced into reclaim which are addressed by the
following two patches.

Patch 1 corrects logic introduced by commit 1741c877 ("mm: kswapd:
        keep kswapd awake for high-order allocations until a percentage of
        the node is balanced") to allow kswapd to go to sleep when
        balanced for high orders.

Patch 2 notes that it is possible for kswapd to miss every
        cond_resched() and updates shrink_slab() so it'll at least reach
        that scheduling point.

Chris Wood reports that these two patches in isolation are sufficient to
prevent the system hanging.  AFAIK, they should also resolve similar hangs
experienced by James Bottomley.


This patch:

Johannes Weiner poined out that the logic in commit 1741c877 ("mm: kswapd:
keep kswapd awake for high-order allocations until a percentage of the
node is balanced") is backwards.  Instead of allowing kswapd to go to
sleep when balancing for high order allocations, it keeps it kswapd
running uselessly.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Tested-by: Colin King <colin.king@canonical.com>
Cc: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: <stable@kernel.org>		[2.6.38+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely
+++ a/mm/vmscan.c
@@ -2287,7 +2287,7 @@ static bool sleeping_prematurely(pg_data
 	 * must be balanced
 	 */
 	if (order)
-		return pgdat_balanced(pgdat, balanced, classzone_idx);
+		return !pgdat_balanced(pgdat, balanced, classzone_idx);
 	else
 		return !all_zones_ok;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch

