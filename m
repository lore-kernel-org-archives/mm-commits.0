From: akpm@linux-foundation.org
Subject: + ubsan-add-trap-instrumentation-option.patch added to
 -mm tree
Date: Thu, 27 Feb 2020 15:30:29 -0800
Message-ID: <20200227233029.XgDWmdInY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbgB0Xab (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 27 Feb 2020 18:30:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, ard.biesheuvel@linaro.org, arnd@arndb.de, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, dvyukov@google.com, glider@google.com, gustavo@embeddedor.com, keescook@chromium.org, lenaptr@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: add trap instrumentation option
has been added to the -mm tree.  Its filename is
     ubsan-add-trap-instrumentation-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-add-trap-instrumentation-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-add-trap-instrumentation-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: add trap instrumentation option

Patch series "ubsan: Split out bounds checker", v5.

This splits out the bounds checker so it can be individually used.  This
is enabled in Android and hopefully for syzbot.  Includes LKDTM tests for
behavioral corner-cases (beyond just the bounds checker), and adjusts
ubsan and kasan slightly for correct panic handling.


This patch (of 6):

The Undefined Behavior Sanitizer can operate in two modes: warning
reporting mode via lib/ubsan.c handler calls, or trap mode, which uses
__builtin_trap() as the handler.  Using lib/ubsan.c means the kernel image
is about 5% larger (due to all the debugging text and reporting structures
to capture details about the warning conditions).  Using the trap mode,
the image size changes are much smaller, though at the loss of the
"warning only" mode.

In order to give greater flexibility to system builders that want minimal
changes to image size and are prepared to deal with kernel code being
aborted and potentially destabilizing the system, this introduces
CONFIG_UBSAN_TRAP.  The resulting image sizes comparison:

   text    data     bss       dec       hex     filename
19533663   6183037  18554956  44271656  2a38828 vmlinux.stock
19991849   7618513  18874448  46484810  2c54d4a vmlinux.ubsan
19712181   6284181  18366540  44362902  2a4ec96 vmlinux.ubsan-trap

CONFIG_UBSAN=y:      image +4.8% (text +2.3%, data +18.9%)
CONFIG_UBSAN_TRAP=y: image +0.2% (text +0.9%, data +1.6%)

Additionally adjusts the CONFIG_UBSAN Kconfig help for clarity and removes
the mention of non-existing boot param "ubsan_handle".

Link: http://lkml.kernel.org/r/20200227193516.32566-2-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Elena Petrova <lenaptr@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |   22 ++++++++++++++++++----
 lib/Makefile           |    2 ++
 scripts/Makefile.ubsan |    9 +++++++--
 3 files changed, 27 insertions(+), 6 deletions(-)

--- a/lib/Kconfig.ubsan~ubsan-add-trap-instrumentation-option
+++ a/lib/Kconfig.ubsan
@@ -5,11 +5,25 @@ config ARCH_HAS_UBSAN_SANITIZE_ALL
 config UBSAN
 	bool "Undefined behaviour sanity checker"
 	help
-	  This option enables undefined behaviour sanity checker
+	  This option enables the Undefined Behaviour sanity checker.
 	  Compile-time instrumentation is used to detect various undefined
-	  behaviours in runtime. Various types of checks may be enabled
-	  via boot parameter ubsan_handle
-	  (see: Documentation/dev-tools/ubsan.rst).
+	  behaviours at runtime. For more details, see:
+	  Documentation/dev-tools/ubsan.rst
+
+config UBSAN_TRAP
+	bool "On Sanitizer warnings, abort the running kernel code"
+	depends on UBSAN
+	depends on $(cc-option, -fsanitize-undefined-trap-on-error)
+	help
+	  Building kernels with Sanitizer features enabled tends to grow
+	  the kernel size by around 5%, due to adding all the debugging
+	  text on failure paths. To avoid this, Sanitizer instrumentation
+	  can just issue a trap. This reduces the kernel size overhead but
+	  turns all warnings (including potentially harmless conditions)
+	  into full exceptions that abort the running kernel code
+	  (regardless of context, locks held, etc), which may destabilize
+	  the system. For some system builders this is an acceptable
+	  trade-off.
 
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
--- a/lib/Makefile~ubsan-add-trap-instrumentation-option
+++ a/lib/Makefile
@@ -285,7 +285,9 @@ quiet_cmd_build_OID_registry = GEN     $
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+ifneq ($(CONFIG_UBSAN_TRAP),y)
 obj-$(CONFIG_UBSAN) += ubsan.o
+endif
 
 UBSAN_SANITIZE_ubsan.o := n
 KASAN_SANITIZE_ubsan.o := n
--- a/scripts/Makefile.ubsan~ubsan-add-trap-instrumentation-option
+++ a/scripts/Makefile.ubsan
@@ -1,5 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 ifdef CONFIG_UBSAN
+
+ifdef CONFIG_UBSAN_ALIGNMENT
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=alignment)
+endif
+
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=shift)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=integer-divide-by-zero)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=unreachable)
@@ -9,8 +14,8 @@ ifdef CONFIG_UBSAN
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=bool)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=enum)
 
-ifdef CONFIG_UBSAN_ALIGNMENT
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=alignment)
+ifdef CONFIG_UBSAN_TRAP
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize-undefined-trap-on-error)
 endif
 
       # -fsanitize=* options makes GCC less smart than usual and
_

Patches currently in -mm which might be from keescook@chromium.org are

shmem-distribute-switch-variables-for-initialization.patch
lib-test_stackinitc-xfail-switch-variable-init-tests.patch
ubsan-add-trap-instrumentation-option.patch
ubsan-split-bounds-checker-from-other-options.patch
lkdtm-bugs-add-arithmetic-overflow-and-array-bounds-checks.patch
ubsan-check-panic_on_warn.patch
kasan-unset-panic_on_warn-before-calling-panic.patch
ubsan-include-bug-type-in-report-header.patch
