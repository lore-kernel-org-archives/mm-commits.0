Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E737AC43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA200613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhEHWpi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWpg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EB9C613EA;
        Sat,  8 May 2021 22:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513874;
        bh=gdoRmAsYpo45S+Hd+7/hz+BI4NFCKtITCNwhJDjVFLU=;
        h=Date:From:To:Subject:From;
        b=CeJ6Y6JcJkJia5j4EU2AhZLbnDBJokiiMk0LuSg7cyLMBptXyVJNMQToesFhRsSX5
         4sN1JNrNMTxfheqIY/gd/58HocDVhTKet1qbkQuu4CrrWX6eXXsqUuQBhiDc+VY1P4
         KwBgC1Toyfh38jK7N5wgyitHe1hCU6gaL8IDf9aw=
Date:   Sat, 08 May 2021 15:44:34 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 kasan-docs-update-ignoring-accesses-section.patch removed from -mm tree
Message-ID: <20210508224434.56CutwvjI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update ignoring accesses section
has been removed from the -mm tree.  Its filename was
     kasan-docs-update-ignoring-accesses-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from andreyknvl@google.com are


