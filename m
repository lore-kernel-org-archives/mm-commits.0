From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch added to
 -mm tree
Date: Thu, 11 Aug 2016 14:30:01 -0700
Message-ID: <57acee59.9vRSpcwFg4Q+lbWg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbcHKVaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 17:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: make compaction_ready() more accurate and readable
has been added to the -mm tree.  Its filename is
     mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch

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
Subject: mm, vmscan: make compaction_ready() more accurate and readable

The compaction_ready() is used during direct reclaim for costly order
allocations to skip reclaim for zones where compaction should be attempted
instead.  It's combining the standard compaction_suitable() check with its
own watermark check based on high watermark with extra gap, and the result
is confusing at best.

This patch attempts to better structure and document the checks involved. 
First, compaction_suitable() can determine that the allocation should
either succeed already, or that compaction doesn't have enough free pages
to proceed.  The third possibility is that compaction has enough free
pages, but we still decide to reclaim first - unless we are already above
the high watermark with gap.  This does not mean that the reclaim will
actually reach this watermark during single attempt, this is rather an
over-reclaim protection.  So document the code as such.  The check for
compaction_deferred() is removed completely, as it in fact had no proper
role here.

The result after this patch is mainly a less confusing code.  We also skip
some over-reclaim in cases where the allocation should already succed.

Link: http://lkml.kernel.org/r/20160810091226.6709-12-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-make-compaction_ready-more-accurate-and-readable mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-make-compaction_ready-more-accurate-and-readable
+++ a/mm/vmscan.c
@@ -2617,38 +2617,35 @@ static bool shrink_node(pg_data_t *pgdat
 }
 
 /*
- * Returns true if compaction should go ahead for a high-order request, or
- * the high-order allocation would succeed without compaction.
+ * Returns true if compaction should go ahead for a costly-order request, or
+ * the allocation would already succeed without compaction. Return false if we
+ * should reclaim first.
  */
 static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 {
 	unsigned long watermark;
-	bool watermark_ok;
+	enum compact_result suitable;
 
-	/*
-	 * Compaction takes time to run and there are potentially other
-	 * callers using the pages just freed. Continue reclaiming until
-	 * there is a buffer of free pages available to give compaction
-	 * a reasonable chance of completing and allocating the page
-	 */
-	watermark = high_wmark_pages(zone) + compact_gap(sc->order);
-	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, sc->reclaim_idx);
-
-	/*
-	 * If compaction is deferred, reclaim up to a point where
-	 * compaction will have a chance of success when re-enabled
-	 */
-	if (compaction_deferred(zone, sc->order))
-		return watermark_ok;
+	suitable = compaction_suitable(zone, sc->order, 0, sc->reclaim_idx);
+	if (suitable == COMPACT_SUCCESS)
+		/* Allocation should succeed already. Don't reclaim. */
+		return true;
+	if (suitable == COMPACT_SKIPPED)
+		/* Compaction cannot yet proceed. Do reclaim. */
+		return false;
 
 	/*
-	 * If compaction is not ready to start and allocation is not likely
-	 * to succeed without it, then keep reclaiming.
+	 * Compaction is already possible, but it takes time to run and there
+	 * are potentially other callers using the pages just freed. So proceed
+	 * with reclaim to make a buffer of free pages available to give
+	 * compaction a reasonable chance of completing and allocating the page.
+	 * Note that we won't actually reclaim the whole buffer in one attempt
+	 * as the target watermark in should_continue_reclaim() is lower. But if
+	 * we are already above the high+gap watermark, don't reclaim at all.
 	 */
-	if (compaction_suitable(zone, sc->order, 0, sc->reclaim_idx) == COMPACT_SKIPPED)
-		return false;
+	watermark = high_wmark_pages(zone) + compact_gap(sc->order);
 
-	return watermark_ok;
+	return zone_watermark_ok_safe(zone, 0, watermark, sc->reclaim_idx);
 }
 
 /*
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch

