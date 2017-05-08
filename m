From: akpm@linux-foundation.org
Subject: [patch 002/114] mm, compaction: remove redundant watermark
 check in compact_finished()
Date: Mon, 08 May 2017 15:54:33 -0700
Message-ID: <20170508225433.1x8lyaYhv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdEHWyf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

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
