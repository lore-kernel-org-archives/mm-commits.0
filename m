Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D812AC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC80F2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779886;
	bh=gMtDbqG7Y8Dqi7y9a/I9maeP3ujqPxaG+HmQh0juH4E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yhTQjy0oHElFZAAtPO9VavrBofiwhXmSZgB5HOrbnsPx/I0rakRfjQpj6OC2jQr8s
	 F07dIWCePEIgAWGgYSd5e+2lyv1QjzNLmsz/CaSGWh915wg6KZ2xLscnzGRG5kmegv
	 TcFrPVzlmLuirsYEV/q/PJMJNarPAMgdSFcF6r94=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGF6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGF6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:58:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5890821744;
        Fri,  7 Aug 2020 05:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779885;
        bh=gMtDbqG7Y8Dqi7y9a/I9maeP3ujqPxaG+HmQh0juH4E=;
        h=Date:From:To:Subject:From;
        b=f0JpymrrXLmXzKYFDeqX94pXfEti+LmH+wRKHq1Dfey1RRw/TF0OZbmt4BVsK6vjL
         o6R845mvEWi5VvVH34L9UXmu1jekFFc4i42VvmWNFMQl9CfjIS1EBDz20S6ebjjJyu
         5gZkKjH9pyRon/PH4f5RBDa9Tm3OUIHre25/7mKs=
Date:   Thu, 06 Aug 2020 22:58:04 -0700
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vinmenon@codeaurora.org
Subject:  [folded-merged]
 mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix.patch
 removed from -mm tree
Message-ID: <20200807055804.-5k8xyaJi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: skip ->watermark_boost for atomic order-0 allocations-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix.patch

This patch was dropped because it was folded into mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch

------------------------------------------------------
From: Charan Teja Kalla <charante@codeaurora.org>
Subject: mm, page_alloc: skip ->watermark_boost for atomic order-0 allocations-fix

fix suggested by Mel Gorman

Link: http://lkml.kernel.org/r/31556793-57b1-1c21-1a9d-22674d9bd938@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix
+++ a/mm/page_alloc.c
@@ -3588,7 +3588,7 @@ bool zone_watermark_ok(struct zone *z, u
 
 static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 				unsigned long mark, int highest_zoneidx,
-				unsigned int alloc_flags)
+				unsigned int alloc_flags, gfp_t gfp_mask)
 {
 	long free_pages;
 
@@ -3607,8 +3607,23 @@ static inline bool zone_watermark_fast(s
 			return true;
 	}
 
-	return __zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
-					free_pages);
+	if (__zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
+					free_pages))
+		return true;
+	/*
+	 * Ignore watermark boosting for GFP_ATOMIC order-0 allocations
+	 * when checking the min watermark. The min watermark is the
+	 * point where boosting is ignored so that kswapd is woken up
+	 * when below the low watermark.
+	 */
+	if (unlikely(!order && (gfp_mask & __GFP_ATOMIC) && z->watermark_boost
+		&& ((alloc_flags & ALLOC_WMARK_MASK) == WMARK_MIN))) {
+		mark = z->_watermark[WMARK_MIN];
+		return __zone_watermark_ok(z, order, mark, highest_zoneidx,
+					alloc_flags, free_pages);
+	}
+
+	return false;
 }
 
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
@@ -3751,20 +3766,9 @@ retry:
 		}
 
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
-		/*
-		 * Allow GFP_ATOMIC order-0 allocations to exclude the
-		 * zone->watermark_boost in their watermark calculations.
-		 * We rely on the ALLOC_ flags set for GFP_ATOMIC requests in
-		 * gfp_to_alloc_flags() for this.  Reason not to use the
-		 * GFP_ATOMIC directly is that we want to fall back to slow path
-		 * thus wake up kswapd.
-		 */
-		if (unlikely(!order && !(alloc_flags & ALLOC_WMARK_MASK) &&
-		     (alloc_flags & (ALLOC_HARDER | ALLOC_HIGH)))) {
-			mark = zone->_watermark[WMARK_MIN];
-		}
 		if (!zone_watermark_fast(zone, order, mark,
-				       ac->highest_zoneidx, alloc_flags)) {
+				       ac->highest_zoneidx, alloc_flags,
+				       gfp_mask)) {
 			int ret;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch
mm-memory_hotplug-update-pcp-lists-everytime-onlining-a-memory-block.patch

