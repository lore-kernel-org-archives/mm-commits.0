Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2954BC49EA5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 22:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C4666138C
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 22:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhFXW60 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 18:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhFXW6Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 18:58:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 040E3611CB;
        Thu, 24 Jun 2021 22:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624575365;
        bh=pnXibYc/IbJKGLhtAErLwryhaop/XCLEvacTLDlweQo=;
        h=Date:From:To:Subject:From;
        b=gohym6iJeweIw/IIUr9nG40kw/lyvV4PO3/3L8x7NVStCra+B/Ysi3u7NoaK37Lgv
         S2W7MX+DT+Ls+Z0t+hwtBIWGScxeR3buof0GhXQovZ6jVhn+rVKiUNR05BR0UYdZ65
         +0iOqUcLC4VZPt/patlDQxdsAxdJy69/uBSzfsog=
Date:   Thu, 24 Jun 2021 15:56:04 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aneesh.kumar@linux.ibm.com,
        bsingharora@gmail.com, christophe.leroy@csgroup.eu, dja@axtens.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  +
 kasan-allow-architectures-to-provide-an-outline-readiness-check.patch added
 to -mm tree
Message-ID: <20210624225604.G7qqdtQ9g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: allow architectures to provide an outline readiness check
has been added to the -mm tree.  Its filename is
     kasan-allow-architectures-to-provide-an-outline-readiness-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-allow-architectures-to-provide-an-outline-readiness-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-allow-architectures-to-provide-an-outline-readiness-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: kasan: allow architectures to provide an outline readiness check

Allow architectures to define a kasan_arch_is_ready() hook that bails out
of any function that's about to touch the shadow unless the arch says that
it is ready for the memory to be accessed.  This is fairly uninvasive and
should have a negligible performance penalty.

This will only work in outline mode, so an arch must specify
ARCH_DISABLE_KASAN_INLINE if it requires this.

Link: https://lkml.kernel.org/r/20210624034050.511391-3-dja@axtens.net
Signed-off-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Marco Elver <elver@google.com>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c  |    3 +++
 mm/kasan/generic.c |    3 +++
 mm/kasan/kasan.h   |    6 ++++++
 mm/kasan/shadow.c  |    6 ++++++
 4 files changed, 18 insertions(+)

--- a/mm/kasan/common.c~kasan-allow-architectures-to-provide-an-outline-readiness-check
+++ a/mm/kasan/common.c
@@ -331,6 +331,9 @@ static inline bool ____kasan_slab_free(s
 	u8 tag;
 	void *tagged_object;
 
+	if (!kasan_arch_is_ready())
+		return false;
+
 	tag = get_tag(object);
 	tagged_object = object;
 	object = kasan_reset_tag(object);
--- a/mm/kasan/generic.c~kasan-allow-architectures-to-provide-an-outline-readiness-check
+++ a/mm/kasan/generic.c
@@ -163,6 +163,9 @@ static __always_inline bool check_region
 						size_t size, bool write,
 						unsigned long ret_ip)
 {
+	if (!kasan_arch_is_ready())
+		return true;
+
 	if (unlikely(size == 0))
 		return true;
 
--- a/mm/kasan/kasan.h~kasan-allow-architectures-to-provide-an-outline-readiness-check
+++ a/mm/kasan/kasan.h
@@ -455,6 +455,12 @@ static inline void kasan_poison_last_gra
 
 #endif /* CONFIG_KASAN_GENERIC */
 
+#ifndef kasan_arch_is_ready
+static inline bool kasan_arch_is_ready(void)	{ return true; }
+#elif !defined(CONFIG_KASAN_GENERIC) || !defined(CONFIG_KASAN_OUTLINE)
+#error kasan_arch_is_ready only works in KASAN generic outline mode!
+#endif
+
 /*
  * Exported functions for interfaces called from assembly or from generated
  * code. Declarations here to avoid warning about missing declarations.
--- a/mm/kasan/shadow.c~kasan-allow-architectures-to-provide-an-outline-readiness-check
+++ a/mm/kasan/shadow.c
@@ -73,6 +73,9 @@ void kasan_poison(const void *addr, size
 {
 	void *shadow_start, *shadow_end;
 
+	if (!kasan_arch_is_ready())
+		return;
+
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
 	 * some of the callers (e.g. kasan_poison_object_data) pass tagged
@@ -99,6 +102,9 @@ EXPORT_SYMBOL(kasan_poison);
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
+	if (!kasan_arch_is_ready())
+		return;
+
 	if (size & KASAN_GRANULE_MASK) {
 		u8 *shadow = (u8 *)kasan_mem_to_shadow(addr + size);
 		*shadow = size & KASAN_GRANULE_MASK;
_

Patches currently in -mm which might be from dja@axtens.net are

mm-vmalloc-unbreak-kasan-vmalloc-support.patch
kasan-allow-an-architecture-to-disable-inline-instrumentation.patch
kasan-allow-architectures-to-provide-an-outline-readiness-check.patch
mm-define-default-max_ptrs_per_-in-include-pgtableh.patch
kasan-use-max_ptrs_per_-for-early-shadow-tables.patch

