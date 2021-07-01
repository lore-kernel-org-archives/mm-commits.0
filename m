Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B666C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4612061468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhGAB6X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238467AbhGAB6W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ECDD61420;
        Thu,  1 Jul 2021 01:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104553;
        bh=EXoz6J7Eyrsot+KAX1cnNMNIcpXWBdH51aKfbMCnwhE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pSd7bIJNBY9K+5mSV1f1i+L6mQea+h64NaJesE4gIW8gdLqjSo6PVBKXAtvYmI6zO
         u8QI3ynh5uF/e9PJPc9rIlWOuQ6AZt5illuyvYD7MvltPOi1Pqvvkdw5Dmaxu97Esj
         WhDpW+0ukC7JOHSHKowpg6PrHaavaHeeWRjUnGxU=
Date:   Wed, 30 Jun 2021 18:55:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        colin.king@canonical.com, dlatypov@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oskar@scara.com,
        torvalds@linux-foundation.org, tpiepho@gmail.com, yguoaz@gmail.com
Subject:  [patch 164/192] lib/math/rational: add Kunit test cases
Message-ID: <20210701015552.rpE3gozWu%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Trent Piepho <tpiepho@gmail.com>
Subject: lib/math/rational: add Kunit test cases

Adds a number of test cases that cover a range of possible code paths.

[akpm@linux-foundation.org: remove non-ascii characters, fix whitespace]
[colin.king@canonical.com: fix spelling mistake "demominator" -> "denominator"]
  Link: https://lkml.kernel.org/r/20210526085049.6393-1-colin.king@canonical.com
Link: https://lkml.kernel.org/r/20210525144250.214670-2-tpiepho@gmail.com
Signed-off-by: Trent Piepho <tpiepho@gmail.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Oskar Schirmer <oskar@scara.com>
Cc: Yiyuan Guo <yguoaz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug        |   12 +++++++
 lib/math/Makefile        |    1 
 lib/math/rational-test.c |   56 +++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)

--- a/lib/Kconfig.debug~lib-math-rational-add-kunit-test-cases
+++ a/lib/Kconfig.debug
@@ -2444,6 +2444,18 @@ config SLUB_KUNIT_TEST
 
 	  If unsure, say N.
 
+config RATIONAL_KUNIT_TEST
+	tristate "KUnit test for rational.c" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	select RATIONAL
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the rational math unit test.
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config TEST_UDELAY
 	tristate "udelay test driver"
 	help
--- a/lib/math/Makefile~lib-math-rational-add-kunit-test-cases
+++ a/lib/math/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_PRIME_NUMBERS)	+= prime_num
 obj-$(CONFIG_RATIONAL)		+= rational.o
 
 obj-$(CONFIG_TEST_DIV64)	+= test_div64.o
+obj-$(CONFIG_RATIONAL_KUNIT_TEST) += rational-test.o
--- /dev/null
+++ a/lib/math/rational-test.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <kunit/test.h>
+
+#include <linux/rational.h>
+
+struct rational_test_param {
+	unsigned long num, den;
+	unsigned long max_num, max_den;
+	unsigned long exp_num, exp_den;
+
+	const char *name;
+};
+
+static const struct rational_test_param test_parameters[] = {
+	{ 1230,	10,	100, 20,	100, 1,    "Exceeds bounds, semi-convergent term > 1/2 last term" },
+	{ 34567,100, 	120, 20,	120, 1,    "Exceeds bounds, semi-convergent term < 1/2 last term" },
+	{ 1, 30,	100, 10,	0, 1,	   "Closest to zero" },
+	{ 1, 19,	100, 10,	1, 10,     "Closest to smallest non-zero" },
+	{ 27,32,	16, 16,		11, 13,    "Use convergent" },
+	{ 1155, 7735,	255, 255,	33, 221,   "Exact answer" },
+	{ 87, 32,	70, 32,		68, 25,    "Semiconvergent, numerator limit" },
+	{ 14533, 4626,	15000, 2400,	7433, 2366, "Semiconvergent, denominator limit" },
+};
+
+static void get_desc(const struct rational_test_param *param, char *desc)
+{
+	strscpy(desc, param->name, KUNIT_PARAM_DESC_SIZE);
+}
+
+/* Creates function rational_gen_params */
+KUNIT_ARRAY_PARAM(rational, test_parameters, get_desc);
+
+static void rational_test(struct kunit *test)
+{
+	const struct rational_test_param *param = (const struct rational_test_param *)test->param_value;
+	unsigned long n = 0, d = 0;
+
+	rational_best_approximation(param->num, param->den, param->max_num, param->max_den, &n, &d);
+	KUNIT_EXPECT_EQ(test, n, param->exp_num);
+	KUNIT_EXPECT_EQ(test, d, param->exp_den);
+}
+
+static struct kunit_case rational_test_cases[] = {
+	KUNIT_CASE_PARAM(rational_test, rational_gen_params),
+	{}
+};
+
+static struct kunit_suite rational_test_suite = {
+	.name = "rational",
+	.test_cases = rational_test_cases,
+};
+
+kunit_test_suites(&rational_test_suite);
+
+MODULE_LICENSE("GPL v2");
_
