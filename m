Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BA72580E1
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939821; cv=none; b=NOxWK8igUxkq70+ZcA7hmcLzrjGsd7uZM1r2ZFsMcMFVyMOuWKcTvLJisQg1USsE3HS3LoLjEmBnW7H11Td/OY5McepHqRHOtWh6hgBG2IBzIk6c7bUIpe9KaFZtnC0zrjINsSd9ywtgNNivDvevFUMgmDOkZgAtVR9zSMa4zyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939821; c=relaxed/simple;
	bh=w+6HVti5T2v3eftgvWVHSc3m0q43hGSPYbnqXrr1iy0=;
	h=Date:To:From:Subject:Message-Id; b=RX4685YgmelcgmeSZ+bXtepCjHued6TjBCV8yYUp1YJkuoBBnYvMEGrw60S0EMz5UqcQVaYzH/YSDiyDQxrHZXcyvdQceFRhtO8e83XwYmUneSdaDW7yf1Z1yy+fqsM3C8cckC7oK58160QPvqCE2FvYXdrtpoG3HfBN95NR+68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EPeZBas/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPeZBas/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683C5C4CEF7;
	Thu, 12 Feb 2026 23:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939821;
	bh=w+6HVti5T2v3eftgvWVHSc3m0q43hGSPYbnqXrr1iy0=;
	h=Date:To:From:Subject:From;
	b=EPeZBas/dKDKLcYTy3a9HBNK+/UftlhVGVgbv50taDdjmrUFa0391ZY2HziuFZMoN
	 Sd9dkohY5C70gqOQo6gbA1+Uwl/GzKLj6TTtSMR46WsJOIpVf3qkvsqMz4JwJ7/99n
	 D0rztdRCFBKXRPMPx4E+Z4hVlWAUCpnpx7BBrZmM=
Date: Thu, 12 Feb 2026 15:43:40 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-add-limits-to-unmap_region-for-vmas.patch removed from -mm tree
Message-Id: <20260212234341.683C5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: add limits to unmap_region() for vmas
has been removed from the -mm tree.  Its filename was
     mm-vma-add-limits-to-unmap_region-for-vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/vma: add limits to unmap_region() for vmas
Date: Wed, 21 Jan 2026 11:49:39 -0500

Add a limit to the vma search instead of using the start and end of the
one passed in.

No functional changes intended.

Link: https://lkml.kernel.org/r/20260121164946.2093480-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    6 ++++--
 mm/vma.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/mm/vma.c~mm-vma-add-limits-to-unmap_region-for-vmas
+++ a/mm/vma.c
@@ -473,6 +473,7 @@ void remove_vma(struct vm_area_struct *v
  * Called with the mm semaphore held.
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long vma_start, unsigned long vma_end,
 		struct vm_area_struct *prev, struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -480,7 +481,7 @@ void unmap_region(struct ma_state *mas,
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end);
+	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
@@ -2466,7 +2467,8 @@ static int __mmap_new_file_vma(struct mm
 
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi->mas, vma, map->prev, map->next);
+		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->prev, map->next);
 
 		return error;
 	}
--- a/mm/vma.h~mm-vma-add-limits-to-unmap_region-for-vmas
+++ a/mm/vma.h
@@ -264,6 +264,7 @@ int do_vmi_munmap(struct vma_iterator *v
 void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long vma_start, unsigned long vma_end,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /**
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

