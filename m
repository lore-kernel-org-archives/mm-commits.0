From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-vmscan-if-kswapd-has-been-running-too-long-allow-it-to-sleep.patch removed from -mm tree
Date: Mon, 23 May 2011 12:56:29 -0700
Message-ID: <201105231956.p4NJuUie008528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933290Ab1EWT4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 May 2011 15:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, James.Bottomley@HansenPartnership.com, chris.mason@oracle.com, cl@linux.com, colin.king@canonical.com, jack@suse.cz, minchan.kim@gmail.com, penberg@kernel.org, raghu.


The patch titled
     mm: vmscan: if kswapd has been running too long, allow it to sleep
has been removed from the -mm tree.  Its filename was
     mm-vmscan-if-kswapd-has-been-running-too-long-allow-it-to-sleep.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmscan: if kswapd has been running too long, allow it to sleep
From: Mel Gorman <mgorman@suse.de>

Under constant allocation pressure, kswapd can be in the situation where
sleeping_prematurely() will always return true even if kswapd has been
running a long time.  Check if kswapd needs to be scheduled.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Colin King <colin.king@canonical.com>
Cc: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: <stable@kernel.org>		[2.6.38+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/vmscan.c~mm-vmscan-if-kswapd-has-been-running-too-long-allow-it-to-sleep mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-if-kswapd-has-been-running-too-long-allow-it-to-sleep
+++ a/mm/vmscan.c
@@ -2251,6 +2251,10 @@ static bool sleeping_prematurely(pg_data
 	unsigned long balanced = 0;
 	bool all_zones_ok = true;
 
+	/* If kswapd has been running too long, just sleep */
+	if (need_resched())
+		return false;
+
 	/* If a direct reclaimer woke kswapd within HZ/10, it's premature */
 	if (remaining)
 		return true;
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely.patch
mm-page_allocc-prevent-unending-loop-in-__alloc_pages_slowpath.patch
memcg-remove-unused-retry-signal-from-reclaim.patch

