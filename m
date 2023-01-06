Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F41CC3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbjAFAh7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbjAFAgk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DAC6319D
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 115AA61BC8
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64672C433EF;
        Fri,  6 Jan 2023 00:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965382;
        bh=ejFVmazFjk/tiDIpw5CNXbmpYyHuvsYLWdpOVqRnT5A=;
        h=Date:To:From:Subject:From;
        b=KEV3RYNQZ81t69TQicorPpd5lEl+IKq5N1DrUJiZ4b/alRuZtGVf+EVwvxC3MKMCN
         PppdWid7Z6zPpvpSUGM+tai4xXjM9jRnPjJ6d5WvUAzzFUbfbRw3uPMd4ECFK111UT
         Iz/iAvUV3YO6C6qblHA1aKENnWuI5hXnEreHtKAY=
Date:   Thu, 05 Jan 2023 16:36:21 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch added to mm-unstable branch
Message-Id: <20230106003622.64672C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: don't use __vma_adjust() in shift_arg_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch

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
Subject: mm/mmap: don't use __vma_adjust() in shift_arg_pages()
Date: Thu, 5 Jan 2023 19:16:04 +0000

Introduce shrink_vma() which uses the vma_prepare() and vma_complete()
functions to reduce the vma coverage.

Convert shift_arg_pages() to use expand_vma() and the new shrink_vma()
function.  Remove support from __vma_adjust() to reduce a vma size since
shift_arg_pages() is the only user that shrinks a VMA in this way.

Link: https://lkml.kernel.org/r/20230105191517.3099082-41-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    4 +-
 include/linux/mm.h |   13 +++------
 mm/mmap.c          |   59 +++++++++++++++++++++++++++++++++----------
 3 files changed, 53 insertions(+), 23 deletions(-)

--- a/fs/exec.c~mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages
+++ a/fs/exec.c
@@ -699,7 +699,7 @@ static int shift_arg_pages(struct vm_are
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	if (vma_adjust(&vmi, vma, new_start, old_end, vma->vm_pgoff))
+	if (vma_expand(&vmi, vma, new_start, old_end, vma->vm_pgoff, NULL))
 		return -ENOMEM;
 
 	/*
@@ -733,7 +733,7 @@ static int shift_arg_pages(struct vm_are
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_adjust(&vmi, vma, new_start, new_end, vma->vm_pgoff);
+	return vma_shrink(&vmi, vma, new_start, new_end, vma->vm_pgoff);
 }
 
 /*
--- a/include/linux/mm.h~mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages
+++ a/include/linux/mm.h
@@ -2807,14 +2807,11 @@ void anon_vma_interval_tree_verify(struc
 
 /* mmap.c */
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma, unsigned long start,
-	unsigned long end, pgoff_t pgoff, struct vm_area_struct *expand);
-static inline int vma_adjust(struct vma_iterator *vmi,
-	struct vm_area_struct *vma, unsigned long start, unsigned long end,
-	pgoff_t pgoff)
-{
-	return __vma_adjust(vmi, vma, start, end, pgoff, NULL);
-}
+extern int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		      unsigned long start, unsigned long end, pgoff_t pgoff,
+		      struct vm_area_struct *next);
+extern int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		       unsigned long start, unsigned long end, pgoff_t pgoff);
 extern struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
 	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
 	unsigned long end, unsigned long vm_flags, struct anon_vma *,
--- a/mm/mmap.c~mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages
+++ a/mm/mmap.c
@@ -696,10 +696,9 @@ again:
  *
  * Returns: 0 on success
  */
-inline int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		      unsigned long start, unsigned long end, pgoff_t pgoff,
-		      struct vm_area_struct *next)
-
+int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	       unsigned long start, unsigned long end, pgoff_t pgoff,
+	       struct vm_area_struct *next)
 {
 	bool remove_next = false;
 	struct vma_prepare vp;
@@ -745,6 +744,44 @@ inline int vma_expand(struct vma_iterato
 nomem:
 	return -ENOMEM;
 }
+
+/*
+ * vma_shrink() - Reduce an existing VMAs memory area
+ * @vmi: The vma iterator
+ * @vma: The VMA to modify
+ * @start: The new start
+ * @end: The new end
+ *
+ * Returns: 0 on success, -ENOMEM otherwise
+ */
+int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	       unsigned long start, unsigned long end, pgoff_t pgoff)
+{
+	struct vma_prepare vp;
+
+	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
+
+	if (vma_iter_prealloc(vmi, vma))
+		return -ENOMEM;
+
+	init_vma_prep(&vp, vma);
+	vma_adjust_trans_huge(vma, start, end, 0);
+	vma_prepare(&vp);
+
+	if (vma->vm_start < start)
+		vma_iter_clear(vmi, vma->vm_start, start);
+
+	if (vma->vm_end > end)
+		vma_iter_clear(vmi, end, vma->vm_end);
+
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+	vma_complete(&vp, vmi, vma->vm_mm);
+	validate_mm(vma->vm_mm);
+	return 0;
+}
+
 /*
  * We cannot adjust vm_start, vm_end, vm_pgoff fields of a vma that
  * is already present in an i_mmap tree without adjusting the tree.
@@ -860,14 +897,7 @@ int __vma_adjust(struct vma_iterator *vm
 
 	vma_prepare(&vma_prep);
 
-	if (vma->vm_start < start)
-		vma_iter_clear(vmi, vma->vm_start, start);
-	else if (start != vma->vm_start)
-		vma_changed = true;
-
-	if (vma->vm_end > end)
-		vma_iter_clear(vmi, end, vma->vm_end);
-	else if (end != vma->vm_end)
+	if (start < vma->vm_start || end > vma->vm_end)
 		vma_changed = true;
 
 	vma->vm_start = start;
@@ -880,7 +910,10 @@ int __vma_adjust(struct vma_iterator *vm
 	if (adjust_next) {
 		next->vm_start += adjust_next;
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
-		vma_iter_store(vmi, next);
+		if (adjust_next < 0) {
+			WARN_ON_ONCE(vma_changed);
+			vma_iter_store(vmi, next);
+		}
 	}
 
 	vma_complete(&vma_prep, vmi, mm);
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

