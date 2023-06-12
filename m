Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E34C7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbjFLV2S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbjFLV1i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:27:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B4EE4A
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7311562277
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DE9C433EF;
        Mon, 12 Jun 2023 21:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605249;
        bh=NB4YiCJ6oMHk0geOqYZNJO79aCwfKEK65RbYQ9wIySQ=;
        h=Date:To:From:Subject:From;
        b=ZvCtm5DVH2IJb9adMIJRLHQcy3vLJ7FRQy/gy2lKQJ46LZvtaUObjsdefbY2wlT7k
         2GR+x/EWuxKimT6S0/5UwOyQzNWkOsGumkomhmlFgxY/xwK8zHZkWzAiDF4A9a13A3
         jwYXsXUGpAGJLGFJ24RAnG87W2OixWc/12c0Wx08=
Date:   Mon, 12 Jun 2023 14:27:29 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-vma_iter_clear_gfp-in-nommu.patch added to mm-unstable branch
Message-Id: <20230612212729.C5DE9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vma_iter_clear_gfp() in nommu
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-vma_iter_clear_gfp-in-nommu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-vma_iter_clear_gfp-in-nommu.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: use vma_iter_clear_gfp() in nommu
Date: Mon, 12 Jun 2023 16:39:47 -0400

Move the definition of vma_iter_clear_gfp() from mmap.c to internal.h so
it can be used in the nommu code.  This will reduce node preallocations in
nommu.

Link: https://lkml.kernel.org/r/20230612203953.2093911-11-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   12 ++++++++++++
 mm/mmap.c     |   12 ------------
 mm/nommu.c    |   12 ++++--------
 3 files changed, 16 insertions(+), 20 deletions(-)

--- a/mm/internal.h~mm-use-vma_iter_clear_gfp-in-nommu
+++ a/mm/internal.h
@@ -1053,6 +1053,18 @@ static inline void vma_iter_clear(struct
 	mas_store_prealloc(&vmi->mas, NULL);
 }
 
+static inline int vma_iter_clear_gfp(struct vma_iterator *vmi,
+			unsigned long start, unsigned long end, gfp_t gfp)
+{
+	vmi->mas.index = start;
+	vmi->mas.last = end - 1;
+	mas_store_gfp(&vmi->mas, NULL, gfp);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
+
 static inline struct vm_area_struct *vma_iter_load(struct vma_iterator *vmi)
 {
 	return mas_walk(&vmi->mas);
--- a/mm/mmap.c~mm-use-vma_iter_clear_gfp-in-nommu
+++ a/mm/mmap.c
@@ -154,18 +154,6 @@ static inline struct vm_area_struct *vma
 	return mas_prev(&vmi->mas, min);
 }
 
-static inline int vma_iter_clear_gfp(struct vma_iterator *vmi,
-			unsigned long start, unsigned long end, gfp_t gfp)
-{
-	vmi->mas.index = start;
-	vmi->mas.last = end - 1;
-	mas_store_gfp(&vmi->mas, NULL, gfp);
-	if (unlikely(mas_is_err(&vmi->mas)))
-		return -ENOMEM;
-
-	return 0;
-}
-
 /*
  * check_brk_limits() - Use platform specific check of range & verify mlock
  * limits.
--- a/mm/nommu.c~mm-use-vma_iter_clear_gfp-in-nommu
+++ a/mm/nommu.c
@@ -1383,17 +1383,13 @@ static int vmi_shrink_vma(struct vma_ite
 
 	/* adjust the VMA's pointers, which may reposition it in the MM's tree
 	 * and list */
-	if (vma_iter_prealloc(vmi)) {
-		pr_warn("Allocation of vma tree for process %d failed\n",
-		       current->pid);
-		return -ENOMEM;
-	}
-
 	if (from > vma->vm_start) {
-		vma_iter_clear(vmi, from, vma->vm_end);
+		if (vma_iter_clear_gfp(vmi, from, vma->vm_end, GFP_KERNEL))
+			return -ENOMEM;
 		vma->vm_end = from;
 	} else {
-		vma_iter_clear(vmi, vma->vm_start, to);
+		if (vma_iter_clear_gfp(vmi, vma->vm_start, to, GFP_KERNEL))
+			return -ENOMEM;
 		vma->vm_start = to;
 	}
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

