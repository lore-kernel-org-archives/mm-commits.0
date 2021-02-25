Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F53C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99CA64F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhBYTad (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:30:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234477AbhBYT1x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B298964F8E;
        Thu, 25 Feb 2021 19:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280561;
        bh=mxbSSshEuagEcSeZ76dsBOIosCdN0vF505WQce6oOoc=;
        h=Date:From:To:Subject:From;
        b=UY1tCfW96+1rxT4l+2LyaTVwJ4jcsEUj5GAseuZnbU2sh+3z8qFXJR4gcjCHSqtAy
         CCD9Km6qlu/oW+VA/ruB2CVGnv7Ip+byYfmTuWv1hQOjgFbXOrmnAvxRKDtIrfvvth
         y7yI+nhLW1ICzimnKTxmhCCVZt09TWuzdwD5oSnw=
Date:   Thu, 25 Feb 2021 11:16:00 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-dont-run-tests-when-kasan-is-not-enabled.patch removed from -mm tree
Message-ID: <20210225191600.1GYY2Uv7o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: don't run tests when KASAN is not enabled
has been removed from the -mm tree.  Its filename was
     kasan-dont-run-tests-when-kasan-is-not-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: don't run tests when KASAN is not enabled

Don't run KASAN tests when it's disabled with kasan.mode=off to avoid
corrupting kernel memory.

Link: https://linux-review.googlesource.com/id/I6447af436a69a94bfc35477f6bf4e2122948355e
Link: https://lkml.kernel.org/r/25bd4fb5cae7b421d806a1f33fb633edd313f0c7.1610733117.git.andreyknvl@google.com
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

 lib/test_kasan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/lib/test_kasan.c~kasan-dont-run-tests-when-kasan-is-not-enabled
+++ a/lib/test_kasan.c
@@ -47,6 +47,11 @@ static bool multishot;
  */
 static int kasan_test_init(struct kunit *test)
 {
+	if (!kasan_enabled()) {
+		kunit_err(test, "can't run KASAN tests with KASAN disabled");
+		return -1;
+	}
+
 	multishot = kasan_save_enable_multi_shot();
 	kasan_set_tagging_report_once(false);
 	return 0;
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

