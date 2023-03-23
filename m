Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAE4C6FD1F
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCWBdt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjCWBda (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50182136
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F49AB81EB1
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4418C433D2;
        Thu, 23 Mar 2023 01:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535137;
        bh=B8jTsoupkink7sA8aiiQGIewtEOzBsSeUMBm8VeoIS0=;
        h=Date:To:From:Subject:From;
        b=UpWVrgVjpADwB2sxPIoq55lbquT1xuP4Mp2bhIz2MbvvickEH+E/G5a0aU5kGSAtc
         wNNeH5+OOJmfavmPg265Uox18izFLH4Ikmfo45lXzbYiGr6ho5LQHOhvStUR24q8m4
         4FBdGN3AT4bUUUFBwvE9iIMjQcvoev4uVAWvCqUU=
Date:   Wed, 22 Mar 2023 18:32:17 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, npiggin@gmail.com, mpe@ellerman.id.au,
        lkp@intel.com, Liam.Howlett@oracle.com, glider@google.com,
        dvyukov@google.com, dja@axtens.net, christophe.leroy@csgroup.eu,
        andreyknvl@gmail.com, elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-powerpc-dont-rename-memintrinsics-if-compiler-adds-prefixes.patch removed from -mm tree
Message-Id: <20230323013217.A4418C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan, powerpc: don't rename memintrinsics if compiler adds prefixes
has been removed from the -mm tree.  Its filename was
     kasan-powerpc-dont-rename-memintrinsics-if-compiler-adds-prefixes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Link: https://lore.kernel.org/oe-kbuild-all/202302271348.U5lvmo0S-lkp@intel.com/
Link: https://lkml.kernel.org/r/20230227094726.3833247-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>	[powerpc]
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/powerpc/include/asm/kasan.h~kasan-powerpc-dont-rename-memintrinsics-if-compiler-adds-prefixes
+++ a/arch/powerpc/include/asm/kasan.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_KASAN_H
 #define __ASM_KASAN_H
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) && !defined(CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX)
 #define _GLOBAL_KASAN(fn)	_GLOBAL(__##fn)
 #define _GLOBAL_TOC_KASAN(fn)	_GLOBAL_TOC(__##fn)
 #define EXPORT_SYMBOL_KASAN(fn)	EXPORT_SYMBOL(__##fn)
--- a/arch/powerpc/include/asm/string.h~kasan-powerpc-dont-rename-memintrinsics-if-compiler-adds-prefixes
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
--- a/arch/powerpc/kernel/prom_init_check.sh~kasan-powerpc-dont-rename-memintrinsics-if-compiler-adds-prefixes
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


