Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35202C4708E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbjAFAgk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbjAFAgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C163E5F4A8
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C7BB61C39
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0088C433EF;
        Fri,  6 Jan 2023 00:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965345;
        bh=xTPo+WVRmq0OwEe/7uhok8DABkHAt//yahMgKW3QzCA=;
        h=Date:To:From:Subject:From;
        b=cCqZd4/HbeY2pT2yXgiDnMAgwgt2fa7tk43aH3yIAgXAM4nBDbdeQ1DtFZNPauwaA
         K3sQNWagLO5b/+1uDO+C8skFVZSzXsZncuB7yPJkKGKj8A+Hq3HIzMX1p7i7Rbt3BI
         OqbFKPsKMtM28ZyookTL06EaYiPgrfqsZCXYs/ck=
Date:   Thu, 05 Jan 2023 16:35:44 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-use-vmi-version-of-vma_merge.patch added to mm-unstable branch
Message-Id: <20230106003545.A0088C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: use vmi version of vma_merge()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-use-vmi-version-of-vma_merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-use-vmi-version-of-vma_merge.patch

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
Subject: mm/mremap: use vmi version of vma_merge()
Date: Thu, 5 Jan 2023 19:15:59 +0000

Use the vma iterator so that the iterator can be invalidated or updated
to avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230105191517.3099082-25-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-vmi-version-of-vma_merge
+++ a/mm/mremap.c
@@ -1018,6 +1018,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			unsigned long extension_end = addr + new_len;
 			pgoff_t extension_pgoff = vma->vm_pgoff +
 				((extension_start - vma->vm_start) >> PAGE_SHIFT);
+			VMA_ITERATOR(vmi, mm, extension_start);
 
 			if (vma->vm_flags & VM_ACCOUNT) {
 				if (security_vm_enough_memory_mm(mm, pages)) {
@@ -1033,10 +1034,10 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			 * with the next vma if it becomes adjacent to the expanded vma and
 			 * otherwise compatible.
 			 */
-			vma = vma_merge(mm, vma, extension_start, extension_end,
-					vma->vm_flags, vma->anon_vma, vma->vm_file,
-					extension_pgoff, vma_policy(vma),
-					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			vma = vmi_vma_merge(&vmi, mm, vma, extension_start,
+				extension_end, vma->vm_flags, vma->anon_vma,
+				vma->vm_file, extension_pgoff, vma_policy(vma),
+				vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
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

