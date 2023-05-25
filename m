Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3ACC77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbjEYVE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241853AbjEYVEs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:04:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CA310EC
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3E0B64B26
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D44C433EF;
        Thu, 25 May 2023 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685048668;
        bh=CscrjAwM4CvZssREZmAx/yDT/Lv927UFAexsjcekrlw=;
        h=Date:To:From:Subject:From;
        b=g1PJWAv9t5jsZWugQWfCoqHFpuT0jDg/O7FhTnZS5cKfSDlWItHXVBnPldaeo+erG
         K183My48PWmdHH8BdwbJe27SBxedPWgw3jvQBtswBluSA2DDdf9Pl42IybhdjPs88N
         bvsUE2XRyGX8aOIrH/T+fOzDfLk/bdDkMR74CM/Q=
Date:   Thu, 25 May 2023 14:04:27 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-the-arguments-to-__must_hold.patch added to mm-unstable branch
Message-Id: <20230525210428.57D44C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix the arguments to __must_hold()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-the-arguments-to-__must_hold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-the-arguments-to-__must_hold.patch

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
Subject: maple_tree: fix the arguments to __must_hold()
Date: Wed, 24 May 2023 11:12:40 +0800

Fix the arguments to __must_hold() to make sparse work.

Link: https://lkml.kernel.org/r/20230524031247.65949-4-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-the-arguments-to-__must_hold
+++ a/lib/maple_tree.c
@@ -1752,7 +1752,7 @@ static inline void mas_adopt_children(st
  * leave the node (true) and handle the adoption and free elsewhere.
  */
 static inline void mas_replace(struct ma_state *mas, bool advanced)
-	__must_hold(mas->tree->lock)
+	__must_hold(mas->tree->ma_lock)
 {
 	struct maple_node *mn = mas_mn(mas);
 	struct maple_enode *old_enode;
@@ -1792,7 +1792,7 @@ static inline void mas_replace(struct ma
  * @child: the maple state to store the child.
  */
 static inline bool mas_new_child(struct ma_state *mas, struct ma_state *child)
-	__must_hold(mas->tree->lock)
+	__must_hold(mas->tree->ma_lock)
 {
 	enum maple_type mt;
 	unsigned char offset;
@@ -6204,7 +6204,7 @@ EXPORT_SYMBOL_GPL(mas_erase);
  * Return: true on allocation, false otherwise.
  */
 bool mas_nomem(struct ma_state *mas, gfp_t gfp)
-	__must_hold(mas->tree->lock)
+	__must_hold(mas->tree->ma_lock)
 {
 	if (likely(mas->node != MA_ERROR(-ENOMEM))) {
 		mas_destroy(mas);
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

