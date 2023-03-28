Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90041C77B6C
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjC1XWF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjC1XVk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7D6BE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AD34619EF
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E05C433D2;
        Tue, 28 Mar 2023 23:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045691;
        bh=aMKCdApk4kZwkMdpBr6V/LjD3gv8Qti22J3ZSQCmAS8=;
        h=Date:To:From:Subject:From;
        b=X5FmwGrmo+A8PMWPiDFRN71VVbUWcVoreI7fjTY0pGJn3WjCS/gpqqr05+rs0NBn1
         5s9Yund/Meu2nRE/JzQsA+MAWXkdDqE8SoVtIW+KpmqaSJPwlKJQiygJ8FU+sgHxIb
         H5n59klX/X2cyEN/NMBoFLupp7byIWOciaWfx89U=
Date:   Tue, 28 Mar 2023 16:21:30 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        keescook@chromium.org, geert@linux-m68k.org, elver@google.com,
        deller@gmx.de, daniel@ffwll.ch, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch removed from -mm tree
Message-Id: <20230328232130.F3E05C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86: kmsan: don't rename memintrinsics in uninstrumented files
has been removed from the -mm tree.  Its filename was
     x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: x86: kmsan: don't rename memintrinsics in uninstrumented files
Date: Fri, 3 Mar 2023 15:14:30 +0100

clang -fsanitize=kernel-memory already replaces calls to
memset/memcpy/memmove and their __builtin_ versions with
__msan_memset/__msan_memcpy/__msan_memmove in instrumented files, so
there is no need to override them.

In non-instrumented versions we are now required to leave memset() and
friends intact, so we cannot replace them with __msan_XXX() functions.

Link: https://lkml.kernel.org/r/20230303141433.3422671-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/string_64.h |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/arch/x86/include/asm/string_64.h~x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files
+++ a/arch/x86/include/asm/string_64.h
@@ -15,22 +15,11 @@
 #endif
 
 #define __HAVE_ARCH_MEMCPY 1
-#if defined(__SANITIZE_MEMORY__) && defined(__NO_FORTIFY)
-#undef memcpy
-#define memcpy __msan_memcpy
-#else
 extern void *memcpy(void *to, const void *from, size_t len);
-#endif
 extern void *__memcpy(void *to, const void *from, size_t len);
 
 #define __HAVE_ARCH_MEMSET
-#if defined(__SANITIZE_MEMORY__) && defined(__NO_FORTIFY)
-extern void *__msan_memset(void *s, int c, size_t n);
-#undef memset
-#define memset __msan_memset
-#else
 void *memset(void *s, int c, size_t n);
-#endif
 void *__memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMSET16
@@ -70,13 +59,7 @@ static inline void *memset64(uint64_t *s
 }
 
 #define __HAVE_ARCH_MEMMOVE
-#if defined(__SANITIZE_MEMORY__) && defined(__NO_FORTIFY)
-#undef memmove
-void *__msan_memmove(void *dest, const void *src, size_t len);
-#define memmove __msan_memmove
-#else
 void *memmove(void *dest, const void *src, size_t count);
-#endif
 void *__memmove(void *dest, const void *src, size_t count);
 
 int memcmp(const void *cs, const void *ct, size_t count);
_

Patches currently in -mm which might be from glider@google.com are


