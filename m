Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201EA3EBF1B
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939832; cv=none; b=E9UjroNghPORo+4jS5oUSi/4dVEeYMI1R2/jo5ddXkHAnPO0VD+7oLFxCc/k/xTz8Kg+RZ3K0KmNxTMLHNSbPbIphvnFNKsPKhUL9kcXJK9HI7Py3mWN0gpG5xAtOtj2cBcy6xFbr4lgUsyUP5nuKP5H/i4FKoXzGpHTQrlqf28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939832; c=relaxed/simple;
	bh=gyKXWHlOzz3JiM+D60TbP1+k++oJ5hhAnlBUQgLxmO4=;
	h=Date:To:From:Subject:Message-Id; b=Wb3FUIk74dFH9UWyL31XVOI2egHbUvlPMxQC/3EgoI+mD/Bwq0WALqJsu7UJ0S+a9vuYCH1axmLgm2xGJRhnBPJLjYgMBzit/FkKdTtX+Ob1BM/dDeqla/+ZhS9+0wG5piEi1d47ZUH2Qzt57JhhQvCoXFpdfnhKeHaudw3ykIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ktXRPZJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ktXRPZJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA888C4CEF7;
	Thu, 12 Feb 2026 23:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939832;
	bh=gyKXWHlOzz3JiM+D60TbP1+k++oJ5hhAnlBUQgLxmO4=;
	h=Date:To:From:Subject:From;
	b=ktXRPZJAo+bjH8dX+gZIvNAxMPN4AYsCy5sWhvFzIBg7SW0gtPHb4X3m2bzF6pxK3
	 DMyU/toeAR2NeLCR1nYU7FhF3Y/FSAVtNo4y7LJou9ZBWe0EzBUYhknBxbcbPknfLm
	 Vh/wyuL1GTqAu99cbQt9gJPvkf8KGg6IgtTvOZWI=
Date: Thu, 12 Feb 2026 15:43:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-use-unmap_region-in-vms_clear_ptes.patch removed from -mm tree
Message-Id: <20260212234351.EA888C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: use unmap_region() in vms_clear_ptes()
has been removed from the -mm tree.  Its filename was
     mm-vma-use-unmap_region-in-vms_clear_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/vma: use unmap_region() in vms_clear_ptes()
Date: Wed, 21 Jan 2026 11:49:45 -0500

There is no need to open code the vms_clear_ptes() now that unmap_desc
struct is used.

Link: https://lkml.kernel.org/r/20260121164946.2093480-11-Liam.Howlett@oracle.com
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

 mm/vma.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/mm/vma.c~mm-vma-use-unmap_region-in-vms_clear_ptes
+++ a/mm/vma.c
@@ -1255,7 +1255,6 @@ int vma_shrink(struct vma_iterator *vmi,
 static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 		    struct ma_state *mas_detach, bool mm_wr_locked)
 {
-	struct mmu_gather tlb;
 	struct unmap_desc unmap = {
 		.mas = mas_detach,
 		.first = vms->vma,
@@ -1280,19 +1279,8 @@ static inline void vms_clear_ptes(struct
 	if (!vms->clear_ptes) /* Nothing to do */
 		return;
 
-	/*
-	 * We can free page tables without write-locking mmap_lock because VMAs
-	 * were isolated before we downgraded mmap_lock.
-	 */
 	mas_set(mas_detach, 1);
-	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
-	update_hiwater_rss(vms->vma->vm_mm);
-	unmap_vmas(&tlb, &unmap);
-	mas_set(mas_detach, 1);
-	/* start and end may be different if there is no prev or next vma. */
-	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
-		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
-	tlb_finish_mmu(&tlb);
+	unmap_region(&unmap);
 	vms->clear_ptes = false;
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

