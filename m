Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD698347FC6
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 23:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762299555; cv=none; b=A+GqHyNZLaZoPMrtVc3qhLI/rYscnUE+fOKRJs0KEN1ZXxaa9ov6Cn0XTig9lQ5JG/rSdT+va6lovWr+0QuLPwwOQX+F6Q7VqIpROwYipmF0prD8O1FjOQ75FlpJcORS8RymylSJ4EfR+wbOOh2fkioy878n+0N1H7HKniFZgDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762299555; c=relaxed/simple;
	bh=c2Nr95m7zzm8oakKWhuLVMgZIDxsp1O1i3/jRzyNsOY=;
	h=Date:To:From:Subject:Message-Id; b=Vcnj60jAH4o2vY2jdnk8skIMepsDuD5/tJUwV2pmjbf5v0OVFOYmlovcibfAiOcJ56JZtzp620dtovbFvfRTNQTNypSBnNDNoAEeElniY30wMtJAHXB2I4Hjb8VD68j9K/BcKypsfvvVtpjESzSW2rI8VkDzbUkX051ro157atQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NAPI0bFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NAPI0bFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E76DC4CEF7;
	Tue,  4 Nov 2025 23:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762299555;
	bh=c2Nr95m7zzm8oakKWhuLVMgZIDxsp1O1i3/jRzyNsOY=;
	h=Date:To:From:Subject:From;
	b=NAPI0bFMnIoRg/jgZQCby6Xq5X8eiSRZf2RTmToR6bZROjGu705qalA4AFN1RHNON
	 2apnLVyhwbDfUn+B/RCUdXMYm/8ECWfUxjLfVvXjk0f7txSSIIdxWDbNll04w6ADKA
	 K7qrFDsGQcBiAS+hv4AhMmf5ZhxuTN20vhO4mp9U=
Date: Tue, 04 Nov 2025 15:39:14 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix.patch added to mm-new branch
Message-Id: <20251104233915.4E76DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix.patch

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
Subject: mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix
Date: Tue, 4 Nov 2025 06:16:03 +0000

fix instance of over-zealous const usage in s390

Link: https://lkml.kernel.org/r/4700dcda-13c8-4ba7-aea9-5513c01cc4a2@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/pgtable.c~mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix
+++ a/arch/s390/mm/pgtable.c
@@ -688,7 +688,7 @@ static void ptep_zap_leaf_entry(struct m
 	if (leafent_is_swap(entry))
 		dec_mm_counter(mm, MM_SWAPENTS);
 	else if (leafent_is_migration(entry)) {
-		const struct folio *folio = leafent_to_folio(entry);
+		struct folio *folio = leafent_to_folio(entry);
 
 		dec_mm_counter(mm, mm_counter(folio));
 	}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-vma-remove-unused-function-make-internal-functions-static.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-vma-small-vma-lock-cleanups.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-uses-of-is_swap_pte-when-leafent_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd-fix.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-leafent_from_pte.patch

