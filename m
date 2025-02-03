Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E8C209692
	for <mm-commits@vger.kernel.org>; Mon,  3 Feb 2025 23:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738626448; cv=none; b=C8et1YOyxDXZi/QvT0cyu7z6wqiSVF4HlakM0TsKk6Dv9SB0z4VK1kjNzHz9JXXXBBjEv8EqYr0/PfXABvfsOgJ3PN1GoCwsPXNsL0ZAwqgYrmLVvIsckuHoaYhS+8CptCPb4iO1BSk3Pmqa7ZAsDMJm7bKn+d4D0963MSYCSDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738626448; c=relaxed/simple;
	bh=zbPBAlOvSynBM4aVfrzZT6Mnah+Sy+2usjlaOZm6DSw=;
	h=Date:To:From:Subject:Message-Id; b=B5mcqbk4Gepn6A4TtW8FKulDB6xAN2l+ZEoVPw47sG0TZcsFUdM04b3kpgMmkLgOjbZZjyBu2g18cckp3gSw4fDLJhk1ObMozW/TT4da7dz7C3YLDHudceA/BRU1kGFVBL8ZbQE98oBEFudFHvmL+S86cL6jObA8qwkZmMSFRCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yz86lSF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yz86lSF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538B1C4CEE0;
	Mon,  3 Feb 2025 23:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738626447;
	bh=zbPBAlOvSynBM4aVfrzZT6Mnah+Sy+2usjlaOZm6DSw=;
	h=Date:To:From:Subject:From;
	b=Yz86lSF7g7xOI0HZq5A89J0IG7bFeXCz/T1TqIosQ/wx01p815abovdmZs/9zmeyO
	 HXtzZakKTt8qHl1jYG+ppuFKDGKaKcR2rk1gLoc+r1KY4Q8guAZGITXyKvrRhrowvU
	 llCDGQgXMGIfWi2jyyCivDhAc+7TnKybdKMskcOs=
Date: Mon, 03 Feb 2025 15:47:26 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,skhan@linuxfoundation.org,luis.hernandez093@gmail.com,jserv@ccns.ncku.edu.tw,davidgow@google.com,eleanor15x@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-add-kunit-test-suite-for-gcd.patch added to mm-nonmm-unstable branch
Message-Id: <20250203234727.538B1C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/math: add Kunit test suite for gcd()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-math-add-kunit-test-suite-for-gcd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-math-add-kunit-test-suite-for-gcd.patch

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
From: Yu-Chun Lin <eleanor15x@gmail.com>
Subject: lib/math: add Kunit test suite for gcd()
Date: Mon, 3 Feb 2025 15:54:00 +0800

Add a KUnit test suite for the gcd() function.  This test suite verifies
the correctness of gcd() across various scenarios, including edge cases.

Link: https://lkml.kernel.org/r/20250203075400.3431330-1-eleanor15x@gmail.com
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: David Gow <davidgow@google.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
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

lib-math-add-kunit-test-suite-for-gcd.patch

