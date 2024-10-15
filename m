Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05875258
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 00:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728951304; cv=none; b=dnvgjDECNVMNELQ/RwpyzCqRR549Ir7UXTUW0HmSbmjgLAyj/+5PdDlVoSPw3XyCzqtN5Jj/69VBGRcbRmchUXVuq8B4Qc+uvveMqsLYS1isgpPBflgF17Qb89Me32LqCFJPFVZdkodz0OjXamjUs/qiWhHt4MFwow6YBJAzWn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728951304; c=relaxed/simple;
	bh=cuxuh7bKSyOExxlZwEpadfabowYS/9jJYxFvBJZ1Vtk=;
	h=Date:To:From:Subject:Message-Id; b=nSGGzjsvSgL+Kt2VPRrtK8t9E0mYnO+IYpuZTh8/c3sU9AvtzIffKOa8tPlYjeVTRz9hGDhVZ72pxtieYyKdMGsDLnXFRbx1eMr14E97UNH3QRy14F21MjrS2xba6vqRCMrwJTDmkKVMah7IF/3pnGPH/PlgN/VzVXsBdG0O7Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9Sc1eCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9Sc1eCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7CCC4CEC3;
	Tue, 15 Oct 2024 00:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728951303;
	bh=cuxuh7bKSyOExxlZwEpadfabowYS/9jJYxFvBJZ1Vtk=;
	h=Date:To:From:Subject:From;
	b=p9Sc1eCv2YVnPzb+Pgoy2OLEsxROwPZIwHfIS/GBldPp33PuJOeH7JMsF+BqRPoxR
	 R0W9e4BdZ54U9jkOkABRDmTFd+ojbmgTErEFFbw+Fx0iI2eleqroUTisNlG7xV4IXf
	 5ps2lv5/nr5jqDSPzR06m7geG+hAaXClRTXVa6MU=
Date: Mon, 14 Oct 2024 17:15:02 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,vbabka@suse.cz,skhan@linuxfoundation.org,sfr@canb.auug.org.au,rostedt@goodmis.org,rmoar@google.com,porlando@lkcamp.dev,palmer@rivosinc.com,npitre@baylibre.com,naveen.n.rao@linux.ibm.com,nathan@kernel.org,mic@digikod.net,mhiramat@kernel.org,maskray@google.com,mark.rutland@arm.com,luis.hernandez093@gmail.com,linux@roeck-us.net,linux@rasmusvillemoes.dk,kuba@kernel.org,kees@kernel.org,Jason@zx2c4.com,horms@kernel.org,gustavoars@kernel.org,geert@linux-m68k.org,elver@google.com,dpereira@lkcamp.dev,dlatypov@google.com,diego.daniel.professional@gmail.com,dhowells@redhat.com,davidgow@google.com,davem@davemloft.net,christophe.leroy@csgroup.eu,charlie@rivosinc.com,brunofrancadevsec@gmail.com,broonie@kernel.org,brendanhiggins@google.com,arnd@arndb.de,anil.s.keshavamurthy@intel.com,andy@kernel.org,gbittencourt@lkcamp.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + unicode-kunit-change-tests-filename-and-path.patch added to mm-nonmm-unstable branch
Message-Id: <20241015001503.6D7CCC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: unicode: kunit: change tests filename and path
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     unicode-kunit-change-tests-filename-and-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/unicode-kunit-change-tests-filename-and-path.patch

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
Subject: unicode: kunit: change tests filename and path
Date: Fri, 11 Oct 2024 15:25:10 +0800

Change utf8 kunit test filename and path to follow the style convention on
Documentation/dev-tools/kunit/style.rst

[davidgow@google.com: rebased, fixed module build (Gabriel Krisman Bertazi)]
Link: https://lkml.kernel.org/r/20241011072509.3068328-8-davidgow@google.com
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

 fs/unicode/.kunitconfig       |    3 
 fs/unicode/Makefile           |    2 
 fs/unicode/tests/.kunitconfig |    3 
 fs/unicode/tests/utf8_kunit.c |  300 ++++++++++++++++++++++++++++++++
 fs/unicode/utf8-selftest.c    |  300 --------------------------------
 5 files changed, 304 insertions(+), 304 deletions(-)

diff --git a/fs/unicode/.kunitconfig a/fs/unicode/.kunitconfig
deleted file mode 100644
--- a/fs/unicode/.kunitconfig
+++ /dev/null
@@ -1,3 +0,0 @@
-CONFIG_KUNIT=y
-CONFIG_UNICODE=y
-CONFIG_UNICODE_NORMALIZATION_KUNIT_TEST=y
--- a/fs/unicode/Makefile~unicode-kunit-change-tests-filename-and-path
+++ a/fs/unicode/Makefile
@@ -4,7 +4,7 @@ ifneq ($(CONFIG_UNICODE),)
 obj-y			+= unicode.o
 endif
 obj-$(CONFIG_UNICODE)	+= utf8data.o
-obj-$(CONFIG_UNICODE_NORMALIZATION_KUNIT_TEST) += utf8-selftest.o
+obj-$(CONFIG_UNICODE_NORMALIZATION_KUNIT_TEST) += tests/utf8_kunit.o
 
 unicode-y := utf8-norm.o utf8-core.o
 
diff --git a/fs/unicode/tests/.kunitconfig a/fs/unicode/tests/.kunitconfig
new file mode 100644
--- /dev/null
+++ a/fs/unicode/tests/.kunitconfig
@@ -0,0 +1,3 @@
+CONFIG_KUNIT=y
+CONFIG_UNICODE=y
+CONFIG_UNICODE_NORMALIZATION_KUNIT_TEST=y
diff --git a/fs/unicode/tests/utf8_kunit.c a/fs/unicode/tests/utf8_kunit.c
new file mode 100664
--- /dev/null
+++ a/fs/unicode/tests/utf8_kunit.c
@@ -0,0 +1,300 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for utf-8 support.
+ *
+ * Copyright 2017 Collabora Ltd.
+ */
+
+#include <linux/unicode.h>
+#include <kunit/test.h>
+
+#include "utf8n.h"
+
+/* Tests will be based on this version. */
+#define UTF8_LATEST	UNICODE_AGE(12, 1, 0)
+
+static const struct {
+	/* UTF-8 strings in this vector _must_ be NULL-terminated. */
+	unsigned char str[10];
+	unsigned char dec[10];
+} nfdi_test_data[] = {
+	/* Trivial sequence */
+	{
+		/* "ABba" decomposes to itself */
+		.str = "aBba",
+		.dec = "aBba",
+	},
+	/* Simple equivalent sequences */
+	{
+               /* 'VULGAR FRACTION ONE QUARTER' cannot decompose to
+                  'NUMBER 1' + 'FRACTION SLASH' + 'NUMBER 4' on
+                  canonical decomposition */
+               .str = {0xc2, 0xbc, 0x00},
+	       .dec = {0xc2, 0xbc, 0x00},
+	},
+	{
+		/* 'LATIN SMALL LETTER A WITH DIAERESIS' decomposes to
+		   'LETTER A' + 'COMBINING DIAERESIS' */
+		.str = {0xc3, 0xa4, 0x00},
+		.dec = {0x61, 0xcc, 0x88, 0x00},
+	},
+	{
+		/* 'LATIN SMALL LETTER LJ' can't decompose to
+		   'LETTER L' + 'LETTER J' on canonical decomposition */
+		.str = {0xC7, 0x89, 0x00},
+		.dec = {0xC7, 0x89, 0x00},
+	},
+	{
+		/* GREEK ANO TELEIA decomposes to MIDDLE DOT */
+		.str = {0xCE, 0x87, 0x00},
+		.dec = {0xC2, 0xB7, 0x00}
+	},
+	/* Canonical ordering */
+	{
+		/* A + 'COMBINING ACUTE ACCENT' + 'COMBINING OGONEK' decomposes
+		   to A + 'COMBINING OGONEK' + 'COMBINING ACUTE ACCENT' */
+		.str = {0x41, 0xcc, 0x81, 0xcc, 0xa8, 0x0},
+		.dec = {0x41, 0xcc, 0xa8, 0xcc, 0x81, 0x0},
+	},
+	{
+		/* 'LATIN SMALL LETTER A WITH DIAERESIS' + 'COMBINING OGONEK'
+		   decomposes to
+		   'LETTER A' + 'COMBINING OGONEK' + 'COMBINING DIAERESIS' */
+		.str = {0xc3, 0xa4, 0xCC, 0xA8, 0x00},
+
+		.dec = {0x61, 0xCC, 0xA8, 0xcc, 0x88, 0x00},
+	},
+
+};
+
+static const struct {
+	/* UTF-8 strings in this vector _must_ be NULL-terminated. */
+	unsigned char str[30];
+	unsigned char ncf[30];
+} nfdicf_test_data[] = {
+	/* Trivial sequences */
+	{
+		/* "ABba" folds to lowercase */
+		.str = {0x41, 0x42, 0x62, 0x61, 0x00},
+		.ncf = {0x61, 0x62, 0x62, 0x61, 0x00},
+	},
+	{
+		/* All ASCII folds to lower-case */
+		.str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0.1",
+		.ncf = "abcdefghijklmnopqrstuvwxyz0.1",
+	},
+	{
+		/* LATIN SMALL LETTER SHARP S folds to
+		   LATIN SMALL LETTER S + LATIN SMALL LETTER S */
+		.str = {0xc3, 0x9f, 0x00},
+		.ncf = {0x73, 0x73, 0x00},
+	},
+	{
+		/* LATIN CAPITAL LETTER A WITH RING ABOVE folds to
+		   LATIN SMALL LETTER A + COMBINING RING ABOVE */
+		.str = {0xC3, 0x85, 0x00},
+		.ncf = {0x61, 0xcc, 0x8a, 0x00},
+	},
+	/* Introduced by UTF-8.0.0. */
+	/* Cherokee letters are interesting test-cases because they fold
+	   to upper-case.  Before 8.0.0, Cherokee lowercase were
+	   undefined, thus, the folding from LC is not stable between
+	   7.0.0 -> 8.0.0, but it is from UC. */
+	{
+		/* CHEROKEE SMALL LETTER A folds to CHEROKEE LETTER A */
+		.str = {0xea, 0xad, 0xb0, 0x00},
+		.ncf = {0xe1, 0x8e, 0xa0, 0x00},
+	},
+	{
+		/* CHEROKEE SMALL LETTER YE folds to CHEROKEE LETTER YE */
+		.str = {0xe1, 0x8f, 0xb8, 0x00},
+		.ncf = {0xe1, 0x8f, 0xb0, 0x00},
+	},
+	{
+		/* OLD HUNGARIAN CAPITAL LETTER AMB folds to
+		   OLD HUNGARIAN SMALL LETTER AMB */
+		.str = {0xf0, 0x90, 0xb2, 0x83, 0x00},
+		.ncf = {0xf0, 0x90, 0xb3, 0x83, 0x00},
+	},
+	/* Introduced by UTF-9.0.0. */
+	{
+		/* OSAGE CAPITAL LETTER CHA folds to
+		   OSAGE SMALL LETTER CHA */
+		.str = {0xf0, 0x90, 0x92, 0xb5, 0x00},
+		.ncf = {0xf0, 0x90, 0x93, 0x9d, 0x00},
+	},
+	{
+		/* LATIN CAPITAL LETTER SMALL CAPITAL I folds to
+		   LATIN LETTER SMALL CAPITAL I */
+		.str = {0xea, 0x9e, 0xae, 0x00},
+		.ncf = {0xc9, 0xaa, 0x00},
+	},
+	/* Introduced by UTF-11.0.0. */
+	{
+		/* GEORGIAN SMALL LETTER AN folds to GEORGIAN MTAVRULI
+		   CAPITAL LETTER AN */
+		.str = {0xe1, 0xb2, 0x90, 0x00},
+		.ncf = {0xe1, 0x83, 0x90, 0x00},
+	}
+};
+
+static ssize_t utf8len(const struct unicode_map *um, enum utf8_normalization n,
+		const char *s)
+{
+	return utf8nlen(um, n, s, (size_t)-1);
+}
+
+static int utf8cursor(struct utf8cursor *u8c, const struct unicode_map *um,
+		enum utf8_normalization n, const char *s)
+{
+	return utf8ncursor(u8c, um, n, s, (unsigned int)-1);
+}
+
+static void check_utf8_nfdi(struct kunit *test)
+{
+	int i;
+	struct utf8cursor u8c;
+	struct unicode_map *um = test->priv;
+
+	for (i = 0; i < ARRAY_SIZE(nfdi_test_data); i++) {
+		int len = strlen(nfdi_test_data[i].str);
+		int nlen = strlen(nfdi_test_data[i].dec);
+		int j = 0;
+		unsigned char c;
+		int ret;
+
+		KUNIT_EXPECT_EQ(test, utf8len(um, UTF8_NFDI, nfdi_test_data[i].str), nlen);
+		KUNIT_EXPECT_EQ(test, utf8nlen(um, UTF8_NFDI, nfdi_test_data[i].str, len),
+				nlen);
+
+
+		ret = utf8cursor(&u8c, um, UTF8_NFDI, nfdi_test_data[i].str);
+		KUNIT_EXPECT_TRUE_MSG(test, ret >= 0, "Can't create cursor\n");
+
+		while ((c = utf8byte(&u8c)) > 0) {
+			KUNIT_EXPECT_EQ_MSG(test, c, nfdi_test_data[i].dec[j],
+					    "Unexpected byte 0x%x should be 0x%x\n",
+					    c, nfdi_test_data[i].dec[j]);
+			j++;
+		}
+
+		KUNIT_EXPECT_EQ(test, j, nlen);
+	}
+}
+
+static void check_utf8_nfdicf(struct kunit *test)
+{
+	int i;
+	struct utf8cursor u8c;
+	struct unicode_map *um = test->priv;
+
+	for (i = 0; i < ARRAY_SIZE(nfdicf_test_data); i++) {
+		int len = strlen(nfdicf_test_data[i].str);
+		int nlen = strlen(nfdicf_test_data[i].ncf);
+		int j = 0;
+		int ret;
+		unsigned char c;
+
+		KUNIT_EXPECT_EQ(test, utf8len(um, UTF8_NFDICF, nfdicf_test_data[i].str),
+				nlen);
+		KUNIT_EXPECT_EQ(test, utf8nlen(um, UTF8_NFDICF, nfdicf_test_data[i].str, len),
+				nlen);
+
+		ret = utf8cursor(&u8c, um, UTF8_NFDICF, nfdicf_test_data[i].str);
+		KUNIT_EXPECT_TRUE_MSG(test, ret >= 0, "Can't create cursor\n");
+
+		while ((c = utf8byte(&u8c)) > 0) {
+			KUNIT_EXPECT_EQ_MSG(test, c, nfdicf_test_data[i].ncf[j],
+					    "Unexpected byte 0x%x should be 0x%x\n",
+					    c, nfdicf_test_data[i].ncf[j]);
+			j++;
+		}
+
+		KUNIT_EXPECT_EQ(test, j, nlen);
+	}
+}
+
+static void check_utf8_comparisons(struct kunit *test)
+{
+	int i;
+	struct unicode_map *um = test->priv;
+
+	for (i = 0; i < ARRAY_SIZE(nfdi_test_data); i++) {
+		const struct qstr s1 = {.name = nfdi_test_data[i].str,
+					.len = sizeof(nfdi_test_data[i].str)};
+		const struct qstr s2 = {.name = nfdi_test_data[i].dec,
+					.len = sizeof(nfdi_test_data[i].dec)};
+
+		/* strncmp returns 0 when strings are equal */
+		KUNIT_EXPECT_TRUE_MSG(test, utf8_strncmp(um, &s1, &s2) == 0,
+				    "%s %s comparison mismatch\n", s1.name, s2.name);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(nfdicf_test_data); i++) {
+		const struct qstr s1 = {.name = nfdicf_test_data[i].str,
+					.len = sizeof(nfdicf_test_data[i].str)};
+		const struct qstr s2 = {.name = nfdicf_test_data[i].ncf,
+					.len = sizeof(nfdicf_test_data[i].ncf)};
+
+		/* strncasecmp returns 0 when strings are equal */
+		KUNIT_EXPECT_TRUE_MSG(test, utf8_strncasecmp(um, &s1, &s2) == 0,
+				    "%s %s comparison mismatch\n", s1.name, s2.name);
+	}
+}
+
+static void check_supported_versions(struct kunit *test)
+{
+	struct unicode_map *um = test->priv;
+	/* Unicode 7.0.0 should be supported. */
+	KUNIT_EXPECT_TRUE(test, utf8version_is_supported(um, UNICODE_AGE(7, 0, 0)));
+
+	/* Unicode 9.0.0 should be supported. */
+	KUNIT_EXPECT_TRUE(test, utf8version_is_supported(um, UNICODE_AGE(9, 0, 0)));
+
+	/* Unicode 1x.0.0 (the latest version) should be supported. */
+	KUNIT_EXPECT_TRUE(test, utf8version_is_supported(um, UTF8_LATEST));
+
+	/* Next versions don't exist. */
+	KUNIT_EXPECT_FALSE(test, utf8version_is_supported(um, UNICODE_AGE(13, 0, 0)));
+	KUNIT_EXPECT_FALSE(test, utf8version_is_supported(um, UNICODE_AGE(0, 0, 0)));
+	KUNIT_EXPECT_FALSE(test, utf8version_is_supported(um, UNICODE_AGE(-1, -1, -1)));
+}
+
+static struct kunit_case unicode_normalization_test_cases[] = {
+	KUNIT_CASE(check_supported_versions),
+	KUNIT_CASE(check_utf8_comparisons),
+	KUNIT_CASE(check_utf8_nfdicf),
+	KUNIT_CASE(check_utf8_nfdi),
+	{}
+};
+
+static int init_test_ucd(struct kunit *test)
+{
+	struct unicode_map *um = utf8_load(UTF8_LATEST);
+
+	test->priv = um;
+
+	KUNIT_EXPECT_EQ_MSG(test, IS_ERR(um), 0,
+			    "%s: Unable to load utf8 table.\n", __func__);
+
+	return 0;
+}
+
+static void exit_test_ucd(struct kunit *test)
+{
+	utf8_unload(test->priv);
+}
+
+static struct kunit_suite unicode_normalization_test_suite = {
+	.name = "unicode_normalization",
+	.test_cases = unicode_normalization_test_cases,
+	.init = init_test_ucd,
+	.exit = exit_test_ucd,
+};
+
+kunit_test_suite(unicode_normalization_test_suite);
+
+
+MODULE_AUTHOR("Gabriel Krisman Bertazi <krisman@collabora.co.uk>");
+MODULE_DESCRIPTION("KUnit tests for utf-8 support.");
+MODULE_LICENSE("GPL");
diff --git a/fs/unicode/utf8-selftest.c a/fs/unicode/utf8-selftest.c
deleted file mode 100644
--- a/fs/unicode/utf8-selftest.c
+++ /dev/null
@@ -1,300 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * KUnit tests for utf-8 support.
- *
- * Copyright 2017 Collabora Ltd.
- */
-
-#include <linux/unicode.h>
-#include <kunit/test.h>
-
-#include "utf8n.h"
-
-/* Tests will be based on this version. */
-#define UTF8_LATEST	UNICODE_AGE(12, 1, 0)
-
-static const struct {
-	/* UTF-8 strings in this vector _must_ be NULL-terminated. */
-	unsigned char str[10];
-	unsigned char dec[10];
-} nfdi_test_data[] = {
-	/* Trivial sequence */
-	{
-		/* "ABba" decomposes to itself */
-		.str = "aBba",
-		.dec = "aBba",
-	},
-	/* Simple equivalent sequences */
-	{
-               /* 'VULGAR FRACTION ONE QUARTER' cannot decompose to
-                  'NUMBER 1' + 'FRACTION SLASH' + 'NUMBER 4' on
-                  canonical decomposition */
-               .str = {0xc2, 0xbc, 0x00},
-	       .dec = {0xc2, 0xbc, 0x00},
-	},
-	{
-		/* 'LATIN SMALL LETTER A WITH DIAERESIS' decomposes to
-		   'LETTER A' + 'COMBINING DIAERESIS' */
-		.str = {0xc3, 0xa4, 0x00},
-		.dec = {0x61, 0xcc, 0x88, 0x00},
-	},
-	{
-		/* 'LATIN SMALL LETTER LJ' can't decompose to
-		   'LETTER L' + 'LETTER J' on canonical decomposition */
-		.str = {0xC7, 0x89, 0x00},
-		.dec = {0xC7, 0x89, 0x00},
-	},
-	{
-		/* GREEK ANO TELEIA decomposes to MIDDLE DOT */
-		.str = {0xCE, 0x87, 0x00},
-		.dec = {0xC2, 0xB7, 0x00}
-	},
-	/* Canonical ordering */
-	{
-		/* A + 'COMBINING ACUTE ACCENT' + 'COMBINING OGONEK' decomposes
-		   to A + 'COMBINING OGONEK' + 'COMBINING ACUTE ACCENT' */
-		.str = {0x41, 0xcc, 0x81, 0xcc, 0xa8, 0x0},
-		.dec = {0x41, 0xcc, 0xa8, 0xcc, 0x81, 0x0},
-	},
-	{
-		/* 'LATIN SMALL LETTER A WITH DIAERESIS' + 'COMBINING OGONEK'
-		   decomposes to
-		   'LETTER A' + 'COMBINING OGONEK' + 'COMBINING DIAERESIS' */
-		.str = {0xc3, 0xa4, 0xCC, 0xA8, 0x00},
-
-		.dec = {0x61, 0xCC, 0xA8, 0xcc, 0x88, 0x00},
-	},
-
-};
-
-static const struct {
-	/* UTF-8 strings in this vector _must_ be NULL-terminated. */
-	unsigned char str[30];
-	unsigned char ncf[30];
-} nfdicf_test_data[] = {
-	/* Trivial sequences */
-	{
-		/* "ABba" folds to lowercase */
-		.str = {0x41, 0x42, 0x62, 0x61, 0x00},
-		.ncf = {0x61, 0x62, 0x62, 0x61, 0x00},
-	},
-	{
-		/* All ASCII folds to lower-case */
-		.str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0.1",
-		.ncf = "abcdefghijklmnopqrstuvwxyz0.1",
-	},
-	{
-		/* LATIN SMALL LETTER SHARP S folds to
-		   LATIN SMALL LETTER S + LATIN SMALL LETTER S */
-		.str = {0xc3, 0x9f, 0x00},
-		.ncf = {0x73, 0x73, 0x00},
-	},
-	{
-		/* LATIN CAPITAL LETTER A WITH RING ABOVE folds to
-		   LATIN SMALL LETTER A + COMBINING RING ABOVE */
-		.str = {0xC3, 0x85, 0x00},
-		.ncf = {0x61, 0xcc, 0x8a, 0x00},
-	},
-	/* Introduced by UTF-8.0.0. */
-	/* Cherokee letters are interesting test-cases because they fold
-	   to upper-case.  Before 8.0.0, Cherokee lowercase were
-	   undefined, thus, the folding from LC is not stable between
-	   7.0.0 -> 8.0.0, but it is from UC. */
-	{
-		/* CHEROKEE SMALL LETTER A folds to CHEROKEE LETTER A */
-		.str = {0xea, 0xad, 0xb0, 0x00},
-		.ncf = {0xe1, 0x8e, 0xa0, 0x00},
-	},
-	{
-		/* CHEROKEE SMALL LETTER YE folds to CHEROKEE LETTER YE */
-		.str = {0xe1, 0x8f, 0xb8, 0x00},
-		.ncf = {0xe1, 0x8f, 0xb0, 0x00},
-	},
-	{
-		/* OLD HUNGARIAN CAPITAL LETTER AMB folds to
-		   OLD HUNGARIAN SMALL LETTER AMB */
-		.str = {0xf0, 0x90, 0xb2, 0x83, 0x00},
-		.ncf = {0xf0, 0x90, 0xb3, 0x83, 0x00},
-	},
-	/* Introduced by UTF-9.0.0. */
-	{
-		/* OSAGE CAPITAL LETTER CHA folds to
-		   OSAGE SMALL LETTER CHA */
-		.str = {0xf0, 0x90, 0x92, 0xb5, 0x00},
-		.ncf = {0xf0, 0x90, 0x93, 0x9d, 0x00},
-	},
-	{
-		/* LATIN CAPITAL LETTER SMALL CAPITAL I folds to
-		   LATIN LETTER SMALL CAPITAL I */
-		.str = {0xea, 0x9e, 0xae, 0x00},
-		.ncf = {0xc9, 0xaa, 0x00},
-	},
-	/* Introduced by UTF-11.0.0. */
-	{
-		/* GEORGIAN SMALL LETTER AN folds to GEORGIAN MTAVRULI
-		   CAPITAL LETTER AN */
-		.str = {0xe1, 0xb2, 0x90, 0x00},
-		.ncf = {0xe1, 0x83, 0x90, 0x00},
-	}
-};
-
-static ssize_t utf8len(const struct unicode_map *um, enum utf8_normalization n,
-		const char *s)
-{
-	return utf8nlen(um, n, s, (size_t)-1);
-}
-
-static int utf8cursor(struct utf8cursor *u8c, const struct unicode_map *um,
-		enum utf8_normalization n, const char *s)
-{
-	return utf8ncursor(u8c, um, n, s, (unsigned int)-1);
-}
-
-static void check_utf8_nfdi(struct kunit *test)
-{
-	int i;
-	struct utf8cursor u8c;
-	struct unicode_map *um = test->priv;
-
-	for (i = 0; i < ARRAY_SIZE(nfdi_test_data); i++) {
-		int len = strlen(nfdi_test_data[i].str);
-		int nlen = strlen(nfdi_test_data[i].dec);
-		int j = 0;
-		unsigned char c;
-		int ret;
-
-		KUNIT_EXPECT_EQ(test, utf8len(um, UTF8_NFDI, nfdi_test_data[i].str), nlen);
-		KUNIT_EXPECT_EQ(test, utf8nlen(um, UTF8_NFDI, nfdi_test_data[i].str, len),
-				nlen);
-
-
-		ret = utf8cursor(&u8c, um, UTF8_NFDI, nfdi_test_data[i].str);
-		KUNIT_EXPECT_TRUE_MSG(test, ret >= 0, "Can't create cursor\n");
-
-		while ((c = utf8byte(&u8c)) > 0) {
-			KUNIT_EXPECT_EQ_MSG(test, c, nfdi_test_data[i].dec[j],
-					    "Unexpected byte 0x%x should be 0x%x\n",
-					    c, nfdi_test_data[i].dec[j]);
-			j++;
-		}
-
-		KUNIT_EXPECT_EQ(test, j, nlen);
-	}
-}
-
-static void check_utf8_nfdicf(struct kunit *test)
-{
-	int i;
-	struct utf8cursor u8c;
-	struct unicode_map *um = test->priv;
-
-	for (i = 0; i < ARRAY_SIZE(nfdicf_test_data); i++) {
-		int len = strlen(nfdicf_test_data[i].str);
-		int nlen = strlen(nfdicf_test_data[i].ncf);
-		int j = 0;
-		int ret;
-		unsigned char c;
-
-		KUNIT_EXPECT_EQ(test, utf8len(um, UTF8_NFDICF, nfdicf_test_data[i].str),
-				nlen);
-		KUNIT_EXPECT_EQ(test, utf8nlen(um, UTF8_NFDICF, nfdicf_test_data[i].str, len),
-				nlen);
-
-		ret = utf8cursor(&u8c, um, UTF8_NFDICF, nfdicf_test_data[i].str);
-		KUNIT_EXPECT_TRUE_MSG(test, ret >= 0, "Can't create cursor\n");
-
-		while ((c = utf8byte(&u8c)) > 0) {
-			KUNIT_EXPECT_EQ_MSG(test, c, nfdicf_test_data[i].ncf[j],
-					    "Unexpected byte 0x%x should be 0x%x\n",
-					    c, nfdicf_test_data[i].ncf[j]);
-			j++;
-		}
-
-		KUNIT_EXPECT_EQ(test, j, nlen);
-	}
-}
-
-static void check_utf8_comparisons(struct kunit *test)
-{
-	int i;
-	struct unicode_map *um = test->priv;
-
-	for (i = 0; i < ARRAY_SIZE(nfdi_test_data); i++) {
-		const struct qstr s1 = {.name = nfdi_test_data[i].str,
-					.len = sizeof(nfdi_test_data[i].str)};
-		const struct qstr s2 = {.name = nfdi_test_data[i].dec,
-					.len = sizeof(nfdi_test_data[i].dec)};
-
-		/* strncmp returns 0 when strings are equal */
-		KUNIT_EXPECT_TRUE_MSG(test, utf8_strncmp(um, &s1, &s2) == 0,
-				    "%s %s comparison mismatch\n", s1.name, s2.name);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(nfdicf_test_data); i++) {
-		const struct qstr s1 = {.name = nfdicf_test_data[i].str,
-					.len = sizeof(nfdicf_test_data[i].str)};
-		const struct qstr s2 = {.name = nfdicf_test_data[i].ncf,
-					.len = sizeof(nfdicf_test_data[i].ncf)};
-
-		/* strncasecmp returns 0 when strings are equal */
-		KUNIT_EXPECT_TRUE_MSG(test, utf8_strncasecmp(um, &s1, &s2) == 0,
-				    "%s %s comparison mismatch\n", s1.name, s2.name);
-	}
-}
-
-static void check_supported_versions(struct kunit *test)
-{
-	struct unicode_map *um = test->priv;
-	/* Unicode 7.0.0 should be supported. */
-	KUNIT_EXPECT_TRUE(test, utf8version_is_supported(um, UNICODE_AGE(7, 0, 0)));
-
-	/* Unicode 9.0.0 should be supported. */
-	KUNIT_EXPECT_TRUE(test, utf8version_is_supported(um, UNICODE_AGE(9, 0, 0)));
-
-	/* Unicode 1x.0.0 (the latest version) should be supported. */
-	KUNIT_EXPECT_TRUE(test, utf8version_is_supported(um, UTF8_LATEST));
-
-	/* Next versions don't exist. */
-	KUNIT_EXPECT_FALSE(test, utf8version_is_supported(um, UNICODE_AGE(13, 0, 0)));
-	KUNIT_EXPECT_FALSE(test, utf8version_is_supported(um, UNICODE_AGE(0, 0, 0)));
-	KUNIT_EXPECT_FALSE(test, utf8version_is_supported(um, UNICODE_AGE(-1, -1, -1)));
-}
-
-static struct kunit_case unicode_normalization_test_cases[] = {
-	KUNIT_CASE(check_supported_versions),
-	KUNIT_CASE(check_utf8_comparisons),
-	KUNIT_CASE(check_utf8_nfdicf),
-	KUNIT_CASE(check_utf8_nfdi),
-	{}
-};
-
-static int init_test_ucd(struct kunit *test)
-{
-	struct unicode_map *um = utf8_load(UTF8_LATEST);
-
-	test->priv = um;
-
-	KUNIT_EXPECT_EQ_MSG(test, IS_ERR(um), 0,
-			    "%s: Unable to load utf8 table.\n", __func__);
-
-	return 0;
-}
-
-static void exit_test_ucd(struct kunit *test)
-{
-	utf8_unload(test->priv);
-}
-
-static struct kunit_suite unicode_normalization_test_suite = {
-	.name = "unicode_normalization",
-	.test_cases = unicode_normalization_test_cases,
-	.init = init_test_ucd,
-	.exit = exit_test_ucd,
-};
-
-kunit_test_suite(unicode_normalization_test_suite);
-
-
-MODULE_AUTHOR("Gabriel Krisman Bertazi <krisman@collabora.co.uk>");
-MODULE_DESCRIPTION("KUnit tests for utf-8 support.");
-MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from gbittencourt@lkcamp.dev are

unicode-kunit-refactor-selftest-to-kunit-tests.patch
unicode-kunit-change-tests-filename-and-path.patch

