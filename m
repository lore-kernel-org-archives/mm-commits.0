Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBADC2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 19:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B0F62222F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 19:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vtx7neTs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgKLTca (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 14:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbgKLTca (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 14:32:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC1722244;
        Thu, 12 Nov 2020 19:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605209549;
        bh=JxYiKuEX5JzfkQDbyrVjdjzzLUyCS4KtPWEXxRoNgvw=;
        h=Date:From:To:Subject:From;
        b=vtx7neTsZW++jOdiQIPA8eQRT7ERU2QYfKfZSNSpuwzFRdpXcDOriaRMx/7NR1Im+
         WmG2UBY0ZWsEcGtySk8D4HbuEwjbQZs4gIjhW5KD7qMi/Vg8mvGiAap8WZjKMtoHj3
         X8KI3SN5Lf0/Xg278cbgeNMI50s7NZLFiBfZYoM0=
Date:   Thu, 12 Nov 2020 11:32:28 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, brendanhiggins@google.com,
        broonie@kernel.org, davidgow@google.com,
        matti.vaittinen@fi.rohmeurope.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, vitor@massaru.org
Subject:  +
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch added to -mm
 tree
Message-ID: <20201112193228.d11UJ_45N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline_kunit: add a new test suite for cmdline API
has been added to the -mm tree.  Its filename is
     lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/cmdline_kunit: add a new test suite for cmdline API

Test get_option() for a starter which is provided by cmdline.c.

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
 lib/cmdline_kunit.c |   98 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 110 insertions(+)

--- /dev/null
+++ a/lib/cmdline_kunit.c
@@ -0,0 +1,98 @@
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
+static const char *cmdline_test_values[] = {
+	1, 1, 1, 1, 2, 3, 2, 3,
+	1, 3, 2, 1, 1, 1, 3, 1,
+};
+
+static void cmdline_do_one_test(struct kunit *test, char *in, int rc, int offset)
+{
+	const char *fmt = "Pattern: %s";
+	char *out = in;
+	int dummy;
+	int ret;
+
+	ret = get_option(&out, &dummy);
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
--- a/lib/Kconfig.debug~lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api
+++ a/lib/Kconfig.debug
@@ -2276,6 +2276,17 @@ config LINEAR_RANGES_TEST
 
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
@@ -350,5 +350,6 @@ obj-$(CONFIG_PLDMFW) += pldmfw/
 # KUnit tests
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
 obj-$(CONFIG_BITS_TEST) += bits_kunit.o
+obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += linear_ranges_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list_kunit.o
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-mathematical-helpers.patch
bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch
lib-list_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-linear_ranges_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-bits_kunit-follow-new-file-name-convention-for-kunit-tests.patch
lib-cmdline-fix-get_option-for-strings-starting-with-hyphen.patch
lib-cmdline-allow-null-to-be-an-output-for-get_option.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch

