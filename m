Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F624A07
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773958619; cv=none; b=F4PanvDf931REIdUCgc54GDP+AJNYhDxRCAvXEffSRO83LYteXxjkTTw+iZuVRtGUHuBb3Mfw5ZdPnfRl0erDF30X20Dgw5DhNrByujPgvwJciclYYq1tdlvji2KurQfykXE5ZbZ2OUcS2FThm/woMuEtMEmcx+2uijAmPpkYFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773958619; c=relaxed/simple;
	bh=AEImAgE+B+r9ZLQUmdsgxXse+N19ONxaCDvZ/1x3u2Y=;
	h=Date:To:From:Subject:Message-Id; b=c/49Zi+kJ58gwKh/K7ioh+Y42IDhQhHetldcb7WXNf00obPvLbK/1Nsr9cJ2431TO/NET8LumqlDjHRXEoXO9zyTqauHYn5cFco3TUZ76KoMf6byDkNiojDfMkmxMrUXsgRrukV16xuI49ov+y5HsqQGdGWv00+gLD95TXXzYaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mwXwmpJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mwXwmpJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A4CC19424;
	Thu, 19 Mar 2026 22:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773958619;
	bh=AEImAgE+B+r9ZLQUmdsgxXse+N19ONxaCDvZ/1x3u2Y=;
	h=Date:To:From:Subject:From;
	b=mwXwmpJaOc04womIclwn1v/lr2ZYhiZXZaHmYbtQdfGTeS2laXcLKkRq3UO1jfsy5
	 aXDvc2XDmILfcTksC083IAMhuerY6Z4cR0PL1WnMyigfO3kq7WUqEmLe7U+oqpuRdC
	 PQOR9sxTjnBIxm5uIJZS77plqvEA8BwJFHoe0CRk=
Date: Thu, 19 Mar 2026 15:16:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch added to mm-new branch
Message-Id: <20260319221659.10A4CC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc.patch

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
Subject: mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
Date: Thu, 19 Mar 2026 13:00:09 +0000

There's no need to use the ancient approach of returning an integer here,
just return a boolean.

Also update flush_needed to be a boolean, similarly.

Also add a kdoc comment describing the function.

Link: https://lkml.kernel.org/r/8bb854291383ff4713427e6d903d6d79435eb153.1773924928.git.ljs@kernel.org
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

 include/linux/huge_mm.h |    4 ++--
 mm/huge_memory.c        |   23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc
+++ a/include/linux/huge_mm.h
@@ -27,8 +27,8 @@ static inline void huge_pud_set_accessed
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
 bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			   pmd_t *pmd, unsigned long addr, unsigned long next);
-int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
-		 unsigned long addr);
+bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
+		  unsigned long addr);
 int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma, pud_t *pud,
 		 unsigned long addr);
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
--- a/mm/huge_memory.c~mm-huge_memory-have-zap_huge_pmd-return-a-boolean-add-kdoc
+++ a/mm/huge_memory.c
@@ -2325,11 +2325,20 @@ static inline void zap_deposited_table(s
 	mm_dec_nr_ptes(mm);
 }
 
-int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+/**
+ * zap_huge_pmd - Zap a huge THP which is of PMD size.
+ * @tlb: The MMU gather TLB state associated with the operation.
+ * @vma: The VMA containing the range to zap.
+ * @pmd: A pointer to the leaf PMD entry.
+ * @addr: The virtual address for the range to zap.
+ *
+ * Returns: %true on success, %false otherwise.
+ */
+bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	struct folio *folio = NULL;
-	int flush_needed = 1;
+	bool flush_needed = true;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2337,7 +2346,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 	ptl = __pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
-		return 0;
+		return false;
 	/*
 	 * For architectures like ppc64 we look at deposited pgtable
 	 * when calling pmdp_huge_get_and_clear. So do the
@@ -2352,13 +2361,13 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		return 1;
+		return true;
 	}
 	if (is_huge_zero_pmd(orig_pmd)) {
 		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		return 1;
+		return true;
 	}
 
 	if (pmd_present(orig_pmd)) {
@@ -2372,7 +2381,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-		flush_needed = 0;
+		flush_needed = false;
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
@@ -2406,7 +2415,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 
-	return 1;
+	return true;
 }
 
 #ifndef pmd_move_must_withdraw
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

