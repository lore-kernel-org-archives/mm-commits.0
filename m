Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989AEC43461
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81C4161402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhEHWpi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhEHWpf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 899BB61402;
        Sat,  8 May 2021 22:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513872;
        bh=L1pNmlZwQAgyY2JlbMPW0nwAJ4b9vfIuekh5PKPthao=;
        h=Date:From:To:Subject:From;
        b=T6Dc9ruGPZlE37b/8u58QRbmUTPtpfD7WaoF4RdpknbUIEJCTvA/aKYurv7NvWM0Z
         CZkgJL+IVMGU+VOeG3KCMAR3fPaYkVdkZQrHmNaEGBB29IiPvjRHRyTWbgJ9EIpsml
         03riWT9aun6C+x2F6B2cPmgA4RDs55IWy1oW9qGc=
Date:   Sat, 08 May 2021 15:44:32 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged] kasan-docs-update-shadow-memory-section.patch
 removed from -mm tree
Message-ID: <20210508224432.U9qsPgu7e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update shadow memory section
has been removed from the -mm tree.  Its filename was
     kasan-docs-update-shadow-memory-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -313,14 +313,11 @@ checking gets disabled.
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
@@ -332,10 +329,9 @@ page is mapped over the shadow area. Thi
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
@@ -346,9 +342,10 @@ CONFIG_KASAN_VMALLOC
 ~~~~~~~~~~~~~~~~~~~~
 
 With ``CONFIG_KASAN_VMALLOC``, KASAN can cover vmalloc space at the
-cost of greater memory usage. Currently this is only supported on x86.
+cost of greater memory usage. Currently, this is supported on x86,
+riscv, s390, and powerpc.
 
-This works by hooking into vmalloc and vmap, and dynamically
+This works by hooking into vmalloc and vmap and dynamically
 allocating real shadow memory to back the mappings.
 
 Most mappings in vmalloc space are small, requiring less than a full
@@ -367,10 +364,10 @@ memory.
 
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


