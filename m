Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C96C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbiHVTWS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238783AbiHVTVJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:21:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE68B7F
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49859B818AD
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33B9C433D6;
        Mon, 22 Aug 2022 19:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196065;
        bh=W9fbiWYGCRuXsIVskWQSC1QkU6SXKQQEj8kxPVDP11E=;
        h=Date:To:From:Subject:From;
        b=GNX9Baj0YAmDGBgsG2vmxTrHclwjn2Hk7dz5gHU12o+BOQKpxLp80s/iw0XOEUobB
         l2iDtHm5/OARaPVDb2jTO3mrfyxf9nSBd2KxK0ndRETsZnXbwOBr7VGoqXgWJRJQtp
         XBsL5ygDJzaXAEs+APlMLHRD86BZN0oofV5TcB38=
Date:   Mon, 22 Aug 2022 12:21:04 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch added to mm-unstable branch
Message-Id: <20220822192104.E33B9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: use maple tree iterator to iterate VMAs
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch

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
Subject: userfaultfd: use maple tree iterator to iterate VMAs
Date: Mon, 22 Aug 2022 15:06:26 +0000

Don't use the mm_struct linked list or the vma->vm_next in prep for
removal.

Link: https://lkml.kernel.org/r/20220822150128.1562046-45-Liam.Howlett@oracle.com
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

 fs/userfaultfd.c              |   62 +++++++++++++++++++++-----------
 include/linux/userfaultfd_k.h |    7 +--
 mm/mmap.c                     |    2 -
 3 files changed, 46 insertions(+), 25 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-use-maple-tree-iterator-to-iterate-vmas
+++ a/fs/userfaultfd.c
@@ -611,14 +611,16 @@ static void userfaultfd_event_wait_compl
 	if (release_new_ctx) {
 		struct vm_area_struct *vma;
 		struct mm_struct *mm = release_new_ctx->mm;
+		VMA_ITERATOR(vmi, mm, 0);
 
 		/* the various vma->vm_userfaultfd_ctx still points to it */
 		mmap_write_lock(mm);
-		for (vma = mm->mmap; vma; vma = vma->vm_next)
+		for_each_vma(vmi, vma) {
 			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx) {
 				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 				vma->vm_flags &= ~__VM_UFFD_FLAGS;
 			}
+		}
 		mmap_write_unlock(mm);
 
 		userfaultfd_ctx_put(release_new_ctx);
@@ -799,11 +801,13 @@ static bool has_unmap_ctx(struct userfau
 	return false;
 }
 
-int userfaultfd_unmap_prep(struct vm_area_struct *vma,
-			   unsigned long start, unsigned long end,
-			   struct list_head *unmaps)
+int userfaultfd_unmap_prep(struct mm_struct *mm, unsigned long start,
+			   unsigned long end, struct list_head *unmaps)
 {
-	for ( ; vma && vma->vm_start < end; vma = vma->vm_next) {
+	VMA_ITERATOR(vmi, mm, start);
+	struct vm_area_struct *vma;
+
+	for_each_vma_range(vmi, vma, end) {
 		struct userfaultfd_unmap_ctx *unmap_ctx;
 		struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
 
@@ -853,6 +857,7 @@ static int userfaultfd_release(struct in
 	/* len == 0 means wake all */
 	struct userfaultfd_wake_range range = { .len = 0, };
 	unsigned long new_flags;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	WRITE_ONCE(ctx->released, true);
 
@@ -869,7 +874,7 @@ static int userfaultfd_release(struct in
 	 */
 	mmap_write_lock(mm);
 	prev = NULL;
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+	mas_for_each(&mas, vma, ULONG_MAX) {
 		cond_resched();
 		BUG_ON(!!vma->vm_userfaultfd_ctx.ctx ^
 		       !!(vma->vm_flags & __VM_UFFD_FLAGS));
@@ -883,10 +888,13 @@ static int userfaultfd_release(struct in
 				 vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
-		if (prev)
+		if (prev) {
+			mas_pause(&mas);
 			vma = prev;
-		else
+		} else {
 			prev = vma;
+		}
+
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
@@ -1268,6 +1276,7 @@ static int userfaultfd_register(struct u
 	bool found;
 	bool basic_ioctls;
 	unsigned long start, end, vma_end;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
 
@@ -1310,7 +1319,8 @@ static int userfaultfd_register(struct u
 		goto out;
 
 	mmap_write_lock(mm);
-	vma = find_vma_prev(mm, start, &prev);
+	mas_set(&mas, start);
+	vma = mas_find(&mas, ULONG_MAX);
 	if (!vma)
 		goto out_unlock;
 
@@ -1335,7 +1345,7 @@ static int userfaultfd_register(struct u
 	 */
 	found = false;
 	basic_ioctls = false;
-	for (cur = vma; cur && cur->vm_start < end; cur = cur->vm_next) {
+	for (cur = vma; cur; cur = mas_next(&mas, end - 1)) {
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
@@ -1395,8 +1405,10 @@ static int userfaultfd_register(struct u
 	}
 	BUG_ON(!found);
 
-	if (vma->vm_start < start)
-		prev = vma;
+	mas_set(&mas, start);
+	prev = mas_prev(&mas, 0);
+	if (prev != vma)
+		mas_next(&mas, ULONG_MAX);
 
 	ret = 0;
 	do {
@@ -1426,6 +1438,8 @@ static int userfaultfd_register(struct u
 				 ((struct vm_userfaultfd_ctx){ ctx }),
 				 anon_vma_name(vma));
 		if (prev) {
+			/* vma_merge() invalidated the mas */
+			mas_pause(&mas);
 			vma = prev;
 			goto next;
 		}
@@ -1433,11 +1447,15 @@ static int userfaultfd_register(struct u
 			ret = split_vma(mm, vma, start, 1);
 			if (ret)
 				break;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
 		if (vma->vm_end > end) {
 			ret = split_vma(mm, vma, end, 0);
 			if (ret)
 				break;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
 	next:
 		/*
@@ -1454,8 +1472,8 @@ static int userfaultfd_register(struct u
 	skip:
 		prev = vma;
 		start = vma->vm_end;
-		vma = vma->vm_next;
-	} while (vma && vma->vm_start < end);
+		vma = mas_next(&mas, end - 1);
+	} while (vma);
 out_unlock:
 	mmap_write_unlock(mm);
 	mmput(mm);
@@ -1499,6 +1517,7 @@ static int userfaultfd_unregister(struct
 	bool found;
 	unsigned long start, end, vma_end;
 	const void __user *buf = (void __user *)arg;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
@@ -1517,7 +1536,8 @@ static int userfaultfd_unregister(struct
 		goto out;
 
 	mmap_write_lock(mm);
-	vma = find_vma_prev(mm, start, &prev);
+	mas_set(&mas, start);
+	vma = mas_find(&mas, ULONG_MAX);
 	if (!vma)
 		goto out_unlock;
 
@@ -1542,7 +1562,7 @@ static int userfaultfd_unregister(struct
 	 */
 	found = false;
 	ret = -EINVAL;
-	for (cur = vma; cur && cur->vm_start < end; cur = cur->vm_next) {
+	for (cur = vma; cur; cur = mas_next(&mas, end - 1)) {
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
@@ -1562,8 +1582,10 @@ static int userfaultfd_unregister(struct
 	}
 	BUG_ON(!found);
 
-	if (vma->vm_start < start)
-		prev = vma;
+	mas_set(&mas, start);
+	prev = mas_prev(&mas, 0);
+	if (prev != vma)
+		mas_next(&mas, ULONG_MAX);
 
 	ret = 0;
 	do {
@@ -1632,8 +1654,8 @@ static int userfaultfd_unregister(struct
 	skip:
 		prev = vma;
 		start = vma->vm_end;
-		vma = vma->vm_next;
-	} while (vma && vma->vm_start < end);
+		vma = mas_next(&mas, end - 1);
+	} while (vma);
 out_unlock:
 	mmap_write_unlock(mm);
 	mmput(mm);
--- a/include/linux/userfaultfd_k.h~userfaultfd-use-maple-tree-iterator-to-iterate-vmas
+++ a/include/linux/userfaultfd_k.h
@@ -175,9 +175,8 @@ extern bool userfaultfd_remove(struct vm
 			       unsigned long start,
 			       unsigned long end);
 
-extern int userfaultfd_unmap_prep(struct vm_area_struct *vma,
-				  unsigned long start, unsigned long end,
-				  struct list_head *uf);
+extern int userfaultfd_unmap_prep(struct mm_struct *mm, unsigned long start,
+				  unsigned long end, struct list_head *uf);
 extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 
@@ -258,7 +257,7 @@ static inline bool userfaultfd_remove(st
 	return true;
 }
 
-static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
+static inline int userfaultfd_unmap_prep(struct mm_struct *mm,
 					 unsigned long start, unsigned long end,
 					 struct list_head *uf)
 {
--- a/mm/mmap.c~userfaultfd-use-maple-tree-iterator-to-iterate-vmas
+++ a/mm/mmap.c
@@ -2545,7 +2545,7 @@ do_mas_align_munmap(struct ma_state *mas
 		 * split, despite we could. This is unlikely enough
 		 * failure that it's not worth optimizing it for.
 		 */
-		error = userfaultfd_unmap_prep(vma, start, end, uf);
+		error = userfaultfd_unmap_prep(mm, start, end, uf);
 
 		if (error)
 			goto userfaultfd_error;
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

