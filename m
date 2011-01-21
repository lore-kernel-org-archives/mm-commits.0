From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch removed from -mm tree
Date: Fri, 21 Jan 2011 12:31:33 -0800
Message-ID: <201101212031.p0LKVXWH031616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab1AUUci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 15:32:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: prevent division-by-zero during user-requested compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: prevent division-by-zero during user-requested compaction
From: Johannes Weiner <hannes@cmpxchg.org>

Up until 3e7d344 ("mm: vmscan: reclaim order-0 and use compaction instead
of lumpy reclaim"), compaction skipped calculating the fragmentation index
of a zone when compaction was explicitely requested through the procfs
knob.

However, when compaction_suitable was introduced, it did not come with an
extra check for order == -1, set on explicit compaction requests, and
passed this order on to the fragmentation index calculation, where it
overshifts the number of requested pages, leading to a division by zero.

This patch makes sure that order == -1 is recognized as the flag it is
rather than passing it along as valid order parameter.

[akpm@linux-foundation.org: add comment, per Mel]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction
+++ a/mm/compaction.c
@@ -406,6 +406,10 @@ static int compact_finished(struct zone 
 	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
 		return COMPACT_CONTINUE;
 
+	/*
+	 * order == -1 is expected when compacting via
+	 * /proc/sys/vm/compact_memory
+	 */
 	if (cc->order == -1)
 		return COMPACT_CONTINUE;
 
@@ -454,6 +458,13 @@ unsigned long compaction_suitable(struct
 		return COMPACT_SKIPPED;
 
 	/*
+	 * order == -1 is expected when compacting via
+	 * /proc/sys/vm/compact_memory
+	 */
+	if (order == -1)
+		return COMPACT_CONTINUE;
+
+	/*
 	 * fragmentation index determines if allocation failures are due to
 	 * low memory or external fragmentation
 	 *
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch

