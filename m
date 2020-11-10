Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43298C55ABD
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1032620897
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="otUcfdQ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732566AbgKJW5P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 17:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732154AbgKJW5P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 17:57:15 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B0C1204EF;
        Tue, 10 Nov 2020 22:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605049033;
        bh=fqC7REqB2qLayWmj23mh1fhYPtQD1h2GAao5dCkMgso=;
        h=Date:From:To:Subject:From;
        b=otUcfdQ4LQYPZlyj3FG2vDL9gM17YogFqEZVxJwJ0NIwdjSvPFB4ABGDPh7ZsL+ug
         dPg/a6uCesGarSOUFZMkerLKs/n17xTftQQS71cBI5VuGTaflzxVQLUHmG/qbxbL33
         Jn0US4quI8H8TsScLk7BKSep3BkzMH8GdT1703Ng=
Date:   Tue, 10 Nov 2020 14:57:12 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  +
 arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch added to -mm
 tree
Message-ID: <20201110225712.Z8ck1Fu_S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kasan: add arch layer for memory tagging helpers
has been added to the -mm tree.  Its filename is
     arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch

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
Subject: arm64: kasan: add arch layer for memory tagging helpers

This patch add a set of arch_*() memory tagging helpers currently only
defined for arm64 when hardware tag-based KASAN is enabled. These helpers
will be used by KASAN runtime to implement the hardware tag-based mode.

The arch-level indirection level is introduced to simplify adding hardware
tag-based KASAN support for other architectures in the future by defining
the appropriate arch_*() macros.

Link: https://lkml.kernel.org/r/b484d6cece68422a6cc5399dc7ceb69ecbdeeb22.1605046192.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Co-developed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/memory.h |    9 +++++++++
 mm/kasan/kasan.h                |   26 ++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

--- a/arch/arm64/include/asm/memory.h~arm64-kasan-add-arch-layer-for-memory-tagging-helpers
+++ a/arch/arm64/include/asm/memory.h
@@ -230,6 +230,15 @@ static inline const void *__tag_set(cons
 	return (const void *)(__addr | __tag_shifted(tag));
 }
 
+#ifdef CONFIG_KASAN_HW_TAGS
+#define arch_enable_tagging()			mte_enable()
+#define arch_init_tags(max_tag)			mte_init_tags(max_tag)
+#define arch_get_random_tag()			mte_get_random_tag()
+#define arch_get_mem_tag(addr)			mte_get_mem_tag(addr)
+#define arch_set_mem_tag_range(addr, size, tag)	\
+			mte_set_mem_tag_range((addr), (size), (tag))
+#endif /* CONFIG_KASAN_HW_TAGS */
+
 /*
  * Physical vs virtual RAM address space conversion.  These are
  * private definitions which should NOT be used outside memory.h
--- a/mm/kasan/kasan.h~arm64-kasan-add-arch-layer-for-memory-tagging-helpers
+++ a/mm/kasan/kasan.h
@@ -241,6 +241,32 @@ static inline const void *arch_kasan_set
 #define reset_tag(addr)		((void *)arch_kasan_reset_tag(addr))
 #define get_tag(addr)		arch_kasan_get_tag(addr)
 
+#ifdef CONFIG_KASAN_HW_TAGS
+
+#ifndef arch_enable_tagging
+#define arch_enable_tagging()
+#endif
+#ifndef arch_init_tags
+#define arch_init_tags(max_tag)
+#endif
+#ifndef arch_get_random_tag
+#define arch_get_random_tag()	(0xFF)
+#endif
+#ifndef arch_get_mem_tag
+#define arch_get_mem_tag(addr)	(0xFF)
+#endif
+#ifndef arch_set_mem_tag_range
+#define arch_set_mem_tag_range(addr, size, tag) ((void *)(addr))
+#endif
+
+#define hw_enable_tagging()			arch_enable_tagging()
+#define hw_init_tags(max_tag)			arch_init_tags(max_tag)
+#define hw_get_random_tag()			arch_get_random_tag()
+#define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)
+#define hw_set_mem_tag_range(addr, size, tag)	arch_set_mem_tag_range((addr), (size), (tag))
+
+#endif /* CONFIG_KASAN_HW_TAGS */
+
 /*
  * Exported functions for interfaces called from assembly or from generated
  * code. Declarations here to avoid warning about missing declarations.
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-unnecessary-gpl-text-from-comment-headers.patch
kasan-kasan_vmalloc-depends-on-kasan_generic.patch
kasan-group-vmalloc-code.patch
s390-kasan-include-asm-pageh-from-asm-kasanh.patch
kasan-shadow-declarations-only-for-software-modes.patch
kasan-rename-unpoison_shadow-to-unpoison_memory.patch
kasan-rename-kasan_shadow_-to-kasan_granule_.patch
kasan-only-build-initc-for-software-modes.patch
kasan-split-out-shadowc-from-commonc.patch
kasan-define-kasan_granule_page.patch
kasan-rename-report-and-tags-files.patch
kasan-dont-duplicate-config-dependencies.patch
kasan-hide-invalid-free-check-implementation.patch
kasan-decode-stack-frame-only-with-kasan_stack_enable.patch
kasan-arm64-only-init-shadow-for-software-modes.patch
kasan-arm64-only-use-kasan_depth-for-software-modes.patch
kasan-arm64-move-initialization-message.patch
kasan-arm64-rename-kasan_init_tags-and-mark-as-__init.patch
kasan-rename-addr_has_shadow-to-addr_has_metadata.patch
kasan-rename-print_shadow_for_address-to-print_memory_metadata.patch
kasan-kasan_non_canonical_hook-only-for-software-modes.patch
kasan-rename-shadow-layout-macros-to-meta.patch
kasan-separate-metadata_fetch_row-for-each-mode.patch
kasan-arm64-dont-allow-sw_tags-with-arm64_mte.patch
kasan-introduce-config_kasan_hw_tags.patch
arm64-kasan-align-allocations-for-hw_tags.patch
arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch
kasan-define-kasan_granule_size-for-hw_tags.patch
kasan-x86-s390-update-undef-config_kasan.patch
kasan-arm64-expand-config_kasan-checks.patch
kasan-arm64-implement-hw_tags-runtime.patch
kasan-arm64-print-report-from-tag-fault-handler.patch
kasan-mm-reset-tags-when-accessing-metadata.patch
kasan-arm64-enable-config_kasan_hw_tags.patch
kasan-add-documentation-for-hardware-tag-based-mode.patch

