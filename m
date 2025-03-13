Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E9C1F4615
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 20:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741898642; cv=none; b=E5aDxLwc4B9A+vfgYqphKvzlecWnCLaBvlN4yhEniTS2nKsKc2Hv/Y703IwUNAA+WTbmhp3fRN+lRokOyAApoG3aVhI/mSfMO/AE67aUkIqkA1ZABln/3x1bISKnhQaDRycKJFuXO9qdsr3JmeltwxhbinbdmNU1Qli7ri8Wrh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741898642; c=relaxed/simple;
	bh=00hjBZamOOFGKdnU9OLg/zGhzmzf/ymwCCvgc4q+raQ=;
	h=Date:To:From:Subject:Message-Id; b=Eli0DRTmhuN3JApyBxmKJqEz3tixfEYcMRtw05ku/j0F8OFoCBSGt2/BNrb+T3G0ZZjRxsmQbaoCdxm7CR8rrFdXibGwlmpRyr0boosresAPkeXmlZeOUwBr8i1z01EZbm/S4XVyJMlVLi27AjnhoYEdmdbSEb3sGyDHV1fSAFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tQRWWHao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tQRWWHao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C45C4CEDD;
	Thu, 13 Mar 2025 20:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741898641;
	bh=00hjBZamOOFGKdnU9OLg/zGhzmzf/ymwCCvgc4q+raQ=;
	h=Date:To:From:Subject:From;
	b=tQRWWHaoW2Ih4bba1AMYgAFFAo8PiFQE0OBjmnaK43mge2sNgmCal5ReT/dWBCwHr
	 DTaC5mZy4R+F1zlFbERZUy9pK1cdH8o7BEY5CIBm3oSamRFDwVMGVV8JAv+T8rvmTK
	 7L0rBAtoZ32lrmCz7aknjstTYQTHyGNKRu5c+97I=
Date: Thu, 13 Mar 2025 13:44:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch added to mm-unstable branch
Message-Id: <20250313204401.98C45C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert lru_add_page_tail() to lru_add_split_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch

This patch will later appear in the mm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert lru_add_page_tail() to lru_add_split_folio()
Date: Thu, 13 Mar 2025 15:14:56 +0000

Remove three hidden calls to compound_head() and accesses to page->lru.

Link: https://lkml.kernel.org/r/20250313151458.4145978-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-convert-lru_add_page_tail-to-lru_add_split_folio
+++ a/mm/huge_memory.c
@@ -3262,25 +3262,25 @@ static void remap_page(struct folio *fol
 	}
 }
 
-static void lru_add_page_tail(struct folio *folio, struct page *tail,
+static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
 		struct lruvec *lruvec, struct list_head *list)
 {
-	VM_BUG_ON_FOLIO(PageLRU(tail), folio);
+	VM_BUG_ON_FOLIO(folio_test_lru(new_folio), folio);
 	lockdep_assert_held(&lruvec->lru_lock);
 
 	if (list) {
 		/* page reclaim is reclaiming a huge page */
 		VM_WARN_ON(folio_test_lru(folio));
-		get_page(tail);
-		list_add_tail(&tail->lru, list);
+		folio_get(new_folio);
+		list_add_tail(&new_folio->lru, list);
 	} else {
 		/* head is still on lru (and we have it frozen) */
 		VM_WARN_ON(!folio_test_lru(folio));
 		if (folio_test_unevictable(folio))
-			tail->mlock_count = 0;
+			new_folio->mlock_count = 0;
 		else
-			list_add_tail(&tail->lru, &folio->lru);
-		SetPageLRU(tail);
+			list_add_tail(&new_folio->lru, &folio->lru);
+		folio_set_lru(new_folio);
 	}
 }
 
@@ -3581,8 +3581,8 @@ after_split:
 					((mapping || swap_cache) ?
 						folio_nr_pages(release) : 0));
 
-			lru_add_page_tail(origin_folio, &release->page,
-						lruvec, list);
+			lru_add_split_folio(origin_folio, release, lruvec,
+					list);
 
 			/* Some pages can be beyond EOF: drop them from cache */
 			if (release->index >= end) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-decline-to-manipulate-the-refcount-on-a-slab-page.patch
dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
fs-convert-block_commit_write-to-take-a-folio.patch
fs-remove-page_file_mapping.patch
fs-remove-folio_file_mapping.patch
mm-assert-the-folio-is-locked-in-folio_start_writeback.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

