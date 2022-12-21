Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4231BC4167B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiLUVOc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbiLUVOR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:14:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BB75FC6
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65882B81BE7
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078E3C433D2;
        Wed, 21 Dec 2022 21:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657254;
        bh=esXq/RA81Z3HVt92N0cqRdlmBC8JhY0CU4TiedQX1Rc=;
        h=Date:To:From:Subject:From;
        b=q4Bszc626A96m5066WOiQBnlxrFEH+z4pxgnCd1vF38dLQM4Jh41mNkwhb/MAFaC7
         8qe6KQ5rovjfAQuHTD+L786A24fek3F/BRjh5F7ZJwfE5+riAKP6bQrGqjE6TkMpA/
         rLUgM8NTYr7Xb/hDvR6XZ4RsVSXWwE2SAq5dMTn8=
Date:   Wed, 21 Dec 2022 13:14:13 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-refine-mab_calc_split-function.patch added to mm-unstable branch
Message-Id: <20221221211414.078E3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: refine mab_calc_split function
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-refine-mab_calc_split-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-refine-mab_calc_split-function.patch

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

maple_tree-remove-extra-space-and-blank-line.patch
maple_tree-remove-extra-return-statement.patch
maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch
maple_tree-use-macro-ma_root_parent-instead-of-number.patch
maple_tree-remove-the-redundant-code.patch
maple_tree-refine-ma_state-init-from-mas_start.patch
maple_tree-refine-mab_calc_split-function.patch

