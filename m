Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C354A07
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773958617; cv=none; b=efExN5O2ZHzbsDPynGQ7joVk33kIdlKMrtkhgAJc/YOHZ1b5ujqKlzY0L1wK9fTKTEwaaYUNK7BwsGhYrSx4vi3SFG5EfOZ6gZUlSZcUayBpegIrsXJu4Pr8N9PJDa/cW5FCh30FazVcTqJ7q6oEis7EQ1KSVT5CvIGgdFIXFBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773958617; c=relaxed/simple;
	bh=YGYRNp4qQ5VSx8wkgOGuw9RzKSBP2KPWEhlsF+6P/WI=;
	h=Date:To:From:Subject:Message-Id; b=fQ0DYFBXwTs5z64CCO5GwzBXUTtJiqnWIeRPR5bmg2LPYpl+JqTTSwnNzDumcKgzUUY89rzHPvU3S+rRP8UialuARZb5FBfD1Sbxxgz3ejZjjxBVwLwaFFfKzoXtJ+KM1VM2T37DGAa2PgQtps0xOYR1yShuXdEaURlcRQ/pmBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hZudetma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hZudetma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77F5C19424;
	Thu, 19 Mar 2026 22:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773958616;
	bh=YGYRNp4qQ5VSx8wkgOGuw9RzKSBP2KPWEhlsF+6P/WI=;
	h=Date:To:From:Subject:From;
	b=hZudetmayIQKwZRJT+JhGfTv5YnQt5qtN0V4eL/TD/phV+/VvIv5f76iNm75nhI84
	 FneXM4Wq/AkAaU8ywqfjsuG8JTArOsITdymanX0MliHuU7Uo6Shs/9+/Js9CfxGV5E
	 bi9ZtO5CnyYhVdVsuwUKBrVhbhFlKATJ/n04wVd4=
Date: Thu, 19 Mar 2026 15:16:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch added to mm-new branch
Message-Id: <20260319221656.B77F5C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge: avoid big else branch in zap_huge_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch

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
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge: avoid big else branch in zap_huge_pmd()
Date: Thu, 19 Mar 2026 13:00:08 +0000

We don't need to have an extra level of indentation, we can simply exit
early in the first two branches.

Link: https://lkml.kernel.org/r/f641f0c9256d54b2266b60caa0538799ea881144.1773924928.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (ARM) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   93 +++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 45 deletions(-)

--- a/mm/huge_memory.c~mm-huge-avoid-big-else-branch-in-zap_huge_pmd
+++ a/mm/huge_memory.c
@@ -2328,8 +2328,10 @@ static inline void zap_deposited_table(s
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
-	pmd_t orig_pmd;
+	struct folio *folio = NULL;
+	int flush_needed = 1;
 	spinlock_t *ptl;
+	pmd_t orig_pmd;
 
 	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
 
@@ -2350,59 +2352,60 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-	} else if (is_huge_zero_pmd(orig_pmd)) {
+		return 1;
+	}
+	if (is_huge_zero_pmd(orig_pmd)) {
 		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-	} else {
-		struct folio *folio = NULL;
-		int flush_needed = 1;
+		return 1;
+	}
+
+	if (pmd_present(orig_pmd)) {
+		struct page *page = pmd_page(orig_pmd);
 
-		if (pmd_present(orig_pmd)) {
-			struct page *page = pmd_page(orig_pmd);
+		folio = page_folio(page);
+		folio_remove_rmap_pmd(folio, page, vma);
+		WARN_ON_ONCE(folio_mapcount(folio) < 0);
+		VM_BUG_ON_PAGE(!PageHead(page), page);
+	} else if (pmd_is_valid_softleaf(orig_pmd)) {
+		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
-			folio = page_folio(page);
-			folio_remove_rmap_pmd(folio, page, vma);
-			WARN_ON_ONCE(folio_mapcount(folio) < 0);
-			VM_BUG_ON_PAGE(!PageHead(page), page);
-		} else if (pmd_is_valid_softleaf(orig_pmd)) {
-			const softleaf_t entry = softleaf_from_pmd(orig_pmd);
-
-			folio = softleaf_to_folio(entry);
-			flush_needed = 0;
-
-			if (!thp_migration_supported())
-				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-		}
+		folio = softleaf_to_folio(entry);
+		flush_needed = 0;
+
+		if (!thp_migration_supported())
+			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	}
 
-		if (folio_test_anon(folio)) {
+	if (folio_test_anon(folio)) {
+		zap_deposited_table(tlb->mm, pmd);
+		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	} else {
+		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-		} else {
-			if (arch_needs_pgtable_deposit())
-				zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, mm_counter_file(folio),
-				       -HPAGE_PMD_NR);
-
-			/*
-			 * Use flush_needed to indicate whether the PMD entry
-			 * is present, instead of checking pmd_present() again.
-			 */
-			if (flush_needed && pmd_young(orig_pmd) &&
-			    likely(vma_has_recency(vma)))
-				folio_mark_accessed(folio);
-		}
-
-		if (folio_is_device_private(folio)) {
-			folio_remove_rmap_pmd(folio, &folio->page, vma);
-			WARN_ON_ONCE(folio_mapcount(folio) < 0);
-			folio_put(folio);
-		}
+		add_mm_counter(tlb->mm, mm_counter_file(folio),
+			       -HPAGE_PMD_NR);
 
-		spin_unlock(ptl);
-		if (flush_needed)
-			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
+		/*
+		 * Use flush_needed to indicate whether the PMD entry
+		 * is present, instead of checking pmd_present() again.
+		 */
+		if (flush_needed && pmd_young(orig_pmd) &&
+		    likely(vma_has_recency(vma)))
+			folio_mark_accessed(folio);
 	}
+
+	if (folio_is_device_private(folio)) {
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+		WARN_ON_ONCE(folio_mapcount(folio) < 0);
+		folio_put(folio);
+	}
+
+	spin_unlock(ptl);
+	if (flush_needed)
+		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
+
 	return 1;
 }
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-zswap-add-missing-kunmap_local.patch
mm-rmap-clear-vma-anon_vma-on-error.patch
mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch
mm-mremap-correct-invalid-map-count-check.patch
mm-abstract-reading-sysctl_max_map_count-and-read_once.patch
mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch
mm-vma-add-vma_flags_empty-vma_flags_and-vma_flags_diff_pair.patch
tools-testing-vma-add-unit-tests-flag-empty-diff_pair-and.patch
mm-vma-add-further-vma_flags_t-unions.patch
tools-testing-vma-convert-bulk-of-test-code-to-vma_flags_t.patch
mm-vma-use-new-vma-flags-for-sticky-flags-logic.patch
tools-testing-vma-fix-vma-flag-tests.patch
mm-vma-add-append_vma_flags-helper.patch
tools-testing-vma-add-simple-test-for-append_vma_flags.patch
mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter.patch
mm-vma-introduce-vma_flags_same.patch
mm-vma-introduce-_to_-helpers.patch
tools-testing-vma-test-that-legacy-flag-helpers-work-correctly.patch
mm-vma-introduce-vma_test-and-make-inlining-consistent.patch
tools-testing-vma-update-vma-flag-tests-to-test-vma_test.patch
mm-introduce-vma_flags_count-and-vma_test_single_mask.patch
tools-testing-vma-test-vma_flags_countvma_test_single_mask.patch
mm-convert-do_brk_flags-to-use-vma_flags_t.patch
mm-update-vma_supports_mlock-to-use-new-vma-flags.patch
mm-vma-introduce-vma_clear_flags.patch
tools-testing-vma-update-vma-tests-to-test-vma_clear_flags.patch
mm-vma-convert-as-much-as-we-can-in-mm-vmac-to-vma_flags_t.patch
mm-vma-convert-vma_modify_flags-to-use-vma_flags_t.patch
mm-vma-convert-__mmap_region-to-use-vma_flags_t.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-correctly-drop-reference-count-on-mapping-failure.patch
mm-add-mmap_action_simple_ioremap.patch
misc-open-dice-replace-deprecated-mmap-hook-with-mmap_prepare.patch
hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch
stm-replace-deprecated-mmap-hook-with-mmap_prepare.patch
staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch
uio-replace-deprecated-mmap-hook-with-mmap_prepare-in-uio_info.patch
mm-add-mmap_action_map_kernel_pages.patch
mm-on-remap-assert-that-input-range-within-the-proposed-vma.patch
mm-huge_memory-simplify-vma_is_specal_huge.patch
mm-huge-avoid-big-else-branch-in-zap_huge_pmd.patch
mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch
mm-huge_memory-handle-buggy-pmd-entry-in-zap_huge_pmd.patch
mm-huge_memory-add-a-common-exit-path-to-zap_huge_pmd.patch
mm-huge_memory-remove-unnecessary-vm_bug_on_page.patch
mm-huge_memory-deduplicate-zap-deposited-table-call.patch
mm-huge_memory-deduplicate-zap_huge_pmd-further-by-tracking-state.patch
mm-huge_memory-have-zap_huge_pmd-use-vm_normal_folio_pmd.patch

