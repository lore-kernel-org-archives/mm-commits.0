Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1C0C05027
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjAUBHk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjAUBHR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:07:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841F773EE0
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:07:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F28B620DC
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64541C4339B;
        Sat, 21 Jan 2023 01:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263234;
        bh=msCfi689l13bSm41kfOwMF5ol3gGn/iEUWKvUJXz6PE=;
        h=Date:To:From:Subject:From;
        b=x3PTAXkineEI8dJSW8aHStLLa/QNPCuDCpXCacbCNjWVcoB4HAQw6p9+CzicnTj0Q
         PvacHti2mVPl6PDE94NxIM1NGodyByovnoFTYLWr5Rm3e/YvDvPMDGaHVI6AwnQgBV
         JxwSf0taIufcaFNEYqkYKAqIIofzjjaFnUejK3TU=
Date:   Fri, 20 Jan 2023 17:07:13 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-refactor-locking-out-of-__vma_adjust.patch added to mm-unstable branch
Message-Id: <20230121010714.64541C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: refactor locking out of __vma_adjust()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-refactor-locking-out-of-__vma_adjust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-refactor-locking-out-of-__vma_adjust.patch

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
Subject: mm/mmap: refactor locking out of __vma_adjust()
Date: Fri, 20 Jan 2023 11:26:41 -0500

Move the locking into vma_prepare() and vma_complete() for use elsewhere

Link: https://lkml.kernel.org/r/20230120162650.984577-41-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/internal.h~mm-mmap-refactor-locking-out-of-__vma_adjust
+++ a/mm/internal.h
@@ -937,4 +937,18 @@ static inline int vma_iter_store_gfp(str
 
 	return 0;
 }
+
+/*
+ * VMA lock generalization
+ */
+struct vma_prepare {
+	struct vm_area_struct *vma;
+	struct vm_area_struct *adj_next;
+	struct file *file;
+	struct address_space *mapping;
+	struct anon_vma *anon_vma;
+	struct vm_area_struct *insert;
+	struct vm_area_struct *remove;
+	struct vm_area_struct *remove2;
+};
 #endif	/* __MM_INTERNAL_H */
--- a/mm/mmap.c~mm-mmap-refactor-locking-out-of-__vma_adjust
+++ a/mm/mmap.c
@@ -577,6 +577,127 @@ nomem:
 }
 
 /*
+ * vma_prepare() - Helper function for handling locking VMAs prior to altering
+ * @vp: The initialized vma_prepare struct
+ */
+static inline void vma_prepare(struct vma_prepare *vp)
+{
+	if (vp->file) {
+		uprobe_munmap(vp->vma, vp->vma->vm_start, vp->vma->vm_end);
+
+		if (vp->adj_next)
+			uprobe_munmap(vp->adj_next, vp->adj_next->vm_start,
+				      vp->adj_next->vm_end);
+
+		i_mmap_lock_write(vp->mapping);
+		if (vp->insert && vp->insert->vm_file) {
+			/*
+			 * Put into interval tree now, so instantiated pages
+			 * are visible to arm/parisc __flush_dcache_page
+			 * throughout; but we cannot insert into address
+			 * space until vma start or end is updated.
+			 */
+			__vma_link_file(vp->insert,
+					vp->insert->vm_file->f_mapping);
+		}
+	}
+
+	if (vp->anon_vma) {
+		anon_vma_lock_write(vp->anon_vma);
+		anon_vma_interval_tree_pre_update_vma(vp->vma);
+		if (vp->adj_next)
+			anon_vma_interval_tree_pre_update_vma(vp->adj_next);
+	}
+
+	if (vp->file) {
+		flush_dcache_mmap_lock(vp->mapping);
+		vma_interval_tree_remove(vp->vma, &vp->mapping->i_mmap);
+		if (vp->adj_next)
+			vma_interval_tree_remove(vp->adj_next,
+						 &vp->mapping->i_mmap);
+	}
+
+}
+
+/*
+ * vma_complete- Helper function for handling the unlocking after altering VMAs,
+ * or for inserting a VMA.
+ *
+ * @vp: The vma_prepare struct
+ * @vmi: The vma iterator
+ * @mm: The mm_struct
+ */
+static inline void vma_complete(struct vma_prepare *vp,
+				struct vma_iterator *vmi, struct mm_struct *mm)
+{
+	if (vp->file) {
+		if (vp->adj_next)
+			vma_interval_tree_insert(vp->adj_next,
+						 &vp->mapping->i_mmap);
+		vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);
+		flush_dcache_mmap_unlock(vp->mapping);
+	}
+
+	if (vp->remove && vp->file) {
+		__remove_shared_vm_struct(vp->remove, vp->file, vp->mapping);
+		if (vp->remove2)
+			__remove_shared_vm_struct(vp->remove2, vp->file,
+						  vp->mapping);
+	} else if (vp->insert) {
+		/*
+		 * split_vma has split insert from vma, and needs
+		 * us to insert it before dropping the locks
+		 * (it may either follow vma or precede it).
+		 */
+		vma_iter_store(vmi, vp->insert);
+		mm->map_count++;
+	}
+
+	if (vp->anon_vma) {
+		anon_vma_interval_tree_post_update_vma(vp->vma);
+		if (vp->adj_next)
+			anon_vma_interval_tree_post_update_vma(vp->adj_next);
+		anon_vma_unlock_write(vp->anon_vma);
+	}
+
+	if (vp->file) {
+		i_mmap_unlock_write(vp->mapping);
+		uprobe_mmap(vp->vma);
+
+		if (vp->adj_next)
+			uprobe_mmap(vp->adj_next);
+	}
+
+	if (vp->remove) {
+again:
+		if (vp->file) {
+			uprobe_munmap(vp->remove, vp->remove->vm_start,
+				      vp->remove->vm_end);
+			fput(vp->file);
+		}
+		if (vp->remove->anon_vma)
+			anon_vma_merge(vp->vma, vp->remove);
+		mm->map_count--;
+		mpol_put(vma_policy(vp->remove));
+		if (!vp->remove2)
+			WARN_ON_ONCE(vp->vma->vm_end < vp->remove->vm_end);
+		vm_area_free(vp->remove);
+
+		/*
+		 * In mprotect's case 6 (see comments on vma_merge),
+		 * we must remove next_next too.
+		 */
+		if (vp->remove2) {
+			vp->remove = vp->remove2;
+			vp->remove2 = NULL;
+			goto again;
+		}
+	}
+	if (vp->insert && vp->file)
+		uprobe_mmap(vp->insert);
+}
+
+/*
  * We cannot adjust vm_start, vm_end, vm_pgoff fields of a vma that
  * is already present in an i_mmap tree without adjusting the tree.
  * The following helper function should be used when such adjustments
@@ -591,14 +712,13 @@ int __vma_adjust(struct vma_iterator *vm
 	struct vm_area_struct *next_next = NULL;	/* uninit var warning */
 	struct vm_area_struct *next = find_vma(mm, vma->vm_end);
 	struct vm_area_struct *orig_vma = vma;
-	struct address_space *mapping = NULL;
-	struct rb_root_cached *root = NULL;
 	struct anon_vma *anon_vma = NULL;
 	struct file *file = vma->vm_file;
 	bool vma_changed = false;
 	long adjust_next = 0;
 	int remove_next = 0;
 	struct vm_area_struct *exporter = NULL, *importer = NULL;
+	struct vma_prepare vma_prep;
 
 	if (next && !insert) {
 		if (end >= next->vm_end) {
@@ -694,39 +814,22 @@ int __vma_adjust(struct vma_iterator *vm
 			   anon_vma != next->anon_vma);
 
 	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
-	if (file) {
-		mapping = file->f_mapping;
-		root = &mapping->i_mmap;
-		uprobe_munmap(vma, vma->vm_start, vma->vm_end);
-
-		if (adjust_next)
-			uprobe_munmap(next, next->vm_start, next->vm_end);
 
-		i_mmap_lock_write(mapping);
-		if (insert && insert->vm_file) {
-			/*
-			 * Put into interval tree now, so instantiated pages
-			 * are visible to arm/parisc __flush_dcache_page
-			 * throughout; but we cannot insert into address
-			 * space until vma start or end is updated.
-			 */
-			__vma_link_file(insert, insert->vm_file->f_mapping);
-		}
-	}
-
-	if (anon_vma) {
-		anon_vma_lock_write(anon_vma);
-		anon_vma_interval_tree_pre_update_vma(vma);
-		if (adjust_next)
-			anon_vma_interval_tree_pre_update_vma(next);
+	memset(&vma_prep, 0, sizeof(vma_prep));
+	vma_prep.vma = vma;
+	vma_prep.anon_vma = anon_vma;
+	vma_prep.file = file;
+	if (adjust_next)
+		vma_prep.adj_next = next;
+	if (file)
+		vma_prep.mapping = file->f_mapping;
+	vma_prep.insert = insert;
+	if (remove_next) {
+		vma_prep.remove = next;
+		vma_prep.remove2 = next_next;
 	}
 
-	if (file) {
-		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_remove(vma, root);
-		if (adjust_next)
-			vma_interval_tree_remove(next, root);
-	}
+	vma_prepare(&vma_prep);
 
 	if (start != vma->vm_start) {
 		if (vma->vm_start < start) {
@@ -764,69 +867,7 @@ int __vma_adjust(struct vma_iterator *vm
 		vma_iter_store(vmi, next);
 	}
 
-	if (file) {
-		if (adjust_next)
-			vma_interval_tree_insert(next, root);
-		vma_interval_tree_insert(vma, root);
-		flush_dcache_mmap_unlock(mapping);
-	}
-
-	if (remove_next && file) {
-		__remove_shared_vm_struct(next, file, mapping);
-		if (remove_next == 2)
-			__remove_shared_vm_struct(next_next, file, mapping);
-	} else if (insert) {
-		/*
-		 * split_vma has split insert from vma, and needs
-		 * us to insert it before dropping the locks
-		 * (it may either follow vma or precede it).
-		 */
-		vma_iter_store(vmi, insert);
-		mm->map_count++;
-	}
-
-	if (anon_vma) {
-		anon_vma_interval_tree_post_update_vma(vma);
-		if (adjust_next)
-			anon_vma_interval_tree_post_update_vma(next);
-		anon_vma_unlock_write(anon_vma);
-	}
-
-	if (file) {
-		i_mmap_unlock_write(mapping);
-		uprobe_mmap(vma);
-
-		if (adjust_next)
-			uprobe_mmap(next);
-	}
-
-	if (remove_next) {
-again:
-		if (file) {
-			uprobe_munmap(next, next->vm_start, next->vm_end);
-			fput(file);
-		}
-		if (next->anon_vma)
-			anon_vma_merge(vma, next);
-		mm->map_count--;
-		mpol_put(vma_policy(next));
-		if (remove_next != 2)
-			BUG_ON(vma->vm_end < next->vm_end);
-		vm_area_free(next);
-
-		/*
-		 * In mprotect's case 6 (see comments on vma_merge),
-		 * we must remove next_next too.
-		 */
-		if (remove_next == 2) {
-			remove_next = 1;
-			next = next_next;
-			goto again;
-		}
-	}
-	if (insert && file)
-		uprobe_mmap(insert);
-
+	vma_complete(&vma_prep, vmi, mm);
 	vma_iter_free(vmi);
 	validate_mm(mm);
 
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

