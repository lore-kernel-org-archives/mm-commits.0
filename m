Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D18C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F2FE61260
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345162AbhIXWpf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345243AbhIXWpe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6EB461019;
        Fri, 24 Sep 2021 22:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523441;
        bh=Pw6rXTMhMM/nLK06bSzwqWYKfCa6ijh184dST5EsLzk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vdjw1TxXbj2MFWBECQRZWn/tNGN1O5rOtm5uttkUc/W5ms0xEmMvv1pl1RcQzDEm8
         H1GsBxEMIL3hSZQvTvVvhVSk0qeUmvKYV7hGr+op+BESUL0vLpR8tsJKiCdqvGQBAq
         9kKk1Dajg9zXNfv3o5Iq3TKY9y5/pNl4iDsLZb6Y=
Date:   Fri, 24 Sep 2021 15:44:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 14/16] kasan: always respect CONFIG_KASAN_STACK
Message-ID: <20210924224400.bnIuxajFt%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
