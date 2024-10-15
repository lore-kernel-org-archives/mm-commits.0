Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825F44428
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 00:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728951299; cv=none; b=sFaQ5FrGNrsZodXL16P4REBCmqE1zE3YtWvOgveqkqGmVtqC76CDuzmWAJhJ9tePk+ZLBwyoH5rggoke5kG+REa0IUhA4Tolf73WD/Q5P23bgaJ/Ab1sCtJbNFrBr+Jih2BIqL8vBPhryebj/vo1PuIUamx0TKBKCazfFRfrFhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728951299; c=relaxed/simple;
	bh=PoNe7jQhOoxYqh3htpntF5VhRYdVcIymg2/VeCD2IWA=;
	h=Date:To:From:Subject:Message-Id; b=pTJP2mkA6TZkLHUggSlFOwwvSJl+rG4LD7+OhoBAhB+QaohdE6ZjpbhSpnCFZNW00b2jlG3gT4YZ2w74FmoaldRejzdEHvY+AOUxKOGS4i2E9ORANR1KNk0qP87t6GY5+Cmx11eWFJIctRQ3/cC+FVS8O8WfVZQC4oMHorAOF1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oi6vb00u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oi6vb00u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284D4C4CEC3;
	Tue, 15 Oct 2024 00:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728951299;
	bh=PoNe7jQhOoxYqh3htpntF5VhRYdVcIymg2/VeCD2IWA=;
	h=Date:To:From:Subject:From;
	b=Oi6vb00uKScZ+FmBmVFfxbClaMpDlhCIBM/bVsIUy5WbMYXJI8A5ZnIJ5OVjOar3I
	 5D9kb6+36S6xG2hql37WFa3Z/HuyTFaGKUPqYCC5BrgSrmMAdd3jFmckTj0u3JnVxf
	 8n1ghKHkKovAJtb5BGG2YH1Jk/fLC/WLj2ZGqOj0=
Date: Mon, 14 Oct 2024 17:14:58 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,vbabka@suse.cz,skhan@linuxfoundation.org,sfr@canb.auug.org.au,rostedt@goodmis.org,rmoar@google.com,porlando@lkcamp.dev,palmer@rivosinc.com,npitre@baylibre.com,naveen.n.rao@linux.ibm.com,nathan@kernel.org,mic@digikod.net,mhiramat@kernel.org,maskray@google.com,mark.rutland@arm.com,luis.hernandez093@gmail.com,linux@roeck-us.net,linux@rasmusvillemoes.dk,kuba@kernel.org,kees@kernel.org,Jason@zx2c4.com,horms@kernel.org,gustavoars@kernel.org,geert@linux-m68k.org,elver@google.com,dpereira@lkcamp.dev,dlatypov@google.com,diego.daniel.professional@gmail.com,dhowells@redhat.com,davidgow@google.com,davem@davemloft.net,christophe.leroy@csgroup.eu,charlie@rivosinc.com,brunofrancadevsec@gmail.com,broonie@kernel.org,brendanhiggins@google.com,arnd@arndb.de,anil.s.keshavamurthy@intel.com,andy@kernel.org,gbittencourt@lkcamp.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + unicode-kunit-refactor-selftest-to-kunit-tests.patch added to mm-nonmm-unstable branch
Message-Id: <20241015001459.284D4C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: unicode: kunit: refactor selftest to kunit tests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     unicode-kunit-refactor-selftest-to-kunit-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/unicode-kunit-refactor-selftest-to-kunit-tests.patch

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
From: Gabriela Bittencourt <gbittencourt@lkcamp.dev>
Subject: unicode: kunit: refactor selftest to kunit tests
Date: Fri, 11 Oct 2024 15:25:09 +0800

Refactoring 'test' functions into kunit tests, to test utf-8 support in
unicode subsystem.

This allows the utf8 tests to be run alongside the KUnit test suite
using kunit-tool, quickly compiling and running all desired tests as
part of the KUnit test suite, instead of compiling the selftest module
and loading it.

The refactoring kept the original testing logic intact, while adopting a
testing pattern across different kernel modules and leveraging KUnit's
benefits.

Link: https://lkml.kernel.org/r/20241011072509.3068328-7-davidgow@google.com
Co-developed-by: Pedro Orlando <porlando@lkcamp.dev>
Signed-off-by: Pedro Orlando <porlando@lkcamp.dev>
Co-developed-by: Danilo Pereira <dpereira@lkcamp.dev>
Signed-off-by: Danilo Pereira <dpereira@lkcamp.dev>
Signed-off-by: Gabriela Bittencourt <gbittencourt@lkcamp.dev>
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Bruno Sobreira Fran=C3=A7a <brunofrancadevsec@gmail.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Diego Vieira <diego.daniel.professional@gmail.com>
Cc: Fangrui Song <maskray@google.com>
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
Cc: Rae Moar <rmoar@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Simon Horman <horms@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unicode/.kunitconfig    |    3 
 fs/unicode/Kconfig         |    5 -
 fs/unicode/Makefile        |    2 
 fs/unicode/utf8-norm.c     |    2 
 fs/unicode/utf8-selftest.c |  151 ++++++++++++++++-------------------
 5 files changed, 78 insertions(+), 85 deletions(-)

--- a/fs/unicode/Kconfig~unicode-kunit-refactor-selftest-to-kunit-tests
+++ a/fs/unicode/Kconfig
@@ -10,6 +10,7 @@ config UNICODE
 	  be a separate loadable module that gets requested only when a file
 	  system actually use it.
 
-config UNICODE_NORMALIZATION_SELFTEST
+config UNICODE_NORMALIZATION_KUNIT_TEST
 	tristate "Test UTF-8 normalization support"
-	depends on UNICODE
+	depends on UNICODE && KUNIT
+	default KUNIT_ALL_TESTS
diff --git a/fs/unicode/.kunitconfig a/fs/unicode/.kunitconfig
new file mode 100644
--- /dev/null
+++ a/fs/unicode/.kunitconfig
@@ -0,0 +1,3 @@
+CONFIG_KUNIT=y
+CONFIG_UNICODE=y
+CONFIG_UNICODE_NORMALIZATION_KUNIT_TEST=y
--- a/fs/unicode/Makefile~unicode-kunit-refactor-selftest-to-kunit-tests
+++ a/fs/unicode/Makefile
@@ -4,7 +4,7 @@ ifneq ($(CONFIG_UNICODE),)
 obj-y			+= unicode.o
 endif
 obj-$(CONFIG_UNICODE)	+= utf8data.o
-obj-$(CONFIG_UNICODE_NORMALIZATION_SELFTEST) += utf8-selftest.o
+obj-$(CONFIG_UNICODE_NORMALIZATION_KUNIT_TEST) += utf8-selftest.o
 
 unicode-y := utf8-norm.o utf8-core.o
 
--- a/fs/unicode/utf8-norm.c~unicode-kunit-refactor-selftest-to-kunit-tests
+++ a/fs/unicode/utf8-norm.c
@@ -586,7 +586,7 @@ ccc_mismatch:
 	}
 }
 
-#ifdef CONFIG_UNICODE_NORMALIZATION_SELFTEST_MODULE
+#if IS_MODULE(CONFIG_UNICODE_NORMALIZATION_KUNIT_TEST)
 EXPORT_SYMBOL_GPL(utf8version_is_supported);
 EXPORT_SYMBOL_GPL(utf8nlen);
 EXPORT_SYMBOL_GPL(utf8ncursor);
--- a/fs/unicode/utf8-selftest.c~unicode-kunit-refactor-selftest-to-kunit-tests
+++ a/fs/unicode/utf8-selftest.c
@@ -1,38 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Kernel module for testing utf-8 support.
+ * KUnit tests for utf-8 support.
  *
  * Copyright 2017 Collabora Ltd.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/printk.h>
 #include <linux/unicode.h>
-#include <linux/dcache.h>
+#include <kunit/test.h>
 
 #include "utf8n.h"
 
-static unsigned int failed_tests;
-static unsigned int total_tests;
-
 /* Tests will be based on this version. */
 #define UTF8_LATEST	UNICODE_AGE(12, 1, 0)
 
-#define _test(cond, func, line, fmt, ...) do {				\
-		total_tests++;						\
-		if (!cond) {						\
-			failed_tests++;					\
-			pr_err("test %s:%d Failed: %s%s",		\
-			       func, line, #cond, (fmt?":":"."));	\
-			if (fmt)					\
-				pr_err(fmt, ##__VA_ARGS__);		\
-		}							\
-	} while (0)
-#define test_f(cond, fmt, ...) _test(cond, __func__, __LINE__, fmt, ##__VA_ARGS__)
-#define test(cond) _test(cond, __func__, __LINE__, "")
-
 static const struct {
 	/* UTF-8 strings in this vector _must_ be NULL-terminated. */
 	unsigned char str[10];
@@ -170,69 +150,74 @@ static int utf8cursor(struct utf8cursor
 	return utf8ncursor(u8c, um, n, s, (unsigned int)-1);
 }
 
-static void check_utf8_nfdi(struct unicode_map *um)
+static void check_utf8_nfdi(struct kunit *test)
 {
 	int i;
 	struct utf8cursor u8c;
+	struct unicode_map *um = test->priv;
 
 	for (i = 0; i < ARRAY_SIZE(nfdi_test_data); i++) {
 		int len = strlen(nfdi_test_data[i].str);
 		int nlen = strlen(nfdi_test_data[i].dec);
 		int j = 0;
 		unsigned char c;
+		int ret;
 
-		test((utf8len(um, UTF8_NFDI, nfdi_test_data[i].str) == nlen));
-		test((utf8nlen(um, UTF8_NFDI, nfdi_test_data[i].str, len) ==
-			nlen));
+		KUNIT_EXPECT_EQ(test, utf8len(um, UTF8_NFDI, nfdi_test_data[i].str), nlen);
+		KUNIT_EXPECT_EQ(test, utf8nlen(um, UTF8_NFDI, nfdi_test_data[i].str, len),
+				nlen);
 
-		if (utf8cursor(&u8c, um, UTF8_NFDI, nfdi_test_data[i].str) < 0)
-			pr_err("can't create cursor\n");
+
+		ret = utf8cursor(&u8c, um, UTF8_NFDI, nfdi_test_data[i].str);
+		KUNIT_EXPECT_TRUE_MSG(test, ret >= 0, "Can't create cursor\n");
 
 		while ((c = utf8byte(&u8c)) > 0) {
-			test_f((c == nfdi_test_data[i].dec[j]),
-			       "Unexpected byte 0x%x should be 0x%x\n",
-			       c, nfdi_test_data[i].dec[j]);
+			KUNIT_EXPECT_EQ_MSG(test, c, nfdi_test_data[i].dec[j],
+					    "Unexpected byte 0x%x should be 0x%x\n",
+					    c, nfdi_test_data[i].dec[j]);
 			j++;
 		}
 
-		test((j == nlen));
+		KUNIT_EXPECT_EQ(test, j, nlen);
 	}
 }
 
-static void check_utf8_nfdicf(struct unicode_map *um)
+static void check_utf8_nfdicf(struct kunit *test)
 {
 	int i;
 	struct utf8cursor u8c;
+	struct unicode_map *um = test->priv;
 
 	for (i = 0; i < ARRAY_SIZE(nfdicf_test_data); i++) {
 		int len = strlen(nfdicf_test_data[i].str);
 		int nlen = strlen(nfdicf_test_data[i].ncf);
 		int j = 0;
+		int ret;
 		unsigned char c;
 
-		test((utf8len(um, UTF8_NFDICF, nfdicf_test_data[i].str) ==
-				nlen));
-		test((utf8nlen(um, UTF8_NFDICF, nfdicf_test_data[i].str, len) ==
-				nlen));
-
-		if (utf8cursor(&u8c, um, UTF8_NFDICF,
-				nfdicf_test_data[i].str) < 0)
-			pr_err("can't create cursor\n");
+		KUNIT_EXPECT_EQ(test, utf8len(um, UTF8_NFDICF, nfdicf_test_data[i].str),
+				nlen);
+		KUNIT_EXPECT_EQ(test, utf8nlen(um, UTF8_NFDICF, nfdicf_test_data[i].str, len),
+				nlen);
+
+		ret = utf8cursor(&u8c, um, UTF8_NFDICF, nfdicf_test_data[i].str);
+		KUNIT_EXPECT_TRUE_MSG(test, ret >= 0, "Can't create cursor\n");
 
 		while ((c = utf8byte(&u8c)) > 0) {
-			test_f((c == nfdicf_test_data[i].ncf[j]),
-			       "Unexpected byte 0x%x should be 0x%x\n",
-			       c, nfdicf_test_data[i].ncf[j]);
+			KUNIT_EXPECT_EQ_MSG(test, c, nfdicf_test_data[i].ncf[j],
+					    "Unexpected byte 0x%x should be 0x%x\n",
+					    c, nfdicf_test_data[i].ncf[j]);
 			j++;
 		}
 
-		test((j == nlen));
+		KUNIT_EXPECT_EQ(test, j, nlen);
 	}
 }
 
-static void check_utf8_comparisons(struct unicode_map *table)
+static void check_utf8_comparisons(struct kunit *test)
 {
 	int i;
+	struct unicode_map *um = test->priv;
 
 	for (i = 0; i < ARRAY_SIZE(nfdi_test_data); i++) {
 		const struct qstr s1 = {.name = nfdi_test_data[i].str,
@@ -240,8 +225,9 @@ static void check_utf8_comparisons(struc
 		const struct qstr s2 = {.name = nfdi_test_data[i].dec,
 					.len = sizeof(nfdi_test_data[i].dec)};
 
-		test_f(!utf8_strncmp(table, &s1, &s2),
-		       "%s %s comparison mismatch\n", s1.name, s2.name);
+		/* strncmp returns 0 when strings are equal */
+		KUNIT_EXPECT_TRUE_MSG(test, utf8_strncmp(um, &s1, &s2) == 0,
+				    "%s %s comparison mismatch\n", s1.name, s2.name);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(nfdicf_test_data); i++) {
@@ -250,62 +236,65 @@ static void check_utf8_comparisons(struc
 		const struct qstr s2 = {.name = nfdicf_test_data[i].ncf,
 					.len = sizeof(nfdicf_test_data[i].ncf)};
 
-		test_f(!utf8_strncasecmp(table, &s1, &s2),
-		       "%s %s comparison mismatch\n", s1.name, s2.name);
+		/* strncasecmp returns 0 when strings are equal */
+		KUNIT_EXPECT_TRUE_MSG(test, utf8_strncasecmp(um, &s1, &s2) == 0,
+				    "%s %s comparison mismatch\n", s1.name, s2.name);
 	}
 }
 
-static void check_supported_versions(struct unicode_map *um)
+static void check_supported_versions(struct kunit *test)
 {
+	struct unicode_map *um = test->priv;
 	/* Unicode 7.0.0 should be supported. */
-	test(utf8version_is_supported(um, UNICODE_AGE(7, 0, 0)));
+	KUNIT_EXPECT_TRUE(test, utf8version_is_supported(um, UNICODE_AGE(7, 0, 0)));
 
 	/* Unicode 9.0.0 should be supported. */
-	test(utf8version_is_supported(um, UNICODE_AGE(9, 0, 0)));
+	KUNIT_EXPECT_TRUE(test, utf8version_is_supported(um, UNICODE_AGE(9, 0, 0)));
 
 	/* Unicode 1x.0.0 (the latest version) should be supported. */
-	test(utf8version_is_supported(um, UTF8_LATEST));
+	KUNIT_EXPECT_TRUE(test, utf8version_is_supported(um, UTF8_LATEST));
 
 	/* Next versions don't exist. */
-	test(!utf8version_is_supported(um, UNICODE_AGE(13, 0, 0)));
-	test(!utf8version_is_supported(um, UNICODE_AGE(0, 0, 0)));
-	test(!utf8version_is_supported(um, UNICODE_AGE(-1, -1, -1)));
+	KUNIT_EXPECT_FALSE(test, utf8version_is_supported(um, UNICODE_AGE(13, 0, 0)));
+	KUNIT_EXPECT_FALSE(test, utf8version_is_supported(um, UNICODE_AGE(0, 0, 0)));
+	KUNIT_EXPECT_FALSE(test, utf8version_is_supported(um, UNICODE_AGE(-1, -1, -1)));
 }
 
-static int __init init_test_ucd(void)
+static struct kunit_case unicode_normalization_test_cases[] = {
+	KUNIT_CASE(check_supported_versions),
+	KUNIT_CASE(check_utf8_comparisons),
+	KUNIT_CASE(check_utf8_nfdicf),
+	KUNIT_CASE(check_utf8_nfdi),
+	{}
+};
+
+static int init_test_ucd(struct kunit *test)
 {
-	struct unicode_map *um;
+	struct unicode_map *um = utf8_load(UTF8_LATEST);
 
-	failed_tests = 0;
-	total_tests = 0;
+	test->priv = um;
 
-	um = utf8_load(UTF8_LATEST);
-	if (IS_ERR(um)) {
-		pr_err("%s: Unable to load utf8 table.\n", __func__);
-		return PTR_ERR(um);
-	}
+	KUNIT_EXPECT_EQ_MSG(test, IS_ERR(um), 0,
+			    "%s: Unable to load utf8 table.\n", __func__);
 
-	check_supported_versions(um);
-	check_utf8_nfdi(um);
-	check_utf8_nfdicf(um);
-	check_utf8_comparisons(um);
-
-	if (!failed_tests)
-		pr_info("All %u tests passed\n", total_tests);
-	else
-		pr_err("%u out of %u tests failed\n", failed_tests,
-		       total_tests);
-	utf8_unload(um);
 	return 0;
 }
 
-static void __exit exit_test_ucd(void)
+static void exit_test_ucd(struct kunit *test)
 {
+	utf8_unload(test->priv);
 }
 
-module_init(init_test_ucd);
-module_exit(exit_test_ucd);
+static struct kunit_suite unicode_normalization_test_suite = {
+	.name = "unicode_normalization",
+	.test_cases = unicode_normalization_test_cases,
+	.init = init_test_ucd,
+	.exit = exit_test_ucd,
+};
+
+kunit_test_suite(unicode_normalization_test_suite);
+
 
 MODULE_AUTHOR("Gabriel Krisman Bertazi <krisman@collabora.co.uk>");
-MODULE_DESCRIPTION("Kernel module for testing utf-8 support");
+MODULE_DESCRIPTION("KUnit tests for utf-8 support.");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from gbittencourt@lkcamp.dev are

unicode-kunit-refactor-selftest-to-kunit-tests.patch
unicode-kunit-change-tests-filename-and-path.patch

