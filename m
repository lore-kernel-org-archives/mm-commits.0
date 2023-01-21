Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C17C05027
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjAUBH1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjAUBHG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:07:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11A173177
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:07:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5C6DECE1F9A
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967EFC433D2;
        Sat, 21 Jan 2023 01:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263221;
        bh=kcZGKUb6uX9viXdBhZQTkTunZhMU0rajMdjmu0523r4=;
        h=Date:To:From:Subject:From;
        b=XOEC41NkXiGfesDf9vNX4fCuB5BxIo4UmogOnjlpo9WBynwIm2K1hGQKiXBZDLjU3
         uTsmW70FNKlVGj/2B+mToK/7l0h0qy20ZOe8TqZecTDVD/CKbnIFc35PueQiFG2Uwv
         Gk5FWfq4tuBwmvp5tjCMZUt0pkaYO/HZDoKJpRUs=
Date:   Fri, 20 Jan 2023 17:07:00 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + madvise-use-split_vma-instead-of-__split_vma.patch added to mm-unstable branch
Message-Id: <20230121010701.967EFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: madvise: use split_vma() instead of __split_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     madvise-use-split_vma-instead-of-__split_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/madvise-use-split_vma-instead-of-__split_vma.patch

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
Subject: madvise: use split_vma() instead of __split_vma()
Date: Fri, 20 Jan 2023 11:26:34 -0500

The split_vma() wrapper is specifically for this use case, so use it.

Link: https://lkml.kernel.org/r/20230120162650.984577-34-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/madvise.c~madvise-use-split_vma-instead-of-__split_vma
+++ a/mm/madvise.c
@@ -161,17 +161,13 @@ static int madvise_update_vma(struct vm_
 	*prev = vma;
 
 	if (start != vma->vm_start) {
-		if (unlikely(mm->map_count >= sysctl_max_map_count))
-			return -ENOMEM;
-		error = __split_vma(&vmi, vma, start, 1);
+		error = split_vma(&vmi, vma, start, 1);
 		if (error)
 			return error;
 	}
 
 	if (end != vma->vm_end) {
-		if (unlikely(mm->map_count >= sysctl_max_map_count))
-			return -ENOMEM;
-		error = __split_vma(&vmi, vma, end, 0);
+		error = split_vma(&vmi, vma, end, 0);
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

