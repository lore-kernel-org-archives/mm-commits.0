Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B316EC433EF
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 20:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiGBUjw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Jul 2022 16:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGBUjt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Jul 2022 16:39:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2396567
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 13:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEBECB80909
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 20:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D981C34114;
        Sat,  2 Jul 2022 20:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656794385;
        bh=i97jYDyrTTXXhrdK8BMSWcXQ7Bxp4GDM/KZcLfNyAkU=;
        h=Date:To:From:Subject:From;
        b=ZhzlQgsHcaze364sxbXCriWMHdeEzOrE+Dc800jS63N67daPrizS72Pr5ZA++2P4C
         NzevoEsV3m4q8qd5cZgQ9WN7uC1+vE9XnjDyfmQlQKycS6QuI7aeDNYRAfM+HbzqkQ
         xZYW/VFrp3f+Rs+3kFTL/pW/LmLsOmsjwka8onLI=
Date:   Sat, 02 Jul 2022 13:39:44 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com, sander@svanheule.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test-introduce-cpumask-kunit-test-suite.patch added to mm-nonmm-unstable branch
Message-Id: <20220702203945.6D981C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test: ontroduce cpumask KUnit test suite
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test-introduce-cpumask-kunit-test-suite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test-introduce-cpumask-kunit-test-suite.patch

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
From: Sander Vanheule <sander@svanheule.net>
Subject: lib/test: ontroduce cpumask KUnit test suite
Date: Sat, 2 Jul 2022 18:08:26 +0200

Add a basic suite of tests for cpumask, providing some tests for empty and
completely filled cpumasks.

Link: https://lkml.kernel.org/r/c96980ec35c3bd23f17c3374bf42c22971545e85.1656777646.git.sander@svanheule.net
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug  |    9 ++
 lib/Makefile       |    1 
 lib/test_cpumask.c |  138 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 148 insertions(+)

--- a/lib/Kconfig.debug~lib-test-introduce-cpumask-kunit-test-suite
+++ a/lib/Kconfig.debug
@@ -2037,6 +2037,15 @@ config LKDTM
 	Documentation on how to use the module can be found in
 	Documentation/fault-injection/provoke-crashes.rst
 
+config TEST_CPUMASK
+	tristate "cpumask tests" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable to turn on cpumask tests, running at boot or module load time.
+
+	  If unsure, say N.
+
 config TEST_LIST_SORT
 	tristate "Linked list sorting test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
--- a/lib/Makefile~lib-test-introduce-cpumask-kunit-test-suite
+++ a/lib/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_TEST_HMM) += test_hmm.o
 obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
+obj-$(CONFIG_TEST_CPUMASK) += test_cpumask.o
 CFLAGS_test_fprobe.o += $(CC_FLAGS_FTRACE)
 obj-$(CONFIG_FPROBE_SANITY_TEST) += test_fprobe.o
 #
--- /dev/null
+++ a/lib/test_cpumask.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for cpumask.
+ *
+ * Author: Sander Vanheule <sander@svanheule.net>
+ */
+
+#include <kunit/test.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+
+#define EXPECT_FOR_EACH_CPU_EQ(test, mask)			\
+	do {							\
+		const cpumask_t *m = (mask);			\
+		int mask_weight = cpumask_weight(m);		\
+		int cpu, iter = 0;				\
+		for_each_cpu(cpu, m)				\
+			iter++;					\
+		KUNIT_EXPECT_EQ((test), mask_weight, iter);	\
+	} while (0)
+
+#define EXPECT_FOR_EACH_CPU_NOT_EQ(test, mask)					\
+	do {									\
+		const cpumask_t *m = (mask);					\
+		int mask_weight = cpumask_weight(m);				\
+		int cpu, iter = 0;						\
+		for_each_cpu_not(cpu, m)					\
+			iter++;							\
+		KUNIT_EXPECT_EQ((test), nr_cpu_ids - mask_weight, iter);	\
+	} while (0)
+
+#define EXPECT_FOR_EACH_CPU_WRAP_EQ(test, mask)			\
+	do {							\
+		const cpumask_t *m = (mask);			\
+		int mask_weight = cpumask_weight(m);		\
+		int cpu, iter = 0;				\
+		for_each_cpu_wrap(cpu, m, nr_cpu_ids / 2)	\
+			iter++;					\
+		KUNIT_EXPECT_EQ((test), mask_weight, iter);	\
+	} while (0)
+
+#define EXPECT_FOR_EACH_CPU_BUILTIN_EQ(test, name)		\
+	do {							\
+		int mask_weight = num_##name##_cpus();		\
+		int cpu, iter = 0;				\
+		for_each_##name##_cpu(cpu)			\
+			iter++;					\
+		KUNIT_EXPECT_EQ((test), mask_weight, iter);	\
+	} while (0)
+
+static cpumask_t mask_empty;
+static cpumask_t mask_all;
+
+static void test_cpumask_weight(struct kunit *test)
+{
+	KUNIT_EXPECT_TRUE(test, cpumask_empty(&mask_empty));
+	KUNIT_EXPECT_TRUE(test, cpumask_full(cpu_possible_mask));
+	KUNIT_EXPECT_TRUE(test, cpumask_full(&mask_all));
+
+	KUNIT_EXPECT_EQ(test, 0, cpumask_weight(&mask_empty));
+	KUNIT_EXPECT_EQ(test, nr_cpu_ids, cpumask_weight(cpu_possible_mask));
+	KUNIT_EXPECT_EQ(test, nr_cpumask_bits, cpumask_weight(&mask_all));
+}
+
+static void test_cpumask_first(struct kunit *test)
+{
+	KUNIT_EXPECT_LE(test, nr_cpu_ids, cpumask_first(&mask_empty));
+	KUNIT_EXPECT_EQ(test, 0, cpumask_first(cpu_possible_mask));
+
+	KUNIT_EXPECT_EQ(test, 0, cpumask_first_zero(&mask_empty));
+	KUNIT_EXPECT_LE(test, nr_cpu_ids, cpumask_first_zero(cpu_possible_mask));
+}
+
+static void test_cpumask_last(struct kunit *test)
+{
+	KUNIT_EXPECT_LE(test, nr_cpumask_bits, cpumask_last(&mask_empty));
+	KUNIT_EXPECT_EQ(test, nr_cpumask_bits - 1, cpumask_last(cpu_possible_mask));
+}
+
+static void test_cpumask_next(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, 0, cpumask_next_zero(-1, &mask_empty));
+	KUNIT_EXPECT_LE(test, nr_cpu_ids, cpumask_next_zero(-1, cpu_possible_mask));
+
+	KUNIT_EXPECT_LE(test, nr_cpu_ids, cpumask_next(-1, &mask_empty));
+	KUNIT_EXPECT_EQ(test, 0, cpumask_next(-1, cpu_possible_mask));
+}
+
+static void test_cpumask_iterators(struct kunit *test)
+{
+	EXPECT_FOR_EACH_CPU_EQ(test, &mask_empty);
+	EXPECT_FOR_EACH_CPU_NOT_EQ(test, &mask_empty);
+	EXPECT_FOR_EACH_CPU_WRAP_EQ(test, &mask_empty);
+
+	EXPECT_FOR_EACH_CPU_EQ(test, cpu_possible_mask);
+	EXPECT_FOR_EACH_CPU_NOT_EQ(test, cpu_possible_mask);
+	EXPECT_FOR_EACH_CPU_WRAP_EQ(test, cpu_possible_mask);
+}
+
+static void test_cpumask_iterators_builtin(struct kunit *test)
+{
+	EXPECT_FOR_EACH_CPU_BUILTIN_EQ(test, possible);
+
+	/* Ensure the dynamic masks are stable while running the tests */
+	cpu_hotplug_disable();
+
+	EXPECT_FOR_EACH_CPU_BUILTIN_EQ(test, online);
+	EXPECT_FOR_EACH_CPU_BUILTIN_EQ(test, present);
+
+	cpu_hotplug_enable();
+}
+
+static int test_cpumask_init(struct kunit *test)
+{
+	cpumask_clear(&mask_empty);
+	cpumask_setall(&mask_all);
+
+	return 0;
+}
+
+static struct kunit_case test_cpumask_cases[] = {
+	KUNIT_CASE(test_cpumask_weight),
+	KUNIT_CASE(test_cpumask_first),
+	KUNIT_CASE(test_cpumask_last),
+	KUNIT_CASE(test_cpumask_next),
+	KUNIT_CASE(test_cpumask_iterators),
+	KUNIT_CASE(test_cpumask_iterators_builtin),
+	{}
+};
+
+static struct kunit_suite test_cpumask_suite = {
+	.name = "cpumask",
+	.init = test_cpumask_init,
+	.test_cases = test_cpumask_cases,
+};
+kunit_test_suite(test_cpumask_suite);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from sander@svanheule.net are

x86-cacheinfo-move-shared-cache-map-definitions.patch
cpumask-fix-invalid-uniprocessor-mask-assumption.patch
lib-test-introduce-cpumask-kunit-test-suite.patch
cpumask-add-up-optimised-for_each__cpu-versions.patch
cpumask-update-cpumask_next_wrap-signature.patch

