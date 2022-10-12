Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DB6C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 00:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiJLALw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 20:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiJLALv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 20:11:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1468604B2
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 17:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 448A86130E
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 00:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C7BC433D6;
        Wed, 12 Oct 2022 00:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665533507;
        bh=bVTjcDksuxRBL2xKvZJrL5RNQq3lMtHbnhFY4TE95pM=;
        h=Date:To:From:Subject:From;
        b=SGa5qtxOp0fXUfJc2b/+YX3FzZ6KuGyZjBo3A8y5M2Y+M2kO3uzRjrskCVpZBfUED
         MXFAHR8wPyK6nQz2B0DczlB3YB2QzDUhmbycQvRuhvN6TEpCVbI6Oj6KwhMNPtpNl6
         HaRugOZ7wkTWY6SWlDrPI+jzUVeQzzKLWQfVx3Xw=
Date:   Tue, 11 Oct 2022 17:11:46 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-preallocate-maple-nodes-for-brk-vma-expansion.patch added to mm-unstable branch
Message-Id: <20221012001147.92C7BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: preallocate maple nodes for brk vma expansion
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-preallocate-maple-nodes-for-brk-vma-expansion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-preallocate-maple-nodes-for-brk-vma-expansion.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: preallocate maple nodes for brk vma expansion
Date: Tue, 11 Oct 2022 16:08:37 +0000

If the brk VMA is the last vma in a maple node and meets the rare criteria
that it can be expanded, then preallocation is necessary to avoid a
potential fs_reclaim circular lock issue on low resources.

At the same time use the actual vma start address (unaligned) when calling
vma_adjust_trans_huge().

Link: https://lkml.kernel.org/r/20221011160624.1253454-1-Liam.Howlett@oracle.com
Fixes: 2e7ce7d354f2 (mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap())
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/mm/mmap.c~mm-mmap-preallocate-maple-nodes-for-brk-vma-expansion
+++ a/mm/mmap.c
@@ -2942,17 +2942,18 @@ static int do_brk_flags(struct ma_state
 	if (vma &&
 	    (!vma->anon_vma || list_is_singular(&vma->anon_vma_chain)) &&
 	    ((vma->vm_flags & ~VM_SOFTDIRTY) == flags)) {
-		mas->index = vma->vm_start;
-		mas->last = addr + len - 1;
-		vma_adjust_trans_huge(vma, addr, addr + len, 0);
+		mas_set_range(mas, vma->vm_start, addr + len - 1);
+		if (mas_preallocate(mas, vma, GFP_KERNEL))
+			return -ENOMEM;
+
+		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
 		if (vma->anon_vma) {
 			anon_vma_lock_write(vma->anon_vma);
 			anon_vma_interval_tree_pre_update_vma(vma);
 		}
 		vma->vm_end = addr + len;
 		vma->vm_flags |= VM_SOFTDIRTY;
-		if (mas_store_gfp(mas, vma, GFP_KERNEL))
-			goto mas_expand_failed;
+		mas_store_prealloc(mas, vma);
 
 		if (vma->anon_vma) {
 			anon_vma_interval_tree_post_update_vma(vma);
@@ -2993,13 +2994,6 @@ mas_store_fail:
 vma_alloc_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
 	return -ENOMEM;
-
-mas_expand_failed:
-	if (vma->anon_vma) {
-		anon_vma_interval_tree_post_update_vma(vma);
-		anon_vma_unlock_write(vma->anon_vma);
-	}
-	return -ENOMEM;
 }
 
 int vm_brk_flags(unsigned long addr, unsigned long request, unsigned long flags)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mmap-fix-copy_vma-failure-path.patch
mm-mmap-preallocate-maple-nodes-for-brk-vma-expansion.patch

