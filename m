Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB86C77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbjEYVFM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241950AbjEYVEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779A819C
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8130164B28
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A9DC433EF;
        Thu, 25 May 2023 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685048680;
        bh=yCyp7DycSaM5/86JCnoWUlnZuuWBqo0/R5NCNe2Q6sk=;
        h=Date:To:From:Subject:From;
        b=2Js1bkzR8R7125DMZOtGrv7Cbp3M73G+sWpfYrYQNmyYFQzvR3xdohqdrJJU4noRy
         5b4WKnek3gJzCGbZlSXeiTgNg3kdLZ+VtmMt5OIYKTk2o7mN41TtyqfnOXvqWz1o8d
         wQjkhMQqMLORR4pfD4Ri3UGJ0BDOZ6QVtNbTDESo=
Date:   Thu, 25 May 2023 14:04:40 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-relocate-the-declaration-of-mas_empty_area_rev.patch added to mm-unstable branch
Message-Id: <20230525210440.D8A9DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: relocate the declaration of mas_empty_area_rev().
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-relocate-the-declaration-of-mas_empty_area_rev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-relocate-the-declaration-of-mas_empty_area_rev.patch

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
Subject: maple_tree: relocate the declaration of mas_empty_area_rev().
Date: Wed, 24 May 2023 11:12:47 +0800

Relocate the declaration of mas_empty_area_rev() so that mas_empty_area()
and mas_empty_area_rev() are together.

Link: https://lkml.kernel.org/r/20230524031247.65949-11-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-relocate-the-declaration-of-mas_empty_area_rev
+++ a/include/linux/maple_tree.h
@@ -474,6 +474,12 @@ void *mas_next_range(struct ma_state *ma
 
 int mas_empty_area(struct ma_state *mas, unsigned long min, unsigned long max,
 		   unsigned long size);
+/*
+ * This finds an empty area from the highest address to the lowest.
+ * AKA "Topdown" version,
+ */
+int mas_empty_area_rev(struct ma_state *mas, unsigned long min,
+		       unsigned long max, unsigned long size);
 
 static inline void mas_init(struct ma_state *mas, struct maple_tree *tree,
 			    unsigned long addr)
@@ -497,12 +503,6 @@ static inline bool mas_is_paused(const s
 	return mas->node == MAS_PAUSE;
 }
 
-/*
- * This finds an empty area from the highest address to the lowest.
- * AKA "Topdown" version,
- */
-int mas_empty_area_rev(struct ma_state *mas, unsigned long min,
-		       unsigned long max, unsigned long size);
 /**
  * mas_reset() - Reset a Maple Tree operation state.
  * @mas: Maple Tree operation state.
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

