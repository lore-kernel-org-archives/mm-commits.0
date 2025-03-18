Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E391CB51F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274659; cv=none; b=PNcYJeFFhlMf/2grl2uEFxb9RdoWPOUTXtZRrqONXeNsQdCKs+ipESjZVClh7RtpLxSFsmXygCSu650fvS0FFj6iTMV0cFsR6DA7AIOlHxi0QW6A15bjow0wGAqwNZXotXjsYDqSf6jAAVb3X92nKx3E9iCXuLGoiGpF1H8T0hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274659; c=relaxed/simple;
	bh=iA3s3GPaojjt8GJhdUSUoBhUKvxqMJCqoE0B65P0sfI=;
	h=Date:To:From:Subject:Message-Id; b=HSFVaRDC+tX8GlGeLNTx8l0trlGPnfXc6380/yTXgh2HEca2GZwTdxFr1SbNefpRaEpl+TfJ55wZTI1QqNmqcSVNmetMy+f+gpYTBV/e3+MwLcyOYCCzgs6pgZkUnPdVXt+D3KK7UGL9YV5agByaI39MYeQEB+MisVrP1P89aPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nK/G5qVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nK/G5qVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18605C4CEDD;
	Tue, 18 Mar 2025 05:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274659;
	bh=iA3s3GPaojjt8GJhdUSUoBhUKvxqMJCqoE0B65P0sfI=;
	h=Date:To:From:Subject:From;
	b=nK/G5qVl9CBejcwYy9uCpnzU6CB/02H7YFbh8XwzYJxjv+/7SImFareMYn9vEtewF
	 2q5tml3Yy/rgw5Bt1T7DTBOcSEaqOg+YGgjmRq6e6zJanvIgUTt7GZiN5iHIU/mneH
	 47vCuuPU0FLFQWJ9CM/Vh5C5TJhmdmxRTQ5h3YpE=
Date: Mon, 17 Mar 2025 22:10:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch removed from -mm tree
Message-Id: <20250318051059.18605C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert lru_add_page_tail() to lru_add_split_folio()
has been removed from the -mm tree.  Its filename was
     mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch

