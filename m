Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA1E23A1
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pIDjH0Oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6CCC433C9;
	Mon, 11 Dec 2023 00:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256039;
	bh=9SbcZ+DYJsVEeKfr9S+x+OQcq3iXgaCZObsCKA1b9F8=;
	h=Date:To:From:Subject:From;
	b=pIDjH0Oz4LOOn2yDpGh7O36VgtdF+0ZaSkkE+Fr9W0TnkrONvZ33m1/pfgq59tIsN
	 94dEdmXlUjSDMGKUDftP6t7hE54uyIRexlYh+2t9xd2ZWFYO8jQjT/Qqt/C25SLWhI
	 tZ0xhNDDVtMnMgpdiJ2YvOdrCGO9IFjBkQUbeJfs=
Date: Sun, 10 Dec 2023 16:53:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,peterz@infradead.org,npiggin@gmail.com,mst@redhat.com,mjguzik@gmail.com,michael.christie@oracle.com,mathieu.desnoyers@efficios.com,Liam.Howlett@oracle.com,corbet@lwn.net,brauner@kernel.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap.patch removed from -mm tree
Message-Id: <20231211005359.0F6CCC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: use __mt_dup() to duplicate maple tree in dup_mmap()
has been removed from the -mm tree.  Its filename was
     fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: fork: use __mt_dup() to duplicate maple tree in dup_mmap()
Date: Fri, 27 Oct 2023 11:38:45 +0800

In dup_mmap(), using __mt_dup() to duplicate the old maple tree and then
directly replacing the entries of VMAs in the new maple tree can result in
better performance.  __mt_dup() uses DFS pre-order to duplicate the maple
tree, so it is efficient.

The average time complexity of __mt_dup() is O(n), where n is the number
of VMAs.  The proof of the time complexity is provided in the commit log
that introduces __mt_dup().  After duplicating the maple tree, each
element is traversed and replaced (ignoring the cases of deletion, which
are rare).  Since it is only a replacement operation for each element,
this process is also O(n).

Analyzing the exact time complexity of the previous algorithm is
challenging because each insertion can involve appending to a node,
pushing data to adjacent nodes, or even splitting nodes.  The frequency of
each action is difficult to calculate.  The worst-case scenario for a
single insertion is when the tree undergoes splitting at every level.  If
we consider each insertion as the worst-case scenario, we can determine
that the upper bound of the time complexity is O(n*log(n)), although this
is a loose upper bound.  However, based on the test data, it appears that
the actual time complexity is likely to be O(n).

As the entire maple tree is duplicated using __mt_dup(), if dup_mmap()
fails, there will be a portion of VMAs that have not been duplicated in
the maple tree.  To handle this, we mark the failure point with
XA_ZERO_ENTRY.  In exit_mmap(), if this marker is encountered, stop
releasing VMAs that have not been duplicated after this point.

There is a "spawn" in byte-unixbench[1], which can be used to test the
performance of fork().  I modified it slightly to make it work with
different number of VMAs.

Below are the test results.  The first row shows the number of VMAs.  The
second and third rows show the number of fork() calls per ten seconds,
corresponding to next-20231006 and the this patchset, respectively.  The
test results were obtained with CPU binding to avoid scheduler load
balancing that could cause unstable results.  There are still some
fluctuations in the test results, but at least they are better than the
original performance.

21     121   221    421    821    1621   3221   6421   12821  25621  51221
112100 76261 54227  34035  20195  11112  6017   3161   1606   802    393
114558 83067 65008  45824  28751  16072  8922   4747   2436   1233   599
2.19%  8.92% 19.88% 34.64% 42.37% 44.64% 48.28% 50.17% 51.68% 53.74% 52.42%

[1] https://github.com/kdlucas/byte-unixbench/tree/master

Link: https://lkml.kernel.org/r/20231027033845.90608-11-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Suggested-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   11 +++++++++++
 kernel/fork.c      |   40 +++++++++++++++++++++++++++++-----------
 mm/internal.h      |   11 -----------
 mm/memory.c        |    7 ++++++-
 mm/mmap.c          |    9 ++++++---
 5 files changed, 52 insertions(+), 26 deletions(-)

--- a/include/linux/mm.h~fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap
+++ a/include/linux/mm.h
@@ -994,6 +994,17 @@ static inline int vma_iter_bulk_alloc(st
 	return mas_expected_entries(&vmi->mas, count);
 }
 
+static inline int vma_iter_clear_gfp(struct vma_iterator *vmi,
+			unsigned long start, unsigned long end, gfp_t gfp)
+{
+	__mas_set_range(&vmi->mas, start, end - 1);
+	mas_store_gfp(&vmi->mas, NULL, gfp);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
+
 /* Free any unused preallocations */
 static inline void vma_iter_free(struct vma_iterator *vmi)
 {
--- a/kernel/fork.c~fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap
+++ a/kernel/fork.c
@@ -650,7 +650,6 @@ static __latent_entropy int dup_mmap(str
 	int retval;
 	unsigned long charge = 0;
 	LIST_HEAD(uf);
-	VMA_ITERATOR(old_vmi, oldmm, 0);
 	VMA_ITERATOR(vmi, mm, 0);
 
 	uprobe_start_dup_mmap();
@@ -678,16 +677,22 @@ static __latent_entropy int dup_mmap(str
 		goto out;
 	khugepaged_fork(mm, oldmm);
 
-	retval = vma_iter_bulk_alloc(&vmi, oldmm->map_count);
-	if (retval)
+	/* Use __mt_dup() to efficiently build an identical maple tree. */
+	retval = __mt_dup(&oldmm->mm_mt, &mm->mm_mt, GFP_KERNEL);
+	if (unlikely(retval))
 		goto out;
 
 	mt_clear_in_rcu(vmi.mas.tree);
-	for_each_vma(old_vmi, mpnt) {
+	for_each_vma(vmi, mpnt) {
 		struct file *file;
 
 		vma_start_write(mpnt);
 		if (mpnt->vm_flags & VM_DONTCOPY) {
+			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
+						    mpnt->vm_end, GFP_KERNEL);
+			if (retval)
+				goto loop_out;
+
 			vm_stat_account(mm, mpnt->vm_flags, -vma_pages(mpnt));
 			continue;
 		}
@@ -749,9 +754,11 @@ static __latent_entropy int dup_mmap(str
 		if (is_vm_hugetlb_page(tmp))
 			hugetlb_dup_vma_private(tmp);
 
-		/* Link the vma into the MT */
-		if (vma_iter_bulk_store(&vmi, tmp))
-			goto fail_nomem_vmi_store;
+		/*
+		 * Link the vma into the MT. After using __mt_dup(), memory
+		 * allocation is not necessary here, so it cannot fail.
+		 */
+		vma_iter_bulk_store(&vmi, tmp);
 
 		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
@@ -760,15 +767,28 @@ static __latent_entropy int dup_mmap(str
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
 
-		if (retval)
+		if (retval) {
+			mpnt = vma_next(&vmi);
 			goto loop_out;
+		}
 	}
 	/* a new mm has just been created */
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
 	vma_iter_free(&vmi);
-	if (!retval)
+	if (!retval) {
 		mt_set_in_rcu(vmi.mas.tree);
+	} else if (mpnt) {
+		/*
+		 * The entire maple tree has already been duplicated. If the
+		 * mmap duplication fails, mark the failure point with
+		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
+		 * stop releasing VMAs that have not been duplicated after this
+		 * point.
+		 */
+		mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
+		mas_store(&vmi.mas, XA_ZERO_ENTRY);
+	}
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
@@ -778,8 +798,6 @@ fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
 
-fail_nomem_vmi_store:
-	unlink_anon_vmas(tmp);
 fail_nomem_anon_vma_fork:
 	mpol_put(vma_policy(tmp));
 fail_nomem_policy:
--- a/mm/internal.h~fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap
+++ a/mm/internal.h
@@ -1154,17 +1154,6 @@ static inline void vma_iter_clear(struct
 	mas_store_prealloc(&vmi->mas, NULL);
 }
 
-static inline int vma_iter_clear_gfp(struct vma_iterator *vmi,
-			unsigned long start, unsigned long end, gfp_t gfp)
-{
-	__mas_set_range(&vmi->mas, start, end - 1);
-	mas_store_gfp(&vmi->mas, NULL, gfp);
-	if (unlikely(mas_is_err(&vmi->mas)))
-		return -ENOMEM;
-
-	return 0;
-}
-
 static inline struct vm_area_struct *vma_iter_load(struct vma_iterator *vmi)
 {
 	return mas_walk(&vmi->mas);
--- a/mm/memory.c~fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap
+++ a/mm/memory.c
@@ -374,6 +374,8 @@ void free_pgtables(struct mmu_gather *tl
 		 * be 0.  This will underflow and is okay.
 		 */
 		next = mas_find(mas, ceiling - 1);
+		if (unlikely(xa_is_zero(next)))
+			next = NULL;
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
@@ -395,6 +397,8 @@ void free_pgtables(struct mmu_gather *tl
 			       && !is_vm_hugetlb_page(next)) {
 				vma = next;
 				next = mas_find(mas, ceiling - 1);
+				if (unlikely(xa_is_zero(next)))
+					next = NULL;
 				if (mm_wr_locked)
 					vma_start_write(vma);
 				unlink_anon_vmas(vma);
@@ -1744,7 +1748,8 @@ void unmap_vmas(struct mmu_gather *tlb,
 		unmap_single_vma(tlb, vma, start, end, &details,
 				 mm_wr_locked);
 		hugetlb_zap_end(vma, &details);
-	} while ((vma = mas_find(mas, tree_end - 1)) != NULL);
+		vma = mas_find(mas, tree_end - 1);
+	} while (vma && likely(!xa_is_zero(vma)));
 	mmu_notifier_invalidate_range_end(&range);
 }
 
--- a/mm/mmap.c~fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap
+++ a/mm/mmap.c
@@ -3294,10 +3294,11 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 
 	vma = mas_find(&mas, ULONG_MAX);
-	if (!vma) {
+	if (!vma || unlikely(xa_is_zero(vma))) {
 		/* Can happen if dup_mmap() received an OOM */
 		mmap_read_unlock(mm);
-		return;
+		mmap_write_lock(mm);
+		goto destroy;
 	}
 
 	lru_add_drain();
@@ -3332,11 +3333,13 @@ void exit_mmap(struct mm_struct *mm)
 		remove_vma(vma, true);
 		count++;
 		cond_resched();
-	} while ((vma = mas_find(&mas, ULONG_MAX)) != NULL);
+		vma = mas_find(&mas, ULONG_MAX);
+	} while (vma && likely(!xa_is_zero(vma)));
 
 	BUG_ON(count != mm->map_count);
 
 	trace_exit_mmap(mm);
+destroy:
 	__mt_destroy(&mm->mm_mt);
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch
maple_tree-avoid-ascending-when-mas-min-is-also-the-parents-minimum.patch
maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch
maple_tree-delete-one-of-the-two-identical-checks.patch
maple_tree-simplify-mas_leaf_set_meta.patch

