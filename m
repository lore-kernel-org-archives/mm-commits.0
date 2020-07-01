From: akpm@linux-foundation.org
Subject: + kasan-improve-and-simplify-kconfigkasan.patch added to
 -mm tree
Date: Tue, 30 Jun 2020 18:44:26 -0700
Message-ID: <20200701014426.hqEar%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgGABo2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 21:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com, ndesaulniers@google.com, dvyukov@google.com, dja@axtens.net, aryabinin@virtuozzo.com, arnd@arndb.de, andreyknvl@google.com, elver@google.com


The patch titled
     Subject: kasan: improve and simplify Kconfig.kasan
has been added to the -mm tree.  Its filename is
     kasan-improve-and-simplify-kconfigkasan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-improve-and-simplify-kconfigkasan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-improve-and-simplify-kconfigkasan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: improve and simplify Kconfig.kasan

Turn 'KASAN' into a menuconfig, to avoid cluttering its parent menu with
the suboptions if enabled.  Use 'if KASAN ...  endif' instead of having to
'depend on KASAN' for each entry.

Link: http://lkml.kernel.org/r/20200629104157.3242503-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/lib/Kconfig.kasan~kasan-improve-and-simplify-kconfigkasan
+++ a/lib/Kconfig.kasan
@@ -18,7 +18,7 @@ config CC_HAS_KASAN_SW_TAGS
 config CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	def_bool !CC_IS_GCC || GCC_VERSION >= 80300
 
-config KASAN
+menuconfig KASAN
 	bool "KASAN: runtime memory debugger"
 	depends on (HAVE_ARCH_KASAN && CC_HAS_KASAN_GENERIC) || \
 		   (HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS)
@@ -29,9 +29,10 @@ config KASAN
 	  designed to find out-of-bounds accesses and use-after-free bugs.
 	  See Documentation/dev-tools/kasan.rst for details.
 
+if KASAN
+
 choice
 	prompt "KASAN mode"
-	depends on KASAN
 	default KASAN_GENERIC
 	help
 	  KASAN has two modes: generic KASAN (similar to userspace ASan,
@@ -88,7 +89,6 @@ endchoice
 
 choice
 	prompt "Instrumentation type"
-	depends on KASAN
 	default KASAN_OUTLINE
 
 config KASAN_OUTLINE
@@ -113,7 +113,6 @@ endchoice
 
 config KASAN_STACK_ENABLE
 	bool "Enable stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
-	depends on KASAN
 	help
 	  The LLVM stack address sanitizer has a know problem that
 	  causes excessive stack usage in a lot of functions, see
@@ -134,7 +133,7 @@ config KASAN_STACK
 
 config KASAN_S390_4_LEVEL_PAGING
 	bool "KASan: use 4-level paging"
-	depends on KASAN && S390
+	depends on S390
 	help
 	  Compiling the kernel with KASan disables automatic 3-level vs
 	  4-level paging selection. 3-level paging is used by default (up
@@ -151,7 +150,7 @@ config KASAN_SW_TAGS_IDENTIFY
 
 config KASAN_VMALLOC
 	bool "Back mappings in vmalloc space with real shadow memory"
-	depends on KASAN && HAVE_ARCH_KASAN_VMALLOC
+	depends on HAVE_ARCH_KASAN_VMALLOC
 	help
 	  By default, the shadow region for vmalloc space is the read-only
 	  zero page. This means that KASAN cannot detect errors involving
@@ -164,8 +163,10 @@ config KASAN_VMALLOC
 
 config TEST_KASAN
 	tristate "Module for testing KASAN for bug detection"
-	depends on m && KASAN
+	depends on m
 	help
 	  This is a test module doing various nasty things like
 	  out of bounds accesses, use after free. It is useful for testing
 	  kernel debugging features like KASAN.
+
+endif # KASAN
_

Patches currently in -mm which might be from elver@google.com are

mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access.patch
kasan-improve-and-simplify-kconfigkasan.patch
kasan-update-required-compiler-versions-in-documentation.patch
kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch
