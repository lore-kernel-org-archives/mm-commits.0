From: akpm@linux-foundation.org
Subject: [merged] vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:30 -0700
Message-ID: <200904011834.n31IYUH6007198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932155AbZDASkL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, ncunningham@crca.org.au, riel@redhat.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     vmscan: clip swap_cluster_max in shrink_all_memory()
has been removed from the -mm tree.  Its filename was
     vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: clip swap_cluster_max in shrink_all_memory()
From: Johannes Weiner <hannes@cmpxchg.org>

shrink_inactive_list() scans in sc->swap_cluster_max chunks until it hits
the scan limit it was passed.

shrink_inactive_list()
{
	do {
		isolate_pages(swap_cluster_max)
		shrink_page_list()
	} while (nr_scanned < max_scan);
}

This assumes that swap_cluster_max is not bigger than the scan limit
because the latter is checked only after at least one iteration.

In shrink_all_memory() sc->swap_cluster_max is initialized to the overall
reclaim goal in the beginning but not decreased while reclaim is making
progress which leads to subsequent calls to shrink_inactive_list()
reclaiming way too much in the one iteration that is done unconditionally.

Set sc->swap_cluster_max always to the proper goal before doing
  shrink_all_zones()
    shrink_list()
      shrink_inactive_list().

While the current shrink_all_memory() happily reclaims more than actually
requested, this patch fixes it to never exceed the goal:

unpatched
   wanted=10000 reclaimed=13356
   wanted=10000 reclaimed=19711
   wanted=10000 reclaimed=10289
   wanted=10000 reclaimed=17306
   wanted=10000 reclaimed=10700
   wanted=10000 reclaimed=10004
   wanted=10000 reclaimed=13301
   wanted=10000 reclaimed=10976
   wanted=10000 reclaimed=10605
   wanted=10000 reclaimed=10088
   wanted=10000 reclaimed=15000

patched
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=9599
   wanted=10000 reclaimed=8476
   wanted=10000 reclaimed=8326
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=9919
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=9624
   wanted=10000 reclaimed=10000
   wanted=10000 reclaimed=10000
   wanted=8500 reclaimed=8092
   wanted=316 reclaimed=316

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: MinChan Kim <minchan.kim@gmail.com>
Acked-by: Nigel Cunningham <ncunningham@crca.org.au>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-clip-swap_cluster_max-in-shrink_all_memory mm/vmscan.c
--- a/mm/vmscan.c~vmscan-clip-swap_cluster_max-in-shrink_all_memory
+++ a/mm/vmscan.c
@@ -2109,7 +2109,6 @@ unsigned long shrink_all_memory(unsigned
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 0,
-		.swap_cluster_max = nr_pages,
 		.may_writepage = 1,
 		.isolate_pages = isolate_pages_global,
 	};
@@ -2151,6 +2150,7 @@ unsigned long shrink_all_memory(unsigned
 			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
 
 			sc.nr_scanned = 0;
+			sc.swap_cluster_max = nr_to_scan;
 			shrink_all_zones(nr_to_scan, prio, pass, &sc);
 			if (sc.nr_reclaimed >= nr_pages)
 				goto out;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
cifs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

