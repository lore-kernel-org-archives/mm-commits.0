Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57EBC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 19:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjLGTja (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 14:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjLGTja (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 14:39:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4320A11D
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 11:39:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34C3C433C8;
        Thu,  7 Dec 2023 19:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701977975;
        bh=z98iyGcZtT4abfRMFNool+6qb3WBqD8yDFhM22vCoVg=;
        h=Date:To:From:Subject:From;
        b=W2PtKjY1YMI8LyUmGAz0Sm59aWbZ6S/Rv2njBEpRehQuEKViyxX1wLoE8tQZQI54S
         82yf4YLCAnIynl//sW9kkXebetGgT24jkv2mokhu0/1dfHfJk+Jq470mj8pSOYHfoQ
         gRhWN+6ZEZKZOfVfOzShWlvCWJ6/yCUtDOzOX/lg=
Date:   Thu, 07 Dec 2023 11:39:35 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-separate-ma_state-node-from-status-fix.patch added to mm-unstable branch
Message-Id: <20231207193935.C34C3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_prev() state separation code
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-separate-ma_state-node-from-status-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-separate-ma_state-node-from-status-fix.patch

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
Subject: maple_tree: fix mas_prev() state separation code
Date: Thu, 7 Dec 2023 14:33:19 -0500

mas_prev() was setting the ma_underflow condition when the limit was
reached and not when the limit was attempting to go lower.  This resulted
in the incorrect behaviour on subsequent actions.

This commit fixes the status setting to only set ma_underflow when the
lower limit is attempted to be decremented, and modifies the testing to
ensure that's the case.

Link: https://lkml.kernel.org/r/20231207193319.4025462-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c      |   16 ++++++++++++----
 lib/test_maple_tree.c |    9 +++++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple_tree-separate-ma_state-node-from-status-fix
+++ a/lib/maple_tree.c
@@ -4498,6 +4498,9 @@ again:
 		mas->last = mas->index - 1;
 		mas->index = mas_safe_min(mas, pivots, mas->offset);
 	} else  {
+		if (mas->index <= min)
+			goto underflow;
+
 		if (mas_prev_node(mas, min)) {
 			mas_rewalk(mas, save_point);
 			goto retry;
@@ -4518,15 +4521,15 @@ again:
 	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
 		goto retry;
 
-	if (mas->index <= min)
-		mas->status = ma_underflow;
 
 	if (likely(entry))
 		return entry;
 
 	if (!empty) {
-		if (mas_is_underflow(mas))
+		if (mas->index <= min) {
+			mas->status = ma_underflow;
 			return NULL;
+		}
 
 		goto again;
 	}
@@ -4662,7 +4665,7 @@ retry:
 		if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
 			goto retry;
 
-		if (pivot >= max) {
+		if (pivot >= max) { /* Was at the limit, next will extend beyond */
 			mas->status = ma_overflow;
 			return NULL;
 		}
@@ -4677,6 +4680,11 @@ again:
 		else
 			mas->last = mas->max;
 	} else  {
+		if (mas->last >= max) {
+			mas->status = ma_overflow;
+			return NULL;
+		}
+
 		if (mas_next_node(mas, node, max)) {
 			mas_rewalk(mas, save_point);
 			goto retry;
--- a/lib/test_maple_tree.c~maple_tree-separate-ma_state-node-from-status-fix
+++ a/lib/test_maple_tree.c
@@ -3280,8 +3280,8 @@ static noinline void __init check_state_
 	MT_BUG_ON(mt, mas.last != 0x1500);
 	MT_BUG_ON(mt, !mas_is_active(&mas));
 
-	/* next:active ->active */
-	entry = mas_next(&mas, ULONG_MAX);
+	/* next:active ->active (spanning limit) */
+	entry = mas_next(&mas, 0x2100);
 	MT_BUG_ON(mt, entry != ptr2);
 	MT_BUG_ON(mt, mas.index != 0x2000);
 	MT_BUG_ON(mt, mas.last != 0x2500);
@@ -3346,6 +3346,11 @@ static noinline void __init check_state_
 	MT_BUG_ON(mt, entry != ptr);
 	MT_BUG_ON(mt, mas.index != 0x1000);
 	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_is_active(&mas)); /* spanning limit */
+	entry = mas_prev(&mas, 0x1200); /* underflow */
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
 	MT_BUG_ON(mt, !mas_is_underflow(&mas));
 
 	/* prev:underflow -> underflow (lower limit) spanning end range */
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
maple_tree-separate-ma_state-node-from-status-fix.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

