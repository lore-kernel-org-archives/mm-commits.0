Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CDDECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 01:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbiH0B52 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 21:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiH0B51 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 21:57:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3F28688B
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 18:57:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C7520CE30A5
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 01:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DFEC433D6;
        Sat, 27 Aug 2022 01:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661565442;
        bh=JKLLXFPyG+cZlZPV5O/kLTPtAg8x6INlCp5EAKrwLpQ=;
        h=Date:To:From:Subject:From;
        b=GWZsfRZp581KK69WxBaDM+UCZVPKxyGNkqHHVvZ9VxA64wmbiI6AYeGdLM/kUzV5a
         kABLDQKi6/vzUDTf0bciYG5CGksheSvxnocQYtEbaVIw8t29WH9UNn0t6bcKhL8Q+3
         WxB60lzVTUvsuzzpeietXyRbnNXKIZODE3YLvfvs=
Date:   Fri, 26 Aug 2022 18:57:21 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com, vbabka@suse.cz,
        sander@svanheule.net, rostedt@goodmis.org, peterz@infradead.org,
        nathan@kernel.org, mingo@redhat.com, mhiramat@kernel.org,
        luc.vanoostenryck@gmail.com, linux@rasmusvillemoes.dk,
        jpoimboe@kernel.org, Jason@zx2c4.com, isabbasso@riseup.net,
        edumazet@google.com, dan.j.williams@intel.com, arnd@arndb.de,
        bvanassche@acm.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + testing-selftests-add-tests-for-the-is_signed_type-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20220827015722.60DFEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: testing/selftests: add tests for the is_signed_type() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     testing-selftests-add-tests-for-the-is_signed_type-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/testing-selftests-add-tests-for-the-is_signed_type-macro.patch

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
From: Bart Van Assche <bvanassche@acm.org>
Subject: testing/selftests: add tests for the is_signed_type() macro
Date: Fri, 26 Aug 2022 09:21:15 -0700

Although not documented, is_signed_type() must support the 'bool' and
pointer types next to scalar and enumeration types.  Add a selftest that
verifies that this macro handles all supported types correctly.

Link: https://lkml.kernel.org/r/20220826162116.1050972-2-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
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
@@ -2532,6 +2532,18 @@ config MEMCPY_KUNIT_TEST
 
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

testing-selftests-add-tests-for-the-is_signed_type-macro.patch
overflow-tracing-define-the-is_signed_type-macro-once.patch

