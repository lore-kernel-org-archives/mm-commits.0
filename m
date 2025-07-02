Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4AF1885B8
	for <mm-commits@vger.kernel.org>; Wed,  2 Jul 2025 21:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751493027; cv=none; b=XBuFzQV1PMgIXis1uIuFo6hwpXibghRZfAh06t83eiXqeiChqFMeGfWuJ1w+ksX61okWZO6TpciGSebXuOmT4TSQRGMlGDoa+7pFi0BxKe3L8uGE+LekHU3PDa/BHY9rwVWECi3jHiS/uLAGYZr4iAVTEUs4nT6YDZo1PZx1fOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751493027; c=relaxed/simple;
	bh=9vAi53rkm9gkjSXsG47ARbqJ9fa9wcYzobCFB1LOMgY=;
	h=Date:To:From:Subject:Message-Id; b=ZhGx2Mx09ycYZ/NMLV3i2TBvhjaoBPRH17g1nuhuBRr2VynZWSjwGLMxrujjmcPFL6O2/eTx2zQBnEtUDEPn7gpEtR5f5XI3z8HGEnju6w1Wk5IFEOnqF3PPJ+IIosQ3uR7SDiboYTldcv0h+PflkIyeCxdBtAPWOHyHNtNwkHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H+w/LvsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H+w/LvsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF449C4CEE7;
	Wed,  2 Jul 2025 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751493026;
	bh=9vAi53rkm9gkjSXsG47ARbqJ9fa9wcYzobCFB1LOMgY=;
	h=Date:To:From:Subject:From;
	b=H+w/LvsNON9XqzdoiIRivkEfjXwt/vm0FM/9DmqNj/15fE9CZe2qxqZZSBGdnwUUP
	 1NoRqw1VwNKETNERwXfkJj6kvC1sVbxACzYUiUozl2f1QhKLB1ps55q3o35quGIXe3
	 ZFsxpjJPjE+rUpV5cGwhDGjv7zo1FKoLcQZ3Fbbo=
Date: Wed, 02 Jul 2025 14:50:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,osalvador@suse.de,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,byungchul@sk.com,apopple@nvidia.com,akpm@linux-foundation.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch added to mm-new branch
Message-Id: <20250702215026.AF449C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: split folio_pte_batch() into folio_pte_batch() and folio_pte_batch_flags()
has been added to the -mm mm-new branch.  Its filename is
     mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: split folio_pte_batch() into folio_pte_batch() and folio_pte_batch_flags()
Date: Wed, 2 Jul 2025 12:49:25 +0200

Many users (including upcoming ones) don't really need the flags etc, and
can live with the possible overhead of a function call.

So let's provide a basic, non-inlined folio_pte_batch(), to avoid code
bloat while still providing a variant that optimizes out all flag checks
at runtime.  folio_pte_batch_flags() will get inlined into
folio_pte_batch(), optimizing out any conditionals that depend on input
flags.

folio_pte_batch() will behave like folio_pte_batch_flags() when no flags
are specified.  It's okay to add new users of folio_pte_batch_flags(), but
using folio_pte_batch() if applicable is preferred.

So, before this change, folio_pte_batch() was inlined into the C file
optimized by propagating constants within the resulting object file.

With this change, we now also have a folio_pte_batch() that is optimized
by propagating all constants.  But instead of having one instance per
object file, we have a single shared one.

In zap_present_ptes(), where we care about performance, the compiler
already seem to generate a call to a common inlined folio_pte_batch()
variant, shared with fork() code.  So calling the new non-inlined variant
should not make a difference.

While at it, drop the "addr" parameter that is unused.

Link: https://lkml.kernel.org/r/20250702104926.212243-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/linux-mm/20250503182858.5a02729fcffd6d4723afcfc2@linux-foundation.org/
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |   11 ++++++++---
 mm/madvise.c   |    4 ++--
 mm/memory.c    |    8 +++-----
 mm/mempolicy.c |    3 +--
 mm/mlock.c     |    3 +--
 mm/mremap.c    |    3 +--
 mm/rmap.c      |    3 +--
 mm/util.c      |   29 +++++++++++++++++++++++++++++
 8 files changed, 46 insertions(+), 18 deletions(-)

--- a/mm/internal.h~mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags
+++ a/mm/internal.h
@@ -218,9 +218,8 @@ static inline pte_t __pte_batch_clear_ig
 }
 
 /**
- * folio_pte_batch - detect a PTE batch for a large folio
+ * folio_pte_batch_flags - detect a PTE batch for a large folio
  * @folio: The large folio to detect a PTE batch for.
- * @addr: The user virtual address the first page is mapped at.
  * @ptep: Page table pointer for the first entry.
  * @pte: Page table entry for the first page.
  * @max_nr: The maximum number of table entries to consider.
@@ -243,9 +242,12 @@ static inline pte_t __pte_batch_clear_ig
  * must be limited by the caller so scanning cannot exceed a single VMA and
  * a single page table.
  *
+ * This function will be inlined to optimize based on the input parameters;
+ * consider using folio_pte_batch() instead if applicable.
+ *
  * Return: the number of table entries in the batch.
  */
-static inline unsigned int folio_pte_batch(struct folio *folio, unsigned long addr,
+static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 		pte_t *ptep, pte_t pte, unsigned int max_nr, fpb_t flags,
 		bool *any_writable, bool *any_young, bool *any_dirty)
 {
@@ -293,6 +295,9 @@ static inline unsigned int folio_pte_bat
 	return min(nr, max_nr);
 }
 
+unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
+		unsigned int max_nr);
+
 /**
  * pte_move_swp_offset - Move the swap entry offset field of a swap pte
  *	 forward or backward by delta
--- a/mm/madvise.c~mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags
+++ a/mm/madvise.c
@@ -349,8 +349,8 @@ static inline int madvise_folio_pte_batc
 {
 	int max_nr = (end - addr) / PAGE_SIZE;
 
-	return folio_pte_batch(folio, addr, ptep, pte, max_nr, 0, NULL,
-			       any_young, any_dirty);
+	return folio_pte_batch_flags(folio, ptep, pte, max_nr, 0, NULL,
+				     any_young, any_dirty);
 }
 
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
--- a/mm/memory.c~mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags
+++ a/mm/memory.c
@@ -995,8 +995,8 @@ copy_present_ptes(struct vm_area_struct
 		if (vma_soft_dirty_enabled(src_vma))
 			flags |= FPB_RESPECT_SOFT_DIRTY;
 
-		nr = folio_pte_batch(folio, addr, src_pte, pte, max_nr, flags,
-				     &any_writable, NULL, NULL);
+		nr = folio_pte_batch_flags(folio, src_pte, pte, max_nr, flags,
+					   &any_writable, NULL, NULL);
 		folio_ref_add(folio, nr);
 		if (folio_test_anon(folio)) {
 			if (unlikely(folio_try_dup_anon_rmap_ptes(folio, page,
@@ -1564,9 +1564,7 @@ static inline int zap_present_ptes(struc
 	 * by keeping the batching logic separate.
 	 */
 	if (unlikely(folio_test_large(folio) && max_nr != 1)) {
-		nr = folio_pte_batch(folio, addr, pte, ptent, max_nr, 0,
-				     NULL, NULL, NULL);
-
+		nr = folio_pte_batch(folio, pte, ptent, max_nr);
 		zap_present_folio_ptes(tlb, vma, folio, page, pte, ptent, nr,
 				       addr, details, rss, force_flush,
 				       force_break, any_skipped);
--- a/mm/mempolicy.c~mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags
+++ a/mm/mempolicy.c
@@ -711,8 +711,7 @@ static int queue_folios_pte_range(pmd_t
 		if (!folio || folio_is_zone_device(folio))
 			continue;
 		if (folio_test_large(folio) && max_nr != 1)
-			nr = folio_pte_batch(folio, addr, pte, ptent,
-					     max_nr, 0, NULL, NULL, NULL);
+			nr = folio_pte_batch(folio, pte, ptent, max_nr);
 		/*
 		 * vm_normal_folio() filters out zero pages, but there might
 		 * still be reserved folios to skip, perhaps in a VDSO.
--- a/mm/mlock.c~mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags
+++ a/mm/mlock.c
@@ -313,8 +313,7 @@ static inline unsigned int folio_mlock_s
 	if (!folio_test_large(folio))
 		return 1;
 
-	return folio_pte_batch(folio, addr, pte, ptent, count, 0, NULL,
-			       NULL, NULL);
+	return folio_pte_batch(folio, pte, ptent, count);
 }
 
 static inline bool allow_mlock_munlock(struct folio *folio,
--- a/mm/mremap.c~mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags
+++ a/mm/mremap.c
@@ -182,8 +182,7 @@ static int mremap_folio_pte_batch(struct
 	if (!folio || !folio_test_large(folio))
 		return 1;
 
-	return folio_pte_batch(folio, addr, ptep, pte, max_nr, 0, NULL,
-			       NULL, NULL);
+	return folio_pte_batch(folio, ptep, pte, max_nr);
 }
 
 static int move_ptes(struct pagetable_move_control *pmc,
--- a/mm/rmap.c~mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags
+++ a/mm/rmap.c
@@ -1868,8 +1868,7 @@ static inline unsigned int folio_unmap_p
 	if (pte_unused(pte))
 		return 1;
 
-	return folio_pte_batch(folio, addr, pvmw->pte, pte, max_nr, 0,
-			       NULL, NULL, NULL);
+	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
 }
 
 /*
--- a/mm/util.c~mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags
+++ a/mm/util.c
@@ -1171,3 +1171,32 @@ int compat_vma_mmap_prepare(struct file
 	return 0;
 }
 EXPORT_SYMBOL(compat_vma_mmap_prepare);
+
+#ifdef CONFIG_MMU
+/**
+ * folio_pte_batch - detect a PTE batch for a large folio
+ * @folio: The large folio to detect a PTE batch for.
+ * @ptep: Page table pointer for the first entry.
+ * @pte: Page table entry for the first page.
+ * @max_nr: The maximum number of table entries to consider.
+ *
+ * This is a simplified variant of folio_pte_batch_flags().
+ *
+ * Detect a PTE batch: consecutive (present) PTEs that map consecutive
+ * pages of the same large folio in a single VMA and a single page table.
+ *
+ * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN,
+ * the accessed bit, writable bit, dirt-bit and soft-dirty bit.
+ *
+ * ptep must map any page of the folio. max_nr must be at least one and
+ * must be limited by the caller so scanning cannot exceed a single VMA and
+ * a single page table.
+ *
+ * Return: the number of table entries in the batch.
+ */
+unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
+		unsigned int max_nr)
+{
+	return folio_pte_batch_flags(folio, ptep, pte, max_nr, 0, NULL, NULL, NULL);
+}
+#endif /* CONFIG_MMU */
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch
mm-huge_memory-dont-ignore-queried-cachemode-in-vmf_insert_pfn_pud.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pmd.patch
mm-huge_memory-dont-mark-refcounted-folios-special-in-vmf_insert_folio_pud.patch
mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch

