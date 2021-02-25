Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F197CC4332D
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C454864F4F
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhBYT2b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:28:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234339AbhBYT0L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:26:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDE3064F86;
        Thu, 25 Feb 2021 19:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280540;
        bh=Un2AnMOeoukgNsu8/EF+dgS0jbwxqXBHPtTgPAHmBWQ=;
        h=Date:From:To:Subject:From;
        b=dR8UYFFBsbY4Ne8fC1Jp7CAbqH/FsrHrl4bFVUj2sTP58c58lOJANA2XeMCGCBecB
         LqSo/mgdM3yJ3R+V4dMZsWcn9vxapfhvI/DpiADGuwvjk/vWiECJsSU2R+5E+BplR7
         6C5faNWpMuyTAbQ9hAqr5UXGJ2ZMMwDX6Bmlwv2k=
Date:   Thu, 25 Feb 2021 11:15:39 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch removed from
 -mm tree
Message-ID: <20210225191539.JblozxCMr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add compiler barriers to KUNIT_EXPECT_KASAN_FAIL
has been removed from the -mm tree.  Its filename was
     kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are

kfence-kasan-make-kfence-compatible-with-kasan-fix-2.patch
kasan-mm-dont-save-alloc-stacks-twice.patch
kasan-mm-optimize-kmalloc-poisoning.patch
kasan-optimize-large-kmalloc-poisoning.patch
kasan-clean-up-setting-free-info-in-kasan_slab_free.patch
kasan-unify-large-kfree-checks.patch
kasan-rework-krealloc-tests.patch
kasan-mm-fail-krealloc-on-freed-objects.patch
kasan-mm-optimize-krealloc-poisoning.patch
kasan-ensure-poisoning-size-alignment.patch
arm64-kasan-simplify-and-inline-mte-functions.patch
kasan-inline-hw_tags-helper-functions.patch
kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

