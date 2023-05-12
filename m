Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDB3C7EE23
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 03:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbjELDl0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 May 2023 23:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239807AbjELDlZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 May 2023 23:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050244EC8
        for <mm-commits@vger.kernel.org>; Thu, 11 May 2023 20:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A0C64D31
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 03:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7A1C433EF;
        Fri, 12 May 2023 03:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683862882;
        bh=oeU12rBzYXzSVlg1c9dkHVwx//lsuOPfxTM05y3Fk0s=;
        h=Date:To:From:Subject:From;
        b=XO6yIJ9Z0qyO9ayIbQZcHqfPEh7DScQiMHwz33lU/xS8Xh8kKxVrmZIbdLXgFQ69Q
         2mUARqTf+xkmH02+vAyL0kJG/fHmk4lj+R5drQQY6XO2150MQljaoNDukmMnA8HTYy
         s6rtjZ2VV4GpFDy0SaBzhz3km72zH1f9Nj56Z83w=
Date:   Thu, 11 May 2023 20:41:22 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        minchan@kernel.org, ke.wang@unisoc.com, iamjoonsoo.kim@lge.com,
        huangzhaoyang@gmail.com, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimization-on-page-allocation-when-cma-enabled.patch added to mm-unstable branch
Message-Id: <20230512034122.CF7A1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: optimization on page allocation when CMA enabled
has been added to the -mm mm-unstable branch.  Its filename is
     mm-optimization-on-page-allocation-when-cma-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimization-on-page-allocation-when-cma-enabled.patch

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
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: optimization on page allocation when CMA enabled
Date: Thu, 11 May 2023 13:22:30 +0800

Let us look at the timeline of scenarios below with WMARK_LOW=25MB
WMARK_MIN=5MB (managed pages 1.9GB).  We can find that CMA begin to be
used until 'C' under the method of 'fixed 2 times of free cma over free
pages' which could have the scenario 'A' and 'B' into a fault state, that
is, free UNMOVABLE & RECLAIMABLE pages is lower than corresponding
watermark without reclaiming which should be deemed as against current
memory policy.  This commit try to solve this by checking
zone_watermark_ok again with removing CMA pages which could lead to a
proper time point of CMA's utilization.

-- Free_pages
|
|
-- WMARK_LOW
|
-- Free_CMA
|
|
--

Free_CMA/Free_pages(MB)      A(12/30) -->  B(12/25) -->  C(12/20)
fixed 1/2 ratio                 N             N           Y
this commit                     Y             Y           Y

Link: https://lkml.kernel.org/r/1683782550-25799-1-git-send-email-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-optimization-on-page-allocation-when-cma-enabled
+++ a/mm/page_alloc.c
@@ -2275,6 +2275,43 @@ do_steal:
 
 }
 
+#ifdef CONFIG_CMA
+/*
+ * GFP_MOVABLE allocation could drain UNMOVABLE & RECLAIMABLE page blocks via
+ * the help of CMA which makes GFP_KERNEL failed. Checking if zone_watermark_ok
+ * again without ALLOC_CMA to see if to use CMA first.
+ */
+static bool use_cma_first(struct zone *zone, unsigned int order, unsigned int alloc_flags)
+{
+	unsigned long watermark;
+	bool cma_first = false;
+
+	watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
+	/* check if GFP_MOVABLE pass previous zone_watermark_ok via the help of CMA */
+	if (zone_watermark_ok(zone, order, watermark, 0, alloc_flags & (~ALLOC_CMA))) {
+		/*
+		 * Balance movable allocations between regular and CMA areas by
+		 * allocating from CMA when over half of the zone's free memory
+		 * is in the CMA area.
+		 */
+		cma_first = (zone_page_state(zone, NR_FREE_CMA_PAGES) >
+				zone_page_state(zone, NR_FREE_PAGES) / 2);
+	} else {
+		/*
+		 * watermark failed means UNMOVABLE & RECLAIMBLE is not enough
+		 * now, we should use cma first to keep them stay around the
+		 * corresponding watermark
+		 */
+		cma_first = true;
+	}
+	return cma_first;
+}
+#else
+static bool use_cma_first(struct zone *zone, unsigned int order, unsigned int alloc_flags)
+{
+	return false;
+}
+#endif
 /*
  * Do the hard work of removing an element from the buddy allocator.
  * Call me with the zone->lock already held.
@@ -2288,12 +2325,11 @@ __rmqueue(struct zone *zone, unsigned in
 	if (IS_ENABLED(CONFIG_CMA)) {
 		/*
 		 * Balance movable allocations between regular and CMA areas by
-		 * allocating from CMA when over half of the zone's free memory
-		 * is in the CMA area.
+		 * allocating from CMA base on judging zone_watermark_ok again
+		 * to see if the latest check got pass via the help of CMA
 		 */
 		if (alloc_flags & ALLOC_CMA &&
-		    zone_page_state(zone, NR_FREE_CMA_PAGES) >
-		    zone_page_state(zone, NR_FREE_PAGES) / 2) {
+			use_cma_first(zone, order, alloc_flags)) {
 			page = __rmqueue_cma_fallback(zone, order);
 			if (page)
 				return page;
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-optimization-on-page-allocation-when-cma-enabled.patch

