Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8EF4C27C46
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbjJYXvG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbjJYXte (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177ECD40
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB87C433CA;
        Wed, 25 Oct 2023 23:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277758;
        bh=GR1PoAp7AoMFvj2eiGdnmwQ9Y7Vj3g0nIHmk5GTv8w0=;
        h=Date:To:From:Subject:From;
        b=QYypjPnc4sThkxMuCIJVct7XbIp6seKISfP5lyusNnTOY+hLfx2fK4SPMYdWftitX
         x/dbNHcqgc4yRpNjd4d2jLQCS4X/dehzaSGKYc5BggztEI/M/JN4hzeDIUHfgxwtoq
         lqD4BKTNIiA0Ee0/9pDmO1O2q3orK1DVoTUEPmW4=
Date:   Wed, 25 Oct 2023 16:49:18 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-test-add-a-unit-test-for-damon_sysfs_set_targets.patch removed from -mm tree
Message-Id: <20231025234918.AAB87C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-test-add-a-unit-test-for-damon_sysfs_set_targets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()
Date: Sun, 22 Oct 2023 21:07:34 +0000

damon_sysfs_set_targets() had a bug that can result in unexpected memory
usage and monitoring overhead increase.  The bug has fixed by a previous
commit.  Add a unit test for avoiding a similar bug of future.

Link: https://lkml.kernel.org/r/20231022210735.46409-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig      |   12 +++++
 mm/damon/sysfs-test.h |   86 ++++++++++++++++++++++++++++++++++++++++
 mm/damon/sysfs.c      |    2 
 3 files changed, 100 insertions(+)

--- a/mm/damon/Kconfig~mm-damon-sysfs-test-add-a-unit-test-for-damon_sysfs_set_targets
+++ a/mm/damon/Kconfig
@@ -59,6 +59,18 @@ config DAMON_SYSFS
 	  This builds the sysfs interface for DAMON.  The user space can use
 	  the interface for arbitrary data access monitoring.
 
+config DAMON_SYSFS_KUNIT_TEST
+	bool "Test for damon debugfs interface" if !KUNIT_ALL_TESTS
+	depends on DAMON_SYSFS && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the DAMON sysfs interface Kunit test suite.
+
+	  For more information on KUnit and unit tests in general, please refer
+	  to the KUnit documentation.
+
+	  If unsure, say N.
+
 config DAMON_DBGFS
 	bool "DAMON debugfs interface (DEPRECATED!)"
 	depends on DAMON_VADDR && DAMON_PADDR && DEBUG_FS
--- a/mm/damon/sysfs.c~mm-damon-sysfs-test-add-a-unit-test-for-damon_sysfs_set_targets
+++ a/mm/damon/sysfs.c
@@ -1836,3 +1836,5 @@ out:
 	return err;
 }
 subsys_initcall(damon_sysfs_init);
+
+#include "sysfs-test.h"
--- /dev/null
+++ a/mm/damon/sysfs-test.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Data Access Monitor Unit Tests
+ *
+ * Author: SeongJae Park <sj@kernel.org>
+ */
+
+#ifdef CONFIG_DAMON_SYSFS_KUNIT_TEST
+
+#ifndef _DAMON_SYSFS_TEST_H
+#define _DAMON_SYSFS_TEST_H
+
+#include <kunit/test.h>
+
+static unsigned int nr_damon_targets(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	unsigned int nr_targets = 0;
+
+	damon_for_each_target(t, ctx)
+		nr_targets++;
+
+	return nr_targets;
+}
+
+static int __damon_sysfs_test_get_any_pid(int min, int max)
+{
+	struct pid *pid;
+	int i;
+
+	for (i = min; i <= max; i++) {
+		pid = find_get_pid(i);
+		if (pid) {
+			put_pid(pid);
+			return i;
+		}
+	}
+	return -1;
+}
+
+static void damon_sysfs_test_set_targets(struct kunit *test)
+{
+	struct damon_sysfs_targets *sysfs_targets;
+	struct damon_sysfs_target *sysfs_target;
+	struct damon_ctx *ctx;
+
+	sysfs_targets = damon_sysfs_targets_alloc();
+	sysfs_targets->nr = 1;
+	sysfs_targets->targets_arr = kmalloc_array(1,
+			sizeof(*sysfs_targets->targets_arr), GFP_KERNEL);
+
+	sysfs_target = damon_sysfs_target_alloc();
+	sysfs_target->pid = __damon_sysfs_test_get_any_pid(12, 100);
+	sysfs_target->regions = damon_sysfs_regions_alloc();
+	sysfs_targets->targets_arr[0] = sysfs_target;
+
+	ctx = damon_new_ctx();
+
+	damon_sysfs_set_targets(ctx, sysfs_targets);
+	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
+
+	sysfs_target->pid = __damon_sysfs_test_get_any_pid(
+			sysfs_target->pid + 1, 200);
+	damon_sysfs_set_targets(ctx, sysfs_targets);
+	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
+
+	damon_destroy_ctx(ctx);
+	kfree(sysfs_targets->targets_arr);
+	kfree(sysfs_targets);
+	kfree(sysfs_target);
+}
+
+static struct kunit_case damon_sysfs_test_cases[] = {
+	KUNIT_CASE(damon_sysfs_test_set_targets),
+	{},
+};
+
+static struct kunit_suite damon_sysfs_test_suite = {
+	.name = "damon-sysfs",
+	.test_cases = damon_sysfs_test_cases,
+};
+kunit_test_suite(damon_sysfs_test_suite);
+
+#endif /* _DAMON_SYSFS_TEST_H */
+
+#endif /* CONFIG_DAMON_SYSFS_KUNIT_TEST */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch

