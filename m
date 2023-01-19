Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823DDC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjASBSJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjASBQP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:16:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B886B988
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E738B81FB9
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86333C433F0;
        Thu, 19 Jan 2023 01:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090902;
        bh=DiAoIyZoTq2iVYKBjkp4vzYSVSSb/Fz3oKD0l9Oeg+g=;
        h=Date:To:From:Subject:From;
        b=wLEh0cOxKARlnfS69fZ+DFzkARoOJjMwWu2EEFugD9bSmffbUliSSLpKfXC9CGayU
         Z8O3uXjgahzuBewgb3JEbHoH93HmeVxU7g+I+g/SqOd9e2Cy/jQo3xIviWpMK19DM7
         2ILWkmk1GZqdtcmvNgJGAKejCJoztyUt6fLpE2wI=
Date:   Wed, 18 Jan 2023 17:15:02 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-refine-ma_state-init-from-mas_start.patch removed from -mm tree
Message-Id: <20230119011502.86333C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: refine ma_state init from mas_start()
has been removed from the -mm tree.  Its filename was
     maple_tree-refine-ma_state-init-from-mas_start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: refine ma_state init from mas_start()
Date: Wed, 21 Dec 2022 14:00:57 +0800

If mas->node is an MAS_START, there are three cases, and they all assign
different values to mas->node and mas->offset.  So there is no need to set
them to a default value before updating.

Update them directly to make them easier to understand and for better
readability.

Link: https://lkml.kernel.org/r/20221221060058.609003-7-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-refine-ma_state-init-from-mas_start
+++ a/lib/maple_tree.c
@@ -1329,7 +1329,7 @@ static void mas_node_count(struct ma_sta
  * mas_start() - Sets up maple state for operations.
  * @mas: The maple state.
  *
- * If mas->node == MAS_START, then set the min, max, depth, and offset to
+ * If mas->node == MAS_START, then set the min, max and depth to
  * defaults.
  *
  * Return:
@@ -1343,22 +1343,22 @@ static inline struct maple_enode *mas_st
 	if (likely(mas_is_start(mas))) {
 		struct maple_enode *root;
 
-		mas->node = MAS_NONE;
 		mas->min = 0;
 		mas->max = ULONG_MAX;
 		mas->depth = 0;
-		mas->offset = 0;
 
 		root = mas_root(mas);
 		/* Tree with nodes */
 		if (likely(xa_is_node(root))) {
 			mas->depth = 1;
 			mas->node = mte_safe_root(root);
+			mas->offset = 0;
 			return NULL;
 		}
 
 		/* empty tree */
 		if (unlikely(!root)) {
+			mas->node = MAS_NONE;
 			mas->offset = MAPLE_NODE_SLOTS;
 			return NULL;
 		}
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-the-parameter-entry-of-mas_preallocate.patch
mm-mmap-fix-typo-in-comment.patch
maple_tree-fix-comment-of-mte_destroy_walk.patch
mm-mmap-fix-comment-of-unmapped_area_topdown.patch

