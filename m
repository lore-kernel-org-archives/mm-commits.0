Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2741F22D4F6
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343239; cv=none; b=O1MyBzkHBjh2MSrf0agvxfQz10eH2/Qd9XamhX3Qgdv78UAeiDZGbjnOTyWcLU9+IFtZIWtUScmrFYRqIPvasEukooiIkgai66Z+6FCU30Y/SjDGiuv9e3XBQ16el1vqygm0y2K/xFIad5MvLo9nuICff2BTp9y6dE6B4KHxLVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343239; c=relaxed/simple;
	bh=7KHIL27A/UHc56IsqwAfo3rfS9KReHeJYwErfIGNpNA=;
	h=Date:To:From:Subject:Message-Id; b=etJtB7tiXC23tWN4m3gVK8Df9SaSMQ6ea5A4rdzhXE4piM4f/cTf4FS7iAb7kldEXcK1yL7Y9xAWf0OLy16pDTq2ara9fFHDPyLQPJMQBPMDRLiHbmEc7XSMdHnifMDgRWO+ame9aPDX3+OLqY0XgbXQZ5ulwU06mb3Os+SvddA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s50PhWvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s50PhWvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65C3C19422;
	Mon, 17 Nov 2025 01:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343239;
	bh=7KHIL27A/UHc56IsqwAfo3rfS9KReHeJYwErfIGNpNA=;
	h=Date:To:From:Subject:From;
	b=s50PhWvVwHzM4+VV6c6kgcBXwEVykiC3OYx3SszKNJmE5MNE+Dm68JREn1GI+uOBy
	 X5LdEE7PZ3GQANmzgWz0IuL0u0UiVOK/eo+U9GTD9RRLWD8jRu3Htw8DpX69xdweUb
	 8cw6nas4Fll6atey6PdKJpm5MF6G2VffZVKnc1C4=
Date: Sun, 16 Nov 2025 17:33:58 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-swap-drop-usage-of-folio_index.patch removed from -mm tree
Message-Id: <20251117013358.E65C3C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate, swap: drop usage of folio_index
has been removed from the -mm tree.  Its filename was
     mm-migrate-swap-drop-usage-of-folio_index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -562,7 +562,7 @@ unlock:
 static int __folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int expected_count)
 {
-	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
+	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct swap_cluster_info *ci = NULL;
 	struct zone *oldzone, *newzone;
 	int dirty;
@@ -715,7 +715,7 @@ EXPORT_SYMBOL(folio_migrate_mapping);
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


