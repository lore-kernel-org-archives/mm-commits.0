From: akpm@linux-foundation.org
Subject: [merged]
 mm-track-actual-nr_scanned-during-shrink_slab.patch removed from -mm tree
Date: Thu, 07 Sep 2017 11:37:10 -0700
Message-ID: <20170907183710.0lP4KZWhH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755797AbdIGShN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:37:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, cl@linux.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, joonas.lahtinen@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, shli@fb.com, vbabka@suse.cz


The patch titled
     Subject: mm: track actual nr_scanned during shrink_slab()
has been removed from the -mm tree.  Its filename was
     mm-track-actual-nr_scanned-during-shrink_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: mm: track actual nr_scanned during shrink_slab()

Some shrinkers may only be able to free a bunch of objects at a time, and
so free more than the requested nr_to_scan in one pass.  Whilst other
shrinkers may find themselves even unable to scan as many objects as they
counted, and so underreport.  Account for the extra freed/scanned objects
against the total number of objects we intend to scan, otherwise we may
end up penalising the slab far more than intended.  Similarly, we want to
add the underperforming scan to the deferred pass so that we try harder
and harder in future passes.

Link: http://lkml.kernel.org/r/20170822135325.9191-1-chris@chris-wilson.co.uk
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Shaohua Li <shli@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |    7 +++++++
 mm/vmscan.c              |    7 ++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN include/linux/shrinker.h~mm-track-actual-nr_scanned-during-shrink_slab include/linux/shrinker.h
--- a/include/linux/shrinker.h~mm-track-actual-nr_scanned-during-shrink_slab
+++ a/include/linux/shrinker.h
@@ -18,6 +18,13 @@ struct shrink_control {
 	 */
 	unsigned long nr_to_scan;
 
+	/*
+	 * How many objects did scan_objects process?
+	 * This defaults to nr_to_scan before every call, but the callee
+	 * should track its actual progress.
+	 */
+	unsigned long nr_scanned;
+
 	/* current node being shrunk (for NUMA aware shrinkers) */
 	int nid;
 
diff -puN mm/vmscan.c~mm-track-actual-nr_scanned-during-shrink_slab mm/vmscan.c
--- a/mm/vmscan.c~mm-track-actual-nr_scanned-during-shrink_slab
+++ a/mm/vmscan.c
@@ -393,14 +393,15 @@ static unsigned long do_shrink_slab(stru
 		unsigned long nr_to_scan = min(batch_size, total_scan);
 
 		shrinkctl->nr_to_scan = nr_to_scan;
+		shrinkctl->nr_scanned = nr_to_scan;
 		ret = shrinker->scan_objects(shrinker, shrinkctl);
 		if (ret == SHRINK_STOP)
 			break;
 		freed += ret;
 
-		count_vm_events(SLABS_SCANNED, nr_to_scan);
-		total_scan -= nr_to_scan;
-		scanned += nr_to_scan;
+		count_vm_events(SLABS_SCANNED, shrinkctl->nr_scanned);
+		total_scan -= shrinkctl->nr_scanned;
+		scanned += shrinkctl->nr_scanned;
 
 		cond_resched();
 	}
_

Patches currently in -mm which might be from chris@chris-wilson.co.uk are


