Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835DCC4361B
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E70523A51
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgLQXDP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 18:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731905AbgLQXDM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 18:03:12 -0500
Date:   Thu, 17 Dec 2020 15:02:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608246151;
        bh=hhHMfDLEr5/z5qCl1DzPcr/+q47U2uaYTI2kBlQNRB0=;
        h=From:To:Subject:From;
        b=QH0r7R5IEbUwVvU5Mpp6Y0K/S3OnkxYZzbbxETQY/RZyHYjE7EmIfPjg4aimqNTdB
         /zeTmNa5BI3DRq3LV8vv3s1ZC6X6AYkeR3IWBUFIBQqZZhBp9DUSdd+rTCtwHZib0U
         3axqexS36u+trJ2BD7cdh/cM+ae+1N3RckSD+DT4=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitor@massaru.org,
        skhan@linuxfoundation.org, matti.vaittinen@fi.rohmeurope.com,
        davidgow@google.com, broonie@kernel.org, brendanhiggins@google.com,
        andriy.shevchenko@linux.intel.com
Subject:  [to-be-updated]
 lib-linear_ranges_kunit-follow-new-file-name-convention-for-kunit-tests.patch
 removed from -mm tree
Message-ID: <20201217230230.AdXCI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/linear_ranges_kunit: follow new file name convention for KUnit tests
has been removed from the -mm tree.  Its filename was
     lib-linear_ranges_kunit-follow-new-file-name-convention-for-kunit-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/linear_ranges_kunit: follow new file name convention for KUnit tests

Follow new file name convention for the KUnit tests.  Since we have
lib/*test*.c in a few variations, use 'kunit' suffix to distinguish usual
test cases with KUnit-based ones.

Link: https://lkml.kernel.org/r/20201112180732.75589-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: David Gow <davidgow@google.com>
Acked-by: Mark Brown <broonie@kernel.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS               |    3 
 lib/Makefile              |    2 
 lib/linear_ranges_kunit.c |  228 ++++++++++++++++++++++++++++++++++++
 lib/test_linear_ranges.c  |  228 ------------------------------------
 4 files changed, 230 insertions(+), 231 deletions(-)

--- /dev/null
+++ a/lib/linear_ranges_kunit.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit test for the linear_ranges helper.
+ *
+ * Copyright (C) 2020, ROHM Semiconductors.
+ * Author: Matti Vaittinen <matti.vaittien@fi.rohmeurope.com>
+ */
+#include <kunit/test.h>
+
+#include <linux/linear_range.h>
+
+/* First things first. I deeply dislike unit-tests. I have seen all the hell
+ * breaking loose when people who think the unit tests are "the silver bullet"
+ * to kill bugs get to decide how a company should implement testing strategy...
+ *
+ * Believe me, it may get _really_ ridiculous. It is tempting to think that
+ * walking through all the possible execution branches will nail down 100% of
+ * bugs. This may lead to ideas about demands to get certain % of "test
+ * coverage" - measured as line coverage. And that is one of the worst things
+ * you can do.
+ *
+ * Ask people to provide line coverage and they do. I've seen clever tools
+ * which generate test cases to test the existing functions - and by default
+ * these tools expect code to be correct and just generate checks which are
+ * passing when ran against current code-base. Run this generator and you'll get
+ * tests that do not test code is correct but just verify nothing changes.
+ * Problem is that testing working code is pointless. And if it is not
+ * working, your test must not assume it is working. You won't catch any bugs
+ * by such tests. What you can do is to generate a huge amount of tests.
+ * Especially if you were are asked to proivde 100% line-coverage x_x. So what
+ * does these tests - which are not finding any bugs now - do?
+ *
+ * They add inertia to every future development. I think it was Terry Pratchet
+ * who wrote someone having same impact as thick syrup has to chronometre.
+ * Excessive amount of unit-tests have this effect to development. If you do
+ * actually find _any_ bug from code in such environment and try fixing it...
+ * ...chances are you also need to fix the test cases. In sunny day you fix one
+ * test. But I've done refactoring which resulted 500+ broken tests (which had
+ * really zero value other than proving to managers that we do do "quality")...
+ *
+ * After this being said - there are situations where UTs can be handy. If you
+ * have algorithms which take some input and should produce output - then you
+ * can implement few, carefully selected simple UT-cases which test this. I've
+ * previously used this for example for netlink and device-tree data parsing
+ * functions. Feed some data examples to functions and verify the output is as
+ * expected. I am not covering all the cases but I will see the logic should be
+ * working.
+ *
+ * Here we also do some minor testing. I don't want to go through all branches
+ * or test more or less obvious things - but I want to see the main logic is
+ * working. And I definitely don't want to add 500+ test cases that break when
+ * some simple fix is done x_x. So - let's only add few, well selected tests
+ * which ensure as much logic is good as possible.
+ */
+
+/*
+ * Test Range 1:
+ * selectors:	2	3	4	5	6
+ * values (5):	10	20	30	40	50
+ *
+ * Test Range 2:
+ * selectors:	7	8	9	10
+ * values (4):	100	150	200	250
+ */
+
+#define RANGE1_MIN 10
+#define RANGE1_MIN_SEL 2
+#define RANGE1_STEP 10
+
+/* 2, 3, 4, 5, 6 */
+static const unsigned int range1_sels[] = { RANGE1_MIN_SEL, RANGE1_MIN_SEL + 1,
+					    RANGE1_MIN_SEL + 2,
+					    RANGE1_MIN_SEL + 3,
+					    RANGE1_MIN_SEL + 4 };
+/* 10, 20, 30, 40, 50 */
+static const unsigned int range1_vals[] = { RANGE1_MIN, RANGE1_MIN +
+					    RANGE1_STEP,
+					    RANGE1_MIN + RANGE1_STEP * 2,
+					    RANGE1_MIN + RANGE1_STEP * 3,
+					    RANGE1_MIN + RANGE1_STEP * 4 };
+
+#define RANGE2_MIN 100
+#define RANGE2_MIN_SEL 7
+#define RANGE2_STEP 50
+
+/*  7, 8, 9, 10 */
+static const unsigned int range2_sels[] = { RANGE2_MIN_SEL, RANGE2_MIN_SEL + 1,
+					    RANGE2_MIN_SEL + 2,
+					    RANGE2_MIN_SEL + 3 };
+/* 100, 150, 200, 250 */
+static const unsigned int range2_vals[] = { RANGE2_MIN, RANGE2_MIN +
+					    RANGE2_STEP,
+					    RANGE2_MIN + RANGE2_STEP * 2,
+					    RANGE2_MIN + RANGE2_STEP * 3 };
+
+#define RANGE1_NUM_VALS (ARRAY_SIZE(range1_vals))
+#define RANGE2_NUM_VALS (ARRAY_SIZE(range2_vals))
+#define RANGE_NUM_VALS (RANGE1_NUM_VALS + RANGE2_NUM_VALS)
+
+#define RANGE1_MAX_SEL (RANGE1_MIN_SEL + RANGE1_NUM_VALS - 1)
+#define RANGE1_MAX_VAL (range1_vals[RANGE1_NUM_VALS - 1])
+
+#define RANGE2_MAX_SEL (RANGE2_MIN_SEL + RANGE2_NUM_VALS - 1)
+#define RANGE2_MAX_VAL (range2_vals[RANGE2_NUM_VALS - 1])
+
+#define SMALLEST_SEL RANGE1_MIN_SEL
+#define SMALLEST_VAL RANGE1_MIN
+
+static struct linear_range testr[] = {
+	{
+		.min = RANGE1_MIN,
+		.min_sel = RANGE1_MIN_SEL,
+		.max_sel = RANGE1_MAX_SEL,
+		.step = RANGE1_STEP,
+	}, {
+		.min = RANGE2_MIN,
+		.min_sel = RANGE2_MIN_SEL,
+		.max_sel = RANGE2_MAX_SEL,
+		.step = RANGE2_STEP
+	},
+};
+
+static void range_test_get_value(struct kunit *test)
+{
+	int ret, i;
+	unsigned int sel, val;
+
+	for (i = 0; i < RANGE1_NUM_VALS; i++) {
+		sel = range1_sels[i];
+		ret = linear_range_get_value_array(&testr[0], 2, sel, &val);
+		KUNIT_EXPECT_EQ(test, 0, ret);
+		KUNIT_EXPECT_EQ(test, val, range1_vals[i]);
+	}
+	for (i = 0; i < RANGE2_NUM_VALS; i++) {
+		sel = range2_sels[i];
+		ret = linear_range_get_value_array(&testr[0], 2, sel, &val);
+		KUNIT_EXPECT_EQ(test, 0, ret);
+		KUNIT_EXPECT_EQ(test, val, range2_vals[i]);
+	}
+	ret = linear_range_get_value_array(&testr[0], 2, sel + 1, &val);
+	KUNIT_EXPECT_NE(test, 0, ret);
+}
+
+static void range_test_get_selector_high(struct kunit *test)
+{
+	int ret, i;
+	unsigned int sel;
+	bool found;
+
+	for (i = 0; i < RANGE1_NUM_VALS; i++) {
+		ret = linear_range_get_selector_high(&testr[0], range1_vals[i],
+						     &sel, &found);
+		KUNIT_EXPECT_EQ(test, 0, ret);
+		KUNIT_EXPECT_EQ(test, sel, range1_sels[i]);
+		KUNIT_EXPECT_TRUE(test, found);
+	}
+
+	ret = linear_range_get_selector_high(&testr[0], RANGE1_MAX_VAL + 1,
+					     &sel, &found);
+	KUNIT_EXPECT_LE(test, ret, 0);
+
+	ret = linear_range_get_selector_high(&testr[0], RANGE1_MIN - 1,
+					     &sel, &found);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_FALSE(test, found);
+	KUNIT_EXPECT_EQ(test, sel, range1_sels[0]);
+}
+
+static void range_test_get_value_amount(struct kunit *test)
+{
+	int ret;
+
+	ret = linear_range_values_in_range_array(&testr[0], 2);
+	KUNIT_EXPECT_EQ(test, (int)RANGE_NUM_VALS, ret);
+}
+
+static void range_test_get_selector_low(struct kunit *test)
+{
+	int i, ret;
+	unsigned int sel;
+	bool found;
+
+	for (i = 0; i < RANGE1_NUM_VALS; i++) {
+		ret = linear_range_get_selector_low_array(&testr[0], 2,
+							  range1_vals[i], &sel,
+							  &found);
+		KUNIT_EXPECT_EQ(test, 0, ret);
+		KUNIT_EXPECT_EQ(test, sel, range1_sels[i]);
+		KUNIT_EXPECT_TRUE(test, found);
+	}
+	for (i = 0; i < RANGE2_NUM_VALS; i++) {
+		ret = linear_range_get_selector_low_array(&testr[0], 2,
+							  range2_vals[i], &sel,
+							  &found);
+		KUNIT_EXPECT_EQ(test, 0, ret);
+		KUNIT_EXPECT_EQ(test, sel, range2_sels[i]);
+		KUNIT_EXPECT_TRUE(test, found);
+	}
+
+	/*
+	 * Seek value greater than range max => get_selector_*_low should
+	 * return Ok - but set found to false as value is not in range
+	 */
+	ret = linear_range_get_selector_low_array(&testr[0], 2,
+					range2_vals[RANGE2_NUM_VALS - 1] + 1,
+					&sel, &found);
+
+	KUNIT_EXPECT_EQ(test, 0, ret);
+	KUNIT_EXPECT_EQ(test, sel, range2_sels[RANGE2_NUM_VALS - 1]);
+	KUNIT_EXPECT_FALSE(test, found);
+}
+
+static struct kunit_case range_test_cases[] = {
+	KUNIT_CASE(range_test_get_value_amount),
+	KUNIT_CASE(range_test_get_selector_high),
+	KUNIT_CASE(range_test_get_selector_low),
+	KUNIT_CASE(range_test_get_value),
+	{},
+};
+
+static struct kunit_suite range_test_module = {
+	.name = "linear-ranges-test",
+	.test_cases = range_test_cases,
+};
+
+kunit_test_suites(&range_test_module);
+
+MODULE_LICENSE("GPL");
--- a/lib/Makefile~lib-linear_ranges_kunit-follow-new-file-name-convention-for-kunit-tests
+++ a/lib/Makefile
@@ -350,6 +350,6 @@ obj-$(CONFIG_PLDMFW) += pldmfw/
 
 # KUnit tests
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
+obj-$(CONFIG_LINEAR_RANGES_TEST) += linear_ranges_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list_kunit.o
-obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
 obj-$(CONFIG_BITS_TEST) += test_bits.o
--- a/lib/test_linear_ranges.c
+++ /dev/null
@@ -1,228 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * KUnit test for the linear_ranges helper.
- *
- * Copyright (C) 2020, ROHM Semiconductors.
- * Author: Matti Vaittinen <matti.vaittien@fi.rohmeurope.com>
- */
-#include <kunit/test.h>
-
-#include <linux/linear_range.h>
-
-/* First things first. I deeply dislike unit-tests. I have seen all the hell
- * breaking loose when people who think the unit tests are "the silver bullet"
- * to kill bugs get to decide how a company should implement testing strategy...
- *
- * Believe me, it may get _really_ ridiculous. It is tempting to think that
- * walking through all the possible execution branches will nail down 100% of
- * bugs. This may lead to ideas about demands to get certain % of "test
- * coverage" - measured as line coverage. And that is one of the worst things
- * you can do.
- *
- * Ask people to provide line coverage and they do. I've seen clever tools
- * which generate test cases to test the existing functions - and by default
- * these tools expect code to be correct and just generate checks which are
- * passing when ran against current code-base. Run this generator and you'll get
- * tests that do not test code is correct but just verify nothing changes.
- * Problem is that testing working code is pointless. And if it is not
- * working, your test must not assume it is working. You won't catch any bugs
- * by such tests. What you can do is to generate a huge amount of tests.
- * Especially if you were are asked to proivde 100% line-coverage x_x. So what
- * does these tests - which are not finding any bugs now - do?
- *
- * They add inertia to every future development. I think it was Terry Pratchet
- * who wrote someone having same impact as thick syrup has to chronometre.
- * Excessive amount of unit-tests have this effect to development. If you do
- * actually find _any_ bug from code in such environment and try fixing it...
- * ...chances are you also need to fix the test cases. In sunny day you fix one
- * test. But I've done refactoring which resulted 500+ broken tests (which had
- * really zero value other than proving to managers that we do do "quality")...
- *
- * After this being said - there are situations where UTs can be handy. If you
- * have algorithms which take some input and should produce output - then you
- * can implement few, carefully selected simple UT-cases which test this. I've
- * previously used this for example for netlink and device-tree data parsing
- * functions. Feed some data examples to functions and verify the output is as
- * expected. I am not covering all the cases but I will see the logic should be
- * working.
- *
- * Here we also do some minor testing. I don't want to go through all branches
- * or test more or less obvious things - but I want to see the main logic is
- * working. And I definitely don't want to add 500+ test cases that break when
- * some simple fix is done x_x. So - let's only add few, well selected tests
- * which ensure as much logic is good as possible.
- */
-
-/*
- * Test Range 1:
- * selectors:	2	3	4	5	6
- * values (5):	10	20	30	40	50
- *
- * Test Range 2:
- * selectors:	7	8	9	10
- * values (4):	100	150	200	250
- */
-
-#define RANGE1_MIN 10
-#define RANGE1_MIN_SEL 2
-#define RANGE1_STEP 10
-
-/* 2, 3, 4, 5, 6 */
-static const unsigned int range1_sels[] = { RANGE1_MIN_SEL, RANGE1_MIN_SEL + 1,
-					    RANGE1_MIN_SEL + 2,
-					    RANGE1_MIN_SEL + 3,
-					    RANGE1_MIN_SEL + 4 };
-/* 10, 20, 30, 40, 50 */
-static const unsigned int range1_vals[] = { RANGE1_MIN, RANGE1_MIN +
-					    RANGE1_STEP,
-					    RANGE1_MIN + RANGE1_STEP * 2,
-					    RANGE1_MIN + RANGE1_STEP * 3,
-					    RANGE1_MIN + RANGE1_STEP * 4 };
-
-#define RANGE2_MIN 100
-#define RANGE2_MIN_SEL 7
-#define RANGE2_STEP 50
-
-/*  7, 8, 9, 10 */
-static const unsigned int range2_sels[] = { RANGE2_MIN_SEL, RANGE2_MIN_SEL + 1,
-					    RANGE2_MIN_SEL + 2,
-					    RANGE2_MIN_SEL + 3 };
-/* 100, 150, 200, 250 */
-static const unsigned int range2_vals[] = { RANGE2_MIN, RANGE2_MIN +
-					    RANGE2_STEP,
-					    RANGE2_MIN + RANGE2_STEP * 2,
-					    RANGE2_MIN + RANGE2_STEP * 3 };
-
-#define RANGE1_NUM_VALS (ARRAY_SIZE(range1_vals))
-#define RANGE2_NUM_VALS (ARRAY_SIZE(range2_vals))
-#define RANGE_NUM_VALS (RANGE1_NUM_VALS + RANGE2_NUM_VALS)
-
-#define RANGE1_MAX_SEL (RANGE1_MIN_SEL + RANGE1_NUM_VALS - 1)
-#define RANGE1_MAX_VAL (range1_vals[RANGE1_NUM_VALS - 1])
-
-#define RANGE2_MAX_SEL (RANGE2_MIN_SEL + RANGE2_NUM_VALS - 1)
-#define RANGE2_MAX_VAL (range2_vals[RANGE2_NUM_VALS - 1])
-
-#define SMALLEST_SEL RANGE1_MIN_SEL
-#define SMALLEST_VAL RANGE1_MIN
-
-static struct linear_range testr[] = {
-	{
-		.min = RANGE1_MIN,
-		.min_sel = RANGE1_MIN_SEL,
-		.max_sel = RANGE1_MAX_SEL,
-		.step = RANGE1_STEP,
-	}, {
-		.min = RANGE2_MIN,
-		.min_sel = RANGE2_MIN_SEL,
-		.max_sel = RANGE2_MAX_SEL,
-		.step = RANGE2_STEP
-	},
-};
-
-static void range_test_get_value(struct kunit *test)
-{
-	int ret, i;
-	unsigned int sel, val;
-
-	for (i = 0; i < RANGE1_NUM_VALS; i++) {
-		sel = range1_sels[i];
-		ret = linear_range_get_value_array(&testr[0], 2, sel, &val);
-		KUNIT_EXPECT_EQ(test, 0, ret);
-		KUNIT_EXPECT_EQ(test, val, range1_vals[i]);
-	}
-	for (i = 0; i < RANGE2_NUM_VALS; i++) {
-		sel = range2_sels[i];
-		ret = linear_range_get_value_array(&testr[0], 2, sel, &val);
-		KUNIT_EXPECT_EQ(test, 0, ret);
-		KUNIT_EXPECT_EQ(test, val, range2_vals[i]);
-	}
-	ret = linear_range_get_value_array(&testr[0], 2, sel + 1, &val);
-	KUNIT_EXPECT_NE(test, 0, ret);
-}
-
-static void range_test_get_selector_high(struct kunit *test)
-{
-	int ret, i;
-	unsigned int sel;
-	bool found;
-
-	for (i = 0; i < RANGE1_NUM_VALS; i++) {
-		ret = linear_range_get_selector_high(&testr[0], range1_vals[i],
-						     &sel, &found);
-		KUNIT_EXPECT_EQ(test, 0, ret);
-		KUNIT_EXPECT_EQ(test, sel, range1_sels[i]);
-		KUNIT_EXPECT_TRUE(test, found);
-	}
-
-	ret = linear_range_get_selector_high(&testr[0], RANGE1_MAX_VAL + 1,
-					     &sel, &found);
-	KUNIT_EXPECT_LE(test, ret, 0);
-
-	ret = linear_range_get_selector_high(&testr[0], RANGE1_MIN - 1,
-					     &sel, &found);
-	KUNIT_EXPECT_EQ(test, 0, ret);
-	KUNIT_EXPECT_FALSE(test, found);
-	KUNIT_EXPECT_EQ(test, sel, range1_sels[0]);
-}
-
-static void range_test_get_value_amount(struct kunit *test)
-{
-	int ret;
-
-	ret = linear_range_values_in_range_array(&testr[0], 2);
-	KUNIT_EXPECT_EQ(test, (int)RANGE_NUM_VALS, ret);
-}
-
-static void range_test_get_selector_low(struct kunit *test)
-{
-	int i, ret;
-	unsigned int sel;
-	bool found;
-
-	for (i = 0; i < RANGE1_NUM_VALS; i++) {
-		ret = linear_range_get_selector_low_array(&testr[0], 2,
-							  range1_vals[i], &sel,
-							  &found);
-		KUNIT_EXPECT_EQ(test, 0, ret);
-		KUNIT_EXPECT_EQ(test, sel, range1_sels[i]);
-		KUNIT_EXPECT_TRUE(test, found);
-	}
-	for (i = 0; i < RANGE2_NUM_VALS; i++) {
-		ret = linear_range_get_selector_low_array(&testr[0], 2,
-							  range2_vals[i], &sel,
-							  &found);
-		KUNIT_EXPECT_EQ(test, 0, ret);
-		KUNIT_EXPECT_EQ(test, sel, range2_sels[i]);
-		KUNIT_EXPECT_TRUE(test, found);
-	}
-
-	/*
-	 * Seek value greater than range max => get_selector_*_low should
-	 * return Ok - but set found to false as value is not in range
-	 */
-	ret = linear_range_get_selector_low_array(&testr[0], 2,
-					range2_vals[RANGE2_NUM_VALS - 1] + 1,
-					&sel, &found);
-
-	KUNIT_EXPECT_EQ(test, 0, ret);
-	KUNIT_EXPECT_EQ(test, sel, range2_sels[RANGE2_NUM_VALS - 1]);
-	KUNIT_EXPECT_FALSE(test, found);
-}
-
-static struct kunit_case range_test_cases[] = {
-	KUNIT_CASE(range_test_get_value_amount),
-	KUNIT_CASE(range_test_get_selector_high),
-	KUNIT_CASE(range_test_get_selector_low),
-	KUNIT_CASE(range_test_get_value),
-	{},
-};
-
-static struct kunit_suite range_test_module = {
-	.name = "linear-ranges-test",
-	.test_cases = range_test_cases,
-};
-
-kunit_test_suites(&range_test_module);
-
-MODULE_LICENSE("GPL");
--- a/MAINTAINERS~lib-linear_ranges_kunit-follow-new-file-name-convention-for-kunit-tests
+++ a/MAINTAINERS
@@ -10057,8 +10057,7 @@ F:	include/uapi/linux/lightnvm.h
 LINEAR RANGES HELPERS
 M:	Mark Brown <broonie@kernel.org>
 R:	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
-F:	lib/linear_ranges.c
-F:	lib/test_linear_ranges.c
+F:	lib/linear_ranges*.c
 F:	include/linux/linear_range.h
 
 LINUX FOR POWER MACINTOSH
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-mathematical-helpers.patch
bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch
lib-bits_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch
lib-cmdline-allow-null-to-be-an-output-for-get_option.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix-3.patch
apparmor-remove-duplicate-macro-list_entry_is_head.patch

