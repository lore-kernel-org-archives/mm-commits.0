Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C801F4596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291527; cv=none; b=gRQk2hQjAFGiUL3rKwcFgB++4zltiU79SOKJ47t6HYKsXsR7YbQUojZTbOllr/PzW+oCbvdGHud8VO0paa5LxnNBytgTKh2FE8bBgdjbsC5P90puk6j40KZJoVfDPvtmY6basD9RaNp+XGp9IhZxe8mztIZPlaOxoQEUXFbE8V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291527; c=relaxed/simple;
	bh=3EwFAApQbvKPGeqHYrGLiqlkXu9mHQhSfCKA4SP/w54=;
	h=Date:To:From:Subject:Message-Id; b=hyGMxCkjP2Una/5FEW7kdvZ5b3HjYyfABrZ+yWs6PA7KaCM4dLwIxCALEqHRTSJ1CDux+uhVWeNP5aUwJItsdcyhGlJFh13jNQNfLG7acx1gpJWG5PoAH6Nc4GCjQgzc6nkrer4P2V75e9+OD1CUAfcTZgOH3gOOFUxEbGYvg50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fAIemBEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fAIemBEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9553BC32782;
	Tue, 25 Jun 2024 04:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291527;
	bh=3EwFAApQbvKPGeqHYrGLiqlkXu9mHQhSfCKA4SP/w54=;
	h=Date:To:From:Subject:From;
	b=fAIemBEUtYpO2LMhUUe5eYuyiaK/RYSekDkZrPAgY+odE7V+7mC2HGo3QW2ku7iTm
	 JL4weFL3xut6SqxaXR2OQl201bqYh2RyCAt3PMLy2PBf0yr7u7lrXZ5CxFnfKZoaGo
	 OPN7X75FTOnjSGYuTgl9PNLsHBB9Uj55VTVIQLaQ=
Date: Mon, 24 Jun 2024 21:58:47 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,peterx@redhat.com,muchun.song@linux.dev,anshuman.khandual@arm.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch removed from -mm tree
Message-Id: <20240625045847.9553BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: drop node_alloc_noretry from alloc_fresh_hugetlb_folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/hugetlb: drop node_alloc_noretry from alloc_fresh_hugetlb_folio
Date: Thu, 16 May 2024 10:10:35 +0200

Since commit d67e32f26713 ("hugetlb: restructure pool allocations"), the
parameter node_alloc_noretry from alloc_fresh_hugetlb_folio() is not used,
so drop it.

Link: https://lkml.kernel.org/r/20240516081035.5651-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -2289,13 +2289,11 @@ static struct folio *only_alloc_fresh_hu
  * pages is zero.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+		gfp_t gfp_mask, int nid, nodemask_t *nmask)
 {
 	struct folio *folio;
 
-	folio = __alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask,
-						node_alloc_noretry);
+	folio = __alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
 	if (!folio)
 		return NULL;
 
@@ -2513,7 +2511,7 @@ static struct folio *alloc_surplus_huget
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
 	if (!folio)
 		return NULL;
 
@@ -2549,7 +2547,7 @@ static struct folio *alloc_migrate_huget
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
 	if (!folio)
 		return NULL;
 
@@ -3474,7 +3472,7 @@ static void __init hugetlb_hstate_alloc_
 			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 			folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-					&node_states[N_MEMORY], NULL);
+					&node_states[N_MEMORY]);
 			if (!folio)
 				break;
 			free_huge_folio(folio); /* free it into the hugepage allocator */
_

Patches currently in -mm which might be from osalvador@suse.de are


