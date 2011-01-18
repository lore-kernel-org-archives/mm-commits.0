From: akpm@linux-foundation.org
Subject: + mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch added to -mm tree
Date: Tue, 18 Jan 2011 15:08:00 -0800
Message-ID: <201101182308.p0IN81gX011115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040Ab1ARXIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 18:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     mm: compaction: prevent division-by-zero during user-requested compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch

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

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction
+++ a/mm/compaction.c
@@ -453,6 +453,9 @@ unsigned long compaction_suitable(struct
 	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 		return COMPACT_SKIPPED;
 
+	if (order == -1)
+		return COMPACT_CONTINUE;
+
 	/*
 	 * fragmentation index determines if allocation failures are due to
 	 * low memory or external fragmentation
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
mm-deactivate-invalidated-pages.patch

