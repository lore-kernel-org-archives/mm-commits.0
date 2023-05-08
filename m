Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBEFFC77B7D
	for <mm-commits@archiver.kernel.org>; Mon,  8 May 2023 00:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjEHAsw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 7 May 2023 20:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjEHAsw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 7 May 2023 20:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1298E53;
        Sun,  7 May 2023 17:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8462C60FE8;
        Mon,  8 May 2023 00:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA462C433D2;
        Mon,  8 May 2023 00:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683506929;
        bh=RMe7wJi/rKW+hMFV9GEEW6+xrrp0luNTEvX9HhWaVj8=;
        h=Date:To:From:Subject:From;
        b=RTfl79ccI5I7mCWOgDhFq6hIeYoD4jkFMVJFjpf3+UHiP5V2W6qkdsO7oim1jKAIs
         jD1tIrSKr/Sta6o5RkwnOd4b/B5Rma2FcNDa/MRDfNuq9fUJjr4Lf/CL/kG42+ELDo
         ASRK1VD0sy2L4HrUSSVXHbBFolIpDC+Hg+V4PRJQ=
Date:   Sun, 07 May 2023 17:48:49 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch added to mm-unstable branch
Message-Id: <20230508004849.DA462C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix potential out-of-bounds access in mas_wr_end_piv()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch

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
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: fix potential out-of-bounds access in mas_wr_end_piv()
Date: Sat, 6 May 2023 10:47:52 +0800

Check the write offset end bounds before using it as the offset into the
pivot array.  This avoids a possible out-of-bounds access on the pivot
array if the write extends to the last slot in the node, in which case the
node maximum should be used as the end pivot.

akpm: this doesn't affect any current callers, but new users of mapletree
may encounter this problem if backported into earlier kernels, so let's
fix it in -stable kernels in case of this.

Link: https://lkml.kernel.org/r/20230506024752.2550-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv
+++ a/lib/maple_tree.c
@@ -4262,11 +4262,13 @@ done:
 
 static inline void mas_wr_end_piv(struct ma_wr_state *wr_mas)
 {
-	while ((wr_mas->mas->last > wr_mas->end_piv) &&
-	       (wr_mas->offset_end < wr_mas->node_end))
-		wr_mas->end_piv = wr_mas->pivots[++wr_mas->offset_end];
+	while ((wr_mas->offset_end < wr_mas->node_end) &&
+	       (wr_mas->mas->last > wr_mas->pivots[wr_mas->offset_end]))
+		wr_mas->offset_end++;
 
-	if (wr_mas->mas->last > wr_mas->end_piv)
+	if (wr_mas->offset_end < wr_mas->node_end)
+		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
+	else
 		wr_mas->end_piv = wr_mas->mas->max;
 }
 
@@ -4423,7 +4425,6 @@ static inline void *mas_wr_store_entry(s
 	}
 
 	/* At this point, we are at the leaf node that needs to be altered. */
-	wr_mas->end_piv = wr_mas->r_max;
 	mas_wr_end_piv(wr_mas);
 
 	if (!wr_mas->entry)
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-make-maple-state-reusable-after-mas_empty_area.patch
maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch

