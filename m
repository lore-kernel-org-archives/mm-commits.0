Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7EAC25B46
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 18:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjJWSXt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 14:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjJWSXs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 14:23:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7849B
        for <mm-commits@vger.kernel.org>; Mon, 23 Oct 2023 11:23:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B641C433C8;
        Mon, 23 Oct 2023 18:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698085425;
        bh=Cc1DpzKWDZbAijFGzrTRgg0Hc6In4z31B8qODLMRtt4=;
        h=Date:To:From:Subject:From;
        b=VnWs7Av4PvpJRkW42D2+Jc1RV/quYjMVq8p+457RXVSvcOvTEgWGbQ3Ttgr9TBs3h
         NwiOh3CRWBtWKmtvNqkOYNuFwjGLAyGonXRpift7dNbBl+8gRBEvGWJvqNifvg0VQm
         AlwFL/Y+/V8IB4akgHgO7nCZbblNAuuWIW6yAc6k=
Date:   Mon, 23 Oct 2023 11:23:44 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-test-add-a-unit-test-for-damon_sysfs_set_targets.patch added to mm-unstable branch
Message-Id: <20231023182345.7B641C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-test-add-a-unit-test-for-damon_sysfs_set_targets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-test-add-a-unit-test-for-damon_sysfs_set_targets.patch

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
@@ -1804,3 +1804,5 @@ out:
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

mm-damon-implement-a-function-for-max-nr_accesses-safe-calculation.patch
mm-damon-core-avoid-divide-by-zero-during-monitoring-results-update.patch
mm-damon-ops-common-avoid-divide-by-zero-during-region-hotness-calculation.patch
mm-damon-lru_sort-avoid-divide-by-zero-in-hot-threshold-calculation.patch
mm-damon-sysfs-remove-requested-targets-when-online-commit-inputs.patch
mm-damon-core-avoid-divide-by-zero-from-pseudo-moving-window-length-calculation.patch
mm-damon-sysfs-test-add-a-unit-test-for-damon_sysfs_set_targets.patch

