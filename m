Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96941265CAF
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588761; cv=none; b=eCVeqyHka67Yyaxp+l/vdy7UVKIRKZbpfAAhmvGtgDANYGOi3GKe7kZxyKu/qiPrE/6efWWWpYPbJa915wEfaXTJOVokXb6fdic4jcJRZvdu8NYnOYhkD8QQGkh7oOjfiY4bhNt0E1GaOaQx37oWREH9sa3nmzdqjvKZDjkPHBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588761; c=relaxed/simple;
	bh=lg2nL9dcrNzBkagWiDLydKhPuZGhWkqgTdHW5PKUntE=;
	h=Date:To:From:Subject:Message-Id; b=QFHCDH/dg7f4vEiraRMbNMZLy2E5tnLoRpr0qgLRCwdFXF0grC81hB2Wb2nY2xKkhqapKGNWPkGEA9Jh6azLbUHFiTiWFKd/76VChwDwQHPS2OBikridiVgzI5vC+uXfEqp6WgzzDavhxEEJOt4V3Kvz32xD1o7G2cgGFcdfSqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eE0BO63w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eE0BO63w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E98C4CEED;
	Tue, 10 Jun 2025 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749588761;
	bh=lg2nL9dcrNzBkagWiDLydKhPuZGhWkqgTdHW5PKUntE=;
	h=Date:To:From:Subject:From;
	b=eE0BO63wJtSLDQ8RTfLWUD27Dltbu29nF2UueipAx4dK2MVqnQmokgyyV3wd0xcMi
	 XWd4ZMQk5e21HwfsTC8wahEukY2huskbOoneCWyECcFQrXwV/9EgdGgbyNsDZ3SIek
	 25aPkw/16JItLfIAabGFoW04xoDPKM9A6boMwXPU=
Date: Tue, 10 Jun 2025 13:52:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,npache@redhat.com,matenajakub@gmail.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch added to mm-new branch
Message-Id: <20250610205241.11E98C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: add MREMAP[_MUST]_RELOCATE_ANON support for large folios
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: add MREMAP[_MUST]_RELOCATE_ANON support for large folios
Date: Mon, 9 Jun 2025 14:26:37 +0100

Larger folios are a challenge, as they might be mapped across multiple
VMAs, and can be mapped at a higher page table level (PUD, PMD) or also at
PTE level.

Handle them correctly by checking whether they are fully spanned by the
VMA we are examining.  If so, then we can simply relocate the folio as we
would any other.

If not, then we must split the folio.  If there is a higher level page
table level mapping the large folio directly then we must also split this.

This will be the minority of cases, and if the operation is performed on a
large, mapping will only be those folios at the start and end of the
mapping which the mapping is not aligned to.

The net result is that we are able to handle large folios mapped in any
form which might be encountered correctly.

Link: https://lkml.kernel.org/r/43175a21c9e93bc4eb51d73190226411e6b9a7b8.1749473726.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |  327 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 297 insertions(+), 30 deletions(-)

--- a/mm/mremap.c~mm-mremap-add-mremap_relocate_anon-support-for-large-folios
+++ a/mm/mremap.c
@@ -77,6 +77,7 @@ struct pte_state {
 	unsigned long new_addr;
 	unsigned long old_end;
 	pte_t *ptep;
+	pmd_t *pmdp;
 	spinlock_t *ptl;
 };
 
@@ -534,40 +535,67 @@ enum pgt_entry {
 	HPAGE_PUD,
 };
 
-/*
- * Returns an extent of the corresponding size for the pgt_entry specified if
- * valid. Else returns a smaller extent bounded by the end of the source and
- * destination pgt_entry.
- */
-static __always_inline unsigned long get_extent(enum pgt_entry entry,
-						struct pagetable_move_control *pmc)
+static void __get_mask_size(enum pgt_entry entry,
+		unsigned long *mask, unsigned long *size)
 {
-	unsigned long next, extent, mask, size;
-	unsigned long old_addr = pmc->old_addr;
-	unsigned long old_end = pmc->old_end;
-	unsigned long new_addr = pmc->new_addr;
-
 	switch (entry) {
 	case HPAGE_PMD:
 	case NORMAL_PMD:
-		mask = PMD_MASK;
-		size = PMD_SIZE;
+		*mask = PMD_MASK;
+		*size = PMD_SIZE;
 		break;
 	case HPAGE_PUD:
 	case NORMAL_PUD:
-		mask = PUD_MASK;
-		size = PUD_SIZE;
+		*mask = PUD_MASK;
+		*size = PUD_SIZE;
 		break;
 	default:
 		BUILD_BUG();
 		break;
 	}
+}
+
+/* Same as get extent, only ignores new address.  */
+static unsigned long __get_old_extent(struct pagetable_move_control *pmc,
+		unsigned long mask, unsigned long size)
+{
+	unsigned long next, extent;
+	unsigned long old_addr = pmc->old_addr;
+	unsigned long old_end = pmc->old_end;
 
 	next = (old_addr + size) & mask;
 	/* even if next overflowed, extent below will be ok */
 	extent = next - old_addr;
 	if (extent > old_end - old_addr)
 		extent = old_end - old_addr;
+
+	return extent;
+}
+
+static unsigned long get_old_extent(enum pgt_entry entry,
+		struct pagetable_move_control *pmc)
+{
+	unsigned long mask, size;
+
+	__get_mask_size(entry, &mask, &size);
+	return __get_old_extent(pmc, mask, size);
+}
+
+/*
+ * Returns an extent of the corresponding size for the pgt_entry specified if
+ * valid. Else returns a smaller extent bounded by the end of the source and
+ * destination pgt_entry.
+ */
+static __always_inline unsigned long get_extent(enum pgt_entry entry,
+						struct pagetable_move_control *pmc)
+{
+	unsigned long next, extent, mask, size;
+	unsigned long new_addr = pmc->new_addr;
+
+	__get_mask_size(entry, &mask, &size);
+
+	extent = __get_old_extent(pmc, mask, size);
+
 	next = (new_addr + size) & mask;
 	if (extent > next - new_addr)
 		extent = next - new_addr;
@@ -797,6 +825,165 @@ static unsigned long pmc_progress(struct
 	return old_addr < orig_old_addr ? 0 : old_addr - orig_old_addr;
 }
 
+/* Assumes folio lock is held. */
+static bool __relocate_large_folio(struct pagetable_move_control *pmc,
+		unsigned long old_addr, unsigned long new_addr,
+		struct folio *folio, bool undo)
+{
+	pgoff_t new_index;
+	struct vm_area_struct *old = pmc->old;
+	struct vm_area_struct *new = pmc->new;
+
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+
+	/* no-op. */
+	if (!folio_test_anon(folio))
+		return true;
+
+	if (!undo)
+		new_index = linear_page_index(new, new_addr);
+	else
+		new_index = linear_page_index(old, old_addr);
+
+	/* See comment in relocate_anon_pte(). */
+	folio_move_anon_rmap(folio, undo ? old : new);
+	WRITE_ONCE(folio->index, new_index);
+	return true;
+}
+
+static bool relocate_large_folio(struct pagetable_move_control *pmc,
+		unsigned long old_addr, unsigned long new_addr,
+		struct folio *folio, bool undo)
+{
+	bool ret;
+
+	folio_lock(folio);
+
+	if (!folio_test_large(folio) || folio_test_ksm(folio)) {
+		ret = false;
+		goto out;
+	}
+
+	/* See relocate_anon_pte() for description. */
+	if (WARN_ON_ONCE(folio_maybe_mapped_shared(folio))) {
+		ret = false;
+		goto out;
+	}
+	if (folio_maybe_dma_pinned(folio)) {
+		ret = false;
+		goto out;
+	}
+
+	ret = __relocate_large_folio(pmc, old_addr, new_addr, folio, undo);
+
+out:
+	folio_unlock(folio);
+	return ret;
+}
+
+static bool relocate_anon_pud(struct pagetable_move_control *pmc,
+		pud_t *pudp, bool undo)
+{
+	spinlock_t *ptl;
+	pud_t pud;
+	struct folio *folio;
+	struct page *page;
+	bool ret;
+	unsigned long old_addr = pmc->old_addr;
+	unsigned long new_addr = pmc->new_addr;
+
+	VM_WARN_ON(old_addr & ~HPAGE_PUD_MASK);
+	VM_WARN_ON(new_addr & ~HPAGE_PUD_MASK);
+
+	ptl = pud_trans_huge_lock(pudp, pmc->old);
+	if (!ptl)
+		return false;
+
+	pud = pudp_get(pudp);
+	if (!pud_present(pud)) {
+		ret = true;
+		goto out;
+	}
+	if (!pud_leaf(pud)) {
+		ret = false;
+		goto out;
+	}
+
+	page = pud_page(pud);
+	if (!page) {
+		ret = true;
+		goto out;
+	}
+
+	folio = page_folio(page);
+	ret = relocate_large_folio(pmc, old_addr, new_addr, folio, undo);
+
+out:
+	spin_unlock(ptl);
+	return ret;
+}
+
+static bool relocate_anon_pmd(struct pagetable_move_control *pmc,
+		pmd_t *pmdp, bool undo)
+{
+	spinlock_t *ptl;
+	pmd_t pmd;
+	struct folio *folio;
+	bool ret;
+	unsigned long old_addr = pmc->old_addr;
+	unsigned long new_addr = pmc->new_addr;
+
+	VM_WARN_ON(old_addr & ~HPAGE_PMD_MASK);
+	VM_WARN_ON(new_addr & ~HPAGE_PMD_MASK);
+
+	ptl = pmd_trans_huge_lock(pmdp, pmc->old);
+	if (!ptl)
+		return false;
+
+	pmd = pmdp_get(pmdp);
+	if (!pmd_present(pmd)) {
+		ret = true;
+		goto out;
+	}
+	if (is_huge_zero_pmd(pmd)) {
+		ret = true;
+		goto out;
+	}
+	if (!pmd_leaf(pmd)) {
+		ret = false;
+		goto out;
+	}
+
+	folio = pmd_folio(pmd);
+	if (!folio) {
+		ret = true;
+		goto out;
+	}
+
+	ret = relocate_large_folio(pmc, old_addr, new_addr, folio, undo);
+out:
+	spin_unlock(ptl);
+	return ret;
+}
+
+/*
+ * Is the THP discovered at old_addr fully spanned at both the old and new VMAs?
+ */
+static bool is_thp_fully_spanned(struct pagetable_move_control *pmc,
+				 unsigned long old_addr,
+				 size_t thp_size)
+{
+	unsigned long old_end = pmc->old_end;
+	unsigned long orig_old_addr = old_end - pmc->len_in;
+	unsigned long aligned_start = old_addr & ~(thp_size - 1);
+	unsigned long aligned_end = aligned_start + thp_size;
+
+	if (aligned_start < orig_old_addr || aligned_end > old_end)
+		return false;
+
+	return true;
+}
+
 /*
  * If the folio mapped at the specified pte entry can have its index and mapping
  * relocated, then do so.
@@ -813,10 +1000,12 @@ static unsigned long relocate_anon_pte(s
 	unsigned long ret = 1;
 	unsigned long old_addr = state->old_addr;
 	unsigned long new_addr = state->new_addr;
+	struct mm_struct *mm = current->mm;
 
 	old = pmc->old;
 	new = pmc->new;
 
+retry:
 	pte = ptep_get(state->ptep);
 
 	/* Ensure we have truly got an anon folio. */
@@ -853,13 +1042,55 @@ static unsigned long relocate_anon_pte(s
 	if (folio_maybe_dma_pinned(folio))
 		goto out;
 
-	/*
-	 * This should not happen as we explicitly disallow this, but check
-	 * anyway.
-	 */
+	/* If a split huge PMD, try to relocate all at once. */
 	if (folio_test_large(folio)) {
-		ret = 0;
-		goto out;
+		size_t size = folio_size(folio);
+
+		if (is_thp_fully_spanned(pmc, old_addr, size) &&
+		    __relocate_large_folio(pmc, old_addr, new_addr, folio, undo)) {
+			VM_WARN_ON_ONCE(old_addr & (size - 1));
+			ret = folio_nr_pages(folio);
+			goto out;
+		} else {
+			int err;
+			struct anon_vma *anon_vma = folio_anon_vma(folio);
+
+			/*
+			 * If the folio has the anon_vma whose lock we hold, we
+			 * have a problem, as split_folio() will attempt to lock
+			 * the already-locked anon_vma causing a deadlock. In
+			 * this case, bail out.
+			 */
+			if (anon_vma->root == pmc->relocate_locked->anon_vma->root) {
+				ret = 0;
+				goto out;
+			}
+
+			/* split_folio() expects elevated refcount. */
+			folio_get(folio);
+
+			/*
+			 * We must relinquish/reacquire the PTE lock over this
+			 * operation. We hold the folio lock and an increased
+			 * reference count, so there's no danger of the folio
+			 * disappearing beneath us.
+			 */
+			pte_unmap_unlock(state->ptep, state->ptl);
+			err = split_folio(folio);
+			state->ptep = pte_offset_map_lock(mm, state->pmdp,
+							  old_addr, &state->ptl);
+			folio_unlock(folio);
+			folio_put(folio);
+
+			if (err || !state->ptep)
+				return 0;
+
+			/*
+			 * If we split, we need to look up the folio again, so
+			 * simply retry the operation.
+			 */
+			goto retry;
+		}
 	}
 
 	if (!undo)
@@ -906,6 +1137,7 @@ static bool relocate_anon_ptes(struct pa
 		.old_addr = pmc->old_addr,
 		.new_addr = pmc->new_addr,
 		.old_end = pmc->old_addr + extent,
+		.pmdp = pmdp,
 	};
 	pte_t *ptep_start;
 	bool ret;
@@ -955,29 +1187,64 @@ static bool __relocate_anon_folios(struc
 		pmd_t pmd;
 		pud_t pud;
 
-		extent = get_extent(NORMAL_PUD, pmc);
+		extent = get_old_extent(NORMAL_PUD, pmc);
 
 		pudp = get_old_pud(mm, pmc->old_addr);
 		if (!pudp)
 			continue;
 		pud = pudp_get(pudp);
+		if (pud_trans_huge(pud)) {
+			unsigned long old_addr = pmc->old_addr;
+
+			if (extent != HPAGE_PUD_SIZE)
+				return false;
+
+			VM_WARN_ON_ONCE(old_addr & ~HPAGE_PUD_MASK);
 
-		if (pud_trans_huge(pud) || pud_devmap(pud))
+			/* We may relocate iff the new address is aligned. */
+			if (!(pmc->new_addr & ~HPAGE_PUD_MASK) &&
+			    is_thp_fully_spanned(pmc, old_addr, HPAGE_PUD_SIZE)) {
+				if (!relocate_anon_pud(pmc, pudp, undo))
+					return false;
+				continue;
+			}
+
+			/* Otherwise, we split so we can do this with PMDs/PTEs. */
+			split_huge_pud(pmc->old, pudp, old_addr);
+		} else if (pud_devmap(pud)) {
 			return false;
+		}
 
-		extent = get_extent(NORMAL_PMD, pmc);
+		extent = get_old_extent(NORMAL_PMD, pmc);
 		pmdp = get_old_pmd(mm, pmc->old_addr);
 		if (!pmdp)
 			continue;
 		pmd = pmdp_get(pmdp);
-
-		if (is_swap_pmd(pmd) || pmd_trans_huge(pmd) ||
-		    pmd_devmap(pmd))
-			return false;
-
 		if (pmd_none(pmd))
 			continue;
 
+		if (pmd_trans_huge(pmd)) {
+			unsigned long old_addr = pmc->old_addr;
+
+			if (extent != HPAGE_PMD_SIZE)
+				return false;
+
+			VM_WARN_ON_ONCE(old_addr & ~HPAGE_PMD_MASK);
+
+			/* We may relocate iff the new address is aligned. */
+			if (!(pmc->new_addr & ~HPAGE_PMD_MASK) &&
+			    is_thp_fully_spanned(pmc, old_addr, HPAGE_PMD_SIZE)) {
+				if (!relocate_anon_pmd(pmc, pmdp, undo))
+					return false;
+				continue;
+			}
+
+			/* Otherwise, we split so we can do this with PTEs. */
+			split_huge_pmd(pmc->old, pmdp, old_addr);
+		} else if (is_swap_pmd(pmd) || pmd_devmap(pmd)) {
+			return false;
+		}
+
 		if (!relocate_anon_ptes(pmc, extent, pmdp, undo))
 			return false;
 	}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

