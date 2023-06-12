Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4ADC7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbjFLV2j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236652AbjFLV1n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:27:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9368C198E
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:27:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F41B62949
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8197AC433EF;
        Mon, 12 Jun 2023 21:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605258;
        bh=tuCpwLg1QSSQLCFSvdP6eNNvWPhhX+LNK/hkz60dMFM=;
        h=Date:To:From:Subject:From;
        b=sSnAWZ1t3yEBXXlN4V1WUZUq9ZE2K2iQ+zXjk04BuamH+YG3gssVRkd917GLkeVTi
         JDWBGl8ltiQSTjTw+wVvWOKzh/+6WaYB3K/DmoV5YKghCmeV0nI5pESLYj6UfVQGhC
         cpDCitQfHbpblQR/k3kB2Yvp6sPJG5ZwamOrsYEE=
Date:   Mon, 12 Jun 2023 14:27:37 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-refine-mas_preallocate-node-calculations.patch added to mm-unstable branch
Message-Id: <20230612212738.8197AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: refine mas_preallocate() node calculations
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-refine-mas_preallocate-node-calculations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-refine-mas_preallocate-node-calculations.patch

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
Subject: maple_tree: refine mas_preallocate() node calculations
Date: Mon, 12 Jun 2023 16:39:51 -0400

Calculate the number of nodes based on the pending write action instead of
assuming the worst case.

This addresses a performance regression introduced in platforms that have
longer allocation timing.

Link: https://lkml.kernel.org/r/20230612203953.2093911-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   48 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-refine-mas_preallocate-node-calculations
+++ a/lib/maple_tree.c
@@ -5541,9 +5541,55 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
  */
 int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
+	MA_WR_STATE(wr_mas, mas, entry);
+	unsigned char node_size;
+	int request = 1;
 	int ret;
 
-	mas_node_count_gfp(mas, 1 + mas_mt_height(mas) * 3, gfp);
+
+	if (unlikely(!mas->index && mas->last == ULONG_MAX))
+		goto ask_now;
+
+	mas_wr_store_setup(&wr_mas);
+	wr_mas.content = mas_start(mas);
+	/* Root expand */
+	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
+		goto ask_now;
+
+	if (unlikely(!mas_wr_walk(&wr_mas))) {
+		/* Spanning store, use worst case for now */
+		request = 1 + mas_mt_height(mas) * 3;
+		goto ask_now;
+	}
+
+	/* At this point, we are at the leaf node that needs to be altered. */
+	/* Exact fit, no nodes needed. */
+	if (wr_mas.r_min == mas->index && wr_mas.r_max == mas->last)
+		return 0;
+
+	mas_wr_end_piv(&wr_mas);
+	node_size = mas_wr_new_end(&wr_mas);
+	/* Slot store can avoid using any nodes */
+	if (node_size == wr_mas.node_end && wr_mas.offset_end - mas->offset == 1)
+		return 0;
+
+	if (node_size >= mt_slots[wr_mas.type]) {
+		/* Split, worst case for now. */
+		request = 1 + mas_mt_height(mas) * 2;
+		goto ask_now;
+	}
+
+	/* Appending does not need any nodes */
+	if (node_size == wr_mas.node_end + 1 && mas->offset == wr_mas.node_end)
+		return 0;
+
+	/* Potential spanning rebalance collapsing a node, use worst-case */
+	if (node_size  - 1 <= mt_min_slots[wr_mas.type])
+		request = mas_mt_height(mas) * 2 - 1;
+
+	/* node store needs one node */
+ask_now:
+	mas_node_count_gfp(mas, request, gfp);
 	mas->mas_flags |= MA_STATE_PREALLOC;
 	if (likely(!mas_is_err(mas)))
 		return 0;
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

