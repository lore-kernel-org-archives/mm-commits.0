Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32723399365
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141575; cv=none; b=DVHZnLW+3XhecN9UlFZlgOm2FJ01/zDZrNc7ZtPD/VZxHM66AwmW9PgBwiiy1YJRtxqprs2qFpd65VCxG/tlgmoiB5tmJv0Ga+gJT96kC369fEGzB5tw42QHFVf0jHwsvK7DPXitLRpR7GO8VOD+la1DQQt8JDDGNRfpxfAlVZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141575; c=relaxed/simple;
	bh=kcpbdlQonsWK9Iccdqwm/HqFQTe8xblnihTWV668Re8=;
	h=Date:To:From:Subject:Message-Id; b=ItvWhYK0ZhLAvoROGmKgp31bsPU/6i1UjlQtkzkcfr7j0DL1yg1czlUZ8bABUlfoXnTW1Qlg1pnagy7BV6m6wt15PkdlNCk9Bl6aaqtPGDkJN1IZSLqwRWSX7JfssXYysmJsT+ADT+HcvoUVWfjxCkH8Jvq6gLeeG24Nyzj+fU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DXXQPYZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DXXQPYZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB70C2BCB7;
	Mon, 18 May 2026 21:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141574;
	bh=kcpbdlQonsWK9Iccdqwm/HqFQTe8xblnihTWV668Re8=;
	h=Date:To:From:Subject:From;
	b=DXXQPYZ8BPlBv2aPEdilrp0kxCM4upwEr15L78MkKetKKxH8NbpVKTNK8WgqVzqBJ
	 a/++QDFyN7kGRaHW2MlG6Q2TWxUGYK9kMwD6mYKOJqFg+ek924CUUsV9riL0lZkUIq
	 e8bsUDg9OGnAXeWKo3bMKk7K6FCmnc2xNozbUEls=
Date: Mon, 18 May 2026 14:59:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch removed from -mm tree
Message-Id: <20260518215934.CCB70C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/truncate: use folio_split() in truncate_inode_partial_folio()
has been removed from the -mm tree.  Its filename was
     mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Wed, 29 Apr 2026 11:35:32 -0400

After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
not.  folio_split() can be used on a FS with large folio support without
worrying about getting a THP on a FS without large folio support.

When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
appear in a FS without large folio support after khugepaged or
madvise(MADV_COLLAPSE) creates it.  During truncate_inode_partial_folio(),
such a PMD large pagecache folio is split and if the FS does not support
large folio, it needs to be split to order-0 ones and could not be split
non uniformly to ones with various orders.  try_folio_split_to_order() was
added to handle this situation by checking folio_check_splittable(...,
SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
READ_ONLY_THP_FOR_FS and the FS does not support large folio.  Now
READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
with FSes supporting large folio, this function is no longer needed and
all large pagecache folios can be split non uniformly.

Link: https://lore.kernel.org/20260429153538.727855-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   25 ++-----------------------
 mm/truncate.c           |    8 ++++----
 2 files changed, 6 insertions(+), 27 deletions(-)

--- a/include/linux/huge_mm.h~mm-truncate-use-folio_split-in-truncate_inode_partial_folio
+++ a/include/linux/huge_mm.h
@@ -394,27 +394,6 @@ static inline int split_huge_page_to_ord
 	return split_huge_page_to_list_to_order(page, NULL, new_order);
 }
 
-/**
- * try_folio_split_to_order() - try to split a @folio at @page to @new_order
- * using non uniform split.
- * @folio: folio to be split
- * @page: split to @new_order at the given page
- * @new_order: the target split order
- *
- * Try to split a @folio at @page using non uniform split to @new_order, if
- * non uniform split is not supported, fall back to uniform split. After-split
- * folios are put back to LRU list. Use min_order_for_split() to get the lower
- * bound of @new_order.
- *
- * Return: 0 - split is successful, otherwise split failed.
- */
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
-{
-	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
-		return split_huge_page_to_order(&folio->page, new_order);
-	return folio_split(folio, new_order, page, NULL);
-}
 static inline int split_huge_page(struct page *page)
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
@@ -647,8 +626,8 @@ static inline int split_folio_to_list(st
 	return -EINVAL;
 }
 
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
+static inline int folio_split(struct folio *folio, unsigned int new_order,
+		struct page *page, struct list_head *list)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
--- a/mm/truncate.c~mm-truncate-use-folio_split-in-truncate_inode_partial_folio
+++ a/mm/truncate.c
@@ -177,7 +177,7 @@ int truncate_inode_folio(struct address_
 	return 0;
 }
 
-static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
+static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 				    unsigned long min_order)
 {
 	enum ttu_flags ttu_flags =
@@ -186,7 +186,7 @@ static int try_folio_split_or_unmap(stru
 		TTU_IGNORE_MLOCK;
 	int ret;
 
-	ret = try_folio_split_to_order(folio, split_at, min_order);
+	ret = folio_split(folio, min_order, split_at, NULL);
 
 	/*
 	 * If the split fails, unmap the folio, so it will be refaulted
@@ -252,7 +252,7 @@ bool truncate_inode_partial_folio(struct
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
+	if (!folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -279,7 +279,7 @@ bool truncate_inode_partial_folio(struct
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split_or_unmap(folio2, split_at2, min_order);
+			folio_split_or_unmap(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
_

Patches currently in -mm which might be from ziy@nvidia.com are

fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

