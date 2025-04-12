Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92955DDAB
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744417703; cv=none; b=XVrh0z/UQlBhtB9IozxvH3IKk966THl9UAGuiRX4XjZZlHotFRCqzFIgp4L/XspAQQRxLsaaqVyHf3rKCL8owRDPRN1MAHUY5c0wrjVKiMmvFW7mapXEFBHYDq2Z8ARDdbGNiVnUQ3lDaaP4vD0SVQ7oISa1DSNSR4kBteRH/JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744417703; c=relaxed/simple;
	bh=TjY5W8uxnYq4idSmRknRk1JRhUaZd4XsdD/WtUHrHHQ=;
	h=Date:To:From:Subject:Message-Id; b=j5SgSz3Tih7hNnEFioW5Nhf1AucILr3lKYmqbqL4SvShr+QP0NmhEf20/I8hbzntEJ8KjsP/a8/DiE3Pw4TwamkpvcZXqTdmBMhvN3ANgjDwdWAxFKtCCePNcQA6dhyPBi/YMZ0pEped+xNVxLHZ8me1C5zsFLJeAwaaW+6RfDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gI8FYz9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gI8FYz9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFC1C4CEE2;
	Sat, 12 Apr 2025 00:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744417702;
	bh=TjY5W8uxnYq4idSmRknRk1JRhUaZd4XsdD/WtUHrHHQ=;
	h=Date:To:From:Subject:From;
	b=gI8FYz9xUYUsuC2Xs4bHPCXIb+iyVWeDVYssox2u7snE/Eg++T59q7Y65nSdF0/Th
	 y7a172Wbm1lI9YtkUBRMVydOxFyOpr9r8i/76nnLqMj8viCbN04AEX9bR14mEkS3Jc
	 GJAeLPYxUV8A94JAjSZtp9VNJU7ByilG2S5egORE=
Date: Fri, 11 Apr 2025 17:28:22 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix.patch removed from -mm tree
Message-Id: <20250412002822.CCFC1C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: page_alloc: speed up fallbacks in rmqueue_bulk() - comment updates
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix.patch

This patch was dropped because it was folded into mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk.patch

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: page_alloc: speed up fallbacks in rmqueue_bulk() - comment updates
Date: Wed, 9 Apr 2025 17:22:14 +000

Tidy up some terminology and redistribute commentary.

Link: https://lkml.kernel.org/r/D92AC0P9594X.3BML64MUKTF8Z@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix
+++ a/mm/page_alloc.c
@@ -2183,21 +2183,13 @@ try_to_claim_block(struct zone *zone, st
 }
 
 /*
- * Try finding a free buddy page on the fallback list.
- *
- * This will attempt to claim a whole pageblock for the requested type
- * to ensure grouping of such requests in the future.
- *
- * If a whole block cannot be claimed, steal an individual page, regressing to
- * __rmqueue_smallest() logic to at least break up as little contiguity as
- * possible.
+ * Try to allocate from some fallback migratetype by claiming the entire block,
+ * i.e. converting it to the allocation's start migratetype.
  *
  * The use of signed ints for order and current_order is a deliberate
  * deviation from the rest of this file, to make the for loop
  * condition simpler.
  */
-
-/* Try to claim a whole foreign block, take a page, expand the remainder */
 static __always_inline struct page *
 __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 						unsigned int alloc_flags)
@@ -2247,7 +2239,10 @@ __rmqueue_claim(struct zone *zone, int o
 	return NULL;
 }
 
-/* Try to steal a single page from a foreign block */
+/*
+ * Try to steal a single page from some fallback migratetype. Leave the rest of
+ * the block as its current migratetype, potentially causing fragmentation.
+ */
 static __always_inline struct page *
 __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 {
@@ -2307,7 +2302,8 @@ __rmqueue(struct zone *zone, unsigned in
 	}
 
 	/*
-	 * Try the different freelists, native then foreign.
+	 * First try the freelists of the requested migratetype, then try
+	 * fallbacks modes with increasing levels of fragmentation risk.
 	 *
 	 * The fallback logic is expensive and rmqueue_bulk() calls in
 	 * a loop with the zone->lock held, meaning the freelists are
@@ -2332,7 +2328,7 @@ __rmqueue(struct zone *zone, unsigned in
 	case RMQUEUE_CLAIM:
 		page = __rmqueue_claim(zone, order, migratetype, alloc_flags);
 		if (page) {
-			/* Replenished native freelist, back to normal mode */
+			/* Replenished preferred freelist, back to normal mode. */
 			*mode = RMQUEUE_NORMAL;
 			return page;
 		}
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk.patch

