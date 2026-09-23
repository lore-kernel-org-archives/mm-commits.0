Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFB0471CEC
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202777; cv=none; b=Hkdlg37LDqaCqHW8GS2CQ2lh8ehBpslCj0arryFokIA2yZRY/Z4S0BRkTUSBimyZ8Df/rVpBZ0NXCMr81RDtwcSnjg5IUpyElgutbZYLmIXhW5T9QubHnKUcyIuOzdlV1xSZ+sihf0roiVMNUKPBX2PbC//HdEHOGG34z6mEEbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202777; c=relaxed/simple;
	bh=s9iL/C7oqumM/rakWrOUF1jF3BW+XugKmly8g8lexpI=;
	h=Date:To:From:Subject:Message-Id; b=Wl4gp95LZ1vS7yOTZ3RgDSigTKjulkjrYibOzQEUFk6eKuR9+oKcFMHQhRb2E+Gt99BG6sQG44ctdhsKV2/RhqXTsqfdVXiuOgOJk77voab2C0M51taj68goTbTtKAIm77Av00lRVqOQo3mMb/QjE6TnjAy3T4x3TSgkb/3FPvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xYFq1Sfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xYFq1Sfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D467A1F00893;
	Wed, 23 Sep 2026 22:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202775;
	bh=e3DjkAL7QYdErv0sBRKV/rYA+KG/vr1WEd9epxzlqEk=;
	h=Date:To:From:Subject;
	b=xYFq1SfkyRWMMm/49C66E+mwFIOvpoMbOC4jGMxphYFMpqh45yn6AhRs2zZ0r8yLa
	 Un5MnQkmbjIRzHGX0j0zBVjq6Szr0+HuBEkZKY0A/7ua3xDPc4lgZTAMDf4myNNHQq
	 zneSGGMabDvJ5oGl6JWt/h4KjLXAX5EjuFsZc7F8=
Date: Wed, 23 Sep 2026 15:32:55 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch added to mm-unstable branch
Message-Id: <20260923223255.D467A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Wed, 23 Sep 2026 23:32:48 +0200

The mapping parameter only served as a non-NULL check to detect whether
page cache entries need updating.  The xa_state pointer conveys exactly
the same information: the anon split helper passes NULL and the file split
helper passes &xas, which is non-NULL iff the folio is in the page cache.

Use the xas pointer instead and drop the parameter, along with its
kerneldoc entry.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-17-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio
+++ a/mm/huge_memory.c
@@ -3833,7 +3833,6 @@ static void __split_folio_to_order(struc
  * @split_at: in buddy allocator like split, the folio containing @split_at
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
- * @mapping: @folio->mapping
  * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
@@ -3866,7 +3865,7 @@ static void __split_folio_to_order(struc
  */
 static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, enum split_type split_type)
+		enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -3890,7 +3889,7 @@ static int __split_frozen_folio(struct f
 		if (is_anon && split_order == 1)
 			continue;
 
-		if (mapping) {
+		if (xas) {
 			/*
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
@@ -4089,8 +4088,7 @@ static int __folio_freeze_split_anon(str
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
-				   NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4226,8 +4224,7 @@ static int __folio_freeze_split_file(str
 
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

