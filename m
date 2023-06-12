Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D618C88CB2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjFLV1v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjFLV1f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5323E10F6
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E35F661EA9
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43458C433EF;
        Mon, 12 Jun 2023 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605231;
        bh=4YmmEV44887FQukzrLZqhBpA07ysD/2huv5ggP/OdSs=;
        h=Date:To:From:Subject:From;
        b=bD51SJ/M7AmoHShvM94IP3R9it9vnK4PbMqqEVezh2GwMImaEIO1YQotrICyxX+Wj
         i5BzBIPkSsmiaWcRbU6fxLzGm8afClEv9Z6p264HuymPIU9RrXL2YkoiPeeKrmQVBj
         MupOeXwH/FEb0fCr0fDfRlS/zIsVWxCrELhtd6Wc=
Date:   Mon, 12 Jun 2023 14:27:10 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-benchmarking-for-mas_for_each.patch added to mm-unstable branch
Message-Id: <20230612212711.43458C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add benchmarking for mas_for_each
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-benchmarking-for-mas_for_each.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-benchmarking-for-mas_for_each.patch

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
Subject: maple_tree: add benchmarking for mas_for_each
Date: Mon, 12 Jun 2023 16:39:38 -0400

Patch series "Reduce preallocations for maple tree", v2.

Initial work on preallocations showed no regression in performance during
testing, but recently some users (both on [1] and off [android] list) have
reported that preallocating the worst-case number of nodes has caused some
slow down.  This patch set addresses the number of allocations in a few
ways.

During munmap() most munmap() operations will remove a single VMA, so
leverage the fact that the maple tree can place a single pointer at range
0 - 0 without allocating.  This is done by changing the index in the
'sidetree'.

Re-introduce the entry argument to mas_preallocate() so that a more
intelligent guess of the node count can be made.

During development of v2 of this patch set, I also noticed that the number
of nodes being allocated for a rebalance was beyond what could possibly be
needed.  This is addressed in patch 0008.

Patches are in the following order:
0001-0002: Testing framework for benchmarking some operations
0003-0004: Reduction of maple node allocation in sidetree
0005:      Small cleanup of do_vmi_align_munmap()
0006-0015: mas_preallocate() calculation change
0016:      Change the vma iterator order


This patch (of 16):

Add a way to test the speed of mas_for_each() to the testing code.

Link: https://lkml.kernel.org/r/20230612203953.2093911-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230612203953.2093911-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-add-benchmarking-for-mas_for_each
+++ a/lib/test_maple_tree.c
@@ -44,6 +44,7 @@ atomic_t maple_tree_tests_passed;
 /* #define BENCH_WALK */
 /* #define BENCH_MT_FOR_EACH */
 /* #define BENCH_FORK */
+/* #define BENCH_MAS_FOR_EACH */
 
 #ifdef __KERNEL__
 #define mt_set_non_kernel(x)		do {} while (0)
@@ -1705,6 +1706,36 @@ static noinline void __init bench_mt_for
 }
 #endif
 
+#if defined(BENCH_MAS_FOR_EACH)
+static noinline void __init bench_mas_for_each(struct maple_tree *mt)
+{
+	int i, count = 1000000;
+	unsigned long max = 2500;
+	void *entry;
+	MA_STATE(mas, mt, 0, 0);
+
+	for (i = 0; i < max; i += 5) {
+		int gap = 4;
+		if (i % 30 == 0)
+			gap = 3;
+		mtree_store_range(mt, i, i + gap, xa_mk_value(i), GFP_KERNEL);
+	}
+
+	rcu_read_lock();
+	for (i = 0; i < count; i++) {
+		unsigned long j = 0;
+
+		mas_for_each(&mas, entry, max) {
+			MT_BUG_ON(mt, entry != xa_mk_value(j));
+			j += 5;
+		}
+		mas_set(&mas, 0);
+	}
+	rcu_read_unlock();
+
+}
+#endif
+
 /* check_forking - simulate the kernel forking sequence with the tree. */
 static noinline void __init check_forking(struct maple_tree *mt)
 {
@@ -3430,6 +3461,13 @@ static int __init maple_tree_seed(void)
 	mtree_destroy(&tree);
 	goto skip;
 #endif
+#if defined(BENCH_MAS_FOR_EACH)
+#define BENCH
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	bench_mas_for_each(&tree);
+	mtree_destroy(&tree);
+	goto skip;
+#endif
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_iteration(&tree);
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

