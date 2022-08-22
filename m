Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D49EC28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbiHVTYK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238615AbiHVTWJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:22:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91454F68C
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA3B4CE16DE
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FC8C433C1;
        Mon, 22 Aug 2022 19:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196090;
        bh=xW7GRWNM1h1eLI35p5z3Le8tq4neF+SrdzP5qtqp9/8=;
        h=Date:To:From:Subject:From;
        b=oj29IyJpM+b2I517WFP8UBFHqtjWs34v2WJO+IRprKzKORVVvS0PE23uAikc7fnJw
         fCoWb9lI/uzRp5XzJQnID8VDRF0WxCsIoqfJbzNqiA/FFxvbJjIyvzmHCKG4h5iPBQ
         YqZKK/MwVSFRSLp+OtImkTR6DD3LWa5bbU1D5mcE=
Date:   Mon, 22 Aug 2022 12:21:30 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list.patch added to mm-unstable branch
Message-Id: <20220822192130.B7FC8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: use vma iterator & maple state instead of vma linked list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list.patch

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
Subject: mm/mempolicy: use vma iterator & maple state instead of vma linked list
Date: Mon, 22 Aug 2022 15:06:30 +0000

Reworked the way mbind_range() finds the first VMA to reuse the maple
state and limit the number of tree walks needed.

Note, this drops the VM_BUG_ON(!vma) call, which would catch a start
address higher than the last VMA.  The code was written in a way that
allowed no VMA updates to occur and still return success.  There should be
no functional change to this scenario with the new code.

Link: https://lkml.kernel.org/r/20220822150128.1562046-57-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   56 ++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list
+++ a/mm/mempolicy.c
@@ -381,9 +381,10 @@ void mpol_rebind_task(struct task_struct
 void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
 {
 	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_write_lock(mm);
-	for (vma = mm->mmap; vma; vma = vma->vm_next)
+	for_each_vma(vmi, vma)
 		mpol_rebind_policy(vma->vm_policy, new);
 	mmap_write_unlock(mm);
 }
@@ -654,7 +655,7 @@ static unsigned long change_prot_numa(st
 static int queue_pages_test_walk(unsigned long start, unsigned long end,
 				struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->vma;
+	struct vm_area_struct *next, *vma = walk->vma;
 	struct queue_pages *qp = walk->private;
 	unsigned long endvma = vma->vm_end;
 	unsigned long flags = qp->flags;
@@ -669,9 +670,10 @@ static int queue_pages_test_walk(unsigne
 			/* hole at head side of range */
 			return -EFAULT;
 	}
+	next = find_vma(vma->vm_mm, vma->vm_end);
 	if (!(flags & MPOL_MF_DISCONTIG_OK) &&
 		((vma->vm_end < qp->end) &&
-		(!vma->vm_next || vma->vm_end < vma->vm_next->vm_start)))
+		(!next || vma->vm_end < next->vm_start)))
 		/* hole at middle or tail of range */
 		return -EFAULT;
 
@@ -785,26 +787,24 @@ static int vma_replace_policy(struct vm_
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
 {
+	MA_STATE(mas, &mm->mm_mt, start - 1, start - 1);
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
 	pgoff_t pgoff;
-	unsigned long vmstart;
-	unsigned long vmend;
-
-	vma = find_vma(mm, start);
-	VM_BUG_ON(!vma);
 
-	prev = vma->vm_prev;
-	if (start > vma->vm_start)
-		prev = vma;
+	prev = mas_find_rev(&mas, 0);
+	if (prev && (start < prev->vm_end))
+		vma = prev;
+	else
+		vma = mas_next(&mas, end - 1);
 
-	for (; vma && vma->vm_start < end; prev = vma, vma = vma->vm_next) {
-		vmstart = max(start, vma->vm_start);
-		vmend   = min(end, vma->vm_end);
+	for (; vma; vma = mas_next(&mas, end - 1)) {
+		unsigned long vmstart = max(start, vma->vm_start);
+		unsigned long vmend = min(end, vma->vm_end);
 
 		if (mpol_equal(vma_policy(vma), new_pol))
-			continue;
+			goto next;
 
 		pgoff = vma->vm_pgoff +
 			((vmstart - vma->vm_start) >> PAGE_SHIFT);
@@ -813,6 +813,8 @@ static int mbind_range(struct mm_struct
 				 new_pol, vma->vm_userfaultfd_ctx,
 				 anon_vma_name(vma));
 		if (prev) {
+			/* vma_merge() invalidated the mas */
+			mas_pause(&mas);
 			vma = prev;
 			goto replace;
 		}
@@ -820,19 +822,25 @@ static int mbind_range(struct mm_struct
 			err = split_vma(vma->vm_mm, vma, vmstart, 1);
 			if (err)
 				goto out;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
 		if (vma->vm_end != vmend) {
 			err = split_vma(vma->vm_mm, vma, vmend, 0);
 			if (err)
 				goto out;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
- replace:
+replace:
 		err = vma_replace_policy(vma, new_pol);
 		if (err)
 			goto out;
+next:
+		prev = vma;
 	}
 
- out:
+out:
 	return err;
 }
 
@@ -1049,6 +1057,7 @@ static int migrate_to_node(struct mm_str
 			   int flags)
 {
 	nodemask_t nmask;
+	struct vm_area_struct *vma;
 	LIST_HEAD(pagelist);
 	int err = 0;
 	struct migration_target_control mtc = {
@@ -1064,8 +1073,9 @@ static int migrate_to_node(struct mm_str
 	 * need migration.  Between passing in the full user address
 	 * space range and MPOL_MF_DISCONTIG_OK, this call can not fail.
 	 */
+	vma = find_vma(mm, 0);
 	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
-	queue_pages_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	queue_pages_range(mm, vma->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
 	if (!list_empty(&pagelist)) {
@@ -1195,14 +1205,13 @@ static struct page *new_page(struct page
 	struct folio *dst, *src = page_folio(page);
 	struct vm_area_struct *vma;
 	unsigned long address;
+	VMA_ITERATOR(vmi, current->mm, start);
 	gfp_t gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL;
 
-	vma = find_vma(current->mm, start);
-	while (vma) {
+	for_each_vma(vmi, vma) {
 		address = page_address_in_vma(page, vma);
 		if (address != -EFAULT)
 			break;
-		vma = vma->vm_next;
 	}
 
 	if (folio_test_hugetlb(src))
@@ -1480,6 +1489,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 	unsigned long vmend;
 	unsigned long end;
 	int err = -ENOENT;
+	VMA_ITERATOR(vmi, mm, start);
 
 	start = untagged_addr(start);
 	if (start & ~PAGE_MASK)
@@ -1505,9 +1515,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 	if (end == start)
 		return 0;
 	mmap_write_lock(mm);
-	vma = find_vma(mm, start);
-	for (; vma && vma->vm_start < end;  vma = vma->vm_next) {
-
+	for_each_vma_range(vmi, vma, end) {
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 		new = mpol_dup(vma_policy(vma));
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

