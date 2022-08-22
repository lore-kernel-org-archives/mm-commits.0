Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CD0C38142
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238237AbiHVTVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbiHVTU5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823D313D38
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:20:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30997B818AD
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0FAC433D6;
        Mon, 22 Aug 2022 19:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196025;
        bh=ojQ1fOBPPaR5lJ8H8jiOOHrUoXCp4YUGfqnUQWZhj4c=;
        h=Date:To:From:Subject:From;
        b=O1ugIcZ0tkA4j+IoqT1M9vKmcPQi9IeCKcmH4hW/uGJA75weKys626QvoauoVB1/o
         QsvbPga+G4KtnRpZcYNJO1oResQCIbyu7TS+yy5zNa1GB9I6LHs/MdCuTgDlA42X+Y
         U4YiFWOHE00Icf73wcaZItO2jPgWvMJmvgUEz5Zw=
Date:   Mon, 22 Aug 2022 12:20:25 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-vma_lookup-to-use-mtree_load.patch added to mm-unstable branch
Message-Id: <20220822192025.CC0FAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert vma_lookup() to use mtree_load()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-vma_lookup-to-use-mtree_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-vma_lookup-to-use-mtree_load.patch

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
Subject: mm: convert vma_lookup() to use mtree_load()
Date: Mon, 22 Aug 2022 15:05:13 +0000

Unlike the rbtree, the Maple Tree will return a NULL if there's nothing at
a particular address.

Since the previous commit dropped the vmacache, it is now possible to
consult the tree directly.

Link: https://lkml.kernel.org/r/20220822150128.1562046-27-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-convert-vma_lookup-to-use-mtree_load
+++ a/include/linux/mm.h
@@ -2799,12 +2799,7 @@ struct vm_area_struct *find_vma_intersec
 static inline
 struct vm_area_struct *vma_lookup(struct mm_struct *mm, unsigned long addr)
 {
-	struct vm_area_struct *vma = find_vma(mm, addr);
-
-	if (vma && addr < vma->vm_start)
-		vma = NULL;
-
-	return vma;
+	return mtree_load(&mm->mm_mt, addr);
 }
 
 static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
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

