Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31FDAD4B
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 00:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730421586; cv=none; b=ZSCd4UlHqawhtaFcpWhO5xlGqgZIWsb5DD7lPyFnNZPtqOsKE6Dz9v6Gv3q8J7tOJcyjiKBoZnfhCproYMn+fmAC8hyvqiZZFfkIefTQecM7OXyjaLcK9w9q/1XzCu5comViVIXNnbiqYXAGTjr+2YtCP2VecmJICSxewPDOL6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730421586; c=relaxed/simple;
	bh=zvjJusuXLxiKXAXe8HpH9vd/mSHwUoTgW2apn6VN+cM=;
	h=Date:To:From:Subject:Message-Id; b=Ja30U7ieOB1nDrU5BXoN5cTkX5DvOHFdkJzOIQ4Y4gX5sgIJbfHDRIfNjWl+MGJEttWqRG0o+onYf/xyUkmmKR9HTE9P9rYdMa2Zo04P/XFYaK6d2cxhBkU0cYBKpcVEL2l4SkoMXp+vd5wou/AGdBtcbL7Ne5XtXVLl5uFGHnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oh4i2RZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oh4i2RZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531BFC4CEC3;
	Fri,  1 Nov 2024 00:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730421585;
	bh=zvjJusuXLxiKXAXe8HpH9vd/mSHwUoTgW2apn6VN+cM=;
	h=Date:To:From:Subject:From;
	b=Oh4i2RZWyIBSlKgZrR9RAJRaF9OqxJ0gFSEQQ8XQrCIEisr4bzfCmTi1a5YryCOtb
	 e7A3wOLEobef2HdOWOqAYAGyB3mX4aoW5z28Uoszn+NrHdIjn4S/fz7nC2ajd46oWL
	 bofQeSdfLn4GGpngPMCjGoir1XY+guncue40zv20=
Date: Thu, 31 Oct 2024 17:39:44 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,ricardo@marliere.net,davidgow@google.com,brendan.higgins@linux.dev,andriy.shevchenko@linux.intel.com,luis.hernandez093@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-add-int_sqrt-test-suite.patch added to mm-nonmm-unstable branch
Message-Id: <20241101003945.531BFC4CEC3@smtp.kernel.org>
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
Date: Wed, 30 Oct 2024 09:43:53 -0400

Adds test suite for integer based square root function.

The test suite is designed to verify the correctness of the int_sqrt()
math library function.

Link: https://lkml.kernel.org/r/c213dbcb-35de-4afd-9d4b-f42f6a9e3de6@linuxfoundation.org
Signed-off-by: Luis Felipe Hernandez <luis.hernandez093@gmail.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Luis Felipe Hernandez <luis.hernandez093@gmail.com>
Cc: Ricardo B. Marliere <ricardo@marliere.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug               |   15 ++++++++
 lib/math/Makefile               |    1 
 lib/math/tests/Makefile         |    1 
 lib/math/tests/int_sqrt_kunit.c |   51 ++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+)

--- a/lib/Kconfig.debug~lib-math-add-int_sqrt-test-suite
+++ a/lib/Kconfig.debug
@@ -3020,6 +3020,21 @@ config INT_POW_TEST
 
 	  If unsure, say N
 
+config INT_SQRT_KUNIT_TEST
+	tristate "Integer square root test test" if !KUNIT_ALL_TESTS
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
@@ -0,0 +1,51 @@
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
+	{ 0, 0, "edge-case: square root of 0" },
+	{ 4, 2, "perfect square: square root of 4" },
+	{ 81, 9, "perfect square: square root of 9" },
+	{ 2, 1, "non-perfect square: square root of 2" },
+	{ 5, 2, "non-perfect square: square root of 5"},
+	{ ULONG_MAX, 4294967295, "large input"},
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

