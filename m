Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB5AC38141
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjAUBIJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjAUBHd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:07:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806A174384
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:07:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E01F62129
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61030C433EF;
        Sat, 21 Jan 2023 01:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263250;
        bh=IlKtenMTq7N9HGJ9cvMBnaadu3cIQXZBzzchci9dz/4=;
        h=Date:To:From:Subject:From;
        b=DYhNGM8krHdk+AC4UL1wFMZYlKC1zwNgfZiOLjiJ6JFKOjMIDvNYINmDGwr7m/ad5
         OH42EzAjFXfSRtDD7T3M56bjmDc/zf2DnoNjSXTczLodGoI50SNvRsWN7xoWzC5hIE
         DrHWWpUmw0prGP3VdzrkM5Qa9xbwNrXgDkV7Y3ac=
Date:   Fri, 20 Jan 2023 17:07:29 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-remove-__vma_adjust.patch added to mm-unstable branch
Message-Id: <20230121010730.61030C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: remove __vma_adjust()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-remove-__vma_adjust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-remove-__vma_adjust.patch

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
Subject: mm/mmap: remove __vma_adjust()
Date: Fri, 20 Jan 2023 11:26:49 -0500

Inline the work of __vma_adjust() into vma_merge().  This reduces code
size and has the added benefits of the comments for the cases being
located with the code.

Change the comments referencing vma_adjust() accordingly.

Link: https://lkml.kernel.org/r/20230120162650.984577-49-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/events/uprobes.c~mm-mmap-remove-__vma_adjust
+++ a/kernel/events/uprobes.c
@@ -1351,7 +1351,7 @@ static int delayed_ref_ctr_inc(struct vm
 }
 
 /*
- * Called from mmap_region/vma_adjust with mm->mmap_lock acquired.
+ * Called from mmap_region/vma_merge with mm->mmap_lock acquired.
  *
  * Currently we ignore all errors and always return 0, the callers
  * can't handle the failure anyway.
--- a/mm/filemap.c~mm-mmap-remove-__vma_adjust
+++ a/mm/filemap.c
@@ -97,7 +97,7 @@
  *    ->i_pages lock		(__sync_single_inode)
  *
  *  ->i_mmap_rwsem
- *    ->anon_vma.lock		(vma_adjust)
+ *    ->anon_vma.lock		(vma_merge)
  *
  *  ->anon_vma.lock
  *    ->page_table_lock or pte_lock	(anon_vma_prepare and various)
--- a/mm/mmap.c~mm-mmap-remove-__vma_adjust
+++ a/mm/mmap.c
@@ -744,133 +744,6 @@ int vma_shrink(struct vma_iterator *vmi,
 }
 
 /*
- * We cannot adjust vm_start, vm_end, vm_pgoff fields of a vma that
- * is already present in an i_mmap tree without adjusting the tree.
- * The following helper function should be used when such adjustments
- * are necessary.  The "insert" vma (if any) is to be inserted
- * before we drop the necessary locks.
- */
-int __vma_adjust(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	unsigned long start, unsigned long end, pgoff_t pgoff,
-	struct vm_area_struct *expand)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct *remove2 = NULL;
-	struct vm_area_struct *remove = NULL;
-	struct vm_area_struct *next = find_vma(mm, vma->vm_end);
-	struct vm_area_struct *orig_vma = vma;
-	struct file *file = vma->vm_file;
-	bool vma_changed = false;
-	long adjust_next = 0;
-	struct vma_prepare vma_prep;
-
-	if (next) {
-		int error = 0;
-
-		if (end >= next->vm_end) {
-			/*
-			 * vma expands, overlapping all the next, and
-			 * perhaps the one after too (mprotect case 6).
-			 * The only other cases that gets here are
-			 * case 1, case 7 and case 8.
-			 */
-			if (next == expand) {
-				/*
-				 * The only case where we don't expand "vma"
-				 * and we expand "next" instead is case 8.
-				 */
-				VM_WARN_ON(end != next->vm_end);
-				/*
-				 * we're removing "vma" and that to do so we
-				 * swapped "vma" and "next".
-				 */
-				VM_WARN_ON(file != next->vm_file);
-				swap(vma, next);
-				remove = next;
-			} else {
-				VM_WARN_ON(expand != vma);
-				/*
-				 * case 1, 6, 7, remove next.
-				 * case 6 also removes the one beyond next
-				 */
-				remove = next;
-				if (end > next->vm_end)
-					remove2 = find_vma(mm, next->vm_end);
-
-				VM_WARN_ON(remove2 != NULL &&
-					   end != remove2->vm_end);
-			}
-
-			/*
-			 * If next doesn't have anon_vma, import from vma after
-			 * next, if the vma overlaps with it.
-			 */
-			if (remove != NULL && !next->anon_vma)
-				error = dup_anon_vma(vma, remove2);
-			else
-				error = dup_anon_vma(vma, remove);
-
-		} else if (end > next->vm_start) {
-			/*
-			 * vma expands, overlapping part of the next:
-			 * mprotect case 5 shifting the boundary up.
-			 */
-			adjust_next = (end - next->vm_start);
-			VM_WARN_ON(expand != vma);
-			error = dup_anon_vma(vma, next);
-		} else if (end < vma->vm_end) {
-			/*
-			 * vma shrinks, and !insert tells it's not
-			 * split_vma inserting another: so it must be
-			 * mprotect case 4 shifting the boundary down.
-			 */
-			adjust_next = -(vma->vm_end - end);
-			VM_WARN_ON(expand != next);
-			error = dup_anon_vma(next, vma);
-		}
-		if (error)
-			return error;
-	}
-
-	if (vma_iter_prealloc(vmi))
-		return -ENOMEM;
-
-	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
-
-	init_multi_vma_prep(&vma_prep, vma, adjust_next ? next : NULL, remove,
-			    remove2);
-	VM_WARN_ON(vma_prep.anon_vma && adjust_next && next->anon_vma &&
-		   vma_prep.anon_vma != next->anon_vma);
-
-	vma_prepare(&vma_prep);
-
-	if (start < vma->vm_start || end > vma->vm_end)
-		vma_changed = true;
-
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-
-	if (vma_changed)
-		vma_iter_store(vmi, vma);
-
-	if (adjust_next) {
-		next->vm_start += adjust_next;
-		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
-		if (adjust_next < 0) {
-			WARN_ON_ONCE(vma_changed);
-			vma_iter_store(vmi, next);
-		}
-	}
-
-	vma_complete(&vma_prep, vmi, mm);
-	vma_iter_free(vmi);
-	validate_mm(mm);
-
-	return 0;
-}
-
-/*
  * If the vma has a ->close operation then the driver probably needs to release
  * per-vma resources, so we don't attempt to merge those.
  */
@@ -996,7 +869,7 @@ can_vma_merge_after(struct vm_area_struc
  * It is important for case 8 that the vma NNNN overlapping the
  * region AAAA is never going to extended over XXXX. Instead XXXX must
  * be extended in region AAAA and NNNN must be removed. This way in
- * all cases where vma_merge succeeds, the moment vma_adjust drops the
+ * all cases where vma_merge succeeds, the moment vma_merge drops the
  * rmap_locks, the properties of the merged vma will be already
  * correct for the whole merged range. Some of those properties like
  * vm_page_prot/vm_flags may be accessed by rmap_walks and they must
@@ -1006,6 +879,12 @@ can_vma_merge_after(struct vm_area_struc
  * or other rmap walkers (if working on addresses beyond the "end"
  * parameter) may establish ptes with the wrong permissions of NNNN
  * instead of the right permissions of XXXX.
+ *
+ * In the code below:
+ * PPPP is represented by *prev
+ * NNNN is represented by *mid (and possibly equal to *next)
+ * XXXX is represented by *next or not represented at all.
+ * AAAA is not represented - it will be merged or the function will return NULL
  */
 struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
 			struct vm_area_struct *prev, unsigned long addr,
@@ -1016,11 +895,19 @@ struct vm_area_struct *vma_merge(struct
 			struct anon_vma_name *anon_name)
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
+	pgoff_t vma_pgoff;
 	struct vm_area_struct *mid, *next, *res = NULL;
+	struct vm_area_struct *vma, *adjust, *remove, *remove2;
 	int err = -1;
 	bool merge_prev = false;
 	bool merge_next = false;
+	bool vma_expanded = false;
+	struct vma_prepare vp;
+	unsigned long vma_end = end;
+	long adj_next = 0;
+	unsigned long vma_start = addr;
 
+	validate_mm(mm);
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
 	 * so this tests vma->vm_flags & VM_SPECIAL, too.
@@ -1038,13 +925,17 @@ struct vm_area_struct *vma_merge(struct
 	VM_WARN_ON(mid && end > mid->vm_end);
 	VM_WARN_ON(addr >= end);
 
-	/* Can we merge the predecessor? */
-	if (prev && prev->vm_end == addr &&
-			mpol_equal(vma_policy(prev), policy) &&
-			can_vma_merge_after(prev, vm_flags,
-					    anon_vma, file, pgoff,
-					    vm_userfaultfd_ctx, anon_name)) {
-		merge_prev = true;
+	if (prev) {
+		res = prev;
+		vma = prev;
+		vma_start = prev->vm_start;
+		vma_pgoff = prev->vm_pgoff;
+		/* Can we merge the predecessor? */
+		if (prev->vm_end == addr && mpol_equal(vma_policy(prev), policy)
+		    && can_vma_merge_after(prev, vm_flags, anon_vma, file,
+				   pgoff, vm_userfaultfd_ctx, anon_name)) {
+			merge_prev = true;
+		}
 	}
 	/* Can we merge the successor? */
 	if (next && end == next->vm_start &&
@@ -1054,32 +945,85 @@ struct vm_area_struct *vma_merge(struct
 					     vm_userfaultfd_ctx, anon_name)) {
 		merge_next = true;
 	}
+
+	remove = remove2 = adjust = NULL;
 	/* Can we merge both the predecessor and the successor? */
 	if (merge_prev && merge_next &&
-			is_mergeable_anon_vma(prev->anon_vma,
-				next->anon_vma, NULL)) {	 /* cases 1, 6 */
-		err = __vma_adjust(vmi, prev, prev->vm_start,
-					next->vm_end, prev->vm_pgoff, prev);
-		res = prev;
-	} else if (merge_prev) {			/* cases 2, 5, 7 */
-		err = __vma_adjust(vmi, prev, prev->vm_start,
-					end, prev->vm_pgoff, prev);
-		res = prev;
+	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
+		remove = mid;				/* case 1 */
+		vma_end = next->vm_end;
+		err = dup_anon_vma(res, remove);
+		if (mid != next) {			/* case 6 */
+			remove2 = next;
+			if (!remove->anon_vma)
+				err = dup_anon_vma(res, remove2);
+		}
+	} else if (merge_prev) {
+		err = 0;				/* case 2 */
+		if (mid && end > mid->vm_start) {
+			err = dup_anon_vma(res, mid);
+			if (end == mid->vm_end) {	/* case 7 */
+				remove = mid;
+			} else {			/* case 5 */
+				adjust = mid;
+				adj_next = (end - mid->vm_start);
+			}
+		}
 	} else if (merge_next) {
-		if (prev && addr < prev->vm_end)	/* case 4 */
-			err = __vma_adjust(vmi, prev, prev->vm_start,
-					addr, prev->vm_pgoff, next);
-		else					/* cases 3, 8 */
-			err = __vma_adjust(vmi, mid, addr, next->vm_end,
-					next->vm_pgoff - pglen, next);
 		res = next;
+		if (prev && addr < prev->vm_end) {	/* case 4 */
+			vma_end = addr;
+			adjust = mid;
+			adj_next = -(vma->vm_end - addr);
+			err = dup_anon_vma(res, adjust);
+		} else {
+			vma = next;			/* case 3 */
+			vma_start = addr;
+			vma_end = next->vm_end;
+			vma_pgoff = next->vm_pgoff;
+			err = 0;
+			if (mid != next) {		/* case 8 */
+				remove = mid;
+				err = dup_anon_vma(res, remove);
+			}
+		}
 	}
 
-	/*
-	 * Cannot merge with predecessor or successor or error in __vma_adjust?
-	 */
+	/* Cannot merge or error in anon_vma clone */
 	if (err)
 		return NULL;
+
+	if (vma_iter_prealloc(vmi))
+		return NULL;
+
+	vma_adjust_trans_huge(vma, vma_start, vma_end, adj_next);
+	init_multi_vma_prep(&vp, vma, adjust, remove, remove2);
+	VM_WARN_ON(vp.anon_vma && adjust && adjust->anon_vma &&
+		   vp.anon_vma != adjust->anon_vma);
+
+	vma_prepare(&vp);
+	if (vma_start < vma->vm_start || vma_end > vma->vm_end)
+		vma_expanded = true;
+
+	vma->vm_start = vma_start;
+	vma->vm_end = vma_end;
+	vma->vm_pgoff = vma_pgoff;
+
+	if (vma_expanded)
+		vma_iter_store(vmi, vma);
+
+	if (adj_next) {
+		adjust->vm_start += adj_next;
+		adjust->vm_pgoff += adj_next >> PAGE_SHIFT;
+		if (adj_next < 0) {
+			WARN_ON(vma_expanded);
+			vma_iter_store(vmi, next);
+		}
+	}
+
+	vma_complete(&vp, vmi, mm);
+	vma_iter_free(vmi);
+	validate_mm(mm);
 	khugepaged_enter_vma(res, vm_flags);
 
 	if (res)
--- a/mm/rmap.c~mm-mmap-remove-__vma_adjust
+++ a/mm/rmap.c
@@ -262,11 +262,12 @@ static inline void unlock_anon_vma_root(
  * Attach the anon_vmas from src to dst.
  * Returns 0 on success, -ENOMEM on failure.
  *
- * anon_vma_clone() is called by __vma_adjust(), __split_vma(), copy_vma() and
- * anon_vma_fork(). The first three want an exact copy of src, while the last
- * one, anon_vma_fork(), may try to reuse an existing anon_vma to prevent
- * endless growth of anon_vma. Since dst->anon_vma is set to NULL before call,
- * we can identify this case by checking (!dst->anon_vma && src->anon_vma).
+ * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vma(),
+ * copy_vma() and anon_vma_fork(). The first four want an exact copy of src,
+ * while the last one, anon_vma_fork(), may try to reuse an existing anon_vma to
+ * prevent endless growth of anon_vma. Since dst->anon_vma is set to NULL before
+ * call, we can identify this case by checking (!dst->anon_vma &&
+ * src->anon_vma).
  *
  * If (!dst->anon_vma && src->anon_vma) is true, this function tries to find
  * and reuse existing anon_vma which has no vmas and only one child anon_vma.
@@ -1253,7 +1254,7 @@ void page_add_anon_rmap(struct page *pag
 		__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
 
 	if (likely(!folio_test_ksm(folio))) {
-		/* address might be in next vma when migration races vma_adjust */
+		/* address might be in next vma when migration races vma_merge */
 		if (first)
 			__page_set_anon_rmap(folio, page, vma, address,
 					     !!(flags & RMAP_EXCLUSIVE));
@@ -2538,7 +2539,7 @@ void hugepage_add_anon_rmap(struct page
 
 	BUG_ON(!folio_test_locked(folio));
 	BUG_ON(!anon_vma);
-	/* address might be in next vma when migration races vma_adjust */
+	/* address might be in next vma when migration races vma_merge */
 	first = atomic_inc_and_test(&folio->_entire_mapcount);
 	VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
 	VM_BUG_ON_PAGE(!first && PageAnonExclusive(page), page);
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

