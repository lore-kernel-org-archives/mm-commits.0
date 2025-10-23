Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1833B29405
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 19:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761247182; cv=none; b=lIv1WHkSO4yD92b6m6VXEJx5Zz4fxsFHNN66JFnZF/mUFT21YbPOisWG7JRM5HxGOsrb034n/eq8z5vVNMDZW3jsvm1YuKGjFuZck33/lSqj5vmRGTFAvGTkyjopbxfye7/8VbOgVcLdg/JpAve/3M3B70+WNXuDiZxsEZIsAyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761247182; c=relaxed/simple;
	bh=MigUJN+wZTz6RiaNWHNxUUR0xHcp79z0zqWNOh44jEQ=;
	h=Date:To:From:Subject:Message-Id; b=RYfENxwgxK7UFfGoDt3WN+iHjsfvxcxv1QfsyQnYa+jfhvf6qf5INdwbm3S7bYCcBPcg+FSwD3AcbaqUJWJrC9GrVp9KwBbOy+H2HD5//LEGN2o1/69Ha1N/3cLE9ezpHRZjlulmaImlJIurUm8L2WCm7zNs4jaOcKYNQ2mLPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KwEF0wqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KwEF0wqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DECFC4CEE7;
	Thu, 23 Oct 2025 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761247181;
	bh=MigUJN+wZTz6RiaNWHNxUUR0xHcp79z0zqWNOh44jEQ=;
	h=Date:To:From:Subject:From;
	b=KwEF0wqfuh7GD72lD5Vb5LA8qa/PnDZwxQxojfCDcZAhIzbo7Vuz43V3WU5tNASpo
	 /+IQBobv9V2mPh2S8V4GxKsYwpCKJOnsjUNolulgiMhyUj+zTXvDwSvh1G60zX68Cu
	 zrZnNXQ39xuSXkb7zHxvWGF06kkho40DVro2n98M=
Date: Thu, 23 Oct 2025 12:19:40 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-swap-drop-usage-of-folio_index.patch added to mm-new branch
Message-Id: <20251023191941.7DECFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate, swap: drop usage of folio_index
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-swap-drop-usage-of-folio_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-swap-drop-usage-of-folio_index.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/migrate, swap: drop usage of folio_index
Date: Fri, 24 Oct 2025 02:00:42 +0800

This helper was used when swap cache was mixed with page cache.  Now they
are completely separate from each other, access to the swap cache is all
wrapped by the swap_cache_* helpers, which expect the folio's swap entry
as a parameter.

This helper is no longer used, remove the last redundant user and drop it.

Link: https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-4-a709469052e7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 mm/swap.h    |   21 ---------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

--- a/mm/migrate.c~mm-migrate-swap-drop-usage-of-folio_index
+++ a/mm/migrate.c
@@ -563,7 +563,7 @@ unlock:
 static int __folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int expected_count)
 {
-	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
+	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct swap_cluster_info *ci = NULL;
 	struct zone *oldzone, *newzone;
 	int dirty;
@@ -716,7 +716,7 @@ EXPORT_SYMBOL(folio_migrate_mapping);
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 				   struct folio *dst, struct folio *src)
 {
-	XA_STATE(xas, &mapping->i_pages, folio_index(src));
+	XA_STATE(xas, &mapping->i_pages, src->index);
 	int rc, expected_count = folio_expected_ref_count(src) + 1;
 
 	if (folio_ref_count(src) != expected_count)
--- a/mm/swap.h~mm-migrate-swap-drop-usage-of-folio_index
+++ a/mm/swap.h
@@ -445,25 +445,4 @@ static inline int non_swapcache_batch(sw
 	return 0;
 }
 #endif /* CONFIG_SWAP */
-
-/**
- * folio_index - File index of a folio.
- * @folio: The folio.
- *
- * For a folio which is either in the page cache or the swap cache,
- * return its index within the address_space it belongs to.  If you know
- * the folio is definitely in the page cache, you can look at the folio's
- * index directly.
- *
- * Return: The index (offset in units of pages) of a folio in its file.
- */
-static inline pgoff_t folio_index(struct folio *folio)
-{
-#ifdef CONFIG_SWAP
-	if (unlikely(folio_test_swapcache(folio)))
-		return swp_offset(folio->swap);
-#endif
-	return folio->index;
-}
-
 #endif /* _MM_SWAP_H */
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-fix-thp-allocation-and-fallback-loop.patch
mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch

