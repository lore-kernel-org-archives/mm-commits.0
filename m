Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CE52882DB
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 18:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763750159; cv=none; b=VBxDXLczR011WXzt+CF9SsAzIGGxeNiHcJ3wZcqWb2GdtTrCMUsQrgTs1yWTaXzT6GeOOawiUB1qIXIDoeiTH8NFUXqeRmlDT4laWcEffMpEdROpiCMJLaGXnBtYF32pfXx0qsmQ7TIzIXCEJsuVE9WVKt0ldL1VJWXGixJA9BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763750159; c=relaxed/simple;
	bh=PvOBmSQX2BeNFXhyFhb4vLoJl9ZaoALn4THNlVFEdjU=;
	h=Date:To:From:Subject:Message-Id; b=GZCyIsCZlwIRVXEcl9P0/ofDmysROA0uJN1UNSYe8Qp8Uk4ENlxintjFjUUe48NFrbFAoYdqW9SIYbF2Lnsp48Ep6DTy2k4W9MoYIR47DiKyj2BYVDV+KpQHn3BWkIaujIvMbl2wxrC+cha7V7/adTz/j7XWFsMh7dKU1+FkuQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bmB9sWW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bmB9sWW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB902C4CEF1;
	Fri, 21 Nov 2025 18:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763750159;
	bh=PvOBmSQX2BeNFXhyFhb4vLoJl9ZaoALn4THNlVFEdjU=;
	h=Date:To:From:Subject:From;
	b=bmB9sWW5FZpZ9Zb5dsD1CmN0qXOictUL4CIe3ZEMGS1GmjhvYVmD+98FN8L5L/Vsy
	 3G1ubLYguu9RMCkZUMRNR5U2vqLFAnQcIwqCeur9NX34x8BNMuQ1KZX99h7nPVB3OT
	 C/9HHzET9dWNArETS75VrNQUkqnSkrf5q9y98sGQ=
Date: Fri, 21 Nov 2025 10:35:58 -0800
To: mm-commits@vger.kernel.org,zhangchunyan@iscas.ac.cn,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-softdirty-add-pgtable_supports_soft_dirty-fix.patch added to mm-unstable branch
Message-Id: <20251121183558.EB902C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-softdirty-add-pgtable_supports_soft_dirty-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-softdirty-add-pgtable_supports_soft_dirty-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-softdirty-add-pgtable_supports_soft_dirty-fix.patch

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
Subject: mm-softdirty-add-pgtable_supports_soft_dirty-fix
Date: Fri, 21 Nov 2025 16:55:37 +0000

fix VMA selftests

Link: https://lkml.kernel.org/r/dac6ddfe-773a-43d5-8f69-021b9ca4d24b@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/vma/vma_internal.h~mm-softdirty-add-pgtable_supports_soft_dirty-fix
+++ a/tools/testing/vma/vma_internal.h
@@ -212,6 +212,8 @@ typedef __bitwise unsigned int vm_fault_
 
 #define ASSERT_EXCLUSIVE_WRITER(x)
 
+#define pgtable_supports_soft_dirty() 1
+
 /**
  * swap - swap values of @a and @b
  * @a: first value
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

