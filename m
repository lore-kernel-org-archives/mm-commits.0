Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDD6C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjASBSS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjASBQR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:16:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849CF6B98F
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DBCCB81FBA
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB119C433EF;
        Thu, 19 Jan 2023 01:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090903;
        bh=vYBolNgRKkHB/tfuqR/KWIG8z9ZFhWmK+1ohJc2Lgno=;
        h=Date:To:From:Subject:From;
        b=kFWLx5Fh+wFJ8nGnb1lljAn/c/kh1DBuxk/hVbs2E4utNhou2AZTSuBVhDluuIZxE
         nxpbQEClqkfG2wp2+4cgQHxybQyVyUl36J5NpjcWC5ri8ZSpi80B6xtJWNWhlOwyas
         pvwciEvZTzBmXyzwZ8aYUNUju2xoJjpaUww9eork=
Date:   Wed, 18 Jan 2023 17:15:03 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-refine-mab_calc_split-function.patch removed from -mm tree
Message-Id: <20230119011503.DB119C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: refine mab_calc_split function
has been removed from the -mm tree.  Its filename was
     maple_tree-refine-mab_calc_split-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: refine mab_calc_split function
Date: Wed, 21 Dec 2022 14:00:58 +0800

Invert the conditional judgment of the mid_split, to focus the return
statement in the last statement, which is easier to understand and for
better readability.

Link: https://lkml.kernel.org/r/20221221060058.609003-8-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-refine-mab_calc_split-function
+++ a/lib/maple_tree.c
@@ -1882,10 +1882,9 @@ static inline int mab_calc_split(struct
 
 	/* Avoid ending a node on a NULL entry */
 	split = mab_no_null_split(bn, split, slot_count);
-	if (!(*mid_split))
-		return split;
 
-	*mid_split = mab_no_null_split(bn, *mid_split, slot_count);
+	if (unlikely(*mid_split))
+		*mid_split = mab_no_null_split(bn, *mid_split, slot_count);
 
 	return split;
 }
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch
maple_tree-fix-comment-of-mte_destroy_walk.patch
mm-mmap-fix-comment-of-unmapped_area_topdown.patch

