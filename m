Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF1EC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D7D364DEC
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhCLSgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233841AbhCLSgB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:36:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D826764F66;
        Fri, 12 Mar 2021 18:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615574161;
        bh=q8nz/qwHEDgdTr9VOk62a7OKqlLUKL2pCZE+5ncsFQI=;
        h=Date:From:To:Subject:From;
        b=tUrxJtIdZXxamABeMxFfpYQs6YN7EQryocXPd3ildZxCMgOukc+4yyZQLXX2Y0jZW
         Rr0CZ8AW20xwSReWYFX9vUTu/Lprx76q3JiSZlHGR/pVepaQlglPzSMlLrd7VOe4Ix
         rq9KN073W1yomZWIrmr7Five/ZlyKgbUm7tHEkRI=
Date:   Fri, 12 Mar 2021 10:36:00 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  + kasan-docs-update-overview-section.patch added to -mm
 tree
Message-ID: <20210312183600.Qz4zd5W4l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update overview section
has been added to the -mm tree.  Its filename is
     kasan-docs-update-overview-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-docs-update-overview-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-docs-update-overview-section.patch

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
Subject: kasan: docs: update overview section

Update the "Overview" section in KASAN documentation:

- Outline main use cases for each mode.
- Mention that HW_TAGS mode need compiler support too.
- Move the part about SLUB/SLAB support from "Usage" to "Overview".
- Punctuation, readability, and other minor clean-ups.

Link: https://lkml.kernel.org/r/1486fba8514de3d7db2f47df2192db59228b0a7b.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-overview-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -11,17 +11,31 @@ designed to find out-of-bound and use-af
 2. software tag-based KASAN (similar to userspace HWASan),
 3. hardware tag-based KASAN (based on hardware memory tagging).
 
-Software KASAN modes (1 and 2) use compile-time instrumentation to insert
-validity checks before every memory access, and therefore require a compiler
+Generic KASAN is mainly used for debugging due to a large memory overhead.
+Software tag-based KASAN can be used for dogfood testing as it has a lower
+memory overhead that allows using it with real workloads. Hardware tag-based
+KASAN comes with low memory and performance overheads and, therefore, can be
+used in production. Either as an in-field memory bug detector or as a security
+mitigation.
+
+Software KASAN modes (#1 and #2) use compile-time instrumentation to insert
+validity checks before every memory access and, therefore, require a compiler
 version that supports that.
 
-Generic KASAN is supported in both GCC and Clang. With GCC it requires version
+Generic KASAN is supported in GCC and Clang. With GCC, it requires version
 8.3.0 or later. Any supported Clang version is compatible, but detection of
 out-of-bounds accesses for global variables is only supported since Clang 11.
 
-Tag-based KASAN is only supported in Clang.
+Software tag-based KASAN mode is only supported in Clang.
+
+The hardware KASAN mode (#3) relies on hardware to perform the checks but
+still requires a compiler version that supports memory tagging instructions.
+This mode is supported in GCC 10+ and Clang 11+.
 
-Currently generic KASAN is supported for the x86_64, arm, arm64, xtensa, s390
+Both software KASAN modes work with SLUB and SLAB memory allocators,
+while the hardware tag-based KASAN currently only supports SLUB.
+
+Currently, generic KASAN is supported for the x86_64, arm, arm64, xtensa, s390,
 and riscv architectures, and tag-based KASAN modes are supported only for arm64.
 
 Usage
@@ -39,9 +53,6 @@ For software modes, you also need to cho
 CONFIG_KASAN_INLINE. Outline and inline are compiler instrumentation types.
 The former produces smaller binary while the latter is 1.1 - 2 times faster.
 
-Both software KASAN modes work with both SLUB and SLAB memory allocators,
-while the hardware tag-based KASAN currently only support SLUB.
-
 For better error reports that include stack traces, enable CONFIG_STACKTRACE.
 
 To augment reports with last allocation and freeing stack of the physical page,
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

