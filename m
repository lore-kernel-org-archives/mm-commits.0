Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CA0C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbiHVTVL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238657AbiHVTUx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305F95F8C
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD8E5B818AD
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FEBC433D6;
        Mon, 22 Aug 2022 19:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661195994;
        bh=KmkQN/uGLXpd3bTdgQHrt2T/3G7KdVWt5ryFvjUcR6c=;
        h=Date:To:From:Subject:From;
        b=bVJBCzDtFq2rtDvslN6Osz2nhwfej9KhDnjEDzBC2P35WumBBvvVZIgjQGdF5DXsh
         xOACX1ODQ2exKmNEilKEKFWUbglqLVNShx1JRxPnNNDKG/ufI7niUFOJ1cgGmPOl2Q
         tjhxK0yx50QbM4EvqS0CwWlpEMn+tZCoEYGXauSI=
Date:   Mon, 22 Aug 2022 12:19:53 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + damon-convert-__damon_va_three_regions-to-use-the-vma-iterator.patch added to mm-unstable branch
Message-Id: <20220822191954.51FEBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: damon: convert __damon_va_three_regions to use the VMA iterator
has been added to the -mm mm-unstable branch.  Its filename is
     damon-convert-__damon_va_three_regions-to-use-the-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/damon-convert-__damon_va_three_regions-to-use-the-vma-iterator.patch

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
Subject: damon: convert __damon_va_three_regions to use the VMA iterator
Date: Mon, 22 Aug 2022 15:03:16 +0000

This rather specialised walk can use the VMA iterator.  If this proves to
be too slow, we can write a custom routine to find the two largest gaps,
but it will be somewhat complicated, so let's see if we need it first.

Update the kunit test case to use the maple tree.  This also fixes an
issue with the kunit testcase not adding the last VMA to the list.

Link: https://lkml.kernel.org/r/20220822150128.1562046-16-Liam.Howlett@oracle.com
Fixes: 17ccae8bb5c9 (mm/damon: add kunit tests)
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |   36 +++++++++-------------------
 mm/damon/vaddr.c      |   51 ++++++++++++++++++++--------------------
 2 files changed, 38 insertions(+), 49 deletions(-)

--- a/mm/damon/vaddr.c~damon-convert-__damon_va_three_regions-to-use-the-vma-iterator
+++ a/mm/damon/vaddr.c
@@ -113,37 +113,38 @@ static unsigned long sz_range(struct dam
  *
  * Returns 0 if success, or negative error code otherwise.
  */
-static int __damon_va_three_regions(struct vm_area_struct *vma,
+static int __damon_va_three_regions(struct mm_struct *mm,
 				       struct damon_addr_range regions[3])
 {
-	struct damon_addr_range gap = {0}, first_gap = {0}, second_gap = {0};
-	struct vm_area_struct *last_vma = NULL;
-	unsigned long start = 0;
-	struct rb_root rbroot;
-
-	/* Find two biggest gaps so that first_gap > second_gap > others */
-	for (; vma; vma = vma->vm_next) {
-		if (!last_vma) {
-			start = vma->vm_start;
-			goto next;
-		}
+	struct damon_addr_range first_gap = {0}, second_gap = {0};
+	VMA_ITERATOR(vmi, mm, 0);
+	struct vm_area_struct *vma, *prev = NULL;
+	unsigned long start;
+
+	/*
+	 * Find the two biggest gaps so that first_gap > second_gap > others.
+	 * If this is too slow, it can be optimised to examine the maple
+	 * tree gaps.
+	 */
+	for_each_vma(vmi, vma) {
+		unsigned long gap;
 
-		if (vma->rb_subtree_gap <= sz_range(&second_gap)) {
-			rbroot.rb_node = &vma->vm_rb;
-			vma = rb_entry(rb_last(&rbroot),
-					struct vm_area_struct, vm_rb);
+		if (!prev) {
+			start = vma->vm_start;
 			goto next;
 		}
+		gap = vma->vm_start - prev->vm_end;
 
-		gap.start = last_vma->vm_end;
-		gap.end = vma->vm_start;
-		if (sz_range(&gap) > sz_range(&second_gap)) {
-			swap(gap, second_gap);
-			if (sz_range(&second_gap) > sz_range(&first_gap))
-				swap(second_gap, first_gap);
+		if (gap > sz_range(&first_gap)) {
+			second_gap = first_gap;
+			first_gap.start = prev->vm_end;
+			first_gap.end = vma->vm_start;
+		} else if (gap > sz_range(&second_gap)) {
+			second_gap.start = prev->vm_end;
+			second_gap.end = vma->vm_start;
 		}
 next:
-		last_vma = vma;
+		prev = vma;
 	}
 
 	if (!sz_range(&second_gap) || !sz_range(&first_gap))
@@ -159,7 +160,7 @@ next:
 	regions[1].start = ALIGN(first_gap.end, DAMON_MIN_REGION);
 	regions[1].end = ALIGN(second_gap.start, DAMON_MIN_REGION);
 	regions[2].start = ALIGN(second_gap.end, DAMON_MIN_REGION);
-	regions[2].end = ALIGN(last_vma->vm_end, DAMON_MIN_REGION);
+	regions[2].end = ALIGN(prev->vm_end, DAMON_MIN_REGION);
 
 	return 0;
 }
@@ -180,7 +181,7 @@ static int damon_va_three_regions(struct
 		return -EINVAL;
 
 	mmap_read_lock(mm);
-	rc = __damon_va_three_regions(mm->mmap, regions);
+	rc = __damon_va_three_regions(mm, regions);
 	mmap_read_unlock(mm);
 
 	mmput(mm);
--- a/mm/damon/vaddr-test.h~damon-convert-__damon_va_three_regions-to-use-the-vma-iterator
+++ a/mm/damon/vaddr-test.h
@@ -14,33 +14,19 @@
 
 #include <kunit/test.h>
 
-static void __link_vmas(struct vm_area_struct *vmas, ssize_t nr_vmas)
+static void __link_vmas(struct maple_tree *mt, struct vm_area_struct *vmas,
+			ssize_t nr_vmas)
 {
-	int i, j;
-	unsigned long largest_gap, gap;
+	int i;
+	MA_STATE(mas, mt, 0, 0);
 
 	if (!nr_vmas)
 		return;
 
-	for (i = 0; i < nr_vmas - 1; i++) {
-		vmas[i].vm_next = &vmas[i + 1];
-
-		vmas[i].vm_rb.rb_left = NULL;
-		vmas[i].vm_rb.rb_right = &vmas[i + 1].vm_rb;
-
-		largest_gap = 0;
-		for (j = i; j < nr_vmas; j++) {
-			if (j == 0)
-				continue;
-			gap = vmas[j].vm_start - vmas[j - 1].vm_end;
-			if (gap > largest_gap)
-				largest_gap = gap;
-		}
-		vmas[i].rb_subtree_gap = largest_gap;
-	}
-	vmas[i].vm_next = NULL;
-	vmas[i].vm_rb.rb_right = NULL;
-	vmas[i].rb_subtree_gap = 0;
+	mas_lock(&mas);
+	for (i = 0; i < nr_vmas; i++)
+		vma_mas_store(&vmas[i], &mas);
+	mas_unlock(&mas);
 }
 
 /*
@@ -72,6 +58,7 @@ static void __link_vmas(struct vm_area_s
  */
 static void damon_test_three_regions_in_vmas(struct kunit *test)
 {
+	static struct mm_struct mm;
 	struct damon_addr_range regions[3] = {0,};
 	/* 10-20-25, 200-210-220, 300-305, 307-330 */
 	struct vm_area_struct vmas[] = {
@@ -83,9 +70,10 @@ static void damon_test_three_regions_in_
 		(struct vm_area_struct) {.vm_start = 307, .vm_end = 330},
 	};
 
-	__link_vmas(vmas, 6);
+	mt_init_flags(&mm.mm_mt, MM_MT_FLAGS);
+	__link_vmas(&mm.mm_mt, vmas, ARRAY_SIZE(vmas));
 
-	__damon_va_three_regions(&vmas[0], regions);
+	__damon_va_three_regions(&mm, regions);
 
 	KUNIT_EXPECT_EQ(test, 10ul, regions[0].start);
 	KUNIT_EXPECT_EQ(test, 25ul, regions[0].end);
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

