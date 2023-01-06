Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41FDC4708E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbjAFAh7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbjAFAgk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD8563197
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BD61B81C1B
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2DCC433D2;
        Fri,  6 Jan 2023 00:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965379;
        bh=pv9jqBF0/rhjwiH+alO2X73D/dq9orZ9tpTVipbj52A=;
        h=Date:To:From:Subject:From;
        b=gDPhTc7caJPXtsdbISJ/h+79DQHqzzilaB/XoCH6EuyHakI5FTrpe1B6vqONlQJAV
         X8n82Uh1yBxI6JgY67GWjs0RDZZxEUB/uDv+ObCOO/5N/AbwQGlxOubJsV7OVvYWMT
         H8N7P2hczQgtOn4rXr/+Ht4+CAziHZ+2Unt2lrsM=
Date:   Thu, 05 Jan 2023 16:36:19 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-use-__vma_adjust-in-__split_vma.patch added to mm-unstable branch
Message-Id: <20230106003619.BF2DCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't use __vma_adjust() in __split_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-dont-use-__vma_adjust-in-__split_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-use-__vma_adjust-in-__split_vma.patch

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
Subject: mm: don't use __vma_adjust() in __split_vma()
Date: Thu, 5 Jan 2023 19:16:04 +0000

Use the abstracted locking and maple tree operations.  Since
__split_vma() is the only user of the __vma_adjust() function to use the
insert argument, drop that argument.  Remove the NULL passed through
from fs/exec's shift_arg_pages() at the same time.

Link: https://lkml.kernel.org/r/20230105191517.3099082-40-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    4 -
 include/linux/mm.h |    7 +-
 mm/mmap.c          |  114 +++++++++++++++++++------------------------
 3 files changed, 56 insertions(+), 69 deletions(-)

--- a/fs/exec.c~mm-dont-use-__vma_adjust-in-__split_vma
+++ a/fs/exec.c
@@ -699,7 +699,7 @@ static int shift_arg_pages(struct vm_are
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	if (vma_adjust(&vmi, vma, new_start, old_end, vma->vm_pgoff, NULL))
+	if (vma_adjust(&vmi, vma, new_start, old_end, vma->vm_pgoff))
 		return -ENOMEM;
 
 	/*
@@ -733,7 +733,7 @@ static int shift_arg_pages(struct vm_are
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_adjust(&vmi, vma, new_start, new_end, vma->vm_pgoff, NULL);
+	return vma_adjust(&vmi, vma, new_start, new_end, vma->vm_pgoff);
 }
 
 /*
--- a/include/linux/mm.h~mm-dont-use-__vma_adjust-in-__split_vma
+++ a/include/linux/mm.h
@@ -2808,13 +2808,12 @@ void anon_vma_interval_tree_verify(struc
 /* mmap.c */
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
 extern int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma, unsigned long start,
-	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert,
-	struct vm_area_struct *expand);
+	unsigned long end, pgoff_t pgoff, struct vm_area_struct *expand);
 static inline int vma_adjust(struct vma_iterator *vmi,
 	struct vm_area_struct *vma, unsigned long start, unsigned long end,
-	pgoff_t pgoff, struct vm_area_struct *insert)
+	pgoff_t pgoff)
 {
-	return __vma_adjust(vmi, vma, start, end, pgoff, insert, NULL);
+	return __vma_adjust(vmi, vma, start, end, pgoff, NULL);
 }
 extern struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
 	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
--- a/mm/mmap.c~mm-dont-use-__vma_adjust-in-__split_vma
+++ a/mm/mmap.c
@@ -754,7 +754,7 @@ nomem:
  */
 int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	unsigned long start, unsigned long end, pgoff_t pgoff,
-	struct vm_area_struct *insert, struct vm_area_struct *expand)
+	struct vm_area_struct *expand)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *remove2 = NULL;
@@ -767,7 +767,7 @@ int __vma_adjust(struct vma_iterator *vm
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
 	struct vma_prepare vma_prep;
 
-	if (next && !insert) {
+	if (next) {
 		if (end >= next->vm_end) {
 			/*
 			 * vma expands, overlapping all the next, and
@@ -858,39 +858,25 @@ int __vma_adjust(struct vma_iterator *vm
 	VM_WARN_ON(vma_prep.anon_vma && adjust_next && next->anon_vma &&
 		   vma_prep.anon_vma != next->anon_vma);
 
-	vma_prep.insert = insert;
 	vma_prepare(&vma_prep);
 
-	if (start != vma->vm_start) {
-		if (vma->vm_start < start) {
-			if (!insert || (insert->vm_end != start)) {
-				vma_iter_clear(vmi, vma->vm_start, start);
-				vma_iter_set(vmi, start);
-				VM_WARN_ON(insert && insert->vm_start > vma->vm_start);
-			}
-		} else {
-			vma_changed = true;
-		}
-		vma->vm_start = start;
-	}
-	if (end != vma->vm_end) {
-		if (vma->vm_end > end) {
-			if (!insert || (insert->vm_start != end)) {
-				vma_iter_clear(vmi, end, vma->vm_end);
-				vma_iter_set(vmi, vma->vm_end);
-				VM_WARN_ON(insert &&
-					   insert->vm_end < vma->vm_end);
-			}
-		} else {
-			vma_changed = true;
-		}
-		vma->vm_end = end;
-	}
+	if (vma->vm_start < start)
+		vma_iter_clear(vmi, vma->vm_start, start);
+	else if (start != vma->vm_start)
+		vma_changed = true;
+
+	if (vma->vm_end > end)
+		vma_iter_clear(vmi, end, vma->vm_end);
+	else if (end != vma->vm_end)
+		vma_changed = true;
+
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
 
 	if (vma_changed)
 		vma_iter_store(vmi, vma);
 
-	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
 		next->vm_start += adjust_next;
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
@@ -909,9 +895,9 @@ int __vma_adjust(struct vma_iterator *vm
  * per-vma resources, so we don't attempt to merge those.
  */
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
-				struct file *file, unsigned long vm_flags,
-				struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-				struct anon_vma_name *anon_name)
+				   struct file *file, unsigned long vm_flags,
+				   struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+				   struct anon_vma_name *anon_name)
 {
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
@@ -1093,20 +1079,19 @@ struct vm_area_struct *vma_merge(struct
 			is_mergeable_anon_vma(prev->anon_vma,
 				next->anon_vma, NULL)) {	 /* cases 1, 6 */
 		err = __vma_adjust(vmi, prev, prev->vm_start,
-					next->vm_end, prev->vm_pgoff, NULL,
-					prev);
+					next->vm_end, prev->vm_pgoff, prev);
 		res = prev;
 	} else if (merge_prev) {			/* cases 2, 5, 7 */
 		err = __vma_adjust(vmi, prev, prev->vm_start,
-					end, prev->vm_pgoff, NULL, prev);
+					end, prev->vm_pgoff, prev);
 		res = prev;
 	} else if (merge_next) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
 			err = __vma_adjust(vmi, prev, prev->vm_start,
-					addr, prev->vm_pgoff, NULL, next);
+					addr, prev->vm_pgoff, next);
 		else					/* cases 3, 8 */
 			err = __vma_adjust(vmi, mid, addr, next->vm_end,
-					next->vm_pgoff - pglen, NULL, next);
+					next->vm_pgoff - pglen, next);
 		res = next;
 	}
 
@@ -2250,6 +2235,7 @@ static void unmap_region(struct mm_struc
 int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		unsigned long addr, int new_below)
 {
+	struct vma_prepare vp;
 	struct vm_area_struct *new;
 	int err;
 
@@ -2265,16 +2251,20 @@ int __split_vma(struct vma_iterator *vmi
 	if (!new)
 		return -ENOMEM;
 
-	if (new_below)
+	err = -ENOMEM;
+	if (vma_iter_prealloc(vmi, vma))
+		goto out_free_vma;
+
+	if (new_below) {
 		new->vm_end = addr;
-	else {
+	} else {
 		new->vm_start = addr;
 		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
 	}
 
 	err = vma_dup_policy(vma, new);
 	if (err)
-		goto out_free_vma;
+		goto out_free_vmi;
 
 	err = anon_vma_clone(new, vma);
 	if (err)
@@ -2286,33 +2276,31 @@ int __split_vma(struct vma_iterator *vmi
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	if (new_below)
-		err = vma_adjust(vmi, vma, addr, vma->vm_end,
-			vma->vm_pgoff + ((addr - new->vm_start) >> PAGE_SHIFT),
-			new);
-	else
-		err = vma_adjust(vmi, vma, vma->vm_start, addr, vma->vm_pgoff,
-				 new);
+	vma_adjust_trans_huge(vma, vma->vm_start, addr, 0);
+	init_vma_prep(&vp, vma);
+	vp.insert = new;
+	vma_prepare(&vp);
+
+	if (new_below) {
+		vma->vm_start = addr;
+		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
+	} else {
+		vma->vm_end = addr;
+	}
+
+	/* vma_complete stores the new vma */
+	vma_complete(&vp, vmi, vma->vm_mm);
 
 	/* Success. */
-	if (!err) {
-		if (new_below)
-			vma_next(vmi);
-		return 0;
-	}
+	if (new_below)
+		vma_next(vmi);
+	return 0;
 
-	/* Avoid vm accounting in close() operation */
-	new->vm_start = new->vm_end;
-	new->vm_pgoff = 0;
-	/* Clean everything up if vma_adjust failed. */
-	if (new->vm_ops && new->vm_ops->close)
-		new->vm_ops->close(new);
-	if (new->vm_file)
-		fput(new->vm_file);
-	unlink_anon_vmas(new);
- out_free_mpol:
+out_free_mpol:
 	mpol_put(vma_policy(new));
- out_free_vma:
+out_free_vmi:
+	vma_iter_free(vmi);
+out_free_vma:
 	vm_area_free(new);
 	validate_mm_mt(vma->vm_mm);
 	return err;
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

