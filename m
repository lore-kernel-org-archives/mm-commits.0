Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739141885B8
	for <mm-commits@vger.kernel.org>; Wed,  2 Jul 2025 21:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751493029; cv=none; b=HEsSD0ucU62gqNJ9DHraAfRpkDEm3rq5id+q9rT9Aytt9UKuC1Bc3lfg6E31khFWX58G2hl0988wIlWSPnfaaMtdvfOVwqYF/I0M/CwXE5lZtpztc447evvPcKWb5idsizArL6efL2hcdn/ENrn1jc32pPaSFePNdKKDoqgqlWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751493029; c=relaxed/simple;
	bh=KZbX8eLaY5Uw8MjZhOVnxe4I1HVWiKohPTwCMlf92cA=;
	h=Date:To:From:Subject:Message-Id; b=JfQqaV8KtvWPrgEPbo8qEYFlUi8d+gTWX2TbxGhSFPaZs0EVjRLTBLN/5UhPQuW1Od00ImCkgp4p8V8/XCXZHvvzRlRppr58OvoQFSfWemyyDh5c2nI+OCF6Shb8alm8QZEcj22fua6Kpo50LppUv6ZIjxDEk5TVwQBjxHTEa2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EtWJlVIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EtWJlVIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0902CC4CEE7;
	Wed,  2 Jul 2025 21:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751493029;
	bh=KZbX8eLaY5Uw8MjZhOVnxe4I1HVWiKohPTwCMlf92cA=;
	h=Date:To:From:Subject:From;
	b=EtWJlVIwOL7EtuGj5FqrOZm0NTL4G4fTZPQE7/poXy87sRolqWL8rqmRXV9pphzom
	 GrIiRCfE/bNmkXs4a0MTbVzHMCu5K8ty1bmfYeSbh0vpcvZDY/YWXPlHV8izdUOkco
	 lPKCJOgBAe1u2Zl4Jbgk1wzp9ZhNzfGOCKanyWRY=
Date: Wed, 02 Jul 2025 14:50:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,osalvador@suse.de,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,byungchul@sk.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch added to mm-new branch
Message-Id: <20250702215029.0902CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove boolean output parameters from folio_pte_batch_ext()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch

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
Subject: mm: remove boolean output parameters from folio_pte_batch_ext()
Date: Wed, 2 Jul 2025 12:49:26 +0200

Instead, let's just allow for specifying through flags whether we want to
have bits merged into the original PTE.

For the madvise() case, simplify by having only a single parameter for
merging young+dirty.  For madvise_cold_or_pageout_pte_range() merging the
dirty bit is not required, but also not harmful.  This code is not that
performance critical after all to really force all micro-optimizations.

As we now have two pte_t * parameters, use PageTable() to make sure we are
actually given a pointer at a copy of the PTE, not a pointer into an
actual page table.

Link: https://lkml.kernel.org/r/20250702104926.212243-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
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
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   65 +++++++++++++++++++++++++++++++-----------------
 mm/madvise.c  |   26 +++----------------
 mm/memory.c   |    8 +----
 mm/util.c     |    2 -
 4 files changed, 50 insertions(+), 51 deletions(-)

--- a/mm/internal.h~mm-remove-boolean-output-parameters-from-folio_pte_batch_ext
+++ a/mm/internal.h
@@ -208,6 +208,18 @@ typedef int __bitwise fpb_t;
 /* Compare PTEs respecting the soft-dirty bit. */
 #define FPB_RESPECT_SOFT_DIRTY		((__force fpb_t)BIT(1))
 
+/*
+ * Merge PTE write bits: if any PTE in the batch is writable, modify the
+ * PTE at @ptentp to be writable.
+ */
+#define FPB_MERGE_WRITE			((__force fpb_t)BIT(2))
+
+/*
+ * Merge PTE young and dirty bits: if any PTE in the batch is young or dirty,
+ * modify the PTE at @ptentp to be young or dirty, respectively.
+ */
+#define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(3))
+
 static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
 {
 	if (!(flags & FPB_RESPECT_DIRTY))
@@ -220,16 +232,12 @@ static inline pte_t __pte_batch_clear_ig
 /**
  * folio_pte_batch_flags - detect a PTE batch for a large folio
  * @folio: The large folio to detect a PTE batch for.
+ * @vma: The VMA. Only relevant with FPB_MERGE_WRITE, otherwise can be NULL.
  * @ptep: Page table pointer for the first entry.
- * @pte: Page table entry for the first page.
+ * @ptentp: Pointer to a COPY of the first page table entry whose flags this
+ *	    function updates based on @flags if appropriate.
  * @max_nr: The maximum number of table entries to consider.
  * @flags: Flags to modify the PTE batch semantics.
- * @any_writable: Optional pointer to indicate whether any entry except the
- *		  first one is writable.
- * @any_young: Optional pointer to indicate whether any entry except the
- *		  first one is young.
- * @any_dirty: Optional pointer to indicate whether any entry except the
- *		  first one is dirty.
  *
  * Detect a PTE batch: consecutive (present) PTEs that map consecutive
  * pages of the same large folio in a single VMA and a single page table.
@@ -242,28 +250,32 @@ static inline pte_t __pte_batch_clear_ig
  * must be limited by the caller so scanning cannot exceed a single VMA and
  * a single page table.
  *
+ * Depending on the FPB_MERGE_* flags, the pte stored at @ptentp will
+ * be updated: it's crucial that a pointer to a COPY of the first
+ * page table entry, obtained through ptep_get(), is provided as @ptentp.
+ *
  * This function will be inlined to optimize based on the input parameters;
  * consider using folio_pte_batch() instead if applicable.
  *
  * Return: the number of table entries in the batch.
  */
 static inline unsigned int folio_pte_batch_flags(struct folio *folio,
-		pte_t *ptep, pte_t pte, unsigned int max_nr, fpb_t flags,
-		bool *any_writable, bool *any_young, bool *any_dirty)
+		struct vm_area_struct *vma, pte_t *ptep, pte_t *ptentp,
+		unsigned int max_nr, fpb_t flags)
 {
+	bool any_writable = false, any_young = false, any_dirty = false;
+	pte_t expected_pte, pte = *ptentp;
 	unsigned int nr, cur_nr;
-	pte_t expected_pte;
-
-	if (any_writable)
-		*any_writable = false;
-	if (any_young)
-		*any_young = false;
-	if (any_dirty)
-		*any_dirty = false;
 
 	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
 	VM_WARN_ON_FOLIO(!folio_test_large(folio) || max_nr < 1, folio);
 	VM_WARN_ON_FOLIO(page_folio(pfn_to_page(pte_pfn(pte))) != folio, folio);
+	/*
+	 * Ensure this is a pointer to a copy not a pointer into a page table.
+	 * If this is a stack value, it won't be a valid virtual address, but
+	 * that's fine because it also cannot be pointing into the page table.
+	 */
+	VM_WARN_ON(virt_addr_valid(ptentp) && PageTable(virt_to_page(ptentp)));
 
 	/* Limit max_nr to the actual remaining PFNs in the folio we could batch. */
 	max_nr = min_t(unsigned long, max_nr,
@@ -279,12 +291,12 @@ static inline unsigned int folio_pte_bat
 		if (!pte_same(__pte_batch_clear_ignored(pte, flags), expected_pte))
 			break;
 
-		if (any_writable)
-			*any_writable |= pte_write(pte);
-		if (any_young)
-			*any_young |= pte_young(pte);
-		if (any_dirty)
-			*any_dirty |= pte_dirty(pte);
+		if (flags & FPB_MERGE_WRITE)
+			any_writable |= pte_write(pte);
+		if (flags & FPB_MERGE_YOUNG_DIRTY) {
+			any_young |= pte_young(pte);
+			any_dirty |= pte_dirty(pte);
+		}
 
 		cur_nr = pte_batch_hint(ptep, pte);
 		expected_pte = pte_advance_pfn(expected_pte, cur_nr);
@@ -292,6 +304,13 @@ static inline unsigned int folio_pte_bat
 		nr += cur_nr;
 	}
 
+	if (any_writable)
+		*ptentp = pte_mkwrite(*ptentp, vma);
+	if (any_young)
+		*ptentp = pte_mkyoung(*ptentp);
+	if (any_dirty)
+		*ptentp = pte_mkdirty(*ptentp);
+
 	return min(nr, max_nr);
 }
 
--- a/mm/madvise.c~mm-remove-boolean-output-parameters-from-folio_pte_batch_ext
+++ a/mm/madvise.c
@@ -344,13 +344,12 @@ static inline bool can_do_file_pageout(s
 
 static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 					  struct folio *folio, pte_t *ptep,
-					  pte_t pte, bool *any_young,
-					  bool *any_dirty)
+					  pte_t *ptentp)
 {
 	int max_nr = (end - addr) / PAGE_SIZE;
 
-	return folio_pte_batch_flags(folio, ptep, pte, max_nr, 0, NULL,
-				     any_young, any_dirty);
+	return folio_pte_batch_flags(folio, NULL, ptep, ptentp, max_nr,
+				     FPB_MERGE_YOUNG_DIRTY);
 }
 
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
@@ -488,13 +487,7 @@ restart:
 		 * next pte in the range.
 		 */
 		if (folio_test_large(folio)) {
-			bool any_young;
-
-			nr = madvise_folio_pte_batch(addr, end, folio, pte,
-						     ptent, &any_young, NULL);
-			if (any_young)
-				ptent = pte_mkyoung(ptent);
-
+			nr = madvise_folio_pte_batch(addr, end, folio, pte, &ptent);
 			if (nr < folio_nr_pages(folio)) {
 				int err;
 
@@ -724,11 +717,7 @@ static int madvise_free_pte_range(pmd_t
 		 * next pte in the range.
 		 */
 		if (folio_test_large(folio)) {
-			bool any_young, any_dirty;
-
-			nr = madvise_folio_pte_batch(addr, end, folio, pte,
-						     ptent, &any_young, &any_dirty);
-
+			nr = madvise_folio_pte_batch(addr, end, folio, pte, &ptent);
 			if (nr < folio_nr_pages(folio)) {
 				int err;
 
@@ -753,11 +742,6 @@ static int madvise_free_pte_range(pmd_t
 					nr = 0;
 				continue;
 			}
-
-			if (any_young)
-				ptent = pte_mkyoung(ptent);
-			if (any_dirty)
-				ptent = pte_mkdirty(ptent);
 		}
 
 		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
--- a/mm/memory.c~mm-remove-boolean-output-parameters-from-folio_pte_batch_ext
+++ a/mm/memory.c
@@ -972,10 +972,9 @@ copy_present_ptes(struct vm_area_struct
 		 pte_t *dst_pte, pte_t *src_pte, pte_t pte, unsigned long addr,
 		 int max_nr, int *rss, struct folio **prealloc)
 {
+	fpb_t flags = FPB_MERGE_WRITE;
 	struct page *page;
 	struct folio *folio;
-	bool any_writable;
-	fpb_t flags = 0;
 	int err, nr;
 
 	page = vm_normal_page(src_vma, addr, pte);
@@ -995,8 +994,7 @@ copy_present_ptes(struct vm_area_struct
 		if (vma_soft_dirty_enabled(src_vma))
 			flags |= FPB_RESPECT_SOFT_DIRTY;
 
-		nr = folio_pte_batch_flags(folio, src_pte, pte, max_nr, flags,
-					   &any_writable, NULL, NULL);
+		nr = folio_pte_batch_flags(folio, src_vma, src_pte, &pte, max_nr, flags);
 		folio_ref_add(folio, nr);
 		if (folio_test_anon(folio)) {
 			if (unlikely(folio_try_dup_anon_rmap_ptes(folio, page,
@@ -1010,8 +1008,6 @@ copy_present_ptes(struct vm_area_struct
 			folio_dup_file_rmap_ptes(folio, page, nr, dst_vma);
 			rss[mm_counter_file(folio)] += nr;
 		}
-		if (any_writable)
-			pte = pte_mkwrite(pte, src_vma);
 		__copy_present_ptes(dst_vma, src_vma, dst_pte, src_pte, pte,
 				    addr, nr);
 		return nr;
--- a/mm/util.c~mm-remove-boolean-output-parameters-from-folio_pte_batch_ext
+++ a/mm/util.c
@@ -1197,6 +1197,6 @@ EXPORT_SYMBOL(compat_vma_mmap_prepare);
 unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 		unsigned int max_nr)
 {
-	return folio_pte_batch_flags(folio, ptep, pte, max_nr, 0, NULL, NULL, NULL);
+	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
 }
 #endif /* CONFIG_MMU */
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

