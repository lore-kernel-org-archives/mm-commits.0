Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2BDC88CB2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjFLV2k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbjFLV1o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:27:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F67B90
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 045D662949
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FB3C433D2;
        Mon, 12 Jun 2023 21:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605260;
        bh=nC7bCHs4TUoSX0rqW2j4MmAQJTSZRy6de5P6d5cQL4Y=;
        h=Date:To:From:Subject:From;
        b=Vs5yw2Wi+M74dbnqKsOn/uQkGeLyrEozxc585Uaiu4MH131EUiOUnpqChx3ur9yDR
         LNi4S8ejnZnG2sBqSgxJtYCm65UXXYp5tqo8sDL9znM6rr36RCPpBe7sFrTH0QMsGe
         p+1+a8fIW5pBL/cEADTLfPWkXHBOrtibpX5Zycf0=
Date:   Mon, 12 Jun 2023 14:27:39 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-reduce-resets-during-store-setup.patch added to mm-unstable branch
Message-Id: <20230612212740.57FB3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: reduce resets during store setup
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-reduce-resets-during-store-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-reduce-resets-during-store-setup.patch

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
Subject: maple_tree: reduce resets during store setup
Date: Mon, 12 Jun 2023 16:39:52 -0400

mas_prealloc() may walk partially down the tree before finding that a
split or spanning store is needed.  When the write occurs, relax the logic
on resetting the walk so that partial walks will not restart, but walks
that have gone too far (a store that affects beyond the current node)
should be restarted.

Link: https://lkml.kernel.org/r/20230612203953.2093911-16-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

--- a/lib/maple_tree.c~maple_tree-reduce-resets-during-store-setup
+++ a/lib/maple_tree.c
@@ -5430,19 +5430,34 @@ static inline void mte_destroy_walk(stru
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
 {
+	if (mas_is_start(wr_mas->mas))
+		return;
+
 	if (unlikely(mas_is_paused(wr_mas->mas)))
-		mas_reset(wr_mas->mas);
+		goto reset;
+
+	if (unlikely(mas_is_none(wr_mas->mas)))
+		goto reset;
+
+	/*
+	 * A less strict version of mas_is_span_wr() where we allow spanning
+	 * writes within this node.  This is to stop partial walks in
+	 * mas_prealloc() from being reset.
+	 */
+	if (wr_mas->mas->last > wr_mas->mas->max)
+		goto reset;
+
+	if (wr_mas->entry)
+		return;
+
+	if (mte_is_leaf(wr_mas->mas->node) &&
+	    wr_mas->mas->last == wr_mas->mas->max)
+		goto reset;
+
+	return;
 
-	if (!mas_is_start(wr_mas->mas)) {
-		if (mas_is_none(wr_mas->mas)) {
-			mas_reset(wr_mas->mas);
-		} else {
-			wr_mas->r_max = wr_mas->mas->max;
-			wr_mas->type = mte_node_type(wr_mas->mas->node);
-			if (mas_is_span_wr(wr_mas))
-				mas_reset(wr_mas->mas);
-		}
-	}
+reset:
+	mas_reset(wr_mas->mas);
 }
 
 /* Interface */
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

