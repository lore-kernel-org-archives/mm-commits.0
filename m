From: akpm@linux-foundation.org
Subject: - vmscan-fix-get_scan_ratio-comment.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:20 -0800
Message-ID: <200811202043.mAKKhKKK007454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbYKTUsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: fix get_scan_ratio() comment
has been removed from the -mm tree.  Its filename was
     vmscan-fix-get_scan_ratio-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: fix get_scan_ratio() comment
From: Rik van Riel <riel@redhat.com>

Fix the old comment on the scan ratio calculations.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~vmscan-fix-get_scan_ratio-comment mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-get_scan_ratio-comment
+++ a/mm/vmscan.c
@@ -1389,9 +1389,9 @@ static void get_scan_ratio(struct zone *
 	file_prio = 200 - sc->swappiness;
 
 	/*
-	 *                  anon       recent_rotated[0]
-	 * %anon = 100 * ----------- / ----------------- * IO cost
-	 *               anon + file      rotate_sum
+	 * The amount of pressure on anon vs file pages is inversely
+	 * proportional to the fraction of recently scanned pages on
+	 * each list that were recently referenced and in active use.
 	 */
 	ap = (anon_prio + 1) * (zone->recent_scanned[0] + 1);
 	ap /= zone->recent_rotated[0] + 1;
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
vmscan-evict-streaming-io-first.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

