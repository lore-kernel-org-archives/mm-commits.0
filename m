Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB098C54E76
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbjAFAiF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbjAFAgs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:36:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C542854D84
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:36:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 636A761BC8
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC2BC433D2;
        Fri,  6 Jan 2023 00:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965391;
        bh=59OqVDL5VPtoVDI0HT7ViwmiLKzq3RhKHcFguEBrIqw=;
        h=Date:To:From:Subject:From;
        b=1XmesEqQsXS5Y7E7q8ytcvd449F6CP8Ndi/TXJWXFfa+NLY0eSooT0W3ynfpWg8Mb
         9WrbGTL2Khfa8WmQmQ7PyPf8E6UgnoxrYy93Uhf7N1QzFuTFoVB6Ilc8bnfR7svWQk
         skn/j8juOTsVDrzyAr++TsRtSi0GS3rnq3zE6E3U=
Date:   Thu, 05 Jan 2023 16:36:31 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vma_merge-set-vma-iterator-to-correct-position.patch added to mm-unstable branch
Message-Id: <20230106003631.BBC2BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vma_merge: set vma iterator to correct position
has been added to the -mm mm-unstable branch.  Its filename is
     vma_merge-set-vma-iterator-to-correct-position.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vma_merge-set-vma-iterator-to-correct-position.patch

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
Subject: vma_merge: set vma iterator to correct position
Date: Thu, 5 Jan 2023 19:16:05 +0000

When merging the previous value, set the vma iterator to the previous
slot.  Don't use the vma iterator to get the next/prev so that it is in
the correct position for a write.

Link: https://lkml.kernel.org/r/20230105191517.3099082-45-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mmap.c~vma_merge-set-vma-iterator-to-correct-position
+++ a/mm/mmap.c
@@ -994,6 +994,7 @@ struct vm_area_struct *vma_merge(struct
 		    && can_vma_merge_after(prev, vm_flags, anon_vma, file,
 				   pgoff, vm_userfaultfd_ctx, anon_name)) {
 			merge_prev = true;
+			vma_prev(vmi);
 		}
 	}
 	/* Can we merge the successor? */
@@ -1085,9 +1086,6 @@ struct vm_area_struct *vma_merge(struct
 	validate_mm(mm);
 	khugepaged_enter_vma(res, vm_flags);
 
-	if (res)
-		vma_iter_set(vmi, end);
-
 	return res;
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

