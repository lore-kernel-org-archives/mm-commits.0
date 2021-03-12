Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF44BC43381
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D624964F77
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhCLSgk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:36:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233554AbhCLSgT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:36:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3FE664F69;
        Fri, 12 Mar 2021 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615574179;
        bh=S3Jl28OZTDWKPeFq/XvyobRjYoqmvBpCuIpCkxRJ+MU=;
        h=Date:From:To:Subject:From;
        b=BQmR2v+3hYoEj5p0oa/apJjbeqUv7gXfxgGwB0+7DvJH8O72pH8VqWFyiREQHhUaY
         1NwJTURoOnnli7jmI6htDZ+KeQBC9SI7rIEuHWGJl4cbcX35a0vVzcfChcZ5P+6OJP
         p9grPR5i6nAdwFLT9LX2DnsodJyJmiDID6b4dZBs=
Date:   Fri, 12 Mar 2021 10:36:18 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  + kasan-docs-update-ignoring-accesses-section.patch added
 to -mm tree
Message-ID: <20210312183618.wottRzX3n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update ignoring accesses section
has been added to the -mm tree.  Its filename is
     kasan-docs-update-ignoring-accesses-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-docs-update-ignoring-accesses-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-docs-update-ignoring-accesses-section.patch

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
@@ -368,12 +368,18 @@ Ignoring accesses
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
 
@@ -381,6 +387,26 @@ Makefile:
 
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

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
kasan-fix-kasan_stack-dependency-for-hw_tags.patch
kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
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

