Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A774132B106
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816295; cv=none; b=e99E+4YyU6H76WLnAsNelvLOqk1ZKZmJe4sZZwcL7fffmcKQjjRUYgRNYHs5e6dPphSddOCESllomXFl0FqkLxAXd+sKjSbYSofKIPonugICrYzbbOxHa7BWy9fyLbxX7e8wepCVWfWNa3YdkihSiOzGIb8T9b+oPMS9HyyxMcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816295; c=relaxed/simple;
	bh=jvLN+H34Jq7IZ1G755njf8ob48IqH9JPWs3uxdApxgw=;
	h=Date:To:From:Subject:Message-Id; b=gp8k2In3K+9WyHmof5pQLZTjYT+6mqIUwIuj3MBNwf+o8pabV9I8zexmRnwSrxCP4TsTvsPrwMoJTrAOE5/XJchTrw/qC98a9oca8enIt+x5c5XIVpXCI4uUpgMoXsskVW6WePrbz2Y2gSNBGNoB+n5zEYIlzYNRwkg8FznCSgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YpRedHLk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YpRedHLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CD61F00A3A;
	Tue,  4 Aug 2026 04:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816293;
	bh=4jQme3hMBSCqfnkWWXGD2orVnzyV+MbdeP6OHSj/cbU=;
	h=Date:To:From:Subject;
	b=YpRedHLkevCeE52EIhCwsZEX4zskeyYS0BX+MbC3zXWQgvk1jhQLLveuaZ3utz7oE
	 upFHyxwI7utN/ow2LrLL9yUKH9BkxcQv5kMuT5TIAIh9es/vlxVd2fC6YnBVN5x3Yl
	 Gsb5bD+WJ4TsN8PQKFqn5UCG++G7K+3d7X3275lg=
Date: Mon, 03 Aug 2026 21:04:52 -0700
To: mm-commits@vger.kernel.org,Sergey.Semin@baikalelectronics.ru,raemoar63@gmail.com,maxim.kaurkin@baikalelectronics.ru,linux@roeck-us.net,david@davidgow.net,brendan.higgins@linux.dev,adinata.softwareengineer@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-math-add-kunit-test-suite-for-polynomial_calc.patch removed from -mm tree
Message-Id: <20260804040453.50CD61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/math: add KUnit test suite for polynomial_calc()
has been removed from the -mm tree.  Its filename was
     lib-math-add-kunit-test-suite-for-polynomial_calc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Adi Nata <adinata.softwareengineer@gmail.com>
Subject: lib/math: add KUnit test suite for polynomial_calc()
Date: Sat, 6 Jun 2026 11:03:09 +0800

Add a KUnit test suite for the polynomial_calc() function, which had no
in-kernel test coverage.  The tests verify correct evaluation of constant,
linear, quadratic, and cubic polynomials, including negative coefficients,
negative input data, zero-coefficient terms.

The Kconfig entry uses 'select POLYNOMIAL' rather than 'depends on
POLYNOMIAL' because POLYNOMIAL is a promptless tristate that cannot
be manually enabled on UML without an explicit selector.

Link: https://lore.kernel.org/20260606030319.316752-1-adinata.softwareengineer@gmail.com
Signed-off-by: Adi Nata <adinata.softwareengineer@gmail.com>
Cc: Maxim Kaurkin <maxim.kaurkin@baikalelectronics.ru>
Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: Rae Moar <raemoar63@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                 |   17 +
 lib/math/tests/Makefile           |    1 
 lib/math/tests/polynomial_kunit.c |  270 ++++++++++++++++++++++++++++
 3 files changed, 288 insertions(+)

--- a/lib/Kconfig.debug~lib-math-add-kunit-test-suite-for-polynomial_calc
+++ a/lib/Kconfig.debug
@@ -3476,6 +3476,23 @@ config GCD_KUNIT_TEST
 
 	  If unsure, say N
 
+config POLYNOMIAL_KUNIT_TEST
+	tristate "Polynomial calculation (polynomial_calc) test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	select POLYNOMIAL
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the polynomial_calc()
+	  function, which evaluates integer polynomials using factor
+	  redistribution to avoid overflow.
+
+	  The test suite verifies correctness for constant, linear, and
+	  quadratic polynomials, negative coefficients, per-step dividers,
+	  divider_leftover, total_divider scaling, and a real sensor
+	  N-to-temperature conversion polynomial.
+
+	  If unsure, say N
+
 config PRIME_NUMBERS_KUNIT_TEST
 	tristate "Prime number generator test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
--- a/lib/math/tests/Makefile~lib-math-add-kunit-test-suite-for-polynomial_calc
+++ a/lib/math/tests/Makefile
@@ -4,5 +4,6 @@ obj-$(CONFIG_GCD_KUNIT_TEST)		+= gcd_kun
 obj-$(CONFIG_INT_LOG_KUNIT_TEST)	+= int_log_kunit.o
 obj-$(CONFIG_INT_POW_KUNIT_TEST)	+= int_pow_kunit.o
 obj-$(CONFIG_INT_SQRT_KUNIT_TEST)	+= int_sqrt_kunit.o
+obj-$(CONFIG_POLYNOMIAL_KUNIT_TEST)	+= polynomial_kunit.o
 obj-$(CONFIG_PRIME_NUMBERS_KUNIT_TEST)	+= prime_numbers_kunit.o
 obj-$(CONFIG_RATIONAL_KUNIT_TEST)	+= rational_kunit.o
diff --git a/lib/math/tests/polynomial_kunit.c a/lib/math/tests/polynomial_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/math/tests/polynomial_kunit.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+#include <linux/polynomial.h>
+
+struct polynomial_test_param {
+	const struct polynomial *poly;
+	long data;
+	long expected;
+	const char *name;
+};
+
+/* f(x) = 5 */
+static const struct polynomial poly_constant = {
+	.total_divider = 1,
+	.terms = {
+		{0, 5, 1, 1},
+	}
+};
+
+/* f(x) = 2x^2 + 3x + 5 */
+static const struct polynomial poly_simple = {
+	.total_divider = 1,
+	.terms = {
+		{2, 2, 1, 1},
+		{1, 3, 1, 1},
+		{0, 5, 1, 1},
+	}
+};
+
+/* f(x) = -5x + 100 */
+static const struct polynomial poly_negative_coef = {
+	.total_divider = 1,
+	.terms = {
+		{1, -5, 1, 1},
+		{0, 100, 1, 1},
+	}
+};
+
+/* f(x) = (150x + 50) / 10 */
+static const struct polynomial poly_total_divider = {
+	.total_divider = 10,
+	.terms = {
+		{1, 150, 1, 1},
+		{0,  50, 1, 1},
+	}
+};
+
+/*
+ * f(x) = x / 2
+ * divider=2 applied once per multiply: mult_frac(coef, data, 2) = coef*data/2
+ */
+static const struct polynomial poly_step_divider = {
+	.total_divider = 1,
+	.terms = {
+		{1, 1, 2, 1},
+		{0, 0, 1, 1},
+	}
+};
+
+/*
+ * f(x) = (100/500) * x^2 = 0.2 * x^2
+ * Encoded as coef=100, divider=10, divider_leftover=5:
+ *   denom = 10^2 * 5 = 500
+ */
+static const struct polynomial poly_leftover = {
+	.total_divider = 1,
+	.terms = {
+		{2, 100, 10, 5},
+		{0,   0,  1, 1},
+	}
+};
+
+/*
+ * f(x) = 2x^3  (single high-degree term, no constant)
+ * Used to exercise the power loop alone.
+ */
+static const struct polynomial poly_cubic = {
+	.total_divider = 1,
+	.terms = {
+		{3, 2, 1, 1},
+		{0, 0, 1, 1},
+	}
+};
+
+/*
+ * f(x) = 4x + 1  with a zero-coefficient quadratic term.
+ * The deg-2 term contributes nothing regardless of input.
+ */
+static const struct polynomial poly_zero_coef = {
+	.total_divider = 1,
+	.terms = {
+		{2, 0, 1, 1},
+		{1, 4, 1, 1},
+		{0, 1, 1, 1},
+	}
+};
+
+/*
+ * f(x) = 9  with total_divider = 0.
+ * The implementation treats 0 as 1 via `total_divider ?: 1`, so the
+ * result must equal the constant term unchanged.
+ */
+static const struct polynomial poly_zero_total_divider = {
+	.total_divider = 0,
+	.terms = {
+		{0, 9, 1, 1},
+	}
+};
+
+
+static const struct polynomial_test_param test_params[] = {
+	{
+		.poly     = &poly_constant,
+		.data     = 0,
+		.expected = 5,
+		.name     = "Constant polynomial at x=0",
+	},
+	{
+		.poly     = &poly_constant,
+		.data     = 42,
+		.expected = 5,
+		.name     = "Constant polynomial is independent of input",
+	},
+	{
+		.poly     = &poly_simple,
+		.data     = 0,
+		.expected = 5,	/* zero input collapses all power terms */
+		.name     = "Zero input yields constant term only",
+	},
+	{
+		.poly     = &poly_simple,
+		.data     = 10,
+		.expected = 235,	/* 2*100 + 3*10 + 5 */
+		.name     = "Simple quadratic at x=10",
+	},
+	{
+		.poly     = &poly_negative_coef,
+		.data     = 10,
+		.expected = 50,		/* -5*10 + 100 */
+		.name     = "Negative coefficient at x=10",
+	},
+	{
+		.poly     = &poly_negative_coef,
+		.data     = 20,
+		.expected = 0,		/* -5*20 + 100 = 0 */
+		.name     = "Negative coefficient result is zero",
+	},
+	{
+		.poly     = &poly_total_divider,
+		.data     = 3,
+		.expected = 50,		/* (150*3 + 50) / 10 = 500/10 */
+		.name     = "total_divider scales the final sum",
+	},
+	{
+		.poly     = &poly_step_divider,
+		.data     = 100,
+		.expected = 50,		/* 1*100/2 */
+		.name     = "Per-step divider halves input",
+	},
+	{
+		.poly     = &poly_leftover,
+		.data     = 30,
+		.expected = 180,	/* 100*30^2 / (10^2 * 5) = 90000/500 */
+		.name     = "divider_leftover with quadratic term",
+	},
+	/* Boundary: unit and negative-unit input */
+	{
+		/*
+		 * data=1: each mult_frac(tmp, 1, divider) strips one factor of
+		 * divider from coef per degree, so coef is left-shifted right
+		 * until intermediate precision is exhausted.
+		 * 2*1 + 3*1 + 5 = 10
+		 */
+		.poly     = &poly_simple,
+		.data     = 1,
+		.expected = 10,
+		.name     = "Boundary: data=1 (unit input)",
+	},
+	{
+		/*
+		 * data=-1: even degrees produce positive contributions,
+		 * odd degrees produce negative ones.
+		 * 2*(-1)^2 + 3*(-1) + 5 = 2 - 3 + 5 = 4
+		 */
+		.poly     = &poly_simple,
+		.data     = -1,
+		.expected = 4,
+		.name     = "Boundary: data=-1 (negative unit input)",
+	},
+
+	/* Boundary: negative non-trivial input */
+	{
+		/*
+		 * 2*(-3)^2 + 3*(-3) + 5 = 18 - 9 + 5 = 14
+		 * Verifies sign handling for negative data across all degrees.
+		 */
+		.poly     = &poly_simple,
+		.data     = -3,
+		.expected = 14,
+		.name     = "Boundary: negative data with quadratic",
+	},
+
+	/* Boundary: total_divider = 0 is treated as 1 */
+	{
+		.poly     = &poly_zero_total_divider,
+		.data     = 42,
+		.expected = 9,
+		.name     = "Boundary: total_divider=0 defaults to 1",
+	},
+
+	/* Boundary: zero-coefficient high-degree term */
+	{
+		/*
+		 * The deg-2 term has coef=0, so it contributes 0 regardless
+		 * of data. Result: 0 + 4*10 + 1 = 41
+		 */
+		.poly     = &poly_zero_coef,
+		.data     = 10,
+		.expected = 41,
+		.name     = "Boundary: zero-coefficient term is inert",
+	},
+
+	/* Boundary: single high-degree term, no constant */
+	{
+		/* 2 * 5^3 = 250; also verifies the loop terminates on deg-0 */
+		.poly     = &poly_cubic,
+		.data     = 5,
+		.expected = 250,
+		.name     = "Boundary: single cubic term",
+	},
+	{
+		/* 2 * (-2)^3 = -16; odd power preserves sign of negative data */
+		.poly     = &poly_cubic,
+		.data     = -2,
+		.expected = -16,
+		.name     = "Boundary: single cubic term, negative data",
+	},
+
+};
+
+static void get_desc(const struct polynomial_test_param *param, char *desc)
+{
+	strscpy(desc, param->name, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(polynomial, test_params, get_desc);
+
+static void polynomial_calc_test(struct kunit *test)
+{
+	const struct polynomial_test_param *param = test->param_value;
+
+	KUNIT_EXPECT_EQ(test, polynomial_calc(param->poly, param->data),
+			param->expected);
+}
+
+static struct kunit_case polynomial_test_cases[] = {
+	KUNIT_CASE_PARAM(polynomial_calc_test, polynomial_gen_params),
+	{}
+};
+
+static struct kunit_suite polynomial_test_suite = {
+	.name = "math-polynomial",
+	.test_cases = polynomial_test_cases,
+};
+
+kunit_test_suites(&polynomial_test_suite);
+
+MODULE_DESCRIPTION("math.polynomial_calc KUnit test suite");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from adinata.softwareengineer@gmail.com are


