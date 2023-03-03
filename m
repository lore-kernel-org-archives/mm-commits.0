Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDE1C64EC4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 05:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCCFzn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 00:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjCCFzh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 00:55:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0A839B93
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 21:55:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A81761737
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 05:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4AFC433D2;
        Fri,  3 Mar 2023 05:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822899;
        bh=dqfLkoJptnN6EskBD1mtSsg/prwxtd2v+Z9cetdrmdM=;
        h=Date:To:From:Subject:From;
        b=hP76OU8FFDRGme/SpfgdSgcTVe4ixecis8jmqcUj/bjZ4Yn89ezs1t75lP+aHZGUB
         ZofurGZyDUSDeUu7//A/McWr8tOx4p31Ilk1LktXZdt4f5bVU8FwNCooJMOOdCXqA4
         +M2nFg6bm/ap7z58xB1WomYPID14RHTc0jabd5rk=
Date:   Thu, 02 Mar 2023 21:54:59 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tglx@linutronix.de, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        naresh.kamboju@linaro.org, mingo@redhat.com, lkft@linaro.org,
        keescook@chromium.org, jakub@redhat.com, glider@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andreyknvl@gmail.com, elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-x86-dont-rename-memintrinsics-in-uninstrumented-files.patch removed from -mm tree
Message-Id: <20230303055459.AD4AFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan, x86: don't rename memintrinsics in uninstrumented files
has been removed from the -mm tree.  Its filename was
     kasan-x86-dont-rename-memintrinsics-in-uninstrumented-files.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan, x86: don't rename memintrinsics in uninstrumented files
Date: Fri, 24 Feb 2023 09:59:42 +0100

Now that memcpy/memset/memmove are no longer overridden by KASAN, we can
just use the normal symbol names in uninstrumented files.

Drop the preprocessor redefinitions.

Link: https://lkml.kernel.org/r/20230224085942.1791837-4-elver@google.com
Fixes: 69d4c0d32186 ("entry, kasan, x86: Disallow overriding mem*() functions")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Functional Testing <lkft@linaro.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/x86/include/asm/string_64.h~kasan-x86-dont-rename-memintrinsics-in-uninstrumented-files
+++ a/arch/x86/include/asm/string_64.h
@@ -85,25 +85,6 @@ char *strcpy(char *dest, const char *src
 char *strcat(char *dest, const char *src);
 int strcmp(const char *cs, const char *ct);
 
-#if (defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__))
-/*
- * For files that not instrumented (e.g. mm/slub.c) we
- * should use not instrumented version of mem* functions.
- */
-
-#undef memcpy
-#define memcpy(dst, src, len) __memcpy(dst, src, len)
-#undef memmove
-#define memmove(dst, src, len) __memmove(dst, src, len)
-#undef memset
-#define memset(s, c, n) __memset(s, c, n)
-
-#ifndef __NO_FORTIFY
-#define __NO_FORTIFY /* FORTIFY_SOURCE uses __builtin_memcpy, etc. */
-#endif
-
-#endif
-
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
_

Patches currently in -mm which might be from elver@google.com are


