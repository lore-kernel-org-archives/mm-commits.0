Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B46EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 22:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjGBWdw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 18:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjGBWdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 18:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EA3E4A
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 15:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0536060CEB
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 22:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC6EC433C8;
        Sun,  2 Jul 2023 22:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688337217;
        bh=5O3Akz6hXG1gVOI4jmKmdfON9I+KMbBNB/jg95/pgdQ=;
        h=Date:To:From:Subject:From;
        b=QH06m4bgK0Yay2j2pdoTwGIPnoZCVdKpACt03cFgDkDCs82/PzS/sOjsrtvKxOzdW
         Mu7MJDm+FvNQa4YK8hED8sTs0Ch5gv3RtQ/qbOy6xLzMG7WjtxYGjVFJKF3eyWxvj9
         xWIcqEiJ3LH2LeAtsPmb2bZOCIkhzqpmfieGSFX8=
Date:   Sun, 02 Jul 2023 15:33:36 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch added to mm-unstable branch
Message-Id: <20230702223337.5FC6EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add a fast path case in mas_wr_slot_store()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch

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
Subject: maple_tree: add a fast path case in mas_wr_slot_store()
Date: Wed, 28 Jun 2023 15:36:57 +0800

When expanding a range in two directions, only partially overwriting the
previous and next ranges, the number of entries will not be increased, so
we can just update the pivots as a fast path. However, it may introduce
potential risks in RCU mode, because it updates two pivots. We only
enable it in non-RCU mode.

Link: https://lkml.kernel.org/r/20230628073657.75314-5-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-a-fast-path-case-in-mas_wr_slot_store
+++ a/lib/maple_tree.c
@@ -4167,23 +4167,35 @@ static inline bool mas_wr_slot_store(str
 {
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char offset = mas->offset;
+	void __rcu **slots = wr_mas->slots;
 	bool gap = false;
 
-	if (wr_mas->offset_end - offset != 1)
-		return false;
-
-	gap |= !mt_slot_locked(mas->tree, wr_mas->slots, offset);
-	gap |= !mt_slot_locked(mas->tree, wr_mas->slots, offset + 1);
+	gap |= !mt_slot_locked(mas->tree, slots, offset);
+	gap |= !mt_slot_locked(mas->tree, slots, offset + 1);
 
-	if (mas->index == wr_mas->r_min) {
-		/* Overwriting the range and over a part of the next range. */
-		rcu_assign_pointer(wr_mas->slots[offset], wr_mas->entry);
-		wr_mas->pivots[offset] = mas->last;
-	} else {
-		/* Overwriting a part of the range and over the next range */
-		rcu_assign_pointer(wr_mas->slots[offset + 1], wr_mas->entry);
+	if (wr_mas->offset_end - offset == 1) {
+		if (mas->index == wr_mas->r_min) {
+			/* Overwriting the range and a part of the next one */
+			rcu_assign_pointer(slots[offset], wr_mas->entry);
+			wr_mas->pivots[offset] = mas->last;
+		} else {
+			/* Overwriting a part of the range and the next one */
+			rcu_assign_pointer(slots[offset + 1], wr_mas->entry);
+			wr_mas->pivots[offset] = mas->index - 1;
+			mas->offset++; /* Keep mas accurate. */
+		}
+	} else if (!mt_in_rcu(mas->tree)) {
+		/*
+		 * Expand the range, only partially overwriting the previous and
+		 * next ranges
+		 */
+		gap |= !mt_slot_locked(mas->tree, slots, offset + 2);
+		rcu_assign_pointer(slots[offset + 1], wr_mas->entry);
 		wr_mas->pivots[offset] = mas->index - 1;
+		wr_mas->pivots[offset + 1] = mas->last;
 		mas->offset++; /* Keep mas accurate. */
+	} else {
+		return false;
 	}
 
 	trace_ma_write(__func__, mas, 0, wr_mas->entry);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-add-test-for-mas_wr_modify-fast-path.patch
maple_tree-add-test-for-expanding-range-in-rcu-mode.patch
maple_tree-optimize-mas_wr_append-also-improve-duplicating-vmas.patch
maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch

