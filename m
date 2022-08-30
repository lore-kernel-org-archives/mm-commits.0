Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE17ECAAD4
	for <mm-commits@archiver.kernel.org>; Tue, 30 Aug 2022 21:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiH3Vt1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 17:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiH3VtZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 17:49:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374208E4D6
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 14:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C686A618B3
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 21:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20478C433C1;
        Tue, 30 Aug 2022 21:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661896163;
        bh=OZ+VL5/moulBm2OhZxurlFf/cRP8We3JwLooHE9cUdw=;
        h=Date:To:From:Subject:From;
        b=PyjFBP3nJi+0MqCDIjkalL4JHWwMM4gh9hDtlFWQCiH2LcnjU/mwg/nT+n3oDKhYa
         FxPJjZQ0kj/o4giSzqwqo6AbkKUS/tWOgE8ZGO8MUzeiU+rTxFalbe/jrvrB8qWwYE
         NE7vYcuVeuZQ6aBdsobezalPwkqm9rGefcnWFufk=
Date:   Tue, 30 Aug 2022 14:49:22 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com, vbabka@suse.cz,
        sander@svanheule.net, rostedt@goodmis.org, peterz@infradead.org,
        nathan@kernel.org, mingo@redhat.com, mhiramat@kernel.org,
        luc.vanoostenryck@gmail.com, linux@rasmusvillemoes.dk,
        keescook@chromium.org, jpoimboe@kernel.org, Jason@zx2c4.com,
        isabbasso@riseup.net, edumazet@google.com,
        dan.j.williams@intel.com, arnd@arndb.de, bvanassche@acm.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] testing-selftests-add-tests-for-the-is_signed_type-macro.patch removed from -mm tree
Message-Id: <20220830214923.20478C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: testing/selftests: add tests for the is_signed_type() macro
has been removed from the -mm tree.  Its filename was
     testing-selftests-add-tests-for-the-is_signed_type-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: testing/selftests: add tests for the is_signed_type() macro
Date: Fri, 26 Aug 2022 09:21:15 -0700

Although not documented, is_signed_type() must support the 'bool' and
pointer types next to scalar and enumeration types.  Add a selftest that
verifies that this macro handles all supported types correctly.

Link: https://lkml.kernel.org/r/20220826162116.1050972-2-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sander Vanheule <sander@svanheule.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug         |   12 +++++++++
 lib/Makefile              |    1 
 lib/is_signed_type_test.c |   48 ++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

--- /dev/null
+++ a/lib/is_signed_type_test.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ *	./tools/testing/kunit/kunit.py run is_signed_type [--raw_output]
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <kunit/test.h>
+#include <linux/overflow.h>
+
+enum unsigned_enum {
+	constant_a = 3,
+};
+
+enum signed_enum {
+	constant_b = -1,
+	constant_c = 2,
+};
+
+static void is_signed_type_test(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, is_signed_type(bool), false);
+	KUNIT_EXPECT_EQ(test, is_signed_type(signed char), true);
+	KUNIT_EXPECT_EQ(test, is_signed_type(unsigned char), false);
+	KUNIT_EXPECT_EQ(test, is_signed_type(int), true);
+	KUNIT_EXPECT_EQ(test, is_signed_type(unsigned int), false);
+	KUNIT_EXPECT_EQ(test, is_signed_type(long), true);
+	KUNIT_EXPECT_EQ(test, is_signed_type(unsigned long), false);
+	KUNIT_EXPECT_EQ(test, is_signed_type(long long), true);
+	KUNIT_EXPECT_EQ(test, is_signed_type(unsigned long long), false);
+	KUNIT_EXPECT_EQ(test, is_signed_type(enum unsigned_enum), false);
+	KUNIT_EXPECT_EQ(test, is_signed_type(enum signed_enum), true);
+	KUNIT_EXPECT_EQ(test, is_signed_type(void *), false);
+	KUNIT_EXPECT_EQ(test, is_signed_type(const char *), false);
+}
+
+static struct kunit_case is_signed_type_test_cases[] = {
+	KUNIT_CASE(is_signed_type_test),
+	{}
+};
+
+static struct kunit_suite is_signed_type_test_suite = {
+	.name = "is_signed_type",
+	.test_cases = is_signed_type_test_cases,
+};
+
+kunit_test_suite(is_signed_type_test_suite);
+
+MODULE_LICENSE("Dual MIT/GPL");
--- a/lib/Kconfig.debug~testing-selftests-add-tests-for-the-is_signed_type-macro
+++ a/lib/Kconfig.debug
@@ -2525,6 +2525,18 @@ config MEMCPY_KUNIT_TEST
 
 	  If unsure, say N.
 
+config IS_SIGNED_TYPE_KUNIT_TEST
+	tristate "Test is_signed_type() macro" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Builds unit tests for the is_signed_type() macro.
+
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config OVERFLOW_KUNIT_TEST
 	tristate "Test check_*_overflow() functions at runtime" if !KUNIT_ALL_TESTS
 	depends on KUNIT
--- a/lib/Makefile~testing-selftests-add-tests-for-the-is_signed_type-macro
+++ a/lib/Makefile
@@ -377,6 +377,7 @@ obj-$(CONFIG_BITS_TEST) += test_bits.o
 obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
 obj-$(CONFIG_SLUB_KUNIT_TEST) += slub_kunit.o
 obj-$(CONFIG_MEMCPY_KUNIT_TEST) += memcpy_kunit.o
+obj-$(CONFIG_IS_SIGNED_TYPE_KUNIT_TEST) += is_signed_type_test.o
 obj-$(CONFIG_OVERFLOW_KUNIT_TEST) += overflow_kunit.o
 CFLAGS_stackinit_kunit.o += $(call cc-disable-warning, switch-unreachable)
 obj-$(CONFIG_STACKINIT_KUNIT_TEST) += stackinit_kunit.o
_

Patches currently in -mm which might be from bvanassche@acm.org are


