Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484ACC3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbjAFAh6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbjAFAgi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0576318F
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01EABB81C0C
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D58C433EF;
        Fri,  6 Jan 2023 00:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965377;
        bh=r/xrK5qHHI4duzYiHSxjzhImtO8CqvN5aSsj0/nh8yI=;
        h=Date:To:From:Subject:From;
        b=rhmS0w/noX5I5twGhVm43f2rJkIFgk3NEbHjutxSXUjH9EzycP2RdqvtCgkY90l4s
         ElbgHKQKv6SJJEequUcVZwArfJXXHZfTo2fo4gxekNVzgi+TzrUU1ayuTPa88qze5B
         Ug0OElBc/aBDit5/4znTlGCQl4ND7/zZenfgIklQ=
Date:   Thu, 05 Jan 2023 16:36:16 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch added to mm-unstable branch
Message-Id: <20230106003617.A7D58C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: introduce init_vma_prep() and init_multi_vma_prep()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch

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
Subject: mm/mmap: introduce init_vma_prep() and init_multi_vma_prep()
Date: Thu, 5 Jan 2023 19:16:04 +0000

Add init_vma_prep() and init_multi_vma_prep() to set up the struct
vma_prepare.  This is to abstract the locking when adjusting the VMAs.

Also change __vma_adjust() variable remove_next int in favour of a
pointer to the VMA to remove.  Rename next_next to remove2 since this
better reflects its use.

Link: https://lkml.kernel.org/r/20230105191517.3099082-39-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |  108 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 61 insertions(+), 47 deletions(-)

--- a/mm/mmap.c~mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep
+++ a/mm/mmap.c
@@ -520,6 +520,45 @@ static int vma_link(struct mm_struct *mm
 }
 
 /*
+ * init_multi_vma_prep() - Initializer for struct vma_prepare
+ * @vp: The vma_prepare struct
+ * @vma: The vma that will be altered once locked
+ * @next: The next vma if it is to be adjusted
+ * @remove: The first vma to be removed
+ * @remove2: The second vma to be removed
+ */
+static inline void init_multi_vma_prep(struct vma_prepare *vp,
+		struct vm_area_struct *vma, struct vm_area_struct *next,
+		struct vm_area_struct *remove, struct vm_area_struct *remove2)
+{
+	memset(vp, 0, sizeof(struct vma_prepare));
+	vp->vma = vma;
+	vp->anon_vma = vma->anon_vma;
+	vp->remove = remove;
+	vp->remove2 = remove2;
+	vp->adj_next = next;
+	if (!vp->anon_vma && next)
+		vp->anon_vma = next->anon_vma;
+
+	vp->file = vma->vm_file;
+	if (vp->file)
+		vp->mapping = vma->vm_file->f_mapping;
+
+}
+
+/*
+ * init_vma_prep() - Initializer wrapper for vma_prepare struct
+ * @vp: The vma_prepare struct
+ * @vma: The vma that will be altered once locked
+ */
+static inline void init_vma_prep(struct vma_prepare *vp,
+				 struct vm_area_struct *vma)
+{
+	init_multi_vma_prep(vp, vma, NULL, NULL, NULL);
+}
+
+
+/*
  * vma_prepare() - Helper function for handling locking VMAs prior to altering
  * @vp: The initialized vma_prepare struct
  */
@@ -628,7 +667,7 @@ again:
 
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
-		 * we must remove next_next too.
+		 * we must remove the one after next as well.
 		 */
 		if (vp->remove2) {
 			vp->remove = vp->remove2;
@@ -662,17 +701,14 @@ inline int vma_expand(struct vma_iterato
 		      struct vm_area_struct *next)
 
 {
+	bool remove_next = false;
 	struct vma_prepare vp;
 
-	memset(&vp, 0, sizeof(vp));
-	vp.vma = vma;
-	vp.anon_vma = vma->anon_vma;
 	if (next && (vma != next) && (end == next->vm_end)) {
-		vp.remove = next;
+		remove_next = true;
 		if (next->anon_vma && !vma->anon_vma) {
 			int error;
 
-			vp.anon_vma = next->anon_vma;
 			vma->anon_vma = next->anon_vma;
 			error = anon_vma_clone(vma, next);
 			if (error)
@@ -680,6 +716,7 @@ inline int vma_expand(struct vma_iterato
 		}
 	}
 
+	init_multi_vma_prep(&vp, vma, NULL, remove_next ? next : NULL, NULL);
 	/* Not merging but overwriting any part of next is not handled. */
 	VM_WARN_ON(next && !vp.remove &&
 		  next != vma && end > next->vm_start);
@@ -690,11 +727,6 @@ inline int vma_expand(struct vma_iterato
 		goto nomem;
 
 	vma_adjust_trans_huge(vma, start, end, 0);
-
-	vp.file = vma->vm_file;
-	if (vp.file)
-		vp.mapping = vp.file->f_mapping;
-
 	/* VMA iterator points to previous, so set to start if necessary */
 	if (vma_iter_addr(vmi) != start)
 		vma_iter_set(vmi, start);
@@ -725,14 +757,13 @@ int __vma_adjust(struct vma_iterator *vm
 	struct vm_area_struct *insert, struct vm_area_struct *expand)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct *next_next = NULL;	/* uninit var warning */
+	struct vm_area_struct *remove2 = NULL;
+	struct vm_area_struct *remove = NULL;
 	struct vm_area_struct *next = find_vma(mm, vma->vm_end);
 	struct vm_area_struct *orig_vma = vma;
-	struct anon_vma *anon_vma = NULL;
 	struct file *file = vma->vm_file;
 	bool vma_changed = false;
 	long adjust_next = 0;
-	int remove_next = 0;
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
 	struct vma_prepare vma_prep;
 
@@ -751,25 +782,24 @@ int __vma_adjust(struct vma_iterator *vm
 				 */
 				VM_WARN_ON(end != next->vm_end);
 				/*
-				 * remove_next == 3 means we're
-				 * removing "vma" and that to do so we
+				 * we're removing "vma" and that to do so we
 				 * swapped "vma" and "next".
 				 */
-				remove_next = 3;
 				VM_WARN_ON(file != next->vm_file);
 				swap(vma, next);
+				remove = next;
 			} else {
 				VM_WARN_ON(expand != vma);
 				/*
-				 * case 1, 6, 7, remove_next == 2 is case 6,
-				 * remove_next == 1 is case 1 or 7.
+				 * case 1, 6, 7, remove next.
+				 * case 6 also removes the one beyond next
 				 */
-				remove_next = 1 + (end > next->vm_end);
-				if (remove_next == 2)
-					next_next = find_vma(mm, next->vm_end);
+				remove = next;
+				if (end > next->vm_end)
+					remove2 = find_vma(mm, next->vm_end);
 
-				VM_WARN_ON(remove_next == 2 &&
-					   end != next_next->vm_end);
+				VM_WARN_ON(remove2 != NULL &&
+					   end != remove2->vm_end);
 			}
 
 			exporter = next;
@@ -779,8 +809,8 @@ int __vma_adjust(struct vma_iterator *vm
 			 * If next doesn't have anon_vma, import from vma after
 			 * next, if the vma overlaps with it.
 			 */
-			if (remove_next == 2 && !next->anon_vma)
-				exporter = next_next;
+			if (remove2 != NULL && !next->anon_vma)
+				exporter = remove2;
 
 		} else if (end > next->vm_start) {
 			/*
@@ -821,30 +851,14 @@ int __vma_adjust(struct vma_iterator *vm
 	if (vma_iter_prealloc(vmi, vma))
 		return -ENOMEM;
 
-	anon_vma = vma->anon_vma;
-	if (!anon_vma && adjust_next)
-		anon_vma = next->anon_vma;
-
-	if (anon_vma)
-		VM_WARN_ON(adjust_next && next->anon_vma &&
-			   anon_vma != next->anon_vma);
-
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
 
-	memset(&vma_prep, 0, sizeof(vma_prep));
-	vma_prep.vma = vma;
-	vma_prep.anon_vma = anon_vma;
-	vma_prep.file = file;
-	if (adjust_next)
-		vma_prep.adj_next = next;
-	if (file)
-		vma_prep.mapping = file->f_mapping;
-	vma_prep.insert = insert;
-	if (remove_next) {
-		vma_prep.remove = next;
-		vma_prep.remove2 = next_next;
-	}
+	init_multi_vma_prep(&vma_prep, vma, adjust_next ? next : NULL, remove,
+			    remove2);
+	VM_WARN_ON(vma_prep.anon_vma && adjust_next && next->anon_vma &&
+		   vma_prep.anon_vma != next->anon_vma);
 
+	vma_prep.insert = insert;
 	vma_prepare(&vma_prep);
 
 	if (start != vma->vm_start) {
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-add-mas_init-function.patch
maple_tree-fix-potential-rcu-issue.patch
maple_tree-reduce-user-error-potential.patch
test_maple_tree-test-modifications-while-iterating.patch
mm-expand-vma-iterator-interface.patch
mm-mmap-convert-brk-to-use-vma-iterator.patch
kernel-fork-convert-forking-to-using-the-vmi-iterator.patch
mmap-convert-vma_link-vma-iterator.patch
mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch
mmap-change-do_mas_munmap-and-do_mas_aligned_munmap-to-use-vma-iterator.patch
mmap-convert-vma_expand-to-use-vma-iterator.patch
mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch
ipc-shm-use-the-vma-iterator-for-munmap-calls.patch
userfaultfd-use-vma-iterator.patch
mm-change-mprotect_fixup-to-vma-iterator.patch
mlock-convert-mlock-to-vma-iterator.patch
coredump-convert-to-vma-iterator.patch
mempolicy-convert-to-vma-iterator.patch
task_mmu-convert-to-vma-iterator.patch
sched-convert-to-vma-iterator.patch
madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch
mmap-pass-through-vmi-iterator-to-__split_vma.patch
mmap-use-vmi-version-of-vma_merge.patch
mm-mremap-use-vmi-version-of-vma_merge.patch
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator.patch
mmap-convert-__vma_adjust-to-use-vma-iterator.patch
mm-pass-through-vma-iterator-to-__vma_adjust.patch
madvise-use-split_vma-instead-of-__split_vma.patch
mm-remove-unnecessary-write-to-vma-iterator-in-__vma_adjust.patch
mm-pass-vma-iterator-through-to-__vma_adjust.patch
mm-add-vma-iterator-to-vma_adjust-arguments.patch
mmap-clean-up-mmap_region-unrolling.patch
mm-change-munmap-splitting-order-and-move_vma.patch
mm-mmap-move-anon_vma-setting-in-__vma_adjust.patch
mm-mmap-refactor-locking-out-of-__vma_adjust.patch
mm-mmap-use-vma_prepare-and-vma_complete-in-vma_expand.patch
mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch
mm-dont-use-__vma_adjust-in-__split_vma.patch
mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch
mm-mmap-introduce-dup_vma_anon-helper.patch
mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch
mm-mmap-remove-__vma_adjust.patch
vma_merge-set-vma-iterator-to-correct-position.patch

