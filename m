Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4485464B
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 02:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733970477; cv=none; b=L33/3rz/0EOszy7sBHr8+7epjbtg2Yv8HJUcW75szG2NEFCuylgdiFZ0yuNBSY5Pm22yOgjWOLdnMR6Y0n7Jstwlpy7mXUANqI4WkUzUO8sGj0bM6Z/BecfvxsaxucNpLAoFun/q50/GwsE6lgWsnsfzcoulgT7hqbSCkeODjxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733970477; c=relaxed/simple;
	bh=/yrfzJXuS+vyxUCg++8hBbj7Wb/f+GSgdKYRKH297G8=;
	h=Date:To:From:Subject:Message-Id; b=PMXVTG3Nrq9n45i0Wl+rYXlPwcdQFjY6Z+oq90qNI7O73lAg7oPUKYExTooWLcDytebO07C2m0OSplPZzsG2L4dDHGCDK6c55L2+QU7H/aAu66Mgi0AtQBtfDieIyRhTVvCVNnGcjCz2wlzwVqrKWrziL7nS/pJVP/CRPKwxHEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vl+dljkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vl+dljkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD749C4CED2;
	Thu, 12 Dec 2024 02:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733970476;
	bh=/yrfzJXuS+vyxUCg++8hBbj7Wb/f+GSgdKYRKH297G8=;
	h=Date:To:From:Subject:From;
	b=Vl+dljkXFkMoRINBhaFvV5GtsHJ54OXiZmiiqJWjwqqfNIhe7a8ojYTwFltt3P/Hp
	 OusyUjPZuqPBSCxTLTkCxbyZQR2JDmNY/ii4qCnhK665e2GYNSDjqFcfuWBh/ONazW
	 X6i2V7Fzy8qbgIzyzP+jkHnMBv5C3YBqfhmhU93c=
Date: Wed, 11 Dec 2024 18:27:56 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,stern@rowland.harvard.edu,skhan@linuxfoundation.org,rbm@suse.com,npitre@baylibre.com,davidgow@google.com,andriy.shevchenko@linux.intel.com,luis.hernandez093@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-add-int_sqrt-test-suite.patch added to mm-nonmm-unstable branch
Message-Id: <20241212022756.CD749C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/math: add int_sqrt test suite
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-math-add-int_sqrt-test-suite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-math-add-int_sqrt-test-suite.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Luis Felipe Hernandez <luis.hernandez093@gmail.com>
Subject: lib/math: add int_sqrt test suite
Date: Wed, 11 Dec 2024 21:12:58 -0500

Adds test suite for integer based square root function.

The test suite is designed to verify the correctness of the int_sqrt()
math library function.

Link: https://lkml.kernel.org/r/20241212021259.20591-1-luis.hernandez093@gmail.com
Signed-off-by: Luis Felipe Hernandez <luis.hernandez093@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Nicolas Pitre <npitre@baylibre.com>
Cc: Ricardo B. Marliere <rbm@suse.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug               |   15 ++++++
 lib/math/Makefile               |    1 
 lib/math/tests/Makefile         |    1 
 lib/math/tests/int_sqrt_kunit.c |   66 ++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+)

--- a/lib/Kconfig.debug~lib-math-add-int_sqrt-test-suite
+++ a/lib/Kconfig.debug
@@ -3174,6 +3174,21 @@ config INT_POW_TEST
 
 	  If unsure, say N
 
+config INT_SQRT_KUNIT_TEST
+	tristate "Integer square root test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the int_sqrt() function,
+	  which performs square root calculation. The test suite checks
+	  various scenarios, including edge cases, to ensure correctness.
+
+	  Enabling this option will include tests that check various scenarios
+	  and edge cases to ensure the accuracy and reliability of the square root
+	  function.
+
+	  If unsure, say N
+
 endif # RUNTIME_TESTING_MENU
 
 config ARCH_USE_MEMTEST
--- a/lib/math/Makefile~lib-math-add-int_sqrt-test-suite
+++ a/lib/math/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_INT_POW_TEST)  += tests/int
 obj-$(CONFIG_TEST_DIV64)	+= test_div64.o
 obj-$(CONFIG_TEST_MULDIV64)	+= test_mul_u64_u64_div_u64.o
 obj-$(CONFIG_RATIONAL_KUNIT_TEST) += rational-test.o
+obj-y  += tests/
diff --git a/lib/math/tests/int_sqrt_kunit.c a/lib/math/tests/int_sqrt_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/math/tests/int_sqrt_kunit.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+#include <linux/limits.h>
+#include <linux/math.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+struct test_case_params {
+	unsigned long x;
+	unsigned long expected_result;
+	const char *name;
+};
+
+static const struct test_case_params params[] = {
+	{ 0, 0, "edge case: square root of 0" },
+	{ 1, 1, "perfect square: square root of 1" },
+	{ 2, 1, "non-perfect square: square root of 2" },
+	{ 3, 1, "non-perfect square: square root of 3" },
+	{ 4, 2, "perfect square: square root of 4" },
+	{ 5, 2, "non-perfect square: square root of 5" },
+	{ 6, 2, "non-perfect square: square root of 6" },
+	{ 7, 2, "non-perfect square: square root of 7" },
+	{ 8, 2, "non-perfect square: square root of 8" },
+	{ 9, 3, "perfect square: square root of 9" },
+	{ 15, 3, "non-perfect square: square root of 15 (N-1 from 16)" },
+	{ 16, 4, "perfect square: square root of 16" },
+	{ 17, 4, "non-perfect square: square root of 17 (N+1 from 16)" },
+	{ 80, 8, "non-perfect square: square root of 80 (N-1 from 81)" },
+	{ 81, 9, "perfect square: square root of 81" },
+	{ 82, 9, "non-perfect square: square root of 82 (N+1 from 81)" },
+	{ 255, 15, "non-perfect square: square root of 255 (N-1 from 256)" },
+	{ 256, 16, "perfect square: square root of 256" },
+	{ 257, 16, "non-perfect square: square root of 257 (N+1 from 256)" },
+	{ 2147483648, 46340, "large input: square root of 2147483648" },
+	{ 4294967295, 65535, "edge case: ULONG_MAX for 32-bit" },
+};
+
+static void get_desc(const struct test_case_params *tc, char *desc)
+{
+	strscpy(desc, tc->name, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(int_sqrt, params, get_desc);
+
+static void int_sqrt_test(struct kunit *test)
+{
+	const struct test_case_params *tc = (const struct test_case_params *)test->param_value;
+
+	KUNIT_EXPECT_EQ(test, tc->expected_result, int_sqrt(tc->x));
+}
+
+static struct kunit_case math_int_sqrt_test_cases[] = {
+	KUNIT_CASE_PARAM(int_sqrt_test, int_sqrt_gen_params),
+	{}
+};
+
+static struct kunit_suite int_sqrt_test_suite = {
+	.name = "math-int_sqrt",
+	.test_cases = math_int_sqrt_test_cases,
+};
+
+kunit_test_suites(&int_sqrt_test_suite);
+
+MODULE_DESCRIPTION("math.int_sqrt KUnit test suite");
+MODULE_LICENSE("GPL");
--- a/lib/math/tests/Makefile~lib-math-add-int_sqrt-test-suite
+++ a/lib/math/tests/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_INT_POW_TEST) += int_pow_kunit.o
+obj-$(CONFIG_INT_SQRT_KUNIT_TEST) += int_sqrt_kunit.o
_

Patches currently in -mm which might be from luis.hernandez093@gmail.com are

lib-math-add-int_sqrt-test-suite.patch

