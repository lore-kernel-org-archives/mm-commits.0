Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFABC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbjKFRee (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjKFRea (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:34:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A598D45
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:34:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB1DC433C8;
        Mon,  6 Nov 2023 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699292066;
        bh=WVBdK9++RFe5NqEuJPZ0Xq/lxWa+3+0maGVPGo8I3+k=;
        h=Date:To:From:Subject:From;
        b=Mv9D0LDKkJQuYk5jCp0MybBxGsQ0Oap1/P6vglLUyauesY2PnPq9/ppqo5p++2Pih
         boG9albmUxFKWmLIxcEMcrCT/8Y7AZnvKbL2ip+edXL67xWKrfhuHXI/jjfNSZMEgS
         P/YV31PSrr6QS6GLfzcRYCfgST7OK1Ezg1HQTN9g=
Date:   Mon, 06 Nov 2023 09:34:25 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-separate-ma_state-node-from-status-fix-2.patch added to mm-unstable branch
Message-Id: <20231106173425.EAB1DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: update forking to separate maple state and node
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-separate-ma_state-node-from-status-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-separate-ma_state-node-from-status-fix-2.patch

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
Subject: maple_tree: update forking to separate maple state and node
Date: Mon, 6 Nov 2023 10:45:51 -0500

Just a small change to the forking code after rebasing the maple status
changes on top.

Link: https://lkml.kernel.org/r/20231106154551.615042-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |    2 +-
 tools/testing/radix-tree/maple.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-separate-ma_state-node-from-status-fix-2
+++ a/lib/maple_tree.c
@@ -6693,7 +6693,7 @@ static inline void mas_dup_build(struct
 
 	node = mt_alloc_one(gfp);
 	if (!node) {
-		new_mas->node = MAS_NONE;
+		new_mas->status = ma_none;
 		mas_set_err(mas, -ENOMEM);
 		return;
 	}
--- a/tools/testing/radix-tree/maple.c~maple_tree-separate-ma_state-node-from-status-fix-2
+++ a/tools/testing/radix-tree/maple.c
@@ -35956,7 +35956,7 @@ static int __init compare_tree(struct ma
 
 	if (mas_is_ptr(&mas_a) || mas_is_ptr(&mas_b)) {
 		if (!(mas_is_ptr(&mas_a) && mas_is_ptr(&mas_b))) {
-			pr_err("One is MAS_ROOT and the other is not.\n");
+			pr_err("One is ma_root and the other is not.\n");
 			return -1;
 		}
 		return 0;
@@ -35965,7 +35965,7 @@ static int __init compare_tree(struct ma
 	while (!mas_is_none(&mas_a) || !mas_is_none(&mas_b)) {
 
 		if (mas_is_none(&mas_a) || mas_is_none(&mas_b)) {
-			pr_err("One is MAS_NONE and the other is not.\n");
+			pr_err("One is ma_none and the other is not.\n");
 			return -1;
 		}
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch
maple_tree-make-mas_erase-more-robust.patch
maple_tree-move-debug-check-to-__mas_set_range.patch
maple_tree-add-end-of-node-tracking-to-the-maple-state.patch
maple_tree-use-cached-node-end-in-mas_next.patch
maple_tree-use-cached-node-end-in-mas_destroy.patch
maple_tree-clean-up-inlines-for-some-functions.patch
maple_tree-separate-ma_state-node-from-status.patch
maple_tree-separate-ma_state-node-from-status-fix-1.patch
maple_tree-separate-ma_state-node-from-status-fix-2.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

