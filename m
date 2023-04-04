Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DB4C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 20:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjDDUZL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 16:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbjDDUZH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 16:25:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AADF4EE5
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 13:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A3963996
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 20:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D05C43443;
        Tue,  4 Apr 2023 20:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680639904;
        bh=3cCQoK0pF2rAPsY5zgVev4uCVsoIqM7Tpa9lyLB7R+M=;
        h=Date:To:From:Subject:From;
        b=vRRDDXJPLw6VQ+brnAhXl5mBXkJZ1Yhp6LNuut/JlsmwoeOb7KTwT9PiTtg1giGgO
         2MFX5od+UL8tsAZmH4FY3RJrJTBzn4ATrQ6FxYlsH3rdq1uFdQYX/GnFi5mX7FkaIW
         5lheueqBS8AOMYMkgxqFbMVfNQTsNZ/6/0IpNTTQ=
Date:   Tue, 04 Apr 2023 13:25:04 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-simplify-mas_wr_node_walk.patch added to mm-unstable branch
Message-Id: <20230404202504.B9D05C43443@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: simplify mas_wr_node_walk()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-simplify-mas_wr_node_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-simplify-mas_wr_node_walk.patch

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
@@ -2317,9 +2317,7 @@ static inline struct maple_enode *mte_no
 static inline void mas_wr_node_walk(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned char count;
-	unsigned char offset;
-	unsigned long index, min, max;
+	unsigned char count, offset;
 
 	if (unlikely(ma_is_dense(wr_mas->type))) {
 		wr_mas->r_max = wr_mas->r_min = mas->index;
@@ -2332,34 +2330,12 @@ static inline void mas_wr_node_walk(stru
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

mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk.patch
maple_tree-simplify-mas_wr_node_walk.patch
maple_tree-fix-a-potential-concurrency-bug-in-rcu-mode.patch

