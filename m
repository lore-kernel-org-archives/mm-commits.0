Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD72DC352A1
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiK3XCb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiK3XCJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:02:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA9D5AE1A
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69292B81D12
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B91EC433B5;
        Wed, 30 Nov 2022 23:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669849326;
        bh=GTy+YgOSZWLNyuvLTjp9ht+FLzGjC3AHtoDAC2/mhBo=;
        h=Date:To:From:Subject:From;
        b=0f5Ciwd/xHSMrbMqbvpRSxFeaqfVGMA/F+OcKS7lAHtlUPviB4jGwwUTZds+5LXdu
         MW/ryxtxCg7ykiX9oX/1dpIi/J6eJtnhdMVTQiuP0qvLUQmttotnnog4EFR79U4O0y
         Cfb5j/n2hAQ+3VTTHF0HdlbS3x0Kk45yoJYPx+rM=
Date:   Wed, 30 Nov 2022 15:02:05 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch removed from -mm tree
Message-Id: <20221130230206.0B91EC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/modules: deduplicate init steps for DAMON context setup
has been removed from the -mm tree.  Its filename was
     mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/modules: deduplicate init steps for DAMON context setup
Date: Wed, 26 Oct 2022 22:59:42 +0000

DAMON_RECLAIM and DAMON_LRU_SORT has duplicated code for DAMON context and
target initializations.  Deduplicate the part by implementing a function
for the initialization in 'modules-common.c' and using it.

Link: https://lkml.kernel.org/r/20221026225943.100429-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Makefile         |    4 +--
 mm/damon/lru_sort.c       |   17 ++------------
 mm/damon/modules-common.c |   42 ++++++++++++++++++++++++++++++++++++
 mm/damon/modules-common.h |    3 ++
 mm/damon/reclaim.c        |   17 ++------------
 5 files changed, 53 insertions(+), 30 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-modules-deduplicate-init-steps-for-damon-context-setup
+++ a/mm/damon/lru_sort.c
@@ -314,25 +314,14 @@ static int damon_lru_sort_after_wmarks_c
 
 static int __init damon_lru_sort_init(void)
 {
-	ctx = damon_new_ctx();
-	if (!ctx)
-		return -ENOMEM;
+	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 
-	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
-		damon_destroy_ctx(ctx);
-		return -EINVAL;
-	}
+	if (err)
+		return err;
 
 	ctx->callback.after_wmarks_check = damon_lru_sort_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_lru_sort_after_aggregation;
 
-	target = damon_new_target();
-	if (!target) {
-		damon_destroy_ctx(ctx);
-		return -ENOMEM;
-	}
-	damon_add_target(ctx, target);
-
 	schedule_delayed_work(&damon_lru_sort_timer, 0);
 
 	damon_lru_sort_initialized = true;
--- a/mm/damon/Makefile~mm-damon-modules-deduplicate-init-steps-for-damon-context-setup
+++ a/mm/damon/Makefile
@@ -5,5 +5,5 @@ obj-$(CONFIG_DAMON_VADDR)	+= ops-common.
 obj-$(CONFIG_DAMON_PADDR)	+= ops-common.o paddr.o
 obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
 obj-$(CONFIG_DAMON_DBGFS)	+= dbgfs.o
-obj-$(CONFIG_DAMON_RECLAIM)	+= reclaim.o
-obj-$(CONFIG_DAMON_LRU_SORT)	+= lru_sort.o
+obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
+obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
--- /dev/null
+++ a/mm/damon/modules-common.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Common Primitives for DAMON Modules
+ *
+ * Author: SeongJae Park <sjpark@amazon.de>
+ */
+
+#include <linux/damon.h>
+
+#include "modules-common.h"
+
+/*
+ * Allocate, set, and return a DAMON context for the physical address space.
+ * @ctxp:	Pointer to save the point to the newly created context
+ * @targetp:	Pointer to save the point to the newly created target
+ */
+int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *target;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return -ENOMEM;
+
+	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
+
+	target = damon_new_target();
+	if (!target) {
+		damon_destroy_ctx(ctx);
+		return -ENOMEM;
+	}
+	damon_add_target(ctx, target);
+
+	*ctxp = ctx;
+	*targetp = target;
+	return 0;
+}
--- a/mm/damon/modules-common.h~mm-damon-modules-deduplicate-init-steps-for-damon-context-setup
+++ a/mm/damon/modules-common.h
@@ -44,3 +44,6 @@
 			0400);						\
 	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
 			0400);
+
+int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp);
--- a/mm/damon/reclaim.c~mm-damon-modules-deduplicate-init-steps-for-damon-context-setup
+++ a/mm/damon/reclaim.c
@@ -256,25 +256,14 @@ static int damon_reclaim_after_wmarks_ch
 
 static int __init damon_reclaim_init(void)
 {
-	ctx = damon_new_ctx();
-	if (!ctx)
-		return -ENOMEM;
+	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 
-	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
-		damon_destroy_ctx(ctx);
-		return -EINVAL;
-	}
+	if (err)
+		return err;
 
 	ctx->callback.after_wmarks_check = damon_reclaim_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
 
-	target = damon_new_target();
-	if (!target) {
-		damon_destroy_ctx(ctx);
-		return -ENOMEM;
-	}
-	damon_add_target(ctx, target);
-
 	schedule_delayed_work(&damon_reclaim_timer, 0);
 
 	damon_reclaim_initialized = true;
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

