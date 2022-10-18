Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20C9C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiJRBFK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiJRBFG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:05:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DDA75FF7
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:05:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8920B81AF5
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD74C433C1;
        Tue, 18 Oct 2022 01:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055099;
        bh=dEH6lD38zJWaNg9qiiV7Vr+Q3b+X90t3YLCj/u0cWBQ=;
        h=Date:To:From:Subject:From;
        b=EBnonwX2nnlEvKCXWgF1YL3vNjscXp4fdxnovGhOSyEDrx4f8mEAKOtoZZHAeFZTS
         yr7MmPfP6X3AtIJMCgY93rQsKCS3gDo6s2gbdnwThJeduT7SzgIzhyok04lZ3lxRfw
         5ijvCyEX5OC3jJYWW6AHuXR8ChD18oKHVBzNGHRA=
Date:   Mon, 17 Oct 2022 18:04:58 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-switch-kunit-tests-to-console-tracepoints.patch added to mm-unstable branch
Message-Id: <20221018010459.5AD74C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: switch kunit tests to console tracepoints
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-switch-kunit-tests-to-console-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-switch-kunit-tests-to-console-tracepoints.patch

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
Subject: kasan: switch kunit tests to console tracepoints
Date: Tue, 27 Sep 2022 19:09:09 +0200

Switch KUnit-compatible KASAN tests from using per-task KUnit resources to
console tracepoints.

This allows for two things:

1. Migrating tests that trigger a KASAN report in the context of a task
   other than current to KUnit framework.
   This is implemented in the patches that follow.

2. Parsing and matching the contents of KASAN reports.
   This is not yet implemented.

Link: https://lkml.kernel.org/r/9345acdd11e953b207b0ed4724ff780e63afeb36.1664298455.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan     |    2 
 mm/kasan/kasan.h      |    8 ---
 mm/kasan/kasan_test.c |   85 +++++++++++++++++++++++++++++-----------
 mm/kasan/report.c     |   31 --------------
 4 files changed, 63 insertions(+), 63 deletions(-)

--- a/lib/Kconfig.kasan~kasan-switch-kunit-tests-to-console-tracepoints
+++ a/lib/Kconfig.kasan
@@ -181,7 +181,7 @@ config KASAN_VMALLOC
 
 config KASAN_KUNIT_TEST
 	tristate "KUnit-compatible tests of KASAN bug detection capabilities" if !KUNIT_ALL_TESTS
-	depends on KASAN && KUNIT
+	depends on KASAN && KUNIT && TRACEPOINTS
 	default KUNIT_ALL_TESTS
 	help
 	  A KUnit-based KASAN test suite. Triggers different kinds of
--- a/mm/kasan/kasan.h~kasan-switch-kunit-tests-to-console-tracepoints
+++ a/mm/kasan/kasan.h
@@ -261,14 +261,6 @@ struct kasan_stack_ring {
 
 #endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
 
-#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
-/* Used in KUnit-compatible KASAN tests. */
-struct kunit_kasan_status {
-	bool report_found;
-	bool sync_fault;
-};
-#endif
-
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 static inline const void *kasan_shadow_to_mem(const void *shadow_addr)
--- a/mm/kasan/kasan_test.c~kasan-switch-kunit-tests-to-console-tracepoints
+++ a/mm/kasan/kasan_test.c
@@ -5,8 +5,12 @@
  * Author: Andrey Ryabinin <a.ryabinin@samsung.com>
  */
 
+#define pr_fmt(fmt) "kasan_test: " fmt
+
+#include <kunit/test.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
+#include <linux/io.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -14,21 +18,28 @@
 #include <linux/module.h>
 #include <linux/printk.h>
 #include <linux/random.h>
+#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/tracepoint.h>
 #include <linux/uaccess.h>
-#include <linux/io.h>
 #include <linux/vmalloc.h>
-#include <linux/set_memory.h>
+#include <trace/events/printk.h>
 
 #include <asm/page.h>
 
-#include <kunit/test.h>
-
 #include "kasan.h"
 
 #define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_GRANULE_SIZE)
 
+static bool multishot;
+
+/* Fields set based on lines observed in the console. */
+static struct {
+	bool report_found;
+	bool async_fault;
+} test_status;
+
 /*
  * Some tests use these global variables to store return values from function
  * calls that could otherwise be eliminated by the compiler as dead code.
@@ -36,35 +47,61 @@
 void *kasan_ptr_result;
 int kasan_int_result;
 
-static struct kunit_resource resource;
-static struct kunit_kasan_status test_status;
-static bool multishot;
+/* Probe for console output: obtains test_status lines of interest. */
+static void probe_console(void *ignore, const char *buf, size_t len)
+{
+	if (strnstr(buf, "BUG: KASAN: ", len))
+		WRITE_ONCE(test_status.report_found, true);
+	else if (strnstr(buf, "Asynchronous fault: ", len))
+		WRITE_ONCE(test_status.async_fault, true);
+}
 
-/*
- * Temporarily enable multi-shot mode. Otherwise, KASAN would only report the
- * first detected bug and panic the kernel if panic_on_warn is enabled. For
- * hardware tag-based KASAN also allow tag checking to be reenabled for each
- * test, see the comment for KUNIT_EXPECT_KASAN_FAIL().
- */
-static int kasan_test_init(struct kunit *test)
+static void register_tracepoints(struct tracepoint *tp, void *ignore)
+{
+	check_trace_callback_type_console(probe_console);
+	if (!strcmp(tp->name, "console"))
+		WARN_ON(tracepoint_probe_register(tp, probe_console, NULL));
+}
+
+static void unregister_tracepoints(struct tracepoint *tp, void *ignore)
+{
+	if (!strcmp(tp->name, "console"))
+		tracepoint_probe_unregister(tp, probe_console, NULL);
+}
+
+static int kasan_suite_init(struct kunit_suite *suite)
 {
 	if (!kasan_enabled()) {
-		kunit_err(test, "can't run KASAN tests with KASAN disabled");
+		pr_err("Can't run KASAN tests with KASAN disabled");
 		return -1;
 	}
 
+	/*
+	 * Temporarily enable multi-shot mode. Otherwise, KASAN would only
+	 * report the first detected bug and panic the kernel if panic_on_warn
+	 * is enabled.
+	 */
 	multishot = kasan_save_enable_multi_shot();
-	test_status.report_found = false;
-	test_status.sync_fault = false;
-	kunit_add_named_resource(test, NULL, NULL, &resource,
-					"kasan_status", &test_status);
+
+	/*
+	 * Because we want to be able to build the test as a module, we need to
+	 * iterate through all known tracepoints, since the static registration
+	 * won't work here.
+	 */
+	for_each_kernel_tracepoint(register_tracepoints, NULL);
 	return 0;
 }
 
-static void kasan_test_exit(struct kunit *test)
+static void kasan_suite_exit(struct kunit_suite *suite)
 {
 	kasan_restore_multi_shot(multishot);
-	KUNIT_EXPECT_FALSE(test, test_status.report_found);
+	for_each_kernel_tracepoint(unregister_tracepoints, NULL);
+	tracepoint_synchronize_unregister();
+}
+
+static void kasan_test_exit(struct kunit *test)
+{
+	KUNIT_EXPECT_FALSE(test, READ_ONCE(test_status.report_found));
 }
 
 /**
@@ -106,11 +143,12 @@ static void kasan_test_exit(struct kunit
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&				\
 	    kasan_sync_fault_possible()) {				\
 		if (READ_ONCE(test_status.report_found) &&		\
-		    READ_ONCE(test_status.sync_fault))			\
+		    !READ_ONCE(test_status.async_fault))		\
 			kasan_enable_tagging();				\
 		migrate_enable();					\
 	}								\
 	WRITE_ONCE(test_status.report_found, false);			\
+	WRITE_ONCE(test_status.async_fault, false);			\
 } while (0)
 
 #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {			\
@@ -1447,9 +1485,10 @@ static struct kunit_case kasan_kunit_tes
 
 static struct kunit_suite kasan_kunit_test_suite = {
 	.name = "kasan",
-	.init = kasan_test_init,
 	.test_cases = kasan_kunit_test_cases,
 	.exit = kasan_test_exit,
+	.suite_init = kasan_suite_init,
+	.suite_exit = kasan_suite_exit,
 };
 
 kunit_test_suite(kasan_kunit_test_suite);
--- a/mm/kasan/report.c~kasan-switch-kunit-tests-to-console-tracepoints
+++ a/mm/kasan/report.c
@@ -30,8 +30,6 @@
 
 #include <asm/sections.h>
 
-#include <kunit/test.h>
-
 #include "kasan.h"
 #include "../slab.h"
 
@@ -114,41 +112,12 @@ EXPORT_SYMBOL_GPL(kasan_restore_multi_sh
 
 #endif
 
-#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
-static void update_kunit_status(bool sync)
-{
-	struct kunit *test;
-	struct kunit_resource *resource;
-	struct kunit_kasan_status *status;
-
-	test = current->kunit_test;
-	if (!test)
-		return;
-
-	resource = kunit_find_named_resource(test, "kasan_status");
-	if (!resource) {
-		kunit_set_failure(test);
-		return;
-	}
-
-	status = (struct kunit_kasan_status *)resource->data;
-	WRITE_ONCE(status->report_found, true);
-	WRITE_ONCE(status->sync_fault, sync);
-
-	kunit_put_resource(resource);
-}
-#else
-static void update_kunit_status(bool sync) { }
-#endif
-
 static DEFINE_SPINLOCK(report_lock);
 
 static void start_report(unsigned long *flags, bool sync)
 {
 	/* Respect the /proc/sys/kernel/traceoff_on_warning interface. */
 	disable_trace_on_warning();
-	/* Update status of the currently running KASAN test. */
-	update_kunit_status(sync);
 	/* Do not allow LOCKDEP mangling KASAN reports. */
 	lockdep_off();
 	/* Make sure we don't end up in loop. */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-switch-kunit-tests-to-console-tracepoints.patch
kasan-migrate-kasan_rcu_uaf-test-to-kunit.patch
kasan-migrate-workqueue_uaf-test-to-kunit.patch

