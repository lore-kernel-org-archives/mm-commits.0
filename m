Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE36215C131
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727257467; cv=none; b=VFdpg+01H46EfFs+1OH/mG4TNqUkVIIikyVvwN+IvFPFRo/zDvMR3jUHubmvQkZ3uGznnQf7P4IBhXHj8VFLiFRZqheTgbUNny4HJVnu9yrgoCuFDSMDyyV9ONysFK2Cj1a3O1Jcza3lNkE6GbtaTHBIAbnkpefgZI1yJ6hIbJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727257467; c=relaxed/simple;
	bh=TcB7jlem8k9JQ/Pdqsk5OL4TfEDfy5qeR7Xintf/flo=;
	h=Date:To:From:Subject:Message-Id; b=qWafbtDrmLRcpnxN1124L8sAdFnI3jWlmyFot8+TVVn81XccgkaoWJL0q1s5RxNAenBoXNGe01EwCAY/wluAgxx1un221Ze/wW2qyG4tZtV0SAtfDs9BcSBMvMCO2/yiGr3f2rtQZuW6y14uN5ygYIAdDDgYlI9bD2x25VN0X3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T2LrmEV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T2LrmEV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EBDC4CEC3;
	Wed, 25 Sep 2024 09:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727257467;
	bh=TcB7jlem8k9JQ/Pdqsk5OL4TfEDfy5qeR7Xintf/flo=;
	h=Date:To:From:Subject:From;
	b=T2LrmEV2FHBhBRwiEYQnH+Buwt6Cr0aMeau9bewFUQvuIjEG28O8x35YJgitZw0nD
	 IL20PnjmrAazl+dWPSnihs1YBmBzF2hdFtZNK5vcH8ulA35D9DzuhjGoa2UuozpZne
	 jclFYKI6zrEcyAPbxOW2tZDs3cNA7etnyzoVwP0k=
Date: Wed, 25 Sep 2024 02:44:26 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,rmoar@google.com,davidgow@google.com,brunofrancadevsec@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-add-int_log-test-suite.patch added to mm-nonmm-unstable branch
Message-Id: <20240925094427.34EBDC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/math: Add int_log test suite
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-math-add-int_log-test-suite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-math-add-int_log-test-suite.patch

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
From: Bruno Sobreira França <brunofrancadevsec@gmail.com>
Subject: lib/math: Add int_log test suite
Date: Wed, 25 Sep 2024 02:56:06 +0000

Introduce KUnit tests for the intlog2 and intlog10 functions, which
compute logarithms in base 2 and base 10, respectively.  The tests cover a
range of inputs to ensure the correctness of these functions across common
and edge cases.

Link: https://lkml.kernel.org/r/20240925025606.1714-1-brunofrancadevsec@gmail.com
Signed-off-by: Bruno Sobreira França <brunofrancadevsec@gmail.com>
Cc: David Gow <davidgow@google.com>
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
@@ -3089,3 +3089,14 @@ config INT_POW_TEST
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

lib-math-add-int_log-test-suite.patch

