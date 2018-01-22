From: akpm@linux-foundation.org
Subject: + kasan-dont-emit-builtin-calls-when-sanitization-is-off.patch
 added to -mm tree
Date: Mon, 22 Jan 2018 13:03:53 -0800
Message-ID: <5a6651b9.ecF5tj7IGaYtGan8%akpm__20904.4050229297$1516654931$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53662 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbeAVVDy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Jan 2018 16:03:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, michal.lkml@markovi.net, ndesaulniers@google.com, stable@vger.kernel.org, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: don't emit builtin calls when sanitization is off
has been added to the -mm tree.  Its filename is
     kasan-dont-emit-builtin-calls-when-sanitization-is-off.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-dont-emit-builtin-calls-when-sanitization-is-off.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-dont-emit-builtin-calls-when-sanitization-is-off.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -432,7 +432,8 @@ export MAKE AWK GENKSYMS INSTALLKERNEL P
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

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-dont-emit-builtin-calls-when-sanitization-is-off.patch
kasan-fix-prototype-author-email-address.patch
kasan-clean-up-kasan_shadow_scale_shift-usage.patch

