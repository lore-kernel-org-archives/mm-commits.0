From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-prevent-kswapd-sleeping-prematurely-due-to-mismatched-classzone_idx-fix.patch removed from -mm tree
Date: Wed, 03 May 2017 14:38:17 -0700
Message-ID: <590a4dc9.BuKem005y+CjIoj8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdECViS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:38:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: prevent kswapd sleeping prematurely due to mismatched classzone_idx -fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-prevent-kswapd-sleeping-prematurely-due-to-mismatched-classzone_idx-fix.patch

This patch was dropped because it was folded into mm-vmscan-prevent-kswapd-sleeping-prematurely-due-to-mismatched-classzone_idx.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm, vmscan: prevent kswapd sleeping prematurely due to mismatched classzone_idx -fix

The patch "mm, vmscan: prevent kswapd sleeping prematurely due to mismatched
classzone_idx" has different initial starting conditions when kswapd
is asleep. kswapd initialises it properly when it starts but the patch
initialises kswapd_classzone_idx early and trips on a warning in
free_area_init_node. This patch leaves the kswapd_classzone_idx as zero
and defers to kswapd to initialise it properly when it starts.

This is a fix to the mmotm patch
mm-vmscan-prevent-kswapd-sleeping-prematurely-due-to-mismatched-classzone_idx.patch

Link: http://lkml.kernel.org/r/20170406174538.5msrznj6nt6qpbx5@suse.de
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~mm-vmscan-prevent-kswapd-sleeping-prematurely-due-to-mismatched-classzone_idx-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-vmscan-prevent-kswapd-sleeping-prematurely-due-to-mismatched-classzone_idx-fix
+++ a/mm/memory_hotplug.c
@@ -1212,10 +1212,14 @@ static pg_data_t __ref *hotadd_new_pgdat
 
 		arch_refresh_nodedata(nid, pgdat);
 	} else {
-		/* Reset the nr_zones, order and classzone_idx before reuse */
+		/*
+		 * Reset the nr_zones, order and classzone_idx before reuse.
+		 * Note that kswapd will init kswapd_classzone_idx properly
+		 * when it starts in the near future.
+		 */
 		pgdat->nr_zones = 0;
 		pgdat->kswapd_order = 0;
-		pgdat->kswapd_classzone_idx = MAX_NR_ZONES;
+		pgdat->kswapd_classzone_idx = 0;
 	}
 
 	/* we can use NODE_DATA(nid) from here */
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-vmscan-prevent-kswapd-sleeping-prematurely-due-to-mismatched-classzone_idx.patch

