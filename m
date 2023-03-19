Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B594C6FD1F
	for <mm-commits@archiver.kernel.org>; Sun, 19 Mar 2023 20:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjCSUSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Mar 2023 16:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCSUR4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 19 Mar 2023 16:17:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DE81B552
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 13:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BC7DB80CAA
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 20:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2232CC433EF;
        Sun, 19 Mar 2023 20:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679257072;
        bh=2wX5YdDGyQAczygQlex+Pa0tJ5u+0rmGGQlGLADkfqk=;
        h=Date:To:From:Subject:From;
        b=cG+opKnxnLJ3FYLf+drWudjNXHMLH2JxaZbsIbxZ7hT6mx/I3J9YosbgVMJiXxM78
         6abFPSMxVQIaq7sQLVDIolutijpTSGLpkky7Fijevguu8as7LTL0KaJD7GTjWn7dMp
         im4MKzJq1f/POTFhKys1I2HyXc+I26jqpS52rbwk=
Date:   Sun, 19 Mar 2023 13:17:51 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch added to mm-unstable branch
Message-Id: <20230319201752.2232CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: set next to NULL if not applicable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch

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
Subject: mm/mmap/vma_merge: set next to NULL if not applicable
Date: Sat, 18 Mar 2023 11:13:19 +0000

We are only interested in next if end == next->vm_start (in which case we
check to see if we can set merge_next), so perform this check alongside
checking whether curr should be set.

This groups all of the simple range checks together and establishes the
invariant that, if prev, curr or next are non-NULL then their positions
are as expected.

Additionally, use the abstract 'vma' object to look up the possible curr
or next VMA in order to avoid any confusion as to what these variables
represent - now curr and next are assigned once and only once.

This has no functional impact.

Link: https://lkml.kernel.org/r/4d717269303d8a6fe1d837968c252eeb6ff1d7e5.1679137163.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-vma_merge-set-next-to-null-if-not-applicable
+++ a/mm/mmap.c
@@ -930,15 +930,53 @@ struct vm_area_struct *vma_merge(struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
-	curr = find_vma(mm, prev ? prev->vm_end : 0);
-	if (curr && curr->vm_end == end)		/* cases 6, 7, 8 */
-		next = find_vma(mm, curr->vm_end);
-	else
-		next = curr;
+	/*
+	 * If there is a previous VMA specified, find the next, otherwise find
+	 * the first.
+	 */
+	vma = find_vma(mm, prev ? prev->vm_end : 0);
+
+	/*
+	 * Does the input range span an existing VMA? If so, we designate this
+	 * VMA 'curr'. The caller will have ensured that curr->vm_start == addr.
+	 *
+	 * Cases 5 - 8.
+	 */
+	if (vma && end > vma->vm_start) {
+		curr = vma;
 
-	/* In cases 1 - 4 there's no CCCC vma */
-	if (curr && end <= curr->vm_start)
+		/*
+		 * If the addr - end range spans this VMA entirely, then we
+		 * check to see if another VMA follows it.
+		 *
+		 * If it is _immediately_ adjacent (checked below), then we
+		 * designate it 'next' (cases 6 - 8).
+		 */
+		if (curr->vm_end == end)
+			vma = find_vma(mm, curr->vm_end);
+		else
+			/* Case 5. */
+			vma = NULL;
+	} else {
+		/*
+		 * The addr - end range either spans the end of prev or spans no
+		 * VMA at all - in either case we dispense with 'curr' and
+		 * maintain only 'prev' and (possibly) 'next'.
+		 *
+		 * Cases 1 - 4.
+		 */
 		curr = NULL;
+	}
+
+	/*
+	 * We only actually examine the next VMA if it is immediately adjacent
+	 * to end which sits either at the end of a hole (cases 1 - 3), PPPP
+	 * (case 4) or CCCC (cases 6 - 8).
+	 */
+	if (vma && end == vma->vm_start)
+		next = vma;
+	else
+		next = NULL;
 
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
@@ -959,11 +997,10 @@ struct vm_area_struct *vma_merge(struct
 		}
 	}
 	/* Can we merge the successor? */
-	if (next && end == next->vm_start &&
-			mpol_equal(policy, vma_policy(next)) &&
-			can_vma_merge_before(next, vm_flags,
-					     anon_vma, file, pgoff+pglen,
-					     vm_userfaultfd_ctx, anon_name)) {
+	if (next && mpol_equal(policy, vma_policy(next)) &&
+	    can_vma_merge_before(next, vm_flags,
+				 anon_vma, file, pgoff+pglen,
+				 vm_userfaultfd_ctx, anon_name)) {
 		merge_next = true;
 	}
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch
mm-prefer-xxx_page-alloc-free-functions-for-order-0-pages.patch
mm-refactor-do_fault_around.patch
mm-pefer-fault_around_pages-to-fault_around_bytes.patch
mm-mmap-vma_merge-further-improve-prev-next-vma-naming.patch
mm-mmap-vma_merge-set-next-to-null-if-not-applicable.patch
mm-mmap-vma_merge-extend-invariants-avoid-invalid-res-vma.patch
mm-mmap-vma_merge-be-explicit-about-the-non-mergeable-case.patch
fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch
mm-vmalloc-use-rwsem-mutex-for-vmap_area_lock-and-vmap_block-lock.patch
fs-proc-kcore-convert-read_kcore-to-read_kcore_iter.patch
mm-vmalloc-convert-vread-to-vread_iter.patch

