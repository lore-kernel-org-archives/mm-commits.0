Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD04C43331
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19F9464F5D
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhCLSgi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233823AbhCLSgL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:36:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC4664F5D;
        Fri, 12 Mar 2021 18:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615574171;
        bh=j1IQF1rTKOvpnoP0XTJo9Ds972rTNftOL3Y9jBgES3w=;
        h=Date:From:To:Subject:From;
        b=Ah6kiLyQ2cV93XIrJf9SMCJGAbs0i8FMJoYlOPF1h2I8EYdnSz5HgMcfwFkoLj5ar
         rIIqzlwP4l64EjftpCxzMJclYsxB5d5QMhozliFXDaX2mbOnm05492P0KIfKeTzFBG
         2FPSnz7eM0pA0t/JYdts02Sb7zK93QjkQuI6WxLw=
Date:   Fri, 12 Mar 2021 10:36:10 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  +
 kasan-docs-update-sw_tags-implementation-details-section.patch added to -mm
 tree
Message-ID: <20210312183610.DVvK6QA9A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update SW_TAGS implementation details section
has been added to the -mm tree.  Its filename is
     kasan-docs-update-sw_tags-implementation-details-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-docs-update-sw_tags-implementation-details-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-docs-update-sw_tags-implementation-details-section.patch

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
Subject: kasan: docs: update SW_TAGS implementation details section

Update the "Implementation details" section for SW_TAGS KASAN:

- Clarify the introduction sentence.
- Punctuation, readability, and other minor clean-ups.

Link: https://lkml.kernel.org/r/69b9b2e49d8cf789358fa24558be3fc0ce4ee32c.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   39 +++++++++++++---------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-sw_tags-implementation-details-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -235,38 +235,37 @@ quarantine (see mm/kasan/quarantine.c fo
 Software tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
-Software tag-based KASAN requires software memory tagging support in the form
-of HWASan-like compiler instrumentation (see HWASan documentation for details).
-
-Software tag-based KASAN is currently only implemented for arm64 architecture.
+Software tag-based KASAN uses a software memory tagging approach to checking
+access validity. It is currently only implemented for the arm64 architecture.
 
 Software tag-based KASAN uses the Top Byte Ignore (TBI) feature of arm64 CPUs
-to store a pointer tag in the top byte of kernel pointers. Like generic KASAN
-it uses shadow memory to store memory tags associated with each 16-byte memory
-cell (therefore it dedicates 1/16th of the kernel memory for shadow memory).
+to store a pointer tag in the top byte of kernel pointers. It uses shadow memory
+to store memory tags associated with each 16-byte memory cell (therefore, it
+dedicates 1/16th of the kernel memory for shadow memory).
 
-On each memory allocation software tag-based KASAN generates a random tag, tags
-the allocated memory with this tag, and embeds this tag into the returned
+On each memory allocation, software tag-based KASAN generates a random tag, tags
+the allocated memory with this tag, and embeds the same tag into the returned
 pointer.
 
 Software tag-based KASAN uses compile-time instrumentation to insert checks
-before each memory access. These checks make sure that tag of the memory that
-is being accessed is equal to tag of the pointer that is used to access this
-memory. In case of a tag mismatch software tag-based KASAN prints a bug report.
+before each memory access. These checks make sure that the tag of the memory
+that is being accessed is equal to the tag of the pointer that is used to access
+this memory. In case of a tag mismatch, software tag-based KASAN prints a bug
+report.
 
-Software tag-based KASAN also has two instrumentation modes (outline, that
-emits callbacks to check memory accesses; and inline, that performs the shadow
+Software tag-based KASAN also has two instrumentation modes (outline, which
+emits callbacks to check memory accesses; and inline, which performs the shadow
 memory checks inline). With outline instrumentation mode, a bug report is
-simply printed from the function that performs the access check. With inline
-instrumentation a brk instruction is emitted by the compiler, and a dedicated
-brk handler is used to print bug reports.
+printed from the function that performs the access check. With inline
+instrumentation, a ``brk`` instruction is emitted by the compiler, and a
+dedicated ``brk`` handler is used to print bug reports.
 
 Software tag-based KASAN uses 0xFF as a match-all pointer tag (accesses through
-pointers with 0xFF pointer tag aren't checked). The value 0xFE is currently
+pointers with the 0xFF pointer tag are not checked). The value 0xFE is currently
 reserved to tag freed memory regions.
 
-Software tag-based KASAN currently only supports tagging of
-kmem_cache_alloc/kmalloc and page_alloc memory.
+Software tag-based KASAN currently only supports tagging of slab and page_alloc
+memory.
 
 Hardware tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
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

