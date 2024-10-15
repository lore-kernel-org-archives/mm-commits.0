Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51460A29
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 00:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728951246; cv=none; b=A+l7OBw89IqcrFzICDU4n548LM7X1ikxa4eo+gRo/PxtI/lI++nESV1j5Z8u8ykoCxY+Ugip2ZJGl2hfKTqUQBvuNmM3hDn570I32Eh7jbRF6uGFFZqnBTLOs9iyfrafoA50w89XGZESEb+p4K0WbKCJUS4XE/AWweZhdz2qlFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728951246; c=relaxed/simple;
	bh=AT9Q9AAiYezNUNkEQKLlP85wMbrUJxEKmDZDImvCaNI=;
	h=Date:To:From:Subject:Message-Id; b=OSH1S18AWoK3TMCdOIzDC847UZlmjDCE81u4nLMROwsu43j60B8F7U4mxVs3FH4SyN5XPHwspolKALJVwiuJvDSEueeYYHvAJAgcFzNZFZ58yhIIZvosxhN3zsj+jcVMM6Y461g2aSR8kxWN2glvkdy0SPLrX6BE8GOPi7R5EhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aKZjOKbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aKZjOKbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8024C4CEC3;
	Tue, 15 Oct 2024 00:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728951245;
	bh=AT9Q9AAiYezNUNkEQKLlP85wMbrUJxEKmDZDImvCaNI=;
	h=Date:To:From:Subject:From;
	b=aKZjOKbNxDkz4pK5VXCLpiEDmSqBt1LOyNMiyx3cJMc3IrzKIQ4ZB9YQX6veZqL02
	 jEFUMtOTfAdiDKLYVw71Exg/hi7SgcPD+Ru7zbFKmHmP3ZlkANjMIS4aAlAaUmFPE0
	 38e3WqiYjSijQojkJ+3VvCUFZEstu2oOm6VGOg5o=
Date: Mon, 14 Oct 2024 17:14:05 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,vbabka@suse.cz,skhan@linuxfoundation.org,sfr@canb.auug.org.au,rostedt@goodmis.org,rmoar@google.com,porlando@lkcamp.dev,palmer@rivosinc.com,npitre@baylibre.com,naveen.n.rao@linux.ibm.com,nathan@kernel.org,mic@digikod.net,mhiramat@kernel.org,maskray@google.com,mark.rutland@arm.com,luis.hernandez093@gmail.com,linux@roeck-us.net,linux@rasmusvillemoes.dk,kuba@kernel.org,kees@kernel.org,Jason@zx2c4.com,horms@kernel.org,gustavoars@kernel.org,geert@linux-m68k.org,gbittencourt@lkcamp.dev,elver@google.com,dpereira@lkcamp.dev,dlatypov@google.com,diego.daniel.professional@gmail.com,dhowells@redhat.com,davidgow@google.com,davem@davemloft.net,christophe.leroy@csgroup.eu,charlie@rivosinc.com,broonie@kernel.org,brendanhiggins@google.com,arnd@arndb.de,anil.s.keshavamurthy@intel.com,andy@kernel.org,brunofrancadevsec@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-add-int_log-test-suite.patch added to mm-nonmm-unstable branch
Message-Id: <20241015001405.A8024C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/math: add int_log test suite
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
From: Bruno Sobreira Fran=C3=A7a <brunofrancadevsec@gmail.com>
Subject: lib/math: add int_log test suite
Date: Fri, 11 Oct 2024 15:25:06 +0800

Introduce KUnit tests for the intlog2 and intlog10 functions, which
compute logarithms in base 2 and base 10, respectively.  The tests cover a
range of inputs to ensure the correctness of these functions across common
and edge cases.

[davidgow@google.com: rebased on top of mm-nonmm-unstable]
Link: https://lkml.kernel.org/r/20241011072509.3068328-4-davidgow@google.com
Signed-off-by: Bruno Sobreira Fran=C3=A7a <brunofrancadevsec@gmail.com>
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Danilo Pereira <dpereira@lkcamp.dev>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Diego Vieira <diego.daniel.professional@gmail.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Gabriela Bittencourt <gbittencourt@lkcamp.dev>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Felipe Hernandez <luis.hernandez093@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicolas Pitre <npitre@baylibre.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Pedro Orlando <porlando@lkcamp.dev>
Cc: Rae Moar <rmoar@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Simon Horman <horms@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug              |   11 ++++
 lib/math/tests/Makefile        |    1 
 lib/math/tests/int_log_kunit.c |   75 +++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

--- a/lib/Kconfig.debug~lib-math-add-int_log-test-suite
+++ a/lib/Kconfig.debug
@@ -3018,6 +3018,17 @@ config INT_POW_KUNIT_TEST
 
 	  If unsure, say N
 
+config INT_LOG_KUNIT_TEST
+        tristate "Integer log (int_log) test" if !KUNIT_ALL_TESTS
+        depends on KUNIT
+        default KUNIT_ALL_TESTS
+        help
+          This option enables the KUnit test suite for the int_log library, which
+          provides two functions to compute the integer logarithm in base 2 and
+          base 10, called respectively as intlog2 and intlog10.
+
+          If unsure, say N
+
 endif # RUNTIME_TESTING_MENU
 
 config ARCH_USE_MEMTEST
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
+	{1, 0, "Log base 10 of 1"},
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
@@ -2,5 +2,6 @@
 
 obj-$(CONFIG_DIV64_KUNIT_TEST)    += div64_kunit.o
 obj-$(CONFIG_INT_POW_KUNIT_TEST)  += int_pow_kunit.o
+obj-$(CONFIG_INT_LOG_KUNIT_TEST)  += int_log_kunit.o
 obj-$(CONFIG_MULDIV64_KUNIT_TEST) += mul_u64_u64_div_u64_kunit.o
 obj-$(CONFIG_RATIONAL_KUNIT_TEST) += rational_kunit.o
_

Patches currently in -mm which might be from brunofrancadevsec@gmail.com are

lib-math-add-int_log-test-suite.patch

