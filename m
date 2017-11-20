From: akpm@linux-foundation.org
Subject: [merged]
 makefile-support-flag-fsanitizer-coverage=trace-cmp.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:26:30 -0800
Message-ID: <20171120212630.CkbODzd-6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752973AbdKTV0c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:26:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.popov@linux.com, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, keescook@chromium.org, mark.rutland@arm.com, mm-commits@vger.kernel.org, quentin.casasnovas@oracle.com, syzkaller@googlegroups.com, tchibo@google.com, vegard.nossum@oracle.com


The patch titled
     Subject: Makefile: support flag -fsanitizer-coverage=trace-cmp
has been removed from the -mm tree.  Its filename was
     makefile-support-flag-fsanitizer-coverage=trace-cmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Victor Chibotaru <tchibo@google.com>
Subject: Makefile: support flag -fsanitizer-coverage=trace-cmp

The flag enables Clang instrumentation of comparison operations (currently
not supported by GCC).  This instrumentation is needed by the new KCOV
device to collect comparison operands.

Link: http://lkml.kernel.org/r/20171011095459.70721-2-glider@google.com
Signed-off-by: Victor Chibotaru <tchibo@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile              |    3 +--
 lib/Kconfig.debug     |   10 ++++++++++
 scripts/Makefile.kcov |    7 +++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~makefile-support-flag-fsanitizer-coverage=trace-cmp lib/Kconfig.debug
--- a/lib/Kconfig.debug~makefile-support-flag-fsanitizer-coverage=trace-cmp
+++ a/lib/Kconfig.debug
@@ -756,6 +756,16 @@ config KCOV
 
 	  For more details, see Documentation/dev-tools/kcov.rst.
 
+config KCOV_ENABLE_COMPARISONS
+	bool "Enable comparison operands collection by KCOV"
+	depends on KCOV
+	default n
+	help
+	  KCOV also exposes operands of every comparison in the instrumented
+	  code along with operand sizes and PCs of the comparison instructions.
+	  These operands can be used by fuzzing engines to improve the quality
+	  of fuzzing coverage.
+
 config KCOV_INSTRUMENT_ALL
 	bool "Instrument all code by default"
 	depends on KCOV
diff -puN Makefile~makefile-support-flag-fsanitizer-coverage=trace-cmp Makefile
--- a/Makefile~makefile-support-flag-fsanitizer-coverage=trace-cmp
+++ a/Makefile
@@ -375,8 +375,6 @@ CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 LDFLAGS_vmlinux =
 CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage -fno-tree-loop-im $(call cc-disable-warning,maybe-uninitialized,)
-CFLAGS_KCOV	:= $(call cc-option,-fsanitize-coverage=trace-pc,)
-
 
 # Use USERINCLUDE when you must reference the UAPI directories only.
 USERINCLUDE    := \
@@ -659,6 +657,7 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)
 	KBUILD_AFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
+include scripts/Makefile.kcov
 include scripts/Makefile.gcc-plugins
 
 ifdef CONFIG_READABLE_ASM
diff -puN /dev/null scripts/Makefile.kcov
--- /dev/null
+++ a/scripts/Makefile.kcov
@@ -0,0 +1,7 @@
+ifdef CONFIG_KCOV
+CFLAGS_KCOV	:= $(call cc-option,-fsanitize-coverage=trace-pc,)
+ifeq ($(CONFIG_KCOV_ENABLE_COMPARISONS),y)
+CFLAGS_KCOV += $(call cc-option,-fsanitize-coverage=trace-cmp,)
+endif
+
+endif
_

Patches currently in -mm which might be from tchibo@google.com are


