Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B23C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiKIBmc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiKIBkc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D3F657C9
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BFD361803
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3364C43470;
        Wed,  9 Nov 2022 01:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957989;
        bh=7DukY/3Q6OTqnqTPinv7rmMV0QJlp3PaAi9cN7fI98o=;
        h=Date:To:From:Subject:From;
        b=ipIym0p38pMCbIlUAlAQi1yVaUzm9weifQI/n/oAfO1QqaMIBYVLnxIkGH2JffI0p
         muSwYkCn3F/mjkDF3nJnAzEB+B1C95WWpaTlbRX18/5utTbJv1BE1JQXffxDlpG1Qd
         Y67I1graLbd+58NZhnobGCKGdSXD93+d6PkYEk4U=
Date:   Tue, 08 Nov 2022 17:39:48 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch removed from -mm tree
Message-Id: <20221109013948.E3364C43470@smtp.kernel.org>
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
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

