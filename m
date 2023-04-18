Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208A0C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjDRXjB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjDRXg4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7540B8A7A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBA6F63A01
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5179EC433EF;
        Tue, 18 Apr 2023 23:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860952;
        bh=J3xQmCqWpPEgojEyIlBpuyUNZr7/4eb+RKexuYfaoFw=;
        h=Date:To:From:Subject:From;
        b=RPj+/n4grNgYcSuGtF4pkE6vZoGs3LxVB43PNzricJVIAvocE2NWTRMNqLpSqbbI5
         Kzb5gjTCvECP8GoEsMn/nCQjSJBJ+TXdlexSt+ggF/TAoIB7ZFBM/TcbvWbw0w28ug
         2tKrHOSDHyxx9hbX9KDHKqKTHi2fzp1Cdunqna9s=
Date:   Tue, 18 Apr 2023 16:35:51 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        senozhatsky@chromium.org, ryabinin.a.a@gmail.com,
        rostedt@goodmis.org, pmladek@suse.com, john.ogness@linutronix.de,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, quic_pkondeti@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] printk-export-console-trace-point-for-kcsan-kasan-kfence-kmsan.patch removed from -mm tree
Message-Id: <20230418233552.5179EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: printk: export console trace point for kcsan/kasan/kfence/kmsan
has been removed from the -mm tree.  Its filename was
     printk-export-console-trace-point-for-kcsan-kasan-kfence-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: printk: export console trace point for kcsan/kasan/kfence/kmsan
Date: Thu, 13 Apr 2023 15:38:59 +0530

The console tracepoint is used by kcsan/kasan/kfence/kmsan test modules. 
Since this tracepoint is not exported, these modules iterate over all
available tracepoints to find the console trace point.  Export the trace
point so that it can be directly used.

Link: https://lkml.kernel.org/r/20230413100859.1492323-1-quic_pkondeti@quicinc.com
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Marco Elver <elver@google.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcsan/kcsan_test.c |   20 ++++++--------------
 kernel/printk/printk.c    |    2 ++
 mm/kasan/kasan_test.c     |   22 ++--------------------
 mm/kfence/kfence_test.c   |   22 ++--------------------
 mm/kmsan/kmsan_test.c     |   22 ++--------------------
 5 files changed, 14 insertions(+), 74 deletions(-)

--- a/kernel/kcsan/kcsan_test.c~printk-export-console-trace-point-for-kcsan-kasan-kfence-kmsan
+++ a/kernel/kcsan/kcsan_test.c
@@ -1572,34 +1572,26 @@ static void test_exit(struct kunit *test
 }
 
 __no_kcsan
-static void register_tracepoints(struct tracepoint *tp, void *ignore)
+static void register_tracepoints(void)
 {
-	check_trace_callback_type_console(probe_console);
-	if (!strcmp(tp->name, "console"))
-		WARN_ON(tracepoint_probe_register(tp, probe_console, NULL));
+	register_trace_console(probe_console, NULL);
 }
 
 __no_kcsan
-static void unregister_tracepoints(struct tracepoint *tp, void *ignore)
+static void unregister_tracepoints(void)
 {
-	if (!strcmp(tp->name, "console"))
-		tracepoint_probe_unregister(tp, probe_console, NULL);
+	unregister_trace_console(probe_console, NULL);
 }
 
 static int kcsan_suite_init(struct kunit_suite *suite)
 {
-	/*
-	 * Because we want to be able to build the test as a module, we need to
-	 * iterate through all known tracepoints, since the static registration
-	 * won't work here.
-	 */
-	for_each_kernel_tracepoint(register_tracepoints, NULL);
+	register_tracepoints();
 	return 0;
 }
 
 static void kcsan_suite_exit(struct kunit_suite *suite)
 {
-	for_each_kernel_tracepoint(unregister_tracepoints, NULL);
+	unregister_tracepoints();
 	tracepoint_synchronize_unregister();
 }
 
--- a/kernel/printk/printk.c~printk-export-console-trace-point-for-kcsan-kasan-kfence-kmsan
+++ a/kernel/printk/printk.c
@@ -71,6 +71,8 @@ EXPORT_SYMBOL_GPL(console_printk);
 atomic_t ignore_console_lock_warning __read_mostly = ATOMIC_INIT(0);
 EXPORT_SYMBOL(ignore_console_lock_warning);
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(console);
+
 /*
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
--- a/mm/kasan/kasan_test.c~printk-export-console-trace-point-for-kcsan-kasan-kfence-kmsan
+++ a/mm/kasan/kasan_test.c
@@ -56,19 +56,6 @@ static void probe_console(void *ignore,
 		WRITE_ONCE(test_status.async_fault, true);
 }
 
-static void register_tracepoints(struct tracepoint *tp, void *ignore)
-{
-	check_trace_callback_type_console(probe_console);
-	if (!strcmp(tp->name, "console"))
-		WARN_ON(tracepoint_probe_register(tp, probe_console, NULL));
-}
-
-static void unregister_tracepoints(struct tracepoint *tp, void *ignore)
-{
-	if (!strcmp(tp->name, "console"))
-		tracepoint_probe_unregister(tp, probe_console, NULL);
-}
-
 static int kasan_suite_init(struct kunit_suite *suite)
 {
 	if (!kasan_enabled()) {
@@ -86,12 +73,7 @@ static int kasan_suite_init(struct kunit
 	 */
 	multishot = kasan_save_enable_multi_shot();
 
-	/*
-	 * Because we want to be able to build the test as a module, we need to
-	 * iterate through all known tracepoints, since the static registration
-	 * won't work here.
-	 */
-	for_each_kernel_tracepoint(register_tracepoints, NULL);
+	register_trace_console(probe_console, NULL);
 	return 0;
 }
 
@@ -99,7 +81,7 @@ static void kasan_suite_exit(struct kuni
 {
 	kasan_kunit_test_suite_end();
 	kasan_restore_multi_shot(multishot);
-	for_each_kernel_tracepoint(unregister_tracepoints, NULL);
+	unregister_trace_console(probe_console, NULL);
 	tracepoint_synchronize_unregister();
 }
 
--- a/mm/kfence/kfence_test.c~printk-export-console-trace-point-for-kcsan-kasan-kfence-kmsan
+++ a/mm/kfence/kfence_test.c
@@ -825,33 +825,15 @@ static void test_exit(struct kunit *test
 	test_cache_destroy();
 }
 
-static void register_tracepoints(struct tracepoint *tp, void *ignore)
-{
-	check_trace_callback_type_console(probe_console);
-	if (!strcmp(tp->name, "console"))
-		WARN_ON(tracepoint_probe_register(tp, probe_console, NULL));
-}
-
-static void unregister_tracepoints(struct tracepoint *tp, void *ignore)
-{
-	if (!strcmp(tp->name, "console"))
-		tracepoint_probe_unregister(tp, probe_console, NULL);
-}
-
 static int kfence_suite_init(struct kunit_suite *suite)
 {
-	/*
-	 * Because we want to be able to build the test as a module, we need to
-	 * iterate through all known tracepoints, since the static registration
-	 * won't work here.
-	 */
-	for_each_kernel_tracepoint(register_tracepoints, NULL);
+	register_trace_console(probe_console, NULL);
 	return 0;
 }
 
 static void kfence_suite_exit(struct kunit_suite *suite)
 {
-	for_each_kernel_tracepoint(unregister_tracepoints, NULL);
+	unregister_trace_console(probe_console, NULL);
 	tracepoint_synchronize_unregister();
 }
 
--- a/mm/kmsan/kmsan_test.c~printk-export-console-trace-point-for-kcsan-kasan-kfence-kmsan
+++ a/mm/kmsan/kmsan_test.c
@@ -626,33 +626,15 @@ static void test_exit(struct kunit *test
 {
 }
 
-static void register_tracepoints(struct tracepoint *tp, void *ignore)
-{
-	check_trace_callback_type_console(probe_console);
-	if (!strcmp(tp->name, "console"))
-		WARN_ON(tracepoint_probe_register(tp, probe_console, NULL));
-}
-
-static void unregister_tracepoints(struct tracepoint *tp, void *ignore)
-{
-	if (!strcmp(tp->name, "console"))
-		tracepoint_probe_unregister(tp, probe_console, NULL);
-}
-
 static int kmsan_suite_init(struct kunit_suite *suite)
 {
-	/*
-	 * Because we want to be able to build the test as a module, we need to
-	 * iterate through all known tracepoints, since the static registration
-	 * won't work here.
-	 */
-	for_each_kernel_tracepoint(register_tracepoints, NULL);
+	register_trace_console(probe_console, NULL);
 	return 0;
 }
 
 static void kmsan_suite_exit(struct kunit_suite *suite)
 {
-	for_each_kernel_tracepoint(unregister_tracepoints, NULL);
+	unregister_trace_console(probe_console, NULL);
 	tracepoint_synchronize_unregister();
 }
 
_

Patches currently in -mm which might be from quic_pkondeti@quicinc.com are


