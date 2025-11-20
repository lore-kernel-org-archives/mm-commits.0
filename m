Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538282698AF
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763674797; cv=none; b=ABvLNntkgU9Lw48YbdrMdFQfKufB6g0RIw0QybA1qL8jxlsj9nIvvv3/EzuYyk5RhOTKdEATLExbC5f/JqEoJByGKG6VbLSOBmOpjfEeTHhixRqs6T/wCQepuqKX5EjCsTnCpn9bfHq2x3WGzgT5Afn69ZhWyiH8a59WfnLwGx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763674797; c=relaxed/simple;
	bh=RW6kyhfe4JTAaSKWYOXhuc+y/10InqWSaLdsa6/sqRU=;
	h=Date:To:From:Subject:Message-Id; b=NQpPh0lj1Pi573XNW0iwOPpJHt1+qxCK6/VZNeUHMlKNK1BK6tjo7b4upFenS7nJzWhqOhX5lo8gjX7H6EfkF7UWfCvzT3Ba1jB2SOW/wO8sNASuDsMohllS4cMMV/rP1ZKuKHkPh4CEA5g+cZg2aB3TpDi/Y2WWHLDrI7JdifY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PglLkaKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PglLkaKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D92FC4CEF1;
	Thu, 20 Nov 2025 21:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763674797;
	bh=RW6kyhfe4JTAaSKWYOXhuc+y/10InqWSaLdsa6/sqRU=;
	h=Date:To:From:Subject:From;
	b=PglLkaKu+uztsVRPdkeJ6gQaS4ysHkAYsmQoZe2j0xgSVgHP1Xh3+IVaGnSDhGlkk
	 8+AgOHRvLjcRN+0qT75hp0CrEZr7XvaOjzMlm6uc9suxuME8HSOUr5YsjCMGEdkgGJ
	 qSz0+a3+4lcUoRiQkMaFFcjQ2RAUCMSugr0WhiLs=
Date: Thu, 20 Nov 2025 13:39:56 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-declare-vma-flags-by-bit-fix-3.patch removed from -mm tree
Message-Id: <20251120213957.1D92FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-declare-vma-flags-by-bit-fix-3
has been removed from the -mm tree.  Its filename was
     mm-declare-vma-flags-by-bit-fix-3.patch

This patch was dropped because it was folded into mm-declare-vma-flags-by-bit.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-declare-vma-flags-by-bit-fix-3
Date: Thu, 20 Nov 2025 14:23:13 +0000

fix parisc build

Link: https://lkml.kernel.org/r/ad8ce21f-7be8-4d9b-be49-d71010e92055@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/mm.h~mm-declare-vma-flags-by-bit-fix-3
+++ a/include/linux/mm.h
@@ -529,14 +529,6 @@ enum {
 
 #define VM_STARTGAP_FLAGS (VM_GROWSDOWN | VM_SHADOW_STACK)
 
-
-
-#ifdef CONFIG_STACK_GROWSUP
-#define VM_STACK_EARLY	VMA_BIT(VMA_STACK_EARLY_BIT)
-#else
-#define VM_STACK_EARLY	VM_NONE
-#endif
-
 #ifdef CONFIG_MSEAL_SYSTEM_MAPPINGS
 #define VM_SEALED_SYSMAP	VM_SEALED
 #else
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-update-vma_modify_flags-to-handle-residual-flags-document.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-propagate-vm_softdirty-on-merge.patch
testing-selftests-mm-add-soft-dirty-merge-self-test.patch
mm-declare-vma-flags-by-bit.patch
mm-simplify-and-rename-mm-flags-function-for-clarity.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch
mm-introduce-vma-flags-bitmap-type.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch

