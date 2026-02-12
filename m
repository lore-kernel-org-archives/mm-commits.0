Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FDB2580E1
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939820; cv=none; b=Jt4wRm3dbc6RGCTIEj9yKlPVHMms5Ae/6ckMPQHDhLuIwiegnDcsySwyujDaAEenMZhep/qn/fSWQ3ix08P3V6B6mOsgWVl3OlIIApTk8wq/LN1WNi/+5ay/MJ1LYKzkyws7Szrn50caoZguj5x8+ZSeKrCjwgCSPn+ADG0nprc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939820; c=relaxed/simple;
	bh=qGEDtvx6+hvrTdfo3eiWMsArdzrUOlUgZ49cU5MmsfM=;
	h=Date:To:From:Subject:Message-Id; b=KMZDg+/n9GFcmvJzCmPAC/mFiuChgkC9I92KbI1Fgm21UJ6K6PZgQAU9RYGn8V2lFPyso4G8k8yVi32fVtpI87oum0P2SyANKn/wkXCLIZXq49OD9jOHhTBCX3/LtafECBe6E+MxPkxi1EXIyjNuO5W+EVI/HLqwAg9vqfrO4S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wmmrre8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wmmrre8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E79C4CEF7;
	Thu, 12 Feb 2026 23:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939819;
	bh=qGEDtvx6+hvrTdfo3eiWMsArdzrUOlUgZ49cU5MmsfM=;
	h=Date:To:From:Subject:From;
	b=Wmmrre8Dy2CYJNAT1ZqtY3W94RzVgF5QtVvMo0gOVlsDRyEAf2bPvQSDqO78CZz/c
	 vs6WAOUsLXmoGBumkS+1tVGFQ+8VLLuqv5aImi190ooNjXZt6qrGxfDQjeMwDTKZwH
	 SlZfxw9EPozkgWrcb59G+JT4Jrle7vyzoSuAisKQ=
Date: Thu, 12 Feb 2026 15:43:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,rppt@kernel.org,pfalcato@suse.de,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,jannh@google.com,david@redhat.com,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-abstract-vma-clean-up-from-exit_mmap.patch removed from -mm tree
Message-Id: <20260212234339.95E79C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: abstract vma clean up from exit_mmap()
has been removed from the -mm tree.  Its filename was
     mm-mmap-abstract-vma-clean-up-from-exit_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: abstract vma clean up from exit_mmap()
Date: Wed, 21 Jan 2026 11:49:38 -0500

Create the new function tear_down_vmas() to remove a range of vmas. 
exit_mmap() will be removing all the vmas.

This is necessary for future patches.

No functional changes intended.

Link: https://lkml.kernel.org/r/20260121164946.2093480-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

 mm/mmap.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/mm/mmap.c~mm-mmap-abstract-vma-clean-up-from-exit_mmap
+++ a/mm/mmap.c
@@ -1247,6 +1247,29 @@ limits_failed:
 }
 EXPORT_SYMBOL(vm_brk_flags);
 
+static
+unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
+		struct vm_area_struct *vma, unsigned long end)
+{
+	unsigned long nr_accounted = 0;
+	int count = 0;
+
+	mmap_assert_write_locked(mm);
+	vma_iter_set(vmi, vma->vm_end);
+	do {
+		if (vma->vm_flags & VM_ACCOUNT)
+			nr_accounted += vma_pages(vma);
+		vma_mark_detached(vma);
+		remove_vma(vma);
+		count++;
+		cond_resched();
+		vma = vma_next(vmi);
+	} while (vma && vma->vm_end <= end);
+
+	VM_WARN_ON_ONCE(count != mm->map_count);
+	return nr_accounted;
+}
+
 /* Release all mmaps. */
 void exit_mmap(struct mm_struct *mm)
 {
@@ -1254,7 +1277,6 @@ void exit_mmap(struct mm_struct *mm)
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	VMA_ITERATOR(vmi, mm, 0);
-	int count = 0;
 
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
@@ -1294,18 +1316,7 @@ void exit_mmap(struct mm_struct *mm)
 	 * enabled, without holding any MM locks besides the unreachable
 	 * mmap_write_lock.
 	 */
-	vma_iter_set(&vmi, vma->vm_end);
-	do {
-		if (vma->vm_flags & VM_ACCOUNT)
-			nr_accounted += vma_pages(vma);
-		vma_mark_detached(vma);
-		remove_vma(vma);
-		count++;
-		cond_resched();
-		vma = vma_next(&vmi);
-	} while (vma && likely(!xa_is_zero(vma)));
-
-	BUG_ON(count != mm->map_count);
+	nr_accounted = tear_down_vmas(mm, &vmi, vma, ULONG_MAX);
 
 destroy:
 	__mt_destroy(&mm->mm_mt);
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

