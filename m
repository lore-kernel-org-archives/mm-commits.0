Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2F7CA5A
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 21:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770933007; cv=none; b=nMXTESkc90P1fF/+ImxihMb8EKvJAF22047KxksCioxQMACJ3TTLziu5sUW696jNyBENQhmrZQL0uhE3alhwQAAtvH7vPgzOjF39xKPkV3aBaYdudREPZj68yXlK2qeuyS9xqM02Aus3EGUR8k6VlrCpNEGrEahi9P5A7D0IrAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770933007; c=relaxed/simple;
	bh=vujYTD2m8TSFEhvdkc1gz4H0PlpDOtG2Ha8Qh7gAjrA=;
	h=Date:To:From:Subject:Message-Id; b=Ss4YYAIq2Iy32UXNqA8Az/xkOe735ebu5gD7g+eRB9F2WcXZ7EjFJI/XTPyRwCZyWATW2OtS3AhkQpKnyHXp7yDZz0fju/lgbKgBTCsk8TOXTymzudEKOftjVwD5+tzaDdNc9K/w5U/NF1b3Jmlg0MZau8VdF9uhbGHjPsQnunU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dn+Ms79m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dn+Ms79m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B6CC4CEF7;
	Thu, 12 Feb 2026 21:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770933007;
	bh=vujYTD2m8TSFEhvdkc1gz4H0PlpDOtG2Ha8Qh7gAjrA=;
	h=Date:To:From:Subject:From;
	b=dn+Ms79meGbUgpnwe7U35W4XU6CDfz1PJnKKqBCoXSnVViKVAoeLUFZqMWLyp9yLG
	 nj96eFqaCLTkocWVExN4ymBqoim/luRv/jspTVEXsxfO69Y6Mr93L0DIIpHm2Gm9aD
	 EqoyVZ5w3X9LYYz8gxYCzzixc310XKqXRENmanYg=
Date: Thu, 12 Feb 2026 13:50:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-unmap_desc-struct-for-freeing-page-tables-fix.patch removed from -mm tree
Message-Id: <20260212215006.E9B6CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix up unmap desc use on exit_mmap()
has been removed from the -mm tree.  Its filename was
     mm-use-unmap_desc-struct-for-freeing-page-tables-fix.patch

This patch was dropped because it was folded into mm-use-unmap_desc-struct-for-freeing-page-tables.patch

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

