Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0357C4167D
	for <mm-commits@archiver.kernel.org>; Tue,  7 Nov 2023 16:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbjKGQ0x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Nov 2023 11:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbjKGQ0g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2023 11:26:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397295FE7
        for <mm-commits@vger.kernel.org>; Tue,  7 Nov 2023 08:23:07 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45A7C433C8;
        Tue,  7 Nov 2023 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699374186;
        bh=a8atUMZNXkH4ejclG+dGsarPm9rgeDXAPEo24YW7R5Q=;
        h=Date:To:From:Subject:From;
        b=a1V4F+4V/2dk+8ajFaAYa1VdJf/KGb//p58OQBaaVbb9DvtqfXkDgcfGz6Ohf2sch
         XH1ddW6pMmmTPQT8wxrV9L5i+O19r3ki9tvRSnTUEjfHO3vXjP8pTWg0nDTwY/dPq9
         kcIvHmC0KWg0J0IsYVRZ/8UZILxquosJL8reYySE=
Date:   Tue, 07 Nov 2023 08:23:06 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        david@redhat.com, abaci@linux.alibaba.com,
        jiapeng.chong@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-unused-function.patch added to mm-unstable branch
Message-Id: <20231107162306.C45A7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove unused function
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-unused-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-unused-function.patch

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
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: maple_tree: remove unused function
Date: Fri, 27 Oct 2023 16:49:44 +0800

The function are defined in the maple_tree.c file, but not called
elsewhere, so delete the unused function.

lib/maple_tree.c:689:29: warning: unused function 'mas_pivot'.

Link: https://lkml.kernel.org/r/20231027084944.24888-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7064
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-unused-function
+++ a/lib/maple_tree.c
@@ -685,35 +685,6 @@ static inline unsigned long *ma_gaps(str
 }
 
 /*
- * mas_pivot() - Get the pivot at @piv of the maple encoded node.
- * @mas: The maple state.
- * @piv: The pivot.
- *
- * Return: the pivot at @piv of @mn.
- */
-static inline unsigned long mas_pivot(struct ma_state *mas, unsigned char piv)
-{
-	struct maple_node *node = mas_mn(mas);
-	enum maple_type type = mte_node_type(mas->node);
-
-	if (MAS_WARN_ON(mas, piv >= mt_pivots[type])) {
-		mas_set_err(mas, -EIO);
-		return 0;
-	}
-
-	switch (type) {
-	case maple_arange_64:
-		return node->ma64.pivot[piv];
-	case maple_range_64:
-	case maple_leaf_64:
-		return node->mr64.pivot[piv];
-	case maple_dense:
-		return 0;
-	}
-	return 0;
-}
-
-/*
  * mas_safe_pivot() - get the pivot at @piv or mas->max.
  * @mas: The maple state
  * @pivots: The pointer to the maple node pivots
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are

maple_tree-remove-unused-function.patch

