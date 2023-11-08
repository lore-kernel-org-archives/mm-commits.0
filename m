Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E86C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 19:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjKHTxQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 14:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjKHTxQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 14:53:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA606211B
        for <mm-commits@vger.kernel.org>; Wed,  8 Nov 2023 11:53:13 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853EAC433C7;
        Wed,  8 Nov 2023 19:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699473193;
        bh=OYXO6a+hKpusKSzQUFfkmSjIZJEs/f/i1t2eq3Xou6s=;
        h=Date:To:From:Subject:From;
        b=rs2JPhhni8sSzVpgZr5k5Fsl54l0PzIaRwA+rQKyszQvJL1x6/oP+asCQ9o5FG+s9
         fkh8N1dg+8CKFmU0w/+Di3aUd9rjXXQVEcYDFP20cL8IDLqmfIyoTDpw0opz/pZcpE
         fXnUESdUF9l1UBq6+imot7v0/lockbVSZZcLpoHI=
Date:   Wed, 08 Nov 2023 11:53:12 -0800
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-mtree_range_walk-clean-up.patch added to mm-unstable branch
Message-Id: <20231108195313.853EAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: mtree_range_walk() clean up
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-mtree_range_walk-clean-up.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-mtree_range_walk-clean-up.patch

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
Subject: maple_tree: mtree_range_walk() clean up
Date: Wed, 1 Nov 2023 13:16:29 -0400

mtree_range_walk() needed to be updated to avoid checking if there was a
pivot value.  On closer examination, the code could avoid setting min or
max in certain scenarios.  The commit removes the extra check for
pivot[offset] before setting max and only sets max when necessary.  It
also only sets min if it is necessary by checking offset 0 prior to the
loop (as it has always done).

The commit also drops a dead node check since the end of the node will
return the array size when the last slot is occupied (by a potential reuse
in a dead node).  The data will be discarded later if the node is marked
dead.

Benchmarking these changes results in an increase in performance of 5.45%
using the BENCH_WALK in the maple tree test code.

Link: https://lkml.kernel.org/r/20231101171629.3612299-13-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/lib/maple_tree.c~maple_tree-mtree_range_walk-clean-up
+++ a/lib/maple_tree.c
@@ -2806,32 +2806,29 @@ static inline void *mtree_range_walk(str
 	min = mas->min;
 	max = mas->max;
 	do {
-		offset = 0;
 		last = next;
 		node = mte_to_node(next);
 		type = mte_node_type(next);
 		pivots = ma_pivots(node, type);
 		end = ma_data_end(node, type, pivots, max);
-		if (unlikely(ma_dead_node(node)))
-			goto dead_node;
-
-		if (pivots[offset] >= mas->index) {
-			prev_max = max;
-			prev_min = min;
-			max = pivots[offset];
+		prev_min = min;
+		prev_max = max;
+		if (pivots[0] >= mas->index) {
+			offset = 0;
+			max = pivots[0];
 			goto next;
 		}
 
-		do {
+		offset = 1;
+		while (offset < end) {
+			if (pivots[offset] >= mas->index) {
+				max = pivots[offset];
+				break;
+			}
 			offset++;
-		} while ((offset < end) && (pivots[offset] < mas->index));
+		}
 
-		prev_min = min;
 		min = pivots[offset - 1] + 1;
-		prev_max = max;
-		if (likely(offset < end && pivots[offset]))
-			max = pivots[offset];
-
 next:
 		slots = ma_slots(node, type);
 		next = mt_slot(mas->tree, slots, offset);
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
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

