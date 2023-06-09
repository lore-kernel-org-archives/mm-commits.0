Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB2CC7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjFIXaR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjFIX2n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED91420F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5068663EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5342C433EF;
        Fri,  9 Jun 2023 23:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353307;
        bh=pnviJ+vzxcyxn6P0oDEinVoX3X5FqeUrbNg3YAMK1cU=;
        h=Date:To:From:Subject:From;
        b=qQq0EA0rdovZMc+oGvP/ZPbMJojr53azqUAWnFUM8oUKbKnoXJO/k6L+BQm4yW4h4
         bXNM4t6SL2HDdicfEa0JzE7tf8NUWpjBQ1Gj3Ndu+h1wGBoVRGaKcLFVlDgv9/Qkh8
         BvrOBbQGcWWRI3xYGnhLMPw19gCAPF3mvKXtfscw=
Date:   Fri, 09 Jun 2023 16:28:27 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-unnecessary-check-from-mas_destroy.patch removed from -mm tree
Message-Id: <20230609232827.A5342C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: remove unnecessary check from mas_destroy()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-unnecessary-check-from-mas_destroy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: remove unnecessary check from mas_destroy()
Date: Thu, 18 May 2023 10:55:29 -0400

mas_destroy currently checks if mas->node is MAS_START prior to calling
mas_start(), but this is unnecessary as mas_start() will do nothing if the
node is anything but MAS_START.

Link: https://lkml.kernel.org/r/20230518145544.1722059-21-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-unnecessary-check-from-mas_destroy
+++ a/lib/maple_tree.c
@@ -5811,9 +5811,7 @@ void mas_destroy(struct ma_state *mas)
 	if (mas->mas_flags & MA_STATE_REBALANCE) {
 		unsigned char end;
 
-		if (mas_is_start(mas))
-			mas_start(mas);
-
+		mas_start(mas);
 		mtree_range_walk(mas);
 		end = mas_data_end(mas) + 1;
 		if (end < mt_min_slot_count(mas->node) - 1)
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

