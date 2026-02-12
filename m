Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937562C026E
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939823; cv=none; b=AdQBI2J8nJqxMbuybJsgnC47ZSP+d0PMGm9aJDwk3enqqb7KV32Ie3Z7tutYCBq5+y0MBdpVwu4vtD02dJiE5ylSckUSDnWS/wdRSPPUd1eWg4XNwpULKzIVU7sG38+k2iYNBHyl2F17u/Mv7R2iY2k5H1N6KcOi40JmrqlF8x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939823; c=relaxed/simple;
	bh=GFd/pUfxlTLk3I10bKBVR730NRPL8l1VmkKskWG8QCw=;
	h=Date:To:From:Subject:Message-Id; b=RcxOyDBC0fqKjNYHgOmIGjKij/OF24BtFaLvz+Sj0R2pAGfOIkaRxVCY/MdAC0UaQkKPBxWggmEdl5y2BdAS0dZUIlyyHnmW5MD4GbV7F6Qc3JbNDqodYhgBPoSCobPMzr/X2k1gUsTsjmyYF89jZ/FZiPS6K/5Kh9VE7heDL6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W4BgW1BT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W4BgW1BT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281EDC4CEF7;
	Thu, 12 Feb 2026 23:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939823;
	bh=GFd/pUfxlTLk3I10bKBVR730NRPL8l1VmkKskWG8QCw=;
	h=Date:To:From:Subject:From;
	b=W4BgW1BTIHRN7Tg9zU6tEA3bAl3qJQnfpjZhOmSN9e8p2Hs/0LvD3iPCscX6vcu5T
	 e8TXyyN5NJGwGFzvyoEX/C30qRC8g8wg9aG/3tSywfcj4YAJNGiO0nqGOYIc0Aqqgo
	 DhnUyhXccMgy7AlNSPi2nrpCB0aJxLbpmZAwGPc4=
Date: Thu, 12 Feb 2026 15:43:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-add-tree-limit-to-free_pgtables.patch removed from -mm tree
Message-Id: <20260212234343.281EDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: add tree limit to free_pgtables()
has been removed from the -mm tree.  Its filename was
     mm-memory-add-tree-limit-to-free_pgtables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/memory: add tree limit to free_pgtables()
Date: Wed, 21 Jan 2026 11:49:40 -0500

The ceiling and tree search limit need to be different arguments for the
future change in the failed fork attempt.  The ceiling and floor variables
are not very descriptive, so change them to pg_start/pg_end.

Adding a new variable for the vma_end to the function as it will differ
from the pg_end in the later patches in the series.

Add a kernel doc about the free_pgtables() function.

Test code also updated.

No functional changes intended.

Link: https://lkml.kernel.org/r/20260121164946.2093480-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h                    |    6 ++--
 mm/memory.c                      |   42 ++++++++++++++++++++++-------
 mm/mmap.c                        |    2 -
 mm/vma.c                         |    3 +-
 tools/testing/vma/vma_internal.h |    3 +-
 5 files changed, 42 insertions(+), 14 deletions(-)

--- a/mm/internal.h~mm-memory-add-tree-limit-to-free_pgtables
+++ a/mm/internal.h
@@ -510,8 +510,10 @@ void deactivate_file_folio(struct folio
 void folio_activate(struct folio *folio);
 
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *start_vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked);
+		   struct vm_area_struct *vma, unsigned long pg_start,
+		   unsigned long pg_end, unsigned long vma_end,
+		   bool mm_wr_locked);
+
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
 struct zap_details;
--- a/mm/memory.c~mm-memory-add-tree-limit-to-free_pgtables
+++ a/mm/memory.c
@@ -370,23 +370,47 @@ void free_pgd_range(struct mmu_gather *t
 	} while (pgd++, addr = next, addr != end);
 }
 
+/**
+ * free_pgtables() - Free a range of page tables
+ * @tlb: The mmu gather
+ * @mas: The maple state
+ * @vma: The first vma
+ * @pg_start: The lowest page table address (floor)
+ * @pg_end: The highest page table address (ceiling)
+ * @vma_end: The highest vma tree search address
+ * @mm_wr_locked: boolean indicating if the mm is write locked
+ *
+ * Note: pg_start and pg_end are provided to indicate the absolute range of the
+ * page tables that should be removed.  This can differ from the vma mappings on
+ * some archs that may have mappings that need to be removed outside the vmas.
+ * Note that the prev->vm_end and next->vm_start are often used.
+ *
+ * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
+ * unrelated data to the mm_struct being torn down.
+ */
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked)
+		   struct vm_area_struct *vma, unsigned long pg_start,
+		   unsigned long pg_end, unsigned long vma_end,
+		   bool mm_wr_locked)
 {
 	struct unlink_vma_file_batch vb;
 
+	/*
+	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
+	 * may be 0.  Underflow is expected in this case.  Otherwise the
+	 * pagetable end is exclusive.
+	 * vma_end is exclusive.
+	 * The last vma address should never be larger than the pagetable end.
+	 */
+	WARN_ON_ONCE(vma_end - 1 > pg_end - 1);
+
 	tlb_free_vmas(tlb);
 
 	do {
 		unsigned long addr = vma->vm_start;
 		struct vm_area_struct *next;
 
-		/*
-		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
-		 * be 0.  This will underflow and is okay.
-		 */
-		next = mas_find(mas, ceiling - 1);
+		next = mas_find(mas, vma_end - 1);
 		if (unlikely(xa_is_zero(next)))
 			next = NULL;
 
@@ -406,7 +430,7 @@ void free_pgtables(struct mmu_gather *tl
 		 */
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
-			next = mas_find(mas, ceiling - 1);
+			next = mas_find(mas, vma_end - 1);
 			if (unlikely(xa_is_zero(next)))
 				next = NULL;
 			if (mm_wr_locked)
@@ -417,7 +441,7 @@ void free_pgtables(struct mmu_gather *tl
 		unlink_file_vma_batch_final(&vb);
 
 		free_pgd_range(tlb, addr, vma->vm_end,
-			floor, next ? next->vm_start : ceiling);
+			pg_start, next ? next->vm_start : pg_end);
 		vma = next;
 	} while (vma);
 }
--- a/mm/mmap.c~mm-memory-add-tree-limit-to-free_pgtables
+++ a/mm/mmap.c
@@ -1308,7 +1308,7 @@ void exit_mmap(struct mm_struct *mm)
 	mt_clear_in_rcu(&mm->mm_mt);
 	vma_iter_set(&vmi, vma->vm_end);
 	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING, true);
+		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
 	tlb_finish_mmu(&tlb);
 
 	/*
--- a/mm/vma.c~mm-memory-add-tree-limit-to-free_pgtables
+++ a/mm/vma.c
@@ -485,6 +485,7 @@ void unmap_region(struct ma_state *mas,
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
+		      next ? next->vm_start : USER_PGTABLES_CEILING,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
 }
@@ -1275,7 +1276,7 @@ static inline void vms_clear_ptes(struct
 	mas_set(mas_detach, 1);
 	/* start and end may be different if there is no prev or next vma. */
 	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
-		      vms->unmap_end, mm_wr_locked);
+		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 	vms->clear_ptes = false;
 }
--- a/tools/testing/vma/vma_internal.h~mm-memory-add-tree-limit-to-free_pgtables
+++ a/tools/testing/vma/vma_internal.h
@@ -1139,7 +1139,8 @@ static inline void unmap_vmas(struct mmu
 
 static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked)
+		   unsigned long ceiling, unsigned long tree_max,
+		   bool mm_wr_locked)
 {
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

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

