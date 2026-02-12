Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BAF3EBF1B
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939825; cv=none; b=MMg/SKsHmJBPbxMtBEnYMQeqkkmOir4lL5Ha+rM0rLLjRI3f6groSEYwawGUraPriFx4YsZL4IkgLOQI6dlOELqb/FVFBmK6SvaWuGfdu1toAihFxwtIx8RNEwdDex2sqIbYxEaZgrYKwW2T7bYcNAiUBl+BKl7OJ1Wz25ADVfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939825; c=relaxed/simple;
	bh=tlJtt47w7mjmCinVGQIE1pQUJRybnhmrJbfvmKmKL4g=;
	h=Date:To:From:Subject:Message-Id; b=MAQE+2bUL1OqmpXjiL7oUBqem2YKUir1Wuj6uQz5xWOEEAMrLAzWMGfwV563+yf9Tgs/uKDOagkokJ3JLOIxK/oJVxAH3tDMvQATK0Ln+mTHsZptNSKL98LhHAt/FwmMQ/BFWhcw8AX+wMTOeejJrPXSzXhxiIH2yQ1QGwdhd34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q8Ir09SH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q8Ir09SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E321FC4CEF7;
	Thu, 12 Feb 2026 23:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939825;
	bh=tlJtt47w7mjmCinVGQIE1pQUJRybnhmrJbfvmKmKL4g=;
	h=Date:To:From:Subject:From;
	b=q8Ir09SHW1ZDS++A9RBycQMMQmOPerb8VAD1/Quf+EJe/qMo8quly7JthSm4NUTSe
	 qBGVOIXhqnZ1U0Si8/V2f1RiTAecN+QJiuDNw57QaBf48YUxoAMX91MZf5XfnedMbA
	 7x2sk0LTrqfZWQ4Fe9Am4gH7PoFwuPvLqEGcZlhU=
Date: Thu, 12 Feb 2026 15:43:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-add-page-table-limit-to-unmap_region.patch removed from -mm tree
Message-Id: <20260212234344.E321FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: add page table limit to unmap_region()
has been removed from the -mm tree.  Its filename was
     mm-vma-add-page-table-limit-to-unmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/vma: add page table limit to unmap_region()
Date: Wed, 21 Jan 2026 11:49:41 -0500

The unmap_region() calls need to pass through the page table limit for a
future patch.

No functional changes intended.

Link: https://lkml.kernel.org/r/20260121164946.2093480-7-Liam.Howlett@oracle.com
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

 mm/vma.c |    7 ++++---
 mm/vma.h |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/mm/vma.c~mm-vma-add-page-table-limit-to-unmap_region
+++ a/mm/vma.c
@@ -474,7 +474,8 @@ void remove_vma(struct vm_area_struct *v
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		unsigned long vma_start, unsigned long vma_end,
-		struct vm_area_struct *prev, struct vm_area_struct *next)
+		unsigned long pg_max, struct vm_area_struct *prev,
+		struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
@@ -484,8 +485,7 @@ void unmap_region(struct ma_state *mas,
 	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-		      next ? next->vm_start : USER_PGTABLES_CEILING,
-		      next ? next->vm_start : USER_PGTABLES_CEILING,
+		      pg_max, next ? next->vm_start : USER_PGTABLES_CEILING,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
 }
@@ -2469,6 +2469,7 @@ static int __mmap_new_file_vma(struct mm
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->next ? map->next->vm_start : USER_PGTABLES_CEILING,
 			     map->prev, map->next);
 
 		return error;
--- a/mm/vma.h~mm-vma-add-page-table-limit-to-unmap_region
+++ a/mm/vma.h
@@ -265,7 +265,8 @@ void remove_vma(struct vm_area_struct *v
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		unsigned long vma_start, unsigned long vma_end,
-		struct vm_area_struct *prev, struct vm_area_struct *next);
+		unsigned long pg_max, struct vm_area_struct *prev,
+		struct vm_area_struct *next);
 
 /**
  * vma_modify_flags() - Perform any necessary split/merge in preparation for
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

