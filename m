Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876C52D9780
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 20:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276452; cv=none; b=ECLOsxw2oBrz/LJwbgako7dMvhjR48kSYVIIQZ0XPWNkMR9RQz38dfsfERO+r8Lar/nv+4btkJ3GQ8q/Wsd30s73j71n4OjM7sNRtJAe+7GtLcXdLXGEXcrpazoLyCXwB634VweyYZJFEMa1Ps2dxtOmr2rmyGhZM59WBkSN9+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276452; c=relaxed/simple;
	bh=MlvhuQCKQX86kbYsuCKBMnEfV7t8mTq0G61kyCz3rg8=;
	h=Date:To:From:Subject:Message-Id; b=k34m8NR5dzS4R56kr3hKF9rnrMqy5CbtTiB5P3FZCxKQGBvemPC5uLP7Q/NzG/rcANqwSuIwKWzyeph+rwHzERo3CDlqnpQfHsO77UjVbygVCRUEnEgqnWKCATDYDqCeVcdouw4qztw6rac/c9U20Cjt2IOz7wZMgg9oXmZBytY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fFgE/G9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fFgE/G9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3DAC4CEF8;
	Thu, 27 Nov 2025 20:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764276451;
	bh=MlvhuQCKQX86kbYsuCKBMnEfV7t8mTq0G61kyCz3rg8=;
	h=Date:To:From:Subject:From;
	b=fFgE/G9ssV/UftefQJR/+BjozEpLIKuJX8sEkgEocler1JHbsgfWxs0l/Dx6+fUz3
	 9sKY2o6c80Bw/Rn4gjzzlqpdrYrN2YgCeVHMH6douTNF47C3TfJix8ogy2moB1sRe3
	 7p9ztl3hnFFcGWvozK6vbO7pADYp6Xn0hK6LCzG8=
Date: Thu, 27 Nov 2025 12:47:31 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch added to mm-new branch
Message-Id: <20251127204731.BC3DAC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: change folio_split_supported() to folio_check_splittable()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: change folio_split_supported() to folio_check_splittable()
Date: Wed, 26 Nov 2025 16:06:15 -0500

Patch series "Improve folio split related functions", v4.

This patchset improves several folio split related functions to avoid
future misuse.  The changes are:

1. Consolidated folio splittable checks by moving truncated folio check,
   huge zero folio check, and writeback folio check into
   folio_split_supported(). Changed the function return type. Renamed it
   to folio_check_splittable() for clarification.

2. Replaced can_split_folio() with open coded folio_expected_ref_count()
   and folio_ref_count() and introduced folio_cache_ref_count().

3. Changed min_order_for_split() to always return an order.

4. Fixed folio split stats counting.

Motivation
==========
This is based on Wei's observation[1] and solves several potential
issues:
1. Dereferencing NULL folio->mapping in try_folio_split_to_order() if it
   is called on truncated folios.
2. Not handling of negative return value of min_order_for_split() in
   mm/memory-failure.c

There is no bug in the current code.


This patch (of 4):

folio_split_supported() used in try_folio_split_to_order() requires
folio->mapping to be non NULL, but current try_folio_split_to_order() does
not check it.  There is no issue in the current code, since
try_folio_split_to_order() is only used in truncate_inode_partial_folio(),
where folio->mapping is not NULL.

To prevent future misuse, move folio->mapping NULL check (i.e., folio is
truncated) into folio_split_supported().  Since folio->mapping NULL check
returns -EBUSY and folio_split_supported() == false means -EINVAL, change
folio_split_supported() return type from bool to int and return error
numbers accordingly.  Rename folio_split_supported() to
folio_check_splittable() to match the return type change.

While at it, move is_huge_zero_folio() check and folio_test_writeback()
check into folio_check_splittable() and add kernel-doc.

Remove all warnings inside folio_check_splittable() and give warnings
in __folio_split() instead, so that bool warns parameter can be removed.

Link: https://lkml.kernel.org/r/20251126210618.1971206-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20251126210618.1971206-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 +--
 mm/huge_memory.c        |   76 +++++++++++++++++++++-----------------
 2 files changed, 46 insertions(+), 36 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-change-folio_split_supported-to-folio_check_splittable
+++ a/include/linux/huge_mm.h
@@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(s
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		enum split_type split_type, bool warns);
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
@@ -407,7 +407,7 @@ static inline int split_huge_page_to_ord
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
+	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
--- a/mm/huge_memory.c~mm-huge_memory-change-folio_split_supported-to-folio_check_splittable
+++ a/mm/huge_memory.c
@@ -3688,15 +3688,40 @@ static int __split_unmapped_folio(struct
 	return 0;
 }
 
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		enum split_type split_type, bool warns)
+/**
+ * folio_check_splittable() - check if a folio can be split to a given order
+ * @folio: folio to be split
+ * @new_order: the smallest order of the after split folios (since buddy
+ *             allocator like split generates folios with orders from @folio's
+ *             order - 1 to new_order).
+ * @split_type: uniform or non-uniform split
+ *
+ * folio_check_splittable() checks if @folio can be split to @new_order using
+ * @split_type method. The truncated folio check must come first.
+ *
+ * Context: folio must be locked.
+ *
+ * Return: 0 - @folio can be split to @new_order, otherwise an error number is
+ * returned.
+ */
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type)
 {
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse folios without a mapping in the
+	 * swapcache (shmem or to-be-anon folios).
+	 */
+	if (!folio->mapping && !folio_test_anon(folio))
+		return -EBUSY;
+
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
-		VM_WARN_ONCE(warns && new_order == 1,
-				"Cannot split to order-1 folio");
 		if (new_order == 1)
-			return false;
+			return -EINVAL;
 	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
@@ -3717,9 +3742,7 @@ bool folio_split_supported(struct folio
 			 * case, the mapping does not actually support large
 			 * folios properly.
 			 */
-			VM_WARN_ONCE(warns,
-				"Cannot split file folio to non-0 order");
-			return false;
+			return -EINVAL;
 		}
 	}
 
@@ -3732,12 +3755,16 @@ bool folio_split_supported(struct folio
 	 * here.
 	 */
 	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
-		VM_WARN_ONCE(warns,
-			"Cannot split swapcache folio to non-0 order");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	if (is_huge_zero_folio(folio))
+		return -EINVAL;
+
+	if (folio_test_writeback(folio))
+		return -EBUSY;
+
+	return 0;
 }
 
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
@@ -3922,7 +3949,6 @@ static int __folio_split(struct folio *f
 	int remap_flags = 0;
 	int extra_pins, ret;
 	pgoff_t end = 0;
-	bool is_hzp;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -3930,31 +3956,15 @@ static int __folio_split(struct folio *f
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
-	/*
-	 * Folios that just got truncated cannot get split. Signal to the
-	 * caller that there was a race.
-	 *
-	 * TODO: this will also currently refuse shmem folios that are in the
-	 * swapcache.
-	 */
-	if (!is_anon && !folio->mapping)
-		return -EBUSY;
-
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
-		return -EINVAL;
-
-	is_hzp = is_huge_zero_folio(folio);
-	if (is_hzp) {
-		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
-		return -EBUSY;
+	ret = folio_check_splittable(folio, new_order, split_type);
+	if (ret) {
+		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
+		return ret;
 	}
 
-	if (folio_test_writeback(folio))
-		return -EBUSY;
-
 	if (is_anon) {
 		/*
 		 * The caller does not necessarily hold an mmap_lock that would
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch

