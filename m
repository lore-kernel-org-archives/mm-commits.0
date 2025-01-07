Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD52594A3
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215942; cv=none; b=HXvJ9iVTKM/evFcxInfG6SEpF4QG3uaRPeLZkEJz6/Zc6CaHL72Q7XG6NH//G0SUNpUSQXXQIVMM4Lam5VWYqdk/SYDSoZ+wDpri1IML7ZrhiFcCTL2UE2XAu/I0YBoHdEokwXKmB9N69ZwjTdB98h3xtFeO7UjcjkJ8d0km6Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215942; c=relaxed/simple;
	bh=g5onvj/XeCLibbxkG9hpEebw6DNEX6oLTjRgbwGKyR4=;
	h=Date:To:From:Subject:Message-Id; b=Tbz3vjXdT1vpNHvvsBnlf6vYnapbvw/VPPwdIG4xdiKXMejPC08S7U9C/AsIJ8hwiRGcI3Y7uNFdnenhy6C4lNL07oJhrCu+mq2Pmdr8gUrOgE6QkZ2AjHGk6q1QQSWGZDmOobgXPX6Nq2pypmPg5kkVvAxhEm1aXVNVVtX7ZjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UsjPJ2+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UsjPJ2+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F84C4CED2;
	Tue,  7 Jan 2025 02:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215941;
	bh=g5onvj/XeCLibbxkG9hpEebw6DNEX6oLTjRgbwGKyR4=;
	h=Date:To:From:Subject:From;
	b=UsjPJ2+bNi+M8rD709/wcMHy5nQRs0gyT15+wcBWkmnPG3Ui/6nJu2B2kYMK4t//m
	 6IhSsS8QxVOxRRDWMbir1lpsxDyfmW60JN5+S/Jt0afghk7PC+OQcCvIVKadySumRW
	 e1YfdfgP+CqJYGaHGaVeUNGAJ7k57FJgbTTUbhyw=
Date: Mon, 06 Jan 2025 18:12:20 -0800
To: mm-commits@vger.kernel.org,si.yanteng@linux.dev,shuah@kernel.org,rmoar@google.com,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-damon-debugfs-interface-kunit-tests.patch added to mm-unstable branch
Message-Id: <20250107021221.73F84C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove DAMON debugfs interface kunit tests
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-remove-damon-debugfs-interface-kunit-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-damon-debugfs-interface-kunit-tests.patch

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
Subject: mm/damon: remove DAMON debugfs interface kunit tests
Date: Mon, 6 Jan 2025 11:19:40 -0800

It's time to remove DAMON debugfs interface, which has deprecated long
before in February 2023.  Read the cover letter of this patch series for
more details.

Remove kunit tests for the interface, to prevent unnecessary test
failures.

Link: https://lkml.kernel.org/r/20250106191941.107070-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig             |   12 --
 mm/damon/dbgfs.c             |    2 
 mm/damon/tests/.kunitconfig  |    7 -
 mm/damon/tests/dbgfs-kunit.h |  173 ---------------------------------
 4 files changed, 194 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-remove-damon-debugfs-interface-kunit-tests
+++ a/mm/damon/dbgfs.c
@@ -1144,5 +1144,3 @@ out:
 }
 
 module_init(damon_dbgfs_init);
-
-#include "tests/dbgfs-kunit.h"
--- a/mm/damon/Kconfig~mm-damon-remove-damon-debugfs-interface-kunit-tests
+++ a/mm/damon/Kconfig
@@ -89,18 +89,6 @@ config DAMON_DBGFS
 	default y
 	depends on DAMON_DBGFS_DEPRECATED
 
-config DAMON_DBGFS_KUNIT_TEST
-	bool "Test for damon debugfs interface" if !KUNIT_ALL_TESTS
-	depends on DAMON_DBGFS && KUNIT=y
-	default KUNIT_ALL_TESTS
-	help
-	  This builds the DAMON debugfs interface Kunit test suite.
-
-	  For more information on KUnit and unit tests in general, please refer
-	  to the KUnit documentation.
-
-	  If unsure, say N.
-
 config DAMON_RECLAIM
 	bool "Build DAMON-based reclaim (DAMON_RECLAIM)"
 	depends on DAMON_PADDR
diff --git a/mm/damon/tests/dbgfs-kunit.h a/mm/damon/tests/dbgfs-kunit.h
deleted file mode 100644
--- a/mm/damon/tests/dbgfs-kunit.h
+++ /dev/null
@@ -1,173 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * DAMON Debugfs Interface Unit Tests
- *
- * Author: SeongJae Park <sj@kernel.org>
- */
-
-#ifdef CONFIG_DAMON_DBGFS_KUNIT_TEST
-
-#ifndef _DAMON_DBGFS_TEST_H
-#define _DAMON_DBGFS_TEST_H
-
-#include <kunit/test.h>
-
-static void damon_dbgfs_test_str_to_ints(struct kunit *test)
-{
-	char *question;
-	int *answers;
-	int expected[] = {12, 35, 46};
-	ssize_t nr_integers = 0, i;
-
-	question = "123";
-	answers = str_to_ints(question, strlen(question), &nr_integers);
-	KUNIT_EXPECT_EQ(test, (ssize_t)1, nr_integers);
-	KUNIT_EXPECT_EQ(test, 123, answers[0]);
-	kfree(answers);
-
-	question = "123abc";
-	answers = str_to_ints(question, strlen(question), &nr_integers);
-	KUNIT_EXPECT_EQ(test, (ssize_t)1, nr_integers);
-	KUNIT_EXPECT_EQ(test, 123, answers[0]);
-	kfree(answers);
-
-	question = "a123";
-	answers = str_to_ints(question, strlen(question), &nr_integers);
-	KUNIT_EXPECT_EQ(test, (ssize_t)0, nr_integers);
-	kfree(answers);
-
-	question = "12 35";
-	answers = str_to_ints(question, strlen(question), &nr_integers);
-	KUNIT_EXPECT_EQ(test, (ssize_t)2, nr_integers);
-	for (i = 0; i < nr_integers; i++)
-		KUNIT_EXPECT_EQ(test, expected[i], answers[i]);
-	kfree(answers);
-
-	question = "12 35 46";
-	answers = str_to_ints(question, strlen(question), &nr_integers);
-	KUNIT_EXPECT_EQ(test, (ssize_t)3, nr_integers);
-	for (i = 0; i < nr_integers; i++)
-		KUNIT_EXPECT_EQ(test, expected[i], answers[i]);
-	kfree(answers);
-
-	question = "12 35 abc 46";
-	answers = str_to_ints(question, strlen(question), &nr_integers);
-	KUNIT_EXPECT_EQ(test, (ssize_t)2, nr_integers);
-	for (i = 0; i < 2; i++)
-		KUNIT_EXPECT_EQ(test, expected[i], answers[i]);
-	kfree(answers);
-
-	question = "";
-	answers = str_to_ints(question, strlen(question), &nr_integers);
-	KUNIT_EXPECT_EQ(test, (ssize_t)0, nr_integers);
-	kfree(answers);
-
-	question = "\n";
-	answers = str_to_ints(question, strlen(question), &nr_integers);
-	KUNIT_EXPECT_EQ(test, (ssize_t)0, nr_integers);
-	kfree(answers);
-}
-
-static void damon_dbgfs_test_set_targets(struct kunit *test)
-{
-	struct damon_ctx *ctx = dbgfs_new_ctx();
-	char buf[64];
-
-	if (!damon_is_registered_ops(DAMON_OPS_PADDR)) {
-		dbgfs_destroy_ctx(ctx);
-		kunit_skip(test, "PADDR not registered");
-	}
-
-	/* Make DAMON consider target has no pid */
-	damon_select_ops(ctx, DAMON_OPS_PADDR);
-
-	dbgfs_set_targets(ctx, 0, NULL);
-	sprint_target_ids(ctx, buf, 64);
-	KUNIT_EXPECT_STREQ(test, (char *)buf, "\n");
-
-	dbgfs_set_targets(ctx, 1, NULL);
-	sprint_target_ids(ctx, buf, 64);
-	KUNIT_EXPECT_STREQ(test, (char *)buf, "42\n");
-
-	dbgfs_set_targets(ctx, 0, NULL);
-	sprint_target_ids(ctx, buf, 64);
-	KUNIT_EXPECT_STREQ(test, (char *)buf, "\n");
-
-	dbgfs_destroy_ctx(ctx);
-}
-
-static void damon_dbgfs_test_set_init_regions(struct kunit *test)
-{
-	struct damon_ctx *ctx = damon_new_ctx();
-	/* Each line represents one region in ``<target idx> <start> <end>`` */
-	char * const valid_inputs[] = {"1 10 20\n 1   20 30\n1 35 45",
-		"1 10 20\n",
-		"1 10 20\n0 39 59\n0 70 134\n  1  20 25\n",
-		""};
-	/* Reading the file again will show sorted, clean output */
-	char * const valid_expects[] = {"1 10 20\n1 20 30\n1 35 45\n",
-		"1 10 20\n",
-		"0 39 59\n0 70 134\n1 10 20\n1 20 25\n",
-		""};
-	char * const invalid_inputs[] = {"3 10 20\n",	/* target not exists */
-		"1 10 20\n 1 14 26\n",		/* regions overlap */
-		"0 10 20\n1 30 40\n 0 5 8"};	/* not sorted by address */
-	char *input, *expect;
-	int i, rc;
-	char buf[256];
-
-	if (!damon_is_registered_ops(DAMON_OPS_PADDR)) {
-		damon_destroy_ctx(ctx);
-		kunit_skip(test, "PADDR not registered");
-	}
-
-	damon_select_ops(ctx, DAMON_OPS_PADDR);
-
-	dbgfs_set_targets(ctx, 3, NULL);
-
-	/* Put valid inputs and check the results */
-	for (i = 0; i < ARRAY_SIZE(valid_inputs); i++) {
-		input = valid_inputs[i];
-		expect = valid_expects[i];
-
-		rc = set_init_regions(ctx, input, strnlen(input, 256));
-		KUNIT_EXPECT_EQ(test, rc, 0);
-
-		memset(buf, 0, 256);
-		sprint_init_regions(ctx, buf, 256);
-
-		KUNIT_EXPECT_STREQ(test, (char *)buf, expect);
-	}
-	/* Put invalid inputs and check the return error code */
-	for (i = 0; i < ARRAY_SIZE(invalid_inputs); i++) {
-		input = invalid_inputs[i];
-		pr_info("input: %s\n", input);
-		rc = set_init_regions(ctx, input, strnlen(input, 256));
-		KUNIT_EXPECT_EQ(test, rc, -EINVAL);
-
-		memset(buf, 0, 256);
-		sprint_init_regions(ctx, buf, 256);
-
-		KUNIT_EXPECT_STREQ(test, (char *)buf, "");
-	}
-
-	dbgfs_set_targets(ctx, 0, NULL);
-	damon_destroy_ctx(ctx);
-}
-
-static struct kunit_case damon_test_cases[] = {
-	KUNIT_CASE(damon_dbgfs_test_str_to_ints),
-	KUNIT_CASE(damon_dbgfs_test_set_targets),
-	KUNIT_CASE(damon_dbgfs_test_set_init_regions),
-	{},
-};
-
-static struct kunit_suite damon_test_suite = {
-	.name = "damon-dbgfs",
-	.test_cases = damon_test_cases,
-};
-kunit_test_suite(damon_test_suite);
-
-#endif /* _DAMON_DBGFS_TEST_H */
-
-#endif	/* CONFIG_DAMON_KUNIT_TEST */
--- a/mm/damon/tests/.kunitconfig~mm-damon-remove-damon-debugfs-interface-kunit-tests
+++ a/mm/damon/tests/.kunitconfig
@@ -13,10 +13,3 @@ CONFIG_DAMON_VADDR_KUNIT_TEST=y
 CONFIG_SYSFS=y
 CONFIG_DAMON_SYSFS=y
 CONFIG_DAMON_SYSFS_KUNIT_TEST=y
-
-# for DAMON debugfs interface
-CONFIG_DEBUG_FS=y
-CONFIG_DAMON_PADDR=y
-CONFIG_DAMON_DBGFS_DEPRECATED=y
-CONFIG_DAMON_DBGFS=y
-CONFIG_DAMON_DBGFS_KUNIT_TEST=y
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch
docs-translations-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch

