Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F0BC54EBF
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbjAFAgM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235905AbjAFAf7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:35:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C0B54728
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AA0F9CE1BDA
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F0AC433D2;
        Fri,  6 Jan 2023 00:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965340;
        bh=T8Mhu1lpeL9Kk3E0P9GccS1b3+iWqllLNOXdn7JhARk=;
        h=Date:To:From:Subject:From;
        b=jmuYDBjb3qTRl7RtZ8k3ELVPZt/i4vlutsx/hQ1hmYuzH9fEiuWOu+0Gqhjzam7TK
         wdNXg6rYJNyENeLarZgKrknwjPUDcCqNflSK/mJed0n/QGZth2lqe37DnxwWJuglmj
         LejpAd3hDhc/8GzNfZKRpEDK1mvRj8QMvFQyAkN8=
Date:   Thu, 05 Jan 2023 16:35:39 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch added to mm-unstable branch
Message-Id: <20230106003539.E1F0AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: madvise: use vmi iterator for __split_vma() and vma_merge()
has been added to the -mm mm-unstable branch.  Its filename is
     madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch

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
Subject: madvise: use vmi iterator for __split_vma() and vma_merge()
Date: Thu, 5 Jan 2023 19:15:58 +0000

Use the vma iterator so that the iterator can be invalidated or updated
to avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230105191517.3099082-22-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~madvise-use-vmi-iterator-for-__split_vma-and-vma_merge
+++ a/mm/madvise.c
@@ -142,6 +142,7 @@ static int madvise_update_vma(struct vm_
 	struct mm_struct *mm = vma->vm_mm;
 	int error;
 	pgoff_t pgoff;
+	VMA_ITERATOR(vmi, mm, 0);
 
 	if (new_flags == vma->vm_flags && anon_vma_name_eq(anon_vma_name(vma), anon_name)) {
 		*prev = vma;
@@ -149,8 +150,8 @@ static int madvise_update_vma(struct vm_
 	}
 
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
-	*prev = vma_merge(mm, *prev, start, end, new_flags, vma->anon_vma,
-			  vma->vm_file, pgoff, vma_policy(vma),
+	*prev = vmi_vma_merge(&vmi, mm, *prev, start, end, new_flags,
+			  vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
 			  vma->vm_userfaultfd_ctx, anon_name);
 	if (*prev) {
 		vma = *prev;
@@ -162,7 +163,7 @@ static int madvise_update_vma(struct vm_
 	if (start != vma->vm_start) {
 		if (unlikely(mm->map_count >= sysctl_max_map_count))
 			return -ENOMEM;
-		error = __split_vma(mm, vma, start, 1);
+		error = vmi__split_vma(&vmi, mm, vma, start, 1);
 		if (error)
 			return error;
 	}
@@ -170,7 +171,7 @@ static int madvise_update_vma(struct vm_
 	if (end != vma->vm_end) {
 		if (unlikely(mm->map_count >= sysctl_max_map_count))
 			return -ENOMEM;
-		error = __split_vma(mm, vma, end, 0);
+		error = vmi__split_vma(&vmi, mm, vma, end, 0);
 		if (error)
 			return error;
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

