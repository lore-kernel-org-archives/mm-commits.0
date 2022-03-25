Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7709CC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbiCYWoo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiCYWo0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9772420C2E1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14166614BD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB83C340F0;
        Fri, 25 Mar 2022 22:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248169;
        bh=BlZQ1s9zhhinUT7NNEBbbiU+JUmWTe4EfD+JJYzTv5E=;
        h=Date:To:From:Subject:From;
        b=2YwRSLtpHQyTLWOgT6LkNB2vA93Id7KKFK38u4I/ggZMHM1677DDuc4uNvNfkjY59
         mIcmRoq0iUYtgGgMKGDw9d88UyLihFxfnfl1IBbX0cisQeI9SY2nddGVYUa3BkoL1E
         Vdhf+AfnMkHqzVw++66UnVg46prtH0cKzx5GRMUE=
Date:   Fri, 25 Mar 2022 15:42:48 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-move-update_kunit_status-to-start_report.patch removed from -mm tree
Message-Id: <20220325224249.6CB83C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move update_kunit_status to start_report
has been removed from the -mm tree.  Its filename was
     kasan-move-update_kunit_status-to-start_report.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move update_kunit_status to start_report

Instead of duplicating calls to update_kunit_status() in every error
report routine, call it once in start_report().  Pass the sync flag as an
additional argument to start_report().

Link: https://lkml.kernel.org/r/cae5c845a0b6f3c867014e53737cdac56b11edc7.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   75 +++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 41 deletions(-)

--- a/mm/kasan/report.c~kasan-move-update_kunit_status-to-start_report
+++ a/mm/kasan/report.c
@@ -98,13 +98,40 @@ static void print_error_description(stru
 			info->access_addr, current->comm, task_pid_nr(current));
 }
 
+#if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
+static void update_kunit_status(bool sync)
+{
+	struct kunit *test;
+	struct kunit_resource *resource;
+	struct kunit_kasan_status *status;
+
+	test = current->kunit_test;
+	if (!test)
+		return;
+
+	resource = kunit_find_named_resource(test, "kasan_status");
+	if (!resource) {
+		kunit_set_failure(test);
+		return;
+	}
+
+	status = (struct kunit_kasan_status *)resource->data;
+	WRITE_ONCE(status->report_found, true);
+	WRITE_ONCE(status->sync_fault, sync);
+
+	kunit_put_resource(resource);
+}
+#else
+static void update_kunit_status(bool sync) { }
+#endif
+
 static DEFINE_SPINLOCK(report_lock);
 
-static void start_report(unsigned long *flags)
+static void start_report(unsigned long *flags, bool sync)
 {
-	/*
-	 * Make sure we don't end up in loop.
-	 */
+	/* Update status of the currently running KASAN test. */
+	update_kunit_status(sync);
+	/* Make sure we don't end up in loop. */
 	kasan_disable_current();
 	spin_lock_irqsave(&report_lock, *flags);
 	pr_err("==================================================================\n");
@@ -356,33 +383,6 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
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
 void kasan_report_invalid_free(void *object, unsigned long ip)
 {
 	unsigned long flags;
@@ -390,9 +390,7 @@ void kasan_report_invalid_free(void *obj
 
 	object = kasan_reset_tag(object);
 
-	update_kunit_status(true);
-
-	start_report(&flags);
+	start_report(&flags, true);
 	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
 	kasan_print_tags(tag, object);
 	pr_err("\n");
@@ -406,9 +404,7 @@ void kasan_report_async(void)
 {
 	unsigned long flags;
 
-	update_kunit_status(false);
-
-	start_report(&flags);
+	start_report(&flags, false);
 	pr_err("BUG: KASAN: invalid-access\n");
 	pr_err("Asynchronous mode enabled: no access details available\n");
 	pr_err("\n");
@@ -425,9 +421,8 @@ static void __kasan_report(unsigned long
 	void *untagged_addr;
 	unsigned long flags;
 
-	update_kunit_status(true);
-
 	disable_trace_on_warning();
+	start_report(&flags, true);
 
 	tagged_addr = (void *)addr;
 	untagged_addr = kasan_reset_tag(tagged_addr);
@@ -442,8 +437,6 @@ static void __kasan_report(unsigned long
 	info.is_write = is_write;
 	info.ip = ip;
 
-	start_report(&flags);
-
 	print_error_description(&info);
 	if (addr_has_metadata(untagged_addr))
 		kasan_print_tags(get_tag(tagged_addr), info.first_bad_addr);
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

