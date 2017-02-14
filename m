From: akpm@linux-foundation.org
Subject: + mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure.patch added
 to -mm tree
Date: Tue, 14 Feb 2017 14:54:12 -0800
Message-ID: <58a38a94.nb3wSoo24sv+3Kju%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdBNWyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 17:54:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vinmenon@codeaurora.org, anton.vorontsov@linaro.org, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, shashim@codeaurora.org, vbabka@suse.cz, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not pass reclaimed slab to vmpressure
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: mm: vmscan: do not pass reclaimed slab to vmpressure

During global reclaim, the nr_reclaimed passed to vmpressure includes the
pages reclaimed from slab.  But the corresponding scanned slab pages is
not passed.  There is an impact to the vmpressure values because of this. 
While moving from kernel version 3.18 to 4.4, a difference is seen in the
vmpressure values for the same workload resulting in a different behaviour
of the vmpressure consumer.  One such case is of a vmpressure based
lowmemorykiller.  It is observed that the vmpressure events are received
late and less in number resulting in tasks not being killed at the right
time.  The following numbers show the impact on reclaim activity due to
the change in behaviour of lowmemorykiller on a 4GB device.  The test
launches a number of apps in sequence and repeats it multiple times.

                      v4.4           v3.18
pgpgin                163016456      145617236
pgpgout               4366220        4188004
workingset_refault    29857868       26781854
workingset_activate   6293946        5634625
pswpin                1327601        1133912
pswpout               3593842        3229602
pgalloc_dma           99520618       94402970
pgalloc_normal        104046854      98124798
pgfree                203772640      192600737
pgmajfault            2126962        1851836
pgsteal_kswapd_dma    19732899       18039462
pgsteal_kswapd_normal 19945336       17977706
pgsteal_direct_dma    206757         131376
pgsteal_direct_normal 236783         138247
pageoutrun            116622         108370
allocstall            7220           4684
compact_stall         931            856

This is a regression introduced by commit 6b4f7799c6a5 ("mm: vmscan:
invoke slab shrinkers from shrink_zone()").

So do not consider reclaimed slab pages for vmpressure calculation.  The
reclaimed pages from slab can be excluded because the freeing of a page by
slab shrinking depends on each slab's object population, making the cost
model (i.e.  scan:free) different from that of LRU.  Also, not every
shrinker accounts the pages it reclaims.  But ideally the pages reclaimed
from slab should be passed to vmpressure, otherwise higher vmpressure
levels can be triggered even when there is a reclaim progress.  But
accounting only the reclaimed slab pages without the scanned, and adding
something which does not fit into the cost model just adds noise to the
vmpressure values.

Fixes: 6b4f7799c6a5 ("mm: vmscan: invoke slab shrinkers from shrink_zone()")
Link: http://lkml.kernel.org/r/1486641577-11685-2-git-send-email-vinmenon@codeaurora.org
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
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
