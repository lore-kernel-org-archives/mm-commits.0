Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1145FC32789
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237554AbiHVTVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238648AbiHVTUx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0702EA0
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:19:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1737DB818AA
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92E5C433D7;
        Mon, 22 Aug 2022 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661195989;
        bh=ZXdtoGgf8hii+p2Y6fAaDWdoV0OSYikprnl6BYQ/1l0=;
        h=Date:To:From:Subject:From;
        b=cfT4DcBRe4jvpCUT8vMZBQ/9OPZExHWrBJZtoiZMgGjiUUOtdcVluQQKRdXzoDc5q
         aPeBa/TZ+IDGt+CHQLHERTasJ8sPtBncEZIhQj7lvAFU2KEJZiINBpzGDLf4MGLrhM
         lLjqHB+i5SS4MtkmmUpYKpr9+oPMCwlTRaN7ul6c=
Date:   Mon, 22 Aug 2022 12:19:48 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-maple-tree-for-unmapped_area_topdown.patch added to mm-unstable branch
Message-Id: <20220822191949.A92E5C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: use maple tree for unmapped_area{_topdown}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-maple-tree-for-unmapped_area_topdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-maple-tree-for-unmapped_area_topdown.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: use maple tree for unmapped_area{_topdown}
Date: Mon, 22 Aug 2022 15:03:08 +0000

The maple tree code was added to find the unmapped area in a previous
commit and was checked against what the rbtree returned, but the actual
result was never used.  Start using the maple tree implementation and
remove the rbtree code.

Add kernel documentation comment for these functions.

Link: https://lkml.kernel.org/r/20220822150128.1562046-14-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |  257 +++++++---------------------------------------------
 1 file changed, 35 insertions(+), 222 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-maple-tree-for-unmapped_area_topdown
+++ a/mm/mmap.c
@@ -2013,250 +2013,63 @@ unacct_error:
 	return error;
 }
 
+/**
+ * unmapped_area() - Find an area between the low_limit and the high_limit with
+ * the correct alignment and offset, all from @info. Note: current->mm is used
+ * for the search.
+ *
+ * @info: The unmapped area information including the range (low_limit -
+ * hight_limit), the alignment offset and mask.
+ *
+ * Return: A memory address or -ENOMEM.
+ */
 static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
-	/*
-	 * We implement the search by looking for an rbtree node that
-	 * immediately follows a suitable gap. That is,
-	 * - gap_start = vma->vm_prev->vm_end <= info->high_limit - length;
-	 * - gap_end   = vma->vm_start        >= info->low_limit  + length;
-	 * - gap_end - gap_start >= length
-	 */
-
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long length, low_limit, high_limit, gap_start, gap_end;
-	unsigned long gap;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	unsigned long length, gap;
+
+	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
 	if (length < info->length)
 		return -ENOMEM;
 
-	mas_empty_area(&mas, info->low_limit, info->high_limit - 1,
-			   length);
-	gap = mas.index;
-	gap += (info->align_offset - gap) & info->align_mask;
-
-	/* Adjust search limits by the desired length */
-	if (info->high_limit < length)
+	if (mas_empty_area(&mas, info->low_limit, info->high_limit - 1,
+				  length))
 		return -ENOMEM;
-	high_limit = info->high_limit - length;
 
-	if (info->low_limit > high_limit)
-		return -ENOMEM;
-	low_limit = info->low_limit + length;
-
-	/* Check if rbtree root looks promising */
-	if (RB_EMPTY_ROOT(&mm->mm_rb))
-		goto check_highest;
-	vma = rb_entry(mm->mm_rb.rb_node, struct vm_area_struct, vm_rb);
-	if (vma->rb_subtree_gap < length)
-		goto check_highest;
-
-	while (true) {
-		/* Visit left subtree if it looks promising */
-		gap_end = vm_start_gap(vma);
-		if (gap_end >= low_limit && vma->vm_rb.rb_left) {
-			struct vm_area_struct *left =
-				rb_entry(vma->vm_rb.rb_left,
-					 struct vm_area_struct, vm_rb);
-			if (left->rb_subtree_gap >= length) {
-				vma = left;
-				continue;
-			}
-		}
-
-		gap_start = vma->vm_prev ? vm_end_gap(vma->vm_prev) : 0;
-check_current:
-		/* Check if current node has a suitable gap */
-		if (gap_start > high_limit)
-			return -ENOMEM;
-		if (gap_end >= low_limit &&
-		    gap_end > gap_start && gap_end - gap_start >= length)
-			goto found;
-
-		/* Visit right subtree if it looks promising */
-		if (vma->vm_rb.rb_right) {
-			struct vm_area_struct *right =
-				rb_entry(vma->vm_rb.rb_right,
-					 struct vm_area_struct, vm_rb);
-			if (right->rb_subtree_gap >= length) {
-				vma = right;
-				continue;
-			}
-		}
-
-		/* Go back up the rbtree to find next candidate node */
-		while (true) {
-			struct rb_node *prev = &vma->vm_rb;
-			if (!rb_parent(prev))
-				goto check_highest;
-			vma = rb_entry(rb_parent(prev),
-				       struct vm_area_struct, vm_rb);
-			if (prev == vma->vm_rb.rb_left) {
-				gap_start = vm_end_gap(vma->vm_prev);
-				gap_end = vm_start_gap(vma);
-				goto check_current;
-			}
-		}
-	}
-
-check_highest:
-	/* Check highest gap, which does not precede any rbtree node */
-	gap_start = mm->highest_vm_end;
-	gap_end = ULONG_MAX;  /* Only for VM_BUG_ON below */
-	if (gap_start > high_limit)
-		return -ENOMEM;
-
-found:
-	/* We found a suitable gap. Clip it with the original low_limit. */
-	if (gap_start < info->low_limit)
-		gap_start = info->low_limit;
-
-	/* Adjust gap address to the desired alignment */
-	gap_start += (info->align_offset - gap_start) & info->align_mask;
-
-	VM_BUG_ON(gap_start + info->length > info->high_limit);
-	VM_BUG_ON(gap_start + info->length > gap_end);
-
-	VM_BUG_ON(gap != gap_start);
-	return gap_start;
+	gap = mas.index;
+	gap += (info->align_offset - gap) & info->align_mask;
+	return gap;
 }
 
+/**
+ * unmapped_area_topdown() - Find an area between the low_limit and the
+ * high_limit with * the correct alignment and offset at the highest available
+ * address, all from @info. Note: current->mm is used for the search.
+ *
+ * @info: The unmapped area information including the range (low_limit -
+ * hight_limit), the alignment offset and mask.
+ *
+ * Return: A memory address or -ENOMEM.
+ */
 static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma = NULL;
-	unsigned long length, low_limit, high_limit, gap_start, gap_end;
-	unsigned long gap;
-
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
-	validate_mm_mt(mm);
+	unsigned long length, gap;
 
+	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
 	if (length < info->length)
 		return -ENOMEM;
 
-	mas_empty_area_rev(&mas, info->low_limit, info->high_limit - 1,
-		   length);
-	gap = mas.last + 1 - info->length;
-	gap -= (gap - info->align_offset) & info->align_mask;
-
-	/*
-	 * Adjust search limits by the desired length.
-	 * See implementation comment at top of unmapped_area().
-	 */
-	gap_end = info->high_limit;
-	if (gap_end < length)
+	if (mas_empty_area_rev(&mas, info->low_limit, info->high_limit - 1,
+				length))
 		return -ENOMEM;
-	high_limit = gap_end - length;
-
-	if (info->low_limit > high_limit)
-		return -ENOMEM;
-	low_limit = info->low_limit + length;
-
-	/* Check highest gap, which does not precede any rbtree node */
-	gap_start = mm->highest_vm_end;
-	if (gap_start <= high_limit)
-		goto found_highest;
 
-	/* Check if rbtree root looks promising */
-	if (RB_EMPTY_ROOT(&mm->mm_rb))
-		return -ENOMEM;
-	vma = rb_entry(mm->mm_rb.rb_node, struct vm_area_struct, vm_rb);
-	if (vma->rb_subtree_gap < length)
-		return -ENOMEM;
-
-	while (true) {
-		/* Visit right subtree if it looks promising */
-		gap_start = vma->vm_prev ? vm_end_gap(vma->vm_prev) : 0;
-		if (gap_start <= high_limit && vma->vm_rb.rb_right) {
-			struct vm_area_struct *right =
-				rb_entry(vma->vm_rb.rb_right,
-					 struct vm_area_struct, vm_rb);
-			if (right->rb_subtree_gap >= length) {
-				vma = right;
-				continue;
-			}
-		}
-
-check_current:
-		/* Check if current node has a suitable gap */
-		gap_end = vm_start_gap(vma);
-		if (gap_end < low_limit)
-			return -ENOMEM;
-		if (gap_start <= high_limit &&
-		    gap_end > gap_start && gap_end - gap_start >= length)
-			goto found;
-
-		/* Visit left subtree if it looks promising */
-		if (vma->vm_rb.rb_left) {
-			struct vm_area_struct *left =
-				rb_entry(vma->vm_rb.rb_left,
-					 struct vm_area_struct, vm_rb);
-			if (left->rb_subtree_gap >= length) {
-				vma = left;
-				continue;
-			}
-		}
-
-		/* Go back up the rbtree to find next candidate node */
-		while (true) {
-			struct rb_node *prev = &vma->vm_rb;
-			if (!rb_parent(prev))
-				return -ENOMEM;
-			vma = rb_entry(rb_parent(prev),
-				       struct vm_area_struct, vm_rb);
-			if (prev == vma->vm_rb.rb_right) {
-				gap_start = vma->vm_prev ?
-					vm_end_gap(vma->vm_prev) : 0;
-				goto check_current;
-			}
-		}
-	}
-
-found:
-	/* We found a suitable gap. Clip it with the original high_limit. */
-	if (gap_end > info->high_limit)
-		gap_end = info->high_limit;
-
-found_highest:
-	/* Compute highest gap address at the desired alignment */
-	gap_end -= info->length;
-	gap_end -= (gap_end - info->align_offset) & info->align_mask;
-
-	VM_BUG_ON(gap_end < info->low_limit);
-	VM_BUG_ON(gap_end < gap_start);
-
-	if (gap != gap_end) {
-		pr_err("%s: %p Gap was found: mt %lu gap_end %lu\n", __func__,
-		       mm, gap, gap_end);
-		pr_err("window was %lu - %lu size %lu\n", info->high_limit,
-		       info->low_limit, length);
-		pr_err("mas.min %lu max %lu mas.last %lu\n", mas.min, mas.max,
-		       mas.last);
-		pr_err("mas.index %lu align mask %lu offset %lu\n", mas.index,
-		       info->align_mask, info->align_offset);
-		pr_err("rb_find_vma find on %lu => %p (%p)\n", mas.index,
-		       find_vma(mm, mas.index), vma);
-#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
-		mt_dump(&mm->mm_mt);
-#endif
-		{
-			struct vm_area_struct *dv = mm->mmap;
-
-			while (dv) {
-				pr_err("vma %p %lu-%lu\n", dv, dv->vm_start, dv->vm_end);
-				dv = dv->vm_next;
-			}
-		}
-		VM_BUG_ON(gap != gap_end);
-	}
-
-	return gap_end;
+	gap = mas.last + 1 - info->length;
+	gap -= (gap - info->align_offset) & info->align_mask;
+	return gap;
 }
 
 /*
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple-tree-add-new-data-structure.patch
radix-tree-test-suite-add-pr_err-define.patch
radix-tree-test-suite-add-kmem_cache_set_non_kernel.patch
radix-tree-test-suite-add-allocation-counts-and-size-to-kmem_cache.patch
radix-tree-test-suite-add-support-for-slab-bulk-apis.patch
radix-tree-test-suite-add-lockdep_is_held-to-header.patch
lib-test_maple_tree-add-testing-for-maple-tree.patch
mm-start-tracking-vmas-with-maple-tree.patch
mm-mmap-use-the-maple-tree-in-find_vma-instead-of-the-rbtree.patch
mm-mmap-use-the-maple-tree-for-find_vma_prev-instead-of-the-rbtree.patch
mm-mmap-use-maple-tree-for-unmapped_area_topdown.patch
kernel-fork-use-maple-tree-for-dup_mmap-during-forking.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator.patch
mm-remove-rb-tree.patch
mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch
xen-use-vma_lookup-in-privcmd_ioctl_mmap.patch
mm-optimize-find_exact_vma-to-use-vma_lookup.patch
mm-khugepaged-optimize-collapse_pte_mapped_thp-by-using-vma_lookup.patch
mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap.patch
mm-use-maple-tree-operations-for-find_vma_intersection.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region.patch
mm-remove-vmacache.patch
mm-convert-vma_lookup-to-use-mtree_load.patch
mm-mmap-move-mmap_region-below-do_munmap.patch
mm-mmap-reorganize-munmap-to-use-maple-states.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap.patch
arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch
fs-proc-base-use-maple-tree-iterators-in-place-of-linked-list.patch
userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch
ipc-shm-use-vma-iterator-instead-of-linked-list.patch
bpf-remove-vma-linked-list.patch
mm-gup-use-maple-tree-navigation-instead-of-linked-list.patch
mm-madvise-use-vma_find-instead-of-vma-linked-list.patch
mm-memcontrol-stop-using-mm-highest_vm_end.patch
mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list.patch
mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list.patch
mm-mremap-use-vma_find_intersection-instead-of-vma-linked-list.patch
mm-msync-use-vma_find-instead-of-vma-linked-list.patch
mm-oom_kill-use-maple-tree-iterators-instead-of-vma-linked-list.patch
mm-swapfile-use-vma-iterator-instead-of-vma-linked-list.patch
riscv-use-vma-iterator-for-vdso.patch
mm-remove-the-vma-linked-list.patch
mm-mmap-drop-range_has_overlap-function.patch
mm-mmapc-pass-in-mapping-to-__vma_link_file.patch

