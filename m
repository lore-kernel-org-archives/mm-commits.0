From: akpm@linux-foundation.org
Subject: [merged] vmscan-clear-zone_congested-for-zone-with-good-watermark-resend.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:39 -0700
Message-ID: <201108261903.p7QJ3NGl005678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085Ab1HZTD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:03:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, mgorman@suse.de, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: clear ZONE_CONGESTED for zone with good watermark
has been removed from the -mm tree.  Its filename was
     vmscan-clear-zone_congested-for-zone-with-good-watermark-resend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: clear ZONE_CONGESTED for zone with good watermark
From: Shaohua Li <shaohua.li@intel.com>

ZONE_CONGESTED is only cleared in kswapd, but pages can be freed in any
task.  It's possible ZONE_CONGESTED isn't cleared in some cases: 1.  the
zone is already balanced just entering balance_pgdat() for order-0 because
concurrent tasks free memory.  In this case, later check will skip the
zone as it's balanced so the flag isn't cleared.  2.  high order balance
fallbacks to order-0.  quote from Mel: At the end of balance_pgdat(),
kswapd uses the following logic;

 If reclaiming at high order {
     for each zone {
             if all_unreclaimable
                     skip
             if watermark is not met
                     order = 0
                     loop again

             /* watermark is met */
             clear congested
     }
 }

i.e.  it clears ZONE_CONGESTED if it the zone is balanced.  if not, it
restarts balancing at order-0.  However, if the higher zones are balanced
for order-0, kswapd will miss clearing ZONE_CONGESTED as that only happens
after a zone is shrunk.  This can mean that wait_iff_congested() stalls
unnecessarily.  This patch makes kswapd clear ZONE_CONGESTED during its
initial highmem->dma scan for zones that are already balanced.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/vmscan.c~vmscan-clear-zone_congested-for-zone-with-good-watermark-resend mm/vmscan.c
--- a/mm/vmscan.c~vmscan-clear-zone_congested-for-zone-with-good-watermark-resend
+++ a/mm/vmscan.c
@@ -2529,6 +2529,9 @@ loop_again:
 					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
 				break;
+			} else {
+				/* If balanced, clear the congested flag */
+				zone_clear_flag(zone, ZONE_CONGESTED);
 			}
 		}
 		if (i < 0)
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
vmscan-add-block-plug-for-page-reclaim.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

