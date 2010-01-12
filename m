From: akpm@linux-foundation.org
Subject: [to-be-updated] vmscan-kswapd-should-notice-that-all-zones-are-not-ok-if-they-are-unreclaimble.patch removed from -mm tree
Date: Tue, 12 Jan 2010 14:19:21 -0800
Message-ID: <201001122219.o0CMJLRW031051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab0ALWUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 17:20:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, elendil@planet.nl, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, will.newton@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: kswapd should notice that all zones are not ok if they are unreclaimble
has been removed from the -mm tree.  Its filename was
     vmscan-kswapd-should-notice-that-all-zones-are-not-ok-if-they-are-unreclaimble.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: kswapd should notice that all zones are not ok if they are unreclaimble
From: Mel Gorman <mel@csn.ul.ie>

Commit f50de2d3 ("vmscan: have kswapd sleep for a short interval and
double check it should be asleep") can cause kswapd to enter an infinite
loop if running on a single-CPU system.  If all zones are unreclaimble,
kswapd thinks "all zones are ok" and prepares to go to sleep.  However,
the zones are not ok because the watermarks are not met so it stays awake
but never calls cond_resched().

This patch notes that if all zones are unreclaimable then the zones are
not ok.  It falls through and cond_resched() gets called.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: Will Newton <will.newton@gmail.com>
Cc: Frans Pop <elendil@planet.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-kswapd-should-notice-that-all-zones-are-not-ok-if-they-are-unreclaimble mm/vmscan.c
--- a/mm/vmscan.c~vmscan-kswapd-should-notice-that-all-zones-are-not-ok-if-they-are-unreclaimble
+++ a/mm/vmscan.c
@@ -2027,8 +2027,10 @@ loop_again:
 				break;
 			}
 		}
-		if (i < 0)
+		if (i < 0) {
+			all_zones_ok = 0;
 			goto out;
+		}
 
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page-allocator-fix-update-nr_free_pages-only-as-necessary.patch
mm-page_alloc-fix-the-range-check-for-backward-merging.patch
vmscan-kswapd-should-notice-that-all-zones-are-not-ok-if-they-are-unreclaimble.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
nodemaskh-remove-macro-any_online_node.patch
add-debugging-aid-for-memory-initialisation-problems.patch

