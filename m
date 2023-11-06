Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5C7C0018A
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjKFR2Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbjKFR2N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:28:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7506D42
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:28:10 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E5FC433C8;
        Mon,  6 Nov 2023 17:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699291690;
        bh=pUgs3k12AxiNUIAvCpCHV0cux5O6wJ6uvv84kXnAU8Y=;
        h=Date:To:From:Subject:From;
        b=kv9V4XSrWqpUW1uoJ8BqutPXi4it3671OtYO36yZVQMFGsMpfJnry1zU+UGKyIBLs
         LeZfftByveWAzHvibIZ3yG4b1Vw7Wj0zr1xtDWp8YjwcJlkjQ9FwZ6ka/iXZkqlmeZ
         0gnuMT6IGzoeoSoNz/GcRv5wMSls3B6Xz58Cs91g=
Date:   Mon, 06 Nov 2023 09:28:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        peterz@infradead.org, npiggin@gmail.com, mst@redhat.com,
        mjguzik@gmail.com, michael.christie@oracle.com,
        mathieu.desnoyers@efficios.com, Liam.Howlett@oracle.com,
        corbet@lwn.net, brauner@kernel.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-skip-other-tests-when-bench-is-enabled.patch added to mm-unstable branch
Message-Id: <20231106172810.42E5FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: skip other tests when BENCH is enabled
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-skip-other-tests-when-bench-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-skip-other-tests-when-bench-is-enabled.patch

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
Subject: maple_tree: skip other tests when BENCH is enabled
Date: Fri, 27 Oct 2023 11:38:42 +0800

Skip other tests when BENCH is enabled so that performance can be measured
in user space.

Link: https://lkml.kernel.org/r/20231027033845.90608-8-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c            |    8 ++++----
 tools/testing/radix-tree/maple.c |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/lib/test_maple_tree.c~maple_tree-skip-other-tests-when-bench-is-enabled
+++ a/lib/test_maple_tree.c
@@ -3585,10 +3585,6 @@ static int __init maple_tree_seed(void)
 
 	pr_info("\nTEST STARTING\n\n");
 
-	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
-	check_root_expand(&tree);
-	mtree_destroy(&tree);
-
 #if defined(BENCH_SLOT_STORE)
 #define BENCH
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
@@ -3647,6 +3643,10 @@ static int __init maple_tree_seed(void)
 #endif
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_root_expand(&tree);
+	mtree_destroy(&tree);
+
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_iteration(&tree);
 	mtree_destroy(&tree);
 
--- a/tools/testing/radix-tree/maple.c~maple_tree-skip-other-tests-when-bench-is-enabled
+++ a/tools/testing/radix-tree/maple.c
@@ -36299,7 +36299,9 @@ void farmer_tests(void)
 
 void maple_tree_tests(void)
 {
+#if !defined(BENCH)
 	farmer_tests();
+#endif
 	maple_tree_seed();
 	maple_tree_harvest();
 }
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-add-mt_free_one-and-mt_attr-helpers.patch
maple_tree-introduce-mtreemas_lock_nested.patch
maple_tree-introduce-interfaces-__mt_dup-and-mtree_dup.patch
radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch
maple_tree-add-test-for-mtree_dup.patch
maple_tree-update-the-documentation-of-maple-tree.patch
maple_tree-skip-other-tests-when-bench-is-enabled.patch
maple_tree-update-check_forking-and-bench_forking.patch
maple_tree-preserve-the-tree-attributes-when-destroying-maple-tree.patch
fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap.patch

