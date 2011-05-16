From: akpm@linux-foundation.org
Subject: + mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely.patch added to -mm tree
Date: Mon, 16 May 2011 14:17:24 -0700
Message-ID: <201105162117.p4GLHPdp019557__14073.4588182115$1305580724$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054Ab1EPVSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 May 2011 17:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, James.Bottomley@HansenPartnership.com, chris.mason@oracle.com, cl@linux.com, colin.king@canonical.com, jack@suse.cz, mgorman@suse.de, minchan.kim@gmail.com, penberg@kernel.org, raghu.prabhu13@gmail.com, riel@redhat.com, stable@kernel.org


The patch titled
     mm: vmscan: correct use of pgdat_balanced in sleeping_prematurely
has been added to the -mm tree.  Its filename is
     mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Patch 1 corrects logic introduced by commit [1741c877: mm: kswapd:
        keep kswapd awake for high-order allocations until a percentage of
        the node is balanced] to allow kswapd to go to sleep when balanced
        for high orders.

Patch 2 notes that even when kswapd is failing to keep up with
        allocation requests, it should still go to sleep when its quota
        has expired to prevent it spinning.

This version drops the patches whereby SLUB avoids expensive steps in the
page allocator, reclaim and compaction due to a lack of agreement on
whether it was an appropriate step or not and not being critical to
resolve the hang.  Chris Wood reports that these two patches in isolation
are sufficient to prevent the system hanging.

					
This patch:

Johannes Weiner poined out that the logic in commit [1741c877: mm:
kswapd: keep kswapd awake for high-order allocations until a percentage
of the node is balanced] is backwards. Instead of allowing kswapd to go
to sleep when balancing for high order allocations, it keeps it kswapd
running uselessly.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Colin King <colin.king@canonical.com>
Cc: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: <stable@kernel.org>		[2.6.38+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely
+++ a/mm/vmscan.c
@@ -2286,7 +2286,7 @@ static bool sleeping_prematurely(pg_data
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
mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-vmalloc-remove-guard-page-from-between-vmap-blocks.patch
mm-break-out-page-allocation-warning-code.patch
mm-print-vmalloc-state-after-allocation-failures.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch

