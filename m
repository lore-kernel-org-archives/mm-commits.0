Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A52B33AD8B
	for <mm-commits@vger.kernel.org>; Tue, 10 Feb 2026 23:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770767699; cv=none; b=bhX9Jzz1NJf1ZlQ3GHX3hkJqrjseI/sD2j+t7CIsNi+joTSpaNnpf0dz/3vPc9keOJeEM7YgFA/mqI60DAx3XHmgE3p/Nz+K1wE+9TPt+xxrYMnZpHaWZxyGBVjWDqLG8kgTOW7MeQf2CazTTbSTqYauj+ur5e/gMpJ1yuDfjKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770767699; c=relaxed/simple;
	bh=SfRkAyDXEykmaanVwRpVcyfeqEnQNthES2wXLo1da2s=;
	h=Date:To:From:Subject:Message-Id; b=hTiFyPQH5etx213EXcgXU8kD15LByyJ8nRz56WI79kD+lz2y8gjeM4y057KEE6sOg0zXaCjfv8YqTRUGkrAZ/kS7Hamju8YDSziyp/c73rEbxFY7nuYdJL/B4qjRcJh8KUMFswkLJh0qmCcTHHQzJGorA5/TKr/sqSxXah6ShsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q37axIUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q37axIUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED62CC116C6;
	Tue, 10 Feb 2026 23:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770767699;
	bh=SfRkAyDXEykmaanVwRpVcyfeqEnQNthES2wXLo1da2s=;
	h=Date:To:From:Subject:From;
	b=Q37axIUUlEQsTc9QvQpxpBD2CQyBOi5s+Nza8d0+9TprUpPxoVpRP/CbKtXFSajvn
	 PqTpQ6vwNDlAaTXADAwfHtXWBkCYx0tJ0IN/tWQn2oCYnd78wculKoQHO/d3Zeqr6m
	 Mmw2ukzqHFqvwDuAOuk+kS0lGcqxAk30jYFF6YCA=
Date: Tue, 10 Feb 2026 15:54:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-unmap_desc-struct-for-freeing-page-tables-fix.patch added to mm-unstable branch
Message-Id: <20260210235458.ED62CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix up unmap desc use on exit_mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-unmap_desc-struct-for-freeing-page-tables-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-unmap_desc-struct-for-freeing-page-tables-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: fix up unmap desc use on exit_mmap()
Date: Tue, 10 Feb 2026 16:42:14 -0500

On exiting mmap, the page table vma limit was set to 0 - ULONG_MAX.  These
setting will trigger the WARN_ON_ONCE() because the vma end will be larger
than the page table end (which is set to TASK_SIZE, in this case).

Adding an unmap_pgtable_init() to initialize the vma range to the user
address limits, as was being used before, will avoid the triggering of the
WARN_ON_ONCE() in free_pgtables().

Comments have been added to the unmap_pgtable_init() in regards to the arm
arch behaviour surrounding the vmas.

Link: https://lkml.kernel.org/r/20260210214214.364856-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++-----
 mm/mmap.c   |    2 +-
 mm/vma.h    |   23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-use-unmap_desc-struct-for-freeing-page-tables-fix
+++ a/mm/memory.c
@@ -391,11 +391,9 @@ void free_pgtables(struct mmu_gather *tl
 
 	/*
 	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
-	 * may be 0.  The underflow here is fine and expected.
-	 * The vma_end is exclusive, which is fine until we use the mas_ instead
-	 * of the vma iterators.
-	 * For freeing the page tables to make sense, the vma_end must be larger
-	 * than the pg_end, so check that after the potential underflow.
+	 * may be 0.  Underflow is expected in this case.  Otherwise the
+	 * pagetable end is exclusive.  vma_end is exclusive.  The last vma
+	 * address should never be larger than the pagetable end.
 	 */
 	WARN_ON_ONCE(unmap->vma_end - 1 > unmap->pg_end - 1);
 
--- a/mm/mmap.c~mm-use-unmap_desc-struct-for-freeing-page-tables-fix
+++ a/mm/mmap.c
@@ -1309,7 +1309,7 @@ void exit_mmap(struct mm_struct *mm)
 	mmap_write_lock(mm);
 	unmap.mm_wr_locked = true;
 	mt_clear_in_rcu(&mm->mm_mt);
-	vma_iter_set(&vmi, unmap.tree_reset);
+	unmap_pgtable_init(&unmap, &vmi);
 	free_pgtables(&tlb, &unmap);
 	tlb_finish_mmu(&tlb);
 
--- a/mm/vma.h~mm-use-unmap_desc-struct-for-freeing-page-tables-fix
+++ a/mm/vma.h
@@ -167,6 +167,10 @@ struct unmap_desc {
 	bool mm_wr_locked;            /* If the mmap write lock is held */
 };
 
+/*
+ * unmap_all_init() - Initialize unmap_desc to remove all vmas, point the
+ * pg_start and pg_end to a safe location.
+ */
 static inline void unmap_all_init(struct unmap_desc *unmap,
 		struct vma_iterator *vmi, struct vm_area_struct *vma)
 {
@@ -181,6 +185,25 @@ static inline void unmap_all_init(struct
 	unmap->mm_wr_locked = false;
 }
 
+/*
+ * unmap_pgtable_init() - Initialize unmap_desc to remove all page tables within
+ * the user range.
+ *
+ * ARM can have mappings outside of vmas.
+ * See: e2cdef8c847b4 ("[PATCH] freepgt: free_pgtables from FIRST_USER_ADDRESS")
+ *
+ * ARM LPAE uses page table mappings beyond the USER_PGTABLES_CEILING
+ * See: CONFIG_ARM_LPAE in arch/arm/include/asm/pgtable.h
+ */
+static inline void unmap_pgtable_init(struct unmap_desc *unmap,
+				      struct vma_iterator *vmi)
+{
+	vma_iter_set(vmi, unmap->tree_reset);
+	unmap->vma_start = FIRST_USER_ADDRESS;
+	unmap->vma_end = USER_PGTABLES_CEILING;
+	unmap->tree_end = USER_PGTABLES_CEILING;
+}
+
 #define UNMAP_STATE(name, _vmi, _vma, _vma_start, _vma_end, _prev, _next)      \
 	struct unmap_desc name = {                                             \
 		.mas = &(_vmi)->mas,                                           \
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-relocate-the-page-table-ceiling-and-floor-definitions.patch
mm-mmap-move-exit_mmap-trace-point.patch
mm-mmap-abstract-vma-clean-up-from-exit_mmap.patch
mm-vma-add-limits-to-unmap_region-for-vmas.patch
mm-memory-add-tree-limit-to-free_pgtables.patch
mm-vma-add-page-table-limit-to-unmap_region.patch
mm-change-dup_mmap-recovery.patch
mm-introduce-unmap_desc-struct-to-reduce-function-arguments.patch
mm-vma-use-unmap_desc-in-exit_mmap-and-vms_clear_ptes.patch
mm-vma-use-unmap_region-in-vms_clear_ptes.patch
mm-use-unmap_desc-struct-for-freeing-page-tables.patch
mm-use-unmap_desc-struct-for-freeing-page-tables-fix.patch
maple_tree-fix-mas_dup_alloc-sparse-warning.patch
maple_tree-move-mas_spanning_rebalance-loop-to-function.patch
maple_tree-extract-use-of-big-node-from-mas_wr_spanning_store.patch
maple_tree-remove-unnecessary-assignment-of-orig_l-index.patch
maple_tree-inline-mas_spanning_rebalance-into-mas_wr_spanning_rebalance.patch
maple_tree-make-ma_wr_states-reliable-for-reuse-in-spanning-store.patch
maple_tree-remove-l_wr_mas-from-mas_wr_spanning_rebalance.patch
maple_tree-dont-pass-through-height-in-mas_wr_spanning_store.patch
maple_tree-move-maple_subtree_state-from-mas_wr_spanning_store-to-mas_wr_spanning_rebalance.patch
maple_tree-correct-right-ma_wr_state-end-pivot-in-mas_wr_spanning_store.patch
maple_tree-introduce-maple_copy-node-and-use-it-in-mas_spanning_rebalance.patch
maple_tree-testing-update-for-spanning-store.patch
maple_tree-inline-mas_spanning_rebalance_loop-into-mas_wr_spanning_rebalance.patch
maple_tree-change-initial-big-node-setup-in-mas_wr_spanning_rebalance.patch
maple_tree-introduce-ma_leaf_max_gap.patch
maple_tree-add-gap-support-slot-and-pivot-sizes-for-maple-copy.patch
maple_tree-start-using-maple-copy-node-for-destination.patch
maple_tree-inline-mas_wr_spanning_rebalance.patch
maple_tree-remove-unnecessary-return-statements.patch
maple_tree-separate-wr_split_store-and-wr_rebalance-store-type-code-path.patch
maple_tree-add-cp_is_new_root-helper.patch
maple_tree-add-cp_is_new_root-helper-fix.patch
maple_tree-use-maple-copy-node-for-mas_wr_rebalance-operation.patch
maple_tree-add-test-for-rebalance-calculation-off-by-one.patch
maple_tree-add-copy_tree_location-helper.patch
maple_tree-add-cp_converged-helper.patch
maple_tree-use-maple-copy-node-for-mas_wr_split.patch
maple_tree-remove-maple-big-node-and-subtree-structs.patch
maple_tree-pass-maple-copy-node-to-mas_wmb_replace.patch
maple_tree-dont-pass-end-to-mas_wr_append.patch
maple_tree-clean-up-mas_wr_node_store.patch

