Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E6AC4332D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 332AE64F28
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbhBXUGu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235092AbhBXUGb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:06:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64DE164F1F;
        Wed, 24 Feb 2021 20:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197136;
        bh=Qiyegy6GgJrFfih/Z9Yl0FqPnozPTJKh2V4KK6EnueU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sDLxUSzWaDgoAk6jkLytx6fL8LafAqjLPJJwgPb8U8aaNvHpvOEEA79FiNryQyp8D
         b49F7/tZJEVXVevhVl3OWAJTBYhGNl+9d/XDSxZA7BbUmIoqW6nvRRd//ro6sJB6VY
         8ESm2ElurC4QfVW1/U2k3v0vg9Y9yNkaBw6OU9yM=
Date:   Wed, 24 Feb 2021 12:05:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 093/173] kasan: add compiler barriers to
 KUNIT_EXPECT_KASAN_FAIL
Message-ID: <20210224200534.sK9xuqhpq%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: add compiler barriers to KUNIT_EXPECT_KASAN_FAIL

It might not be obvious to the compiler that the expression must be
executed between writing and reading to fail_data. In this case, the
compiler might reorder or optimize away some of the accesses, and
the tests will fail.

Add compiler barriers around the expression in KUNIT_EXPECT_KASAN_FAIL
and use READ/WRITE_ONCE() for accessing fail_data fields.

Link: https://linux-review.googlesource.com/id/I046079f48641a1d36fe627fc8827a9249102fd50
Link: https://lkml.kernel.org/r/6f11596f367d8ae8f71d800351e9a5d91eda19f6.1610733117.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c  |   17 ++++++++++++-----
 mm/kasan/report.c |    2 +-
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/lib/test_kasan.c~kasan-add-compiler-barriers-to-kunit_expect_kasan_fail
+++ a/lib/test_kasan.c
@@ -68,23 +68,30 @@ static void kasan_test_exit(struct kunit
  * normally auto-disabled. When this happens, this test handler reenables
  * tag checking. As tag checking can be only disabled or enabled per CPU, this
  * handler disables migration (preemption).
+ *
+ * Since the compiler doesn't see that the expression can change the fail_data
+ * fields, it can reorder or optimize away the accesses to those fields.
+ * Use READ/WRITE_ONCE() for the accesses and compiler barriers around the
+ * expression to prevent that.
  */
 #define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {		\
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS))			\
 		migrate_disable();				\
-	fail_data.report_expected = true;			\
-	fail_data.report_found = false;				\
+	WRITE_ONCE(fail_data.report_expected, true);		\
+	WRITE_ONCE(fail_data.report_found, false);		\
 	kunit_add_named_resource(test,				\
 				NULL,				\
 				NULL,				\
 				&resource,			\
 				"kasan_data", &fail_data);	\
+	barrier();						\
 	expression;						\
+	barrier();						\
 	KUNIT_EXPECT_EQ(test,					\
-			fail_data.report_expected,		\
-			fail_data.report_found);		\
+			READ_ONCE(fail_data.report_expected),	\
+			READ_ONCE(fail_data.report_found));	\
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS)) {			\
-		if (fail_data.report_found)			\
+		if (READ_ONCE(fail_data.report_found))		\
 			kasan_enable_tagging();			\
 		migrate_enable();				\
 	}							\
--- a/mm/kasan/report.c~kasan-add-compiler-barriers-to-kunit_expect_kasan_fail
+++ a/mm/kasan/report.c
@@ -331,7 +331,7 @@ static void kasan_update_kunit_status(st
 	}
 
 	kasan_data = (struct kunit_kasan_expectation *)resource->data;
-	kasan_data->report_found = true;
+	WRITE_ONCE(kasan_data->report_found, true);
 	kunit_put_resource(resource);
 }
 #endif /* IS_ENABLED(CONFIG_KUNIT) */
_
