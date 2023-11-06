Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB44EC4167D
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjKFReM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjKFReL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:34:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F035B7
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:34:08 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39919C433C7;
        Mon,  6 Nov 2023 17:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699292048;
        bh=2MaJYD2DiRalvqUegGi4hWo5CjfU2Pxy5/AzViOgJQQ=;
        h=Date:To:From:Subject:From;
        b=UMsnoZCgA6MqvVXB6x0vWihqrcfzixrUbOiMxRE1jMv7Q/VCSBpooZQ5jzWy8KdD1
         VbJnew/+KNDI2jigFNDkh//5/wPmiJ7Sm0mETxkO3lYRC5cQHnm+vRfPCDFi2MF3Ef
         txqmRDDD/Wio/Ahk70OeDODTUjGA+ieufhaSABno=
Date:   Mon, 06 Nov 2023 09:34:07 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-make-mas_erase-more-robust.patch added to mm-unstable branch
Message-Id: <20231106173408.39919C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: make mas_erase() more robust
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-make-mas_erase-more-robust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-make-mas_erase-more-robust.patch

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
Subject: maple_tree: make mas_erase() more robust
Date: Wed, 1 Nov 2023 13:16:19 -0400

mas_erase() may not deal correctly with all maple states.  Make the
function more robust by ensuring the state is in one of the two acceptable
states.

Link: https://lkml.kernel.org/r/20231101171629.3612299-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-make-mas_erase-more-robust
+++ a/lib/maple_tree.c
@@ -6173,7 +6173,7 @@ void *mas_erase(struct ma_state *mas)
 	void *entry;
 	MA_WR_STATE(wr_mas, mas, NULL);
 
-	if (mas_is_none(mas) || mas_is_paused(mas))
+	if (!mas_is_active(mas) || !mas_is_start(mas))
 		mas->node = MAS_START;
 
 	/* Retry unnecessary when holding the write lock. */
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

