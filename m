Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77430C2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3527A230FA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgLPRKQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbgLPRKP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:15 -0500
Date:   Wed, 16 Dec 2020 09:09:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138552;
        bh=tSDOPP9uymazLYcPqovbLdBNyXY66uQpysz4oz96EEc=;
        h=From:To:Subject:From;
        b=TtrFfI7JSsWDz0tixQRi35HXG8rua/cdfgp6ZyF77MmAah/06Qa5UvrObKovcxKnY
         iIBRRtxRdnsDd/osYUTAR/feIkQ92XpPcPBiI8Zz5o8HClvOVmlPk4w/gt93gWPGwS
         ulSU4OFVPj9R77wheNXy1w5iGEvjU0d3yVVpIxks=
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, brendanhiggins@google.com,
        broonie@kernel.org, davidgow@google.com,
        matti.vaittinen@fi.rohmeurope.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, vitor@massaru.org
Subject:  [merged]
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch removed from
 -mm tree
Message-ID: <20201216170912.9JW6JzXoA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline_kunit: add a new test suite for cmdline API
has been removed from the -mm tree.  Its filename was
     lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/cmdline_kunit: add a new test suite for cmdline API

Test get_option() for a starter which is provided by cmdline.c.

[akpm@linux-foundation.org: fix warning by constifying cmdline_test_values]
[andriy.shevchenko@linux.intel.com: type of expected returned values should be int]
  Link: https://lkml.kernel.org/r/20201116104244.15472-1-andriy.shevchenko@linux.intel.com
[andriy.shevchenko@linux.intel.com: provide meaningful MODULE_LICENSE()]
  Link: https://lkml.kernel.org/r/20201116104257.15527-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20201112180732.75589-6-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug   |   11 ++++
 lib/Makefile        |    1 
 lib/cmdline_kunit.c |  100 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+)

--- /dev/null
+++ a/lib/cmdline_kunit.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Test cases for API provided by cmdline.c
+ */
+
+#include <kunit/test.h>
+#include <linux/kernel.h>
+#include <linux/random.h>
+#include <linux/string.h>
+
+static const char *cmdline_test_strings[] = {
+	"\"\"", ""  , "=" , "\"-", ","    , "-,"   , ",-"   , "-" ,
+	"+,"  , "--", ",,", "''" , "\"\",", "\",\"", "-\"\"", "\"",
+};
+
+static const int cmdline_test_values[] = {
+	1, 1, 1, 1, 2, 3, 2, 3,
+	1, 3, 2, 1, 1, 1, 3, 1,
+};
+
+static void cmdline_do_one_test(struct kunit *test, const char *in, int rc, int offset)
+{
+	const char *fmt = "Pattern: %s";
+	const char *out = in;
+	int dummy;
+	int ret;
+
+	ret = get_option((char **)&out, &dummy);
+
+	KUNIT_EXPECT_EQ_MSG(test, ret, rc, fmt, in);
+	KUNIT_EXPECT_PTR_EQ_MSG(test, out, in + offset, fmt, in);
+}
+
+static void cmdline_test_noint(struct kunit *test)
+{
+	unsigned int i = 0;
+
+	do {
+		const char *str = cmdline_test_strings[i];
+		int rc = 0;
+		int offset;
+
+		/* Only first and leading '-' will advance the pointer */
+		offset = !!(*str == '-');
+		cmdline_do_one_test(test, str, rc, offset);
+	} while (++i < ARRAY_SIZE(cmdline_test_strings));
+}
+
+static void cmdline_test_lead_int(struct kunit *test)
+{
+	unsigned int i = 0;
+	char in[32];
+
+	do {
+		const char *str = cmdline_test_strings[i];
+		int rc = cmdline_test_values[i];
+		int offset;
+
+		sprintf(in, "%u%s", get_random_int() % 256, str);
+		/* Only first '-' after the number will advance the pointer */
+		offset = strlen(in) - strlen(str) + !!(rc == 2);
+		cmdline_do_one_test(test, in, rc, offset);
+	} while (++i < ARRAY_SIZE(cmdline_test_strings));
+}
+
+static void cmdline_test_tail_int(struct kunit *test)
+{
+	unsigned int i = 0;
+	char in[32];
+
+	do {
+		const char *str = cmdline_test_strings[i];
+		/* When "" or "-" the result will be valid integer */
+		int rc = strcmp(str, "") ? (strcmp(str, "-") ? 0 : 1) : 1;
+		int offset;
+
+		sprintf(in, "%s%u", str, get_random_int() % 256);
+		/*
+		 * Only first and leading '-' not followed by integer
+		 * will advance the pointer.
+		 */
+		offset = rc ? strlen(in) : !!(*str == '-');
+		cmdline_do_one_test(test, in, rc, offset);
+	} while (++i < ARRAY_SIZE(cmdline_test_strings));
+}
+
+static struct kunit_case cmdline_test_cases[] = {
+	KUNIT_CASE(cmdline_test_noint),
+	KUNIT_CASE(cmdline_test_lead_int),
+	KUNIT_CASE(cmdline_test_tail_int),
+	{}
+};
+
+static struct kunit_suite cmdline_test_suite = {
+	.name = "cmdline",
+	.test_cases = cmdline_test_cases,
+};
+kunit_test_suite(cmdline_test_suite);
+
+MODULE_LICENSE("GPL");
--- a/lib/Kconfig.debug~lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api
+++ a/lib/Kconfig.debug
@@ -2311,6 +2311,17 @@ config LINEAR_RANGES_TEST
 
 	  If unsure, say N.
 
+config CMDLINE_KUNIT_TEST
+	tristate "KUnit test for cmdline API"
+	depends on KUNIT
+	help
+	  This builds the cmdline API unit test.
+	  Tests the logic of API provided by cmdline.c.
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config BITS_TEST
 	tristate "KUnit test for bits.h"
 	depends on KUNIT
--- a/lib/Makefile~lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api
+++ a/lib/Makefile
@@ -351,5 +351,6 @@ obj-$(CONFIG_PLDMFW) += pldmfw/
 # KUnit tests
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
 obj-$(CONFIG_BITS_TEST) += bits_kunit.o
+obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += linear_ranges_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list_kunit.o
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


