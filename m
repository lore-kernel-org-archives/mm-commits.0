Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACA11CF5C0
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274628; cv=none; b=iEpqplYgA89xAy8OhXm/oCgEcXrhA2KK6XiO37B3MNvy2W23nRte2fNkELHEVMKBUasOAWyxcrlwCn1KJjwTzKcSQfTL7MDfn5oC0XszlP6NsKvSYR9M/6/LTrj6r4gfeyith4qMAz1FedkX3KQ/6fbtqkoIm5tsty15QA2C0uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274628; c=relaxed/simple;
	bh=B2IqtLMsz4iUfnjkY7Us7qhTCeweyoou/YIO0KhzMA8=;
	h=Date:To:From:Subject:Message-Id; b=cpBIMPJDk2cPu8h76Y5STGY+3OrHq+QaEQdzYFgHPMEP01EOH84RX6SKDkg24uOPM1LejwRUxhfpupitl2D6uBUDwXSb8Glx1kLKxqvFyYMCbYfTzyCak0CeE1dAh4iAPvs2CEVSgvKcxT07C+GT36JJQBosruDeUs5H20MMRWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=omHKL65/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="omHKL65/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791ADC4CEDD;
	Tue, 18 Mar 2025 05:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274628;
	bh=B2IqtLMsz4iUfnjkY7Us7qhTCeweyoou/YIO0KhzMA8=;
	h=Date:To:From:Subject:From;
	b=omHKL65/+rQFMZ4hvAI1sSoFWR6Wy5LU/Fu7QaYKaAeNpH2mNMvc+LQFmSP2t6pYu
	 WytsAwriOIAj5xsCleMJ5/f41W6kz6RiuCs4NKYm9NjVooeibQPBgfM2Fn9NbUnaPW
	 yDqIfLw3PCP05S9RpOTBHqxTQ9AyGpr+rKsw9WRM=
Date: Mon, 17 Mar 2025 22:10:27 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-truncate-use-folio_split-in-truncate-operation.patch removed from -mm tree
Message-Id: <20250318051028.791ADC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/truncate: use folio_split() in truncate operation
has been removed from the -mm tree.  Its filename was
     mm-truncate-use-folio_split-in-truncate-operation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/truncate: use folio_split() in truncate operation
Date: Fri, 7 Mar 2025 12:40:00 -0500

Instead of splitting the large folio uniformly during truncation, try to
use buddy allocator like folio_split() at the start and the end of a
truncation range to minimize the number of resulting folios if it is
supported.  try_folio_split() is introduced to use folio_split() if
supported and it falls back to uniform split otherwise.

For example, to truncate a order-4 folio
[0, 1, 2, 3, 4, 5, ..., 15]
between [3, 10] (inclusive), folio_split() splits the folio at 3 to
[0,1], [2], [3], [4..7], [8..15] and [3], [4..7] can be dropped and
[8..15] is kept with zeros in [8..10], then another folio_split() is
done at 10, so [8..10] can be dropped.

One possible optimization is to make folio_split() to split a folio based
on a given range, like [3..10] above.  But that complicates folio_split(),
so it will be investigated when necessary.

Link: https://lkml.kernel.org/r/20250226210032.2044041-8-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250307174001.242794-8-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   36 ++++++++++++++++++++++++++++++++++++
 mm/huge_memory.c        |    6 +++---
 mm/truncate.c           |   37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 75 insertions(+), 4 deletions(-)

--- a/include/linux/huge_mm.h~mm-truncate-use-folio_split-in-truncate-operation
+++ a/include/linux/huge_mm.h
@@ -345,6 +345,36 @@ int split_huge_page_to_list_to_order(str
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
@@ -536,6 +566,12 @@ static inline int split_folio_to_list(st
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
--- a/mm/huge_memory.c~mm-truncate-use-folio_split-in-truncate-operation
+++ a/mm/huge_memory.c
@@ -3654,7 +3654,7 @@ after_split:
 	return ret;
 }
 
-static bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
+bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns)
 {
 	if (folio_test_anon(folio)) {
@@ -3686,7 +3686,7 @@ static bool non_uniform_split_supported(
 }
 
 /* See comments in non_uniform_split_supported() */
-static bool uniform_split_supported(struct folio *folio, unsigned int new_order,
+bool uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns)
 {
 	if (folio_test_anon(folio)) {
@@ -4005,7 +4005,7 @@ int split_huge_page_to_list_to_order(str
  *
  * After split, folio is left locked for caller.
  */
-static int folio_split(struct folio *folio, unsigned int new_order,
+int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
--- a/mm/truncate.c~mm-truncate-use-folio_split-in-truncate-operation
+++ a/mm/truncate.c
@@ -192,6 +192,7 @@ bool truncate_inode_partial_folio(struct
 {
 	loff_t pos = folio_pos(folio);
 	unsigned int offset, length;
+	struct page *split_at, *split_at2;
 
 	if (pos < start)
 		offset = start - pos;
@@ -221,8 +222,42 @@ bool truncate_inode_partial_folio(struct
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
+		/*
+		 * make sure folio2 is large and does not change its mapping.
+		 * Its split result does not matter here.
+		 */
+		if (folio_test_large(folio2) &&
+		    folio2->mapping == folio->mapping)
+			try_folio_split(folio2, split_at2, NULL);
+
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


