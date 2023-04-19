Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F764C6FD18
	for <mm-commits@archiver.kernel.org>; Wed, 19 Apr 2023 19:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjDSTuH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Apr 2023 15:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjDSTuF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Apr 2023 15:50:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDF21BD8
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 12:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DB6663887
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 19:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6604C433EF;
        Wed, 19 Apr 2023 19:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681933802;
        bh=1pxCGZj/ev8fYinebpXzZTe70JOmXM7wOdcoGl8ORg0=;
        h=Date:To:From:Subject:From;
        b=rM9rai71/rYnPHOzNiQvszEt5jt8z9dN6YKf+Bcld2QN23JB9fp2QA8mxVTuKAgpM
         I4m9332JEAr7Z0WCV7wTEU4b1kUEJJareaVlF6Scfdk9U+3FW3gmTwKnZVQnDBvp1n
         r8ya1fyGUE9kNcy7rS6fUteh68JiAecG2AFW0YrE=
Date:   Wed, 19 Apr 2023 12:50:02 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@Oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-allocation-in-mas_sparse_area.patch added to mm-unstable branch
Message-Id: <20230419195002.A6604C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix allocation in mas_sparse_area()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-allocation-in-mas_sparse_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-allocation-in-mas_sparse_area.patch

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
Subject: maple_tree: fix allocation in mas_sparse_area()
Date: Wed, 19 Apr 2023 17:36:25 +0800

In the case of reverse allocation, mas->index and mas->last do not point
to the correct allocation range, which will cause users to get incorrect
allocation results, so fix it.  If the user does not use it in a specific
way, this bug will not be triggered.

Also re-checks whether the size is still satisfied after the lower bound
was increased, which is a corner case and is incorrect in previous
versions.

Link: https://lkml.kernel.org/r/20230419093625.99201-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-allocation-in-mas_sparse_area
+++ a/lib/maple_tree.c
@@ -5250,25 +5250,28 @@ static inline void mas_fill_gap(struct m
  * @size: The size of the gap
  * @fwd: Searching forward or back
  */
-static inline void mas_sparse_area(struct ma_state *mas, unsigned long min,
+static inline int mas_sparse_area(struct ma_state *mas, unsigned long min,
 				unsigned long max, unsigned long size, bool fwd)
 {
-	unsigned long start = 0;
-
-	if (!unlikely(mas_is_none(mas)))
-		start++;
+	if (!unlikely(mas_is_none(mas)) && min == 0) {
+		min++;
+		/*
+		 * At this time, min is increased, we need to recheck whether
+		 * the size is satisfied.
+		 */
+		if (min > max || max - min + 1 < size)
+			return -EBUSY;
+	}
 	/* mas_is_ptr */
 
-	if (start < min)
-		start = min;
-
 	if (fwd) {
-		mas->index = start;
-		mas->last = start + size - 1;
-		return;
+		mas->index = min;
+		mas->last = min + size - 1;
+	} else {
+		mas->last = max;
+		mas->index = max - size + 1;
 	}
-
-	mas->index = max;
+	return 0;
 }
 
 /*
@@ -5297,10 +5300,8 @@ int mas_empty_area(struct ma_state *mas,
 		return -EBUSY;
 
 	/* Empty set */
-	if (mas_is_none(mas) || mas_is_ptr(mas)) {
-		mas_sparse_area(mas, min, max, size, true);
-		return 0;
-	}
+	if (mas_is_none(mas) || mas_is_ptr(mas))
+		return mas_sparse_area(mas, min, max, size, true);
 
 	/* The start of the window can only be within these values */
 	mas->index = min;
@@ -5356,10 +5357,8 @@ int mas_empty_area_rev(struct ma_state *
 	}
 
 	/* Empty set. */
-	if (mas_is_none(mas) || mas_is_ptr(mas)) {
-		mas_sparse_area(mas, min, max, size, false);
-		return 0;
-	}
+	if (mas_is_none(mas) || mas_is_ptr(mas))
+		return mas_sparse_area(mas, min, max, size, false);
 
 	/* The start of the window can only be within these values. */
 	mas->index = min;
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-fix-allocation-in-mas_sparse_area.patch

