Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C802C61DA3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 22:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjCCW6d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 17:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbjCCW6Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 17:58:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E012F311D5
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 14:58:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29327B818A4
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 22:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A690BC433EF;
        Fri,  3 Mar 2023 22:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677884248;
        bh=kyagSBl5CNJZhLgwzJipCiY4k/8zPbF/105fHjQXOAU=;
        h=Date:To:From:Subject:From;
        b=CniZDUUwjBOqv9RlIDPKS2ZMjrFEa0EXO9qhdzFENGwSzlOI1ud2JLuDasFtZmpQH
         PKrwvEElYvwiIcHre/dmWTOWE+AjwQBokJgOzCoi5Wmg9zzLYC/1ZNuObJXvAD5nu4
         Plw+U3NMpQmAb61Sp7188KkPwtCXwimJTDfPpZ6c=
Date:   Fri, 03 Mar 2023 14:57:27 -0800
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        keescook@chromium.org, geert@linux-m68k.org, elver@google.com,
        deller@gmx.de, daniel@ffwll.ch, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch added to mm-unstable branch
Message-Id: <20230303225728.A690BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: kmsan: don't rename memintrinsics in uninstrumented files
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch
kmsan-another-take-at-fixing-memcpy-tests.patch
x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch
kmsan-add-memsetxx-tests.patch

