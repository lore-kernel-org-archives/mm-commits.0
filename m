Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58A82DE6F5
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939828; cv=none; b=qT4j6wURN5yMq800nsYS+PYz3JIVoxUMtvQjyY3qI+Nr4euh0deNJTAlNtBN0oslMZ3/f6nQclW57++Day9ciyX+HkNqPLGd1kXzgIn1aKQRcVkkRjbjEllJh4GbQ5pwRL/CYuR7hmv80xRDdtIlXvmduwGq8ktqt39TfxdrRA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939828; c=relaxed/simple;
	bh=IPU3eTN8+USvsVN6Py0OzjYb7jAz9vTSiDqEFwJIS98=;
	h=Date:To:From:Subject:Message-Id; b=gmeWfft+Hglkqo9bJBqXA5Av4Ei0e7K1NwJDGxYseIcyCgvuh5iBy3/4ya1HXBsdd4hWOgYEAr8TOeZ45Jxa8ZVS+KPhR7greF9uC0sRhkmZIOdmGQNqODPnE5QipC0LS/UdQj4OcmZnXHiTixiZsokgwNl7Mpe8HMmpQWhYsGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NiOXMH4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NiOXMH4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CF1C4CEF7;
	Thu, 12 Feb 2026 23:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939828;
	bh=IPU3eTN8+USvsVN6Py0OzjYb7jAz9vTSiDqEFwJIS98=;
	h=Date:To:From:Subject:From;
	b=NiOXMH4RpZk6edbG3ygl2fyBvWrkEkhEzguQ8GplnbpjWUg1EXV8ALrQlYFHhhJLA
	 lPRKudSHIxSegou8515ohyEBDkEE9hJpKJBYKsxU4DEv/ruF4hxtq/iouXHYBOEuSm
	 e6pxnwu3HLGkBK2mfL4LEC0/jNNtO5dX9X79sPMQ=
Date: Thu, 12 Feb 2026 15:43:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-unmap_desc-struct-to-reduce-function-arguments.patch removed from -mm tree
Message-Id: <20260212234348.71CF1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce unmap_desc struct to reduce function arguments
has been removed from the -mm tree.  Its filename was
     mm-introduce-unmap_desc-struct-to-reduce-function-arguments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: introduce unmap_desc struct to reduce function arguments
Date: Wed, 21 Jan 2026 11:49:43 -0500

The unmap_region code uses a number of arguments that could use better
documentation.  With the addition of a descriptor for unmap (called
unmap_desc), the arguments can be more self-documenting and increase the
descriptions within the declaration.

No functional change intended

Link: https://lkml.kernel.org/r/20260121164946.2093480-9-Liam.Howlett@oracle.com
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

 mm/mmap.c |   14 ++++++++++----
 mm/vma.c  |   25 +++++++++++--------------
 mm/vma.h  |   35 ++++++++++++++++++++++++++++++-----
 3 files changed, 51 insertions(+), 23 deletions(-)

--- a/mm/mmap.c~mm-introduce-unmap_desc-struct-to-reduce-function-arguments
+++ a/mm/mmap.c
@@ -1876,11 +1876,17 @@ loop_out:
 		if (end) {
 			vma_iter_set(&vmi, 0);
 			tmp = vma_next(&vmi);
+			UNMAP_STATE(unmap, &vmi, /* first = */ tmp,
+				    /* vma_start = */ 0, /* vma_end = */ end,
+				    /* prev = */ NULL, /* next = */ NULL);
+
+			/*
+			 * Don't iterate over vmas beyond the failure point for
+			 * both unmap_vma() and free_pgtables().
+			 */
+			unmap.tree_end = end;
 			flush_cache_mm(mm);
-			unmap_region(&vmi.mas, /* vma = */ tmp,
-				     /* vma_start = */ 0, /* vma_end = */ end,
-				     /* pg_end = */ end, /* prev = */ NULL,
-				     /* next = */ NULL);
+			unmap_region(&unmap);
 			charge = tear_down_vmas(mm, &vmi, tmp, end);
 			vm_unacct_memory(charge);
 		}
--- a/mm/vma.c~mm-introduce-unmap_desc-struct-to-reduce-function-arguments
+++ a/mm/vma.c
@@ -472,21 +472,19 @@ void remove_vma(struct vm_area_struct *v
  *
  * Called with the mm semaphore held.
  */
-void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long vma_start, unsigned long vma_end,
-		unsigned long pg_max, struct vm_area_struct *prev,
-		struct vm_area_struct *next)
+void unmap_region(struct unmap_desc *unmap)
 {
-	struct mm_struct *mm = vma->vm_mm;
+	struct mm_struct *mm = unmap->first->vm_mm;
+	struct ma_state *mas = unmap->mas;
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
-	mas_set(mas, vma->vm_end);
-	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-		      pg_max, next ? next->vm_start : USER_PGTABLES_CEILING,
-		      /* mm_wr_locked = */ true);
+	unmap_vmas(&tlb, mas, unmap->first, unmap->vma_start, unmap->vma_end,
+		   unmap->vma_end);
+	mas_set(mas, unmap->tree_reset);
+	free_pgtables(&tlb, mas, unmap->first, unmap->pg_start, unmap->pg_end,
+		      unmap->tree_end, unmap->mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 }
 
@@ -2463,15 +2461,14 @@ static int __mmap_new_file_vma(struct mm
 
 	error = mmap_file(vma->vm_file, vma);
 	if (error) {
+		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
+			    map->prev, map->next);
 		fput(vma->vm_file);
 		vma->vm_file = NULL;
 
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
-			     map->next ? map->next->vm_start : USER_PGTABLES_CEILING,
-			     map->prev, map->next);
-
+		unmap_region(&unmap);
 		return error;
 	}
 
--- a/mm/vma.h~mm-introduce-unmap_desc-struct-to-reduce-function-arguments
+++ a/mm/vma.h
@@ -155,6 +155,35 @@ struct vma_merge_struct {
 
 };
 
+struct unmap_desc {
+	struct  ma_state *mas;        /* the maple state point to the first vma */
+	struct vm_area_struct *first; /* The first vma */
+	unsigned long pg_start;       /* The first pagetable address to free (floor) */
+	unsigned long pg_end;         /* The last pagetable address to free (ceiling) */
+	unsigned long vma_start;      /* The min vma address */
+	unsigned long vma_end;        /* The max vma address */
+	unsigned long tree_end;       /* Maximum for the vma tree search */
+	unsigned long tree_reset;     /* Where to reset the vma tree walk */
+	bool mm_wr_locked;            /* If the mmap write lock is held */
+};
+
+#define UNMAP_STATE(name, _vmi, _vma, _vma_start, _vma_end, _prev, _next)      \
+	struct unmap_desc name = {                                             \
+		.mas = &(_vmi)->mas,                                           \
+		.first = _vma,                                                 \
+		.pg_start = _prev ? ((struct vm_area_struct *)_prev)->vm_end : \
+			FIRST_USER_ADDRESS,                                    \
+		.pg_end = _next ? ((struct vm_area_struct *)_next)->vm_start : \
+			USER_PGTABLES_CEILING,                                 \
+		.vma_start = _vma_start,                                       \
+		.vma_end = _vma_end,                                           \
+		.tree_end = _next ?                                            \
+			((struct vm_area_struct *)_next)->vm_start :           \
+			USER_PGTABLES_CEILING,                                 \
+		.tree_reset = _vma->vm_end,                                    \
+		.mm_wr_locked = true,                                          \
+	}
+
 static inline bool vmg_nomem(struct vma_merge_struct *vmg)
 {
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
@@ -262,11 +291,7 @@ int do_vmi_munmap(struct vma_iterator *v
 		  bool unlock);
 
 void remove_vma(struct vm_area_struct *vma);
-
-void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long vma_start, unsigned long vma_end,
-		unsigned long pg_max, struct vm_area_struct *prev,
-		struct vm_area_struct *next);
+void unmap_region(struct unmap_desc *unmap);
 
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

