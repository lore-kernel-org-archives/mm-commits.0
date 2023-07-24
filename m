Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3C4C001DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 18:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjGXS71 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 14:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjGXS70 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 14:59:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB631188
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 11:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4363561382
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 18:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70425C433C8;
        Mon, 24 Jul 2023 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225164;
        bh=Hg68wj3hT7cm5Oa1OUxwKvIU5Ixm84BgC1k+8NGs7S4=;
        h=Date:To:From:Subject:From;
        b=lOKZ7xyIY5U4S8tqyj9J2ewT0hnvhns2d88OHNCTQUqgU41bvV2jycA5IRdvzTy95
         B+UJvrlOh3njaxFZXPHg0y0DRvebOQnkuObvXyVo/LkW23bOsGx/YgUai3QFxmFVib
         gkPkK2Nz20H0HSqyPaR69RM1x0pyTrs944/ZL4KE=
Date:   Mon, 24 Jul 2023 11:59:23 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-introduce-__mas_set_range.patch added to mm-unstable branch
Message-Id: <20230724185924.70425C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: introduce __mas_set_range()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-introduce-__mas_set_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-introduce-__mas_set_range.patch

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
Subject: maple_tree: introduce __mas_set_range()
Date: Mon, 24 Jul 2023 14:31:47 -0400

mas_set_range() resets the node to MAS_START, which will cause a re-walk
of the tree to the range.  This is unnecessary when the maple state is
already at the correct location of the write.  Add a function that only
sets the range to avoid unnecessary re-walking of the tree.

Link: https://lkml.kernel.org/r/20230724183157.3939892-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-introduce-__mas_set_range
+++ a/include/linux/maple_tree.h
@@ -539,6 +539,22 @@ static inline void mas_reset(struct ma_s
  */
 #define mas_for_each(__mas, __entry, __max) \
 	while (((__entry) = mas_find((__mas), (__max))) != NULL)
+/**
+ * __mas_set_range() - Set up Maple Tree operation state to a sub-range of the
+ * current location.
+ * @mas: Maple Tree operation state.
+ * @start: New start of range in the Maple Tree.
+ * @last: New end of range in the Maple Tree.
+ *
+ * set the internal maple state values to a sub-range.
+ * Please use mas_set_range() if you do not know where you are in the tree.
+ */
+static inline void __mas_set_range(struct ma_state *mas, unsigned long start,
+		unsigned long last)
+{
+	mas->index = start;
+	mas->last = last;
+}
 
 /**
  * mas_set_range() - Set up Maple Tree operation state for a different index.
@@ -553,9 +569,8 @@ static inline void mas_reset(struct ma_s
 static inline
 void mas_set_range(struct ma_state *mas, unsigned long start, unsigned long last)
 {
-	       mas->index = start;
-	       mas->last = last;
-	       mas->node = MAS_START;
+	__mas_set_range(mas, start, last);
+	mas->node = MAS_START;
 }
 
 /**
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-change-do_vmi_align_munmap-tracking-of-vmas-to-remove.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch

