Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4472BC83005
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbjFIX3n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjFIX2g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3366358C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6033060D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C31C433D2;
        Fri,  9 Jun 2023 23:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353287;
        bh=oe0b1BUOtONLDuzWl75WA+u/cbfwc6zKZhQrHaiWhDM=;
        h=Date:To:From:Subject:From;
        b=xQlORyH3xhKOyl69csGcjEIqh0axjtElP3s3RfcS0bOSjm/MkSoSygX34Hb2RN8gY
         Fd6cmB6z+6fwXGIbC6eksynHCipvQB9Fu4da4XpWKnTDCFJiv8+aj4+dcPgNKslm5V
         SxD3To25LuJOFjPG7aSoMyu4SN/7SExmA16zEAv8=
Date:   Fri, 09 Jun 2023 16:28:07 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-clean-up-mas_dfs_postorder.patch removed from -mm tree
Message-Id: <20230609232807.B9C31C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: clean up mas_dfs_postorder()
has been removed from the -mm tree.  Its filename was
     maple_tree-clean-up-mas_dfs_postorder.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: clean up mas_dfs_postorder()
Date: Thu, 18 May 2023 10:55:13 -0400

Convert loop type to ensure all variables are set to make the compiler
happy, and use the mas_is_none() function instead of explicitly checking
the node in the maple state.

Link: https://lkml.kernel.org/r/20230518145544.1722059-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clean-up-mas_dfs_postorder
+++ a/lib/maple_tree.c
@@ -6734,15 +6734,12 @@ static void mas_dfs_postorder(struct ma_
 
 	mas->node = mn;
 	mas_ascend(mas);
-	while (mas->node != MAS_NONE) {
+	do {
 		p = mas->node;
 		p_min = mas->min;
 		p_max = mas->max;
 		mas_prev_node(mas, 0);
-	}
-
-	if (p == MAS_NONE)
-		return;
+	} while (!mas_is_none(mas));
 
 	mas->node = p;
 	mas->max = p_max;
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

