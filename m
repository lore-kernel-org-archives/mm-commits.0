Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8E2C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 583126148E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhD3GBh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3GBh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5503A61483;
        Fri, 30 Apr 2021 06:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762449;
        bh=f9XfdwFmOiW0LG+BkCsjVa1G40K6IPuXMT6ANeMrAZ0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xF3TKrJXX4P9VJb0ev/S+fe5SYVvMjchNuUp3kYU9RS9K8Qqz9h/nWjUoLBIX14a1
         UsLNY7eSMYW/metVYtIKb8+bCU0xPUgWYMMAW3y1s4qAR3LTHIK2auyzUYLF5pVJEG
         P8ElTYZUYrsUPA7NuWng0tyb8s8t+wFvaR0qPp5c=
Date:   Thu, 29 Apr 2021 23:00:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 148/178] kasan: detect false-positives in tests
Message-ID: <20210430060049.FrKVS3ZER%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: detect false-positives in tests

Currently, KASAN-KUnit tests can check that a particular annotated part of
code causes a KASAN report.  However, they do not check that no unwanted
reports happen between the annotated parts.

This patch implements these checks.

It is done by setting report_data.report_found to false in
kasan_test_init() and at the end of KUNIT_EXPECT_KASAN_FAIL() and then
checking that it remains false at the beginning of
KUNIT_EXPECT_KASAN_FAIL() and in kasan_test_exit().

kunit_add_named_resource() call is moved to kasan_test_init(), and the
value of fail_data.report_expected is kept as false in between
KUNIT_EXPECT_KASAN_FAIL() annotations for consistency.

Link: https://lkml.kernel.org/r/48079c52cc329fbc52f4386996598d58022fb872.1617207873.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   55 +++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

--- a/lib/test_kasan.c~kasan-detect-false-positives-in-tests
+++ a/lib/test_kasan.c
@@ -54,6 +54,10 @@ static int kasan_test_init(struct kunit
 
 	multishot = kasan_save_enable_multi_shot();
 	kasan_set_tagging_report_once(false);
+	fail_data.report_found = false;
+	fail_data.report_expected = false;
+	kunit_add_named_resource(test, NULL, NULL, &resource,
+					"kasan_data", &fail_data);
 	return 0;
 }
 
@@ -61,6 +65,7 @@ static void kasan_test_exit(struct kunit
 {
 	kasan_set_tagging_report_once(true);
 	kasan_restore_multi_shot(multishot);
+	KUNIT_EXPECT_FALSE(test, fail_data.report_found);
 }
 
 /**
@@ -78,33 +83,31 @@ static void kasan_test_exit(struct kunit
  * fields, it can reorder or optimize away the accesses to those fields.
  * Use READ/WRITE_ONCE() for the accesses and compiler barriers around the
  * expression to prevent that.
+ *
+ * In between KUNIT_EXPECT_KASAN_FAIL checks, fail_data.report_found is kept as
+ * false. This allows detecting KASAN reports that happen outside of the checks
+ * by asserting !fail_data.report_found at the start of KUNIT_EXPECT_KASAN_FAIL
+ * and in kasan_test_exit.
  */
-#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {		\
-	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&			\
-	    !kasan_async_mode_enabled())			\
-		migrate_disable();				\
-	WRITE_ONCE(fail_data.report_expected, true);		\
-	WRITE_ONCE(fail_data.report_found, false);		\
-	kunit_add_named_resource(test,				\
-				NULL,				\
-				NULL,				\
-				&resource,			\
-				"kasan_data", &fail_data);	\
-	barrier();						\
-	expression;						\
-	barrier();						\
-	if (kasan_async_mode_enabled())				\
-		kasan_force_async_fault();			\
-	barrier();						\
-	KUNIT_EXPECT_EQ(test,					\
-			READ_ONCE(fail_data.report_expected),	\
-			READ_ONCE(fail_data.report_found));	\
-	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&			\
-	    !kasan_async_mode_enabled()) {			\
-		if (READ_ONCE(fail_data.report_found))		\
-			kasan_enable_tagging_sync();		\
-		migrate_enable();				\
-	}							\
+#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {			\
+	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&				\
+	    !kasan_async_mode_enabled())				\
+		migrate_disable();					\
+	KUNIT_EXPECT_FALSE(test, READ_ONCE(fail_data.report_found));	\
+	WRITE_ONCE(fail_data.report_expected, true);			\
+	barrier();							\
+	expression;							\
+	barrier();							\
+	KUNIT_EXPECT_EQ(test,						\
+			READ_ONCE(fail_data.report_expected),		\
+			READ_ONCE(fail_data.report_found));		\
+	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS)) {				\
+		if (READ_ONCE(fail_data.report_found))			\
+			kasan_enable_tagging();				\
+		migrate_enable();					\
+	}								\
+	WRITE_ONCE(fail_data.report_found, false);			\
+	WRITE_ONCE(fail_data.report_expected, false);			\
 } while (0)
 
 #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {			\
_
