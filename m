Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328DFC41513
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjJPWuD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbjJPWty (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:49:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB48B4
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:49:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B462AC433C9;
        Mon, 16 Oct 2023 22:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697496592;
        bh=k3gDXRzXZArJsXPUM0Z1Mro0wi4FepTFI6d1p+Bd4tk=;
        h=Date:To:From:Subject:From;
        b=2UNAvseSxDlv0ikaG6J89rTWI8YDjGpFVrAeeCw3y3Z3iJtXA3rCK8Hgh9ogbSFkK
         LFzR46YiQGFFZ0UC7rxuNGDEEBXN0oBxEsNfub+sCEGnirScWrNHI9qsPEMFI2GNkJ
         k7KfU7XS1VcF4eNhfl5ecNlZ7bq5IeNKqbW5zM0U=
Date:   Mon, 16 Oct 2023 15:49:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch added to mm-unstable branch
Message-Id: <20231016224952.B462AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, pcp: decrease PCP high if free pages < high watermark
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, pcp: decrease PCP high if free pages < high watermark
Date: Mon, 16 Oct 2023 13:30:01 +0800

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

Link: https://lkml.kernel.org/r/20231016053002.756205-9-ying.huang@intel.com
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
 mm/page_alloc.c        |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-pcp-decrease-pcp-high-if-free-pages-high-watermark
+++ a/include/linux/mmzone.h
@@ -1030,6 +1030,7 @@ enum zone_flags {
 					 * Cleared when kswapd is woken.
 					 */
 	ZONE_RECLAIM_ACTIVE,		/* kswapd may be scanning the zone. */
+	ZONE_BELOW_HIGH,		/* zone is below high watermark. */
 };
 
 static inline unsigned long zone_managed_pages(struct zone *zone)
--- a/mm/page_alloc.c~mm-pcp-decrease-pcp-high-if-free-pages-high-watermark
+++ a/mm/page_alloc.c
@@ -2443,7 +2443,13 @@ static int nr_pcp_high(struct per_cpu_pa
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
@@ -2493,6 +2499,10 @@ static void free_unref_page_commit(struc
 	if (pcp->count >= high) {
 		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
 				   pcp, pindex);
+		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
+		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
+				      ZONE_MOVABLE, 0))
+			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
 	}
 }
 
@@ -2799,7 +2809,7 @@ static int nr_pcp_alloc(struct per_cpu_p
 	 * If we had larger pcp->high, we could avoid to allocate from
 	 * zone.
 	 */
-	if (high_min != high_max && !test_bit(ZONE_RECLAIM_ACTIVE, &zone->flags))
+	if (high_min != high_max && !test_bit(ZONE_BELOW_HIGH, &zone->flags))
 		high = pcp->high = min(high + batch, high_max);
 
 	if (!order) {
@@ -3261,6 +3271,25 @@ retry:
 			}
 		}
 
+		/*
+		 * Detect whether the number of free pages is below high
+		 * watermark.  If so, we will decrease pcp->high and free
+		 * PCP pages in free path to reduce the possibility of
+		 * premature page reclaiming.  Detection is done here to
+		 * avoid to do that in hotter free path.
+		 */
+		if (test_bit(ZONE_BELOW_HIGH, &zone->flags))
+			goto check_alloc_wmark;
+
+		mark = high_wmark_pages(zone);
+		if (zone_watermark_fast(zone, order, mark,
+					ac->highest_zoneidx, alloc_flags,
+					gfp_mask))
+			goto try_this_zone;
+		else
+			set_bit(ZONE_BELOW_HIGH, &zone->flags);
+
+check_alloc_wmark:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch
mm-pcp-avoid-to-drain-pcp-when-process-exit.patch
cacheinfo-calculate-size-of-per-cpu-data-cache-slice.patch
mm-pcp-reduce-lock-contention-for-draining-high-order-pages.patch
mm-restrict-the-pcp-batch-scale-factor-to-avoid-too-long-latency.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch
mm-add-framework-for-pcp-high-auto-tuning.patch
mm-tune-pcp-high-automatically.patch
mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch
mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch

