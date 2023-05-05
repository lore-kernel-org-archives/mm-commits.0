Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E7DC77B7D
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 19:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbjEETbz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 15:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjEETbL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 15:31:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17AE6189
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 12:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32C1360AB1
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87732C433D2;
        Fri,  5 May 2023 19:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683315065;
        bh=uGl6kh7ptl5trxBzC7rpddRoPxQiK+kbkw5uS7Oeisc=;
        h=Date:To:From:Subject:From;
        b=uiCCn/VX8R623ICb2Ownx+9eiPY911dMrtieiu2orKi9cjkHp+LsNV4VqGHTqjwVc
         oLGMeckualcmg+tldgyhMcSmn4DepBroWC3JagDxZ8AEnwc2omVjRMDB0OSNg0jzVB
         5mw/DsnyDRw7MYgBLzV5W4fciNsQsutZwNywuXu0=
Date:   Fri, 05 May 2023 12:31:04 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        senozhatsky@chromium.org, richard.weiyang@gmail.com,
        dcb314@hotmail.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch added to mm-unstable branch
Message-Id: <20230505193105.87732C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: revise limit checks in mas_empty_area{_rev}()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch

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
Subject: maple_tree: revise limit checks in mas_empty_area{_rev}()
Date: Fri, 5 May 2023 13:41:53 -0400

Since the maple tree is inclusive in range, ensure that a range of 1 (min
= max) works for searching for a gap in either direction, and make sure
the size is at least 1 but not larger than the delta between min and max.

This commit also updates the testing.  Unfortunately there isn't a way to
safely update the tests and code without a test failure.

Link: https://lkml.kernel.org/r/20230505174204.2665599-26-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c      |   20 +++++++++++++-------
 lib/test_maple_tree.c |   27 ++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 14 deletions(-)

--- a/lib/maple_tree.c~maple_tree-revise-limit-checks-in-mas_empty_area_rev
+++ a/lib/maple_tree.c
@@ -5282,7 +5282,10 @@ int mas_empty_area(struct ma_state *mas,
 	unsigned long *pivots;
 	enum maple_type mt;
 
-	if (min >= max)
+	if (min > max)
+		return -EINVAL;
+
+	if (size == 0 || max - min < size - 1)
 		return -EINVAL;
 
 	if (mas_is_start(mas))
@@ -5337,7 +5340,10 @@ int mas_empty_area_rev(struct ma_state *
 {
 	struct maple_enode *last = mas->node;
 
-	if (min >= max)
+	if (min > max)
+		return -EINVAL;
+
+	if (size == 0 || max - min < size - 1)
 		return -EINVAL;
 
 	if (mas_is_start(mas)) {
@@ -5373,7 +5379,7 @@ int mas_empty_area_rev(struct ma_state *
 		return -EBUSY;
 
 	/* Trim the upper limit to the max. */
-	if (max <= mas->last)
+	if (max < mas->last)
 		mas->last = max;
 
 	mas->index = mas->last - size + 1;
@@ -6409,7 +6415,7 @@ int mtree_alloc_range(struct maple_tree
 {
 	int ret = 0;
 
-	MA_STATE(mas, mt, min, max - size);
+	MA_STATE(mas, mt, min, min);
 	if (!mt_is_alloc(mt))
 		return -EINVAL;
 
@@ -6429,7 +6435,7 @@ int mtree_alloc_range(struct maple_tree
 retry:
 	mas.offset = 0;
 	mas.index = min;
-	mas.last = max - size;
+	mas.last = max - size + 1;
 	ret = mas_alloc(&mas, entry, size, startp);
 	if (mas_nomem(&mas, gfp))
 		goto retry;
@@ -6445,14 +6451,14 @@ int mtree_alloc_rrange(struct maple_tree
 {
 	int ret = 0;
 
-	MA_STATE(mas, mt, min, max - size);
+	MA_STATE(mas, mt, min, max - size + 1);
 	if (!mt_is_alloc(mt))
 		return -EINVAL;
 
 	if (WARN_ON_ONCE(mt_is_reserved(entry)))
 		return -EINVAL;
 
-	if (min >= max)
+	if (min > max)
 		return -EINVAL;
 
 	if (max < size - 1)
--- a/lib/test_maple_tree.c~maple_tree-revise-limit-checks-in-mas_empty_area_rev
+++ a/lib/test_maple_tree.c
@@ -123,7 +123,7 @@ static noinline void __init check_mtree_
 	unsigned long result = expected + 1;
 	int ret;
 
-	ret = mtree_alloc_rrange(mt, &result, ptr, size, start, end - 1,
+	ret = mtree_alloc_rrange(mt, &result, ptr, size, start, end,
 			GFP_KERNEL);
 	MT_BUG_ON(mt, ret != eret);
 	if (ret)
@@ -701,7 +701,7 @@ static noinline void __init check_alloc_
 		0,              /* Return value success. */
 
 		0x0,            /* Min */
-		0x565234AF1 << 12,    /* Max */
+		0x565234AF0 << 12,    /* Max */
 		0x3000,         /* Size */
 		0x565234AEE << 12,  /* max - 3. */
 		0,              /* Return value success. */
@@ -713,14 +713,14 @@ static noinline void __init check_alloc_
 		0,              /* Return value success. */
 
 		0x0,            /* Min */
-		0x7F36D510A << 12,    /* Max */
+		0x7F36D5109 << 12,    /* Max */
 		0x4000,         /* Size */
 		0x7F36D5106 << 12,    /* First rev hole of size 0x4000 */
 		0,              /* Return value success. */
 
 		/* Ascend test. */
 		0x0,
-		34148798629 << 12,
+		34148798628 << 12,
 		19 << 12,
 		34148797418 << 12,
 		0x0,
@@ -732,6 +732,12 @@ static noinline void __init check_alloc_
 		0x0,
 		-EBUSY,
 
+		/* Single space test. */
+		34148798725 << 12,
+		34148798725 << 12,
+		1 << 12,
+		34148798725 << 12,
+		0,
 	};
 
 	int i, range_count = ARRAY_SIZE(range);
@@ -780,9 +786,9 @@ static noinline void __init check_alloc_
 	mas_unlock(&mas);
 	for (i = 0; i < req_range_count; i += 5) {
 #if DEBUG_REV_RANGE
-		pr_debug("\tReverse request between %lu-%lu size %lu, should get %lu\n",
-				req_range[i] >> 12,
-				(req_range[i + 1] >> 12) - 1,
+		pr_debug("\tReverse request %d between %lu-%lu size %lu, should get %lu\n",
+				i, req_range[i] >> 12,
+				(req_range[i + 1] >> 12),
 				req_range[i+2] >> 12,
 				req_range[i+3] >> 12);
 #endif
@@ -901,6 +907,13 @@ static noinline void __init check_alloc_
 		4503599618982063UL << 12,  /* Size */
 		34359052178 << 12,  /* Expected location */
 		-EBUSY,             /* Return failure. */
+
+		/* Test a single entry */
+		34148798648 << 12,		/* Min */
+		34148798648 << 12,		/* Max */
+		4096,			/* Size of 1 */
+		34148798648 << 12,	/* Location is the same as min/max */
+		0,			/* Success */
 	};
 	int i, range_count = ARRAY_SIZE(range);
 	int req_range_count = ARRAY_SIZE(req_range);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-static-analyser-cppcheck-issue.patch
maple_tree-avoid-unnecessary-ascending.patch
maple_tree-clean-up-mas_dfs_postorder.patch
maple_tree-add-debug-bug_on-and-warn_on-variants.patch
maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent.patch
maple_tree-use-mas_bug_on-in-mas_set_height.patch
maple_tree-use-mas_bug_on-from-mas_topiary_range.patch
maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc.patch
maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch
maple_tree-return-error-on-mte_pivots-out-of-range.patch
maple_tree-make-test-code-work-without-debug-enabled.patch
mm-update-validate_mm-to-use-vma-iterator.patch
mm-update-vma_iter_store-to-use-mas_warn_on.patch
maple_tree-add-__init-and-__exit-to-test-module.patch
maple_tree-remove-unnecessary-check-from-mas_destroy.patch
maple_tree-mas_start-reset-depth-on-dead-node.patch
mm-mmap-change-do_vmi_align_munmap-for-maple-tree-iterator-changes.patch
maple_tree-try-harder-to-keep-active-node-after-mas_next.patch
maple_tree-try-harder-to-keep-active-node-with-mas_prev.patch
maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch
maple_tree-fix-testing-mas_empty_area.patch
maple_tree-introduce-mas_next_slot-interface.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch
maple_tree-relocate-mas_rewalk-and-mas_rewalk_if_dead.patch
maple_tree-introduce-mas_prev_slot-interface.patch
maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch
maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch
maple_tree-update-testing-code-for-mas_nextprevwalk.patch
mm-add-vma_iter_nextprev_range-to-vma-iterator.patch
mm-avoid-rewalk-in-mmap_region.patch
maple_tree-add-gap-to-check_alloc_rev_range-testcase.patch

