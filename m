Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A89C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbiHVTZN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238423AbiHVTXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:23:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5620E5281A
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79436B818AD
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3347EC433D7;
        Mon, 22 Aug 2022 19:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196111;
        bh=B/BvnaHGUY4l4SEmHgrnPy8KLo6iS1gu/i8U6n+rlwk=;
        h=Date:To:From:Subject:From;
        b=bKEG346IGScp21dCdTXlr6XpGxNeCCt+dhH02z23EPocJ8z181JAeXZMMjKpkvJs3
         5xussVw07dVuJ77OZRRg5cFbp3/avqBqVit++jWPRUoYVsq7GMkhw+gIGPlfbt4ioz
         6WPlJtia99tE6JcEf+i3dphgaDAurORRRNy5qENY=
Date:   Mon, 22 Aug 2022 12:21:50 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, dhowells@redhat.com,
        david@redhat.com, catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-use-vma-iterator-for-vdso.patch added to mm-unstable branch
Message-Id: <20220822192151.3347EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: use vma iterator for vdso
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-use-vma-iterator-for-vdso.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-use-vma-iterator-for-vdso.patch

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
Subject: riscv: use vma iterator for vdso
Date: Mon, 22 Aug 2022 15:06:33 +0000

Remove the linked list use in favour of the vma iterator.

Link: https://lkml.kernel.org/r/20220822150128.1562046-67-Liam.Howlett@oracle.com
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

 arch/riscv/kernel/vdso.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/vdso.c~riscv-use-vma-iterator-for-vdso
+++ a/arch/riscv/kernel/vdso.c
@@ -114,11 +114,12 @@ int vdso_join_timens(struct task_struct
 {
 	struct mm_struct *mm = task->mm;
 	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, mm, 0);
 	struct __vdso_info *vdso_info = mm->context.vdso_info;
 
 	mmap_read_lock(mm);
 
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+	for_each_vma(vmi, vma) {
 		unsigned long size = vma->vm_end - vma->vm_start;
 
 		if (vma_is_special_mapping(vma, vdso_info->dm))
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

