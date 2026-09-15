Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B602DF3EA
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 00:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789433130; cv=none; b=o0IK8qnfHM98y/80oogKWr4ls6jEppPrNnGxzUAWw212+XnKMPjTzUnlD83ktLru08t4oCKSamkfl22hz4p9I4m81J6qNrzJbXT5eX+0LNgFHX09Kmd/3RjIpjEAjH+kRLspcsGkrXIk2bjvZZQ6asHRjoL5I7A88n/ONFKTa6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789433130; c=relaxed/simple;
	bh=MPI1X4w4Ps9I6mF5IKtkt7JbDm2W8+/ij5g4+psnCJs=;
	h=Date:To:From:Subject:Message-Id; b=j/Su8RADzaCAq51Q1L2gd4Yg+Hjg4KB66t9lF21iuUV0jC1pluobUaXCH2TQIe+jIEIpUdwXkBDuIgkkoFENIUrQs5h3O7NMjhJtR4UuCe/XIezJM5KAwOHMZxqh13lrzG+vi1+0Fn/S0obofUSmTxdLxrp/CDtu9bYf7MzX9mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iq+BcQXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iq+BcQXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94E81F000FF;
	Tue, 15 Sep 2026 00:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789433128;
	bh=bub9+TZdqo3DpBi39Knp/mwxzX4U4QPazgN8Vv1HtTw=;
	h=Date:To:From:Subject;
	b=iq+BcQXRVs8YFIJVXGDm7QopbHOHaaGK40/3RmrothlByro548FvI1JH5YExbk9OW
	 0ULfobAPOEqP1fOlyyYhQrGPJ+jz9ybqiTpRayBtehmgPYKTxbI7b5c7ZxnbS17Uu5
	 F80HzmrIRlgPFSdfQACxVhPjS/AtJ+ny2ZjJaa3Q=
Date: Mon, 14 Sep 2026 17:45:28 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch added to mm-new branch
Message-Id: <20260915004528.B94E81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio
Date: Tue, 15 Sep 2026 01:14:58 +0800

The mapping parameter only served as a non-NULL check to detect whether
page cache entries need updating.  The xa_state pointer conveys exactly
the same information: the anon split helper passes NULL and the file split
helper passes &xas, which is non-NULL iff the folio is in the page cache.

Use the xas pointer instead and drop the parameter, along with its
kerneldoc entry.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-17-39878b37dfb0@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/huge_memory.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio
+++ a/mm/huge_memory.c
@@ -3830,7 +3830,6 @@ static void __split_folio_to_order(struc
  * @split_at: in buddy allocator like split, the folio containing @split_at
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
- * @mapping: @folio->mapping
  * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
@@ -3863,7 +3862,7 @@ static void __split_folio_to_order(struc
  */
 static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, enum split_type split_type)
+		enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -3887,7 +3886,7 @@ static int __split_frozen_folio(struct f
 		if (is_anon && split_order == 1)
 			continue;
 
-		if (mapping) {
+		if (xas) {
 			/*
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
@@ -4087,8 +4086,7 @@ static int __folio_freeze_split_anon(str
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
-				   NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4224,8 +4222,7 @@ static int __folio_freeze_split_file(str
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
-	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
-				   mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch
mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch
mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation.patch
mm-huge_memory-split-the-routine-for-splitting-anon-and-file-folio.patch
mm-huge_memory-rename-__split_unmapped_folio-to-__split_frozen_folio.patch
mm-huge_memory-consolidate-irq-and-locking-for-folio-split.patch
mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch
mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch
mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch
mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch
mm-huge_memory-move-filemap-management-into-the-file-split-helper.patch
mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch
mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

