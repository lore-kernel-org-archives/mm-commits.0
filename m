From: akpm@linux-foundation.org
Subject: [merged] vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:09:42 -0700
Message-ID: <201111012109.pA1L9g2A032231@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15457 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab1KAVJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, mgorman@suse.de, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: count pages into balanced for zone with good watermark
has been removed from the -mm tree.  Its filename was
     vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: vmscan: count pages into balanced for zone with good watermark

It's possible a zone watermark is ok when entering the balance_pgdat()
loop, while the zone is within the requested classzone_idx.  Count pages
from this zone into `balanced'.  In this way, we can skip shrinking zones
too much for high order allocation.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~vmscan-count-pages-into-balanced-for-zone-with-good-watermark mm/vmscan.c
--- a/mm/vmscan.c~vmscan-count-pages-into-balanced-for-zone-with-good-watermark
+++ a/mm/vmscan.c
@@ -2748,6 +2748,8 @@ out:
 
 			/* If balanced, clear the congested flag */
 			zone_clear_flag(zone, ZONE_CONGESTED);
+			if (i <= *classzone_idx)
+				balanced += zone->present_pages;
 		}
 	}
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
block-avoid-unnecessary-plug-list-flush.patch
block-add-missed-trace_block_plug.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

