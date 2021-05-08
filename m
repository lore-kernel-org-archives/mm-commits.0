Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF2DC43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D51B4613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhEHWpo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWpn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F30A61402;
        Sat,  8 May 2021 22:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513881;
        bh=O60Apl7954ZCyeeBqInAjbWDVVV9VjS1Ks0ohugdte4=;
        h=Date:From:To:Subject:From;
        b=muYktO2oiVQJqW0L4DVBs7TEDGBBRGXJQZGSUK+S5s/rOelr8I0IgkvpVBPkkRQmO
         Yi7uRigziZuacqBJFNsy8eMQZtrhZ40BU2vgft5QJS2BTC5raKxWZFmqeli4R73uFR
         5KfuOsAR1GXtbq+rnA/mKbbVQIGLvYa+6GO3vfU8=
Date:   Sat, 08 May 2021 15:44:41 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged] kasan-detect-false-positives-in-tests.patch
 removed from -mm tree
Message-ID: <20210508224441.DYXtzm18c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: detect false-positives in tests
has been removed from the -mm tree.  Its filename was
     kasan-detect-false-positives-in-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
+			kasan_enable_tagging_sync();			\
+		migrate_enable();					\
+	}								\
+	WRITE_ONCE(fail_data.report_found, false);			\
+	WRITE_ONCE(fail_data.report_expected, false);			\
 } while (0)
 
 #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {			\
_

Patches currently in -mm which might be from andreyknvl@google.com are


