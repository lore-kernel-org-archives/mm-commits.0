Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBD5C32772
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbiHVTVk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238607AbiHVTUs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B142052801
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:19:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D34961212
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B205C433C1;
        Mon, 22 Aug 2022 19:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661195980;
        bh=YXYr0QpYuWXFm02M22Na44WRcyu4glLpNBqviGAe6/Y=;
        h=Date:To:From:Subject:From;
        b=2eMUnV4ID9aSGQMJLfh3THqAl+jYpXbdrmITNhkx9VdtlMqrePrSk+/F4LEDxss5v
         1VcQNdzvNVbNSHbRCkn1lbxGsAzIkBLGHQreXsk7BDOHLSNvMTUU3KYINNVrciebDB
         1ZgyOHuAonZP2dqgY+GrncWBHROtzHM/XkJBgs/I=
Date:   Mon, 22 Aug 2022 12:19:39 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        vbabka@suse.cz, svens@linux.ibm.com, sj@kernel.org,
        Liam.Howlett@Oracle.com, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-vma-iterator.patch added to mm-unstable branch
Message-Id: <20220822191940.9B205C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add VMA iterator
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-vma-iterator.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add VMA iterator
Date: Mon, 22 Aug 2022 15:02:54 +0000

This thin layer of abstraction over the maple tree state is for iterating
over VMAs.  You can go forwards, go backwards or ask where the iterator
is.  Rename the existing vma_next() to __vma_next() -- it will be removed
by the end of this series.

Link: https://lkml.kernel.org/r/20220822150128.1562046-10-Liam.Howlett@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   32 ++++++++++++++++++++++++++++++++
 include/linux/mm_types.h |   21 +++++++++++++++++++++
 mm/mmap.c                |   10 +++++-----
 3 files changed, 58 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-add-vma-iterator
+++ a/include/linux/mm.h
@@ -661,6 +661,38 @@ static inline bool vma_is_accessible(str
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
+static inline
+struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
+{
+	return mas_find(&vmi->mas, max);
+}
+
+static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
+{
+	/*
+	 * Uses vma_find() to get the first VMA when the iterator starts.
+	 * Calling mas_next() could skip the first entry.
+	 */
+	return vma_find(vmi, ULONG_MAX);
+}
+
+static inline struct vm_area_struct *vma_prev(struct vma_iterator *vmi)
+{
+	return mas_prev(&vmi->mas, 0);
+}
+
+static inline unsigned long vma_iter_addr(struct vma_iterator *vmi)
+{
+	return vmi->mas.index;
+}
+
+#define for_each_vma(__vmi, __vma)					\
+	while (((__vma) = vma_next(&(__vmi))) != NULL)
+
+/* The MM code likes to work with exclusive end addresses */
+#define for_each_vma_range(__vmi, __vma, __end)				\
+	while (((__vma) = vma_find(&(__vmi), (__end) - 1)) != NULL)
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
--- a/include/linux/mm_types.h~mm-add-vma-iterator
+++ a/include/linux/mm_types.h
@@ -778,6 +778,27 @@ static inline void lru_gen_use_mm(struct
 
 #endif /* CONFIG_LRU_GEN */
 
+struct vma_iterator {
+	struct ma_state mas;
+};
+
+#define VMA_ITERATOR(name, __mm, __addr)				\
+	struct vma_iterator name = {					\
+		.mas = {						\
+			.tree = &(__mm)->mm_mt,				\
+			.index = __addr,				\
+			.node = MAS_START,				\
+		},							\
+	}
+
+static inline void vma_iter_init(struct vma_iterator *vmi,
+		struct mm_struct *mm, unsigned long addr)
+{
+	vmi->mas.tree = &mm->mm_mt;
+	vmi->mas.index = addr;
+	vmi->mas.node = MAS_START;
+}
+
 struct mmu_gather;
 extern void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm);
 extern void tlb_gather_mmu_fullmm(struct mmu_gather *tlb, struct mm_struct *mm);
--- a/mm/mmap.c~mm-add-vma-iterator
+++ a/mm/mmap.c
@@ -586,7 +586,7 @@ static int find_vma_links(struct mm_stru
 }
 
 /*
- * vma_next() - Get the next VMA.
+ * __vma_next() - Get the next VMA.
  * @mm: The mm_struct.
  * @vma: The current vma.
  *
@@ -594,7 +594,7 @@ static int find_vma_links(struct mm_stru
  *
  * Returns: The next VMA after @vma.
  */
-static inline struct vm_area_struct *vma_next(struct mm_struct *mm,
+static inline struct vm_area_struct *__vma_next(struct mm_struct *mm,
 					 struct vm_area_struct *vma)
 {
 	if (!vma)
@@ -1291,7 +1291,7 @@ struct vm_area_struct *vma_merge(struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
-	next = vma_next(mm, prev);
+	next = __vma_next(mm, prev);
 	area = next;
 	if (area && area->vm_end == end)		/* cases 6, 7, 8 */
 		next = next->vm_next;
@@ -2843,7 +2843,7 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *next = vma_next(mm, prev);
+	struct vm_area_struct *next = __vma_next(mm, prev);
 	struct mmu_gather tlb;
 
 	lru_add_drain();
@@ -3051,7 +3051,7 @@ int __do_munmap(struct mm_struct *mm, un
 		if (error)
 			goto split_failed;
 	}
-	vma = vma_next(mm, prev);
+	vma = __vma_next(mm, prev);
 
 	if (unlikely(uf)) {
 		/*
_

Patches currently in -mm which might be from willy@infradead.org are

support-highmem-pages-in-vmap_pages_range_noflush.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

