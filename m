Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74201339394
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465815; cv=none; b=JV+g35pUQiH0sSWWnlu+DEy0oeFWJoTYzvWQd+7CRcSlNDSqTLgUxm1DspMceiXwfcgFD1zIEcmVTXdBME/DXAEWzS/8am6ZYTLPVEwt/CcyA9V2Tu0EcPxL4opX3kLQSFNZaY8z1sNulwsUd+xXYh43jXJltEizAe993T0hknM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465815; c=relaxed/simple;
	bh=adFstNEOTzptcte96JY4J8aGpe4dG6uIb+a9+mIRSx8=;
	h=Date:To:From:Subject:Message-Id; b=kRm0umC8EQc5Uh/Gv4o+1E5/8agGwsx4F1LHgI1IwsvnCsFEnys6s/sjl+1gfv+6itn1VJG7JJ66DANJZvBE2S6Rq1UpK8dko0OsUJe7IzleH/niacc8sQOpp/KqI/qs1Cqyk42bvrj4UZwfJ9N7TXBvtFvu+Z1BFLmR01b9RZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vZbYfzT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vZbYfzT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1831F000E9;
	Fri, 31 Jul 2026 02:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465814;
	bh=rjZmz7aCGQAWqvrQna0OXqe609m53qvipXG04Y8wQ6Y=;
	h=Date:To:From:Subject;
	b=vZbYfzT4zZZESWAzbbdIKxITSnCdU0S708U8CA6MrmGErDE3zD1ePIDmDVAIcKiGq
	 r/swzq/zTOTyKVYOyhuRc4AXhlutFSlUgqbNatmZRjND+AHgLSeEzpJyJusUf5yVVs
	 Lg6Gy16Bcp0Acqp6cwJzb1FlOTZ2U5Uhssv+i7dA=
Date: Thu, 30 Jul 2026 19:43:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch removed from -mm tree
Message-Id: <20260731024334.4B1831F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: drop alloc_flags arg from alloc_flags_cma()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: drop alloc_flags arg from alloc_flags_cma()
Date: Fri, 03 Jul 2026 12:31:57 +0000

To align the style with other alloc_flags_*() functions, drop this
additive argument and just have the callers do that themselves.

Note you can't always freely or alloc_flags like these callers do (because
of the WMARK bits that encode an enum) but this is fine for ALLOC_CMA,
just like it's fine for e.g.  ALLOC_NON_BLOCK returned by
alloc_flags_nonblocking() and or'd by its caller.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-17-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/all/5dcdd1ef-21ad-4ed0-9e8a-0e5cf96b4392@kernel.org/
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma
+++ a/mm/page_alloc.c
@@ -3775,14 +3775,13 @@ alloc_flags_nofragment(struct zone *zone
 }
 
 /* Must be called after current_gfp_context() which can change gfp_mask */
-static inline unsigned int alloc_flags_cma(gfp_t gfp_mask,
-					   unsigned int alloc_flags)
+static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
 {
 #ifdef CONFIG_CMA
 	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
+		return ALLOC_CMA;
 #endif
-	return alloc_flags;
+	return ALLOC_DEFAULT;
 }
 
 /*
@@ -4526,7 +4525,7 @@ alloc_flags_slowpath(gfp_t gfp_mask, uns
 	} else if (unlikely(rt_or_dl_task(current)) && in_task())
 		alloc_flags |= ALLOC_MIN_RESERVE;
 
-	alloc_flags = alloc_flags_cma(gfp_mask, alloc_flags);
+	alloc_flags |= alloc_flags_cma(gfp_mask);
 
 	if (defrag_mode)
 		alloc_flags |= ALLOC_NOFRAGMENT;
@@ -4837,7 +4836,7 @@ retry:
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
-		alloc_flags = alloc_flags_cma(gfp_mask, reserve_flags) |
+		alloc_flags = alloc_flags_cma(gfp_mask) | reserve_flags |
 				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
 
 	/*
@@ -5070,7 +5069,7 @@ static inline bool prepare_alloc_pages(g
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	*alloc_flags = alloc_flags_cma(gfp_mask, *alloc_flags);
+	*alloc_flags |= alloc_flags_cma(gfp_mask);
 
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

