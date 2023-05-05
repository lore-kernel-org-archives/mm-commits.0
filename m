Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19549C77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 19:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbjEETbM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 15:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjEETat (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 15:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E517E4C05
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 12:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80CFD64024
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 19:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D51C433D2;
        Fri,  5 May 2023 19:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683315046;
        bh=XGY0G/skCID2qWsFA/XEuhVLA9rM8p62ftoXQ7hd6qU=;
        h=Date:To:From:Subject:From;
        b=SRfA2L9e8BZLnHQy5IjjJUvKDINtH1a4Rx803LDQS5sD+AHuOrPLttJsriZj/Ddu4
         Q1K0hHOEdnPZZqGkBjmx/bFDvkeiJoWNHzZt7X2vt252aPJAs4vIuUPMKqNtEl8ElE
         fdN+TKSLtx/7z1gHmbICa84yYChtuqL2e/s7QpFw=
Date:   Fri, 05 May 2023 12:30:46 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        senozhatsky@chromium.org, richard.weiyang@gmail.com,
        dcb314@hotmail.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-make-test-code-work-without-debug-enabled.patch added to mm-unstable branch
Message-Id: <20230505193046.D4D51C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: make test code work without debug enabled
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-make-test-code-work-without-debug-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-make-test-code-work-without-debug-enabled.patch

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
Subject: maple_tree: make test code work without debug enabled
Date: Fri, 5 May 2023 13:41:44 -0400

The test code is less useful without debug, but can still do general
validations.  Define mt_dump(), mas_dump() and mas_wr_dump() as a noop if
debug is not enabled and document it in the test module information that
more information can be obtained with another kernel config option.

MT_BUG_ON() will report a failures without tree dumps, and the output will
be less useful.

Link: https://lkml.kernel.org/r/20230505174204.2665599-17-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                |   10 +++++++---
 lib/test_maple_tree.c            |   27 ++++++++++++++++++++++++---
 tools/testing/radix-tree/maple.c |    1 -
 3 files changed, 31 insertions(+), 7 deletions(-)

--- a/lib/Kconfig.debug~maple_tree-make-test-code-work-without-debug-enabled
+++ a/lib/Kconfig.debug
@@ -2293,9 +2293,13 @@ config TEST_XARRAY
 	tristate "Test the XArray code at runtime"
 
 config TEST_MAPLE_TREE
-	depends on DEBUG_KERNEL
-	select DEBUG_MAPLE_TREE
-	tristate "Test the Maple Tree code at runtime"
+	tristate "Test the Maple Tree code at runtime or module load"
+	help
+	  Enable this option to test the maple tree code functions at boot, or
+	  when the module is loaded. Enable "Debug Maple Trees" will enable
+	  more verbose output on failures.
+
+	  If unsure, say N.
 
 config TEST_RHASHTABLE
 	tristate "Perform selftest on resizable hash table"
--- a/lib/test_maple_tree.c~maple_tree-make-test-code-work-without-debug-enabled
+++ a/lib/test_maple_tree.c
@@ -11,12 +11,33 @@
 #include <linux/module.h>
 
 #define MTREE_ALLOC_MAX 0x2000000000000Ul
-#ifndef CONFIG_DEBUG_MAPLE_TREE
-#define CONFIG_DEBUG_MAPLE_TREE
-#endif
 #define CONFIG_MAPLE_SEARCH
 #define MAPLE_32BIT (MAPLE_NODE_SLOTS > 31)
 
+#ifndef CONFIG_DEBUG_MAPLE_TREE
+#define mt_dump(mt, fmt)		do {} while (0)
+#define mt_validate(mt)			do {} while (0)
+#define mt_cache_shrink()		do {} while (0)
+#define mas_dump(mas)			do {} while (0)
+#define mas_wr_dump(mas)		do {} while (0)
+atomic_t maple_tree_tests_run;
+atomic_t maple_tree_tests_passed;
+#undef MT_BUG_ON
+
+#define MT_BUG_ON(__tree, __x) do {					\
+	atomic_inc(&maple_tree_tests_run);				\
+	if (__x) {							\
+		pr_info("BUG at %s:%d (%u)\n",				\
+		__func__, __LINE__, __x);				\
+		pr_info("Pass: %u Run:%u\n",				\
+			atomic_read(&maple_tree_tests_passed),		\
+			atomic_read(&maple_tree_tests_run));		\
+	} else {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	}								\
+} while (0)
+#endif
+
 /* #define BENCH_SLOT_STORE */
 /* #define BENCH_NODE_STORE */
 /* #define BENCH_AWALK */
--- a/tools/testing/radix-tree/maple.c~maple_tree-make-test-code-work-without-debug-enabled
+++ a/tools/testing/radix-tree/maple.c
@@ -22,7 +22,6 @@
 #define dump_stack()	assert(0)
 
 #include "../../../lib/maple_tree.c"
-#undef CONFIG_DEBUG_MAPLE_TREE
 #include "../../../lib/test_maple_tree.c"
 
 #define RCU_RANGE_COUNT 1000
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

