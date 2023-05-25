Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93355C77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjEYVE4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241590AbjEYVEq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:04:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F75E10E5
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:04:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6890764B12
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7E4C433EF;
        Thu, 25 May 2023 21:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685048664;
        bh=m4nrDsLCk398EY+G7DpMqH2S+DbwTA/uK4pyBkOghSk=;
        h=Date:To:From:Subject:From;
        b=BPDI23/yLdIc9jqtJoT8wovrqMUIx0R5hxPoqkLubPVbvUcYovfBNN9Fxft626uFK
         hoEMC8FO95Tsw2Y9B609qxw3MKczzWiiN/TgQWBf+Cor+BwlzS+95EQmOZwWkG/5j6
         5zTzb2pNqPrGFyuVUeNOeGhxBRAZrxyQS6mcH7Sg=
Date:   Thu, 25 May 2023 14:04:23 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-rework-mtree_alloc_rangerrange.patch added to mm-unstable branch
Message-Id: <20230525210424.BD7E4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: rework mtree_alloc_{range,rrange}()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-rework-mtree_alloc_rangerrange.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-rework-mtree_alloc_rangerrange.patch

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
Subject: maple_tree: rework mtree_alloc_{range,rrange}()
Date: Wed, 24 May 2023 11:12:38 +0800

Patch series "Clean ups for maple tree", v4.

Some clean ups, mainly to make the code of maple tree more concise.
This patchset has passed the self-test.


This patch (of 10):

Use mas_empty_area{_rev}() to refactor mtree_alloc_{range,rrange}()

Link: https://lkml.kernel.org/r/20230524031247.65949-2-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   57 +++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

--- a/lib/maple_tree.c~maple_tree-rework-mtree_alloc_rangerrange
+++ a/lib/maple_tree.c
@@ -6493,31 +6493,33 @@ int mtree_alloc_range(struct maple_tree
 {
 	int ret = 0;
 
-	MA_STATE(mas, mt, min, min);
+	MA_STATE(mas, mt, 0, 0);
 	if (!mt_is_alloc(mt))
 		return -EINVAL;
 
 	if (WARN_ON_ONCE(mt_is_reserved(entry)))
 		return -EINVAL;
 
-	if (min > max)
-		return -EINVAL;
-
-	if (max < size)
-		return -EINVAL;
-
-	if (!size)
-		return -EINVAL;
-
 	mtree_lock(mt);
 retry:
-	mas.offset = 0;
-	mas.index = min;
-	mas.last = max - size + 1;
-	ret = mas_alloc(&mas, entry, size, startp);
+	ret = mas_empty_area(&mas, min, max, size);
+	if (ret)
+		goto unlock;
+
+	mas_insert(&mas, entry);
+	/*
+	 * mas_nomem() may release the lock, causing the allocated area
+	 * to be unavailable, so try to allocate a free area again.
+	 */
 	if (mas_nomem(&mas, gfp))
 		goto retry;
 
+	if (mas_is_err(&mas))
+		ret = xa_err(mas.node);
+	else
+		*startp = mas.index;
+
+unlock:
 	mtree_unlock(mt);
 	return ret;
 }
@@ -6529,28 +6531,33 @@ int mtree_alloc_rrange(struct maple_tree
 {
 	int ret = 0;
 
-	MA_STATE(mas, mt, min, max - size + 1);
+	MA_STATE(mas, mt, 0, 0);
 	if (!mt_is_alloc(mt))
 		return -EINVAL;
 
 	if (WARN_ON_ONCE(mt_is_reserved(entry)))
 		return -EINVAL;
 
-	if (min > max)
-		return -EINVAL;
-
-	if (max < size - 1)
-		return -EINVAL;
-
-	if (!size)
-		return -EINVAL;
-
 	mtree_lock(mt);
 retry:
-	ret = mas_rev_alloc(&mas, min, max, entry, size, startp);
+	ret = mas_empty_area_rev(&mas, min, max, size);
+	if (ret)
+		goto unlock;
+
+	mas_insert(&mas, entry);
+	/*
+	 * mas_nomem() may release the lock, causing the allocated area
+	 * to be unavailable, so try to allocate a free area again.
+	 */
 	if (mas_nomem(&mas, gfp))
 		goto retry;
 
+	if (mas_is_err(&mas))
+		ret = xa_err(mas.node);
+	else
+		*startp = mas.index;
+
+unlock:
 	mtree_unlock(mt);
 	return ret;
 }
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

radix-tree-move-declarations-to-header-fix.patch
maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch
maple_tree-rework-mtree_alloc_rangerrange.patch
maple_tree-drop-mas_rev_alloc-and-mas_fill_gap.patch
maple_tree-fix-the-arguments-to-__must_hold.patch
maple_tree-simplify-mas_is_span_wr.patch
maple_tree-make-the-code-symmetrical-in-mas_wr_extend_null.patch
maple_tree-add-mas_wr_new_end-to-calculate-new_end-accurately.patch
maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append.patch
maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient.patch
maple_tree-simplify-and-clean-up-mas_wr_node_store.patch
maple_tree-relocate-the-declaration-of-mas_empty_area_rev.patch

