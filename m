Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866C1C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58AEA61241
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhIWWWU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234844AbhIWWWT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 18:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B771E60F39;
        Thu, 23 Sep 2021 22:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632435647;
        bh=06s67IazN48y1lGewjenhIylxkuZPNsoYrh1t1poWLE=;
        h=Date:From:To:Subject:From;
        b=ITB+eWcPvLY8iMJLQ9G4HXIrOCocVrVEtAdzzs8EQbkN32JGMk5SdLqUgxmryv2nG
         80aMpmgZSa73Qu7P5Pi1zi/EECQ9HFGE5xvf+hzvnS+39PaO5/BicTbPYAlXqbRZUx
         wA2fUVi1zJObYt6uh43jfbiMUB+kBkJ0IZabVf1Q=
Date:   Thu, 23 Sep 2021 15:20:46 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, arnd@arndb.de, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, ryabinin.a.a@gmail.com
Subject:  + kasan-always-respect-config_kasan_stack.patch added to
 -mm tree
Message-ID: <20210923222046.xoI6Pna7S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: always respect CONFIG_KASAN_STACK
has been added to the -mm tree.  Its filename is
     kasan-always-respect-config_kasan_stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-always-respect-config_kasan_stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-always-respect-config_kasan_stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: kasan: always respect CONFIG_KASAN_STACK

Currently, the asan-stack parameter is only passed along if
CFLAGS_KASAN_SHADOW is not empty, which requires KASAN_SHADOW_OFFSET to be
defined in Kconfig so that the value can be checked.  In RISC-V's case,
KASAN_SHADOW_OFFSET is not defined in Kconfig, which means that asan-stack
does not get disabled with clang even when CONFIG_KASAN_STACK is disabled,
resulting in large stack warnings with allmodconfig:

drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:117:12:
error: stack frame size (14400) exceeds limit (2048) in function
'lb035q02_connect' [-Werror,-Wframe-larger-than]
static int lb035q02_connect(struct omap_dss_device *dssdev)
           ^
1 error generated.

Ensure that the value of CONFIG_KASAN_STACK is always passed along to the
compiler so that these warnings do not happen when CONFIG_KASAN_STACK is
disabled.

Link: https://github.com/ClangBuiltLinux/linux/issues/1453
References: 6baec880d7a5 ("kasan: turn off asan-stack for clang-8 and earlier")
Link: https://lkml.kernel.org/r/20210922205525.570068-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/Makefile.kasan~kasan-always-respect-config_kasan_stack
+++ a/scripts/Makefile.kasan
@@ -33,10 +33,11 @@ else
 	CFLAGS_KASAN := $(CFLAGS_KASAN_SHADOW) \
 	 $(call cc-param,asan-globals=1) \
 	 $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
-	 $(call cc-param,asan-stack=$(stack_enable)) \
 	 $(call cc-param,asan-instrument-allocas=1)
 endif
 
+CFLAGS_KASAN += $(call cc-param,asan-stack=$(stack_enable))
+
 endif # CONFIG_KASAN_GENERIC
 
 ifdef CONFIG_KASAN_SW_TAGS
_

Patches currently in -mm which might be from nathan@kernel.org are

kasan-always-respect-config_kasan_stack.patch

