Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238BBC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiLLCQ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiLLCOh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2627DF57
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 194A5CE0B8F
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9F3C433EF;
        Mon, 12 Dec 2022 02:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811268;
        bh=sncKif4v4kwT+hAtyRi/SnVL5/wboDJa9eorBuxnCZo=;
        h=Date:To:From:Subject:From;
        b=z1aoU+Dd5Xj6VhjUJ+l+x/1zgjw6Mpp/87CLQnVCMtGCTlr+IZLR4XEtiIcGC+Xy4
         E6XPzKCeurj13RnUhEd2sGmPIvoIOJZvdVxec/VVpHZ7L+nJ1oeyzLzo9Rv8CwSLYl
         C9lIQkxlW47Pdal7QB0sxajz868Sicxlx0NSBqSc=
Date:   Sun, 11 Dec 2022 18:14:27 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        davidgow@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-fail-non-kasan-kunit-tests-on-kasan-reports.patch removed from -mm tree
Message-Id: <20221212021428.3E9F3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: fail non-kasan KUnit tests on KASAN reports
has been removed from the -mm tree.  Its filename was
     kasan-fail-non-kasan-kunit-tests-on-kasan-reports.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


