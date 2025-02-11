Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6973597B
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 01:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739236328; cv=none; b=LvB4IEnpZY4a+wxNdW491xTJ77bfVc0qljRfPxglVHDmNtYDUxHCkGDCPESTn/SkCaBCtNJc/o+o5L7tLnv2ifzaZesgvvsCasLtVkHhckWRKlxWfwatWQFimey7ul6PyxSy77AicOf+Y1zhk7LwQ1//Bt4dpPke5+sWFsLY8sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739236328; c=relaxed/simple;
	bh=71REf9MxxPZM0am+6ZJfcrZAPk0TBBPpnc0Lx3AIId4=;
	h=Date:To:From:Subject:Message-Id; b=aN9t++tJ+Ud1BV2WeSwbTmmtplppup/neAzRUSLpbWUtm0B9ZCUAXnzBx+Wu6pdMX+lWQX7s+caGbGJlaN8EpxSkQb3RzmHXNAUhs9OFiDdE0xCHr8MUaOxv3q/nsGQiH4WW+bRfwiqPrIstPcloXmhvHO8s3/48TnVtYBMVGS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vZ/SxpaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vZ/SxpaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7250EC4CED1;
	Tue, 11 Feb 2025 01:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739236327;
	bh=71REf9MxxPZM0am+6ZJfcrZAPk0TBBPpnc0Lx3AIId4=;
	h=Date:To:From:Subject:From;
	b=vZ/SxpaTFOOi5MEvW+vy3J3+8fx/Sbe134okT9S37WikkyToXVKmXw52Btggx7HEZ
	 k67A5bCgZNJ+BDRtixvG4b+5aHtzLXU78wl6b6MYfU6OZKkXVuKYtZClnmzRS5QIuU
	 KdiNkdRdUmOg6vQywEXDd2Q/nrz1MXBOeZiJeMnc=
Date: Mon, 10 Feb 2025 17:12:06 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,skhan@linuxfoundation.org,luis.hernandez093@gmail.com,jserv@ccns.ncku.edu.tw,davidgow@google.com,eleanor15x@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-math-add-kunit-test-suite-for-gcd.patch removed from -mm tree
Message-Id: <20250211011207.7250EC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/math: add Kunit test suite for gcd()
has been removed from the -mm tree.  Its filename was
     lib-math-add-kunit-test-suite-for-gcd.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yu-Chun Lin <eleanor15x@gmail.com>
Subject: lib/math: add Kunit test suite for gcd()
Date: Mon, 3 Feb 2025 15:54:00 +0800

Add a KUnit test suite for the gcd() function.  This test suite verifies
the correctness of gcd() across various scenarios, including edge cases.

Link: https://lkml.kernel.org/r/20250203075400.3431330-1-eleanor15x@gmail.com
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: David Gow <davidgow@google.com>
Cc: Luis Felipe Hernandez <luis.hernandez093@gmail.com>
Cc: Shuah khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug          |   13 ++++++++
 lib/math/Makefile          |    3 +
 lib/math/tests/Makefile    |    1 
 lib/math/tests/gcd_kunit.c |   56 +++++++++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-math-add-kunit-test-suite-for-gcd
+++ a/lib/Kconfig.debug
@@ -3197,6 +3197,19 @@ config INT_SQRT_KUNIT_TEST
 
 	  If unsure, say N
 
+config GCD_KUNIT_TEST
+	tristate "Greatest common divisor test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the gcd() function,
+	  which computes the greatest common divisor of two numbers.
+
+	  This test suite verifies the correctness of gcd() across various
+	  scenarios, including edge cases.
+
+	  If unsure, say N
+
 endif # RUNTIME_TESTING_MENU
 
 config ARCH_USE_MEMTEST
--- a/lib/math/Makefile~lib-math-add-kunit-test-suite-for-gcd
+++ a/lib/math/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_INT_POW_TEST)  += tests/int
 obj-$(CONFIG_TEST_DIV64)	+= test_div64.o
 obj-$(CONFIG_TEST_MULDIV64)	+= test_mul_u64_u64_div_u64.o
 obj-$(CONFIG_RATIONAL_KUNIT_TEST) += rational-test.o
-obj-$(CONFIG_INT_SQRT_KUNIT_TEST) += tests/int_sqrt_kunit.o
\ No newline at end of file
+obj-$(CONFIG_INT_SQRT_KUNIT_TEST) += tests/int_sqrt_kunit.o
+obj-$(CONFIG_GCD_KUNIT_TEST) += tests/gcd_kunit.o
diff --git a/lib/math/tests/gcd_kunit.c a/lib/math/tests/gcd_kunit.c
new file mode 100644
--- /dev/null
+++ a/lib/math/tests/gcd_kunit.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+#include <linux/gcd.h>
+#include <linux/limits.h>
+
+struct test_case_params {
+	unsigned long val1;
+	unsigned long val2;
+	unsigned long expected_result;
+	const char *name;
+};
+
+static const struct test_case_params params[] = {
+	{ 48, 18, 6, "GCD of 48 and 18" },
+	{ 18, 48, 6, "GCD of 18 and 48" },
+	{ 56, 98, 14, "GCD of 56 and 98" },
+	{ 17, 13, 1, "Coprime numbers" },
+	{ 101, 103, 1, "Coprime numbers" },
+	{ 270, 192, 6, "GCD of 270 and 192" },
+	{ 0, 5, 5, "GCD with zero" },
+	{ 7, 0, 7, "GCD with zero reversed" },
+	{ 36, 36, 36, "GCD of identical numbers" },
+	{ ULONG_MAX, 1, 1, "GCD of max ulong and 1" },
+	{ ULONG_MAX, ULONG_MAX, ULONG_MAX, "GCD of max ulong values" },
+};
+
+static void get_desc(const struct test_case_params *tc, char *desc)
+{
+	strscpy(desc, tc->name, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(gcd, params, get_desc);
+
+static void gcd_test(struct kunit *test)
+{
+	const struct test_case_params *tc = (const struct test_case_params *)test->param_value;
+
+	KUNIT_EXPECT_EQ(test, tc->expected_result, gcd(tc->val1, tc->val2));
+}
+
+static struct kunit_case math_gcd_test_cases[] = {
+	KUNIT_CASE_PARAM(gcd_test, gcd_gen_params),
+	{}
+};
+
+static struct kunit_suite gcd_test_suite = {
+	.name = "math-gcd",
+	.test_cases = math_gcd_test_cases,
+};
+
+kunit_test_suite(gcd_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("math.gcd KUnit test suite");
+MODULE_AUTHOR("Yu-Chun Lin <eleanor15x@gmail.com>");
--- a/lib/math/tests/Makefile~lib-math-add-kunit-test-suite-for-gcd
+++ a/lib/math/tests/Makefile
@@ -2,3 +2,4 @@
 
 obj-$(CONFIG_INT_POW_TEST) += int_pow_kunit.o
 obj-$(CONFIG_INT_SQRT_KUNIT_TEST) += int_sqrt_kunit.o
+obj-$(CONFIG_GCD_KUNIT_TEST) += gcd_kunit.o
_

Patches currently in -mm which might be from eleanor15x@gmail.com are


