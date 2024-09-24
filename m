Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE11146D45
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 22:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727218337; cv=none; b=gnZTOKNmSFmdi/l3C7xfsr4eBVRzpsCEL129EDVAIovoUhshisg0canYHbpAbGr07KyDokYUgb3AQ6mjpqRXyCiRHU5wsil7BNTXH3iY/FLE0I6r45v2TrSj6UNaLPEx6+rcRCZRNGZ68ifNW24UD1GNt72pfBwfKYRCwZSRx3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727218337; c=relaxed/simple;
	bh=KGEOPC4ToTEvGXPwYm/XVgcsIj06+c1N2cxFxN20Mt8=;
	h=Date:To:From:Subject:Message-Id; b=lAsjo9KzJxIBTXtUzOvffsnMzpmLHsVteKNHpHQeV9/5GYYxkrZ4p1kXaM0iQSe8a7M8L6GvwhwF5Z3ldxrnvlaUji3SURWvKUS0rrWHenX6iZxHmIlftESuY5TcbmNSjKQcTilnVSQb5vfQIVj045eMWWcotS7nkjGY8wItShc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hmcbapCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hmcbapCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76830C4CEC4;
	Tue, 24 Sep 2024 22:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727218337;
	bh=KGEOPC4ToTEvGXPwYm/XVgcsIj06+c1N2cxFxN20Mt8=;
	h=Date:To:From:Subject:From;
	b=hmcbapCqlOLPrLt/RJ++dasdM+ioNx1e9A170uXr5Da9x7iKEW2fRk6Kz6wtwm6c5
	 iq/CNFgWrK439wbavcYfzK39blGIR1FNiea+BCgHdqIfQ0NQigby2KRn2PkDNLaTcr
	 bPgaMAvMe9KRUtQ9XV7aziwWdQbMDxJedL5BTs30=
Date: Tue, 24 Sep 2024 15:52:16 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,rmoar@google.com,davidgow@google.com,brunofrancadevsec@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-add-int_log-test-suite.patch added to mm-nonmm-unstable branch
Message-Id: <20240924225217.76830C4CEC4@smtp.kernel.org>
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
From: =?UTF-8?q?Bruno=20Sobreira=20Fran=C3=A7a?= <brunofrancadevsec@gmail.com>
Subject: lib/math: Add int_log test suite
Date: Mon, 23 Sep 2024 18:28:01 +0000

This commit introduces KUnit tests for the intlog2 and intlog10
functions, which compute logarithms in base 2 and base 10, respectively.
The tests cover a range of inputs to ensure the correctness of these
functions across common and edge cases.

Link: https://lkml.kernel.org/r/20240923182801.37747-1-brunofrancadevsec@gmail.com
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
+       	{16, 67108864, "Log base 2 of 16"},
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

