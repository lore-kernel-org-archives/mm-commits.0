Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D48C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE639206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027188;
	bh=8kkyN61XMtUdNt7sL6mzl0HTAb1cKc0GH6PmL4PPPQU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mKSmzKkcHZEfkQ2yJvoIpiMep2219dSs1D8mOkE+ZzKJDdxOtzMjHIiQs84liCCvf
	 t53g7r/GK8W25H19RUweHQE0bvHwdSZ9/w8DcyMpjzFJRKXes2xQR435LXxQg98+Kl
	 afpZuyApvUO/zZcpDTyJau3abfbai2jny0gfk8ds=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgHJCjs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgHJCjs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 957402065D;
        Mon, 10 Aug 2020 02:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027187;
        bh=8kkyN61XMtUdNt7sL6mzl0HTAb1cKc0GH6PmL4PPPQU=;
        h=Date:From:To:Subject:From;
        b=HAl59s2F0tpDLcQoUTmKgDsWIAAKYsq5bRa5wkp9aSiexauyNbWoVmPUZeXbDjcd8
         vZU2W18itPuSCa86k5TJs5nIvUNew+lijaogVhYNsMNVHy0oXhZ1ckOO1UgR2aiXKl
         UpKDFAYpBoigI4hB16BOpvtUerFj6ux7c1J6q2ek=
Date:   Sun, 09 Aug 2020 19:39:47 -0700
From:   akpm@linux-foundation.org
To:     charante@codeaurora.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, vinmenon@codeaurora.org
Subject:  [merged]
 mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch
 removed from -mm tree
Message-ID: <20200810023947.MLA1Frv0j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: skip ->waternark_boost for atomic order-0 allocations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm, page_alloc: skip ->waternark_boost for atomic order-0 allocations

When boosting is enabled, it is observed that rate of atomic order-0
allocation failures are high due to the fact that free levels in the
system are checked with ->watermark_boost offset.  This is not a problem
for sleepable allocations but for atomic allocations which looks like
regression.

This problem is seen frequently on system setup of Android kernel running
on Snapdragon hardware with 4GB RAM size.  When no extfrag event occurred
in the system, ->watermark_boost factor is zero, thus the watermark
configurations in the system are:

   _watermark = (
          [WMARK_MIN] = 1272, --> ~5MB
          [WMARK_LOW] = 9067, --> ~36MB
          [WMARK_HIGH] = 9385), --> ~38MB
   watermark_boost = 0

After launching some memory hungry applications in Android which can cause
extfrag events in the system to an extent that ->watermark_boost can be
set to max i.e.  default boost factor makes it to 150% of high watermark.

   _watermark = (
          [WMARK_MIN] = 1272, --> ~5MB
          [WMARK_LOW] = 9067, --> ~36MB
          [WMARK_HIGH] = 9385), --> ~38MB
   watermark_boost = 14077, -->~57MB

With default system configuration, for an atomic order-0 allocation to
succeed, having free memory of ~2MB will suffice.  But boosting makes the
min_wmark to ~61MB thus for an atomic order-0 allocation to be successful
system should have minimum of ~23MB of free memory(from calculations of
zone_watermark_ok(), min = 3/4(min/2)).  But failures are observed despite
system is having ~20MB of free memory.  In the testing, this is
reproducible as early as first 300secs since boot and with furtherlowram
configurations(<2GB) it is observed as early as first 150secs since boot.

These failures can be avoided by excluding the ->watermark_boost in
watermark caluculations for atomic order-0 allocations.

[akpm@linux-foundation.org: fix comment grammar, reflow comment]
[charante@codeaurora.org: fix suggested by Mel Gorman]
  Link: http://lkml.kernel.org/r/31556793-57b1-1c21-1a9d-22674d9bd938@codeaurora.org
Link: http://lkml.kernel.org/r/1589882284-21010-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations
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
@@ -3752,7 +3767,8 @@ retry:
 
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (!zone_watermark_fast(zone, order, mark,
-				       ac->highest_zoneidx, alloc_flags)) {
+				       ac->highest_zoneidx, alloc_flags,
+				       gfp_mask)) {
 			int ret;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-memory_hotplug-update-pcp-lists-everytime-onlining-a-memory-block.patch

