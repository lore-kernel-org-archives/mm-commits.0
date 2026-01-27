Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2213B31619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486671; cv=none; b=PuWCxD7DWiE2l9XbTRgWZm3Y9tiMjn/oBCGogjolmBX+YhoVxi/ycHZXGgj7YowjB8g9L4U56igv1A8bA++BBz09OqnHyCGLJAXRFA12zTMHUbGINj179FHLa3RQMsUqMZphxRV26TVZfCx4KAAWbeZdEeKziyy25xTMLOMKeXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486671; c=relaxed/simple;
	bh=+C4eKFb5HH9wHzAp4EXznev+r0UUQ4vPrL3/9Sd8j8k=;
	h=Date:To:From:Subject:Message-Id; b=koUcPrci/7FVcpS04k5o5zB3AIw7WAFh6KvfpuXGhy8wK5rtJyuxS1QU5wL1qvE3EeDF1CgqYiKvmwq5lsS5mhEiWQTQDS4Oh09LbTy19WAQPcPJnV6lBPdR9gaAtVWzbZuis6tV3McU9+FSn31xaeCOIDcV5xogwv/3Q+E8Mfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cC8uIZJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cC8uIZJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEDEC116C6;
	Tue, 27 Jan 2026 04:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486671;
	bh=+C4eKFb5HH9wHzAp4EXznev+r0UUQ4vPrL3/9Sd8j8k=;
	h=Date:To:From:Subject:From;
	b=cC8uIZJSoE9HKEo6jZ3sqZZu2TOEOvxU8t8g7RmCq32Q6bEKoXIXqg9kjsOvReHnV
	 7WSNEE/Er5FX14awqPlSnjGp9WS/bfdXwE7Jd1D7RpDOKXKcSMJAT3Fo+34K3Uaj/3
	 aMKwLIILpdoFco5tlamcMaHBZT8qRT1cPZgYxODw=
Date: Mon, 26 Jan 2026 20:04:30 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,rppt@kernel.org,rientjes@google.com,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-refactor-the-initial-compaction-handling.patch removed from -mm tree
Message-Id: <20260127040430.ECEDEC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: refactor the initial compaction handling
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-refactor-the-initial-compaction-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: refactor the initial compaction handling
Date: Tue, 06 Jan 2026 12:52:37 +0100

The initial direct compaction done in some cases in
__alloc_pages_slowpath() stands out from the main retry loop of reclaim +
compaction.

We can simplify this by instead skipping the initial reclaim attempt via a
new local variable compact_first, and handle the compact_prority as
necessary to match the original behavior.  No functional change intended.

Link: https://lkml.kernel.org/r/20260106-thp-thisnode-tweak-v3-2-f5d67c21a193@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    8 ++-
 mm/page_alloc.c     |  100 ++++++++++++++++++++----------------------
 2 files changed, 55 insertions(+), 53 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-refactor-the-initial-compaction-handling
+++ a/include/linux/gfp.h
@@ -407,9 +407,15 @@ extern gfp_t gfp_allowed_mask;
 /* Returns true if the gfp_mask allows use of ALLOC_NO_WATERMARK */
 bool gfp_pfmemalloc_allowed(gfp_t gfp_mask);
 
+/* A helper for checking if gfp includes all the specified flags */
+static inline bool gfp_has_flags(gfp_t gfp, gfp_t flags)
+{
+	return (gfp & flags) == flags;
+}
+
 static inline bool gfp_has_io_fs(gfp_t gfp)
 {
-	return (gfp & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS);
+	return gfp_has_flags(gfp, __GFP_IO | __GFP_FS);
 }
 
 /*
--- a/mm/page_alloc.c~mm-page_alloc-refactor-the-initial-compaction-handling
+++ a/mm/page_alloc.c
@@ -4694,7 +4694,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 						struct alloc_context *ac)
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = gfp_compaction_allowed(gfp_mask);
+	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
@@ -4707,6 +4707,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned int cpuset_mems_cookie;
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
+	bool compact_first = false;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4731,6 +4732,19 @@ restart:
 	zonelist_iter_cookie = zonelist_iter_begin();
 
 	/*
+	 * For costly allocations, try direct compaction first, as it's likely
+	 * that we have enough base pages and don't need to reclaim. For non-
+	 * movable high-order allocations, do that as well, as compaction will
+	 * try prevent permanent fragmentation by migrating from blocks of the
+	 * same migratetype.
+	 */
+	if (can_compact && (costly_order || (order > 0 &&
+					ac->migratetype != MIGRATE_MOVABLE))) {
+		compact_first = true;
+		compact_priority = INIT_COMPACT_PRIORITY;
+	}
+
+	/*
 	 * The fast path uses conservative alloc_flags to succeed only until
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
@@ -4772,53 +4786,6 @@ restart:
 	if (page)
 		goto got_pg;
 
-	/*
-	 * For costly allocations, try direct compaction first, as it's likely
-	 * that we have enough base pages and don't need to reclaim. For non-
-	 * movable high-order allocations, do that as well, as compaction will
-	 * try prevent permanent fragmentation by migrating from blocks of the
-	 * same migratetype.
-	 * Don't try this for allocations that are allowed to ignore
-	 * watermarks, as the ALLOC_NO_WATERMARKS attempt didn't yet happen.
-	 */
-	if (can_direct_reclaim && can_compact &&
-			(costly_order ||
-			   (order > 0 && ac->migratetype != MIGRATE_MOVABLE))
-			&& !gfp_pfmemalloc_allowed(gfp_mask)) {
-		page = __alloc_pages_direct_compact(gfp_mask, order,
-						alloc_flags, ac,
-						INIT_COMPACT_PRIORITY,
-						&compact_result);
-		if (page)
-			goto got_pg;
-
-		/*
-		 * Checks for costly allocations with __GFP_NORETRY, which
-		 * includes some THP page fault allocations
-		 */
-		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
-			/*
-			 * THP page faults may attempt local node only first,
-			 * but are then allowed to only compact, not reclaim,
-			 * see alloc_pages_mpol().
-			 *
-			 * Compaction has failed above and we don't want such
-			 * THP allocations to put reclaim pressure on a single
-			 * node in a situation where other nodes might have
-			 * plenty of available memory.
-			 */
-			if (gfp_mask & __GFP_THISNODE)
-				goto nopage;
-
-			/*
-			 * Proceed with single round of reclaim/compaction, but
-			 * since sync compaction could be very expensive, keep
-			 * using async compaction.
-			 */
-			compact_priority = INIT_COMPACT_PRIORITY;
-		}
-	}
-
 retry:
 	/*
 	 * Deal with possible cpuset update races or zonelist updates to avoid
@@ -4862,10 +4829,12 @@ retry:
 		goto nopage;
 
 	/* Try direct reclaim and then allocating */
-	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
-							&did_some_progress);
-	if (page)
-		goto got_pg;
+	if (!compact_first) {
+		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
+							ac, &did_some_progress);
+		if (page)
+			goto got_pg;
+	}
 
 	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
@@ -4873,6 +4842,33 @@ retry:
 	if (page)
 		goto got_pg;
 
+	if (compact_first) {
+		/*
+		 * THP page faults may attempt local node only first, but are
+		 * then allowed to only compact, not reclaim, see
+		 * alloc_pages_mpol().
+		 *
+		 * Compaction has failed above and we don't want such THP
+		 * allocations to put reclaim pressure on a single node in a
+		 * situation where other nodes might have plenty of available
+		 * memory.
+		 */
+		if (gfp_has_flags(gfp_mask, __GFP_NORETRY | __GFP_THISNODE))
+			goto nopage;
+
+		/*
+		 * For the initial compaction attempt we have lowered its
+		 * priority. Restore it for further retries, if those are
+		 * allowed. With __GFP_NORETRY there will be a single round of
+		 * reclaim and compaction with the lowered priority.
+		 */
+		if (!(gfp_mask & __GFP_NORETRY))
+			compact_priority = DEF_COMPACT_PRIORITY;
+
+		compact_first = false;
+		goto retry;
+	}
+
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
 		goto nopage;
_

Patches currently in -mm which might be from vbabka@suse.cz are


