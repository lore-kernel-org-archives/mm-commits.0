Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4654C433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADE4E64F38
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhB0Ccn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229795AbhB0CcW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D96564F3D;
        Sat, 27 Feb 2021 02:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393095;
        bh=dNCXYYlrM1ZLueEfMwaqjfItJleTBWiwKc1B7MsWsb8=;
        h=Date:From:To:Subject:From;
        b=ENZKer9EbwdoRZFwDnMWc/cg3M8hnB9Mw9gUI6ckrxpPHqXTt0PrYRpQ53qJdNHOC
         lnH+Mler2UHtU9lJGySrUvD48sHT6ewOmxo1Hj9mXeglYQOcX0GFhzN9MIixRR1zTe
         FS9WJ7zSL99MG9DrI1KCk+xtK+z2Rk/dry/0QFBM=
Date:   Fri, 26 Feb 2021 18:31:35 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch removed from
 -mm tree
Message-ID: <20210227023135.Lz9nynlXz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: clarify that only first bug is reported in HW_TAGS
has been removed from the -mm tree.  Its filename was
     kasan-clarify-that-only-first-bug-is-reported-in-hw_tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clarify that only first bug is reported in HW_TAGS

Hwardware tag-based KASAN only reports the first found bug. After that MTE
tag checking gets disabled. Clarify this in comments and documentation.

Link: https://lkml.kernel.org/r/00383ba88a47c3f8342d12263c24bdf95527b07d.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
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

 Documentation/dev-tools/kasan.rst |    8 ++++++--
 mm/kasan/hw_tags.c                |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-clarify-that-only-first-bug-is-reported-in-hw_tags
+++ a/Documentation/dev-tools/kasan.rst
@@ -155,7 +155,7 @@ Boot parameters
 ~~~~~~~~~~~~~~~
 
 Hardware tag-based KASAN mode (see the section about various modes below) is
-intended for use in production as a security mitigation. Therefore it supports
+intended for use in production as a security mitigation. Therefore, it supports
 boot parameters that allow to disable KASAN competely or otherwise control
 particular KASAN features.
 
@@ -165,7 +165,8 @@ particular KASAN features.
   traces collection (default: ``on``).
 
 - ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
-  report or also panic the kernel (default: ``report``).
+  report or also panic the kernel (default: ``report``). Note, that tag
+  checking gets disabled after the first reported bug.
 
 For developers
 ~~~~~~~~~~~~~~
@@ -295,6 +296,9 @@ Note, that enabling CONFIG_KASAN_HW_TAGS
 enabled. Even when kasan.mode=off is provided, or when the hardware doesn't
 support MTE (but supports TBI).
 
+Hardware tag-based KASAN only reports the first found bug. After that MTE tag
+checking gets disabled.
+
 What memory accesses are sanitised by KASAN?
 --------------------------------------------
 
--- a/mm/kasan/hw_tags.c~kasan-clarify-that-only-first-bug-is-reported-in-hw_tags
+++ a/mm/kasan/hw_tags.c
@@ -48,7 +48,7 @@ EXPORT_SYMBOL(kasan_flag_enabled);
 /* Whether to collect alloc/free stack traces. */
 DEFINE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
 
-/* Whether panic or disable tag checking on fault. */
+/* Whether to panic or print a report and disable tag checking on fault. */
 bool kasan_flag_panic __ro_after_init;
 
 /* kasan=off/on */
_

Patches currently in -mm which might be from andreyknvl@google.com are


