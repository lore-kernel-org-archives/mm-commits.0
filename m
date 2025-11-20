Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AB22DC765
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763654045; cv=none; b=QQFgzD23hakrkahJZvcPGKjL4SII/yOdmobNeRZ9FY3HWcOwA5bKpbHucrKBBPPi1XwSM6wMsXTWSyn1ZDS7dDOBqZ7cG9TgDAxlzBe2hPAVJ3tCAv9AlvCX1mJn2V9EdwpDPH7yO9/3Abn3Va1hvdHivVLgDI50zY2eRKnPcgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763654045; c=relaxed/simple;
	bh=qqH30mOgqHhs9f66ZdG13WKAXxDNUqdKaTcbwhVpmDw=;
	h=Date:To:From:Subject:Message-Id; b=RoDlM2rLnS3zFGGbBfzVu/sH6/h4KfOBuKs+u1XCuBSXZs0Dm7lysv9Wk+6kr4N7EMtkF7FMuN0nU7PoPdb+uHg5iMefw0b5as/geB7fcNyGjxayzl5Re4pTARZlZmFQxMS2/OuikBZZ1HFFAY1Yznt2ytaMNS7kt60xXl019mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ABgn7R1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ABgn7R1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14348C4CEF1;
	Thu, 20 Nov 2025 15:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763654045;
	bh=qqH30mOgqHhs9f66ZdG13WKAXxDNUqdKaTcbwhVpmDw=;
	h=Date:To:From:Subject:From;
	b=ABgn7R1ovG6dqp79uiMykVBq70HYEXs+wYeZUfIafKx3UOZpzwicTOCkDKNvB3xPZ
	 p14VC9JJhR+5VGWHp8zH6iOF+ZrRyo8pPlzaMWPItKCwtdU8XhdqnNPiw7+rwV8Fvb
	 +lu932tYN9yk1tn/vbu1+sfloeEN17LovAjwpsoA=
Date: Thu, 20 Nov 2025 07:54:04 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-declare-vma-flags-by-bit-fix-3.patch added to mm-unstable branch
Message-Id: <20251120155405.14348C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-declare-vma-flags-by-bit-fix-3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-declare-vma-flags-by-bit-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-declare-vma-flags-by-bit-fix-3.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-propagate-vm_softdirty-on-merge.patch
testing-selftests-mm-add-soft-dirty-merge-self-test.patch
mm-declare-vma-flags-by-bit.patch
mm-declare-vma-flags-by-bit-fix.patch
mm-declare-vma-flags-by-bit-fix-2.patch
mm-declare-vma-flags-by-bit-fix-3.patch
mm-simplify-and-rename-mm-flags-function-for-clarity.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch
mm-introduce-vma-flags-bitmap-type.patch

