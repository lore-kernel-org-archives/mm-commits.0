From: akpm@linux-foundation.org
Subject: + vmscan-avoid-set-zone-congested-if-no-page-dirty.patch added to -mm tree
Date: Wed, 10 Nov 2010 15:16:45 -0800
Message-ID: <201011102316.oAANGjFF011712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753973Ab0KJXRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 18:17:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, hannes@cmpxchg.org, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     vmscan: avoid setting zone congested if no page dirty
has been added to the -mm tree.  Its filename is
     vmscan-avoid-set-zone-congested-if-no-page-dirty.patch

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
Subject: vmscan: avoid setting zone congested if no page dirty
From: Shaohua Li <shaohua.li@intel.com>

nr_dirty and nr_congested are increased only when the page is dirty.  So
if all pages are clean, both them will be zero.  In this case, we should
not mark the zone congested.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-avoid-set-zone-congested-if-no-page-dirty mm/vmscan.c
--- a/mm/vmscan.c~vmscan-avoid-set-zone-congested-if-no-page-dirty
+++ a/mm/vmscan.c
@@ -913,7 +913,7 @@ keep_lumpy:
 	 * back off and wait for congestion to clear because further reclaim
 	 * will encounter the same problem
 	 */
-	if (nr_dirty == nr_congested)
+	if (nr_dirty == nr_congested && nr_dirty != 0)
 		zone_set_flag(zone, ZONE_CONGESTED);
 
 	free_page_list(&free_pages);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
vmscan-avoid-set-zone-congested-if-no-page-dirty.patch

