Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF5BC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 20:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiK3UU1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 15:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiK3UUK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 15:20:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F246D4E681
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 12:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEFBAB81CB6
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 20:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6628CC433C1;
        Wed, 30 Nov 2022 20:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669839356;
        bh=W45KfM2IiuaL0Mpu1B1oyOQfotVrEA5ISIYamvdEHBs=;
        h=Date:To:From:Subject:From;
        b=nMCxIEx3LYPli1ZTqrqsi0wuYjmGYUITJGrDFDV00IDepgnombsYTzgwATHYrVVD2
         sfJB2HULCsdzLn7L9cZRh2DqXpU1JNRZQ4nTcWh3bivKJBP2VodYhzxcxR1D8bkZwu
         7fsZaIZ/vSVSDa3PNTuWG7cey2t7BVMQXiTiU3Io=
Date:   Wed, 30 Nov 2022 12:15:55 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        davidgow@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fail-non-kasan-kunit-tests-on-kasan-reports.patch added to mm-unstable branch
Message-Id: <20221130201556.6628CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fail non-kasan KUnit tests on KASAN reports
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-fail-non-kasan-kunit-tests-on-kasan-reports.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fail-non-kasan-kunit-tests-on-kasan-reports.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fail non-kasan KUnit tests on KASAN reports
Date: Wed, 30 Nov 2022 16:02:03 +0100

After the recent changes done to KUnit-enabled KASAN tests, non-KASAN
KUnit tests stopped being failed when KASAN report is detected.

Recover that property by failing the currently running non-KASAN KUnit
test when KASAN detects and prints a report for a bad memory access.

Note that if the bad accesses happened in a kernel thread that doesn't
have a reference to the currently running KUnit-test available via
current->kunit_test, the test won't be failed.  This is a limitation of
KUnit, which doesn't yet provide a thread-agnostic way to find the
reference to the currenly running test.

Link: https://lkml.kernel.org/r/7be29a8ea967cee6b7e48d3d5a242d1d0bd96851.1669820505.git.andreyknvl@google.com
Fixes: 49d9977ac909 ("kasan: check CONFIG_KASAN_KUNIT_TEST instead of CONFIG_KUNIT")
Fixes: 7ce0ea19d50e ("kasan: switch kunit tests to console tracepoints")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: David Gow <davidgow@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h      |   12 +++++++++
 mm/kasan/kasan_test.c |    4 +++
 mm/kasan/report.c     |   53 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)

--- a/mm/kasan/kasan.h~kasan-fail-non-kasan-kunit-tests-on-kasan-reports
+++ a/mm/kasan/kasan.h
@@ -541,6 +541,18 @@ static inline bool kasan_arch_is_ready(v
 #error kasan_arch_is_ready only works in KASAN generic outline mode!
 #endif
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+
+void kasan_kunit_test_suite_start(void);
+void kasan_kunit_test_suite_end(void);
+
+#else /* CONFIG_KASAN_KUNIT_TEST */
+
+static inline void kasan_kunit_test_suite_start(void) { }
+static inline void kasan_kunit_test_suite_end(void) { }
+
+#endif /* CONFIG_KASAN_KUNIT_TEST */
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST) || IS_ENABLED(CONFIG_KASAN_MODULE_TEST)
 
 bool kasan_save_enable_multi_shot(void);
--- a/mm/kasan/kasan_test.c~kasan-fail-non-kasan-kunit-tests-on-kasan-reports
+++ a/mm/kasan/kasan_test.c
@@ -76,6 +76,9 @@ static int kasan_suite_init(struct kunit
 		return -1;
 	}
 
+	/* Stop failing KUnit tests on KASAN reports. */
+	kasan_kunit_test_suite_start();
+
 	/*
 	 * Temporarily enable multi-shot mode. Otherwise, KASAN would only
 	 * report the first detected bug and panic the kernel if panic_on_warn
@@ -94,6 +97,7 @@ static int kasan_suite_init(struct kunit
 
 static void kasan_suite_exit(struct kunit_suite *suite)
 {
+	kasan_kunit_test_suite_end();
 	kasan_restore_multi_shot(multishot);
 	for_each_kernel_tracepoint(unregister_tracepoints, NULL);
 	tracepoint_synchronize_unregister();
--- a/mm/kasan/report.c~kasan-fail-non-kasan-kunit-tests-on-kasan-reports
+++ a/mm/kasan/report.c
@@ -9,6 +9,7 @@
  *        Andrey Konovalov <andreyknvl@gmail.com>
  */
 
+#include <kunit/test.h>
 #include <linux/bitops.h>
 #include <linux/ftrace.h>
 #include <linux/init.h>
@@ -112,10 +113,62 @@ EXPORT_SYMBOL_GPL(kasan_restore_multi_sh
 
 #endif
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+
+/*
+ * Whether the KASAN KUnit test suite is currently being executed.
+ * Updated in kasan_test.c.
+ */
+bool kasan_kunit_executing;
+
+void kasan_kunit_test_suite_start(void)
+{
+	WRITE_ONCE(kasan_kunit_executing, true);
+}
+EXPORT_SYMBOL_GPL(kasan_kunit_test_suite_start);
+
+void kasan_kunit_test_suite_end(void)
+{
+	WRITE_ONCE(kasan_kunit_executing, false);
+}
+EXPORT_SYMBOL_GPL(kasan_kunit_test_suite_end);
+
+static bool kasan_kunit_test_suite_executing(void)
+{
+	return READ_ONCE(kasan_kunit_executing);
+}
+
+#else /* CONFIG_KASAN_KUNIT_TEST */
+
+static inline bool kasan_kunit_test_suite_executing(void) { return false; }
+
+#endif /* CONFIG_KASAN_KUNIT_TEST */
+
+#if IS_ENABLED(CONFIG_KUNIT)
+
+static void fail_non_kasan_kunit_test(void)
+{
+	struct kunit *test;
+
+	if (kasan_kunit_test_suite_executing())
+		return;
+
+	test = current->kunit_test;
+	if (test)
+		kunit_set_failure(test);
+}
+
+#else /* CONFIG_KUNIT */
+
+static inline void fail_non_kasan_kunit_test(void) { }
+
+#endif /* CONFIG_KUNIT */
+
 static DEFINE_SPINLOCK(report_lock);
 
 static void start_report(unsigned long *flags, bool sync)
 {
+	fail_non_kasan_kunit_test();
 	/* Respect the /proc/sys/kernel/traceoff_on_warning interface. */
 	disable_trace_on_warning();
 	/* Do not allow LOCKDEP mangling KASAN reports. */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fail-non-kasan-kunit-tests-on-kasan-reports.patch

