Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03341C53210
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbjAFAgJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236434AbjAFAfi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:35:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9015559C3
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 738C1B81C10
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2785FC433EF;
        Fri,  6 Jan 2023 00:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965332;
        bh=mL1Wvey9NUMU/WBcTpGgZptpnWzlU4DtvBP3yBg6+Fw=;
        h=Date:To:From:Subject:From;
        b=q9FHdjazcV+fb0EUaN1vSf2L2bOVt6+7v7P5DfZmYTTerWPMUbYw8tOQCzkv7+K5R
         6i//AftR3rVxJo1FTwMB5mtpug/J4rAtncD/v4Ns6+N281PinHkCYvGEapQJe2TDbk
         23JfdbVrkeW0y9SIwm90P/mcy4XH6K9Yix3OxQrQ=
Date:   Thu, 05 Jan 2023 16:35:31 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + coredump-convert-to-vma-iterator.patch added to mm-unstable branch
Message-Id: <20230106003532.2785FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: convert to vma iterator
has been added to the -mm mm-unstable branch.  Its filename is
     coredump-convert-to-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coredump-convert-to-vma-iterator.patch

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
Subject: coredump: convert to vma iterator
Date: Thu, 5 Jan 2023 19:15:57 +0000

Use the vma iterator so that the iterator can be invalidated or updated
to avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230105191517.3099082-18-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/coredump.c~coredump-convert-to-vma-iterator
+++ a/fs/coredump.c
@@ -1111,14 +1111,14 @@ whole:
  * Helper function for iterating across a vma list.  It ensures that the caller
  * will visit `gate_vma' prior to terminating the search.
  */
-static struct vm_area_struct *coredump_next_vma(struct ma_state *mas,
+static struct vm_area_struct *coredump_next_vma(struct vma_iterator *vmi,
 				       struct vm_area_struct *vma,
 				       struct vm_area_struct *gate_vma)
 {
 	if (gate_vma && (vma == gate_vma))
 		return NULL;
 
-	vma = mas_next(mas, ULONG_MAX);
+	vma = vma_next(vmi);
 	if (vma)
 		return vma;
 	return gate_vma;
@@ -1146,7 +1146,7 @@ static bool dump_vma_snapshot(struct cor
 {
 	struct vm_area_struct *gate_vma, *vma = NULL;
 	struct mm_struct *mm = current->mm;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 	int i = 0;
 
 	/*
@@ -1167,7 +1167,7 @@ static bool dump_vma_snapshot(struct cor
 		return false;
 	}
 
-	while ((vma = coredump_next_vma(&mas, vma, gate_vma)) != NULL) {
+	while ((vma = coredump_next_vma(&vmi, vma, gate_vma)) != NULL) {
 		struct core_vma_metadata *m = cprm->vma_meta + i;
 
 		m->start = vma->vm_start;
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

