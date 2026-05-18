Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CA7389116
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 18:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779128085; cv=none; b=JHDpi4J9MRklViv1ISuOP3SIpnXTc6dGjnGyagYKldLQMED2ecwXRfL2aBy5jXRCKMNJoW4XaFnvIIsHIXe6ioj6Iv04KCGUlpgzhVlbH8oK2tTRdiPA6INv71KEVE42IZLCgpkP8R6QxImTIyJwQ4cNhBZ9GMpM/yi6Yqxuoz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779128085; c=relaxed/simple;
	bh=JmYc0+qrTTmhoBHudxd/Ux90pFyIwntdk7GWFUtMOWw=;
	h=Date:To:From:Subject:Message-Id; b=UacBgl6V02D6Q9u2s9d6i/qRdksvcIUHAx7QKQK/q2sfSBDtzVoaVFjFS3V3dIiR5cyxHvWkxxi1769chYkONJxoawbk0d/cXTke1WlYSEUrBGva2l4R6hkPEQNy/BY4u4M1Q5BA6EHUycXHSqCiP1ANkFNmvgQXE2kvgoFLois=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HjgwJi9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HjgwJi9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A6CC2BCB7;
	Mon, 18 May 2026 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779128084;
	bh=JmYc0+qrTTmhoBHudxd/Ux90pFyIwntdk7GWFUtMOWw=;
	h=Date:To:From:Subject:From;
	b=HjgwJi9nGYJi70imLiQz3JsMJssryr87tppLFhp5iSNjnZup094ePGjwNoO4TZJ7W
	 Qa2znDDpeMW/6AmnwxCTjfwZhzhWsfy9HwElDbe9nwCsPRJu0SA3m4kWRC+xkh3yzl
	 aiWME/5g7i/kC1//jPXkOR3s4Sv5YPLhkMAiRcKs=
Date: Mon, 18 May 2026 11:14:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lenb@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch added to mm-new branch
Message-Id: <20260518181444.A0A6CC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: don't overload migratetype in find_suitable_fallback()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: don't overload migratetype in find_suitable_fallback()
Date: Wed, 13 May 2026 12:35:14 +0000

This function currently returns a signed integer that encodes status
in-band, as negative numbers, along with a migratetype.  Switch to a more
explicit/verbose style that encodes the status and migratetype separately.

In the spirit of making things more explicit, also create an enum to avoid
using magic integer literals with special meanings.  This enables
documenting the values at their definition instead of in one of the
callers.

Link: https://lore.kernel.org/20260513-page_alloc-unmapped-prep-v1-2-dacdf5402be8@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ++-
 mm/internal.h   |   14 +++++++++++---
 mm/page_alloc.c |   38 ++++++++++++++++++++++----------------
 3 files changed, 35 insertions(+), 20 deletions(-)

--- a/mm/compaction.c~mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback
+++ a/mm/compaction.c
@@ -2340,7 +2340,8 @@ static enum compact_result __compact_fin
 		 * Job done if allocation would steal freepages from
 		 * other migratetype buddy lists.
 		 */
-		if (find_suitable_fallback(area, order, migratetype, true) >= 0)
+		if (find_suitable_fallback(area, order, migratetype, true, NULL)
+		    == FALLBACK_FOUND)
 			/*
 			 * Movable pages are OK in any pageblock. If we are
 			 * stealing for a non-movable allocation, make sure
--- a/mm/internal.h~mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback
+++ a/mm/internal.h
@@ -1104,9 +1104,17 @@ static inline void init_cma_pageblock(st
 }
 #endif
 
-
-int find_suitable_fallback(struct free_area *area, unsigned int order,
-			   int migratetype, bool claimable);
+enum fallback_result {
+	/* Found suitable migratetype, *mt_out is valid. */
+	FALLBACK_FOUND,
+	/* No fallback found in requested order. */
+	FALLBACK_EMPTY,
+	/* Passed @claimable, but claiming whole block is a bad idea. */
+	FALLBACK_NOCLAIM,
+};
+enum fallback_result
+find_suitable_fallback(struct free_area *area, unsigned int order,
+		       int migratetype, bool claimable, int *mt_out);
 
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
--- a/mm/page_alloc.c~mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback
+++ a/mm/page_alloc.c
@@ -2264,25 +2264,29 @@ static bool should_try_claim_block(unsig
  * we would do this whole-block claiming. This would help to reduce
  * fragmentation due to mixed migratetype pages in one pageblock.
  */
-int find_suitable_fallback(struct free_area *area, unsigned int order,
-			   int migratetype, bool claimable)
+enum fallback_result
+find_suitable_fallback(struct free_area *area, unsigned int order,
+		       int migratetype, bool claimable, int *mt_out)
 {
 	int i;
 
 	if (claimable && !should_try_claim_block(order, migratetype))
-		return -2;
+		return FALLBACK_NOCLAIM;
 
 	if (area->nr_free == 0)
-		return -1;
+		return FALLBACK_EMPTY;
 
 	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
 		int fallback_mt = fallbacks[migratetype][i];
 
-		if (!free_area_empty(area, fallback_mt))
-			return fallback_mt;
+		if (!free_area_empty(area, fallback_mt)) {
+			if (mt_out)
+				*mt_out = fallback_mt;
+			return FALLBACK_FOUND;
+		}
 	}
 
-	return -1;
+	return FALLBACK_EMPTY;
 }
 
 /*
@@ -2392,16 +2396,16 @@ __rmqueue_claim(struct zone *zone, int o
 	 */
 	for (current_order = MAX_PAGE_ORDER; current_order >= min_order;
 				--current_order) {
+		enum fallback_result result;
+
 		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, true);
+		result = find_suitable_fallback(area, current_order,
+						start_migratetype, true, &fallback_mt);
 
-		/* No block in that order */
-		if (fallback_mt == -1)
+		if (result == FALLBACK_EMPTY)
 			continue;
 
-		/* Advanced into orders too low to claim, abort */
-		if (fallback_mt == -2)
+		if (result == FALLBACK_NOCLAIM)
 			break;
 
 		page = get_page_from_free_area(area, fallback_mt);
@@ -2431,10 +2435,12 @@ __rmqueue_steal(struct zone *zone, int o
 	int fallback_mt;
 
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
+		enum fallback_result result;
+
 		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, false);
-		if (fallback_mt == -1)
+		result = find_suitable_fallback(area, current_order, start_migratetype,
+						false, &fallback_mt);
+		if (result == FALLBACK_EMPTY)
 			continue;
 
 		page = get_page_from_free_area(area, fallback_mt);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-cleanup-flag-vars-in-alloc_pages_bulk_noprof.patch
drm-managed-use-special-gfp_t-format-specifier.patch
mm-kfence-use-special-gfp_t-format-specifier.patch
net-rds-use-special-gfp_t-format-specifier.patch
mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch

