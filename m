Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866A5C7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbjFLV1w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFLV1f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E5910FA
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA2BD61EA9
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186AEC433D2;
        Mon, 12 Jun 2023 21:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605233;
        bh=56G6VyaVeqIrbUdtKKvCX0pXuPHjIaoPn3lzAuTDfsU=;
        h=Date:To:From:Subject:From;
        b=m8nWLPx44ECXhI17TBlBHkZYOBd+lavp+GAY9wdGJ+bNgdg06GuDLraiybzl7tfxc
         lcP9LY5B0TKlO7M50aEmoerbM5Fup8CERWAErJ2ENxvNdb2im3WPIr6O725mNQbGTJ
         ZfbC2jSFyuxAmovLKrWkE2AvSCwaw5+1ELGpvDB0=
Date:   Mon, 12 Jun 2023 14:27:12 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-benchmarking-for-mas_prev.patch added to mm-unstable branch
Message-Id: <20230612212713.186AEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add benchmarking for mas_prev()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-benchmarking-for-mas_prev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-benchmarking-for-mas_prev.patch

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
Subject: maple_tree: add benchmarking for mas_prev()
Date: Mon, 12 Jun 2023 16:39:39 -0400

Link: https://lkml.kernel.org/r/20230612203953.2093911-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-add-benchmarking-for-mas_prev
+++ a/lib/test_maple_tree.c
@@ -45,6 +45,7 @@ atomic_t maple_tree_tests_passed;
 /* #define BENCH_MT_FOR_EACH */
 /* #define BENCH_FORK */
 /* #define BENCH_MAS_FOR_EACH */
+/* #define BENCH_MAS_PREV */
 
 #ifdef __KERNEL__
 #define mt_set_non_kernel(x)		do {} while (0)
@@ -1735,7 +1736,35 @@ static noinline void __init bench_mas_fo
 
 }
 #endif
+#if defined(BENCH_MAS_PREV)
+static noinline void __init bench_mas_prev(struct maple_tree *mt)
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
 
+	rcu_read_lock();
+	for (i = 0; i < count; i++) {
+		unsigned long j = 2495;
+
+		mas_set(&mas, ULONG_MAX);
+		while ((entry = mas_prev(&mas, 0)) != NULL) {
+			MT_BUG_ON(mt, entry != xa_mk_value(j));
+			j -= 5;
+		}
+	}
+	rcu_read_unlock();
+
+}
+#endif
 /* check_forking - simulate the kernel forking sequence with the tree. */
 static noinline void __init check_forking(struct maple_tree *mt)
 {
@@ -3468,6 +3497,13 @@ static int __init maple_tree_seed(void)
 	mtree_destroy(&tree);
 	goto skip;
 #endif
+#if defined(BENCH_MAS_PREV)
+#define BENCH
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	bench_mas_prev(&tree);
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

