Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFD7140E34
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 22:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728080762; cv=none; b=cJ3vBQQFauu1WNNoYv5EHn6ZOMXYDAp5GRizK1P6KBCn+hPvtf+PoJWC/iiah7LJDNqD7cWB0OqBKefh3mEVy8jNaJcFBj/XCQin7oLmWPtbVGdU5ax4mn98dgNT40XRWhi7xBiJdgM6KZrCrQEkqo8CPswkNEP+o6aFj7uqCCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728080762; c=relaxed/simple;
	bh=OIiiIWkvkRH4uU1zoMwgHl+yU9w2DFpgsbIVvA+qe9E=;
	h=Date:To:From:Subject:Message-Id; b=H2G0tIl6GAP5x+SUtuWu/Anady16crCkPWvRpmRyPrES81AuIcMbsso8oQ+OlmVwVkIZXD+py4DhMSKuunGgbsjscNYE88Mjf3gYu+wpZo65qcgCR/df6QMHhht6bTgHusiTTpBHCFDLSAOEU+GIiEzewGWypjFx2gNVrUGqOjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MvBN/rOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MvBN/rOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B57C4CEC6;
	Fri,  4 Oct 2024 22:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728080761;
	bh=OIiiIWkvkRH4uU1zoMwgHl+yU9w2DFpgsbIVvA+qe9E=;
	h=Date:To:From:Subject:From;
	b=MvBN/rOLDsXUEyJ4EMEqiNT8hsSRy82Oob6SZlJSpW9v/EAtkZVsfblXA3A2QY6sH
	 Cqv424MoZE+lXiqfU3S786uBHyBisgpcckIwLxawSCP277U/ewn2NM/gpQKUWvzLpR
	 Z742DBfvzlBEOJL6DxW5fIKGgFX2aPOsY5AgMJnU=
Date: Fri, 04 Oct 2024 15:26:00 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,rmoar@google.com,davidgow@google.com,brunofrancadevsec@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-math-add-int_log-test-suite.patch removed from -mm tree
Message-Id: <20241004222601.84B57C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/math: add int_log test suite
has been removed from the -mm tree.  Its filename was
     lib-math-add-int_log-test-suite.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Bruno Sobreira França <brunofrancadevsec@gmail.com>
Subject: lib/math: add int_log test suite
Date: Wed, 25 Sep 2024 02:56:06 +0000

Introduce KUnit tests for the intlog2 and intlog10 functions, which
compute logarithms in base 2 and base 10, respectively.  The tests cover a
range of inputs to ensure the correctness of these functions across common
and edge cases.

Link: https://lkml.kernel.org/r/20240925025606.1714-1-brunofrancadevsec@gmail.com
Signed-off-by: Bruno Sobreira França <brunofrancadevsec@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug              |   11 ++++
 lib/math/Makefile              |    3 -
 lib/math/tests/Makefile        |    1 
 lib/math/tests/int_log_kunit.c |   75 +++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-math-add-int_log-test-suite
+++ a/lib/Kconfig.debug
@@ -3104,3 +3104,14 @@ config INT_POW_TEST
 	  function.
 
 	  If unsure, say N
+
+config INT_LOG_TEST
+	tristate "Integer log (int_log) test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the int_log library, which
+	  provides two functions to compute the integer logarithm in base 2 and
+	  base 10, called respectively as intlog2 and intlog10.
+
+	  If unsure, say N
--- a/lib/math/Makefile~lib-math-add-int_log-test-suite
+++ a/lib/math/Makefile
@@ -5,7 +5,8 @@ obj-$(CONFIG_CORDIC)		+= cordic.o
 obj-$(CONFIG_PRIME_NUMBERS)	+= prime_numbers.o
 obj-$(CONFIG_RATIONAL)		+= rational.o
 
-obj-$(CONFIG_INT_POW_TEST)  += tests/int_pow_kunit.o
+obj-$(CONFIG_INT_POW_TEST)  	+= tests/int_pow_kunit.o
+obj-$(CONFIG_INT_LOG_TEST) 	+= tests/int_log_kunit.o
 obj-$(CONFIG_TEST_DIV64)	+= test_div64.o
 obj-$(CONFIG_TEST_MULDIV64)	+= test_mul_u64_u64_div_u64.o
 obj-$(CONFIG_RATIONAL_KUNIT_TEST) += rational-test.o
diff --git a/lib/math/tests/int_log_kunit.c a/lib/math/tests/int_log_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/math/tests/int_log_kunit.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+#include <linux/int_log.h>
+
+struct test_case_params {
+	u32 value;
+	unsigned int expected_result;
+	const char *name;
+};
+
+
+/* The expected result takes into account the log error */
+static const struct test_case_params intlog2_params[] = {
+	{0, 0, "Log base 2 of 0"},
+	{1, 0, "Log base 2 of 1"},
+	{2, 16777216, "Log base 2 of 2"},
+	{3, 26591232, "Log base 2 of 3"},
+	{4, 33554432, "Log base 2 of 4"},
+	{8, 50331648, "Log base 2 of 8"},
+	{16, 67108864, "Log base 2 of 16"},
+	{32, 83886080, "Log base 2 of 32"},
+	{U32_MAX, 536870911, "Log base 2 of MAX"},
+};
+
+static const struct test_case_params intlog10_params[] = {
+	{0, 0, "Log base 10 of 0"},
+	{1, 0, "Log bsae 10 of 1"},
+	{6, 13055203, "Log base 10 of 6"},
+	{10, 16777225, "Log base 10 of 10"},
+	{100, 33554450, "Log base 10 of 100"},
+	{1000, 50331675, "Log base 10 of 1000"},
+	{10000, 67108862, "Log base 10 of 10000"},
+	{U32_MAX, 161614247, "Log base 10 of MAX"}
+};
+
+static void get_desc(const struct test_case_params *tc, char *desc)
+{
+	strscpy(desc, tc->name, KUNIT_PARAM_DESC_SIZE);
+}
+
+
+KUNIT_ARRAY_PARAM(intlog2, intlog2_params, get_desc);
+
+static void intlog2_test(struct kunit *test)
+{
+	const struct test_case_params *tc = (const struct test_case_params *)test->param_value;
+
+	KUNIT_EXPECT_EQ(test, tc->expected_result, intlog2(tc->value));
+}
+
+KUNIT_ARRAY_PARAM(intlog10, intlog10_params, get_desc);
+
+static void intlog10_test(struct kunit *test)
+{
+	const struct test_case_params *tc = (const struct test_case_params *)test->param_value;
+
+	KUNIT_EXPECT_EQ(test, tc->expected_result, intlog10(tc->value));
+}
+
+static struct kunit_case math_int_log_test_cases[] = {
+	KUNIT_CASE_PARAM(intlog2_test, intlog2_gen_params),
+	KUNIT_CASE_PARAM(intlog10_test, intlog10_gen_params),
+	{}
+};
+
+static struct kunit_suite int_log_test_suite = {
+	.name = "math-int_log",
+	.test_cases =  math_int_log_test_cases,
+};
+
+kunit_test_suites(&int_log_test_suite);
+
+MODULE_DESCRIPTION("math.int_log KUnit test suite");
+MODULE_LICENSE("GPL");
+
--- a/lib/math/tests/Makefile~lib-math-add-int_log-test-suite
+++ a/lib/math/tests/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_INT_POW_TEST) += int_pow_kunit.o
+obj-$(CONFIG_INT_LOG_TEST) += int_log_kunit.o
_

Patches currently in -mm which might be from brunofrancadevsec@gmail.com are


