Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E9917C220;
	Thu, 22 Aug 2024 18:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724349816; cv=none; b=oqCBAVTyN3AAtcRqQiFXrD6SVIY7OtgLC/xDFo37H8EkIf+QxtD3Ijj2pb6j4HdyQJPgGnArXNbEwy2Qf896+Mc0xJiOnFiyyQuoqcUKpW/3q0dtq0ntV7h2ETqJ4AlfLLzzn4aRVwLNt+kXneEbXWLJy1OKvGBKjeWK0ftsl+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724349816; c=relaxed/simple;
	bh=gr3S8ktoJyMn1jKPhSjw3jsHWwnV8gxwwtqDDDkTOok=;
	h=Date:To:From:Subject:Message-Id; b=ZI5RlVssotSp2rGslOhvRYLNbA/DORWahwxbgDc0dLFm9769NcTi1Ynq9uFeG4q/SHsQIK6y/90TlHjGtuKwKsukmi3RyOfGaZ9SRm/kMfxv189rmWXQt164tkGXi/eGSzHL4p9t8RwOCJ2LNVfJJE1PIuQhDFmNwXxDls7OSWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=quHScmSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="quHScmSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12784C32782;
	Thu, 22 Aug 2024 18:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724349815;
	bh=gr3S8ktoJyMn1jKPhSjw3jsHWwnV8gxwwtqDDDkTOok=;
	h=Date:To:From:Subject:From;
	b=quHScmSidZl9ca7nGACl+UzgC5EVFxZ3gDDIgM+gERzCDuGDntAcwptbbKa0X4xaA
	 Rg7Y6i82hr0HXnTorPKvJg3Rw6gJN4SNAVrs3USWrzY35Cd2UhOIMOvfPuyQ74equt
	 HKuDCKqHfptP2sweqmALPn6vsWmep1jXKv+/KRtw=
Date: Thu, 22 Aug 2024 11:03:33 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,yuzhao@google.com,willy@infradead.org,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,leitao@debian.org,huangzhaoyang@gmail.com,hannes@cmpxchg.org,david@redhat.com,bharata@amd.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-skip-cma-pages-when-they-are-not-available-update.patch added to mm-hotfixes-unstable branch
Message-Id: <20240822180335.12784C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: revert-mm-skip-cma-pages-when-they-are-not-available-update
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-skip-cma-pages-when-they-are-not-available-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-skip-cma-pages-when-they-are-not-available-update.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: revert-mm-skip-cma-pages-when-they-are-not-available-update
Date: Wed, 21 Aug 2024 20:26:07 +0100

also revert b7108d66318a ("Multi-gen LRU: skip CMA pages when they are not
eligible"), per Johannes

Link: https://lkml.kernel.org/r/9060a32d-b2d7-48c0-8626-1db535653c54@gmail.com
Link: https://lkml.kernel.org/r/357ac325-4c61-497a-92a3-bdbd230d5ec9@gmail.com
Fixes: 5da226dbfce3 ("mm: skip CMA pages when they are not available")
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

--- a/mm/vmscan.c~revert-mm-skip-cma-pages-when-they-are-not-available-update
+++ a/mm/vmscan.c
@@ -4253,25 +4253,6 @@ void lru_gen_soft_reclaim(struct mem_cgr
 
 #endif /* CONFIG_MEMCG */
 
-#ifdef CONFIG_CMA
-/*
- * It is waste of effort to scan and reclaim CMA pages if it is not available
- * for current allocation context. Kswapd can not be enrolled as it can not
- * distinguish this scenario by using sc->gfp_mask = GFP_KERNEL
- */
-static bool skip_cma(struct folio *folio, struct scan_control *sc)
-{
-	return !current_is_kswapd() &&
-			gfp_migratetype(sc->gfp_mask) != MIGRATE_MOVABLE &&
-			folio_migratetype(folio) == MIGRATE_CMA;
-}
-#else
-static bool skip_cma(struct folio *folio, struct scan_control *sc)
-{
-	return false;
-}
-#endif
-
 /******************************************************************************
  *                          the eviction
  ******************************************************************************/
@@ -4319,7 +4300,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (zone > sc->reclaim_idx || skip_cma(folio, sc)) {
+	if (zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

revert-mm-skip-cma-pages-when-they-are-not-available.patch
revert-mm-skip-cma-pages-when-they-are-not-available-update.patch

