Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF5923ED69
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837182; cv=none; b=qPMrgNYIHg/X23agcDAcRDZsRj1xLusVsQcGIY5jhHVeyVAtQNir9P5WbNgUCoNRkpB4Bi2NslDr+/8Bm7ZRQWPh6xDs0/DT76E1h250UDWfuel8NBZf9xpqeCfd5m4MnlQxVB6dNcaBduHaqkHp8PIu+RnQ/S6gCdCHY7fKa0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837182; c=relaxed/simple;
	bh=sCpNuK4Y/Ba7nDdVDeXw00BJO5Xy1f2iHrn29U9ShGA=;
	h=Date:To:From:Subject:Message-Id; b=jlOXIywmPHjBIj39P7t+Nk82E9rlXWQxOpeYhKZ+sERzPh4A0LzxEjwHEOgS6GR+EBp1RWhgyLDC4jglnEQJqyZxk3cpJIpjGoGhjGCf7Bv1Khwu/vPL6W5c/PvUU2k2Lp2ks2ROB3I9ALdIf+H/3fwCUhcs/SEl3LvkhCS1ccM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cqOrcxV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cqOrcxV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6431C4CEDD;
	Tue, 14 Jan 2025 06:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837182;
	bh=sCpNuK4Y/Ba7nDdVDeXw00BJO5Xy1f2iHrn29U9ShGA=;
	h=Date:To:From:Subject:From;
	b=cqOrcxV4loRNPAqO6A4jQknZugzF98JrRXNQhiODA6DazCOFYeF0CYLJaj4lBGhpT
	 6xC8nmrEHjFU1UPIqhzvI7EL++03Js308dFvzNQ1zTnN07H7iLyarLrnQXx7jrPIdj
	 Cu/ELmayn9MOG/GKkKJ6EmmGLx9tX8ghabOONs4o=
Date: Mon, 13 Jan 2025 22:46:21 -0800
To: mm-commits@vger.kernel.org,si.yanteng@linux.dev,shuah@kernel.org,rmoar@google.com,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-damon-debugfs-interface-kunit-tests.patch removed from -mm tree
Message-Id: <20250114064621.E6431C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove DAMON debugfs interface kunit tests
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-damon-debugfs-interface-kunit-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

