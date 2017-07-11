From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low.patch removed from
 -mm tree
Date: Tue, 11 Jul 2017 12:22:49 -0700
Message-ID: <20170711192249.jwwJIILXu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTWu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:22:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, rientjes@google.com


The patch titled
     Subject: mm, vmscan: avoid thrashing anon lru when free + file is low
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, vmscan: avoid thrashing anon lru when free + file is low

The purpose of the code that commit 623762517e23 ("revert 'mm: vmscan: do
not swap anon pages just because free+file is low'") reintroduces is to
prefer swapping anonymous memory rather than trashing the file lru.

If the anonymous inactive lru for the set of eligible zones is considered
low, however, or the length of the list for the given reclaim priority
does not allow for effective anonymous-only reclaiming, then avoid forcing
SCAN_ANON.  Forcing SCAN_ANON will end up thrashing the small list and
leave unreclaimed memory on the file lrus.

If the inactive list is insufficient, fallback to balanced reclaim so the
file lru doesn't remain untouched.

[akpm@linux-foundation.org: fix build]
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1705011432220.137835@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low
+++ a/mm/vmscan.c
@@ -2228,8 +2228,17 @@ static void get_scan_count(struct lruvec
 		}
 
 		if (unlikely(pgdatfile + pgdatfree <= total_high_wmark)) {
-			scan_balance = SCAN_ANON;
-			goto out;
+			/*
+			 * Force SCAN_ANON if there are enough inactive
+			 * anonymous pages on the LRU in eligible zones.
+			 * Otherwise, the small LRU gets thrashed.
+			 */
+			if (!inactive_list_is_low(lruvec, false, memcg, sc, false) &&
+			    lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, sc->reclaim_idx)
+					>> sc->priority) {
+				scan_balance = SCAN_ANON;
+				goto out;
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from rientjes@google.com are


