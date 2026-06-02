Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32283BAD84
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439058; cv=none; b=fHom+sAC8C2wfjFmJJxNIUP3o8Fno1CTBWMKE7HcyArfgmbtXeIV1sl/CjN5pe+MoS6eII51Ha7dTHSXeD8yLnqWRY2ZPTB//SyD9sq8iaBmotEaMJJ9p9o/i1igYEqmCLn1ZYy7B1YUOwli5CuFOCQNQOFkSv/A7Ek8gO131jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439058; c=relaxed/simple;
	bh=D3c5KK060TRE20m3VBbnnwViehF0+cT8wDKqhUIhMhA=;
	h=Date:To:From:Subject:Message-Id; b=mQibt1js8BlKyTvgV6jZqWWnBRRB84JyoQf9cEdIq1rHK7MrtZGhMTMF4uJow2QseFJqdMsHQUE17VGWMuSa2mFNtqMA752tLWPsTpRvcufHcliuMSBE0sM5angzwFfM/FGWpgB95IVOt0+9LrIkQDqE4IDqMnGBK+i6ygKSqUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IykH0XnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IykH0XnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4447F1F00893;
	Tue,  2 Jun 2026 22:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439056;
	bh=Taa3KKroX+29IUxRVlihNNIotjYQOBRSEtkJPkD0tqA=;
	h=Date:To:From:Subject;
	b=IykH0XnPIpt1h2Qm9c9dHnlHne/oHX2U48Udfcl6s9WnK+fsj47ol16wdwIc316Z5
	 NB0I5sDkXAAOEWyjGvWJFCAMXyg5Hn3F7qcHCOH+1R9lnAdPUlkAGDTNYoyslA3r0p
	 K+nQai8KILO1xqvKNBAKEPHp9JH65h+NjAZMqFJc=
Date: Tue, 02 Jun 2026 15:24:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lenb@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch removed from -mm tree
Message-Id: <20260602222416.4447F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: don't overload migratetype in find_suitable_fallback()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2259,25 +2259,29 @@ static bool should_try_claim_block(unsig
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
@@ -2387,16 +2391,16 @@ __rmqueue_claim(struct zone *zone, int o
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
@@ -2426,10 +2430,12 @@ __rmqueue_steal(struct zone *zone, int o
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

mm-delete-stale-comment-about-cachelines.patch

