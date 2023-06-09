Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0950AC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbjFIXaS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjFIX2n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DD33A9C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8519763EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF41C433D2;
        Fri,  9 Jun 2023 23:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353309;
        bh=s/xRwc5Tj3ISH9LpD+mwHcb86KBHzh1pOQ/6a9xh1UE=;
        h=Date:To:From:Subject:From;
        b=v3YO+I60Vfhss53eTfGgyoEpZZ6444v8MCz2tVoie2Hks8DJ52/EXENKTUUmjtIcZ
         exLNXzSELmYehldhSGKcbif+7xiht0tjcEqdB3L5xqk5ZqrAmjdexSBSH0NUNM2FI5
         nLu0MQZnXsh1pU+oRJHSVzjYzLtD/FtMAg13odtI=
Date:   Fri, 09 Jun 2023 16:28:28 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-mas_start-reset-depth-on-dead-node.patch removed from -mm tree
Message-Id: <20230609232828.DAF41C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: mas_start() reset depth on dead node
has been removed from the -mm tree.  Its filename was
     maple_tree-mas_start-reset-depth-on-dead-node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: mas_start() reset depth on dead node
Date: Thu, 18 May 2023 10:55:30 -0400

When a dead node is detected, the depth has already been set to 1 so reset
it to 0.

Link: https://lkml.kernel.org/r/20230518145544.1722059-22-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-mas_start-reset-depth-on-dead-node
+++ a/lib/maple_tree.c
@@ -1396,9 +1396,9 @@ static inline struct maple_enode *mas_st
 
 		mas->min = 0;
 		mas->max = ULONG_MAX;
-		mas->depth = 0;
 
 retry:
+		mas->depth = 0;
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
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

