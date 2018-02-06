From: akpm@linux-foundation.org
Subject: [patch 001/114] kasan: don't emit builtin calls when
 sanitization is off
Date: Tue, 06 Feb 2018 15:36:00 -0800
Message-ID: <20180206233600.95GEtlu9C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753862AbeBFXgC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:36:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, michal.lkml@markovi.net, mm-commits@vger.kernel.org, ndesaulniers@google.com, stable@vger.kernel.org, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: don't emit builtin calls when sanitization is off

With KASAN enabled the kernel has two different memset() functions, one
with KASAN checks (memset) and one without (__memset).  KASAN uses some
macro tricks to use the proper version where required.  For example
memset() calls in mm/slub.c are without KASAN checks, since they operate
on poisoned slab object metadata.

The issue is that clang emits memset() calls even when there is no
memset() in the source code.  They get linked with improper memset()
implementation and the kernel fails to boot due to a huge amount of KASAN
reports during early boot stages.

The solution is to add -fno-builtin flag for files with KASAN_SANITIZE :=
n marker.

Link: http://lkml.kernel.org/r/8ffecfffe04088c52c42b92739c2bd8a0bcb3f5e.1516384594.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile               |    3 ++-
 scripts/Makefile.kasan |    3 +++
 scripts/Makefile.lib   |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN Makefile~kasan-dont-emit-builtin-calls-when-sanitization-is-off Makefile
--- a/Makefile~kasan-dont-emit-builtin-calls-when-sanitization-is-off
+++ a/Makefile
@@ -434,7 +434,8 @@ export MAKE LEX YACC AWK GENKSYMS INSTAL
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
-export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_KASAN CFLAGS_UBSAN
+export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
+export CFLAGS_KASAN CFLAGS_KASAN_NOSANITIZE CFLAGS_UBSAN
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
diff -puN scripts/Makefile.kasan~kasan-dont-emit-builtin-calls-when-sanitization-is-off scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-dont-emit-builtin-calls-when-sanitization-is-off
+++ a/scripts/Makefile.kasan
@@ -31,4 +31,7 @@ else
 endif
 
 CFLAGS_KASAN += $(call cc-option, -fsanitize-address-use-after-scope)
+
+CFLAGS_KASAN_NOSANITIZE := -fno-builtin
+
 endif
diff -puN scripts/Makefile.lib~kasan-dont-emit-builtin-calls-when-sanitization-is-off scripts/Makefile.lib
--- a/scripts/Makefile.lib~kasan-dont-emit-builtin-calls-when-sanitization-is-off
+++ a/scripts/Makefile.lib
@@ -121,7 +121,7 @@ endif
 ifeq ($(CONFIG_KASAN),y)
 _c_flags += $(if $(patsubst n%,, \
 		$(KASAN_SANITIZE_$(basetarget).o)$(KASAN_SANITIZE)y), \
-		$(CFLAGS_KASAN))
+		$(CFLAGS_KASAN), $(CFLAGS_KASAN_NOSANITIZE))
 endif
 
 ifeq ($(CONFIG_UBSAN),y)
_
