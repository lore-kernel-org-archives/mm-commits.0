Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F371CC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbjFIX1q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjFIX1S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240B73584;
        Fri,  9 Jun 2023 16:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B10DE61782;
        Fri,  9 Jun 2023 23:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7FBC433EF;
        Fri,  9 Jun 2023 23:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353235;
        bh=jwiEPJzlIHO4N56CRjcquGT7Bl80AunRPNQlYEgB1Qc=;
        h=Date:To:From:Subject:From;
        b=2pX6EVHKNDMT3yBs8+vxjSzq9UIwNLWWE70Uv2QSRBCXN0HknS5wkXmjNJwWtOez1
         42XYm8vlJwRx0m2bdZJ9wKDmL3Y/3tSCk3Tpk4xnc9KQqJ8aZV+rucFn4jPTfKmG3l
         NEDdy5s2q5L0mPtG6fw+peuhWfmqY7mtHQwZ0hTI=
Date:   Fri, 09 Jun 2023 16:27:14 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch removed from -mm tree
Message-Id: <20230609232715.0F7FBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix potential out-of-bounds access in mas_wr_end_piv()
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4263,11 +4263,13 @@ done:
 
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
 
@@ -4424,7 +4426,6 @@ static inline void *mas_wr_store_entry(s
 	}
 
 	/* At this point, we are at the leaf node that needs to be altered. */
-	wr_mas->end_piv = wr_mas->r_max;
 	mas_wr_end_piv(wr_mas);
 
 	if (!wr_mas->entry)
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


