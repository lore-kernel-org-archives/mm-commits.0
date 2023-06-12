Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F22AC7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbjFLV2M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjFLV1h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:27:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E55170D
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:27:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5E8862277
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D00C433D2;
        Mon, 12 Jun 2023 21:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605241;
        bh=pLBS9puuPAJPn1CU27U0gQtt7o4+KQsmOM4iE+ZDuH8=;
        h=Date:To:From:Subject:From;
        b=edy9wpIjXgw4VhIf2ipqCDa2irJcy/TnH9boP9/PNVFq20MUSU6O0ccrEYGtGK3h+
         nZplx0eZuEuGYjBA2YBNyq7fs6CdzNUx7XuwB1+UVHYmM0sb72eJ5EVsVCZGWZigb2
         5ouqSWiA0OUbOv1zXVNrTv1C+2kHqpYecF47d5pE=
Date:   Mon, 12 Jun 2023 14:27:20 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-introduce-__mas_set_range.patch added to mm-unstable branch
Message-Id: <20230612212721.24D00C433D2@smtp.kernel.org>
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
Date: Mon, 12 Jun 2023 16:39:43 -0400

mas_set_range() resets the node to MAS_START, which will cause a re-walk
of the tree to the range.  This is unnecessary when the maple state is
already at the correct location of the write.  Add a function that only
sets the range to avoid unnecessary re-walking of the tree.

Link: https://lkml.kernel.org/r/20230612203953.2093911-7-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-introduce-__mas_set_range
+++ a/include/linux/maple_tree.h
@@ -531,6 +531,22 @@ static inline void mas_reset(struct ma_s
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
+       mas->index = start;
+       mas->last = last;
+}
 
 /**
  * mas_set_range() - Set up Maple Tree operation state for a different index.
@@ -545,9 +561,8 @@ static inline void mas_reset(struct ma_s
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

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-adjust-node-allocation-on-mas_rebalance.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
maple_tree-reduce-resets-during-store-setup.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

