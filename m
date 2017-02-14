From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure.patch removed from -mm
 tree
Date: Tue, 14 Feb 2017 14:51:50 -0800
Message-ID: <58a38a06.a+VcQNPO6S3kugLJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58064 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdBNWvv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 17:51:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vinmenon@codeaurora.org, anton.vorontsov@linaro.org, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, shashim@codeaurora.org, vbabka@suse.cz, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not pass reclaimed slab to vmpressure
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: mm: vmscan: do not pass reclaimed slab to vmpressure

During global reclaim, the nr_reclaimed passed to vmpressure includes the
pages reclaimed from slab.  But the corresponding scanned slab pages is
not passed.  This can cause total reclaimed pages to be greater than
scanned, causing an unsigned underflow in vmpressure resulting in a
critical event being sent to root cgroup.  So do not consider reclaimed
slab pages for vmpressure calculation.  The reclaimed pages from slab can
be excluded because the freeing of a page by slab shrinking depends on
each slab's object population, making the cost model (i.e.  scan:free)
different from that of LRU.  Also, not every shrinker accounts the pages
it reclaims.

This is a regression introduced by commit 6b4f7799c6a5 ("mm: vmscan:
invoke slab shrinkers from shrink_zone()").

Fixes: 6b4f7799c6a5 ("mm: vmscan: invoke slab shrinkers from shrink_zone()")
Link: http://lkml.kernel.org/r/1485853328-7672-1-git-send-email-vinmenon@codeaurora.org
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Shiraz Hashim <shashim@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure
+++ a/mm/vmscan.c
@@ -2603,16 +2603,23 @@ static bool shrink_node(pg_data_t *pgdat
 				    sc->nr_scanned - nr_scanned,
 				    node_lru_pages);
 
+		/*
+		 * Record the subtree's reclaim efficiency. The reclaimed
+		 * pages from slab is excluded here because the corresponding
+		 * scanned pages is not accounted. Moreover, freeing a page
+		 * by slab shrinking depends on each slab's object population,
+		 * making the cost model (i.e. scan:free) different from that
+		 * of LRU.
+		 */
+		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+			   sc->nr_scanned - nr_scanned,
+			   sc->nr_reclaimed - nr_reclaimed);
+
 		if (reclaim_state) {
 			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 			reclaim_state->reclaimed_slab = 0;
 		}
 
-		/* Record the subtree's reclaim efficiency */
-		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
-			   sc->nr_scanned - nr_scanned,
-			   sc->nr_reclaimed - nr_reclaimed);
