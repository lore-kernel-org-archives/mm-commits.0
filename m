Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD4AC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A5061955
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhGFTQQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231740AbhGFTQP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B4136128D;
        Tue,  6 Jul 2021 19:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598816;
        bh=JUwOAJi/YpRlC+mcZKgDrwl0RnLf9eyO3PHDXa7cV8U=;
        h=Date:From:To:Subject:From;
        b=Wpmjxo8PY9u66KSm48HHJmdtHLfGPhD1QMQxAjGiZAa5Zkyzp0iGmVg14zAMh0V2C
         fhxuUgevpCtvlLtA+15J50VtBnhrdKmhlPAhiTtYkhtz/RDPth2EXAV8d+lh9FIpjx
         kiH5QKRtDsUSIA/6/4vv0w1nk7YWLqqAYjMWlPYw=
Date:   Tue, 06 Jul 2021 12:13:36 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, brendanhiggins@google.com, corbet@lwn.net,
        davidgow@google.com, dja@axtens.net, dvyukov@google.com,
        elver@google.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com
Subject:  [merged]
 kasan-test-improve-failure-message-in-kunit_expect_kasan_fail.patch removed
 from -mm tree
Message-ID: <20210706191336.gR5zSuEGU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: improve failure message in KUNIT_EXPECT_KASAN_FAIL()
has been removed from the -mm tree.  Its filename was
     kasan-test-improve-failure-message-in-kunit_expect_kasan_fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Gow <davidgow@google.com>
Subject: kasan: test: improve failure message in KUNIT_EXPECT_KASAN_FAIL()

The KUNIT_EXPECT_KASAN_FAIL() macro currently uses KUNIT_EXPECT_EQ() to
compare fail_data.report_expected and fail_data.report_found.  This always
gave a somewhat useless error message on failure, but the addition of
extra compile-time checking with READ_ONCE() has caused it to get much
longer, and be truncated before anything useful is displayed.

Instead, just check fail_data.report_found by hand (we've just set
report_expected to 'true'), and print a better failure message with
KUNIT_FAIL().  Because of this, report_expected is no longer used
anywhere, and can be removed.

Beforehand, a failure in:
KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)area)[3100]);
would have looked like:
[22:00:34] [FAILED] vmalloc_oob
[22:00:34]     # vmalloc_oob: EXPECTATION FAILED at lib/test_kasan.c:991
[22:00:34]     Expected ({ do { extern void __compiletime_assert_705(void) __attribute__((__error__("Unsupported access size for {READ,WRITE}_ONCE()."))); if (!((sizeof(fail_data.report_expected) == sizeof(char) || sizeof(fail_data.repp
[22:00:34]     not ok 45 - vmalloc_oob

With this change, it instead looks like:
[22:04:04] [FAILED] vmalloc_oob
[22:04:04]     # vmalloc_oob: EXPECTATION FAILED at lib/test_kasan.c:993
[22:04:04]     KASAN failure expected in "((volatile char *)area)[3100]", but none occurred
[22:04:04]     not ok 45 - vmalloc_oob

Also update the example failure in the documentation to reflect this.

Link: https://lkml.kernel.org/r/20210606005531.165954-1-davidgow@google.com
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    9 ++++-----
 include/linux/kasan.h             |    1 -
 lib/test_kasan.c                  |   11 +++++------
 3 files changed, 9 insertions(+), 12 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-test-improve-failure-message-in-kunit_expect_kasan_fail
+++ a/Documentation/dev-tools/kasan.rst
@@ -447,11 +447,10 @@ When a test fails due to a failed ``kmal
 
 When a test fails due to a missing KASAN report::
 
-        # kmalloc_double_kzfree: EXPECTATION FAILED at lib/test_kasan.c:629
-        Expected kasan_data->report_expected == kasan_data->report_found, but
-        kasan_data->report_expected == 1
-        kasan_data->report_found == 0
-        not ok 28 - kmalloc_double_kzfree
+        # kmalloc_double_kzfree: EXPECTATION FAILED at lib/test_kasan.c:974
+        KASAN failure expected in "kfree_sensitive(ptr)", but none occurred
+        not ok 44 - kmalloc_double_kzfree
+
 
 At the end the cumulative status of all KASAN tests is printed. On success::
 
--- a/include/linux/kasan.h~kasan-test-improve-failure-message-in-kunit_expect_kasan_fail
+++ a/include/linux/kasan.h
@@ -17,7 +17,6 @@ struct task_struct;
 
 /* kasan_data struct is used in KUnit tests for KASAN expected failures */
 struct kunit_kasan_expectation {
-	bool report_expected;
 	bool report_found;
 };
 
--- a/lib/test_kasan.c~kasan-test-improve-failure-message-in-kunit_expect_kasan_fail
+++ a/lib/test_kasan.c
@@ -55,7 +55,6 @@ static int kasan_test_init(struct kunit
 	multishot = kasan_save_enable_multi_shot();
 	kasan_set_tagging_report_once(false);
 	fail_data.report_found = false;
-	fail_data.report_expected = false;
 	kunit_add_named_resource(test, NULL, NULL, &resource,
 					"kasan_data", &fail_data);
 	return 0;
@@ -94,20 +93,20 @@ static void kasan_test_exit(struct kunit
 	    !kasan_async_mode_enabled())				\
 		migrate_disable();					\
 	KUNIT_EXPECT_FALSE(test, READ_ONCE(fail_data.report_found));	\
-	WRITE_ONCE(fail_data.report_expected, true);			\
 	barrier();							\
 	expression;							\
 	barrier();							\
-	KUNIT_EXPECT_EQ(test,						\
-			READ_ONCE(fail_data.report_expected),		\
-			READ_ONCE(fail_data.report_found));		\
+	if (!READ_ONCE(fail_data.report_found)) {			\
+		KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN failure "	\
+				"expected in \"" #expression		\
+				 "\", but none occurred");		\
+	}								\
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS)) {				\
 		if (READ_ONCE(fail_data.report_found))			\
 			kasan_enable_tagging_sync();			\
 		migrate_enable();					\
 	}								\
 	WRITE_ONCE(fail_data.report_found, false);			\
-	WRITE_ONCE(fail_data.report_expected, false);			\
 } while (0)
 
 #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {			\
_

Patches currently in -mm which might be from davidgow@google.com are


