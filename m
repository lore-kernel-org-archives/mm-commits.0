From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch added
 to -mm tree
Date: Wed, 17 Jun 2020 17:13:14 -0700
Message-ID: <20200618001314.fdvGU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgFRANR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 20:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinmenon@codeaurora.org, mgorman@techsingularity.net, charante@codeaurora.org


The patch titled
     Subject: mm, page_alloc: skip ->waternark_boost for atomic order-0 allocations
has been added to the -mm tree.  Its filename is
     mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Link: http://lkml.kernel.org/r/1589882284-21010-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations
+++ a/mm/page_alloc.c
@@ -3746,6 +3746,18 @@ retry:
 		}
 
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
+		/*
+		 * Allow GFP_ATOMIC order-0 allocations to exclude the
+		 * zone->watermark_boost in their watermark calculations.
+		 * We rely on the ALLOC_ flags set for GFP_ATOMIC requests in
+		 * gfp_to_alloc_flags() for this.  Reason not to use the
+		 * GFP_ATOMIC directly is that we want to fall back to slow path
+		 * thus wake up kswapd.
+		 */
+		if (unlikely(!order && !(alloc_flags & ALLOC_WMARK_MASK) &&
+		     (alloc_flags & (ALLOC_HARDER | ALLOC_HIGH)))) {
+			mark = zone->_watermark[WMARK_MIN];
+		}
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags)) {
 			int ret;
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch
mm-page_alloc-skip-watermark_boost-for-atomic-order-0-allocations-fix.patch
