Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1782C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 961636128D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhGFTQT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhGFTQS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:16:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A244F61206;
        Tue,  6 Jul 2021 19:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598820;
        bh=xlNWpC0bnt9mDyIdfnwDLuQ3H5v0FzUbT+yfnoEktx8=;
        h=Date:From:To:Subject:From;
        b=cfCakyxtFDEqX60x+6At3QoPDtDsorTX3q5i+zVmsQsbdg0ghotrgOtOY+pjR6qS9
         qZk5TvcpGAoM9L1tNeth9kWGi6bfUR/UX2K2yCXAFMnKTGE4Ecyom8jP8kh3FZ4esn
         4P0n0peVCwneCkmYLhq4MAMbp2ogx1z5l1NSQdLM=
Date:   Tue, 06 Jul 2021 12:13:39 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aneesh.kumar@linux.ibm.com,
        bsingharora@gmail.com, christophe.leroy@csgroup.eu, dja@axtens.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Subject:  [merged]
 kasan-allow-an-architecture-to-disable-inline-instrumentation.patch removed
 from -mm tree
Message-ID: <20210706191339.6bgFwTFj0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: allow an architecture to disable inline instrumentation
has been removed from the -mm tree.  Its filename was
     kasan-allow-an-architecture-to-disable-inline-instrumentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: kasan: allow an architecture to disable inline instrumentation

Patch series "KASAN core changes for ppc64 radix KASAN", v16.

Building on the work of Christophe, Aneesh and Balbir, I've ported KASAN
to 64-bit Book3S kernels running on the Radix MMU.  I've been trying this
for a while, but we keep having collisions between the kasan code in the
mm tree and the code I want to put in to the ppc tree.

This series just contains the kasan core changes that we need.  There
should be no noticeable changes to other platforms.


This patch (of 4):

For annoying architectural reasons, it's very difficult to support inline
instrumentation on powerpc64.*

Add a Kconfig flag to allow an arch to disable inline.  (It's a bit
annoying to be 'backwards', but I'm not aware of any way to have an arch
force a symbol to be 'n', rather than 'y'.)

We also disable stack instrumentation in this case as it does things that
are functionally equivalent to inline instrumentation, namely adding code
that touches the shadow directly without going through a C helper.

* on ppc64 atm, the shadow lives in virtual memory and isn't accessible in
real mode.  However, before we turn on virtual memory, we parse the device
tree to determine which platform and MMU we're running under.  That calls
generic DT code, which is instrumented.  Inline instrumentation in DT
would unconditionally attempt to touch the shadow region, which we won't
have set up yet, and would crash.  We can make outline mode wait for the
arch to be ready, but we can't change what the compiler inserts for inline
mode.

Link: https://lkml.kernel.org/r/20210624034050.511391-1-dja@axtens.net
Link: https://lkml.kernel.org/r/20210624034050.511391-2-dja@axtens.net
Signed-off-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/lib/Kconfig.kasan~kasan-allow-an-architecture-to-disable-inline-instrumentation
+++ a/lib/Kconfig.kasan
@@ -12,6 +12,13 @@ config HAVE_ARCH_KASAN_HW_TAGS
 config HAVE_ARCH_KASAN_VMALLOC
 	bool
 
+config ARCH_DISABLE_KASAN_INLINE
+	bool
+	help
+	  An architecture might not support inline instrumentation.
+	  When this option is selected, inline and stack instrumentation are
+	  disabled.
+
 config CC_HAS_KASAN_GENERIC
 	def_bool $(cc-option, -fsanitize=kernel-address)
 
@@ -130,6 +137,7 @@ config KASAN_OUTLINE
 
 config KASAN_INLINE
 	bool "Inline instrumentation"
+	depends on !ARCH_DISABLE_KASAN_INLINE
 	help
 	  Compiler directly inserts code checking shadow memory before
 	  memory accesses. This is faster than outline (in some workloads
@@ -141,6 +149,7 @@ endchoice
 config KASAN_STACK
 	bool "Enable stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
 	depends on KASAN_GENERIC || KASAN_SW_TAGS
+	depends on !ARCH_DISABLE_KASAN_INLINE
 	default y if CC_IS_GCC
 	help
 	  The LLVM stack address sanitizer has a know problem that
@@ -154,6 +163,9 @@ config KASAN_STACK
 	  but clang users can still enable it for builds without
 	  CONFIG_COMPILE_TEST.	On gcc it is assumed to always be safe
 	  to use and enabled by default.
+	  If the architecture disables inline instrumentation, stack
+	  instrumentation is also disabled as it adds inline-style
+	  instrumentation that is run unconditionally.
 
 config KASAN_SW_TAGS_IDENTIFY
 	bool "Enable memory corruption identification"
_

Patches currently in -mm which might be from dja@axtens.net are


