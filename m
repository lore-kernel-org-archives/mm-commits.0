Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBF11D555
	for <mm-commits@vger.kernel.org>; Sat, 22 Nov 2025 22:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763848932; cv=none; b=SySF8elks+9+euYw1MRBcdY9x+Sutyf/m4SP4oRJmQXNowWy8OH7dScFkiyJVwnJ9PRXOdUBWBj6N30aGQCoDqpstHAcpuS9R1iQXhLtkerYKyHtjxZriNg6vOpdNsexBRR09Gd+Tr0MaqpJWLffTw6X3MkLZ00+YL0s6OZZEjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763848932; c=relaxed/simple;
	bh=IFRbx+zDfmDQitNvl6v2wbA3/iO6d+EqAF70uCaPjrI=;
	h=Date:To:From:Subject:Message-Id; b=oL7Y6P4L9roAmEZJMOheFzniQnFXH2D7dRyoMmyRhycS1nN2PhUwbF05KO6ZPjBkRTsEjfv4zaH2dx3BrSMDVUeREOiRiG4gUlq6tRKxz4vKihQRvx42fHusRYalQPgSjPS+AtnHkEGPidnSaJom6iKVGLW0o25lopytD9uty7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0pbJAqvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0pbJAqvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADD1C4CEF5;
	Sat, 22 Nov 2025 22:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763848931;
	bh=IFRbx+zDfmDQitNvl6v2wbA3/iO6d+EqAF70uCaPjrI=;
	h=Date:To:From:Subject:From;
	b=0pbJAqvzVb+BeUyjSBdIDF+Wrt/CMjYgxaai+Qnovhmso5oa2bMfOccIpiib2mBD6
	 yUUh5aDx+gKqqsOT+8jLoNKtQNw3OnDU3pyfg+lQSFiEnXFXzq97rrSX2dFL6exQ+f
	 0trrEwClU5tBbMuNQ8V7FdA6wqwzaslonU2No8QY=
Date: Sat, 22 Nov 2025 14:02:11 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch added to mm-new branch
Message-Id: <20251122220211.CADD1C4CEF5@smtp.kernel.org>
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
Date: Fri, 21 Nov 2025 21:55:26 -0500

Patch series "Improve folio split related functions", v2.

This patchset improves several folio split related functions to avoid
future misuse.  The changes are:

1. Consolidated folio splittable checks by moving truncated folio check,
   huge zero folio check, and writeback folio check into
   folio_split_supported(). Changed the function return type. Renamed it
   to folio_check_splittable() for clarification.

2. Replaced can_split_folio() with open coded folio_expected_ref_count()
   and folio_ref_count().

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

Link: https://lkml.kernel.org/r/20251122025529.1562592-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20251122025529.1562592-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
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
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   10 +++--
 mm/huge_memory.c        |   74 +++++++++++++++++++++++---------------
 2 files changed, 53 insertions(+), 31 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-change-folio_split_supported-to-folio_check_splittable
+++ a/include/linux/huge_mm.h
@@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(s
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		enum split_type split_type, bool warns);
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type, bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
@@ -407,7 +407,11 @@ static inline int split_huge_page_to_ord
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
+	int ret;
+
+	ret = folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM,
+				     /* warns= */ false);
+	if (ret)
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
--- a/mm/huge_memory.c~mm-huge_memory-change-folio_split_supported-to-folio_check_splittable
+++ a/mm/huge_memory.c
@@ -3688,15 +3688,43 @@ static int __split_unmapped_folio(struct
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
+ * @warns: whether gives warnings or not for the checks in the function
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
+			   enum split_type split_type, bool warns)
 {
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse shmem folios that are in the
+	 * swapcache.
+	 */
+	if (!folio_test_anon(folio) && !folio->mapping)
+		return -EBUSY;
+
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
 		if (new_order == 1)
-			return false;
+			return -EINVAL;
 	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
@@ -3719,7 +3747,7 @@ bool folio_split_supported(struct folio
 			 */
 			VM_WARN_ONCE(warns,
 				"Cannot split file folio to non-0 order");
-			return false;
+			return -EINVAL;
 		}
 	}
 
@@ -3734,10 +3762,18 @@ bool folio_split_supported(struct folio
 	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
 		VM_WARN_ONCE(warns,
 			"Cannot split swapcache folio to non-0 order");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	if (is_huge_zero_folio(folio)) {
+		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
+		return -EINVAL;
+	}
+
+	if (folio_test_writeback(folio))
+		return -EBUSY;
+
+	return 0;
 }
 
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
@@ -3922,7 +3958,6 @@ static int __folio_split(struct folio *f
 	int remap_flags = 0;
 	int extra_pins, ret;
 	pgoff_t end = 0;
-	bool is_hzp;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -3930,30 +3965,13 @@ static int __folio_split(struct folio *f
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
-	}
-
-	if (folio_test_writeback(folio))
-		return -EBUSY;
+	ret = folio_check_splittable(folio, new_order, split_type,
+				     /* warn = */ true);
+	if (ret)
+		return ret;
 
 	if (is_anon) {
 		/*
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch
mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch

