Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3099633554A
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025808; cv=none; b=NTh93owgwI8t9YBcYI8E4i1CF1DIMNKGRDuTbQj8iPMU1f8LDFTKxgE+zzduceAG9dmE/UY8ZkP1oeAsY+uUvuyU0ytpvtYyF3ipRVh7VzNVnH8y6ICOml04mosTBP16iwexfCel/yikvuLzKqUtQAoOED1/8nIqCHRyc+WXUXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025808; c=relaxed/simple;
	bh=ETsHbI0jRmhKbfcXtVNBqEoJOw1knKDNpZ7e2Udq1YY=;
	h=Date:To:From:Subject:Message-Id; b=hr79tN73vcNQzanfmOb6b0RwpJbe3NJnIVq97gMhvNZJmH+L1pqDz4HJvEDZkFWtaTISyP8bciItWZ8l0QUTERiRdCHmqbTYW1RyFpSXBivG2m1gB/l77b7Ztj75SyN/0sJuUqLC6HuUgF2YZOVA//X7O6P5lEXkb2atnrUXRh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1yuc4yPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1yuc4yPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045E2C4CEFB;
	Mon, 24 Nov 2025 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025808;
	bh=ETsHbI0jRmhKbfcXtVNBqEoJOw1knKDNpZ7e2Udq1YY=;
	h=Date:To:From:Subject:From;
	b=1yuc4yPpmQsOlO7vB3UgtOntVCT7lNEIJ0gN/GG5QL5ac0tZWa+IF/HcHwMfA1CVa
	 AFD/on3L67pAk56vkaBrCLTLN0HY7N+d9G63sr4vVq+tWmRaD7OXx1VOPzvvPzCRL3
	 BAIEKE+fj7QPlZIGs8yNK1GGrUCLa5yZzTqwyjYA=
Date: Mon, 24 Nov 2025 15:10:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-introduce-enum-split_type-for-clarity.patch removed from -mm tree
Message-Id: <20251124231008.045E2C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: introduce enum split_type for clarity
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-introduce-enum-split_type-for-clarity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: tweak layout, per David]
Link: https://lkml.kernel.org/r/20251106034155.21398-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251106034155.21398-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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
@@ -3504,16 +3504,16 @@ static void __split_folio_to_order(struc
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
@@ -3536,11 +3536,11 @@ static void __split_folio_to_order(struc
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
@@ -3562,7 +3562,7 @@ static int __split_unmapped_folio(struct
 			 * irq is disabled to allocate enough memory, whereas
 			 * non-uniform split can handle ENOMEM.
 			 */
-			if (uniform_split)
+			if (split_type == SPLIT_TYPE_UNIFORM)
 				xas_split(xas, folio, old_order);
 			else {
 				xas_set_order(xas, folio->index, split_order);
@@ -3659,7 +3659,7 @@ bool uniform_split_supported(struct foli
  * @split_at: a page within the new folio
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
- * @uniform_split: perform uniform split or not (non-uniform split)
+ * @split_type: perform uniform split or not (non-uniform split)
  * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
@@ -3676,7 +3676,7 @@ bool uniform_split_supported(struct foli
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, bool uniform_split, bool unmapped)
+		struct list_head *list, enum split_type split_type, bool unmapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3711,10 +3711,10 @@ static int __folio_split(struct folio *f
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (uniform_split && !uniform_split_supported(folio, new_order, true))
+	if (split_type == SPLIT_TYPE_UNIFORM && !uniform_split_supported(folio, new_order, true))
 		return -EINVAL;
 
-	if (!uniform_split &&
+	if (split_type == SPLIT_TYPE_NON_UNIFORM &&
 	    !non_uniform_split_supported(folio, new_order, true))
 		return -EINVAL;
 
@@ -3764,7 +3764,7 @@ static int __folio_split(struct folio *f
 			goto out;
 		}
 
-		if (uniform_split) {
+		if (split_type == SPLIT_TYPE_UNIFORM) {
 			xas_set_order(&xas, folio->index, new_order);
 			xas_split_alloc(&xas, folio, old_order, gfp);
 			if (xas_error(&xas)) {
@@ -3869,7 +3869,7 @@ static int __folio_split(struct folio *f
 		lruvec = folio_lruvec_lock(folio);
 
 		ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
-					     mapping, uniform_split);
+					     mapping, split_type);
 
 		/*
 		 * Unfreeze after-split folios and put them back to the right
@@ -4045,8 +4045,8 @@ int __split_huge_page_to_list_to_order(s
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list, true,
-				unmapped);
+	return __folio_split(folio, new_order, &folio->page, page, list,
+			     SPLIT_TYPE_UNIFORM, unmapped);
 }
 
 /**
@@ -4077,7 +4077,7 @@ int folio_split(struct folio *folio, uns
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			false, false);
+			     SPLIT_TYPE_NON_UNIFORM, false);
 }
 
 int min_order_for_split(struct folio *folio)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


