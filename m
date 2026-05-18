Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD203AA4E7
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779142925; cv=none; b=kj5HW7M5Q6pnOhr1RJHA6Q83S0QlyoTD3SCXsNYvmeBk50nPQe9tSJ3YqTyGG3r8AuIZ9tXGIIPaAUVAN2GM0czOeoJPpSXvsMJKZdOAsUMzot2uowHpCTp/MPM3+SEy1MYypdi1mNgZ9wd/Pyl9JcJh4A//e4orvIgFlMwHh94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779142925; c=relaxed/simple;
	bh=dzShBOxEAeiw2tddVQ5pXFzZWtHNg6WzzkCQj5y2LWU=;
	h=Date:To:From:Subject:Message-Id; b=XHp2WiKPRO/d8m6PFckaowGXb+FnzTqQkuAGrkSZQEziM5O0rI8syz7E67BJSIBljqPveuOl3DDcI1uS/n6mQt6VQFGvppWqMltK9SeUObnFqqIJNk9qjaNqXq6JzstFj53tsZaeKd9+jdj3B2zyUv15zCWXewunyhs9niRDcHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xgEqAdSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xgEqAdSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739E1C2BCB7;
	Mon, 18 May 2026 22:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779142925;
	bh=dzShBOxEAeiw2tddVQ5pXFzZWtHNg6WzzkCQj5y2LWU=;
	h=Date:To:From:Subject:From;
	b=xgEqAdSABSPSCIqtOXFNP8cDFZ91tfS0//MsxOs46IYpxtrv4hsaJMAPSbT87j+Cc
	 gl3pNbmLYUpvUXq/uIvY6Br7hv3dJ0+3S6e1YojzVlOZvu8+v2/mpGIVBjzpxpGfED
	 Pq7ACHi3DPVZIaGzpwQNFY/JEX186ch+goeOeB4o=
Date: Mon, 18 May 2026 15:22:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch added to mm-unstable branch
Message-Id: <20260518222205.739E1C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: use folio_split() in truncate_inode_partial_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Sun, 17 May 2026 09:54:11 -0400

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

Link: https://lore.kernel.org/20260517135416.1434539-10-ziy@nvidia.com
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

mm-khugepaged-remove-read_only_thp_for_fs-check.patch
mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch
mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

