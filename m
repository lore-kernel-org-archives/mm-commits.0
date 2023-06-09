Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1A1C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjFIX3m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbjFIX2g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD7D30FE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C8EB60D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D7EC433D2;
        Fri,  9 Jun 2023 23:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353286;
        bh=sMnQ/Hxs4jJexfP6gr2oZhiw7/gJAgvJ6su2EyY+oKM=;
        h=Date:To:From:Subject:From;
        b=WRoVIy1GTYkdZQq7gbtf/Naqe5avIkESF9RXxjXpHf6HQx2Mf4gocHnYSYGxZqqh0
         NIe9JZDxgjzvymDvxi0g5KYToymG8Mds0un7Hm/j2CY9wOwgLCWh8UmqunWuHLCOWx
         4AxtFQeclBb0AZqjGl+Bj4jth39qTO8mPdaCz9D8=
Date:   Fri, 09 Jun 2023 16:28:05 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-avoid-unnecessary-ascending.patch removed from -mm tree
Message-Id: <20230609232806.85D7EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: avoid unnecessary ascending
has been removed from the -mm tree.  Its filename was
     maple_tree-avoid-unnecessary-ascending.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: avoid unnecessary ascending
Date: Thu, 18 May 2023 10:55:12 -0400

The maple tree node limits are implied by the parent.  When walking up the
tree, the limit may not be known until a slot that does not have implied
limits are encountered.  However, if the node is the left-most or
right-most node, the walking up to find that limit can be skipped.

This commit also fixes the debug/testing code that was not setting the
limit on walking down the tree as that optimization is not compatible with
this change.

Link: https://lkml.kernel.org/r/20230518145544.1722059-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |   11 ++++++++---
 tools/testing/radix-tree/maple.c |    4 ++++
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-avoid-unnecessary-ascending
+++ a/lib/maple_tree.c
@@ -1103,7 +1103,6 @@ static int mas_ascend(struct ma_state *m
 	enum maple_type a_type;
 	unsigned long min, max;
 	unsigned long *pivots;
-	unsigned char offset;
 	bool set_max = false, set_min = false;
 
 	a_node = mas_mn(mas);
@@ -1115,8 +1114,9 @@ static int mas_ascend(struct ma_state *m
 	p_node = mte_parent(mas->node);
 	if (unlikely(a_node == p_node))
 		return 1;
+
 	a_type = mas_parent_type(mas, mas->node);
-	offset = mte_parent_slot(mas->node);
+	mas->offset = mte_parent_slot(mas->node);
 	a_enode = mt_mk_node(p_node, a_type);
 
 	/* Check to make sure all parent information is still accurate */
@@ -1124,7 +1124,6 @@ static int mas_ascend(struct ma_state *m
 		return 1;
 
 	mas->node = a_enode;
-	mas->offset = offset;
 
 	if (mte_is_root(a_enode)) {
 		mas->max = ULONG_MAX;
@@ -1132,6 +1131,12 @@ static int mas_ascend(struct ma_state *m
 		return 0;
 	}
 
+	if (!mas->min)
+		set_min = true;
+
+	if (mas->max == ULONG_MAX)
+		set_max = true;
+
 	min = 0;
 	max = ULONG_MAX;
 	do {
--- a/tools/testing/radix-tree/maple.c~maple_tree-avoid-unnecessary-ascending
+++ a/tools/testing/radix-tree/maple.c
@@ -35259,6 +35259,7 @@ static void mas_dfs_preorder(struct ma_s
 
 	struct maple_enode *prev;
 	unsigned char end, slot = 0;
+	unsigned long *pivots;
 
 	if (mas->node == MAS_START) {
 		mas_start(mas);
@@ -35291,6 +35292,9 @@ walk_up:
 		mas_ascend(mas);
 		goto walk_up;
 	}
+	pivots = ma_pivots(mte_to_node(prev), mte_node_type(prev));
+	mas->max = mas_safe_pivot(mas, pivots, slot, mte_node_type(prev));
+	mas->min = mas_safe_min(mas, pivots, slot);
 
 	return;
 done:
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
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

