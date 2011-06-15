From: akpm@linux-foundation.org
Subject: + compaction-checks-correct-fragmentation-index.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:17 -0700
Message-ID: <201106150124.p5F1OYNQ031954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533Ab1FOBZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     compaction: checks correct fragmentation index
has been added to the -mm tree.  Its filename is
     compaction-checks-correct-fragmentation-index.patch

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
Subject: compaction: checks correct fragmentation index
From: Shaohua Li <shaohua.li@intel.com>

fragmentation_index() returns -1000 when the allocation might succeed
This doesn't match the comment and code in compaction_suitable(). I
thought compaction_suitable should return COMPACT_PARTIAL in -1000
case, because in this case allocation could succeed depending on
watermarks.

The impact of this is that compaction starts and compact_finished() is
called which rechecks the watermarks and the free lists.  It should have
the same result in that compaction should not start but is more expensive.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~compaction-checks-correct-fragmentation-index mm/compaction.c
--- a/mm/compaction.c~compaction-checks-correct-fragmentation-index
+++ a/mm/compaction.c
@@ -480,7 +480,8 @@ unsigned long compaction_suitable(struct
 	 * fragmentation index determines if allocation failures are due to
 	 * low memory or external fragmentation
 	 *
-	 * index of -1 implies allocations might succeed dependingon watermarks
+	 * index of -1000 implies allocations might succeed depending on
+	 * watermarks
 	 * index towards 0 implies failure is due to lack of memory
 	 * index towards 1000 implies failure is due to fragmentation
 	 *
@@ -490,7 +491,8 @@ unsigned long compaction_suitable(struct
 	if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
 		return COMPACT_SKIPPED;
 
-	if (fragindex == -1 && zone_watermark_ok(zone, order, watermark, 0, 0))
+	if (fragindex == -1000 && zone_watermark_ok(zone, order, watermark,
+	    0, 0))
 		return COMPACT_PARTIAL;
 
 	return COMPACT_CONTINUE;
_

Patches currently in -mm which might be from shaohua.li@intel.com are

compaction-checks-correct-fragmentation-index.patch
linux-next.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

