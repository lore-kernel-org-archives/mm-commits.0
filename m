Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A516354AE2
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 23:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760744886; cv=none; b=GpryWYiwoH0Y7If1WgQgK25a229qa1bCkKF3lTDDuaPQvZCWZH10veDADmBs0Lq2K09WCB4xM/xYLufUMpEdxlb9HjPguT+IT+ZLJwC3k8HKNBoICtdTKOctj6xyXBHrDQTFNYcP8xIpVNFtzdSVKvXVrlW3+iui1ZaYdHT9u5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760744886; c=relaxed/simple;
	bh=0mMYyAekjhbFrFiOKw+CaBwN/SALoFQaulH+6GsoNfg=;
	h=Date:To:From:Subject:Message-Id; b=Tu9mBtgC8eJE5X+RHAJPDRzm0D/QzPKmOrtl2GuG5+bHd8fDeh62cIlw6CNTD5M+NDGVQPVBxbx7hk8YgG+88RRTV83sj5H960FP2A7Qw0Jvn9mybridjQVS8gb4AXRRxgAxQVz8lLcMfkH1a4/L/SoTD2LCV84vDAjJZynXiuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wkkT/pbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wkkT/pbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FB1C4CEE7;
	Fri, 17 Oct 2025 23:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760744885;
	bh=0mMYyAekjhbFrFiOKw+CaBwN/SALoFQaulH+6GsoNfg=;
	h=Date:To:From:Subject:From;
	b=wkkT/pbTerlczuTbnYLlq9tPZxXxTEBleQOGagMZeuZgz94hfqxcWxEmYrlxPsS31
	 ipxMAHjGBMkDnniRvaYNEofgQIdG4gsmJ+vzL2E1vZjcQKXYsWiEVhPai38Ce+FfZq
	 lCv15gZCZiMHydmm33NZsPAUj/5x7+xdLBB0256c=
Date: Fri, 17 Oct 2025 16:48:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,p.raghav@samsung.com,npache@redhat.com,nao.horiguchi@gmail.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jane.chu@oracle.com,dev.jain@arm.com,david@redhat.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch added to mm-hotfixes-unstable branch
Message-Id: <20251017234805.64FB1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: do not change split_huge_page*() target order silently.
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/huge_memory: do not change split_huge_page*() target order silently.
Date: Thu, 16 Oct 2025 21:36:30 -0400

Page cache folios from a file system that support large block size (LBS)
can have minimal folio order greater than 0, thus a high order folio might
not be able to be split down to order-0.  Commit e220917fa507 ("mm: split
a folio in minimum folio order chunks") bumps the target order of
split_huge_page*() to the minimum allowed order when splitting a LBS
folio.  This causes confusion for some split_huge_page*() callers like
memory failure handling code, since they expect after-split folios all
have order-0 when split succeeds but in reality get min_order_for_split()
order folios and give warnings.

Fix it by failing a split if the folio cannot be split to the target
order.  Rename try_folio_split() to try_folio_split_to_order() to reflect
the added new_order parameter.  Remove its unused list parameter.

[The test poisons LBS folios, which cannot be split to order-0 folios, and
also tries to poison all memory.  The non split LBS folios take more
memory than the test anticipated, leading to OOM.  The patch fixed the
kernel warning and the test needs some change to avoid OOM.]

Link: https://lkml.kernel.org/r/20251017013630.139907-1-ziy@nvidia.com
Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
Cc: stable@vger.kernel.org
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   55 +++++++++++++++-----------------------
 mm/huge_memory.c        |    9 ------
 mm/truncate.c           |    6 ++--
 3 files changed, 28 insertions(+), 42 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-do-not-change-split_huge_page-target-order-silently
+++ a/include/linux/huge_mm.h
@@ -376,45 +376,30 @@ bool non_uniform_split_supported(struct
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 /*
- * try_folio_split - try to split a @folio at @page using non uniform split.
+ * try_folio_split_to_order - try to split a @folio at @page to @new_order using
+ * non uniform split.
  * @folio: folio to be split
- * @page: split to order-0 at the given page
- * @list: store the after-split folios
+ * @page: split to @new_order at the given page
+ * @new_order: the target split order
  *
- * Try to split a @folio at @page using non uniform split to order-0, if
- * non uniform split is not supported, fall back to uniform split.
+ * Try to split a @folio at @page using non uniform split to @new_order, if
+ * non uniform split is not supported, fall back to uniform split. After-split
+ * folios are put back to LRU list. Use min_order_for_split() to get the lower
+ * bound of @new_order.
  *
  * Return: 0: split is successful, otherwise split failed.
  */
-static inline int try_folio_split(struct folio *folio, struct page *page,
-		struct list_head *list)
+static inline int try_folio_split_to_order(struct folio *folio,
+		struct page *page, unsigned int new_order)
 {
-	int ret = min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	if (!non_uniform_split_supported(folio, 0, false))
-		return split_huge_page_to_list_to_order(&folio->page, list,
-				ret);
-	return folio_split(folio, ret, page, list);
+	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
+		return split_huge_page_to_list_to_order(&folio->page, NULL,
+				new_order);
+	return folio_split(folio, new_order, page, NULL);
 }
 static inline int split_huge_page(struct page *page)
 {
-	struct folio *folio = page_folio(page);
-	int ret = min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	/*
-	 * split_huge_page() locks the page before splitting and
-	 * expects the same page that has been split to be locked when
-	 * returned. split_folio(page_folio(page)) cannot be used here
-	 * because it converts the page to folio and passes the head
-	 * page to be split.
-	 */
-	return split_huge_page_to_list_to_order(page, NULL, ret);
+	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
@@ -597,14 +582,20 @@ static inline int split_huge_page(struct
 	return -EINVAL;
 }
 
+static inline int min_order_for_split(struct folio *folio)
+{
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
+}
+
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
 }
 
-static inline int try_folio_split(struct folio *folio, struct page *page,
-		struct list_head *list)
+static inline int try_folio_split_to_order(struct folio *folio,
+		struct page *page, unsigned int new_order)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
--- a/mm/huge_memory.c~mm-huge_memory-do-not-change-split_huge_page-target-order-silently
+++ a/mm/huge_memory.c
@@ -3653,8 +3653,6 @@ static int __folio_split(struct folio *f
 
 		min_order = mapping_min_folio_order(folio->mapping);
 		if (new_order < min_order) {
-			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
-				     min_order);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3986,12 +3984,7 @@ int min_order_for_split(struct folio *fo
 
 int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	int ret = min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	return split_huge_page_to_list_to_order(&folio->page, list, ret);
+	return split_huge_page_to_list_to_order(&folio->page, list, 0);
 }
 
 /*
--- a/mm/truncate.c~mm-huge_memory-do-not-change-split_huge_page-target-order-silently
+++ a/mm/truncate.c
@@ -194,6 +194,7 @@ bool truncate_inode_partial_folio(struct
 	size_t size = folio_size(folio);
 	unsigned int offset, length;
 	struct page *split_at, *split_at2;
+	unsigned int min_order;
 
 	if (pos < start)
 		offset = start - pos;
@@ -223,8 +224,9 @@ bool truncate_inode_partial_folio(struct
 	if (!folio_test_large(folio))
 		return true;
 
+	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split(folio, split_at, NULL)) {
+	if (!try_folio_split_to_order(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -254,7 +256,7 @@ bool truncate_inode_partial_folio(struct
 		 */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split(folio2, split_at2, NULL);
+			try_folio_split_to_order(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch

