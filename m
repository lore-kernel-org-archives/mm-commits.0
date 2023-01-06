Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D26C53210
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjAFAhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236498AbjAFAgI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFD654D91
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53D2DB81C10
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEA4C433EF;
        Fri,  6 Jan 2023 00:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965356;
        bh=HmlU8OPnpFKPwArwxyIkhhvso+nYOT+vSZPkReOhwio=;
        h=Date:To:From:Subject:From;
        b=MqCGzu0M+VkQ3epSak7xygnLtgxp9uOxhUaFlS0uOQmDNBjp1w+nEXbFcnhFFzGRh
         p5rYmpeyqakLRR9CoTSM5uqi11Rt1QwPWp0Ps1CClPJsNxLJVybSD3CTBvytVcqQeG
         M00nS+dmRr3jvPO5QpKPQ7faQRcPezjfcjlfB5G0=
Date:   Thu, 05 Jan 2023 16:35:55 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-through-vma-iterator-to-__vma_adjust.patch added to mm-unstable branch
Message-Id: <20230106003556.0CEA4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pass through vma iterator to __vma_adjust()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-through-vma-iterator-to-__vma_adjust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-through-vma-iterator-to-__vma_adjust.patch

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
Subject: mm: pass through vma iterator to __vma_adjust()
Date: Thu, 5 Jan 2023 19:16:01 +0000

Pass the vma iterator through to __vma_adjust() so the state can be
updated.

Link: https://lkml.kernel.org/r/20230105191517.3099082-29-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++--
 mm/mmap.c          |   31 +++++++++++++++----------------
 2 files changed, 19 insertions(+), 18 deletions(-)

--- a/include/linux/mm.h~mm-pass-through-vma-iterator-to-__vma_adjust
+++ a/include/linux/mm.h
@@ -2807,13 +2807,15 @@ void anon_vma_interval_tree_verify(struc
 
 /* mmap.c */
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int __vma_adjust(struct vm_area_struct *vma, unsigned long start,
+extern int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert,
 	struct vm_area_struct *expand);
 static inline int vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
 {
-	return __vma_adjust(vma, start, end, pgoff, insert, NULL);
+	VMA_ITERATOR(vmi, vma->vm_mm, start);
+
+	return __vma_adjust(&vmi, vma, start, end, pgoff, insert, NULL);
 }
 extern struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
 	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
--- a/mm/mmap.c~mm-pass-through-vma-iterator-to-__vma_adjust
+++ a/mm/mmap.c
@@ -638,9 +638,9 @@ nomem:
  * are necessary.  The "insert" vma (if any) is to be inserted
  * before we drop the necessary locks.
  */
-int __vma_adjust(struct vm_area_struct *vma, unsigned long start,
-	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert,
-	struct vm_area_struct *expand)
+int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	unsigned long start, unsigned long end, pgoff_t pgoff,
+	struct vm_area_struct *insert, struct vm_area_struct *expand)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next_next = NULL;	/* uninit var warning */
@@ -653,7 +653,6 @@ int __vma_adjust(struct vm_area_struct *
 	bool vma_changed = false;
 	long adjust_next = 0;
 	int remove_next = 0;
-	VMA_ITERATOR(vmi, mm, 0);
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
 
 	if (next && !insert) {
@@ -738,7 +737,7 @@ int __vma_adjust(struct vm_area_struct *
 		}
 	}
 
-	if (vma_iter_prealloc(&vmi, vma))
+	if (vma_iter_prealloc(vmi, vma))
 		return -ENOMEM;
 
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
@@ -784,7 +783,7 @@ int __vma_adjust(struct vm_area_struct *
 	if (start != vma->vm_start) {
 		if ((vma->vm_start < start) &&
 		    (!insert || (insert->vm_end != start))) {
-			vma_iter_clear(&vmi, vma->vm_start, start);
+			vma_iter_clear(vmi, vma->vm_start, start);
 			VM_WARN_ON(insert && insert->vm_start > vma->vm_start);
 		} else {
 			vma_changed = true;
@@ -794,8 +793,8 @@ int __vma_adjust(struct vm_area_struct *
 	if (end != vma->vm_end) {
 		if (vma->vm_end > end) {
 			if (!insert || (insert->vm_start != end)) {
-				vma_iter_clear(&vmi, end, vma->vm_end);
-				vma_iter_set(&vmi, vma->vm_end);
+				vma_iter_clear(vmi, end, vma->vm_end);
+				vma_iter_set(vmi, vma->vm_end);
 				VM_WARN_ON(insert &&
 					   insert->vm_end < vma->vm_end);
 			}
@@ -806,13 +805,13 @@ int __vma_adjust(struct vm_area_struct *
 	}
 
 	if (vma_changed)
-		vma_iter_store(&vmi, vma);
+		vma_iter_store(vmi, vma);
 
 	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
 		next->vm_start += adjust_next;
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
-		vma_iter_store(&vmi, next);
+		vma_iter_store(vmi, next);
 	}
 
 	if (file) {
@@ -832,7 +831,7 @@ int __vma_adjust(struct vm_area_struct *
 		 * us to insert it before dropping the locks
 		 * (it may either follow vma or precede it).
 		 */
-		vma_iter_store(&vmi, insert);
+		vma_iter_store(vmi, insert);
 		mm->map_count++;
 	}
 
@@ -878,7 +877,7 @@ again:
 	if (insert && file)
 		uprobe_mmap(insert);
 
-	vma_iter_free(&vmi);
+	vma_iter_free(vmi);
 	validate_mm(mm);
 
 	return 0;
@@ -1072,20 +1071,20 @@ struct vm_area_struct *vma_merge(struct
 	if (merge_prev && merge_next &&
 			is_mergeable_anon_vma(prev->anon_vma,
 				next->anon_vma, NULL)) {	 /* cases 1, 6 */
-		err = __vma_adjust(prev, prev->vm_start,
+		err = __vma_adjust(vmi, prev, prev->vm_start,
 					next->vm_end, prev->vm_pgoff, NULL,
 					prev);
 		res = prev;
 	} else if (merge_prev) {			/* cases 2, 5, 7 */
-		err = __vma_adjust(prev, prev->vm_start,
+		err = __vma_adjust(vmi, prev, prev->vm_start,
 					end, prev->vm_pgoff, NULL, prev);
 		res = prev;
 	} else if (merge_next) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
-			err = __vma_adjust(prev, prev->vm_start,
+			err = __vma_adjust(vmi, prev, prev->vm_start,
 					addr, prev->vm_pgoff, NULL, next);
 		else					/* cases 3, 8 */
-			err = __vma_adjust(mid, addr, next->vm_end,
+			err = __vma_adjust(vmi, mid, addr, next->vm_end,
 					next->vm_pgoff - pglen, NULL, next);
 		res = next;
 	}
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

