Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A86C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CC0561A0A
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhCXWuI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238379AbhCXWtp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:49:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5FAD619B8;
        Wed, 24 Mar 2021 22:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616626182;
        bh=PAc0LbWEjZWPdhhSJIkNqzOZU873h5nAPL1LWJnv5EI=;
        h=Date:From:To:Subject:From;
        b=cwHFSsQh5b+mk9iVuulVmz49Qbg+l4Yj1+/L98dnYyiBxOQopcBnCchUzt0KPjEnT
         rej2rBqVON2NLjOhLmseoOWEten/ztjdswzZrZaLiUDYhdQVf92kgjWBRgasMSUEH2
         AlUf8I5HEjBulO3FIGK9Oovn8x2JJ8OJ9WPWRzts=
Date:   Wed, 24 Mar 2021 15:49:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        michal.lkml@markovi.net, masahiroy@kernel.org, glider@google.com,
        elver@google.com, dvyukov@google.com, arnd@arndb.de,
        andreyknvl@gmail.com, arnd@kernel.org
Subject:  + kasan-fix-hwasan-build-for-gcc.patch added to -mm tree
Message-ID: <20210324224939.kbP-t%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix hwasan build for gcc
has been added to the -mm tree.  Its filename is
     kasan-fix-hwasan-build-for-gcc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-hwasan-build-for-gcc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-hwasan-build-for-gcc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@kernel.org>
Subject: kasan: fix hwasan build for gcc


gcc-11 adds support for -fsanitize=kernel-hwaddress, so it becomes
possible to enable CONFIG_KASAN_SW_TAGS.

Unfortunately this fails to build at the moment, because the
corresponding command line arguments use llvm specific syntax.

Change it to use the cc-param macro instead, which works on both
clang and gcc.

Link: https://lkml.kernel.org/r/20210323124112.1229772-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/scripts/Makefile.kasan~kasan-fix-hwasan-build-for-gcc
+++ a/scripts/Makefile.kasan
@@ -36,14 +36,14 @@ endif # CONFIG_KASAN_GENERIC
 ifdef CONFIG_KASAN_SW_TAGS
 
 ifdef CONFIG_KASAN_INLINE
-    instrumentation_flags := -mllvm -hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET)
+    instrumentation_flags := $(call cc-param,hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET))
 else
-    instrumentation_flags := -mllvm -hwasan-instrument-with-calls=1
+    instrumentation_flags := $(call cc-param,hwasan-instrument-with-calls=1)
 endif
 
 CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
-		-mllvm -hwasan-instrument-stack=$(CONFIG_KASAN_STACK) \
-		-mllvm -hwasan-use-short-granules=0 \
+		$(call cc-param,hwasan-instrument-stack=$(CONFIG_KASAN_STACK)) \
+		$(call cc-param,hwasan-use-short-granules=0) \
 		$(instrumentation_flags)
 
 endif # CONFIG_KASAN_SW_TAGS
_

Patches currently in -mm which might be from arnd@kernel.org are

kasan-fix-hwasan-build-for-gcc.patch

