From: akpm@linux-foundation.org
Subject: +
 mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
 added to -mm tree
Date: Tue, 28 Feb 2017 15:53:24 -0800
Message-ID: <58b60d74.6fMJztaLD8BQ909J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdB1XzF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 18:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix check for reclaimable pages in PF_MEMALLOC reclaim throttling
has been added to the -mm tree.  Its filename is
     mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fix check for reclaimable pages in PF_MEMALLOC reclaim throttling

PF_MEMALLOC direct reclaimers get throttled on a node when the sum of all
free pages in each zone fall below half the min watermark.  During the
summation, we want to exclude zones that don't have reclaimables. 
Checking the same pgdat over and over again doesn't make sense.

Fixes: 599d0c954f91 ("mm, vmscan: move LRU lists to node")
Link: http://lkml.kernel.org/r/20170228214007.5621-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jia He <hejianet@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling
+++ a/mm/vmscan.c
@@ -2831,8 +2831,10 @@ static bool pfmemalloc_watermark_ok(pg_d
 
 	for (i = 0; i <= ZONE_NORMAL; i++) {
 		zone = &pgdat->node_zones[i];
-		if (!managed_zone(zone) ||
-		    pgdat_reclaimable_pages(pgdat) == 0)
+		if (!managed_zone(zone))
+			continue;
+
+		if (!zone_reclaimable_pages(zone))
 			continue;
 
 		pfmemalloc_reserve += min_wmark_pages(zone);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch

