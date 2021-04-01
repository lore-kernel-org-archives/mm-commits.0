Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9268C433B4
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91679610A2
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhDAAUi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230349AbhDAAUg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 20:20:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B67F9610A2;
        Thu,  1 Apr 2021 00:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617236436;
        bh=Rwf64uFcZOkTjiIIGrpZGaWyRXJH1/OiFz4qWBSKO4Q=;
        h=Date:From:To:Subject:From;
        b=nZ5ih+UOjr57Co/BkMvNT6ecWmkfLarVgH6wZrbivCZ9cqUmJX2EPLnGEoeLd55U9
         yHORak0H1xPhwmwjEzAGNEs2dJZrfhCGWZ15Y1mSYKDzNUKJBGSgMWhPiA3iJYW14m
         STaLSb6q3pP5beIjhtLR3U0lg6FS2CftWJzeCKD4=
Date:   Wed, 31 Mar 2021 17:20:35 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  + kasan-detect-false-positives-in-tests.patch added to
 -mm tree
Message-ID: <20210401002035.VGIyVMskW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: detect false-positives in tests
has been added to the -mm tree.  Its filename is
     kasan-detect-false-positives-in-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-detect-false-positives-in-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-detect-false-positives-in-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 lib/test_kasan.c |   49 +++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

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
@@ -78,28 +83,30 @@ static void kasan_test_exit(struct kunit
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
-	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS))			\
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
-	KUNIT_EXPECT_EQ(test,					\
-			READ_ONCE(fail_data.report_expected),	\
-			READ_ONCE(fail_data.report_found));	\
-	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS)) {			\
-		if (READ_ONCE(fail_data.report_found))		\
-			kasan_enable_tagging();			\
-		migrate_enable();				\
-	}							\
+#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {			\
+	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS))				\
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

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-conflict-with-page-poisoning.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch
kasan-docs-clean-up-sections.patch
kasan-docs-update-overview-section.patch
kasan-docs-update-usage-section.patch
kasan-docs-update-error-reports-section.patch
kasan-docs-update-boot-parameters-section.patch
kasan-docs-update-generic-implementation-details-section.patch
kasan-docs-update-sw_tags-implementation-details-section.patch
kasan-docs-update-hw_tags-implementation-details-section.patch
kasan-docs-update-shadow-memory-section.patch
kasan-docs-update-ignoring-accesses-section.patch
kasan-docs-update-tests-section.patch
kasan-detect-false-positives-in-tests.patch

