Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6668EC4167D
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjKFReT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjKFReT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:34:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB9BD45
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:34:16 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CAAC433C8;
        Mon,  6 Nov 2023 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699292056;
        bh=d5IBotmEgA474XspJNWkv0ReweFSTK2QeiL4iVMuD48=;
        h=Date:To:From:Subject:From;
        b=Ohp4MtxkXJtNbYGGELVOva9V5FagOMqkuWQc7wHt0qSZ0EboXWqngqbEI5x2hRF0G
         CLvrrjqkekdwOxfobuS/fn4QlShDmadznE/Lq58sFtjpFqGx4IB/+OyQQgWzV+slJ2
         mXNVjI59JBbqkJKF3bF/GypKIa9Kehh15pvW86Zo=
Date:   Mon, 06 Nov 2023 09:34:15 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-cached-node-end-in-mas_destroy.patch added to mm-unstable branch
Message-Id: <20231106173416.74CAAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: use cached node end in mas_destroy()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-cached-node-end-in-mas_destroy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-cached-node-end-in-mas_destroy.patch

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
Subject: maple_tree: use cached node end in mas_destroy()
Date: Wed, 1 Nov 2023 13:16:23 -0400

The node end is set during the walk, so use the resulting end instead of
re-fetching it.

Link: https://lkml.kernel.org/r/20231101171629.3612299-7-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-cached-node-end-in-mas_destroy
+++ a/lib/maple_tree.c
@@ -5576,7 +5576,7 @@ void mas_destroy(struct ma_state *mas)
 
 		mas_start(mas);
 		mtree_range_walk(mas);
-		end = mas_data_end(mas) + 1;
+		end = mas->end + 1;
 		if (end < mt_min_slot_count(mas->node) - 1)
 			mas_destroy_rebalance(mas, end);
 
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

