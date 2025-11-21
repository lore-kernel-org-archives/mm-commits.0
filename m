Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909D727B32D
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 18:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763750663; cv=none; b=dzayXk18Z8jp4fnBRKEHHI/stJ8Q8tb4GA8FlTne4SQ39w0y7NSaAZW8ffe1wld058Ll35r0/4oue1BLLn27aGLQG/3BL+1GQf0UJ1pm9PGIaw0wFOL9sFft2JpTBu4T+V+juIDcHbTTpfj28fq6UOpRzynC0tal0Kts8es4UIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763750663; c=relaxed/simple;
	bh=KDQUCnmiOvPisA4ZJJVu1Jj0oA7MM40C6xtz/98EYYQ=;
	h=Date:To:From:Subject:Message-Id; b=JPdwYgs/utrRjszRclHbhZ68338aszSeU/AQ+DyPEheDp5IXbq7D5WpnyagYP14qIAGyCDcTKZixjP+QkkhG84LeD9SSST7uc5/7ddxgT4tUKuDTEOJPjsUFEUKEZnOkytv8YyJXVZLyW//e12oP6V73udhSV23LhyegSbSoSX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ftPPSvSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ftPPSvSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1118FC4CEF1;
	Fri, 21 Nov 2025 18:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763750663;
	bh=KDQUCnmiOvPisA4ZJJVu1Jj0oA7MM40C6xtz/98EYYQ=;
	h=Date:To:From:Subject:From;
	b=ftPPSvSEZhV+Chok+zFx88t4beRYTH7+7HPhMtrQWkiN9CxXGGMEQPv4r4YRtme2Z
	 oo3VSU2xPnSEm7sJKuec5vREkg6Bery1Q6bep7zXT2LsrUWVYq13N1ok3thhum1JYQ
	 zhdxxss8Uhxpp3ff5DiaT/Ei5J4xuflpuN6b/g9o=
Date: Fri, 21 Nov 2025 10:44:22 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch added to mm-unstable branch
Message-Id: <20251121184423.1118FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: add missing stub
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch

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
Subject: tools/testing/vma: add missing stub
Date: Fri, 21 Nov 2025 17:25:18 +0000

vm_flags_reset() is not available in the userland VMA tests, so add a stub
which const-casts vma->vm_flags and avoids the upcoming removal of the
vma->__vm_flags field.

Link: https://lkml.kernel.org/r/4aff8bf7-d367-4ba3-90ad-13eef7a063fa@lucifer.local
Fixes: c5c67c1de357 ("tools/testing/vma: eliminate dependency on vma->__vm_flags")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/vma/vma_internal.h~tools-testing-vma-eliminate-dependency-on-vma-__vm_flags
+++ a/tools/testing/vma/vma_internal.h
@@ -1549,4 +1549,11 @@ static inline int do_munmap(struct mm_st
 	return 0;
 }
 
+static inline void vm_flags_reset(struct vm_area_struct *vma, vm_flags_t flags)
+{
+	vm_flags_t *dst = (vm_flags_t *)(&vma->vm_flags);
+
+	*dst = flags;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

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
mm-softdirty-add-pgtable_supports_soft_dirty-fix.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch

