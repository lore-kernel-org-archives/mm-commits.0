Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8687C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCUVMc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCUVMb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:12:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440CA58B54
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E590BB816ED
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E70DC433EF;
        Tue, 21 Mar 2023 21:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679433125;
        bh=/pAS7Q2DxWdwRXyKaa3//7UoDSMB8YU6bPFKx9HRM+c=;
        h=Date:To:From:Subject:From;
        b=rmPRG6tq3lmaNhxIEVbDTfxV4rYdH3ocjuwG8PdLcRxKiP2wQeIILF7+mNFHLxJgj
         7etsJPvg4LBG+hWzDu/7srVXaHEzKiOvlfI1ABXI7nel0tASgJWNuAuvQkeoWlrw+t
         rfPSDmPmgNEstqHjx3SXtPHJCw+NMqFtC6C/mjfg=
Date:   Tue, 21 Mar 2023 14:12:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vernon2gm@gmail.com, vbabka@suse.cz, liam.howlett@oracle.com,
        david@redhat.com, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch added to mm-unstable branch
Message-Id: <20230321211205.7E70DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: extend invariants, avoid invalid res, vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch

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
Subject: mm/mmap/vma_merge: extend invariants, avoid invalid res, vma
Date: Tue, 21 Mar 2023 20:45:57 +0000

Previously, vma was an uninitialised variable which was only definitely
assigned as a result of the logic covering all possible input cases - for
it to have remained uninitialised, prev would have to be NULL, and next
would _have_ to be mergeable.

We now reuse vma to assign curr and next, so to be absolutely explicit,
ensure this variable is _always_ assigned, and while we're at it remove
the redundant assignment of both res and vma (if prev is NULL then we
simply assign to NULL).

In addition, we absolutely do rely on addr == curr->vm_start should curr
exist, so assert as much.

Link: https://lkml.kernel.org/r/17b6fc3edc46c4b33aa93b9ef17a63a3a76f4b5f.1679431180.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma
+++ a/mm/mmap.c
@@ -911,7 +911,7 @@ struct vm_area_struct *vma_merge(struct
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	pgoff_t vma_pgoff;
-	struct vm_area_struct *curr, *next, *res = NULL;
+	struct vm_area_struct *curr, *next, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
 	int err = -1;
 	bool merge_prev = false;
@@ -940,14 +940,18 @@ struct vm_area_struct *vma_merge(struct
 		/* Is there a VMA next to a hole (case 1 - 3) or prev (4)? */
 		next = vma_lookup(mm, end);
 
-	/* verify some invariant that must be enforced by the caller */
+	/*
+	 * By default, we return prev. Cases 3, 4, 8 will instead return next
+	 * and cases 3, 8 will also update vma to point at next.
+	 */
+	res = vma = prev;
+
+	/* Verify some invariant that must be enforced by the caller. */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
-	VM_WARN_ON(curr && end > curr->vm_end);
+	VM_WARN_ON(curr && (addr != curr->vm_start || end > curr->vm_end));
 	VM_WARN_ON(addr >= end);
 
 	if (prev) {
-		res = prev;
-		vma = prev;
 		vma_start = prev->vm_start;
 		vma_pgoff = prev->vm_pgoff;
 		/* Can we merge the predecessor? */
@@ -958,6 +962,7 @@ struct vm_area_struct *vma_merge(struct
 			vma_prev(vmi);
 		}
 	}
+
 	/* Can we merge the successor? */
 	if (next && mpol_equal(policy, vma_policy(next)) &&
 	    can_vma_merge_before(next, vm_flags,
@@ -998,6 +1003,10 @@ struct vm_area_struct *vma_merge(struct
 			adj_start = -(prev->vm_end - addr);
 			err = dup_anon_vma(next, prev);
 		} else {
+			/*
+			 * Note that cases 3 and 8 are the ONLY ones where prev
+			 * is permitted to be (but is not necessarily) NULL.
+			 */
 			vma = next;			/* case 3 */
 			vma_start = addr;
 			vma_end = next->vm_end;
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

