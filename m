Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEB02F363C
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025805; cv=none; b=Ax/CNNMZNimEe4575gIzGJEaxWTYmPAqlneEpEDOMIzuV3BzwtUI0f15VX1HlL3LM4O+jpkU3stAzhD6nTB6FqXx4MHXKZ5TiTG9TcnTRl2SxMCPX9q9It4Q5JAusRLyZFcDh2E4DNvx15+amq/NfiFejbVBBO3MSouvP7mJWsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025805; c=relaxed/simple;
	bh=XOpaXBu11+K7luPpKo/GvqnkHN4MecRjJbJV+mkOwVg=;
	h=Date:To:From:Subject:Message-Id; b=QA5rKdIJkFiFZvW8kHUHP0KfQSzO58/NpmlYnPayWWVt2JXgkoW8URDRUgkUSC9pNaFOgOaL9qaJnjvEqM1OLRO3InaVM3eaz8L82IpqJVOHobDOCZrlgIQofsnxE4Z3eV4N1VhERyUz357XGVqKetD6mkk9amS+T+4p3qmfYR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MhJkZvQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MhJkZvQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36655C4CEF1;
	Mon, 24 Nov 2025 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025805;
	bh=XOpaXBu11+K7luPpKo/GvqnkHN4MecRjJbJV+mkOwVg=;
	h=Date:To:From:Subject:From;
	b=MhJkZvQ+43K/WwJckMPHkdVuNQ8U6nKwQqMHfOeLMvv4Vfuqj0jjIpVkaI87K+tWz
	 Q8segM7zKqpP4dWVVuHy31JfHImBRzrEKDZrevW5cKQIUymgiBqjKEqO0Z+Q0c0nmP
	 /2sklQOb4T2HePSvT+aqXioB6Ix2BjnUpHYzfb90=
Date: Mon, 24 Nov 2025 15:10:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,kernel@pankajraghav.com,jane.chu@oracle.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch removed from -mm tree
Message-Id: <20251124231005.36655C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix kernel-doc comments for folio_split() and related
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: fix kernel-doc comments for folio_split() and related
Date: Fri, 31 Oct 2025 12:20:01 -0400

try_folio_split_to_order(), folio_split, __folio_split(), and
__split_unmapped_folio() do not have correct kernel-doc comment format. 
Fix them.

[ziy@nvidia.com: kernel-doc fixup]
  Link: https://lkml.kernel.org/r/BE7AC5F3-9E64-4923-861D-C2C4E0CB91EB@nvidia.com
[ziy@nvidia.com: add newline to fix an error and a warning from docutils]
  Link: https://lkml.kernel.org/r/040B38C0-23C6-4AEA-B069-69AE6DAA828B@nvidia.com
Link: https://lkml.kernel.org/r/20251031162001.670503-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   10 ++++---
 mm/huge_memory.c        |   52 ++++++++++++++++++++------------------
 2 files changed, 34 insertions(+), 28 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related
+++ a/include/linux/huge_mm.h
@@ -386,9 +386,9 @@ static inline int split_huge_page_to_ord
 	return split_huge_page_to_list_to_order(page, NULL, new_order);
 }
 
-/*
- * try_folio_split_to_order - try to split a @folio at @page to @new_order using
- * non uniform split.
+/**
+ * try_folio_split_to_order() - try to split a @folio at @page to @new_order
+ * using non uniform split.
  * @folio: folio to be split
  * @page: split to @new_order at the given page
  * @new_order: the target split order
@@ -398,7 +398,7 @@ static inline int split_huge_page_to_ord
  * folios are put back to LRU list. Use min_order_for_split() to get the lower
  * bound of @new_order.
  *
- * Return: 0: split is successful, otherwise split failed.
+ * Return: 0 - split is successful, otherwise split failed.
  */
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
@@ -483,6 +483,8 @@ static inline spinlock_t *pud_trans_huge
 /**
  * folio_test_pmd_mappable - Can we map this folio with a PMD?
  * @folio: The folio to test
+ *
+ * Return: true - @folio can be mapped, false - @folio cannot be mapped.
  */
 static inline bool folio_test_pmd_mappable(struct folio *folio)
 {
--- a/mm/huge_memory.c~mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related
+++ a/mm/huge_memory.c
@@ -3493,8 +3493,9 @@ static void __split_folio_to_order(struc
 		ClearPageCompound(&folio->page);
 }
 
-/*
- * It splits an unmapped @folio to lower order smaller folios in two ways.
+/**
+ * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
+ * two ways: uniform split or non-uniform split.
  * @folio: the to-be-split folio
  * @new_order: the smallest order of the after split folios (since buddy
  *             allocator like split generates folios with orders from @folio's
@@ -3511,26 +3512,27 @@ static void __split_folio_to_order(struc
  *    uniform_split is true.
  * 2. buddy allocator like (non-uniform) split: the given @folio is split into
  *    half and one of the half (containing the given page) is split into half
- *    until the given @page's order becomes @new_order. This is done when
+ *    until the given @folio's order becomes @new_order. This is done when
  *    uniform_split is false.
  *
  * The high level flow for these two methods are:
- * 1. uniform split: a single __split_folio_to_order() is called to split the
- *    @folio into @new_order, then we traverse all the resulting folios one by
- *    one in PFN ascending order and perform stats, unfreeze, adding to list,
- *    and file mapping index operations.
- * 2. non-uniform split: in general, folio_order - @new_order calls to
- *    __split_folio_to_order() are made in a for loop to split the @folio
- *    to one lower order at a time. The resulting small folios are processed
- *    like what is done during the traversal in 1, except the one containing
- *    @page, which is split in next for loop.
+ *
+ * 1. uniform split: @xas is split with no expectation of failure and a single
+ *    __split_folio_to_order() is called to split the @folio into @new_order
+ *    along with stats update.
+ * 2. non-uniform split: folio_order - @new_order calls to
+ *    __split_folio_to_order() are expected to be made in a for loop to split
+ *    the @folio to one lower order at a time. The folio containing @split_at
+ *    is split in each iteration. @xas is split into half in each iteration and
+ *    can fail. A failed @xas split leaves split folios as is without merging
+ *    them back.
  *
  * After splitting, the caller's folio reference will be transferred to the
- * folio containing @page. The caller needs to unlock and/or free after-split
- * folios if necessary.
+ * folio containing @split_at. The caller needs to unlock and/or free
+ * after-split folios if necessary.
  *
- * For !uniform_split, when -ENOMEM is returned, the original folio might be
- * split. The caller needs to check the input folio.
+ * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
+ * split but not to @new_order, the caller needs to check)
  */
 static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
@@ -3650,8 +3652,8 @@ bool uniform_split_supported(struct foli
 	return true;
 }
 
-/*
- * __folio_split: split a folio at @split_at to a @new_order folio
+/**
+ * __folio_split() - split a folio at @split_at to a @new_order folio
  * @folio: folio to split
  * @new_order: the order of the new folio
  * @split_at: a page within the new folio
@@ -3669,7 +3671,7 @@ bool uniform_split_supported(struct foli
  * 1. for uniform split, @lock_at points to one of @folio's subpages;
  * 2. for buddy allocator like (non-uniform) split, @lock_at points to @folio.
  *
- * return: 0: successful, <0 failed (if -ENOMEM is returned, @folio might be
+ * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
@@ -4047,14 +4049,13 @@ int __split_huge_page_to_list_to_order(s
 				unmapped);
 }
 
-/*
- * folio_split: split a folio at @split_at to a @new_order folio
+/**
+ * folio_split() - split a folio at @split_at to a @new_order folio
  * @folio: folio to split
  * @new_order: the order of the new folio
  * @split_at: a page within the new folio
- *
- * return: 0: successful, <0 failed (if -ENOMEM is returned, @folio might be
- * split but not to @new_order, the caller needs to check)
+ * @list: after-split folios are added to @list if not null, otherwise to LRU
+ *        list
  *
  * It has the same prerequisites and returns as
  * split_huge_page_to_list_to_order().
@@ -4068,6 +4069,9 @@ int __split_huge_page_to_list_to_order(s
  * [order-4, {order-3}, order-3, order-5, order-6, order-7, order-8].
  *
  * After split, folio is left locked for caller.
+ *
+ * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
+ * split but not to @new_order, the caller needs to check)
  */
 int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch

