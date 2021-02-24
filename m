Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0765BC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8F3564F23
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbhBXUHL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhBXUGx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:06:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BB6664F0C;
        Wed, 24 Feb 2021 20:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197164;
        bh=qw9ptL7Cnw4elSq3daOYS3InTUivIfyhGpsiItG/Ub4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nTIFO2KC6jeZYIbqNAvBnC08GwHIkzy/kbuUSxjTD9v2R1YYSP7N8T4X4b6+zEsWY
         VW4mtLTcJpVQLDP6YfeAfY+BatsBRJlOU3YNVCH4uz4P1YM/MjLeE13UtsoZnEHaTY
         xLP8nCd/XGQonaFLYeoJ9DKpWYYWpt3E8Vn8mFfo=
Date:   Wed, 24 Feb 2021 12:06:02 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 100/173] kasan: don't run tests when KASAN is not
 enabled
Message-ID: <20210224200602.U_Wshqs7c%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
