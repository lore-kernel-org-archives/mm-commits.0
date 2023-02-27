Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50D4C64ED6
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjB0WQp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB0WQp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:16:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8C627483
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:16:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96F3BB80DBB
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310CDC433EF;
        Mon, 27 Feb 2023 22:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677536201;
        bh=+tF/OlvVy+CDpgR/1qvbjpsRUOC+cvOkRfvKMtHnys4=;
        h=Date:To:From:Subject:From;
        b=OWLgv2+7B6rPiOJ1QOB/GUWr+MlFlLuGRTDiH2M/G19wJRwRyuY4YJ16lfCkJmIiE
         jwV/QxOndKumz71I28se3m9gKIqsTQYBuR5QSZwmAP9mvtHcjT8+CqtBG/gDgZ5dzg
         yXwQTXX6F/ch5qJdhSbvc4oHDfQGmV8QDlWrjqHw=
Date:   Mon, 27 Feb 2023 14:16:39 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, elver@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230227221641.310CDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, powerpc: don't rename memintrinsics if compiler adds prefixes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Marco Elver <elver@google.com>
Subject: kasan, powerpc: don't rename memintrinsics if compiler adds prefixes
Date: Mon, 27 Feb 2023 10:47:27 +0100

With appropriate compiler support [1], KASAN builds use __asan prefixed
meminstrinsics, and KASAN no longer overrides memcpy/memset/memmove.

If compiler support is detected (CC_HAS_KASAN_MEMINTRINSIC_PREFIX), define
memintrinsics normally (do not prefix '__').

On powerpc, KASAN is the only user of __mem functions, which are used to
define instrumented memintrinsics.  Alias the normal versions for KASAN to
use in its implementation.

Link: https://lore.kernel.org/all/20230224085942.1791837-1-elver@google.com/ [1]
Link: https://lkml.kernel.org/r/20230227094726.3833247-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/oe-kbuild-all/202302271348.U5lvmo0S-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/powerpc/include/asm/kasan.h~kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files-fix
+++ a/arch/powerpc/include/asm/kasan.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_KASAN_H
 #define __ASM_KASAN_H
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) && !defined(CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX)
 #define _GLOBAL_KASAN(fn)	_GLOBAL(__##fn)
 #define _GLOBAL_TOC_KASAN(fn)	_GLOBAL_TOC(__##fn)
 #define EXPORT_SYMBOL_KASAN(fn)	EXPORT_SYMBOL(__##fn)
--- a/arch/powerpc/include/asm/string.h~kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files-fix
+++ a/arch/powerpc/include/asm/string.h
@@ -30,11 +30,17 @@ extern int memcmp(const void *,const voi
 extern void * memchr(const void *,int,__kernel_size_t);
 void memcpy_flushcache(void *dest, const void *src, size_t size);
 
+#ifdef CONFIG_KASAN
+/* __mem variants are used by KASAN to implement instrumented meminstrinsics. */
+#ifdef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
+#define __memset memset
+#define __memcpy memcpy
+#define __memmove memmove
+#else /* CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX */
 void *__memset(void *s, int c, __kernel_size_t count);
 void *__memcpy(void *to, const void *from, __kernel_size_t n);
 void *__memmove(void *to, const void *from, __kernel_size_t n);
-
-#if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
+#ifndef __SANITIZE_ADDRESS__
 /*
  * For files that are not instrumented (e.g. mm/slub.c) we
  * should use not instrumented version of mem* functions.
@@ -46,8 +52,9 @@ void *__memmove(void *to, const void *fr
 #ifndef __NO_FORTIFY
 #define __NO_FORTIFY /* FORTIFY_SOURCE uses __builtin_memcpy, etc. */
 #endif
-
-#endif
+#endif /* !__SANITIZE_ADDRESS__ */
+#endif /* CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX */
+#endif /* CONFIG_KASAN */
 
 #ifdef CONFIG_PPC64
 #ifndef CONFIG_KASAN
--- a/arch/powerpc/kernel/prom_init_check.sh~kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files-fix
+++ a/arch/powerpc/kernel/prom_init_check.sh
@@ -13,8 +13,13 @@
 # If you really need to reference something from prom_init.o add
 # it to the list below:
 
-grep "^CONFIG_KASAN=y$" ${KCONFIG_CONFIG} >/dev/null
-if [ $? -eq 0 ]
+has_renamed_memintrinsics()
+{
+	grep -q "^CONFIG_KASAN=y$" ${KCONFIG_CONFIG} && \
+		! grep -q "^CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX=y" ${KCONFIG_CONFIG}
+}
+
+if has_renamed_memintrinsics
 then
 	MEM_FUNCS="__memcpy __memset"
 else
_

Patches currently in -mm which might be from elver@google.com are

kasan-emit-different-calls-for-instrumentable-memintrinsics.patch
kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files.patch
kasan-treat-meminstrinsic-as-builtins-in-uninstrumented-files-fix.patch
kasan-test-fix-test-for-new-meminstrinsic-instrumentation.patch
kasan-x86-dont-rename-memintrinsics-in-uninstrumented-files.patch

