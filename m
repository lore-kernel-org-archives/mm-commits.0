Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BB2C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjDRXfw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbjDRXev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FAEAD3F
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A473362BAD
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05001C433EF;
        Tue, 18 Apr 2023 23:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860862;
        bh=G5x/yqr30AYUY4Z1/AF0brxUYSfp6iOE9RTXA0pGQXQ=;
        h=Date:To:From:Subject:From;
        b=kJKLQCobFKmYSXCuW2RiehtbHrlyd0EZPwRIlb2ywwPtVDvK7FglnVbgHaQnb38dF
         YJKKhdYM6YoMgCwY48LRS0COfqNOK/ni5Re9xDvmfVfACaGgsupAamedDINzUtJSg/
         vW44mYEinaqU22iNtK2Axx1W6DeRYQVaL7jQGSvg=
Date:   Tue, 18 Apr 2023 16:34:21 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-simplify-mas_wr_node_walk.patch removed from -mm tree
Message-Id: <20230418233422.05001C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: simplify mas_wr_node_walk()
has been removed from the -mm tree.  Its filename was
     maple_tree-simplify-mas_wr_node_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: simplify mas_wr_node_walk()
Date: Tue, 14 Mar 2023 20:42:02 +0800

Simplify code of mas_wr_node_walk() without changing functionality, and
improve readability.  Remove some special judgments.  Instead of
dynamically recording the min and max in the loop, get the final min and
max directly at the end.

Link: https://lkml.kernel.org/r/20230314124203.91572-3-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-mas_wr_node_walk
+++ a/lib/maple_tree.c
@@ -2312,9 +2312,7 @@ static inline struct maple_enode *mte_no
 static inline void mas_wr_node_walk(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned char count;
-	unsigned char offset;
-	unsigned long index, min, max;
+	unsigned char count, offset;
 
 	if (unlikely(ma_is_dense(wr_mas->type))) {
 		wr_mas->r_max = wr_mas->r_min = mas->index;
@@ -2327,34 +2325,12 @@ static inline void mas_wr_node_walk(stru
 	count = wr_mas->node_end = ma_data_end(wr_mas->node, wr_mas->type,
 					       wr_mas->pivots, mas->max);
 	offset = mas->offset;
-	min = mas_safe_min(mas, wr_mas->pivots, offset);
-	if (unlikely(offset == count))
-		goto max;
 
-	max = wr_mas->pivots[offset];
-	index = mas->index;
-	if (unlikely(index <= max))
-		goto done;
+	while (offset < count && mas->index > wr_mas->pivots[offset])
+		offset++;
 
-	if (unlikely(!max && offset))
-		goto max;
-
-	min = max + 1;
-	while (++offset < count) {
-		max = wr_mas->pivots[offset];
-		if (index <= max)
-			goto done;
-		else if (unlikely(!max))
-			break;
-
-		min = max + 1;
-	}
-
-max:
-	max = mas->max;
-done:
-	wr_mas->r_max = max;
-	wr_mas->r_min = min;
+	wr_mas->r_max = offset < count ? wr_mas->pivots[offset] : mas->max;
+	wr_mas->r_min = mas_safe_min(mas, wr_mas->pivots, offset);
 	wr_mas->offset_end = mas->offset = offset;
 }
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-use-correct-variable-type-in-sizeof.patch
maple_tree-add-a-test-case-to-check-maple_alloc.patch

