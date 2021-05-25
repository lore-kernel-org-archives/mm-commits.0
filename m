Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FEAC47086
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 21:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C60EB613B6
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 21:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhEYVnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 17:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhEYVne (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 17:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD5DC613C1;
        Tue, 25 May 2021 21:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621978924;
        bh=TymfE/LlT4wrYEULa/sz5U5xY6kPFeUL4Qy0KNJ01vg=;
        h=Date:From:To:Subject:From;
        b=zHY/K/snenVihusEwN/Bu8UoUM5NzPDzRuuUXKwSL4svOy2kHIUQo4gjBWSZh8gAN
         c6Zd/tgK16IoveSHNXW0fAsaFiAW6E6w52sCIUc84r89Y9zKQOv43m2BzCfE4ajdyl
         uhDKDalB3viZe2pgstkzgKPwaWCbGh0pAPv4JsNk=
Date:   Tue, 25 May 2021 14:42:03 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, dlatypov@google.com,
        mm-commits@vger.kernel.org, oskar@scara.com, tpiepho@gmail.com,
        yguoaz@gmail.com
Subject:  + lib-math-rational-add-kunit-test-cases.patch added to
 -mm tree
Message-ID: <20210525214203.AsXdX9nOm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/math/rational: add Kunit test cases
has been added to the -mm tree.  Its filename is
     lib-math-rational-add-kunit-test-cases.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-math-rational-add-kunit-t=
est-cases.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-math-rational-add-kunit-t=
est-cases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Trent Piepho <tpiepho@gmail.com>
Subject: lib/math/rational: add Kunit test cases

Adds a number of test cases that cover a range of possible code paths.

Link: https://lkml.kernel.org/r/20210525144250.214670-2-tpiepho@gmail.com
Signed-off-by: Trent Piepho <tpiepho@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Oskar Schirmer <oskar@scara.com>
Cc: Yiyuan Guo <yguoaz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug        |   12 +++++++
 lib/math/Makefile        |    1=20
 lib/math/rational-test.c |   56 +++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)

--- a/lib/Kconfig.debug~lib-math-rational-add-kunit-test-cases
+++ a/lib/Kconfig.debug
@@ -2447,6 +2447,18 @@ config SLUB_KUNIT_TEST
=20
 	  If unsure, say N.
=20
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
@@ -6,3 +6,4 @@ obj-$(CONFIG_PRIME_NUMBERS)	+=3D prime_num
 obj-$(CONFIG_RATIONAL)		+=3D rational.o
=20
 obj-$(CONFIG_TEST_DIV64)	+=3D test_div64.o
+obj-$(CONFIG_RATIONAL_KUNIT_TEST) +=3D rational-test.o
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
+static const struct rational_test_param test_parameters[] =3D {
+	{ 1230,	10,	100, 20,	100, 1,    "Exceeds bounds, semi-convergent term > =
=C2=BD last term" },
+	{ 34567,100, 	120, 20,	120, 1,    "Exceeds bounds, semi-convergent term <=
 =C2=BD last term" },
+	{ 1, 30,	100, 10,	0, 1,	   "Closest to zero" },
+	{ 1, 19,	100, 10,	1, 10,     "Closest to smallest non-zero" },
+	{ 27,32,	16, 16,		11, 13,    "Use convergent" },
+	{ 1155, 7735,	255, 255,	33, 221,   "Exact answer" },
+	{ 87, 32,	70, 32,		68, 25,    "Semiconvergent, numerator limit" },
+	{ 14533, 4626,	15000, 2400,	7433, 2366, "Semiconvergent, demominator limi=
t" },
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
+	const struct rational_test_param *param =3D (const struct rational_test_p=
aram *)test->param_value;
+	unsigned long n =3D 0, d =3D 0;
+
+	rational_best_approximation(param->num, param->den, param->max_num, param=
->max_den, &n, &d);
+	KUNIT_EXPECT_EQ(test, n, param->exp_num);
+	KUNIT_EXPECT_EQ(test, d, param->exp_den);
+}
+
+static struct kunit_case rational_test_cases[] =3D {
+       KUNIT_CASE_PARAM(rational_test, rational_gen_params),
+       {}
+};
+
+static struct kunit_suite rational_test_suite =3D {
+       .name =3D "rational",
+       .test_cases =3D rational_test_cases,
+};
+
+kunit_test_suites(&rational_test_suite);
+
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from tpiepho@gmail.com are

lib-math-rationalc-fix-divide-by-zero.patch
lib-math-rational-add-kunit-test-cases.patch

