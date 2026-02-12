Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE3B3EBF1B
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939834; cv=none; b=CU5FMAdfnLhzmMUZS0kJ696lCO9p5GyOJP2rc/Iv5cyzcrVRGor4bbMkB7xlg9Ds7xQejhy9EQCtE2EtV94DCsTchhGdWtU+DXXtCED/BbBfa5yEkGsIE84uph54VWW82/y7vwQu09tuRm5oqNb3S1fJMtYCcD4FCQWOcNwcVS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939834; c=relaxed/simple;
	bh=FoSVOLNMU2+cyr16IDfHK1jjWymVN2L8S3p1zcNutpA=;
	h=Date:To:From:Subject:Message-Id; b=PoSBhzXVJpYTDnVgNbpmA8hauoFlij1YkScKQSCDXe8U8Dy8rIrJNUoFHs1cLmBf5Bn6AqDHStWnvXBQ1OyeB8cB3EOW4U9iwX2Ty+EmPnO8yVmgNCvt094oPV45iYpaeWVoa2zUXbJlFkhT32Ewq8XzCkDDtLtx9TqozkYe/wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=my6qGSh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="my6qGSh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1967C4CEF7;
	Thu, 12 Feb 2026 23:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939833;
	bh=FoSVOLNMU2+cyr16IDfHK1jjWymVN2L8S3p1zcNutpA=;
	h=Date:To:From:Subject:From;
	b=my6qGSh01n4Syh1EvfCXEoLiSF2djZMKNVpePNrlxkjphTqga3za/reuEFZoSgydA
	 YLaCfrKjqL+4es1N9UlzCGhMU91AP5GghdEBPyTcTdC7xYWOZN+QkDDXCo/OHh6cEM
	 lj9Zh7ZprdLbS1Otx1Ljofou4T87mUm0gEwpg7v8=
Date: Thu, 12 Feb 2026 15:43:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-unmap_desc-struct-for-freeing-page-tables.patch removed from -mm tree
Message-Id: <20260212234353.B1967C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use unmap_desc struct for freeing page tables
has been removed from the -mm tree.  Its filename was
     mm-use-unmap_desc-struct-for-freeing-page-tables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: use unmap_desc struct for freeing page tables
Date: Wed, 21 Jan 2026 11:49:46 -0500

Pass through the unmap_desc to free_pgtables() because it almost has
everything necessary and is already on the stack.

Updates testing code as necessary.

No functional changes intended.

[Liam.Howlett@oracle.com: fix up unmap desc use on exit_mmap()]
  Link: https://lkml.kernel.org/r/20260210214214.364856-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20260121164946.2093480-12-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
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
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h                    |    5 ----
 mm/memory.c                      |   33 +++++++++++------------------
 mm/mmap.c                        |    6 ++---
 mm/vma.c                         |    6 +----
 mm/vma.h                         |   23 ++++++++++++++++++++
 tools/testing/vma/vma_internal.h |    7 ++----
 6 files changed, 45 insertions(+), 35 deletions(-)

--- a/mm/internal.h~mm-use-unmap_desc-struct-for-freeing-page-tables
+++ a/mm/internal.h
@@ -512,10 +512,7 @@ bool __folio_end_writeback(struct folio
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
-void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long pg_start,
-		   unsigned long pg_end, unsigned long vma_end,
-		   bool mm_wr_locked);
+void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
 
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
--- a/mm/memory.c~mm-use-unmap_desc-struct-for-freeing-page-tables
+++ a/mm/memory.c
@@ -373,12 +373,7 @@ void free_pgd_range(struct mmu_gather *t
 /**
  * free_pgtables() - Free a range of page tables
  * @tlb: The mmu gather
- * @mas: The maple state
- * @vma: The first vma
- * @pg_start: The lowest page table address (floor)
- * @pg_end: The highest page table address (ceiling)
- * @vma_end: The highest vma tree search address
- * @mm_wr_locked: boolean indicating if the mm is write locked
+ * @unmap: The unmap_desc
  *
  * Note: pg_start and pg_end are provided to indicate the absolute range of the
  * page tables that should be removed.  This can differ from the vma mappings on
@@ -388,21 +383,19 @@ void free_pgd_range(struct mmu_gather *t
  * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
  * unrelated data to the mm_struct being torn down.
  */
-void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long pg_start,
-		   unsigned long pg_end, unsigned long vma_end,
-		   bool mm_wr_locked)
+void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
 	struct unlink_vma_file_batch vb;
+	struct ma_state *mas = unmap->mas;
+	struct vm_area_struct *vma = unmap->first;
 
 	/*
 	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
 	 * may be 0.  Underflow is expected in this case.  Otherwise the
-	 * pagetable end is exclusive.
-	 * vma_end is exclusive.
-	 * The last vma address should never be larger than the pagetable end.
+	 * pagetable end is exclusive.  vma_end is exclusive.  The last vma
+	 * address should never be larger than the pagetable end.
 	 */
-	WARN_ON_ONCE(vma_end - 1 > pg_end - 1);
+	WARN_ON_ONCE(unmap->vma_end - 1 > unmap->pg_end - 1);
 
 	tlb_free_vmas(tlb);
 
@@ -410,13 +403,13 @@ void free_pgtables(struct mmu_gather *tl
 		unsigned long addr = vma->vm_start;
 		struct vm_area_struct *next;
 
-		next = mas_find(mas, vma_end - 1);
+		next = mas_find(mas, unmap->tree_end - 1);
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
 		 * pgtables
 		 */
-		if (mm_wr_locked)
+		if (unmap->mm_wr_locked)
 			vma_start_write(vma);
 		unlink_anon_vmas(vma);
 
@@ -428,16 +421,16 @@ void free_pgtables(struct mmu_gather *tl
 		 */
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
-			next = mas_find(mas, vma_end - 1);
-			if (mm_wr_locked)
+			next = mas_find(mas, unmap->tree_end - 1);
+			if (unmap->mm_wr_locked)
 				vma_start_write(vma);
 			unlink_anon_vmas(vma);
 			unlink_file_vma_batch_add(&vb, vma);
 		}
 		unlink_file_vma_batch_final(&vb);
 
-		free_pgd_range(tlb, addr, vma->vm_end,
-			pg_start, next ? next->vm_start : pg_end);
+		free_pgd_range(tlb, addr, vma->vm_end, unmap->pg_start,
+			       next ? next->vm_start : unmap->pg_end);
 		vma = next;
 	} while (vma);
 }
--- a/mm/mmap.c~mm-use-unmap_desc-struct-for-freeing-page-tables
+++ a/mm/mmap.c
@@ -1307,10 +1307,10 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	mm_flags_set(MMF_OOM_SKIP, mm);
 	mmap_write_lock(mm);
+	unmap.mm_wr_locked = true;
 	mt_clear_in_rcu(&mm->mm_mt);
-	vma_iter_set(&vmi, vma->vm_end);
-	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
+	unmap_pgtable_init(&unmap, &vmi);
+	free_pgtables(&tlb, &unmap);
 	tlb_finish_mmu(&tlb);
 
 	/*
--- a/mm/vma.c~mm-use-unmap_desc-struct-for-freeing-page-tables
+++ a/mm/vma.c
@@ -475,15 +475,13 @@ void remove_vma(struct vm_area_struct *v
 void unmap_region(struct unmap_desc *unmap)
 {
 	struct mm_struct *mm = unmap->first->vm_mm;
-	struct ma_state *mas = unmap->mas;
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, unmap);
-	mas_set(mas, unmap->tree_reset);
-	free_pgtables(&tlb, mas, unmap->first, unmap->pg_start, unmap->pg_end,
-		      unmap->tree_end, unmap->mm_wr_locked);
+	mas_set(unmap->mas, unmap->tree_reset);
+	free_pgtables(&tlb, unmap);
 	tlb_finish_mmu(&tlb);
 }
 
--- a/mm/vma.h~mm-use-unmap_desc-struct-for-freeing-page-tables
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
--- a/tools/testing/vma/vma_internal.h~mm-use-unmap_desc-struct-for-freeing-page-tables
+++ a/tools/testing/vma/vma_internal.h
@@ -1137,11 +1137,10 @@ static inline void unmap_vmas(struct mmu
 {
 }
 
-static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, unsigned long tree_max,
-		   bool mm_wr_locked)
+static inline void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc)
 {
+	(void)tlb;
+	(void)desc;
 }
 
 static inline void mapping_unmap_writable(struct address_space *mapping)
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

