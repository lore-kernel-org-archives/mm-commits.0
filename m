Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A670EE94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbjJFVtR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbjJFVtQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:49:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF9BCF
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:49:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02528C433C8;
        Fri,  6 Oct 2023 21:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628946;
        bh=R1C8FeWOsKmkMvHMgOVSdrWK9o+3lR23rmv8tIzed2k=;
        h=Date:To:From:Subject:From;
        b=J2IQL1/n+xu8nJyQvtYCG2RszGMBWHsY78I4F1WK86GFHJ/nYraf5K/G1YjATw6I1
         +8gkIKKVAyJNKtWslxzxtFVfTo3y8YhAOoQdN0pofZlfgPtg5+h0we/HfYHYxbl93e
         OeQLZ7XVI17GsAWs4ZUOaNTw/w6FkZjgv7W0LtuE=
Date:   Fri, 06 Oct 2023 14:49:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch removed from -mm tree
Message-Id: <20231006214906.02528C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, pcp: decrease PCP high if free pages < high watermark
has been removed from the -mm tree.  Its filename was
     mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, pcp: decrease PCP high if free pages < high watermark
Date: Tue, 26 Sep 2023 14:09:09 +0800

One target of PCP is to minimize pages in PCP if the system free pages is
too few.  To reach that target, when page reclaiming is active for the
zone (ZONE_RECLAIM_ACTIVE), we will stop increasing PCP high in allocating
path, decrease PCP high and free some pages in freeing path.  But this may
be too late because the background page reclaiming may introduce latency
for some workloads.  So, in this patch, during page allocation we will
detect whether the number of free pages of the zone is below high
watermark.  If so, we will stop increasing PCP high in allocating path,
decrease PCP high and free some pages in freeing path.  With this, we can
reduce the possibility of the premature background page reclaiming caused
by too large PCP.

The high watermark checking is done in allocating path to reduce the
overhead in hotter freeing path.

Link: https://lkml.kernel.org/r/20230926060911.266511-9-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |   22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-pcp-decrease-pcp-high-if-free-pages-high-watermark
+++ a/include/linux/mmzone.h
@@ -1004,6 +1004,7 @@ enum zone_flags {
 					 * Cleared when kswapd is woken.
 					 */
 	ZONE_RECLAIM_ACTIVE,		/* kswapd may be scanning the zone. */
+	ZONE_BELOW_HIGH,		/* zone is below high watermark. */
 };
 
 static inline unsigned long zone_managed_pages(struct zone *zone)
--- a/mm/page_alloc.c~mm-pcp-decrease-pcp-high-if-free-pages-high-watermark
+++ a/mm/page_alloc.c
@@ -2409,7 +2409,13 @@ static int nr_pcp_high(struct per_cpu_pa
 		return min(batch << 2, pcp->high);
 	}
 
-	if (pcp->count >= high && high_min != high_max) {
+	if (high_min == high_max)
+		return high;
+
+	if (test_bit(ZONE_BELOW_HIGH, &zone->flags)) {
+		pcp->high = max(high - (batch << pcp->free_factor), high_min);
+		high = max(pcp->count, high_min);
+	} else if (pcp->count >= high) {
 		int need_high = (batch << pcp->free_factor) + batch;
 
 		/* pcp->high should be large enough to hold batch freed pages */
@@ -2459,6 +2465,10 @@ static void free_unref_page_commit(struc
 	if (pcp->count >= high) {
 		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
 				   pcp, pindex);
+		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
+		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
+				      ZONE_MOVABLE, 0))
+			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
 	}
 }
 
@@ -2765,7 +2775,7 @@ static int nr_pcp_alloc(struct per_cpu_p
 	 * If we had larger pcp->high, we could avoid to allocate from
 	 * zone.
 	 */
-	if (high_min != high_max && !test_bit(ZONE_RECLAIM_ACTIVE, &zone->flags))
+	if (high_min != high_max && !test_bit(ZONE_BELOW_HIGH, &zone->flags))
 		high = pcp->high = min(high + batch, high_max);
 
 	if (!order) {
@@ -3226,6 +3236,14 @@ retry:
 			}
 		}
 
+		mark = high_wmark_pages(zone);
+		if (zone_watermark_fast(zone, order, mark,
+					ac->highest_zoneidx, alloc_flags,
+					gfp_mask))
+			goto try_this_zone;
+		else if (!test_bit(ZONE_BELOW_HIGH, &zone->flags))
+			set_bit(ZONE_BELOW_HIGH, &zone->flags);
+
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch

