From: akpm@linux-foundation.org
Subject: +
 mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
 added to -mm tree
Date: Tue, 07 Mar 2017 15:27:28 -0800
Message-ID: <58bf41e0.0f7pb3CBHup0p3EP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51990 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756511AbdCHAVP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 19:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: remove redundant watermark check in compact_finished()
has been added to the -mm tree.  Its filename is
     mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: remove redundant watermark check in compact_finished()

When detecting whether compaction has succeeded in forming a high-order
page, __compact_finished() employs a watermark check, followed by an own
search for a suitable page in the freelists.  This is not ideal for two
reasons:

- The watermark check also searches high-order freelists, but has a less
  strict criteria wrt fallback.  It's therefore redundant and waste of
  cycles.  This was different in the past when high-order watermark check
  attempted to apply reserves to high-order pages.

- The watermark check might actually fail due to lack of order-0 pages. 
  Compaction can't help with that, so there's no point in continuing
  because of that.  It's possible that high-order page still exists and it
  terminates.

This patch therefore removes the watermark check.  This should save some
cycles and terminate compaction sooner in some cases.

Link: http://lkml.kernel.org/r/20170307131545.28577-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/compaction.c~mm-compaction-remove-redundant-watermark-check-in-compact_finished mm/compaction.c
--- a/mm/compaction.c~mm-compaction-remove-redundant-watermark-check-in-compact_finished
+++ a/mm/compaction.c
@@ -1280,7 +1280,6 @@ static enum compact_result __compact_fin
 			    const int migratetype)
 {
 	unsigned int order;
-	unsigned long watermark;
 
 	if (cc->contended || fatal_signal_pending(current))
 		return COMPACT_CONTENDED;
@@ -1308,13 +1307,6 @@ static enum compact_result __compact_fin
 	if (is_via_compact_memory(cc->order))
 		return COMPACT_CONTINUE;
 
-	/* Compaction run is not finished if the watermark is not met */
-	watermark = zone->watermark[cc->alloc_flags & ALLOC_WMARK_MASK];
-
-	if (!zone_watermark_ok(zone, cc->order, watermark, cc->classzone_idx,
-							cc->alloc_flags))
-		return COMPACT_CONTINUE;
