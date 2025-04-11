Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48251290BD9
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 21:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744406479; cv=none; b=GyBiiyYywQoO1AMYEpWy84kiRB7DKwn83G8XQ8IUoQ9Tn4FdJ8KRkMLSZtozXu5L2+zuhR34kwHjwhO7lFaWcBj4fdS8RUpFImKFGKFOX/ox2rpE9tur2BRjXTTv/B6LH2PpxeT76XaCbmQ9C3Y6ypFEB1By/kTw8By0Kre8ATI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744406479; c=relaxed/simple;
	bh=TMlulS0SaFRPC+EU5M7aHI0M7KHuBy3rcK00IX9hGzE=;
	h=Date:To:From:Subject:Message-Id; b=sBSEedrReD0Mcrp9ZxFnk/JZteV0vtwaztdYJf+guNPo2TYfPOt0wnIOX8DDOu7JadOLDTAnBSjoyEBfU+kK3nvXLkeJBQ2M+9bnsalLCsjyYbKVv0A3GjyA/mQOkxXPMcbhtLr3i+/N3xMfnk2gqpPQDKwu4jCLrGNH3G7t4HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YYRNjaZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YYRNjaZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A210DC4CEE2;
	Fri, 11 Apr 2025 21:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744406477;
	bh=TMlulS0SaFRPC+EU5M7aHI0M7KHuBy3rcK00IX9hGzE=;
	h=Date:To:From:Subject:From;
	b=YYRNjaZbPF0cVisz6ecqOrZg2aJQOkBNIBeChfaUfy8wBhFboEXEEb6yypkx9m01P
	 AcyKCx2nG5FxeBKkv1jGowMgR2MxvRT/X/TLBwh9kBIKXYeTwQuzkQcClXdNoNvCwR
	 rGKknQNnuNhwsxql/YkFIkD10c7orANaP+sLbNzc=
Date: Fri, 11 Apr 2025 14:21:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,muchun.song@linux.dev,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch added to mm-new branch
Message-Id: <20250411212117.A210DC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,hugetlb: allocate frozen pages in alloc_buddy_hugetlb_folio
has been added to the -mm mm-new branch.  Its filename is
     mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch

This patch will later appear in the mm-new branch at
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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: allocate frozen pages in alloc_buddy_hugetlb_folio
Date: Fri, 11 Apr 2025 15:23:59 +0200

alloc_buddy_hugetlb_folio() allocates a rmappable folio, then strips the
rmappable part and freezes it.  We can simplify all that by allocating
frozen pages directly.

Link: https://lkml.kernel.org/r/20250411132359.312708-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1951,7 +1951,6 @@ static struct folio *alloc_buddy_hugetlb
 	int order = huge_page_order(h);
 	struct folio *folio;
 	bool alloc_try_hard = true;
-	bool retry = true;
 
 	/*
 	 * By default we always try hard to allocate the folio with
@@ -1966,22 +1965,8 @@ static struct folio *alloc_buddy_hugetlb
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
-retry:
-	folio = __folio_alloc(gfp_mask, order, nid, nmask);
-	/* Ensure hugetlb folio won't have large_rmappable flag set. */
-	if (folio)
-		folio_clear_large_rmappable(folio);
 
-	if (folio && !folio_ref_freeze(folio, 1)) {
-		folio_put(folio);
-		if (retry) {	/* retry once */
-			retry = false;
-			goto retry;
-		}
-		/* WOW!  twice in a row. */
-		pr_warn("HugeTLB unexpected inflated folio ref count\n");
-		folio = NULL;
-	}
+	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
_

Patches currently in -mm which might be from osalvador@suse.de are

maintainers-update-hugetlb-reviewers.patch
mmhugetlb-allocate-frozen-pages-in-alloc_buddy_hugetlb_folio.patch

