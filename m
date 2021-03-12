Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09521C4332B
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4F3864F69
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbhCLSgk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:36:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233846AbhCLSgR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:36:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C6F64F5D;
        Fri, 12 Mar 2021 18:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615574177;
        bh=4gjBYxasksoSoQ8CWixv3RmIfiKXXdwuAjhUy0RWjpg=;
        h=Date:From:To:Subject:From;
        b=z3KrUaEuo8K4V7wxmXXdB7e8NTfsQ5KKSViGef+Jl1Xgev+xP7TQtrPDTneIhQB9g
         y3wGWZPfkC6g5JgdzhgDjvZ3h2cLCYbASHss+gxRLbHdlpVhX7KpK40Fmx0csg46wN
         FwOLgnNqmuNAKQsRC4OTgl4RUKecwrRtHC8gtNDM=
Date:   Fri, 12 Mar 2021 10:36:16 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  + kasan-docs-update-shadow-memory-section.patch added to
 -mm tree
Message-ID: <20210312183616.vZ_e1qSKm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update shadow memory section
has been added to the -mm tree.  Its filename is
     kasan-docs-update-shadow-memory-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-docs-update-shadow-memory-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-docs-update-shadow-memory-section.patch

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
Subject: kasan: docs: update shadow memory section

Update the "Shadow memory" section in KASAN documentation:

- Rearrange the introduction paragraph do it doesn't give a
  "KASAN has an issue" impression.
- Update the list of architectures with vmalloc support.
- Punctuation, readability, and other minor clean-ups.

Link: https://lkml.kernel.org/r/00f8c38b0fd5290a3f4dced04eaba41383e67e14.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   31 ++++++++++++----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-shadow-memory-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -304,14 +304,11 @@ checking gets disabled.
 Shadow memory
 -------------
 
-The kernel maps memory in a number of different parts of the address
-space. This poses something of a problem for KASAN, which requires
-that all addresses accessed by instrumented code have a valid shadow
-region.
-
-The range of kernel virtual addresses is large: there is not enough
-real memory to support a real shadow region for every address that
-could be accessed by the kernel.
+The kernel maps memory in several different parts of the address space.
+The range of kernel virtual addresses is large: there is not enough real
+memory to support a real shadow region for every address that could be
+accessed by the kernel. Therefore, KASAN only maps real shadow for certain
+parts of the address space.
 
 Default behaviour
 ~~~~~~~~~~~~~~~~~
@@ -323,10 +320,9 @@ page is mapped over the shadow area. Thi
 declares all memory accesses as permitted.
 
 This presents a problem for modules: they do not live in the linear
-mapping, but in a dedicated module space. By hooking in to the module
-allocator, KASAN can temporarily map real shadow memory to cover
-them. This allows detection of invalid accesses to module globals, for
-example.
+mapping but in a dedicated module space. By hooking into the module
+allocator, KASAN temporarily maps real shadow memory to cover them.
+This allows detection of invalid accesses to module globals, for example.
 
 This also creates an incompatibility with ``VMAP_STACK``: if the stack
 lives in vmalloc space, it will be shadowed by the read-only page, and
@@ -337,9 +333,10 @@ CONFIG_KASAN_VMALLOC
 ~~~~~~~~~~~~~~~~~~~~
 
 With ``CONFIG_KASAN_VMALLOC``, KASAN can cover vmalloc space at the
-cost of greater memory usage. Currently this is only supported on x86.
+cost of greater memory usage. Currently, this is supported on x86,
+riscv, s390, and powerpc.
 
-This works by hooking into vmalloc and vmap, and dynamically
+This works by hooking into vmalloc and vmap and dynamically
 allocating real shadow memory to back the mappings.
 
 Most mappings in vmalloc space are small, requiring less than a full
@@ -358,10 +355,10 @@ memory.
 
 To avoid the difficulties around swapping mappings around, KASAN expects
 that the part of the shadow region that covers the vmalloc space will
-not be covered by the early shadow page, but will be left
-unmapped. This will require changes in arch-specific code.
+not be covered by the early shadow page but will be left unmapped.
+This will require changes in arch-specific code.
 
-This allows ``VMAP_STACK`` support on x86, and can simplify support of
+This allows ``VMAP_STACK`` support on x86 and can simplify support of
 architectures that do not have a fixed module region.
 
 For developers
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

