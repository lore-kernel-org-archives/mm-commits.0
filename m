Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9049C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjFIXaU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbjFIX3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348F54213
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBDDD63EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3C3C433D2;
        Fri,  9 Jun 2023 23:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353314;
        bh=9GeIhSCnCVCaKMPpm5b+6B76mXkL4HbN7xmLtkwb+i4=;
        h=Date:To:From:Subject:From;
        b=reqUQz45SIpWnPandkHgKEENdCKq6PxfVxFX7esrFj4wlcaLmO1Bilh/ggT9WyMtK
         nr9WQOZXKkMNIRzs4hwoTvZc7CBY4bVgkxI09vkmwe9Ci7RWjerTtKcGv3DG/OOB0o
         NWYyTa6emJu6r7N26taPOMxG09qecWpzm3apFjmE=
Date:   Fri, 09 Jun 2023 16:28:33 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch removed from -mm tree
Message-Id: <20230609232834.1F3C3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: revise limit checks in mas_empty_area{_rev}()
has been removed from the -mm tree.  Its filename was
     maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: revise limit checks in mas_empty_area{_rev}()
Date: Thu, 18 May 2023 10:55:34 -0400

Since the maple tree is inclusive in range, ensure that a range of 1 (min
= max) works for searching for a gap in either direction, and make sure
the size is at least 1 but not larger than the delta between min and max.

This commit also updates the testing.  Unfortunately there isn't a way to
safely update the tests and code without a test failure.

Link: https://lkml.kernel.org/r/20230518145544.1722059-26-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c      |   20 +++++++++++++-------
 lib/test_maple_tree.c |   28 +++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 14 deletions(-)

--- a/lib/maple_tree.c~maple_tree-revise-limit-checks-in-mas_empty_area_rev
+++ a/lib/maple_tree.c
@@ -5283,7 +5283,10 @@ int mas_empty_area(struct ma_state *mas,
 	unsigned long *pivots;
 	enum maple_type mt;
 
-	if (min >= max)
+	if (min > max)
+		return -EINVAL;
+
+	if (size == 0 || max - min < size - 1)
 		return -EINVAL;
 
 	if (mas_is_start(mas))
@@ -5332,7 +5335,10 @@ int mas_empty_area_rev(struct ma_state *
 {
 	struct maple_enode *last = mas->node;
 
-	if (min >= max)
+	if (min > max)
+		return -EINVAL;
+
+	if (size == 0 || max - min < size - 1)
 		return -EINVAL;
 
 	if (mas_is_start(mas)) {
@@ -5368,7 +5374,7 @@ int mas_empty_area_rev(struct ma_state *
 		return -EBUSY;
 
 	/* Trim the upper limit to the max. */
-	if (max <= mas->last)
+	if (max < mas->last)
 		mas->last = max;
 
 	mas->index = mas->last - size + 1;
@@ -6404,7 +6410,7 @@ int mtree_alloc_range(struct maple_tree
 {
 	int ret = 0;
 
-	MA_STATE(mas, mt, min, max - size);
+	MA_STATE(mas, mt, min, min);
 	if (!mt_is_alloc(mt))
 		return -EINVAL;
 
@@ -6424,7 +6430,7 @@ int mtree_alloc_range(struct maple_tree
 retry:
 	mas.offset = 0;
 	mas.index = min;
-	mas.last = max - size;
+	mas.last = max - size + 1;
 	ret = mas_alloc(&mas, entry, size, startp);
 	if (mas_nomem(&mas, gfp))
 		goto retry;
@@ -6440,14 +6446,14 @@ int mtree_alloc_rrange(struct maple_tree
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
@@ -798,6 +804,7 @@ static noinline void __init check_alloc_
 
 	mt_set_non_kernel(1);
 	mtree_erase(mt, 34148798727); /* create a deleted range. */
+	mtree_erase(mt, 34148798725);
 	check_mtree_alloc_rrange(mt, 0, 34359052173, 210253414,
 			34148798725, 0, mt);
 
@@ -901,6 +908,13 @@ static noinline void __init check_alloc_
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

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

