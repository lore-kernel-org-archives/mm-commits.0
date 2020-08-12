Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFADC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D5C4206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196106;
	bh=gBkIBpapT5m05uHUR/XGA9w70CX34vooRh9E6R7j9+c=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QtoD57Q24ryu9V504BbYrEOiqx56my5ct5XZHq4UsEjIgsfT2PVteMtoellLqLxll
	 W0MM0/I5oTmdi91RmGNmR2pDWCqg56j5L/jIi5wHM+2vLVUnqKvBcEdfs5fKMOohXL
	 rH3KOlVxWKxhOUMc5PBFtdIG8A/nOPugBndFe3XU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgHLBfG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgHLBfG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46ABD207DA;
        Wed, 12 Aug 2020 01:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196104;
        bh=gBkIBpapT5m05uHUR/XGA9w70CX34vooRh9E6R7j9+c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GnXwLQErRiJCY0ao7y1EC1KpTc+Xej1rxrE7NIdBazaljZUERt2RUo2RhTvLEAU6G
         BBKDjv+m0phhMLJEnHQDYFrL1rs9tJjGwNnueVrz93/7B8VYE/gTXOzTFPAB/2fJip
         Hfx+C5EoivdRgmEmtDlDt0nuAZinAmOdjF5EAo/s=
Date:   Tue, 11 Aug 2020 18:35:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andy.shevchenko@gmail.com,
        arnd@arndb.de, emil.l.velikov@gmail.com, geert@linux-m68k.org,
        keescook@chromium.org, linus.walleij@linaro.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rd.dunlap@gmail.com, rikard.falkeborn@gmail.com,
        syednwaris@gmail.com, torvalds@linux-foundation.org,
        vilhelm.gray@gmail.com, weiyongjun1@huawei.com,
        yamada.masahiro@socionext.com
Subject:  [patch 091/165] lib/test_bits.c: add tests of GENMASK
Message-ID: <20200812013503.D4sgoLZOW%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: lib/test_bits.c: add tests of GENMASK

Add tests of GENMASK and GENMASK_ULL.

A few test cases that should fail compilation are provided under #ifdef
TEST_GENMASK_FAILURES

[rd.dunlap@gmail.com: add MODULE_LICENSE()]
  Link: http://lkml.kernel.org/r/dfc74524-0789-2827-4eff-476ddab65699@gmail.com
[weiyongjun1@huawei.com: make some functions static]
  Link: http://lkml.kernel.org/r/20200702150336.4756-1-weiyongjun1@huawei.com
Link: http://lkml.kernel.org/r/20200621054210.14804-2-rikard.falkeborn@gmail.com
Link: http://lkml.kernel.org/r/20200608221823.35799-2-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Randy Dunlap <rd.dunlap@gmail.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Syed Nayyar Waris <syednwaris@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   11 ++++++
 lib/Makefile      |    1 
 lib/test_bits.c   |   75 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

--- a/lib/Kconfig.debug~bits-add-tests-of-genmask
+++ a/lib/Kconfig.debug
@@ -2236,6 +2236,17 @@ config LINEAR_RANGES_TEST
 
 	  If unsure, say N.
 
+config BITS_TEST
+	tristate "KUnit test for bits.h"
+	depends on KUNIT
+	help
+	  This builds the bits unit test.
+	  Tests the logic of macros defined in bits.h.
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config TEST_UDELAY
 	tristate "udelay test driver"
 	help
--- a/lib/Makefile~bits-add-tests-of-genmask
+++ a/lib/Makefile
@@ -342,3 +342,4 @@ obj-$(CONFIG_PLDMFW) += pldmfw/
 # KUnit tests
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
+obj-$(CONFIG_BITS_TEST) += test_bits.o
--- /dev/null
+++ a/lib/test_bits.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Test cases for functions and macros in bits.h
+ */
+
+#include <kunit/test.h>
+#include <linux/bits.h>
+
+
+static void genmask_test(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, 1ul, GENMASK(0, 0));
+	KUNIT_EXPECT_EQ(test, 3ul, GENMASK(1, 0));
+	KUNIT_EXPECT_EQ(test, 6ul, GENMASK(2, 1));
+	KUNIT_EXPECT_EQ(test, 0xFFFFFFFFul, GENMASK(31, 0));
+
+#ifdef TEST_GENMASK_FAILURES
+	/* these should fail compilation */
+	GENMASK(0, 1);
+	GENMASK(0, 10);
+	GENMASK(9, 10);
+#endif
+
+
+}
+
+static void genmask_ull_test(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, 1ull, GENMASK_ULL(0, 0));
+	KUNIT_EXPECT_EQ(test, 3ull, GENMASK_ULL(1, 0));
+	KUNIT_EXPECT_EQ(test, 0x000000ffffe00000ull, GENMASK_ULL(39, 21));
+	KUNIT_EXPECT_EQ(test, 0xffffffffffffffffull, GENMASK_ULL(63, 0));
+
+#ifdef TEST_GENMASK_FAILURES
+	/* these should fail compilation */
+	GENMASK_ULL(0, 1);
+	GENMASK_ULL(0, 10);
+	GENMASK_ULL(9, 10);
+#endif
+}
+
+static void genmask_input_check_test(struct kunit *test)
+{
+	unsigned int x, y;
+	int z, w;
+
+	/* Unknown input */
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(x, 0));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(0, x));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(x, y));
+
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(z, 0));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(0, z));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(z, w));
+
+	/* Valid input */
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(1, 1));
+	KUNIT_EXPECT_EQ(test, 0, GENMASK_INPUT_CHECK(39, 21));
+}
+
+
+static struct kunit_case bits_test_cases[] = {
+	KUNIT_CASE(genmask_test),
+	KUNIT_CASE(genmask_ull_test),
+	KUNIT_CASE(genmask_input_check_test),
+	{}
+};
+
+static struct kunit_suite bits_test_suite = {
+	.name = "bits-test",
+	.test_cases = bits_test_cases,
+};
+kunit_test_suite(bits_test_suite);
+
+MODULE_LICENSE("GPL");
_
