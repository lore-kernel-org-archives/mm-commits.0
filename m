Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4930176FA7
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729200421; cv=none; b=a9cbwQPKIV+iBPp//c610vJF2/LxzuHQtEo7NkzFyWsJ27Ylax5X+wqMiuIfn08xgbnhbVmvIAb3bm1LpQsVwvqD3kGviR2QBAsUdLDb8Lgy5CozgjtYb61beKcRmacxeQ+lF+r4eH0DxlxRDNnh0F2ark+UdyPr8Mi6YFnAY3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729200421; c=relaxed/simple;
	bh=hh2aPz1aIR+TRrt45yCtzSKBO/LPN7Q/ImtGbUcMY50=;
	h=Date:To:From:Subject:Message-Id; b=U46vjHaNMZdGLQ4jhZmbFwcr9+h03RE0VSbivqMzzo6M5V0Xf0orcRH5YhhJTZpQMQ4Mzz4hYCiGdXDZ5ax3McTJggk7eAiIivvXvymoFT1Ljey7mhcoeKiR2iXN5qPSdo9jDnvrln6OZ5Hf+yEMYYZzIM6oMJKay/GLWYRukkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yrZh/3R9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yrZh/3R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4098AC4CEC5;
	Thu, 17 Oct 2024 21:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729200421;
	bh=hh2aPz1aIR+TRrt45yCtzSKBO/LPN7Q/ImtGbUcMY50=;
	h=Date:To:From:Subject:From;
	b=yrZh/3R9xSqXV6SSUIuFxbMJNilR+e7c0ykJ4OyMWv0fmlyXhSyWdgADgPmmWBMQ9
	 Md7spQtOxW/pPESC7eV8Q8qGskIHQ7EENeNbughUcVL8nP5tWaAAy2ev2smLZxqU/r
	 6QOXHZgZvxRJxFXaC7Ms9dnL2sHRs7BOyGShEXGc=
Date: Thu, 17 Oct 2024 14:27:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,oliver.sang@intel.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch added to mm-hotfixes-unstable branch
Message-Id: <20241017212701.4098AC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: add expand-only VMA merge mode and optimise do_brk_flags()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/vma: add expand-only VMA merge mode and optimise do_brk_flags()
Date: Thu, 17 Oct 2024 15:31:45 +0100

Patch series "introduce VMA merge mode to improve brk() performance".

A ~5% performance regression was discovered on the
aim9.brk_test.ops_per_sec by the linux kernel test bot [0].

In the past to satisfy brk() performance we duplicated VMA expansion code
and special-cased do_brk_flags().  This is however horrid and undoes work
to abstract this logic, so in resolving the issue I have endeavoured to
avoid this.

Investigating further I was able to observe that the use of a
vma_iter_next_range() and vma_prev() pair, causing an unnecessary maple
tree walk.  In addition there is work that we do that is simply
unnecessary for brk().

Therefore, add a special VMA merge mode VMG_FLAG_JUST_EXPAND to avoid
doing any of this - it assumes the VMA iterator is pointing at the
previous VMA and which skips logic that brk() does not require.

This mostly eliminates the performance regression reducing it to ~2% which
is in the realm of noise.  In addition, the will-it-scale test brk2,
written to be more representative of real-world brk() usage, shows a
modest performance improvement - which gives me confidence that we are not
meaningfully regressing real workloads here.

This series includes a test asserting that the 'just expand' mode works as
expected.

With many thanks to Oliver Sang for helping with performance testing of
candidate patch sets!

[0]:https://lore.kernel.org/linux-mm/202409301043.629bea78-oliver.sang@intel.com


This patch (of 2):

We know in advance that do_brk_flags() wants only to perform a VMA
expansion (if the prior VMA is compatible), and that we assume no
mergeable VMA follows it.

These are the semantics of this function prior to the recent rewrite of
the VMA merging logic, however we are now doing more work than necessary -
positioning the VMA iterator at the prior VMA and performing tasks that
are not required.

Add a new field to the vmg struct to permit merge flags and add a new
merge flag VMG_FLAG_JUST_EXPAND which implies this behaviour, and have
do_brk_flags() use this.

This fixes a reported performance regression in a brk() benchmarking suite.

Link: https://lkml.kernel.org/r/cover.1729174352.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/4e65d4395e5841c5acf8470dbcb714016364fd39.1729174352.git.lorenzo.stoakes@oracle.com
Fixes: cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/linux-mm/202409301043.629bea78-oliver.sang@intel.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 mm/vma.c  |   23 +++++++++++++++--------
 mm/vma.h  |   14 ++++++++++++++
 3 files changed, 31 insertions(+), 9 deletions(-)

--- a/mm/mmap.c~mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags
+++ a/mm/mmap.c
@@ -1756,7 +1756,8 @@ static int do_brk_flags(struct vma_itera
 		VMG_STATE(vmg, mm, vmi, addr, addr + len, flags, PHYS_PFN(addr));
 
 		vmg.prev = vma;
-		vma_iter_next_range(vmi);
+		/* vmi is positioned at prev, which this mode expects. */
+		vmg.merge_flags = VMG_FLAG_JUST_EXPAND;
 
 		if (vma_merge_new_range(&vmg))
 			goto out;
--- a/mm/vma.c~mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags
+++ a/mm/vma.c
@@ -917,6 +917,7 @@ struct vm_area_struct *vma_merge_new_ran
 	pgoff_t pgoff = vmg->pgoff;
 	pgoff_t pglen = PHYS_PFN(end - start);
 	bool can_merge_left, can_merge_right;
+	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
 
 	mmap_assert_write_locked(vmg->mm);
 	VM_WARN_ON(vmg->vma);
@@ -930,7 +931,7 @@ struct vm_area_struct *vma_merge_new_ran
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
-	can_merge_right = can_vma_merge_right(vmg, can_merge_left);
+	can_merge_right = !just_expand && can_vma_merge_right(vmg, can_merge_left);
 
 	/* If we can merge with the next VMA, adjust vmg accordingly. */
 	if (can_merge_right) {
@@ -953,7 +954,11 @@ struct vm_area_struct *vma_merge_new_ran
 		if (can_merge_right && !can_merge_remove_vma(next))
 			vmg->end = end;
 
-		vma_prev(vmg->vmi); /* Equivalent to going to the previous range */
+		/* In expand-only case we are already positioned at prev. */
+		if (!just_expand) {
+			/* Equivalent to going to the previous range. */
+			vma_prev(vmg->vmi);
+		}
 	}
 
 	/*
@@ -967,12 +972,14 @@ struct vm_area_struct *vma_merge_new_ran
 	}
 
 	/* If expansion failed, reset state. Allows us to retry merge later. */
-	vmg->vma = NULL;
-	vmg->start = start;
-	vmg->end = end;
-	vmg->pgoff = pgoff;
-	if (vmg->vma == prev)
-		vma_iter_set(vmg->vmi, start);
+	if (!just_expand) {
+		vmg->vma = NULL;
+		vmg->start = start;
+		vmg->end = end;
+		vmg->pgoff = pgoff;
+		if (vmg->vma == prev)
+			vma_iter_set(vmg->vmi, start);
+	}
 
 	return NULL;
 }
--- a/mm/vma.h~mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags
+++ a/mm/vma.h
@@ -59,6 +59,17 @@ enum vma_merge_state {
 	VMA_MERGE_SUCCESS,
 };
 
+enum vma_merge_flags {
+	VMG_FLAG_DEFAULT = 0,
+	/*
+	 * If we can expand, simply do so. We know there is nothing to merge to
+	 * the right. Does not reset state upon failure to merge. The VMA
+	 * iterator is assumed to be positioned at the previous VMA, rather than
+	 * at the gap.
+	 */
+	VMG_FLAG_JUST_EXPAND = 1 << 0,
+};
+
 /* Represents a VMA merge operation. */
 struct vma_merge_struct {
 	struct mm_struct *mm;
@@ -75,6 +86,7 @@ struct vma_merge_struct {
 	struct mempolicy *policy;
 	struct vm_userfaultfd_ctx uffd_ctx;
 	struct anon_vma_name *anon_name;
+	enum vma_merge_flags merge_flags;
 	enum vma_merge_state state;
 };
 
@@ -99,6 +111,7 @@ static inline pgoff_t vma_pgoff_offset(s
 		.flags = flags_,					\
 		.pgoff = pgoff_,					\
 		.state = VMA_MERGE_START,				\
+		.merge_flags = VMG_FLAG_DEFAULT,			\
 	}
 
 #define VMG_VMA_STATE(name, vmi_, prev_, vma_, start_, end_)	\
@@ -118,6 +131,7 @@ static inline pgoff_t vma_pgoff_offset(s
 		.uffd_ctx = vma_->vm_userfaultfd_ctx,		\
 		.anon_name = anon_vma_name(vma_),		\
 		.state = VMA_MERGE_START,			\
+		.merge_flags = VMG_FLAG_DEFAULT,		\
 	}
 
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch
tools-testing-add-expand-only-mode-vma-test.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

