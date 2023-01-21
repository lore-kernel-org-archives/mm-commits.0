Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D6DC27C76
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjAUBH6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjAUBHc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:07:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD0073ED7
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 596DCB829E7
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064F2C433D2;
        Sat, 21 Jan 2023 01:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263247;
        bh=uMGegKXT1P4Omv1VjQ30rfGnbqllcjoF/l2i4ISXTGo=;
        h=Date:To:From:Subject:From;
        b=e1UEOy69HWGfHwPc0BlaPvkhIFXcx3H2QG2EnPhUyazvfJmQHmM85PpQOuZZzv+FL
         apDiO5BKaWN8CWoXMjkxCEsnvI9nL70hhfJuz7c5o0zaAilZqSWmpu+D3KJ01GU+T3
         EcWHjBv2JTxs+NFf8+43SBdIsIsWCeam5uMg/LYY=
Date:   Fri, 20 Jan 2023 17:07:26 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-introduce-dup_vma_anon-helper.patch added to mm-unstable branch
Message-Id: <20230121010727.064F2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: introduce dup_vma_anon() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-introduce-dup_vma_anon-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-introduce-dup_vma_anon-helper.patch

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
Subject: mm/mmap: introduce dup_vma_anon() helper
Date: Fri, 20 Jan 2023 11:26:47 -0500

Create a helper for duplicating the anon vma when adjusting the vma.  This
simplifies the logic of __vma_adjust().

Link: https://lkml.kernel.org/r/20230120162650.984577-47-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-introduce-dup_vma_anon-helper
+++ a/mm/mmap.c
@@ -621,6 +621,29 @@ again:
 }
 
 /*
+ * dup_anon_vma() - Helper function to duplicate anon_vma
+ * @dst: The destination VMA
+ * @src: The source VMA
+ *
+ * Returns: 0 on success.
+ */
+static inline int dup_anon_vma(struct vm_area_struct *dst,
+			       struct vm_area_struct *src)
+{
+	/*
+	 * Easily overlooked: when mprotect shifts the boundary, make sure the
+	 * expanding vma has anon_vma set if the shrinking vma had, to cover any
+	 * anon pages imported.
+	 */
+	if (src->anon_vma && !dst->anon_vma) {
+		dst->anon_vma = src->anon_vma;
+		return anon_vma_clone(dst, src);
+	}
+
+	return 0;
+}
+
+/*
  * vma_expand - Expand an existing VMA
  *
  * @vmi: The vma iterator
@@ -645,15 +668,12 @@ int vma_expand(struct vma_iterator *vmi,
 	struct vma_prepare vp;
 
 	if (next && (vma != next) && (end == next->vm_end)) {
-		remove_next = true;
-		if (next->anon_vma && !vma->anon_vma) {
-			int error;
+		int ret;
 
-			vma->anon_vma = next->anon_vma;
-			error = anon_vma_clone(vma, next);
-			if (error)
-				return error;
-		}
+		remove_next = true;
+		ret = dup_anon_vma(vma, next);
+		if (ret)
+			return ret;
 	}
 
 	init_multi_vma_prep(&vp, vma, NULL, remove_next ? next : NULL, NULL);
@@ -742,10 +762,11 @@ int __vma_adjust(struct vma_iterator *vm
 	struct file *file = vma->vm_file;
 	bool vma_changed = false;
 	long adjust_next = 0;
-	struct vm_area_struct *exporter = NULL, *importer = NULL;
 	struct vma_prepare vma_prep;
 
 	if (next) {
+		int error = 0;
+
 		if (end >= next->vm_end) {
 			/*
 			 * vma expands, overlapping all the next, and
@@ -780,15 +801,14 @@ int __vma_adjust(struct vma_iterator *vm
 					   end != remove2->vm_end);
 			}
 
-			exporter = next;
-			importer = vma;
-
 			/*
 			 * If next doesn't have anon_vma, import from vma after
 			 * next, if the vma overlaps with it.
 			 */
-			if (remove2 != NULL && !next->anon_vma)
-				exporter = remove2;
+			if (remove != NULL && !next->anon_vma)
+				error = dup_anon_vma(vma, remove2);
+			else
+				error = dup_anon_vma(vma, remove);
 
 		} else if (end > next->vm_start) {
 			/*
@@ -796,9 +816,8 @@ int __vma_adjust(struct vma_iterator *vm
 			 * mprotect case 5 shifting the boundary up.
 			 */
 			adjust_next = (end - next->vm_start);
-			exporter = next;
-			importer = vma;
-			VM_WARN_ON(expand != importer);
+			VM_WARN_ON(expand != vma);
+			error = dup_anon_vma(vma, next);
 		} else if (end < vma->vm_end) {
 			/*
 			 * vma shrinks, and !insert tells it's not
@@ -806,24 +825,11 @@ int __vma_adjust(struct vma_iterator *vm
 			 * mprotect case 4 shifting the boundary down.
 			 */
 			adjust_next = -(vma->vm_end - end);
-			exporter = vma;
-			importer = next;
-			VM_WARN_ON(expand != importer);
-		}
-
-		/*
-		 * Easily overlooked: when mprotect shifts the boundary,
-		 * make sure the expanding vma has anon_vma set if the
-		 * shrinking vma had, to cover any anon pages imported.
-		 */
-		if (exporter && exporter->anon_vma && !importer->anon_vma) {
-			int error;
-
-			importer->anon_vma = exporter->anon_vma;
-			error = anon_vma_clone(importer, exporter);
-			if (error)
-				return error;
+			VM_WARN_ON(expand != next);
+			error = dup_anon_vma(next, vma);
 		}
+		if (error)
+			return error;
 	}
 
 	if (vma_iter_prealloc(vmi))
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
nommu-convert-nommu-to-using-the-vma-iterator.patch
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

