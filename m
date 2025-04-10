Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBE42C190
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 00:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744245510; cv=none; b=ZscNFzE2OGZL5OaGLRwYpuAIq/EAZLeAWJC4qw1BBJS2Z38YrGtUwK8jcHWr3guPCylqb09Yut/v3aELDUQ8hBcjdVCld7QFWteLYZoVw9SDkCNq3Ee/dcCaKWTAGcrrCOgfvthsMFSJWsd0iiPRV560h4FJL2aSw19DwhrkGBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744245510; c=relaxed/simple;
	bh=HIlH5K5iymIzv4dcYkqwQDnSKEog1qxg2osUfLsOnjI=;
	h=Date:To:From:Subject:Message-Id; b=PepwkrkUhCk6yGBKR1FOq+m4mKyh4ejGZaZeprGRr74rI2Somq470g6bX6Q9E+N2AJQ7YCxMyMarSlgTyKxds2oLp+c6IboGqOvn15qpfxSSz0s0V7tu+AFq9Xd/rc6cpVPJAV8FeUsEH4HqhT7NQbEz8sEAcVC3obXeculZcYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AITg/O7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AITg/O7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5815C4CEE2;
	Thu, 10 Apr 2025 00:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744245509;
	bh=HIlH5K5iymIzv4dcYkqwQDnSKEog1qxg2osUfLsOnjI=;
	h=Date:To:From:Subject:From;
	b=AITg/O7oqM89LQdaw8FaPiec+7TBiwCTKBqUii6RDqTzO90Z97wyJ3K288UASx52m
	 4+KLdX34GV11/6gXwaVisiAdLZ1lp9aOpBBey/CpEJHvaA85YGCHie7OnTCcyXSK2C
	 f8psgp1VeJ2rSEFxBReOqYK0l0f9UuGB9CPu0gtc=
Date: Wed, 09 Apr 2025 17:38:28 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410003829.D5815C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: page_alloc: speed up fallbacks in rmqueue_bulk() - comment updates
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix.patch

