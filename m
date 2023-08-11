Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572D8C04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbjHKW7L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236859AbjHKW6z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1710326A2
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBE65678C4
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522C9C433C7;
        Fri, 11 Aug 2023 22:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794734;
        bh=JQXimwJYmNR702s6BwMIOUCbCPDhUQUGwfmp4Wx+n7g=;
        h=Date:To:From:Subject:From;
        b=V/2FBDTDNXszGF3/px38PjBVNUpVHFXTs7E4myYVkK7NmG/vqjO90c4Sxsi2oJXJt
         luCY0ByXmi+kX2YcQPApnBreZKJoi1wOhtJMQM5YDYKXPx0adgWMhVVqVi+uEQT+BB
         K7jnWbUerTAsLXk1Xf5e8JOXzWCm4cXjsJ4FGNJs=
Date:   Fri, 11 Aug 2023 15:58:53 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-optimize-mas_wr_append-also-improve-duplicating-vmas.patch removed from -mm tree
Message-Id: <20230811225854.522C9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: optimize mas_wr_append(), also improve duplicating VMAs
has been removed from the -mm tree.  Its filename was
     maple_tree-optimize-mas_wr_append-also-improve-duplicating-vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: optimize mas_wr_append(), also improve duplicating VMAs
Date: Wed, 28 Jun 2023 15:36:56 +0800

When the new range can be completely covered by the original last range
without touching the boundaries on both sides, two new entries can be
appended to the end as a fast path. We update the original last pivot at
the end, and the newly appended two entries will not be accessed before
this, so it is also safe in RCU mode.

This is useful for sequential insertion, which is what we do in
dup_mmap(). Enabling BENCH_FORK in test_maple_tree and just running
bench_forking() gives the following time-consuming numbers:

before:               after:
17,874.83 msec        15,738.38 msec

It shows about a 12% performance improvement for duplicating VMAs.

Link: https://lkml.kernel.org/r/20230628073657.75314-4-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/lib/maple_tree.c~maple_tree-optimize-mas_wr_append-also-improve-duplicating-vmas
+++ a/lib/maple_tree.c
@@ -4267,10 +4267,10 @@ static inline unsigned char mas_wr_new_e
  *
  * Return: True if appended, false otherwise
  */
-static inline bool mas_wr_append(struct ma_wr_state *wr_mas)
+static inline bool mas_wr_append(struct ma_wr_state *wr_mas,
+				 unsigned char new_end)
 {
 	unsigned char end = wr_mas->node_end;
-	unsigned char new_end = end + 1;
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char node_pivots = mt_pivots[wr_mas->type];
 
@@ -4282,16 +4282,27 @@ static inline bool mas_wr_append(struct
 		ma_set_meta(wr_mas->node, maple_leaf_64, 0, new_end);
 	}
 
-	if (mas->last == wr_mas->r_max) {
-		/* Append to end of range */
-		rcu_assign_pointer(wr_mas->slots[new_end], wr_mas->entry);
-		wr_mas->pivots[end] = mas->index - 1;
-		mas->offset = new_end;
+	if (new_end == wr_mas->node_end + 1) {
+		if (mas->last == wr_mas->r_max) {
+			/* Append to end of range */
+			rcu_assign_pointer(wr_mas->slots[new_end],
+					   wr_mas->entry);
+			wr_mas->pivots[end] = mas->index - 1;
+			mas->offset = new_end;
+		} else {
+			/* Append to start of range */
+			rcu_assign_pointer(wr_mas->slots[new_end],
+					   wr_mas->content);
+			wr_mas->pivots[end] = mas->last;
+			rcu_assign_pointer(wr_mas->slots[end], wr_mas->entry);
+		}
 	} else {
-		/* Append to start of range */
+		/* Append to the range without touching any boundaries. */
 		rcu_assign_pointer(wr_mas->slots[new_end], wr_mas->content);
-		wr_mas->pivots[end] = mas->last;
-		rcu_assign_pointer(wr_mas->slots[end], wr_mas->entry);
+		wr_mas->pivots[end + 1] = mas->last;
+		rcu_assign_pointer(wr_mas->slots[end + 1], wr_mas->entry);
+		wr_mas->pivots[end] = mas->index - 1;
+		mas->offset = end + 1;
 	}
 
 	if (!wr_mas->content || !wr_mas->entry)
@@ -4338,7 +4349,7 @@ static inline void mas_wr_modify(struct
 		goto slow_path;
 
 	/* Attempt to append */
-	if (new_end == wr_mas->node_end + 1 && mas_wr_append(wr_mas))
+	if (mas_wr_append(wr_mas, new_end))
 		return;
 
 	if (new_end == wr_mas->node_end && mas_wr_slot_store(wr_mas))
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


