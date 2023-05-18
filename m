Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E755C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 21:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjERVdD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 17:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjERVcF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 17:32:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFFD19B2
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 14:31:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D7866526B
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 21:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9852C433D2;
        Thu, 18 May 2023 21:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684445396;
        bh=P4S2WyyxnYhsbKcPefYeuxbfYy0B/aB53xIhUxqxkAA=;
        h=Date:To:From:Subject:From;
        b=SDTJL399UcsxJ4GWPDrfixQ6bEuDuYgc1QREC8u5eCuCy2J6S+wYSIJDPLpdeEUky
         32MgbVUU285yJXMiK5N/qQp19mIVgOwX7DdXL/ec77s7uEchZUtqaMfW4nT21pdiix
         +17EeMNosqw0vKwY8M5mfCQB5Z4BClLAC1OpMX2Q=
Date:   Thu, 18 May 2023 14:29:56 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch added to mm-unstable branch
Message-Id: <20230518212956.C9852C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: clear up index and last setting in single entry tree
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch

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
Subject: maple_tree: clear up index and last setting in single entry tree
Date: Thu, 18 May 2023 10:55:41 -0400

When there is a single entry tree (range of 0-0 pointing to an entry),
then ensure the limit is either 0-0 or 1-oo, depending on where the user
walks.  Ensure the correct node setting as well; either MAS_ROOT or
MAS_NONE.

Link: https://lkml.kernel.org/r/20230518145544.1722059-33-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-clear-up-index-and-last-setting-in-single-entry-tree
+++ a/lib/maple_tree.c
@@ -5023,24 +5023,25 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
+	if (mas_is_none(mas) || mas_is_paused(mas) || mas_is_ptr(mas))
+		mas->node = MAS_START;
 retry:
 	entry = mas_state_walk(mas);
-	if (mas_is_start(mas))
+	if (mas_is_start(mas)) {
 		goto retry;
-
-	if (mas_is_ptr(mas)) {
+	} else if (mas_is_none(mas)) {
+		mas->index = 0;
+		mas->last = ULONG_MAX;
+	} else if (mas_is_ptr(mas)) {
 		if (!mas->index) {
 			mas->last = 0;
-		} else {
-			mas->index = 1;
-			mas->last = ULONG_MAX;
+			return entry;
 		}
-		return entry;
-	}
 
-	if (mas_is_none(mas)) {
-		mas->index = 0;
+		mas->index = 1;
 		mas->last = ULONG_MAX;
+		mas->node = MAS_NONE;
+		return NULL;
 	}
 
 	return entry;
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

