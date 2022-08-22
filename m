Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F8FC32774
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbiHVTVP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238661AbiHVTUx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D1FB7FE
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:20:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DA1460F8D
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFE6C433D6;
        Mon, 22 Aug 2022 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196003;
        bh=1T/Ux43o0B77Rms+IDeraK6RUx7JqgGoOPfu/kVGQYg=;
        h=Date:To:From:Subject:From;
        b=XHdG/GognoDCnZWKN/uxWLikOzvx837oZroWxjSTX3xekmNt9jc5RBy12s0S6+MGH
         TyamY1ZQsq1JwvEPoh0C8LLOwoT6DiF1tRsNo/rKvKKjfMKYylrM7FEWkNwLcnX/8d
         95RaHy3hLkN6mTtaooY5co4C4sbyySHoE7HeSAVg=
Date:   Mon, 22 Aug 2022 12:20:03 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, dhowells@redhat.com,
        david@redhat.com, catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch added to mm-unstable branch
Message-Id: <20220822192003.ABFE6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: change zeroing of maple tree in __vma_adjust()
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch

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
Subject: mmap: change zeroing of maple tree in __vma_adjust()
Date: Mon, 22 Aug 2022 15:04:26 +0000

Only write to the maple tree if we are not inserting or the insert isn't
going to overwrite the area to clear.  This avoids spanning writes and
node coealescing when unnecessary.

The change requires a custom search for the linked list addition to find
the correct VMA for the prev link.

Link: https://lkml.kernel.org/r/20220822150128.1562046-19-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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

 mm/mmap.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mmap-change-zeroing-of-maple-tree-in-__vma_adjust
+++ a/mm/mmap.c
@@ -567,11 +567,11 @@ static int vma_link(struct mm_struct *mm
  * mm's list and the mm tree.  It has already been inserted into the interval tree.
  */
 static void __insert_vm_struct(struct mm_struct *mm, struct ma_state *mas,
-			       struct vm_area_struct *vma)
+		struct vm_area_struct *vma, unsigned long location)
 {
 	struct vm_area_struct *prev;
 
-	mas_set(mas, vma->vm_start);
+	mas_set(mas, location);
 	prev = mas_prev(mas, 0);
 	vma_mas_store(vma, mas);
 	__vma_link_list(mm, vma, prev);
@@ -601,6 +601,7 @@ int __vma_adjust(struct vm_area_struct *
 	int remove_next = 0;
 	MA_STATE(mas, &mm->mm_mt, 0, 0);
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
+	unsigned long ll_prev = vma->vm_start; /* linked list prev. */
 
 	if (next && !insert) {
 		if (end >= next->vm_end) {
@@ -728,15 +729,27 @@ int __vma_adjust(struct vm_area_struct *
 	}
 
 	if (start != vma->vm_start) {
-		if (vma->vm_start < start)
+		if ((vma->vm_start < start) &&
+		    (!insert || (insert->vm_end != start))) {
 			vma_mas_szero(&mas, vma->vm_start, start);
-		vma_changed = true;
+			VM_WARN_ON(insert && insert->vm_start > vma->vm_start);
+		} else {
+			vma_changed = true;
+		}
 		vma->vm_start = start;
 	}
 	if (end != vma->vm_end) {
-		if (vma->vm_end > end)
-			vma_mas_szero(&mas, end, vma->vm_end);
-		vma_changed = true;
+		if (vma->vm_end > end) {
+			if (!insert || (insert->vm_start != end)) {
+				vma_mas_szero(&mas, end, vma->vm_end);
+				VM_WARN_ON(insert &&
+					   insert->vm_end < vma->vm_end);
+			} else if (insert->vm_start == end) {
+				ll_prev = vma->vm_end;
+			}
+		} else {
+			vma_changed = true;
+		}
 		vma->vm_end = end;
 		if (!next)
 			mm->highest_vm_end = vm_end_gap(vma);
@@ -783,7 +796,7 @@ int __vma_adjust(struct vm_area_struct *
 		 * us to insert it before dropping the locks
 		 * (it may either follow vma or precede it).
 		 */
-		__insert_vm_struct(mm, &mas, insert);
+		__insert_vm_struct(mm, &mas, insert, ll_prev);
 	}
 
 	if (anon_vma) {
@@ -870,6 +883,7 @@ again:
 	if (insert && file)
 		uprobe_mmap(insert);
 
+	mas_destroy(&mas);
 	validate_mm(mm);
 	return 0;
 }
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

