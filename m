Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6991EBFE4
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 07:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733987925; cv=none; b=WsnUgQjOn+eNsxM+pZtwAWCtaWXWdnggjRqa2qKIbOeHgLuztBvl40+Bbajjy+JstP2skCMkTbWE5AqNCfSziuff3i4mD1HVGwYE+LNHXIxP/DnTLG2B7DLnS40UE4SPsyFP92cIaRFRUirpPT08K77pm1aSjDRv//7YG/iONEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733987925; c=relaxed/simple;
	bh=dXj37UbWe3ZyghANCzzfn7aNTRdroCiLwiGXukNxhv0=;
	h=Date:To:From:Subject:Message-Id; b=SWgjUSlrjVgrhfjKCEq77deKlTqhwQUk6Xa27QG77Rpz/TbDtku2Qn5G/fci0aPo+menxj6h7+PmAbXU9BCub1MtqNTSI2tHJ2Hazwx/OKL+qKPd6lWvkQCofHSlqj/W5prhtyw7ZS2duvnvy6AH7pkru07OZranOwoYETP1Oro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f8mVXf4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f8mVXf4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D665AC4CECE;
	Thu, 12 Dec 2024 07:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733987924;
	bh=dXj37UbWe3ZyghANCzzfn7aNTRdroCiLwiGXukNxhv0=;
	h=Date:To:From:Subject:From;
	b=f8mVXf4w9F3foXFLjPXEmUeypQN9RBAsNRw22kjIE9hLYbpgp27pZXNOhP7XQl2u0
	 QMiNa8jhxKMoq+ahgWEh+dJ405oRTLjcYPQdll77yIlhqShVAaSj3EfWLnNsxfAfgB
	 wouNy0K4L0fPeKdHPkNhwNadW4ptNmepkIxpOozE=
Date: Wed, 11 Dec 2024 23:18:44 -0800
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,stern@rowland.harvard.edu,skhan@linuxfoundation.org,rbm@suse.com,npitre@baylibre.com,davidgow@google.com,andriy.shevchenko@linux.intel.com,luis.hernandez093@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] lib-math-add-int_sqrt-test-suite.patch removed from -mm tree
Message-Id: <20241212071844.D665AC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/math: add int_sqrt test suite
has been removed from the -mm tree.  Its filename was
     lib-math-add-int_sqrt-test-suite.patch

This patch was dropped because it had testing failures

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


