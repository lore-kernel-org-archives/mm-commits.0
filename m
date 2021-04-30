Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1639C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864FC61483
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhD3GB3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhD3GB3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F07461482;
        Fri, 30 Apr 2021 06:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762440;
        bh=s/UdawWteAsAtNp9fSZCySBSnSFxJVPUfZXfbTqZUbw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Vbsrhbzna1dt+mL+HzV84U+aHCNHuQQxVwWDoiBb53CqZqQEiXAIefkufNuSVVWIp
         JGP6mQeCHlcDUlQIzyyWynqLsZlJm8WSHQTX9iZJJTf+Ztl4e2NlH7AEXPTnEHM4MC
         8FTNga33Iv17nn5Gq+4kEDswzOdyErStUAMi6XkI=
Date:   Thu, 29 Apr 2021 23:00:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 145/178] kasan: docs: update ignoring accesses
 section
Message-ID: <20210430060039.NQHzrzXmr%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: docs: update ignoring accesses section

Update the "Ignoring accesses" section in KASAN documentation:

- Mention __no_sanitize_address/noinstr.
- Mention kasan_disable/enable_current().
- Mention kasan_reset_tag()/page_kasan_tag_reset().
- Readability and punctuation clean-ups.

Link: https://lkml.kernel.org/r/4531ba5f3eca61f6aade863c136778cc8c807a64.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   34 ++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-ignoring-accesses-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -377,12 +377,18 @@ Ignoring accesses
 ~~~~~~~~~~~~~~~~~
 
 Software KASAN modes use compiler instrumentation to insert validity checks.
-Such instrumentation might be incompatible with some part of the kernel, and
-therefore needs to be disabled. To disable instrumentation for specific files
-or directories, add a line similar to the following to the respective kernel
+Such instrumentation might be incompatible with some parts of the kernel, and
+therefore needs to be disabled.
+
+Other parts of the kernel might access metadata for allocated objects.
+Normally, KASAN detects and reports such accesses, but in some cases (e.g.,
+in memory allocators), these accesses are valid.
+
+For software KASAN modes, to disable instrumentation for a specific file or
+directory, add a ``KASAN_SANITIZE`` annotation to the respective kernel
 Makefile:
 
-- For a single file (e.g. main.o)::
+- For a single file (e.g., main.o)::
 
     KASAN_SANITIZE_main.o := n
 
@@ -390,6 +396,26 @@ Makefile:
 
     KASAN_SANITIZE := n
 
+For software KASAN modes, to disable instrumentation on a per-function basis,
+use the KASAN-specific ``__no_sanitize_address`` function attribute or the
+generic ``noinstr`` one.
+
+Note that disabling compiler instrumentation (either on a per-file or a
+per-function basis) makes KASAN ignore the accesses that happen directly in
+that code for software KASAN modes. It does not help when the accesses happen
+indirectly (through calls to instrumented functions) or with the hardware
+tag-based mode that does not use compiler instrumentation.
+
+For software KASAN modes, to disable KASAN reports in a part of the kernel code
+for the current task, annotate this part of the code with a
+``kasan_disable_current()``/``kasan_enable_current()`` section. This also
+disables the reports for indirect accesses that happen through function calls.
+
+For tag-based KASAN modes (include the hardware one), to disable access
+checking, use ``kasan_reset_tag()`` or ``page_kasan_tag_reset()``. Note that
+temporarily disabling access checking via ``page_kasan_tag_reset()`` requires
+saving and restoring the per-page KASAN tag via
+``page_kasan_tag``/``page_kasan_tag_set``.
 
 Tests
 ~~~~~
_
