Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7A9C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbiHVTVg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbiHVTUz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3297FF5B3
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B69A4B8171F
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497BEC433C1;
        Mon, 22 Aug 2022 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196014;
        bh=kCnMTrSDL2SK6Vh0/juVMs75yd5+Z07xSgMTKdaB0sQ=;
        h=Date:To:From:Subject:From;
        b=lyEeUWa6olobfwBO/f5HHcjTTIdTkkfufFohCF60x9E5s95XNIC5VNDxePP5eqUUP
         5ZKlOju2DG543OUQzOoD0WvY4EPNZ+TKlx4f6tgD148MSkVqysFJJme+arD+NGDvQx
         eqU3cRlhl+DlKD3q+b7LyK0iV99VY/3UMV6qfOuQ=
Date:   Mon, 22 Aug 2022 12:20:13 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-maple-tree-operations-for-find_vma_intersection.patch added to mm-unstable branch
Message-Id: <20220822192014.497BEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use maple tree operations for find_vma_intersection()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-maple-tree-operations-for-find_vma_intersection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-maple-tree-operations-for-find_vma_intersection.patch

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
Subject: mm: use maple tree operations for find_vma_intersection()
Date: Mon, 22 Aug 2022 15:05:06 +0000

Move find_vma_intersection() to mmap.c and change implementation to maple
tree.

When searching for a vma within a range, it is easier to use the maple
tree interface.

Exported find_vma_intersection() for kvm module.

Link: https://lkml.kernel.org/r/20220822150128.1562046-24-Liam.Howlett@oracle.com
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

 include/linux/mm.h |   22 ++++------------------
 mm/mmap.c          |   29 +++++++++++++++++++++++++++++
 mm/nommu.c         |   11 +++++++++++
 3 files changed, 44 insertions(+), 18 deletions(-)

--- a/include/linux/mm.h~mm-use-maple-tree-operations-for-find_vma_intersection
+++ a/include/linux/mm.h
@@ -2782,26 +2782,12 @@ extern struct vm_area_struct * find_vma(
 extern struct vm_area_struct * find_vma_prev(struct mm_struct * mm, unsigned long addr,
 					     struct vm_area_struct **pprev);
 
-/**
- * find_vma_intersection() - Look up the first VMA which intersects the interval
- * @mm: The process address space.
- * @start_addr: The inclusive start user address.
- * @end_addr: The exclusive end user address.
- *
- * Returns: The first VMA within the provided range, %NULL otherwise.  Assumes
- * start_addr < end_addr.
+/*
+ * Look up the first VMA which intersects the interval [start_addr, end_addr)
+ * NULL if none.  Assume start_addr < end_addr.
  */
-static inline
 struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
-					     unsigned long start_addr,
-					     unsigned long end_addr)
-{
-	struct vm_area_struct *vma = find_vma(mm, start_addr);
-
-	if (vma && end_addr <= vma->vm_start)
-		vma = NULL;
-	return vma;
-}
+			unsigned long start_addr, unsigned long end_addr);
 
 /**
  * vma_lookup() - Find a VMA at a specific address
--- a/mm/mmap.c~mm-use-maple-tree-operations-for-find_vma_intersection
+++ a/mm/mmap.c
@@ -2062,6 +2062,35 @@ get_unmapped_area(struct file *file, uns
 EXPORT_SYMBOL(get_unmapped_area);
 
 /**
+ * find_vma_intersection() - Look up the first VMA which intersects the interval
+ * @mm: The process address space.
+ * @start_addr: The inclusive start user address.
+ * @end_addr: The exclusive end user address.
+ *
+ * Returns: The first VMA within the provided range, %NULL otherwise.  Assumes
+ * start_addr < end_addr.
+ */
+struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
+					     unsigned long start_addr,
+					     unsigned long end_addr)
+{
+	struct vm_area_struct *vma;
+	unsigned long index = start_addr;
+
+	mmap_assert_locked(mm);
+	/* Check the cache first. */
+	vma = vmacache_find(mm, start_addr);
+	if (likely(vma))
+		return vma;
+
+	vma = mt_find(&mm->mm_mt, &index, end_addr - 1);
+	if (vma)
+		vmacache_update(start_addr, vma);
+	return vma;
+}
+EXPORT_SYMBOL(find_vma_intersection);
+
+/**
  * find_vma() - Find the VMA for a given address, or the next VMA.
  * @mm: The mm_struct to check
  * @addr: The address
--- a/mm/nommu.c~mm-use-maple-tree-operations-for-find_vma_intersection
+++ a/mm/nommu.c
@@ -642,6 +642,17 @@ static void delete_vma(struct mm_struct
 	vm_area_free(vma);
 }
 
+struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
+					     unsigned long start_addr,
+					     unsigned long end_addr)
+{
+	unsigned long index = start_addr;
+
+	mmap_assert_locked(mm);
+	return mt_find(&mm->mm_mt, &index, end_addr - 1);
+}
+EXPORT_SYMBOL(find_vma_intersection);
+
 /*
  * look up the first VMA in which addr resides, NULL if none
  * - should be called with mm->mmap_lock at least held readlocked
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

