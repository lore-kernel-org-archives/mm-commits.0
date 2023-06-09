Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC089C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjFIXdA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjFIXb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E9346A5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84F1065D0A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCA0C433D2;
        Fri,  9 Jun 2023 23:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353374;
        bh=klPOSp9kaa0sm6BqsiLQpWRwV7zQWFt83jMdU2Dt+0w=;
        h=Date:To:From:Subject:From;
        b=SE7mrWsxedMgakZcawF7hpDHDP2ypRCms3vQHkDkbHLx1EhcQib7t4Tj3U+i98tyl
         5VY3kT+oLED5cEatuaqdCoGlMlRvriL0LHcc7E5pDOp65LaNOPhIFqq77akPIbzSmu
         emQeJnDjPBILbzpoOCBv26MwoDA/dGMqgdr+OC+o=
Date:   Fri, 09 Jun 2023 16:29:33 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-mas_wr_new_end-to-calculate-new_end-accurately.patch removed from -mm tree
Message-Id: <20230609232933.DFCA0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add mas_wr_new_end() to calculate new_end accurately
has been removed from the -mm tree.  Its filename was
     maple_tree-add-mas_wr_new_end-to-calculate-new_end-accurately.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: add mas_wr_new_end() to calculate new_end accurately
Date: Wed, 24 May 2023 11:12:43 +0800

The previous new_end calculation is inaccurate, because it assumes that
two new pivots must be added (this is inaccurate), and sometimes it will
miss the fast path and enter the slow path.  Add mas_wr_new_end() to
accurately calculate new_end to make the conditions for entering the fast
path more accurate.

Link: https://lkml.kernel.org/r/20230524031247.65949-7-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-mas_wr_new_end-to-calculate-new_end-accurately
+++ a/lib/maple_tree.c
@@ -4296,6 +4296,21 @@ static inline void mas_wr_extend_null(st
 	}
 }
 
+static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
+{
+	struct ma_state *mas = wr_mas->mas;
+	unsigned char new_end = wr_mas->node_end + 2;
+
+	new_end -= wr_mas->offset_end - mas->offset;
+	if (wr_mas->r_min == mas->index)
+		new_end--;
+
+	if (wr_mas->end_piv == mas->last)
+		new_end--;
+
+	return new_end;
+}
+
 static inline bool mas_wr_append(struct ma_wr_state *wr_mas)
 {
 	unsigned char end = wr_mas->node_end;
@@ -4351,9 +4366,8 @@ static void mas_wr_bnode(struct ma_wr_st
 
 static inline void mas_wr_modify(struct ma_wr_state *wr_mas)
 {
-	unsigned char node_slots;
-	unsigned char node_size;
 	struct ma_state *mas = wr_mas->mas;
+	unsigned char new_end;
 
 	/* Direct replacement */
 	if (wr_mas->r_min == mas->index && wr_mas->r_max == mas->last) {
@@ -4363,17 +4377,15 @@ static inline void mas_wr_modify(struct
 		return;
 	}
 
-	/* Attempt to append */
-	node_slots = mt_slots[wr_mas->type];
-	node_size = wr_mas->node_end - wr_mas->offset_end + mas->offset + 2;
-	if (mas->max == ULONG_MAX)
-		node_size++;
-
-	/* slot and node store will not fit, go to the slow path */
-	if (unlikely(node_size >= node_slots))
+	/*
+	 * new_end exceeds the size of the maple node and cannot enter the fast
+	 * path.
+	 */
+	new_end = mas_wr_new_end(wr_mas);
+	if (new_end >= mt_slots[wr_mas->type])
 		goto slow_path;
 
-	if (wr_mas->entry && (wr_mas->node_end < node_slots - 1) &&
+	if (wr_mas->entry && (wr_mas->node_end < mt_slots[wr_mas->type] - 1) &&
 	    (mas->offset == wr_mas->node_end) && mas_wr_append(wr_mas)) {
 		if (!wr_mas->content || !wr_mas->entry)
 			mas_update_gap(mas);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


