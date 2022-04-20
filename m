Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284B7C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 21:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbiDTVsJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 17:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382646AbiDTVsI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 17:48:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B485252A7
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 14:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98D356197B
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 21:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8780C385A9;
        Wed, 20 Apr 2022 21:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650491120;
        bh=vL/GpKPJc0L3rcZckmvNdZGlyhjXzLfKxncnBg10T/o=;
        h=Date:To:From:Subject:From;
        b=cntL1iyB008swG59flA3Dh7gs/wBJfjl1H1YAl3Dcp3aN4m2WJ3HPbr0hC5oLHnRM
         DM9xYFdPZFRa5ZObSFMrrJMVvQ2BS6UoDomaOvgxbNZ4gztJHHMQSHfgoNlBzj8ulq
         ouPB0XP6YE23Eg6++dBEVyScga1P/5BhNZ+wrvzc=
Date:   Wed, 20 Apr 2022 14:45:19 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-2.patch added to -mm tree
Message-Id: <20220420214519.E8780C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: Fix potential insufficient nodes on mas_spanning_rebalance()
has been added to the -mm tree.  Its filename is
     maple-tree-add-new-data-structure-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maple-tree-add-new-data-structure-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maple-tree-add-new-data-structure-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: Fix potential insufficient nodes on mas_spanning_rebalance()

When a spanning store occurs at a non-root node but causes an insufficient
leave, mas_spanning_rebalance() was not detecting it as a non-root node. 
This only happened when the spanning write was detected at the root node.

Link: https://lkml.kernel.org/r/20220420134737.yuhkl6znauwpp7j5@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-2
+++ a/lib/maple_tree.c
@@ -2894,7 +2894,7 @@ static int mas_spanning_rebalance(struct
 	mast->free = &free;
 	mast->destroy = &destroy;
 	l_mas.node = r_mas.node = m_mas.node = MAS_NONE;
-	if (!mas_is_root_limits(mas) &&
+	if (!mas_is_root_limits(mast->orig_l) &&
 	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type])) {
 		/*
 		 * Do not free the current node as it may be freed in a bulk
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple-tree-add-new-data-structure-fix-2.patch

