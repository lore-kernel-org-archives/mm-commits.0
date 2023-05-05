Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1765CC77B7D
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 19:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbjEETbA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 15:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbjEETap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 15:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558D91AB
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 12:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC76F614FE
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC1BC433D2;
        Fri,  5 May 2023 19:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683315043;
        bh=B0xhQ4n3luMLlVkOq7am6mq+mkAq71gDKRr5vEIV0Vg=;
        h=Date:To:From:Subject:From;
        b=sXia9CW0CDIVaG5K6XWHZAi3PSUCMhYxNKZMiwU6Ha1QsPMoIYFbZJsJGZy0rRloD
         Jklk4l2U4tOn58Jwp+mOxxDsieriOooVJaANxKA1+hDxMtxXvJLgxgPYMn21VRc39v
         y5p4rTO6tJK+2kY6y3lJfyWSTycTnl9OpYhKcIz8=
Date:   Fri, 05 May 2023 12:30:42 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        senozhatsky@chromium.org, richard.weiyang@gmail.com,
        dcb314@hotmail.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch added to mm-unstable branch
Message-Id: <20230505193043.3EC1BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: use MAS_BUG_ON() prior to calling mas_meta_gap()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch

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
Subject: maple_tree: use MAS_BUG_ON() prior to calling mas_meta_gap()
Date: Fri, 5 May 2023 13:41:42 -0400

Replace the call to BUG_ON() in mas_meta_gap() with calls before the
function call MAS_BUG_ON() to get more information on error condition.

Link: https://lkml.kernel.org/r/20230505174204.2665599-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap
+++ a/lib/maple_tree.c
@@ -963,8 +963,6 @@ static inline unsigned char ma_meta_end(
 static inline unsigned char ma_meta_gap(struct maple_node *mn,
 					enum maple_type mt)
 {
-	BUG_ON(mt != maple_arange_64);
-
 	return mn->ma64.meta.gap;
 }
 
@@ -1628,6 +1626,7 @@ static inline unsigned long mas_max_gap(
 		return mas_leaf_max_gap(mas);
 
 	node = mas_mn(mas);
+	MAS_BUG_ON(mas, mt != maple_arange_64);
 	offset = ma_meta_gap(node, mt);
 	if (offset == MAPLE_ARANGE64_META_MAX)
 		return 0;
@@ -1661,6 +1660,7 @@ static inline void mas_parent_gap(struct
 	pgaps = ma_gaps(pnode, pmt);
 
 ascend:
+	MAS_BUG_ON(mas, pmt != maple_arange_64);
 	meta_offset = ma_meta_gap(pnode, pmt);
 	if (meta_offset == MAPLE_ARANGE64_META_MAX)
 		meta_gap = 0;
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
maple_tree-add-gap-to-check_alloc_rev_range-testcase.patch

