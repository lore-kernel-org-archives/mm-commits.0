From: akpm@linux-foundation.org
Subject: + vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch added to -mm tree
Date: Fri, 19 Aug 2011 16:47:36 -0700
Message-ID: <201108192347.p7JNla2n031821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab1HSXrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Aug 2011 19:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, mgorman@suse.de, minchan.kim@gmail.com


The patch titled
     vmscan: count pages into balanced for zone with good watermark
has been added to the -mm tree.  Its filename is
     vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch

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
Subject: vmscan: count pages into balanced for zone with good watermark
From: Shaohua Li <shaohua.li@intel.com>

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
@@ -2758,6 +2758,8 @@ out:
 
 			/* If balanced, clear the congested flag */
 			zone_clear_flag(zone, ZONE_CONGESTED);
+			if (i <= *classzone_idx)
+				balanced += zone->present_pages;
 		}
 	}
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
mm-fix-a-vmscan-warning.patch
linux-next.patch
vmscan-add-block-plug-for-page-reclaim.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

