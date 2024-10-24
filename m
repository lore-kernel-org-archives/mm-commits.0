Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E277166F14
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750534; cv=none; b=lHX2OhZ4EltDBhtYUcCJki6xJlZot/0NHMp8z6o7Oen5QLxmZoXjiio0Cy3fbVuwn9O0KMBLWOduBH/i81pKjl4tQtKPNqye2ksOuMBlkUyjgB6jhHikirv9T1N8mUqzIEiIXcF7Ls7R0wbwcFSJSFJg3taRLZ4E97ZJFYm6c8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750534; c=relaxed/simple;
	bh=ks4ViC8g37MlEULINCY3e6ppoQCw0eFyy4teH8A/1rE=;
	h=Date:To:From:Subject:Message-Id; b=XazrViaTlfkm5q7sF3UjYMz2Q+qRjiBWkjUlUk2djO8jIFQvn82URYCSnVaCyie94sX2FLqdzjDICj+HGvaeCmc/+3GnoeXtNR/kNHE6Hx1WiKgfntzuITf749sBqGPm2PBY90BPJcO5GGt60TaAU94qPphvOkWq6LFY6EHKtQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ry+7Guhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ry+7Guhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2601CC4CECC;
	Thu, 24 Oct 2024 06:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750534;
	bh=ks4ViC8g37MlEULINCY3e6ppoQCw0eFyy4teH8A/1rE=;
	h=Date:To:From:Subject:From;
	b=ry+7GuhlKb6cr2vaCGF/qHCgx9V4pctcGdonop7GEUql7vEizpO3lS08OnsUhGnU9
	 +wVOA1VNbIkPhrZsQd2GJAz1wIZkTBAbXeowxlnhW3h7pfGFOkPFwG0mv8yTAC5Olz
	 hl4+vOM3XJAEiWz6NIW6m9jR4sCVX7BM4DzfzNxA=
Date: Wed, 23 Oct 2024 23:15:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,oliver.sang@intel.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch removed from -mm tree
Message-Id: <20241024061534.2601CC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: add expand-only VMA merge mode and optimise do_brk_flags()
has been removed from the -mm tree.  Its filename was
     mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

