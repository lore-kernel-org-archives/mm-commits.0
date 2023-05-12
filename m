Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5D7C77B75
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbjELXAE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240394AbjELW7k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 18:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137981FEE
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 15:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5CD061CF8
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 22:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1BFC4339B;
        Fri, 12 May 2023 22:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683932370;
        bh=hzyUkFr6eueBu4MsrwT8ZQHHqSGItkzQcLrtRe9T64U=;
        h=Date:To:From:Subject:From;
        b=qLOu6kK8n0bU6ob8eK29mEsZNUxeaxzUBAXTGEGLQHoBZYqjWQs6nTvprJRz7FFOU
         OT4XSOxnWYzoJK5oUihUYbCTxSdNaiNUVoLCmmlycIkR3jtTGceEbjLoMV5NGBWNxf
         t+JIWCFfhOLYPHVqXAtna/S/cpHHRb5F9z7hqjEo=
Date:   Fri, 12 May 2023 15:59:29 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-unnecessary-check-from-mas_destroy.patch added to mm-unstable branch
Message-Id: <20230512225930.4C1BFC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove unnecessary check from mas_destroy()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-unnecessary-check-from-mas_destroy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-unnecessary-check-from-mas_destroy.patch

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
Subject: maple_tree: remove unnecessary check from mas_destroy()
Date: Fri, 12 May 2023 14:20:21 -0400

mas_destroy currently checks if mas->node is MAS_START prior to calling
mas_start(), but this is unnecessary as mas_start() will do nothing if the
node is anything but MAS_START.

Link: https://lkml.kernel.org/r/20230512182036.359030-21-Liam.Howlett@oracle.com
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

maple_tree-fix-static-analyser-cppcheck-issue.patch
maple_tree-avoid-unnecessary-ascending.patch
maple_tree-clean-up-mas_dfs_postorder.patch
maple_tree-add-debug-bug_on-and-warn_on-variants.patch
maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent.patch
maple_tree-use-mas_bug_on-in-mas_set_height.patch
maple_tree-use-mas_bug_on-from-mas_topiary_range.patch
maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc.patch
maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch
maple_tree-return-error-on-mte_pivots-out-of-range.patch
maple_tree-make-test-code-work-without-debug-enabled.patch
mm-update-validate_mm-to-use-vma-iterator.patch
mm-update-vma_iter_store-to-use-mas_warn_on.patch
maple_tree-add-__init-and-__exit-to-test-module.patch
maple_tree-remove-unnecessary-check-from-mas_destroy.patch
maple_tree-mas_start-reset-depth-on-dead-node.patch
mm-mmap-change-do_vmi_align_munmap-for-maple-tree-iterator-changes.patch
maple_tree-try-harder-to-keep-active-node-after-mas_next.patch
maple_tree-try-harder-to-keep-active-node-with-mas_prev.patch
maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch
maple_tree-fix-testing-mas_empty_area.patch
maple_tree-introduce-mas_next_slot-interface.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch
maple_tree-relocate-mas_rewalk-and-mas_rewalk_if_dead.patch
maple_tree-introduce-mas_prev_slot-interface.patch
maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch
maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch
maple_tree-update-testing-code-for-mas_nextprevwalk.patch
mm-add-vma_iter_nextprev_range-to-vma-iterator.patch
mm-avoid-rewalk-in-mmap_region.patch

