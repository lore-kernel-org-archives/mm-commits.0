Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D0AC41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjHKXNR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbjHKXND (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE863C15
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA00167B04
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C224C433C8;
        Fri, 11 Aug 2023 23:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794975;
        bh=vmsy3KGCHVtLqB0Ptuvy7xfc+oO2WJn3cNJ0WkuGax4=;
        h=Date:To:From:Subject:From;
        b=W3C0zEVdWrVjplNjE5cFeL7qwIQSt6pfrEPM3Tio1L313MHfe+vHC82tm3s4KkN5b
         xQ5aOAHb+GRXyVWSMEsIfEpAcxqtoaJD0Q9l26I8Rfe+rQs2ohzPhsthgmj5p6QKmH
         kgzPiXH1hKY71rWYmGruzpoC1dbMwQ9dgn+mXO4Y=
Date:   Fri, 11 Aug 2023 16:02:54 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch removed from -mm tree
Message-Id: <20230811230255.2C224C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: change vma iteration order in do_vmi_align_munmap()
has been removed from the -mm tree.  Its filename was
     mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

