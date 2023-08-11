Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E9DC001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbjHKW7N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbjHKW64 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0921F3584
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCFAE6738D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43876C433C7;
        Fri, 11 Aug 2023 22:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794735;
        bh=FgOGYTUncu0myY5lzPk6FM1B/NODXB/tpKSw7XMOLt0=;
        h=Date:To:From:Subject:From;
        b=14bNizt1DHZBuQ+W+4F05ey9fiTh4SCleoIbML+f0xdOE+HQ/rzWO1Z3KRqCym8o9
         vNCtQXPPAfHtXGnOEP1n/4y4zO0zc9iPCDSOzb7UUPFateLtDLJQbIOmytUTC+NSzf
         k4Txsy9ARJZ+zYGVPUKdNQuV9EpbU1xKCCiYX2ls=
Date:   Fri, 11 Aug 2023 15:58:54 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch removed from -mm tree
Message-Id: <20230811225855.43876C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add a fast path case in mas_wr_slot_store()
has been removed from the -mm tree.  Its filename was
     maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4168,23 +4168,35 @@ static inline bool mas_wr_slot_store(str
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


