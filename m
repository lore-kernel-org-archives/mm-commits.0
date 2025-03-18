Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ABC7A13A
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 04:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273356; cv=none; b=QpPicXCJYU5WwJ8Aw7HguPucQ/odlOUA06S2KJEpkBPHeMdDJzLEfrJFSO4dEtqYISfqsRetNuMyycNTrCd0m/AEkLWpnpD9Kqimp0jmFR+/O4RQ/bLRSI5L43AQfbUhs6FaGWLbOVpujSisJ4IquD9y0onIMT+zDAjd/j5EDtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273356; c=relaxed/simple;
	bh=HBIb81Cx/aYcxNRRJz+uixKDFwzfg4hkR1//Nq3tgvU=;
	h=Date:To:From:Subject:Message-Id; b=DqV+k1GHJGGiEH5ucT0qJdeC3gi7lk0PMrMYYVno8E7bo7x2hAh6LKAaOSE4TAfHBaCo9d6macl7UfSmuDl32g1xWHxMXAc9oAjPcbj4PxsnSXyAeswlxgiDpAqsUTOrkrlD1CJABr8xpx4Atv3ABvJoAXGQqdjwWIbtxthYmL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8F4fV6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8F4fV6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B7BC4CEEA;
	Tue, 18 Mar 2025 04:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742273354;
	bh=HBIb81Cx/aYcxNRRJz+uixKDFwzfg4hkR1//Nq3tgvU=;
	h=Date:To:From:Subject:From;
	b=A8F4fV6SSU8T8xgpXCjNXta0T1fmOvoZrMe/3NPgdH0JmTGPthaBN0RNpud6YmtdE
	 NAXPZuqEDOLtqDBXzVXDnAq29isbxHMczy/0Lp49r4ocRMKd/4GYOgRGOb7Nm+HaIB
	 OFeWccA6leN3DjsiXRVEhXFeqyrpfQMRuv3y5xpI=
Date: Mon, 17 Mar 2025 21:49:13 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch removed from -mm tree
Message-Id: <20250318044913.E0B7BC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: unfreeze head folio after page cache entries are updated
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch

This patch was dropped because it was folded into mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: unfreeze head folio after page cache entries are updated
Date: Mon, 10 Mar 2025 11:59:42 -0400

Otherwise others can grab the head folio and see stale page cache entries.
Data corruption can happen because of that.

Drop large EOF tail folios with the right number of refs to prevent memory
leak.

Also include Matthew's suggestion on __split_folio_to_order()[1]

[1] https://lore.kernel.org/all/Z88ar5YS99HsIRYo@casper.infradead.org/

Link: https://lkml.kernel.org/r/0F15DA7F-1977-412F-9A3E-F06B515D4BD2@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Hugh Dickins <hughd@google.com>
Closes: https://lore.kernel.org/all/fcbadb7f-dd3e-21df-f9a7-2853b53183c4@google.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   52 +++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix
+++ a/mm/huge_memory.c
@@ -3525,15 +3525,14 @@ static void __split_folio_to_order(struc
 {
 	long new_nr_pages = 1 << new_order;
 	long nr_pages = 1 << old_order;
-	long index;
+	long i;
 
 	/*
 	 * Skip the first new_nr_pages, since the new folio from them have all
 	 * the flags from the original folio.
 	 */
-	for (index = new_nr_pages; index < nr_pages; index += new_nr_pages) {
-		struct page *head = &folio->page;
-		struct page *new_head = head + index;
+	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
+		struct page *new_head = &folio->page + i;
 
 		/*
 		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
@@ -3541,7 +3540,7 @@ static void __split_folio_to_order(struc
 		 */
 		struct folio *new_folio = (struct folio *)new_head;
 
-		VM_BUG_ON_PAGE(atomic_read(&new_head->_mapcount) != -1, new_head);
+		VM_BUG_ON_PAGE(atomic_read(&new_folio->_mapcount) != -1, new_head);
 
 		/*
 		 * Clone page flags before unfreezing refcount.
@@ -3556,8 +3555,8 @@ static void __split_folio_to_order(struc
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
 		 */
-		new_head->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-		new_head->flags |= (head->flags &
+		new_folio->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		new_folio->flags |= (folio->flags &
 				((1L << PG_referenced) |
 				 (1L << PG_swapbacked) |
 				 (1L << PG_swapcache) |
@@ -3576,23 +3575,20 @@ static void __split_folio_to_order(struc
 				 (1L << PG_dirty) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
-		/* ->mapping in first and second tail page is replaced by other uses */
-		VM_BUG_ON_PAGE(new_nr_pages > 2 && new_head->mapping != TAIL_MAPPING,
-			       new_head);
-		new_head->mapping = head->mapping;
-		new_head->index = head->index + index;
+		new_folio->mapping = folio->mapping;
+		new_folio->index = folio->index + i;
 
 		/*
 		 * page->private should not be set in tail pages. Fix up and warn once
 		 * if private is unexpectedly set.
 		 */
-		if (unlikely(new_head->private)) {
+		if (unlikely(new_folio->private)) {
 			VM_WARN_ON_ONCE_PAGE(true, new_head);
-			new_head->private = 0;
+			new_folio->private = 0;
 		}
 
 		if (folio_test_swapcache(folio))
-			new_folio->swap.val = folio->swap.val + index;
+			new_folio->swap.val = folio->swap.val + i;
 
 		/* Page flags must be visible before we make the page non-compound. */
 		smp_wmb();
@@ -3788,17 +3784,18 @@ after_split:
 			}
 
 			/*
-			 * Unfreeze refcount first. Additional reference from
-			 * page cache.
+			 * origin_folio should be kept frozon until page cache
+			 * entries are updated with all the other after-split
+			 * folios to prevent others seeing stale page cache
+			 * entries.
 			 */
-			folio_ref_unfreeze(release,
-				1 + ((!folio_test_anon(origin_folio) ||
-				     folio_test_swapcache(origin_folio)) ?
-					     folio_nr_pages(release) : 0));
-
 			if (release == origin_folio)
 				continue;
 
+			folio_ref_unfreeze(release, 1 +
+					((mapping || swap_cache) ?
+						folio_nr_pages(release) : 0));
+
 			lru_add_page_tail(origin_folio, &release->page,
 						lruvec, list);
 
@@ -3810,7 +3807,7 @@ after_split:
 					folio_account_cleaned(release,
 						inode_to_wb(mapping->host));
 				__filemap_remove_folio(release, NULL);
-				folio_put(release);
+				folio_put_refs(release, folio_nr_pages(release));
 			} else if (mapping) {
 				__xa_store(&mapping->i_pages,
 						release->index, release, 0);
@@ -3822,6 +3819,15 @@ after_split:
 		}
 	}
 
+	/*
+	 * Unfreeze origin_folio only after all page cache entries, which used
+	 * to point to it, have been updated with new folios. Otherwise,
+	 * a parallel folio_try_get() can grab origin_folio and its caller can
+	 * see stale page cache entries.
+	 */
+	folio_ref_unfreeze(origin_folio, 1 +
+		((mapping || swap_cache) ? folio_nr_pages(origin_folio) : 0));
+
 	unlock_page_lruvec(lruvec);
 
 	if (swap_cache)
_

Patches currently in -mm which might be from ziy@nvidia.com are

xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-folio_split-in-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

