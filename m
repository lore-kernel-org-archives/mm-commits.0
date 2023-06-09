Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DB3C7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjFIXaN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjFIX2i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524824208
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E36C461036
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F38C433D2;
        Fri,  9 Jun 2023 23:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353302;
        bh=3FVy7LsPUaC4XyPi2ME8UAtbAYp0+daUDoGpYmQGdkE=;
        h=Date:To:From:Subject:From;
        b=1hkHmjNtzRhldAoViFNrt4c8ShlWT51a9RElYaXw/SHl68iqL792o/Jb8j7kRq495
         MOrNc8F/LqtJgNYJGzqy55WSpd9hoe8rtwmVzffK3J5DszYtMpXAmcNqLozW4wDgRl
         rRescCMePo632Na2mz/Jf+B09h59h8mKHobt6Py0=
Date:   Fri, 09 Jun 2023 16:28:21 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-make-test-code-work-without-debug-enabled.patch removed from -mm tree
Message-Id: <20230609232822.45F38C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: make test code work without debug enabled
has been removed from the -mm tree.  Its filename was
     maple_tree-make-test-code-work-without-debug-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: make test code work without debug enabled
Date: Thu, 18 May 2023 10:55:25 -0400

The test code is less useful without debug, but can still do general
validations.  Define mt_dump(), mas_dump() and mas_wr_dump() as a noop if
debug is not enabled and document it in the test module information that
more information can be obtained with another kernel config option.

MT_BUG_ON() will report a failures without tree dumps, and the output will
be less useful.

Link: https://lkml.kernel.org/r/20230518145544.1722059-17-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                |   10 +++++++---
 lib/test_maple_tree.c            |   27 ++++++++++++++++++++++++---
 tools/testing/radix-tree/maple.c |    1 -
 3 files changed, 31 insertions(+), 7 deletions(-)

--- a/lib/Kconfig.debug~maple_tree-make-test-code-work-without-debug-enabled
+++ a/lib/Kconfig.debug
@@ -2302,9 +2302,13 @@ config TEST_XARRAY
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

