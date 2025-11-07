Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78A71A9F96
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 00:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762476054; cv=none; b=cA0UH+LrMtrKkKhPX4XiAgww680DHj95TezoUtZRi+1uzO+gPb+9S8VNfiEdXPM3tZ/jIICP4486j+38oP1ZKLUvUy6TFlYiIssemm85oidZQhEJ0i3K+82d1epzq64w0MjJOv7nkMgGgOXjcKa44QiHPVQh07EuPkBXT9NuXyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762476054; c=relaxed/simple;
	bh=YlcLPAa52pQkUevpcsnW5fgS8f1lJ02bAtu/CjFTBeE=;
	h=Date:To:From:Subject:Message-Id; b=ig8rOrTof+vktBkB5rqBYaEbFh33J/ML55yTlgYtAqCIktR4l2zeft+WNeNLwNt1kcuOKFrBMm0+uKTgwLObQk4ZLVwb9XNx6vzF6NQFzYP4ElwpshGM4OPtMvC9PYl0dLgYfh/ydzfLO3ZUlZ/R0qh1Bm1W4bviXULy/W0b0YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aS2tumHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aS2tumHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2311BC4CEFB;
	Fri,  7 Nov 2025 00:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762476054;
	bh=YlcLPAa52pQkUevpcsnW5fgS8f1lJ02bAtu/CjFTBeE=;
	h=Date:To:From:Subject:From;
	b=aS2tumHdHJXETa75V/Lynn2o5t3NvcF6SugE3xALgyQ6iJz9EeI/xKQi4lWUaNBiN
	 JjIE3uw5h7hZGDAgJXrF0AdMqBYP14S1L292AGBZ6pmGuCLcmoaD3NvmBXABwd7q1k
	 r0Rr09VZr1j3I3lYEzBrhy+mY8DrzUm3XVTXHkFg=
Date: Thu, 06 Nov 2025 16:40:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-introduce-enum-split_type-for-clarity.patch added to mm-new branch
Message-Id: <20251107004054.2311BC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: introduce enum split_type for clarity
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-introduce-enum-split_type-for-clarity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-introduce-enum-split_type-for-clarity.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: introduce enum split_type for clarity
Date: Thu, 6 Nov 2025 03:41:54 +0000

Patch series "mm/huge_memory: Define split_type and consolidate split
support checks", v3.

This two-patch series focuses on improving code clarity and removing
redundancy in the huge memory handling logic related to folio splitting.

The series is based on an original proposal to merge two significantly
identical functions that check folio split support[1].  During this
process, we found an opportunity to improve readability by explicitly
defining the split types.  

Patch 1: define split_type and use it
Patch 2: merge uniform_split_supported() and non_uniform_split_supported()


This patch (of 2):

We currently handle two distinct types of large folio splitting:
  * uniform split
  * non-uniform split

Differentiating between these types using a simple boolean variable is not
obvious and can harm code readability.

This commit introduces enum split_type to explicitly define these two
types.  Replacing the existing boolean variable with this enumeration
significantly improves code clarity and expressiveness when dealing with
folio splitting logic.

No functional change is expected.

Link: https://lkml.kernel.org/r/20251106034155.21398-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251106034155.21398-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 +++++
 mm/huge_memory.c        |   30 +++++++++++++++---------------
 2 files changed, 20 insertions(+), 15 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-introduce-enum-split_type-for-clarity
+++ a/include/linux/huge_mm.h
@@ -364,6 +364,11 @@ unsigned long thp_get_unmapped_area_vmfl
 		unsigned long len, unsigned long pgoff, unsigned long flags,
 		vm_flags_t vm_flags);
 
+enum split_type {
+	SPLIT_TYPE_UNIFORM,
+	SPLIT_TYPE_NON_UNIFORM,
+};
+
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order, bool unmapped);
--- a/mm/huge_memory.c~mm-huge_memory-introduce-enum-split_type-for-clarity
+++ a/mm/huge_memory.c
@@ -3523,16 +3523,16 @@ static void __split_folio_to_order(struc
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
  * @mapping: @folio->mapping
- * @uniform_split: if the split is uniform or not (buddy allocator like split)
+ * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
  * 1. uniform split: the given @folio into multiple @new_order small folios,
  *    where all small folios have the same order. This is done when
- *    uniform_split is true.
+ *    split_type is SPLIT_TYPE_UNIFORM.
  * 2. buddy allocator like (non-uniform) split: the given @folio is split into
  *    half and one of the half (containing the given page) is split into half
  *    until the given @folio's order becomes @new_order. This is done when
- *    uniform_split is false.
+ *    split_type is SPLIT_TYPE_NON_UNIFORM.
  *
  * The high level flow for these two methods are:
  *
@@ -3555,11 +3555,11 @@ static void __split_folio_to_order(struc
  */
 static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, bool uniform_split)
+		struct address_space *mapping, enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
-	int start_order = uniform_split ? new_order : old_order - 1;
+	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
 	int split_order;
 
 	/*
@@ -3581,7 +3581,7 @@ static int __split_unmapped_folio(struct
 			 * irq is disabled to allocate enough memory, whereas
 			 * non-uniform split can handle ENOMEM.
 			 */
-			if (uniform_split)
+			if (split_type == SPLIT_TYPE_UNIFORM)
 				xas_split(xas, folio, old_order);
 			else {
 				xas_set_order(xas, folio->index, split_order);
@@ -3678,7 +3678,7 @@ bool uniform_split_supported(struct foli
  * @split_at: a page within the new folio
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
- * @uniform_split: perform uniform split or not (non-uniform split)
+ * @split_type: perform uniform split or not (non-uniform split)
  * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
@@ -3695,7 +3695,7 @@ bool uniform_split_supported(struct foli
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, bool uniform_split, bool unmapped)
+		struct list_head *list, enum split_type split_type, bool unmapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3720,10 +3720,10 @@ static int __folio_split(struct folio *f
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (uniform_split && !uniform_split_supported(folio, new_order, true))
+	if (split_type == SPLIT_TYPE_UNIFORM && !uniform_split_supported(folio, new_order, true))
 		return -EINVAL;
 
-	if (!uniform_split &&
+	if (split_type == SPLIT_TYPE_NON_UNIFORM &&
 	    !non_uniform_split_supported(folio, new_order, true))
 		return -EINVAL;
 
@@ -3785,7 +3785,7 @@ static int __folio_split(struct folio *f
 			goto out;
 		}
 
-		if (uniform_split) {
+		if (split_type == SPLIT_TYPE_UNIFORM) {
 			xas_set_order(&xas, folio->index, new_order);
 			xas_split_alloc(&xas, folio, old_order, gfp);
 			if (xas_error(&xas)) {
@@ -3890,7 +3890,7 @@ static int __folio_split(struct folio *f
 		lruvec = folio_lruvec_lock(folio);
 
 		ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
-					     mapping, uniform_split);
+					     mapping, split_type);
 
 		/*
 		 * Unfreeze after-split folios and put them back to the right
@@ -4066,8 +4066,8 @@ int __split_huge_page_to_list_to_order(s
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list, true,
-				unmapped);
+	return __folio_split(folio, new_order, &folio->page, page, list,
+				SPLIT_TYPE_UNIFORM, unmapped);
 }
 
 /**
@@ -4098,7 +4098,7 @@ int folio_split(struct folio *folio, uns
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			false, false);
+				SPLIT_TYPE_NON_UNIFORM, false);
 }
 
 int min_order_for_split(struct folio *folio)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch
mm-huge_memory-avoid-reinvoking-folio_test_anon.patch
mm-huge_memory-update-folio-stat-after-successful-split.patch
mm-huge_memory-optimize-and-simplify-folio-stat-update-after-split.patch
mm-huge_memory-optimize-old_order-derivation-during-folio-splitting.patch
mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch

