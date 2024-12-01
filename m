Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F8314A84
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 07:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733036458; cv=none; b=bli2dk59S6+K9knDVcmbNBfPDxrS/xwvHaOky1y2R8D4XZRB2RDuJFbXiOYuAlNOmgJ7Let55CH6dbyEz2nS1POBg4aWpE4fl5TI3obgVkrnQngaMP+4ZYjBauBVLeWzBnAxnF0Og+D4BktDwc0/Nk4gnTwqywdv8hGL4rdW2RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733036458; c=relaxed/simple;
	bh=C1/2eMBnjRu0rjlvRSKtWLyhIY4dkhpoCuQB9lo5udg=;
	h=Date:To:From:Subject:Message-Id; b=pYpUinLVvc8n5kN7YnoXMhd8uwnw3dbuvfl0EJg7esHFjZrUyHQTNvYWW27Bs1odAqZ680prjaGiWSizqxbFumb4Lnox8shUwWhPK08UaxG/boZ+TFOWHlacHJCXsOXqsymv+R4ytk1iOoQosqgEktebiHtgngWa638WIjV9RE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AwZPBVnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AwZPBVnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7E2C4CECF;
	Sun,  1 Dec 2024 07:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733036457;
	bh=C1/2eMBnjRu0rjlvRSKtWLyhIY4dkhpoCuQB9lo5udg=;
	h=Date:To:From:Subject:From;
	b=AwZPBVnRDcIR4D2z7c2zLGXlGGmyKrWgcFSn/tDYXsyPOrxTdNv1NDTrFOCj9w/Xg
	 YHCHd/qdfsCWcxCYKh+kEDi3sK7iuK+Zq3OcUkcBqDyNhTABe3BjkXcZ2DYScq5vcb
	 Wzsi9v8tVMufHEcS3wupzzZDD1ka+71+Sy+PvQvo=
Date: Sat, 30 Nov 2024 23:00:57 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,minchan@kernel.org,ke.wang@unisoc.com,iamjoonsoo.kim@lge.com,huangzhaoyang@gmail.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-optimization-on-page-allocation-when-cma-enabled.patch removed from -mm tree
Message-Id: <20241201070057.9F7E2C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimization on page allocation when CMA enabled
has been removed from the -mm tree.  Its filename was
     mm-optimization-on-page-allocation-when-cma-enabled.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: optimization on page allocation when CMA enabled
Date: Thu, 11 May 2023 13:22:30 +0800

According to current CMA utilization policy, an alloc_pages(GFP_USER)
could 'steal' UNMOVABLE & RECLAIMABLE page blocks via the help of CMA(pass
zone_watermark_ok by counting CMA in but use U&R in rmqueue), which could
lead to following alloc_pages(GFP_KERNEL) fail.  Solving this by
introducing second watermark checking for GFP_MOVABLE, which could have
the allocation use CMA when proper.

-- Free_pages(30MB)
|
|
-- WMARK_LOW(25MB)
|
-- Free_CMA(12MB)
|
|
--

Link: https://lkml.kernel.org/r/20231016071245.2865233-1-zhaoyang.huang@unisoc.com
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
@@ -2262,6 +2262,43 @@ do_steal:
 	return page;
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
@@ -2275,12 +2312,11 @@ __rmqueue(struct zone *zone, unsigned in
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


