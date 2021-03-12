Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BCAC433E9
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B882E64F72
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhCLSgi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233814AbhCLSgJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:36:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E006364DEC;
        Fri, 12 Mar 2021 18:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615574169;
        bh=npUX6DuOe6e+ux1TE7oqvoiKOxAHNOz7f21QQ7S9C+U=;
        h=Date:From:To:Subject:From;
        b=yc80s3qpfsujYq8v8D7Vzy3qR9atepQqJ7WeIMSdg6zZX1gxRPtYiN7ZA6rZ30ruz
         CJX8XGwB5ZF+AVUn33+qVECbdIRy/fWptiU7tO1NSAdMN7QzJtXJKgmF82pYnlbZZW
         qedZMcpjxLi64etZjvbnz5MU/4kTAPqzbc09zPAc=
Date:   Fri, 12 Mar 2021 10:36:08 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  +
 kasan-docs-update-generic-implementation-details-section.patch added to -mm
 tree
Message-ID: <20210312183608.t-eMwh1r6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update GENERIC implementation details section
has been added to the -mm tree.  Its filename is
     kasan-docs-update-generic-implementation-details-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-docs-update-generic-implementation-details-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-docs-update-generic-implementation-details-section.patch

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
Subject: kasan: docs: update GENERIC implementation details section

Update the "Implementation details" section for generic KASAN:

- Don't mention kmemcheck, it's not present in the kernel anymore.
- Don't mention GCC as the only supported compiler.
- Update kasan_mem_to_shadow() definition to match actual code.
- Punctuation, readability, and other minor clean-ups.

Link: https://lkml.kernel.org/r/f2f35fdab701f8c709f63d328f98aec2982c8acc.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   29 +++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-generic-implementation-details-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -200,12 +200,11 @@ Implementation details
 Generic KASAN
 ~~~~~~~~~~~~~
 
-From a high level perspective, KASAN's approach to memory error detection is
-similar to that of kmemcheck: use shadow memory to record whether each byte of
-memory is safe to access, and use compile-time instrumentation to insert checks
-of shadow memory on each memory access.
+Software KASAN modes use shadow memory to record whether each byte of memory is
+safe to access and use compile-time instrumentation to insert shadow memory
+checks before each memory access.
 
-Generic KASAN dedicates 1/8th of kernel memory to its shadow memory (e.g. 16TB
+Generic KASAN dedicates 1/8th of kernel memory to its shadow memory (16TB
 to cover 128TB on x86_64) and uses direct mapping with a scale and offset to
 translate a memory address to its corresponding shadow address.
 
@@ -214,23 +213,23 @@ address::
 
     static inline void *kasan_mem_to_shadow(const void *addr)
     {
-	return ((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
+	return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
 		+ KASAN_SHADOW_OFFSET;
     }
 
 where ``KASAN_SHADOW_SCALE_SHIFT = 3``.
 
 Compile-time instrumentation is used to insert memory access checks. Compiler
-inserts function calls (__asan_load*(addr), __asan_store*(addr)) before each
-memory access of size 1, 2, 4, 8 or 16. These functions check whether memory
-access is valid or not by checking corresponding shadow memory.
-
-GCC 5.0 has possibility to perform inline instrumentation. Instead of making
-function calls GCC directly inserts the code to check the shadow memory.
-This option significantly enlarges kernel but it gives x1.1-x2 performance
-boost over outline instrumented kernel.
+inserts function calls (``__asan_load*(addr)``, ``__asan_store*(addr)``) before
+each memory access of size 1, 2, 4, 8, or 16. These functions check whether
+memory accesses are valid or not by checking corresponding shadow memory.
+
+With inline instrumentation, instead of making function calls, the compiler
+directly inserts the code to check shadow memory. This option significantly
+enlarges the kernel, but it gives an x1.1-x2 performance boost over the
+outline-instrumented kernel.
 
-Generic KASAN is the only mode that delays the reuse of freed object via
+Generic KASAN is the only mode that delays the reuse of freed objects via
 quarantine (see mm/kasan/quarantine.c for implementation).
 
 Software tag-based KASAN
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

