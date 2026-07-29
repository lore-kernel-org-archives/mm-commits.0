Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C31B38AC96
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298397; cv=none; b=ZouU4fQGGYO5cN0uryF/6vY1rXsutodG7RpsJyupLOH0r+gb3Rcu323byLGlGh/YTEBv30tAOa6u03S1DKoOfIPaJroq+dEQOjmvj9bdabjhv0xnvtTGPLLRATv/qSnQppZAO6S4wasljGmScKf65KNnmpd36oPinHpAC0DXfGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298397; c=relaxed/simple;
	bh=Ll8UeNiMxRAFpq4o905E6LyQBZR1P/1dvx+wQ0pINoI=;
	h=Date:To:From:Subject:Message-Id; b=FBvLTNPRw8nBr9waIQHvq6t44JkX0FpYyvWIXvitIBRHV6JJxIKCEJR96aEcT7n+PQtBPqLCuCASY89UXEdhr+ehd7OWgKQ0fKJjDpws3NGNnyYrxxFs7lpH/jEzvMP+7e+QEaBjuTNBinDXOO5mst6JkbKxms3R5R3O4Q3W3pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OPQ6pHHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OPQ6pHHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E543F1F00A3A;
	Wed, 29 Jul 2026 04:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298396;
	bh=P+OUd2tAVm6qjEOFygkNniLxd+FvW58wyp7m9yfWe2Y=;
	h=Date:To:From:Subject;
	b=OPQ6pHHKGW+xj1X3fDvO62Faz0dOJzuJ/FLpOk4kf4J9emaLAKsDnhUtxPkOJDJtT
	 AgYPQ0GWP3mU3wflEM3wLWKtv8t+mMMD/24SJo7kNoF9bYVy48IH9RDtxpV/asbUsF
	 3L4BNdNN8vW7Azwo7STi7Zn57ZoUQGTWtVbBRkws=
Date: Tue, 28 Jul 2026 21:13:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,sj@kernel.org,david@kernel.org,chengming.zhou@linux.dev,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pagetranscompound.patch removed from -mm tree
Message-Id: <20260729041315.E543F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageTransCompound()
has been removed from the -mm tree.  Its filename was
     mm-remove-pagetranscompound.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove PageTransCompound()
Date: Thu, 18 Jun 2026 19:35:23 +0800

Remove the last user of PageTransCompound() in ksm and get rid of
PageTransCompound().

Link: https://lore.kernel.org/20260618113523.3913307-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Tested-by: Xu Xin <xu.xin16@zte.com.cn>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   14 --------------
 mm/ksm.c                   |   17 +++++++++--------
 2 files changed, 9 insertions(+), 22 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagetranscompound
+++ a/include/linux/page-flags.h
@@ -879,20 +879,6 @@ FOLIO_FLAG_FALSE(partially_mapped)
 
 #define PG_head_mask ((1UL << PG_head))
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/*
- * PageTransCompound returns true for both transparent huge pages
- * and hugetlbfs pages, so it should only be called when it's known
- * that hugetlbfs pages aren't involved.
- */
-static inline int PageTransCompound(const struct page *page)
-{
-	return PageCompound(page);
-}
-#else
-TESTPAGEFLAG_FALSE(TransCompound, transcompound)
-#endif
-
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
 /*
  * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
--- a/mm/ksm.c~mm-remove-pagetranscompound
+++ a/mm/ksm.c
@@ -2327,23 +2327,24 @@ static void cmp_and_merge_page(struct pa
 	tree_rmap_item =
 		unstable_tree_search_insert(rmap_item, page, &tree_page);
 	if (tree_rmap_item) {
+		struct folio *tree_folio;
 		bool split;
 
 		kfolio = try_to_merge_two_pages(rmap_item, page,
 						tree_rmap_item, tree_page);
+		tree_folio = page_folio(tree_page);
 		/*
-		 * If both pages we tried to merge belong to the same compound
-		 * page, then we actually ended up increasing the reference
-		 * count of the same compound page twice, and split_huge_page
-		 * failed.
+		 * If both pages we tried to merge belong to the same (large)
+		 * folio, then we actually ended up increasing the reference
+		 * count of the same folio twice, and split_huge_page failed.
+		 *
 		 * Here we set a flag if that happened, and we use it later to
-		 * try split_huge_page again. Since we call put_page right
+		 * try split_huge_page again. Since we call folio_put() right
 		 * afterwards, the reference count will be correct and
 		 * split_huge_page should succeed.
 		 */
-		split = PageTransCompound(page)
-			&& compound_head(page) == compound_head(tree_page);
-		put_page(tree_page);
+		split = folio == tree_folio;
+		folio_put(tree_folio);
 		if (kfolio) {
 			/*
 			 * The pages were successfully merged: insert new
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-improve-mincore_hugetlb-fix.patch
mm-mincore-refactor-mincore_page.patch

