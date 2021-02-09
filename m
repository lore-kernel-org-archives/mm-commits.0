Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB09FC433E0
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 22:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B628A64DEE
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 22:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhBIW3B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 17:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233980AbhBIWMQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 17:12:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEF2264ECD;
        Tue,  9 Feb 2021 21:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906924;
        bh=xZSowleWtaeqZhTcDcTbm/BmRYYIaEdtQV2EpoetsNs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nV+9eYMoxV4NqeQMiHsE9JGOu1mmKzHislOrDKf4XaEgjllLvSdR4ykFOWOS57QJg
         EiEz7zomJ7pGjYWl2NU6LbMzV7rsioX9S+qB/xSQ8EUd5aIeRGgEVaedQhSruhoSA3
         x8k+lyWyg/jTIkgcutit3hb2im/uyQXlduEyN2CI=
Date:   Tue, 09 Feb 2021 13:42:03 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 05/14] kasan: fix stack traces dependency for
 HW_TAGS
Message-ID: <20210209214203.tt68YEBnH%akpm@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix stack traces dependency for HW_TAGS

Currently, whether the alloc/free stack traces collection is enabled by
default for hardware tag-based KASAN depends on CONFIG_DEBUG_KERNEL.  The
intention for this dependency was to only enable collection on slow debug
kernels due to a significant perf and memory impact.

As it turns out, CONFIG_DEBUG_KERNEL is not considered a debug option and
is enabled on many productions kernels including Android and Ubuntu.  As
the result, this dependency is pointless and only complicates the code and
documentation.

Having stack traces collection disabled by default would make the hardware
mode work differently to to the software ones, which is confusing.

This change removes the dependency and enables stack traces collection by
default.

Looking into the future, this default might makes sense for production
kernels, assuming we implement a fast stack trace collection approach.

Link: https://lkml.kernel.org/r/6678d77ceffb71f1cff2cf61560e2ffe7bb6bfe9.1612808820.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    3 +--
 mm/kasan/hw_tags.c                |    8 ++------
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-fix-stack-traces-dependency-for-hw_tags
+++ a/Documentation/dev-tools/kasan.rst
@@ -163,8 +163,7 @@ particular KASAN features.
 - ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
 
 - ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
-  traces collection (default: ``on`` for ``CONFIG_DEBUG_KERNEL=y``, otherwise
-  ``off``).
+  traces collection (default: ``on``).
 
 - ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
   report or also panic the kernel (default: ``report``).
--- a/mm/kasan/hw_tags.c~kasan-fix-stack-traces-dependency-for-hw_tags
+++ a/mm/kasan/hw_tags.c
@@ -134,12 +134,8 @@ void __init kasan_init_hw_tags(void)
 
 	switch (kasan_arg_stacktrace) {
 	case KASAN_ARG_STACKTRACE_DEFAULT:
-		/*
-		 * Default to enabling stack trace collection for
-		 * debug kernels.
-		 */
-		if (IS_ENABLED(CONFIG_DEBUG_KERNEL))
-			static_branch_enable(&kasan_flag_stacktrace);
+		/* Default to enabling stack trace collection. */
+		static_branch_enable(&kasan_flag_stacktrace);
 		break;
 	case KASAN_ARG_STACKTRACE_OFF:
 		/* Do nothing, kasan_flag_stacktrace keeps its default value. */
_
