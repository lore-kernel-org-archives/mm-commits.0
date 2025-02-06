Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD012248AC
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 08:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738829146; cv=none; b=hD3Pi9ilz8X3gYwAfA9xnZqGnq9rEILEU4T3wcGt2O6M2yEWfwEtgjVUN8dea+uWDqp3WI0EF2gyCxFHCmobIdOki9AD9F21rIYEqIwZdUHb8dQL19f8cchH/yoQ7YZWjOfIprB67y+ck13q/N5pExBgcMJ3nDm2KuEMm+h3vbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738829146; c=relaxed/simple;
	bh=v2+bR8jEeSApBG6x/t2HdoOuLE1GijUrYg7tLJDzO2Q=;
	h=Date:To:From:Subject:Message-Id; b=NwZqMcGJ76hRPe+vD5qg0VoMWheG61fwg6yQSXDjBTzDD2S+ymiUJjGJs769t95mCp2jJTEr5wJrmcuTKEsY25mg8THpiLretPqp131GpkqGzwT0m9M6rFFbyoqHf/NO+yMnO/++yzRKN5gFdTvsDKSHaEEb9QRUIiriqMFmqSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NRGJKVbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NRGJKVbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869D0C4CEDD;
	Thu,  6 Feb 2025 08:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738829145;
	bh=v2+bR8jEeSApBG6x/t2HdoOuLE1GijUrYg7tLJDzO2Q=;
	h=Date:To:From:Subject:From;
	b=NRGJKVbYvCLAElb0eXp2bIGV9p2jIBnUTDoeGG3N0PSAwBpcoCAUC7sa2ia5GD33h
	 2bKpx0vQR0JeZDSBfaA2KQBc31BQop9Lxq7dNuVbowTG8u0cxAl3F0t6l2RkUWSsIB
	 g16DfDPmiCIktAu/oYlaTk6zeIbuj0ZcM1DKs+WU=
Date: Thu, 06 Feb 2025 00:05:45 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch added to mm-unstable branch
Message-Id: <20250206080545.869D0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: use buddy allocator like folio split for truncate operation.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/truncate: use buddy allocator like folio split for truncate operation.
Date: Tue, 4 Feb 2025 22:14:16 -0500

Instead of splitting the large folio uniformly during truncation, try to
use buddy allocator like split at the start of truncation range to
minimize the number of resulting folios if it is supported. 
try_folio_split() is introduced to use folio_split() if supported and fall
back to uniform split otherwise.

For example, to truncate a order-4 folio
[0, 1, 2, 3, 4, 5, ..., 15]
between [3, 10] (inclusive), folio_split() splits the folio to
[0,1], [2], [3], [4..7], [8..15] and [3], [4..7] can be dropped and
[8..15] is kept with zeros in [8..10], then another folio_split() is
done at 10, so [8..10] can be dropped.

One possible optimization is to make folio_split() to split a folio based
on a given range, like [3..10] above.  But that complicates folio_split(),
so it will be investigated when necessary.

Link: https://lkml.kernel.org/r/20250205031417.1771278-7-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   36 ++++++++++++++++++++++++++++++++++++
 mm/huge_memory.c        |    4 ++--
 mm/truncate.c           |   31 ++++++++++++++++++++++++++++++-
 3 files changed, 68 insertions(+), 3 deletions(-)

--- a/include/linux/huge_mm.h~mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation
+++ a/include/linux/huge_mm.h
@@ -343,6 +343,36 @@ int split_huge_page_to_list_to_order(str
 		unsigned int new_order);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
+bool uniform_split_supported(struct folio *folio, unsigned int new_order,
+		bool warns);
+bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
+		bool warns);
+int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
+		struct list_head *list);
+/*
+ * try_folio_split - try to split a @folio at @page using non uniform split.
+ * @folio: folio to be split
+ * @page: split to order-0 at the given page
+ * @list: store the after-split folios
+ *
+ * Try to split a @folio at @page using non uniform split to order-0, if
+ * non uniform split is not supported, fall back to uniform split.
+ *
+ * Return: 0: split is successful, otherwise split failed.
+ */
+static inline int try_folio_split(struct folio *folio, struct page *page,
+		struct list_head *list)
+{
+	int ret = min_order_for_split(folio);
+
+	if (ret < 0)
+		return ret;
+
+	if (!non_uniform_split_supported(folio, 0, false))
+		return split_huge_page_to_list_to_order(&folio->page, list,
+				ret);
+	return folio_split(folio, ret, page, list);
+}
 static inline int split_huge_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
@@ -534,6 +564,12 @@ static inline int split_folio_to_list(st
 {
 	return 0;
 }
+
+static inline int try_folio_split(struct folio *folio, struct page *page,
+		struct list_head *list)
+{
+	return 0;
+}
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
--- a/mm/huge_memory.c~mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation
+++ a/mm/huge_memory.c
@@ -3647,7 +3647,7 @@ after_split:
 	return ret;
 }
 
-static bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
+bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns)
 {
 	/* order-1 is not supported for anonymous THP. */
@@ -3680,7 +3680,7 @@ static bool non_uniform_split_supported(
 }
 
 /* See comments in non_uniform_split_supported() */
-static bool uniform_split_supported(struct folio *folio, unsigned int new_order,
+bool uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns)
 {
 	if (folio_test_anon(folio) && new_order == 1) {
--- a/mm/truncate.c~mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation
+++ a/mm/truncate.c
@@ -192,6 +192,7 @@ bool truncate_inode_partial_folio(struct
 {
 	loff_t pos = folio_pos(folio);
 	unsigned int offset, length;
+	struct page *split_at, *split_at2;
 
 	if (pos < start)
 		offset = start - pos;
@@ -221,8 +222,36 @@ bool truncate_inode_partial_folio(struct
 		folio_invalidate(folio, offset, length);
 	if (!folio_test_large(folio))
 		return true;
-	if (split_folio(folio) == 0)
+
+	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
+	split_at2 = folio_page(folio,
+			PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
+
+	if (!try_folio_split(folio, split_at, NULL)) {
+		/*
+		 * try to split at offset + length to make sure folios within
+		 * the range can be dropped, especially to avoid memory waste
+		 * for shmem truncate
+		 */
+		struct folio *folio2 = page_folio(split_at2);
+
+		if (!folio_try_get(folio2))
+			goto no_split;
+
+		if (!folio_test_large(folio2))
+			goto out;
+
+		if (!folio_trylock(folio2))
+			goto out;
+
+		/* split result does not matter here */
+		try_folio_split(folio2, split_at2, NULL);
+		folio_unlock(folio2);
+out:
+		folio_put(folio2);
+no_split:
 		return true;
+	}
 	if (folio_test_dirty(folio))
 		return false;
 	truncate_inode_folio(folio->mapping, folio);
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch

