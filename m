From: akpm@linux-foundation.org
Subject: + vmscan-fix-get_scan_ratio-comment.patch added to -mm tree
Date: Tue, 18 Nov 2008 19:44:55 -0800
Message-ID: <200811190344.mAJ3itLO027361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbYKSDpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 22:45:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     vmscan: fix get_scan_ratio() comment
has been added to the -mm tree.  Its filename is
     vmscan-fix-get_scan_ratio-comment.patch

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

vmscan-let-gfp_nofs-go-to-swap-again.patch
vmscan-fix-get_scan_ratio-comment.patch
linux-next.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

