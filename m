Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9498EC53210
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbjAFAiE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbjAFAgr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEC9633AA
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C89FB81B07
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1279C433D2;
        Fri,  6 Jan 2023 00:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965386;
        bh=WBMWhHc0L4s2UlwxhOLYJdBtEvc3Jrgtuci10+Iv+Ok=;
        h=Date:To:From:Subject:From;
        b=WL1K9CeNRfYxCYlsn5hL4IPcWggFq3i92JGrqjpQy28CFye3wU0GpsQH60P1+9fa+
         AKTo8houxbE8F4bCnpSj6qbjii5X8tJXQUR8W76q1408bJhycdo7gZj5URxZGbiYVs
         DBzRIB/3Pm6Ka9yonPXYjEwS+uIG6VI+R+7Pu+Rs=
Date:   Thu, 05 Jan 2023 16:36:26 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch added to mm-unstable branch
Message-Id: <20230106003626.D1279C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: convert do_brk_flags() to use vma_prepare() and vma_complete()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch

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
Subject: mm/mmap: convert do_brk_flags() to use vma_prepare() and vma_complete()
Date: Thu, 5 Jan 2023 19:16:05 +0000

Use the abstracted vma locking for do_brk_flags()

Link: https://lkml.kernel.org/r/20230105191517.3099082-43-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete
+++ a/mm/mmap.c
@@ -2983,6 +2983,7 @@ static int do_brk_flags(struct vma_itera
 		unsigned long addr, unsigned long len, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
+	struct vma_prepare vp;
 
 	validate_mm_mt(mm);
 	/*
@@ -3010,18 +3011,13 @@ static int do_brk_flags(struct vma_itera
 			goto unacct_fail;
 
 		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
-		if (vma->anon_vma) {
-			anon_vma_lock_write(vma->anon_vma);
-			anon_vma_interval_tree_pre_update_vma(vma);
-		}
+		init_vma_prep(&vp, vma);
+		vma_prepare(&vp);
 		vma->vm_end = addr + len;
 		vma->vm_flags |= VM_SOFTDIRTY;
 		vma_iter_store(vmi, vma);
 
-		if (vma->anon_vma) {
-			anon_vma_interval_tree_post_update_vma(vma);
-			anon_vma_unlock_write(vma->anon_vma);
-		}
+		vma_complete(&vp, vmi, mm);
 		khugepaged_enter_vma(vma, flags);
 		goto out;
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

