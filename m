Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1E6C53210
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbjAFAfj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbjAFAfV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:35:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4758454D87
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE3E3B81C10
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960A7C433F1;
        Fri,  6 Jan 2023 00:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965314;
        bh=AhBavwymFQDjPs1kRHzXBMR+Zcepr2KW/OngmfI8UQs=;
        h=Date:To:From:Subject:From;
        b=w1fH34puWOox1Uj5vVLT8qBZnH0bqXSTzEARve+BzL8MoKvrLYLARwxhT71e+fOOK
         06rKZla3zAlZNAf+Y50JSAvMamui+6eyG+f5uelX+YvS7O/575lBL+OKcJvTAVM3tO
         PE067y4tS/R1uloOTGkLbOJZSv227Ptg0QDsooX8=
Date:   Thu, 05 Jan 2023 16:35:13 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch added to mm-unstable branch
Message-Id: <20230106003514.960A7C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: remove preallocation from do_mas_align_munmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch

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
Subject: mm/mmap: remove preallocation from do_mas_align_munmap()
Date: Thu, 5 Jan 2023 19:15:55 +0000

In preparation for passing the vma state through split, the pre-allocation
that occurs before the split has to be moved to after.  Since the
preallocation would then live right next to the store, just call store
instead of preallocating.  This effectively restores the potential error
path of splitting and not munmap'ing which pre-dates the maple tree.

Link: https://lkml.kernel.org/r/20230105191517.3099082-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-remove-preallocation-from-do_mas_align_munmap
+++ a/mm/mmap.c
@@ -2388,9 +2388,6 @@ do_mas_align_munmap(struct ma_state *mas
 	mt_init_flags(&mt_detach, MT_FLAGS_LOCK_EXTERN);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
-	if (mas_preallocate(mas, vma, GFP_KERNEL))
-		return -ENOMEM;
-
 	mas->last = end - 1;
 	/*
 	 * If we need to split any vma, do it now to save pain later.
@@ -2481,8 +2478,6 @@ do_mas_align_munmap(struct ma_state *mas
 			goto userfaultfd_error;
 	}
 
-	/* Point of no return */
-	mas_set_range(mas, start, end - 1);
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
 	{
@@ -2490,6 +2485,7 @@ do_mas_align_munmap(struct ma_state *mas
 		struct vm_area_struct *vma_mas, *vma_test;
 		int test_count = 0;
 
+		mas_set_range(mas, start, end - 1);
 		rcu_read_lock();
 		vma_test = mas_find(&test, end - 1);
 		mas_for_each(mas, vma_mas, end - 1) {
@@ -2499,10 +2495,13 @@ do_mas_align_munmap(struct ma_state *mas
 		}
 		rcu_read_unlock();
 		BUG_ON(count != test_count);
-		mas_set_range(mas, start, end - 1);
 	}
 #endif
-	mas_store_prealloc(mas, NULL);
+	/* Point of no return */
+	mas_set_range(mas, start, end - 1);
+	if (mas_store_gfp(mas, NULL, GFP_KERNEL))
+		return -ENOMEM;
+
 	mm->map_count -= count;
 	/*
 	 * Do not downgrade mmap_lock if we are next to VM_GROWSDOWN or
@@ -2534,7 +2533,6 @@ end_split_failed:
 	__mt_destroy(&mt_detach);
 start_split_failed:
 map_count_exceeded:
-	mas_destroy(mas);
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

