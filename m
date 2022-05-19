Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF12C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 02:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiESCjs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 22:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiESCjr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 22:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA428FFB2
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 19:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A72960C8C
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 02:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCEBC385A5;
        Thu, 19 May 2022 02:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652927985;
        bh=ssH2hkOVZsJJ7uAzi/RWlEn+2A/obbRxf12O8WsneCk=;
        h=Date:To:From:Subject:From;
        b=xKmJOprt+iT4NkO//xLu0F3bkWCQLRcYyFdaqSl9HpOKASFPuImlSr+0UBPTfqJTI
         aTgy9nQwvTkkg1Y275YIoxCohwrmDfbF+dk85bwO6M2y8m69Hcktn8RpfxR5yIuECw
         a0L92TZV88A5p2cfKQz/NhZe57nkAbnQ/AGS2gJs=
Date:   Wed, 18 May 2022 19:39:45 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20220519023945.CDCEBC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes
Date: Wed May 18 07:37:00 PM PDT 2022

reflow comments, fix comment leadin

Cc: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes
+++ a/mm/mmap.c
@@ -1879,16 +1879,20 @@ cannot_expand:
 		addr = vma->vm_start;
 		mas_reset(&mas);
 
-		/* If vm_flags changed after call_mmap(), we should try merge vma again
-		 * as we may succeed this time.
+		/*
+		 * If vm_flags changed after call_mmap(), we should try merge
+		 * vma again as we may succeed this time.
 		 */
 		if (unlikely(vm_flags != vma->vm_flags && prev)) {
 			merge = vma_merge(mm, prev, vma->vm_start, vma->vm_end, vma->vm_flags,
 				NULL, vma->vm_file, vma->vm_pgoff, NULL, NULL_VM_UFFD_CTX, NULL);
 			if (merge) {
-				/* ->mmap() can change vma->vm_file and fput the original file. So
-				 * fput the vma->vm_file here or we would add an extra fput for file
-				 * and cause general protection fault ultimately.
+				/*
+				 * ->mmap() can change vma->vm_file and fput
+				 * the original file. So fput the vma->vm_file
+				 * here or we would add an extra fput for file
+				 * and cause general protection fault
+				 * ultimately.
 				 */
 				fput(vma->vm_file);
 				vm_area_free(vma);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch
mm-swap-add-helper-swap_offset_available-fix.patch
mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

