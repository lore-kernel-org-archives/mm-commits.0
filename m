Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287F4C76195
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjCUVMg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCUVMc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:12:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47329580C5
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2018B81A37
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AE8C433EF;
        Tue, 21 Mar 2023 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679433127;
        bh=s9EREJTplynCZhPvYmx3CjBv9/yLErTLUs+bowMViC8=;
        h=Date:To:From:Subject:From;
        b=KBbSrPvgJfkzTsD8XmJ4ZUkXeEeO5irLcKS1bbdV/rzFYkj21avU4Zj3yuITMBAyB
         Rx/WZnXdFUDEfGvzHIMGfcn/RaqzeDf9JGAvpZftKPU1AtMChUnCqTPuI/MG3BvIde
         zhkYu+x46YS3eQYgpYrUScIVAhD1ZIEfZuhL3K98=
Date:   Tue, 21 Mar 2023 14:12:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vernon2gm@gmail.com, vbabka@suse.cz, liam.howlett@oracle.com,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch added to mm-unstable branch
Message-Id: <20230321211207.77AE8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: init cleanup, be explicit about the non-mergeable case
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/mmap/vma_merge: init cleanup, be explicit about the non-mergeable case
Date: Tue, 21 Mar 2023 20:45:58 +0000

Reorder the initial variables sensibly and set vma_start and vm_pgoff
there rather than later so all initial values are set at the same time
meaning we don't have to set these later.

Rather than setting err = -1 and only resetting if we hit merge cases,
explicitly check the non-mergeable case to make it abundantly clear that
we only proceed with the rest if something is mergeable, default err to 0
and only update if an error might occur.

Move the merge_prev, merge_next cases closer to the logic determining
curr, next.

This has no functional impact.

Link: https://lkml.kernel.org/r/f5e27d1bb9259b7ef7a45099a838e47fbaaad3ab.1679431180.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   55 ++++++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case
+++ a/mm/mmap.c
@@ -909,18 +909,18 @@ struct vm_area_struct *vma_merge(struct
 			struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 			struct anon_vma_name *anon_name)
 {
-	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
-	pgoff_t vma_pgoff;
 	struct vm_area_struct *curr, *next, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
-	int err = -1;
+	struct vma_prepare vp;
+	int err = 0;
 	bool merge_prev = false;
 	bool merge_next = false;
 	bool vma_expanded = false;
-	struct vma_prepare vp;
+	unsigned long vma_start = prev ? prev->vm_start : addr;
 	unsigned long vma_end = end;
+	pgoff_t vma_pgoff = prev ? prev->vm_pgoff : 0;
+	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	long adj_start = 0;
-	unsigned long vma_start = addr;
 
 	validate_mm(mm);
 	/*
@@ -940,6 +940,23 @@ struct vm_area_struct *vma_merge(struct
 		/* Is there a VMA next to a hole (case 1 - 3) or prev (4)? */
 		next = vma_lookup(mm, end);
 
+	/* Can we merge the predecessor? */
+	if (prev && addr == prev->vm_end && mpol_equal(vma_policy(prev), policy)
+	    && can_vma_merge_after(prev, vm_flags, anon_vma, file,
+				   pgoff, vm_userfaultfd_ctx, anon_name)) {
+		merge_prev = true;
+		vma_prev(vmi);
+	}
+
+	/* Can we merge the successor? */
+	merge_next = next && mpol_equal(policy, vma_policy(next)) &&
+		can_vma_merge_before(next, vm_flags,
+				     anon_vma, file, pgoff+pglen,
+				     vm_userfaultfd_ctx, anon_name);
+
+	if (!merge_prev && !merge_next)
+		return NULL; /* Not mergeable. */
+
 	/*
 	 * By default, we return prev. Cases 3, 4, 8 will instead return next
 	 * and cases 3, 8 will also update vma to point at next.
@@ -951,26 +968,6 @@ struct vm_area_struct *vma_merge(struct
 	VM_WARN_ON(curr && (addr != curr->vm_start || end > curr->vm_end));
 	VM_WARN_ON(addr >= end);
 
-	if (prev) {
-		vma_start = prev->vm_start;
-		vma_pgoff = prev->vm_pgoff;
-		/* Can we merge the predecessor? */
-		if (prev->vm_end == addr && mpol_equal(vma_policy(prev), policy)
-		    && can_vma_merge_after(prev, vm_flags, anon_vma, file,
-				   pgoff, vm_userfaultfd_ctx, anon_name)) {
-			merge_prev = true;
-			vma_prev(vmi);
-		}
-	}
-
-	/* Can we merge the successor? */
-	if (next && mpol_equal(policy, vma_policy(next)) &&
-	    can_vma_merge_before(next, vm_flags,
-				 anon_vma, file, pgoff+pglen,
-				 vm_userfaultfd_ctx, anon_name)) {
-		merge_next = true;
-	}
-
 	remove = remove2 = adjust = NULL;
 	/* Can we merge both the predecessor and the successor? */
 	if (merge_prev && merge_next &&
@@ -985,7 +982,7 @@ struct vm_area_struct *vma_merge(struct
 				err = dup_anon_vma(prev, curr);
 		}
 	} else if (merge_prev) {
-		err = 0;				/* case 2 */
+							/* case 2 */
 		if (curr) {
 			err = dup_anon_vma(prev, curr);
 			if (end == curr->vm_end) {	/* case 7 */
@@ -995,7 +992,7 @@ struct vm_area_struct *vma_merge(struct
 				adj_start = (end - curr->vm_start);
 			}
 		}
-	} else if (merge_next) {
+	} else { /* merge_next */
 		res = next;
 		if (prev && addr < prev->vm_end) {	/* case 4 */
 			vma_end = addr;
@@ -1011,7 +1008,7 @@ struct vm_area_struct *vma_merge(struct
 			vma_start = addr;
 			vma_end = next->vm_end;
 			vma_pgoff = next->vm_pgoff;
-			err = 0;
+
 			if (curr) {			/* case 8 */
 				vma_pgoff = curr->vm_pgoff;
 				remove = curr;
@@ -1020,7 +1017,7 @@ struct vm_area_struct *vma_merge(struct
 		}
 	}
 
-	/* Cannot merge or error in anon_vma clone */
+	/* Error in anon_vma clone. */
 	if (err)
 		return NULL;
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch
mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
mm-vmalloc-use-rwsem-mutex-for-vmap_area_lock-and-vmap_block-lock.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
mm-vmalloc-convert-vread-to-vread_iter.patch
maintainers-add-myself-as-vmalloc-reviewer.patch
mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch
mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch
mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch
mm-mmap-vma_merge-init-cleanup-be-explicit-about-the-non-mergeable-case.patch

