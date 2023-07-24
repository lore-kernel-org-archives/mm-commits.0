Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16155C001DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 19:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjGXS77 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 14:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjGXS75 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 14:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1589610F5
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 11:59:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90A77613CA
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 18:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D069EC433C7;
        Mon, 24 Jul 2023 18:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225185;
        bh=cRy4xzNLt56eft0RZOCe+2slhmGpBRgZx30rgYbrSzs=;
        h=Date:To:From:Subject:From;
        b=xP/P46v6cMpXU5c4OqwsqXTdGfavV4I2xeSjM/NmUbPJmBkvoJBzzi9qSDZtnS30c
         NEqYWoYpbL8TcmzR+2bCtpV02SwPcqh6MGLJ6/0UQ+C1a18SH2s6Z/FyDWXIkvu4y0
         XC4lF/W2zhdbU1vmY8WEetF0K9GKx5N/6kbcMlpc=
Date:   Mon, 24 Jul 2023 11:59:45 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch added to mm-unstable branch
Message-Id: <20230724185945.D069EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: change vma iteration order in do_vmi_align_munmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

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
Subject: mm/mmap: change vma iteration order in do_vmi_align_munmap()
Date: Mon, 24 Jul 2023 14:31:57 -0400

By delaying the setting of prev/next VMA until after the write of NULL,
the probability of the prev/next VMA already being in the CPU cache is
significantly increased, especially for larger munmap operations.  It
also means that prev/next will be loaded closer to when they are used.

This requires changing the loop type when gathering the VMAs that will
be freed.

Since prev will be set later in the function, it is better to reverse
the splitting direction of the start VMA (modify the new_below argument
to __split_vma).

Using the vma_iter_prev_range() to walk back to the correct location in
the tree will, on the most part, mean walking within the CPU cache.
Usually, this is two steps vs a node reset and a tree re-walk.

Link: https://lkml.kernel.org/r/20230724183157.3939892-16-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/mmap.c~mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap
+++ a/mm/mmap.c
@@ -2452,20 +2452,17 @@ do_vmi_align_munmap(struct vma_iterator
 		if (end < vma->vm_end && mm->map_count >= sysctl_max_map_count)
 			goto map_count_exceeded;
 
-		error = __split_vma(vmi, vma, start, 0);
+		error = __split_vma(vmi, vma, start, 1);
 		if (error)
 			goto start_split_failed;
-
-		vma = vma_iter_load(vmi);
 	}
 
-	prev = vma_prev(vmi);
-
 	/*
 	 * Detach a range of VMAs from the mm. Using next as a temp variable as
 	 * it is always overwritten.
 	 */
-	for_each_vma_range(*vmi, next, end) {
+	next = vma;
+	do {
 		/* Does it split the end? */
 		if (next->vm_end > end) {
 			error = __split_vma(vmi, next, end, 0);
@@ -2501,13 +2498,7 @@ do_vmi_align_munmap(struct vma_iterator
 		BUG_ON(next->vm_start < start);
 		BUG_ON(next->vm_start > end);
 #endif
-	}
-
-	if (vma_iter_end(vmi) > end)
-		next = vma_iter_load(vmi);
-
-	if (!next)
-		next = vma_next(vmi);
+	} for_each_vma_range(*vmi, next, end);
 
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
@@ -2528,7 +2519,10 @@ do_vmi_align_munmap(struct vma_iterator
 		BUG_ON(count != test_count);
 	}
 #endif
-	vma_iter_set(vmi, start);
+
+	while (vma_iter_addr(vmi) > start)
+		vma_iter_prev_range(vmi);
+
 	error = vma_iter_clear_gfp(vmi, start, end, GFP_KERNEL);
 	if (error)
 		goto clear_tree_failed;
@@ -2539,6 +2533,11 @@ do_vmi_align_munmap(struct vma_iterator
 	if (unlock)
 		mmap_write_downgrade(mm);
 
+	prev = vma_iter_prev_range(vmi);
+	next = vma_next(vmi);
+	if (next)
+		vma_iter_prev_range(vmi);
+
 	/*
 	 * We can free page tables without write-locking mmap_lock because VMAs
 	 * were isolated before we downgraded mmap_lock.
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

